/// Storage quota per plan (spec 7.11, 8): free 1 GB, Plus 25 GB, read from
/// config/app limits.storageGb. Counts the files a person uploaded: vault
/// documents they own and album photos/videos they added. The Cloud Storage
/// trigger in functions/src/phase7.ts enforces the same limit on the server.
library;

const _gb = 1024 * 1024 * 1024;

int gbToBytes(num gb) => (gb * _gb).round();

class StorageUsage {
  const StorageUsage({required this.usedBytes, required this.limitBytes, this.docsBytes = 0, this.albumBytes = 0});
  final int usedBytes;
  final int limitBytes;
  final int docsBytes;
  final int albumBytes;

  double get fraction => limitBytes <= 0 ? 1 : (usedBytes / limitBytes).clamp(0.0, 1.0);
  int get freeBytes => (limitBytes - usedBytes).clamp(0, limitBytes);
  bool canAdd(int bytes) => usedBytes + bytes <= limitBytes;

  /// More than 90% used: show a gentle warning.
  bool get nearlyFull => fraction >= 0.9;
}

StorageUsage computeUsage({required Iterable<int> docSizes, required Iterable<int> albumSizes, required num limitGb}) {
  final d = docSizes.fold<int>(0, (a, b) => a + b);
  final a = albumSizes.fold<int>(0, (x, y) => x + y);
  return StorageUsage(usedBytes: d + a, limitBytes: gbToBytes(limitGb), docsBytes: d, albumBytes: a);
}

/// 950 KB, 12.4 MB, 1.2 GB (Indian English uses the same units).
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var v = bytes / 1024;
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  final digits = v >= 100 || i == 0 ? 0 : 1;
  var s = v.toStringAsFixed(digits);
  if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
  return '$s ${units[i]}';
}

/// Videos up to 60 s on free and 3 min on Plus (limits.videoSeconds).
bool videoWithinLimit(int seconds, num limitSeconds) => seconds <= limitSeconds;
