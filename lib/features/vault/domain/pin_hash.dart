/// Vault PIN and share-link PIN hashing (spec 7.9). Pure Dart, so the seed
/// and the Cloud Function (Node crypto.pbkdf2, same parameters) agree.
///
/// Format: `pbkdf2$<iterations>$<salt base64>$<hash base64>` using
/// PBKDF2-HMAC-SHA256 with a 32-byte output. PINs are never stored plain.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

const pinIterations = 1000;

/// 4 to 6 digits (spec 7.9).
bool isValidPin(String pin) => RegExp(r'^\d{4,6}$').hasMatch(pin);

/// Rejects PINs that are too easy to guess: one repeated digit or a
/// straight run such as 1234 or 654321.
bool isWeakPin(String pin) {
  if (!isValidPin(pin)) return true;
  if (pin.split('').toSet().length == 1) return true;
  var up = true;
  var down = true;
  for (var i = 1; i < pin.length; i++) {
    final a = pin.codeUnitAt(i - 1);
    final b = pin.codeUnitAt(i);
    if (b - a != 1) up = false;
    if (a - b != 1) down = false;
  }
  return up || down;
}

Uint8List pbkdf2Sha256(List<int> password, List<int> salt, int iterations, [int length = 32]) {
  final hmac = Hmac(sha256, password);
  final out = BytesBuilder();
  var block = 1;
  while (out.length < length) {
    final first = hmac.convert([...salt, (block >> 24) & 0xff, (block >> 16) & 0xff, (block >> 8) & 0xff, block & 0xff]).bytes;
    final acc = Uint8List.fromList(first);
    var u = first;
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < acc.length; j++) {
        acc[j] ^= u[j];
      }
    }
    out.add(acc);
    block++;
  }
  return Uint8List.fromList(out.toBytes().sublist(0, length));
}

/// Hashes [pin] with a fresh random salt (or [salt] for repeatable seeds).
String hashPin(String pin, {List<int>? salt, int iterations = pinIterations, Random? random}) {
  final r = random ?? Random.secure();
  final s = salt ?? List<int>.generate(16, (_) => r.nextInt(256));
  final h = pbkdf2Sha256(utf8.encode(pin), s, iterations);
  return 'pbkdf2\$$iterations\$${base64Encode(s)}\$${base64Encode(h)}';
}

/// Checks [pin] against a stored hash in constant time.
bool verifyPin(String pin, String? stored) {
  if (stored == null) return false;
  final parts = stored.split('\$');
  if (parts.length != 4 || parts[0] != 'pbkdf2') return false;
  final iterations = int.tryParse(parts[1]);
  if (iterations == null || iterations < 1) return false;
  final salt = base64Decode(parts[2]);
  final expected = base64Decode(parts[3]);
  final got = pbkdf2Sha256(utf8.encode(pin), salt, iterations, expected.length);
  var diff = 0;
  for (var i = 0; i < expected.length; i++) {
    diff |= expected[i] ^ got[i];
  }
  return diff == 0;
}

/// A random numeric PIN for share links (4 digits, never a weak one).
String randomSharePin([Random? random]) {
  final r = random ?? Random.secure();
  while (true) {
    final pin = List.generate(4, (_) => r.nextInt(10)).join();
    if (!isWeakPin(pin)) return pin;
  }
}

/// Unguessable link token (22 characters, about 131 bits).
String newShareToken([Random? random]) {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789';
  final r = random ?? Random.secure();
  return List.generate(22, (_) => chars[r.nextInt(chars.length)]).join();
}
