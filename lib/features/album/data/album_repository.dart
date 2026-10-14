import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/services/storage_service.dart';
import '../../pets/domain/pet.dart';
import '../domain/album.dart';

class AlbumRepository {
  AlbumRepository(this._db, this._storage);
  final FirebaseFirestore _db;
  final StorageService _storage;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('album');

  Stream<List<AlbumItem>> watchPet(String petId) =>
      _col.where('petId', isEqualTo: petId).snapshots().map((s) => [for (final d in s.docs) AlbumItem(d.id, d.data())]..sort((a, b) => b.takenAt.compareTo(a.takenAt)));

  Future<String> add({
    required Pet pet,
    required AppUser by,
    required String type,
    String? url,
    String? contentType,
    String? storagePath,
    int sizeBytes = 0,
    int durationSec = 0,
    String caption = '',
    DateTime? takenAt,
    String? milestone,
    String? milestoneTitle,
    List<String> albums = const [],
  }) async {
    final ref = await _col.add({
      'petId': pet.id,
      'ownerId': pet.ownerId,
      'type': type,
      'url': url,
      'contentType': contentType,
      'storagePath': storagePath,
      'sizeBytes': sizeBytes,
      'durationSec': durationSec,
      'caption': caption.trim(),
      'takenAt': takenAt ?? DateTime.now(),
      'favourite': false,
      'albums': albums,
      'milestone': milestone,
      'milestoneTitle': milestoneTitle,
      'byUid': by.uid,
      'byName': by.name,
      'createdAt': DateTime.now(),
    });
    if (milestone != null) {
      await _db.collection('activity').add({
        'petId': pet.id,
        'actorId': by.uid,
        'actorName': by.name,
        'type': 'milestone',
        'detail': milestoneTitle ?? milestone,
        'createdAt': DateTime.now(),
      });
    }
    return ref.id;
  }

  Future<void> update(String id, Map<String, dynamic> fields) => _col.doc(id).update(fields);

  Future<void> toggleFavourite(AlbumItem i) => _col.doc(i.id).update({'favourite': !i.favourite});

  Future<void> delete(AlbumItem i) async {
    await _col.doc(i.id).delete();
    final url = i.url;
    if (url != null && (url.startsWith('mem://') || url.startsWith('http'))) await _storage.delete(url);
  }

  Future<void> addToAlbum(Iterable<AlbumItem> items, String name) async {
    for (final i in items) {
      if (!i.albums.contains(name)) await _col.doc(i.id).update({'albums': [...i.albums, name]});
    }
  }

  Future<void> removeFromAlbum(AlbumItem i, String name) => _col.doc(i.id).update({'albums': [for (final a in i.albums) if (a != name) a]});

  Future<void> renameAlbum(Iterable<AlbumItem> items, String from, String to) async {
    for (final i in items.where((i) => i.albums.contains(from))) {
      await _col.doc(i.id).update({'albums': [for (final a in i.albums) a == from ? to : a]});
    }
  }

  Future<void> deleteAlbum(Iterable<AlbumItem> items, String name) async {
    for (final i in items.where((i) => i.albums.contains(name))) {
      await removeFromAlbum(i, name);
    }
  }

  /// Yearly birthday reminder (spec 7.11) at 9 am on the next birthday.
  Future<void> setBirthdayReminder({required Pet pet, required String ownerId, required DateTime at, required String title, required bool on}) async {
    final old = await _db.collection('reminders').where('ownerId', isEqualTo: ownerId).get();
    for (final r in old.docs.where((d) => d.data()['petId'] == pet.id && d.data()['type'] == 'birthday')) {
      await r.reference.delete();
    }
    if (!on) return;
    await _db.collection('reminders').add({
      'ownerId': ownerId,
      'petId': pet.id,
      'type': 'birthday',
      'title': title,
      'at': DateTime(at.year, at.month, at.day, 9),
      'repeat': 'yearly',
      'done': false,
    });
  }
}

final albumRepositoryProvider = Provider<AlbumRepository>((ref) => AlbumRepository(ref.watch(firestoreProvider), ref.watch(storageServiceProvider)));

final petAlbumProvider = StreamProvider.family<List<AlbumItem>, String>((ref, petId) => ref.watch(albumRepositoryProvider).watchPet(petId));
