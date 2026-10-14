import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// The website plays demo uploads from a data URL (nothing is written to disk).
Future<(VideoPlayerController, Future<void> Function())> controllerFromBytes(Uint8List bytes, String contentType) async {
  final uri = Uri.dataFromBytes(bytes, mimeType: contentType.isEmpty ? 'video/mp4' : contentType);
  return (VideoPlayerController.networkUrl(uri), () async {});
}

/// On the web a picked file's path is a blob URL the browser can play.
Future<int?> pickedVideoSeconds(XFile file) async {
  final c = VideoPlayerController.networkUrl(Uri.parse(file.path));
  try {
    await c.initialize().timeout(const Duration(seconds: 8));
    return c.value.duration.inSeconds;
  } catch (_) {
    return null;
  } finally {
    await c.dispose();
  }
}
