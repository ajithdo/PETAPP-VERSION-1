import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/services/service_providers.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/album.dart';
import '../album_labels.dart';
import 'video_source.dart';

/// Plays an album video. Uploaded videos play for real; the demo's sample
/// clips (seed:…) have no video file, so their playback is simulated.
class AlbumVideoView extends ConsumerStatefulWidget {
  const AlbumVideoView({super.key, required this.item});
  final AlbumItem item;

  @override
  ConsumerState<AlbumVideoView> createState() => _AlbumVideoViewState();
}

class _AlbumVideoViewState extends ConsumerState<AlbumVideoView> {
  VideoPlayerController? _c;
  Future<void> Function()? _cleanup;
  bool _failed = false;

  bool get _simulated => (widget.item.url ?? '').startsWith('seed:');

  @override
  void initState() {
    super.initState();
    if (!_simulated) _load();
  }

  Future<void> _load() async {
    try {
      final url = widget.item.url!;
      VideoPlayerController c;
      if (url.startsWith('http')) {
        c = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        final bytes = await ref.read(storageServiceProvider).read(url);
        if (bytes == null) throw StateError('missing video');
        final made = await controllerFromBytes(bytes, widget.item.contentType ?? 'video/mp4');
        c = made.$1;
        _cleanup = made.$2;
      }
      await c.initialize();
      if (!mounted) {
        await c.dispose();
        return;
      }
      c.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() => _c = c);
    } catch (e) {
      debugPrint('Video failed: $e');
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    _cleanup?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_simulated) return _SimulatedVideo(item: widget.item);
    if (_failed) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.videocam_off_rounded, color: Colors.white70, size: 48),
          const SizedBox(height: Space.sm),
          Text(l.albumVideoFailed, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
        ]),
      );
    }
    final c = _c;
    if (c == null) return const Center(child: CircularProgressIndicator());
    final playing = c.value.isPlaying;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: AspectRatio(
          aspectRatio: c.value.aspectRatio == 0 ? 16 / 9 : c.value.aspectRatio,
          child: Stack(alignment: Alignment.center, children: [
            VideoPlayer(c),
            _PlayButton(playing: playing, onTap: () => playing ? c.pause() : c.play()),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
        child: Row(children: [
          Expanded(child: VideoProgressIndicator(c, allowScrubbing: true, colors: VideoProgressColors(playedColor: context.colors.primary))),
          const SizedBox(width: Space.sm),
          Text('${videoLength(c.value.position.inSeconds)} / ${videoLength(c.value.duration.inSeconds)}',
              style: const TextStyle(color: Colors.white70)),
        ]),
      ),
    ]);
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.playing, required this.onTap});
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: playing ? 0.35 : 1,
      child: IconButton.filled(
        tooltip: playing ? l.albumPause : l.albumPlay,
        iconSize: 40,
        style: IconButton.styleFrom(backgroundColor: Colors.black54, foregroundColor: Colors.white, minimumSize: const Size(72, 72)),
        onPressed: onTap,
        icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
      ),
    );
  }
}

class _SimulatedVideo extends StatefulWidget {
  const _SimulatedVideo({required this.item});
  final AlbumItem item;
  @override
  State<_SimulatedVideo> createState() => _SimulatedVideoState();
}

class _SimulatedVideoState extends State<_SimulatedVideo> with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.item.durationSec.clamp(3, 600)),
  )..addListener(() => setState(() {}));

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final total = widget.item.durationSec;
    final playing = _a.isAnimating;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(alignment: Alignment.center, children: [
            Positioned.fill(
              child: Transform.scale(
                scale: context.reduceMotion ? 1 : 1 + 0.06 * _a.value,
                child: MediaImage(url: widget.item.url!, semanticLabel: widget.item.caption),
              ),
            ),
            _PlayButton(
              playing: playing,
              onTap: () {
                if (playing) {
                  _a.stop();
                } else {
                  if (_a.isCompleted) _a.reset();
                  _a.forward();
                }
                setState(() {});
              },
            ),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
        child: Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: _a.value, minHeight: 4, color: context.colors.primary, backgroundColor: Colors.white24),
            ),
          ),
          const SizedBox(width: Space.sm),
          Text('${videoLength((_a.value * total).round())} / ${videoLength(total)}', style: const TextStyle(color: Colors.white70)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        child: Text(l.albumDemoVideo, style: const TextStyle(color: Colors.white60, fontSize: 12), textAlign: TextAlign.center),
      ),
    ]);
  }
}
