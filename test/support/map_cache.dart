import 'dart:io';

import 'package:flutter_map/flutter_map.dart';

/// flutter_map creates its tile cache on first use and asks a platform
/// plugin for the cache folder, which the test sandbox doesn't have. The
/// error arrives asynchronously, in the middle of checks that wait on real
/// async work. Creating the shared cache up front with a temporary folder
/// avoids the plugin call.
void useTemporaryMapCache() {
  BuiltInMapCachingProvider.getOrCreateInstance(cacheDirectory: Directory.systemTemp.createTempSync('fm_cache').path);
}
