import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// File storage for photos, vault documents, album media and chat files.
abstract class StorageService {
  /// Uploads bytes and returns a URL that [MediaImage] and viewers understand.
  Future<String> upload(Uint8List bytes, {required String path, required String contentType});
  Future<Uint8List?> read(String url);
  Future<void> delete(String url);
}

/// Standalone demo: files are kept on the device (base64 in local storage).
/// URLs look like `mem://<id>`.
class DemoStorageService implements StorageService {
  DemoStorageService(this._prefs);
  final SharedPreferences _prefs;
  static final Map<String, Uint8List> _cache = {};

  static Uint8List? cached(String url) => _cache[url];

  @override
  Future<String> upload(Uint8List bytes, {required String path, required String contentType}) async {
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    final url = 'mem://$id';
    _cache[url] = bytes;
    try {
      await _prefs.setString('media_$id', base64Encode(bytes));
      await _prefs.setString('mediatype_$id', contentType);
    } catch (e) {
      debugPrint('Demo storage is full, keeping file in memory only: $e');
    }
    return url;
  }

  @override
  Future<Uint8List?> read(String url) async {
    final hit = _cache[url];
    if (hit != null) return hit;
    if (!url.startsWith('mem://')) return null;
    final raw = _prefs.getString('media_${url.substring(6)}');
    if (raw == null) return null;
    final bytes = base64Decode(raw);
    _cache[url] = bytes;
    return bytes;
  }

  @override
  Future<void> delete(String url) async {
    _cache.remove(url);
    if (url.startsWith('mem://')) {
      await _prefs.remove('media_${url.substring(6)}');
      await _prefs.remove('mediatype_${url.substring(6)}');
    }
  }
}

/// Cloud Storage (emulator or real project). Files go under users/{uid}/.
class FirebaseStorageService implements StorageService {
  FirebaseStorageService(this._storage);
  final FirebaseStorage _storage;

  @override
  Future<String> upload(Uint8List bytes, {required String path, required String contentType}) async {
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  @override
  Future<Uint8List?> read(String url) async {
    try {
      return await _storage.refFromURL(url).getData(30 * 1024 * 1024);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> delete(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }
}
