import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/service_providers.dart';

class PetInvite {
  PetInvite(this.id, this.data);
  final String id;
  final Map<String, dynamic> data;
  String get petId => data['petId'] as String;
  String get petName => (data['petName'] as String?) ?? '';
  String get role => (data['role'] as String?) ?? 'viewer';
  String? get contact => data['contact'] as String?;
  String get invitedByName => (data['invitedByName'] as String?) ?? '';
  String get token => data['token'] as String;
  DateTime? get expiresAt => parseDate(data['expiresAt']);
}

class ActivityItem {
  ActivityItem(this.id, this.data);
  final String id;
  final Map<String, dynamic> data;
  String get petId => data['petId'] as String;
  String get actorName => (data['actorName'] as String?) ?? '';
  String get type => (data['type'] as String?) ?? '';
  String? get detail => data['detail'] as String?;
  DateTime get createdAt => parseDate(data['createdAt']) ?? DateTime.now();
}

/// Family sharing (spec 6 and 7.2): invites by phone, email or link, roles,
/// expiring sitter access and the "who did what" feed.
class FamilyRepository {
  FamilyRepository(this._db, this._messaging);
  final FirebaseFirestore _db;
  final MessagingService _messaging;

  static String contactKey(String contact) {
    final c = contact.trim().toLowerCase();
    if (c.contains('@')) return c;
    return normalizePhone(c).replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _token() {
    const chars = 'abcdefghjkmnpqrstuvwxyz23456789';
    final r = Random.secure();
    return List.generate(10, (_) => chars[r.nextInt(chars.length)]).join();
  }

  /// Creates an invite. With [contact] the invite reaches that person's
  /// account (and an SMS/email goes to the Demo Outbox); without it, a link.
  Future<PetInvite> invite({
    required String petId,
    required String petName,
    required AppUser from,
    required String role,
    String? contact,
    DateTime? expiresAt,
  }) async {
    final token = _token();
    final data = {
      'petId': petId,
      'petName': petName,
      'invitedBy': from.uid,
      'invitedByName': from.name,
      'contact': contact == null ? null : contactKey(contact),
      'role': role,
      'expiresAt': expiresAt,
      'token': token,
      'status': 'pending',
      'createdAt': DateTime.now(),
    };
    final ref = await _db.collection('petInvites').add(data);
    if (contact != null) {
      final isEmail = contact.contains('@');
      await _messaging.send(
        channel: isEmail ? Channel.email : Channel.sms,
        to: contactKey(contact),
        subject: isEmail ? '${from.name} invited you to PawSetu' : null,
        body: '${from.name} invited you to help care for $petName on PawSetu. Open: https://pawsetu.app/#/join/$token',
        uid: from.uid,
        type: 'family_invite',
      );
    }
    return PetInvite(ref.id, data);
  }

  Stream<List<PetInvite>> watchSentInvites(String petId) => _db
      .collection('petInvites')
      .where('petId', isEqualTo: petId)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) => [for (final d in s.docs) PetInvite(d.id, d.data())]);

  /// Invites waiting for this user, matched by email or phone.
  Stream<List<PetInvite>> watchMyInvites(AppUser user) {
    final keys = [
      if (user.email != null) contactKey(user.email!),
      if (user.phone != null) contactKey(user.phone!),
    ];
    if (keys.isEmpty) return Stream.value(const []);
    return _db
        .collection('petInvites')
        .where('contact', whereIn: keys)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => [for (final d in s.docs) PetInvite(d.id, d.data())]);
  }

  Future<PetInvite?> findByToken(String token) async {
    final q = await _db.collection('petInvites').where('token', isEqualTo: token).limit(1).get();
    if (q.docs.isEmpty) return null;
    return PetInvite(q.docs.first.id, q.docs.first.data());
  }

  Future<void> accept(PetInvite invite, AppUser user) async {
    final pet = _db.collection('pets').doc(invite.petId);
    await pet.update({
      'memberIds': FieldValue.arrayUnion([user.uid]),
      'members.${user.uid}': {'role': invite.role, 'name': user.name, 'expiresAt': invite.expiresAt},
    });
    await _db.collection('petInvites').doc(invite.id).update({'status': 'accepted', 'acceptedBy': user.uid});
    await _activity(invite.petId, user, 'member_joined', invite.role);
  }

  Future<void> decline(PetInvite invite) =>
      _db.collection('petInvites').doc(invite.id).update({'status': 'declined'});

  Future<void> cancelInvite(String inviteId) => _db.collection('petInvites').doc(inviteId).delete();

  Future<void> changeRole(String petId, String uid, String role, DateTime? expiresAt, AppUser by) async {
    await _db.collection('pets').doc(petId).update({
      'members.$uid.role': role,
      'members.$uid.expiresAt': expiresAt,
    });
    await _activity(petId, by, 'role_changed', role);
  }

  Future<void> removeMember(String petId, String uid, String name, AppUser by) async {
    await _db.collection('pets').doc(petId).update({
      'memberIds': FieldValue.arrayRemove([uid]),
      'members.$uid': FieldValue.delete(),
    });
    await _activity(petId, by, 'member_removed', name);
  }

  Future<void> _activity(String petId, AppUser by, String type, String? detail) => _db.collection('activity').add({
        'petId': petId,
        'actorId': by.uid,
        'actorName': by.name,
        'type': type,
        'detail': detail,
        'createdAt': DateTime.now(),
      });

  /// Recent activity for a set of pets, newest first.
  Stream<List<ActivityItem>> watchActivity(List<String> petIds, {int limit = 40}) {
    if (petIds.isEmpty) return Stream.value(const []);
    return _db
        .collection('activity')
        .where('petId', whereIn: petIds.take(10).toList())
        .snapshots()
        .map((s) {
      final items = [for (final d in s.docs) ActivityItem(d.id, d.data())]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items.take(limit).toList();
    });
  }
}

final familyRepositoryProvider = Provider<FamilyRepository>(
    (ref) => FamilyRepository(ref.watch(firestoreProvider), ref.watch(messagingServiceProvider)));

final myInvitesProvider = StreamProvider<List<PetInvite>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(familyRepositoryProvider).watchMyInvites(user);
});

final sentInvitesProvider = StreamProvider.family<List<PetInvite>, String>(
    (ref, petId) => ref.watch(familyRepositoryProvider).watchSentInvites(petId));
