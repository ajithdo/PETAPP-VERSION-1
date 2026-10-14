import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/converters.dart';
import '../../../core/providers.dart';
import '../../album/domain/album.dart';
import '../domain/share_rules.dart';
import '../domain/vault_models.dart';
import 'vault_repository.dart';

/// What a person with a share link may see.
class ShareView {
  const ShareView({
    required this.status,
    this.kind = 'docs',
    this.petName = '',
    this.species = 'dog',
    this.ownerName = '',
    this.expiresAt,
    this.docs = const [],
    this.items = const [],
  });
  final ShareStatus status;
  final String kind;
  final String petName;
  final String species;
  final String ownerName;
  final DateTime? expiresAt;
  final List<VaultDoc> docs;
  final List<AlbumItem> items;
}

/// Opens share links for people who are not signed in.
/// Standalone demo: checked on this device against the demo database.
/// Emulator / live: the openShareLink Cloud Function checks expiry, PIN and
/// revocation, writes the access log and returns short-lived file URLs, so
/// security rules never expose the vault to the public.
abstract class ShareLinkService {
  Future<ShareView> open(String token, {String? pin});
}

class LocalShareLinkService implements ShareLinkService {
  LocalShareLinkService(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;
  final FirebaseFirestore _db;
  final DateTime Function() _clock;

  @override
  Future<ShareView> open(String token, {String? pin}) async {
    final now = _clock();
    final ref = _db.collection('shareLinks').doc(token);
    final snap = await ref.get();
    final link = snap.exists ? ShareLink(snap.id, snap.data()!) : null;
    final status = checkShare(link, pin: pin, now: now);
    if (link == null) return ShareView(status: status);
    if (status == ShareStatus.wrongPin || status == ShareStatus.ok) {
      await ref.update({
        'accessLog': FieldValue.arrayUnion([
          {'at': now, 'device': accessDeviceLabel(), 'ok': status == ShareStatus.ok},
        ]),
      });
    }
    if (status != ShareStatus.ok) {
      return ShareView(status: status, kind: link.kind, petName: link.petName, ownerName: link.ownerName, expiresAt: link.expiresAt);
    }
    final pet = (await _db.collection('pets').doc(link.petId).get()).data();
    final docs = <VaultDoc>[];
    final items = <AlbumItem>[];
    if (link.kind == 'album') {
      final s = await _db.collection('album').where('petId', isEqualTo: link.petId).get();
      for (final d in s.docs) {
        final i = AlbumItem(d.id, d.data());
        if (!i.hasMedia) continue;
        if (link.albumName != null && !i.albums.contains(link.albumName)) continue;
        items.add(i);
      }
      items.sort((a, b) => b.takenAt.compareTo(a.takenAt));
    } else {
      for (final id in link.docIds) {
        final d = await _db.collection('documents').doc(id).get();
        if (d.exists) docs.add(VaultDoc(d.id, d.data()!));
      }
    }
    return ShareView(
      status: ShareStatus.ok,
      kind: link.kind,
      petName: link.petName,
      species: (pet?['species'] as String?) ?? 'dog',
      ownerName: link.ownerName,
      expiresAt: link.expiresAt,
      docs: docs,
      items: items,
    );
  }
}

class FunctionsShareLinkService implements ShareLinkService {
  FunctionsShareLinkService(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<ShareView> open(String token, {String? pin}) async {
    final res = await _functions.httpsCallable('openShareLink').call<Map<String, dynamic>>({'token': token, 'pin': pin});
    final d = Map<String, dynamic>.from(res.data);
    final status = ShareStatus.values.firstWhere((s) => s.name == d['status'], orElse: () => ShareStatus.notFound);
    List<Map<String, dynamic>> list(String k) => [for (final e in (d[k] as List?) ?? const []) Map<String, dynamic>.from(e as Map)];
    return ShareView(
      status: status,
      kind: (d['kind'] as String?) ?? 'docs',
      petName: (d['petName'] as String?) ?? '',
      species: (d['species'] as String?) ?? 'dog',
      ownerName: (d['ownerName'] as String?) ?? '',
      expiresAt: parseDate(d['expiresAt']),
      docs: [for (final m in list('docs')) VaultDoc(m['id'] as String, m)],
      items: [for (final m in list('items')) AlbumItem(m['id'] as String, m)],
    );
  }
}

final shareLinkServiceProvider = Provider<ShareLinkService>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.isStandalone) return LocalShareLinkService(ref.watch(firestoreProvider));
  return FunctionsShareLinkService(FirebaseFunctions.instanceFor(region: 'asia-south1'));
});
