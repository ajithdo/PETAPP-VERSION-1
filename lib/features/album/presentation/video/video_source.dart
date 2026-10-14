/// Builds video players from in-memory bytes (demo uploads) and reads a
/// picked video's length, on Android/iOS (temporary file) and the web
/// (data or blob URL).
library;

export 'video_source_io.dart' if (dart.library.js_interop) 'video_source_web.dart';
