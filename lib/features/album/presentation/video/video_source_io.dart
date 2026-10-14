import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// Plays bytes from a temporary file that the returned cleanup deletes.
Future<(VideoPlayerController, Future<void> Function())> controllerFromBytes(Uint8List bytes, String contentType) async {
  final ext = contentType.contains('quicktime') ? 'mov' : (contentType.contains('webm') ? 'webm' : 'mp4');
  final f = File('${Directory.systemTemp.path}/pawsetu_${DateTime.now().microsecondsSinceEpoch}.$ext');
  await f.writeAsBytes(bytes, flush: true);
  return (
    VideoPlayerController.file(f),
    () async {
      try {
        await f.delete();
      } catch (_) {}
    },
  );
}

/// Length of a picked video in seconds, or null if it can't be read.
Future<int?> pickedVideoSeconds(XFile file) async {
  final c = VideoPlayerController.file(File(file.path));
  try {
    await c.initialize().timeout(const Duration(seconds: 8));
    return c.value.duration.inSeconds;
  } catch (_) {
    return null;
  } finally {
    await c.dispose();
  }
}
