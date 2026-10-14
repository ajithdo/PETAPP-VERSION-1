import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/data/converters.dart';
import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../messaging/data/chat_models.dart';
import '../../messaging/data/chat_repository.dart';
import '../../messaging/domain/chat_rules.dart';
import '../../pets/domain/pet.dart';
import '../domain/televet_rules.dart';
import 'consultation.dart';

/// What the owner chose in the tele-vet start flow.
class StartConsultRequest {
  const StartConsultRequest({
    required this.owner,
    required this.pet,
    required this.problem,
    required this.mode,
    this.photos = const [],
    this.vetId,
    this.scheduledAt,
    this.redFlag,
    this.medicines = const [],
  });
  final AppUser owner;
  final Pet pet;
  final String problem;
  final String mode;
  final List<String> photos;
  final String? vetId;
  final DateTime? scheduledAt;
  final String? redFlag;
  final List<Map<String, dynamic>> medicines;
}

/// Thrown when a consultation cannot start (monthly limit, video on free).
class TeleVetStartException implements Exception {
  const TeleVetStartException(this.block);
  final StartBlock block;
}

/// Starting, messaging, accepting and ending consultations. Limits are
/// enforced here: by Dart rules in the standalone demo and by Cloud
/// Functions (functions/src/phase6.ts) when Firebase runs.
abstract class TeleVetBackend {
  Future<String> start(StartConsultRequest r);

  /// Sends a message in a consultation. Returns the check result; when it
  /// is not ok nothing was sent and the UI explains why, gently.
  Future<TeleVetCheck> send(
    Consultation c,
    AppUser me, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
    String? event,
    Map<String, dynamic>? meta,
    String? prescriptionId,
  });
  Future<void> accept(Consultation c, AppUser vet);
  Future<void> end(Consultation c, AppUser by);
}

/// Pet details a vet needs (vets cannot read the pet document).
Map<String, dynamic> petSnapshot(Pet pet, {required bool full, List<Map<String, dynamic>> medicines = const []}) => {
      'breedId': pet.breedId,
      'breedOther': pet.breedOther,
      'birthday': pet.birthday,
      'gender': pet.gender,
      'weightKg': pet.weightKg,
      'colorTag': pet.colorTag,
      'photoUrl': pet.photoUrl,
      'neutered': pet.neutered,
      'allergies': pet.allergies,
      if (full) ...{
        'dietType': pet.dietType,
        'temperament': pet.temperament,
        'markings': pet.markings,
        'medicines': medicines,
      },
    };

/// Standalone demo: runs the same rules on the device.
class LocalTeleVetBackend implements TeleVetBackend {
  LocalTeleVetBackend(this._db, this._chat, {required this.simulate, required this.uiLang});
  final FirebaseFirestore _db;
  final ChatRepository _chat;
  final bool simulate;
  final String Function() uiLang;

  CollectionReference<Map<String, dynamic>> get _cons => _db.collection('consultations');

  Future<Map<String, dynamic>> _config() async => (await _db.collection('config').doc('app').get()).data() ?? const {};

  Future<AppLocalizations> _langOf(String uid) async {
    final u = await _db.collection('users').doc(uid).get();
    return lookupAppLocalizations(Locale((u.data()?['language'] as String?) ?? 'en'));
  }

  Future<void> _notify(String uid, String Function(AppLocalizations l) title, String link) async {
    if (isPlaceholderParticipant(uid)) return;
    final l = await _langOf(uid);
    await _db.collection('notifications').add({
      'uid': uid,
      'title': title(l),
      'body': '',
      'type': 'messages',
      'link': link,
      'read': false,
      'createdAt': DateTime.now(),
    });
  }

  /// The vet that "Chat now" connects to: a tele-vet vet with an app account
  /// (in the demo that is Dr. Sameer Khan).
  Future<DocumentSnapshot<Map<String, dynamic>>?> _nextVet() async {
    final s = await _db.collection('vets').where('teleVet', isEqualTo: true).get();
    final withAccount = s.docs.where((d) => d.data()['uid'] != null && d.data()['status'] == 'approved').toList();
    return withAccount.firstOrNull ?? s.docs.firstOrNull;
  }

  @override
  Future<String> start(StartConsultRequest r) async {
    final now = DateTime.now();
    final cfg = await _config();
    final plus = r.owner.isPlus;
    final limits = TeleVetLimits.fromPlan(((cfg['limits'] as Map?)?[plus ? 'plus' : 'free'] as Map?)?.cast<String, dynamic>(), plus: plus);
    final mine = await _cons.where('ownerId', isEqualTo: r.owner.uid).get();
    final used = consultationsThisMonth(mine.docs.map((d) => parseDate(d.data()['createdAt']) ?? now), now);
    final block = canStartConsultation(usedThisMonth: used, limits: limits, video: r.mode == 'video');
    if (block != StartBlock.none) throw TeleVetStartException(block);

    final vetSnap = r.vetId != null ? await _db.collection('vets').doc(r.vetId).get() : null;
    final vet = vetSnap?.data();
    final commission = (cfg['commission'] as Map?) ?? const {};
    final price = priceTeleVet(
      video: r.mode == 'video',
      videoFee: (vet?['videoFee'] as num?)?.toInt() ?? 399,
      plus: plus,
      discountPercent: (commission['videoDiscountPercent'] as num?) ?? 10,
      commissionPercent: (commission['bookingPercent'] as num?) ?? 10,
    );
    final ref = _cons.doc();
    final convId = teleVetConversationId(ref.id);
    final vetUid = vet?['uid'] as String?;
    await ref.set({
      'ownerId': r.owner.uid,
      'ownerName': r.owner.name,
      'petId': r.pet.id,
      'petName': r.pet.name,
      'petSpecies': r.pet.species,
      'petSnapshot': petSnapshot(r.pet, full: plus, medicines: r.medicines),
      'vetId': r.vetId,
      'vetUid': vetUid,
      'vetName': vet?['name'],
      'clinicId': vet?['clinicId'],
      'clinicName': vet?['clinicName'],
      'status': 'queued',
      'mode': r.mode,
      'problem': r.problem,
      'photos': r.photos,
      'plan': r.owner.plan,
      'priority': plus,
      'limits': limits.toMap(),
      'messagesUsed': 0,
      'createdAt': now,
      'scheduledAt': r.scheduledAt,
      'startedAt': null,
      'endsAt': null,
      'consentAt': now,
      'fee': price.fee,
      'discount': price.discount,
      'total': price.total,
      'commission': price.commission,
      'payout': price.payout,
      'paymentStatus': price.total > 0 ? 'paid' : 'included',
      'conversationId': convId,
      'redFlag': r.redFlag,
      'privateNotes': '',
    });
    await _db.collection('conversations').doc(convId).set({
      'type': 'televet',
      'participantIds': [r.owner.uid, ?vetUid],
      'participants': {
        r.owner.uid: {'name': r.owner.name, 'role': 'owner'},
        ?vetUid: {'name': vet?['name'], 'role': 'vet'},
      },
      'ownerId': r.owner.uid,
      'ownerName': r.owner.name,
      'providerName': vet?['name'] ?? '',
      'providerId': r.vetId,
      'providerKind': 'vet',
      'petId': r.pet.id,
      'petName': r.pet.name,
      'petSpecies': r.pet.species,
      'consultationId': ref.id,
      'lastMessage': r.problem,
      'lastType': 'text',
      'lastSenderId': r.owner.uid,
      'lastAt': now,
      'createdAt': now,
      'unread': {?vetUid: 1},
      'muted': <String, bool>{},
      'blockedBy': <String>[],
      'typing': <String, Object?>{},
    });
    final msgs = _db.collection('messages');
    await msgs.add({
      'conversationId': convId,
      'senderId': 'system',
      'senderName': '',
      'type': 'system',
      'event': 'tv_started',
      'meta': {'mode': r.mode, 'scheduledAt': r.scheduledAt},
      'text': '',
      'createdAt': now,
      'readBy': [r.owner.uid],
    });
    await msgs.add({
      'conversationId': convId,
      'senderId': r.owner.uid,
      'senderName': r.owner.name,
      'type': 'text',
      'text': r.problem,
      'meta': {'problem': true},
      'createdAt': now.add(const Duration(milliseconds: 1)),
      'readBy': [r.owner.uid],
    });
    for (final (i, p) in r.photos.indexed) {
      await msgs.add({
        'conversationId': convId,
        'senderId': r.owner.uid,
        'senderName': r.owner.name,
        'type': 'photo',
        'url': p,
        'text': '',
        'meta': {'problem': true},
        'createdAt': now.add(Duration(milliseconds: 2 + i)),
        'readBy': [r.owner.uid],
      });
    }
    if (price.total > 0) {
      await _db.collection('expenses').doc('exp_${ref.id}').set({
        'ownerId': r.owner.uid,
        'petId': r.pet.id,
        'category': 'vet',
        'amount': price.total,
        'date': now,
        'note': '${vet?['name'] ?? ''} · tele-vet',
        'source': 'televet',
        'sourceId': ref.id,
      });
    }
    // Tell the chosen vet, or every tele-vet vet with an account.
    final vetUids = <String>{};
    if (vetUid != null) {
      vetUids.add(vetUid);
    } else {
      final all = await _db.collection('vets').where('teleVet', isEqualTo: true).get();
      vetUids.addAll(all.docs.map((d) => d.data()['uid'] as String?).whereType<String>());
    }
    for (final u in vetUids) {
      await _notify(u, (l) => l.ntfTeleVetRequest(r.pet.name, r.owner.name), '/partner/televet');
    }
    if (simulate && r.scheduledAt == null) _demoAutoAccept(ref.id, r.vetId);
    return ref.id;
  }

  /// Demo: a vet picks up "Chat now" and "Video now" requests within seconds.
  void _demoAutoAccept(String consultationId, String? vetId) {
    Future<void>.delayed(const Duration(seconds: 4), () async {
      try {
        final snap = await _cons.doc(consultationId).get();
        if (!snap.exists) return;
        final c = Consultation(snap.id, snap.data()!);
        if (!c.isQueued) return;
        final v = vetId != null ? await _db.collection('vets').doc(vetId).get() : await _nextVet();
        final vet = v?.data();
        if (v == null || vet == null) return;
        final uid = (vet['uid'] as String?) ?? 'p_${v.id}';
        await _acceptAs(c, uid: uid, vetId: v.id, vet: vet);
        final conv = await _chat.watchOne(c.conversationId).first;
        if (conv == null) return;
        final l = lookupAppLocalizations(Locale(uiLang()));
        await _chat.writeMessage(
          c: conv,
          senderId: uid,
          senderName: vet['name'] as String? ?? '',
          text: l.demoVetGreeting(c.ownerName.split(' ').first, c.petName),
          demo: true,
          notify: false,
        );
      } catch (e) {
        debugPrint('Demo auto-accept failed: $e');
      }
    });
  }

  Future<void> _acceptAs(Consultation c, {required String uid, required String vetId, required Map<String, dynamic> vet}) async {
    final now = DateTime.now();
    await _cons.doc(c.id).update({
      'status': 'active',
      'vetId': vetId,
      'vetUid': uid,
      'vetName': vet['name'],
      'clinicId': vet['clinicId'],
      'clinicName': vet['clinicName'],
      'startedAt': now,
      'endsAt': chatEndsAt(now, c.limits),
    });
    await _db.collection('conversations').doc(c.conversationId).update({
      'participantIds': FieldValue.arrayUnion([uid]),
      'participants.$uid': {'name': vet['name'], 'role': 'vet'},
      'providerName': vet['name'],
      'providerId': vetId,
    });
    final conv = await _chat.watchOne(c.conversationId).first;
    if (conv != null) {
      await _chat.writeMessage(
        c: conv,
        senderId: 'system',
        senderName: '',
        type: 'system',
        event: 'tv_joined',
        meta: {'name': vet['name'], 'endsAt': chatEndsAt(now, c.limits)},
        notify: false,
      );
    }
    await _notify(c.ownerId, (l) => l.ntfVetJoined(vet['name'] as String? ?? '', c.petName), '/messages/${c.conversationId}');
  }

  @override
  Future<void> accept(Consultation c, AppUser vet) async {
    final s = await _db.collection('vets').where('uid', isEqualTo: vet.uid).get();
    final doc = s.docs.firstOrNull;
    final data = doc?.data() ?? {'name': vet.name};
    await _acceptAs(c, uid: vet.uid, vetId: doc?.id ?? vet.partnerId ?? vet.uid, vet: data);
  }

  @override
  Future<TeleVetCheck> send(
    Consultation c,
    AppUser me, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
    String? event,
    Map<String, dynamic>? meta,
    String? prescriptionId,
  }) async {
    final snap = await _cons.doc(c.id).get();
    final fresh = Consultation(snap.id, snap.data() ?? c.raw);
    final fromOwner = me.uid == fresh.ownerId;
    final counted = fromOwner && type != 'system' && type != 'call';
    final check = checkTeleVetMessage(
      text: text,
      fromOwner: counted,
      limits: fresh.limits,
      messagesUsed: fresh.messagesUsed,
      status: fresh.status,
      endsAt: fresh.endsAt,
      now: DateTime.now(),
      attachment: type != 'text',
    );
    if (!check.ok) return check;
    final conv = await _chat.watchOne(fresh.conversationId).first;
    if (conv == null) return const TeleVetCheck(TeleVetBlock.ended);
    await _chat.writeMessage(
      c: conv,
      senderId: type == 'system' ? 'system' : me.uid,
      senderName: type == 'system' ? '' : me.name,
      type: type,
      text: text,
      url: url,
      fileName: fileName,
      sizeBytes: sizeBytes,
      durationSec: durationSec,
      event: event,
      meta: meta,
      prescriptionId: prescriptionId,
    );
    if (counted) await _cons.doc(c.id).update({'messagesUsed': FieldValue.increment(1)});
    if (simulate && (type == 'text' || type == 'photo' || type == 'voice') && fresh.isActive) {
      final l = lookupAppLocalizations(Locale(uiLang()));
      _chat.simulateReply(
        conv,
        me,
        text: fromOwner ? l.demoReplyVet(fresh.petName) : l.demoReplyOwnerVet(me.name.split(' ').last),
      );
    }
    return check;
  }

  @override
  Future<void> end(Consultation c, AppUser by) async {
    final now = DateTime.now();
    await _cons.doc(c.id).update({'status': 'ended', 'endedAt': now, 'endedBy': by.uid});
    final conv = await _chat.watchOne(c.conversationId).first;
    if (conv != null) {
      await _chat.writeMessage(c: conv, senderId: 'system', senderName: '', type: 'system', event: 'tv_ended', meta: {'by': by.name}, notify: false);
    }
    if (by.uid != c.ownerId) {
      await _notify(c.ownerId, (l) => l.ntfConsultEnded(c.petName), '/messages/${c.conversationId}');
    }
  }
}

/// Firebase (emulator or live): the callable Cloud Functions in
/// functions/src/phase6.ts check plans, limits and prices on the server.
class FunctionsTeleVetBackend implements TeleVetBackend {
  FunctionsTeleVetBackend(this._fns);
  final FirebaseFunctions _fns;

  @override
  Future<String> start(StartConsultRequest r) async {
    try {
      final res = await _fns.httpsCallable('startConsultation').call<Map<String, dynamic>>({
        'petId': r.pet.id,
        'problem': r.problem,
        'mode': r.mode,
        'photos': r.photos,
        'vetId': r.vetId,
        'scheduledAt': r.scheduledAt?.toUtc().toIso8601String(),
        'redFlag': r.redFlag,
        'petSnapshot': petSnapshot(r.pet, full: r.owner.isPlus, medicines: r.medicines)..['birthday'] = r.pet.birthday?.toUtc().toIso8601String(),
      });
      return res.data['id'] as String;
    } on FirebaseFunctionsException catch (e) {
      final reason = (e.details as Map?)?['reason'];
      if (reason == 'monthly_limit') throw const TeleVetStartException(StartBlock.monthlyLimit);
      if (reason == 'video_needs_plus') throw const TeleVetStartException(StartBlock.videoNeedsPlus);
      rethrow;
    }
  }

  @override
  Future<TeleVetCheck> send(
    Consultation c,
    AppUser me, {
    String type = 'text',
    String text = '',
    String? url,
    String? fileName,
    int? sizeBytes,
    int? durationSec,
    String? event,
    Map<String, dynamic>? meta,
    String? prescriptionId,
  }) async {
    final res = await _fns.httpsCallable('sendTeleVetMessage').call<Map<String, dynamic>>({
      'consultationId': c.id,
      'type': type,
      'text': text,
      'url': url,
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'durationSec': durationSec,
      'event': event,
      'meta': meta,
      'prescriptionId': prescriptionId,
    });
    final d = res.data;
    final block = TeleVetBlock.values.firstWhere((b) => b.name == d['block'], orElse: () => TeleVetBlock.none);
    return TeleVetCheck(
      block,
      words: (d['words'] as num?)?.toInt() ?? 0,
      maxWords: (d['maxWords'] as num?)?.toInt() ?? 0,
      messagesLeft: (d['messagesLeft'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<void> accept(Consultation c, AppUser vet) => _fns.httpsCallable('acceptConsultation').call({'consultationId': c.id});

  @override
  Future<void> end(Consultation c, AppUser by) => _fns.httpsCallable('endConsultation').call({'consultationId': c.id});
}

final teleVetBackendProvider = Provider<TeleVetBackend>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.usesFirebase) return FunctionsTeleVetBackend(FirebaseFunctions.instanceFor(region: 'asia-south1'));
  return LocalTeleVetBackend(
    ref.watch(firestoreProvider),
    ref.watch(chatRepositoryProvider),
    simulate: cfg.isDemo,
    uiLang: () => ref.read(settingsProvider).locale,
  );
});

/// Reads and the direct writes the rules allow (vet notes, owner rating).
class TeleVetRepository {
  TeleVetRepository(this._db);
  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> get _cons => _db.collection('consultations');

  Stream<List<Consultation>> watchMine(String uid) => _cons
      .where('ownerId', isEqualTo: uid)
      .snapshots()
      .map((s) => [for (final d in s.docs) Consultation(d.id, d.data())]..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  Stream<Consultation?> watchOne(String id) => _cons.doc(id).snapshots().map((d) => d.exists ? Consultation(d.id, d.data()!) : null);

  /// Vet view: the shared queue (unassigned or assigned to me) plus my
  /// active and past consultations.
  Stream<List<Consultation>> watchForVet(String uid) {
    late StreamController<List<Consultation>> ctrl;
    var queued = <Consultation>[];
    var mine = <Consultation>[];
    final subs = <StreamSubscription<dynamic>>[];
    void emit() {
      final all = <String, Consultation>{for (final c in queued) c.id: c, for (final c in mine) c.id: c};
      ctrl.add(all.values.where((c) => !c.isQueued || c.vetUid == null || c.vetUid == uid).toList());
    }

    ctrl = StreamController<List<Consultation>>(
      onListen: () {
        subs.add(_cons.where('status', isEqualTo: 'queued').snapshots().listen((s) {
          queued = [for (final d in s.docs) Consultation(d.id, d.data())];
          emit();
        }, onError: ctrl.addError));
        subs.add(_cons.where('vetUid', isEqualTo: uid).snapshots().listen((s) {
          mine = [for (final d in s.docs) Consultation(d.id, d.data())];
          emit();
        }, onError: ctrl.addError));
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
      },
    );
    return ctrl.stream;
  }

  Future<void> saveNotes(String id, String notes) => _cons.doc(id).update({'privateNotes': notes, 'notesAt': DateTime.now()});

  Future<void> setRecommendation(String id, String kind) => _cons.doc(id).update({'recommendation': kind});

  /// Rating after a consultation (also shown as a verified vet review).
  Future<void> rate(Consultation c, AppUser owner, int stars, String text) async {
    await _cons.doc(c.id).update({'rating': stars, 'ratingText': text});
    if (c.vetId != null) {
      await _db.collection('reviews').add({
        'targetType': 'vet',
        'targetId': c.vetId,
        'ownerId': owner.uid,
        'ownerName': owner.name,
        'consultationId': c.id,
        'rating': stars,
        'text': text,
        'status': 'visible',
        'reply': null,
        'createdAt': DateTime.now(),
      });
    }
  }

  Stream<Prescription?> watchPrescription(String id) =>
      _db.collection('prescriptions').doc(id).snapshots().map((d) => d.exists ? Prescription(d.id, d.data()!) : null);

  /// Tele-vet vets the owner can choose (approved, tele-vet on).
  Future<List<Map<String, dynamic>>> teleVets() async {
    final s = await _db.collection('vets').where('teleVet', isEqualTo: true).get();
    final out = [
      for (final d in s.docs)
        if (d.data()['status'] == 'approved') {'id': d.id, ...d.data()},
    ];
    // Vets with an app account first (they answer in the demo), then rating.
    out.sort((a, b) {
      final ua = a['uid'] != null ? 0 : 1;
      final ub = b['uid'] != null ? 0 : 1;
      if (ua != ub) return ua - ub;
      return ((b['rating'] as num?) ?? 0).compareTo((a['rating'] as num?) ?? 0);
    });
    return out;
  }

  /// Pet history the vet panel shows (Plus: full history).
  Stream<List<Map<String, dynamic>>> watchPetEvents(String petId) => _db
      .collection('healthEvents')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) d.data()]..sort((a, b) => (parseDate(b['date']) ?? DateTime(0)).compareTo(parseDate(a['date']) ?? DateTime(0))));

  Stream<List<Map<String, dynamic>>> watchPetVaccines(String petId) => _db
      .collection('vaccinations')
      .where('petId', isEqualTo: petId)
      .snapshots()
      .map((s) => [for (final d in s.docs) d.data()]
        ..sort((a, b) => (parseDate(b['givenDate']) ?? DateTime(0)).compareTo(parseDate(a['givenDate']) ?? DateTime(0))));
}

final teleVetRepositoryProvider = Provider<TeleVetRepository>((ref) => TeleVetRepository(ref.watch(firestoreProvider)));

final myConsultationsProvider = StreamProvider<List<Consultation>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(teleVetRepositoryProvider).watchMine(u.uid);
});

final vetConsultationsProvider = StreamProvider<List<Consultation>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref.watch(teleVetRepositoryProvider).watchForVet(u.uid);
});

final consultationProvider = StreamProvider.family<Consultation?, String>((ref, id) => ref.watch(teleVetRepositoryProvider).watchOne(id));

final prescriptionProvider = StreamProvider.family<Prescription?, String>((ref, id) => ref.watch(teleVetRepositoryProvider).watchPrescription(id));

final teleVetsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) => ref.watch(teleVetRepositoryProvider).teleVets());

final petEventsForVetProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, petId) => ref.watch(teleVetRepositoryProvider).watchPetEvents(petId));

final petVaccinesForVetProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, petId) => ref.watch(teleVetRepositoryProvider).watchPetVaccines(petId));

/// The consultation behind a tele-vet conversation, if any.
Consultation? consultationOf(WidgetRef ref, Conversation c) =>
    c.consultationId == null ? null : ref.watch(consultationProvider(c.consultationId!)).value;
