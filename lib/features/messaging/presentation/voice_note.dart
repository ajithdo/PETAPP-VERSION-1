import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/chat_repository.dart';
import '../domain/chat_rules.dart';

/// Records voice notes (up to 2 minutes) as 16 kHz mono PCM through the
/// `record` package, which works on Android, iOS and the web, and wraps the
/// audio as WAV. When no microphone is available (or permission is denied)
/// the chat offers a clearly labelled demo voice note instead.
class VoiceRecorder {
  AudioRecorder? _rec;
  StreamSubscription<Uint8List>? _sub;
  final _bytes = BytesBuilder(copy: false);
  DateTime? _startedAt;
  bool _demo = false;
  static const sampleRate = 16000;

  bool get isDemo => _demo;
  Duration get elapsed => _startedAt == null ? Duration.zero : DateTime.now().difference(_startedAt!);

  /// Starts recording. Returns false when the microphone cannot be used.
  Future<bool> start() async {
    try {
      final rec = AudioRecorder();
      _rec = rec;
      if (!await rec.hasPermission()) return false;
      final stream = await rec.startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits, sampleRate: sampleRate, numChannels: 1));
      _sub = stream.listen(_bytes.add, onError: (Object e) => debugPrint('Voice note stream error: $e'));
      _startedAt = DateTime.now();
      return true;
    } catch (e) {
      debugPrint('Microphone not available: $e');
      return false;
    }
  }

  /// Simulated recording for the demo (no microphone used).
  void startDemo() {
    _demo = true;
    _startedAt = DateTime.now();
  }

  /// Stops and returns WAV bytes plus the length in seconds.
  Future<({Uint8List bytes, int seconds})?> stop() async {
    final secs = elapsed.inMilliseconds / 1000;
    if (_demo) {
      final s = secs.clamp(1, maxVoiceNote.inSeconds).round();
      return (bytes: demoVoiceWav(s), seconds: s);
    }
    try {
      await _rec?.stop();
    } catch (_) {}
    await _sub?.cancel();
    final pcm = _bytes.takeBytes();
    if (pcm.isEmpty) return null;
    final seconds = (pcm.length / (sampleRate * 2)).round().clamp(1, maxVoiceNote.inSeconds);
    return (bytes: Uint8List.fromList(pcm16ToWav(pcm, sampleRate: sampleRate)), seconds: seconds);
  }

  Future<void> cancel() async {
    try {
      await _rec?.stop();
    } catch (_) {}
    await _sub?.cancel();
    _bytes.clear();
  }

  void dispose() {
    _sub?.cancel();
    _rec?.dispose();
  }
}

/// A soft, low "hum" so the demo voice note plays something audible
/// without using the microphone. 8 kHz mono to keep it small.
Uint8List demoVoiceWav(int seconds) {
  const rate = 8000;
  final n = rate * seconds;
  final pcm = Uint8List(n * 2);
  for (var i = 0; i < n; i++) {
    final t = i / rate;
    final env = 0.5 + 0.5 * math.sin(2 * math.pi * 2.2 * t).abs();
    final fade = math.min(1.0, math.min(t * 4, (seconds - t) * 4));
    final v = (math.sin(2 * math.pi * 180 * t) * 0.6 + math.sin(2 * math.pi * 270 * t) * 0.3) * env * fade * 2500;
    final s = v.round().clamp(-32768, 32767);
    pcm[i * 2] = s & 0xff;
    pcm[i * 2 + 1] = (s >> 8) & 0xff;
  }
  return Uint8List.fromList(pcm16ToWav(pcm, sampleRate: rate));
}

String formatSeconds(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

/// Play / pause bubble content for a voice note. Sample voice notes in the
/// seed data (url seed:voice:n) play silently with a moving progress bar.
class VoiceNotePlayer extends ConsumerStatefulWidget {
  const VoiceNotePlayer({super.key, required this.url, required this.durationSec, required this.color});
  final String url;
  final int durationSec;
  final Color color;

  @override
  ConsumerState<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends ConsumerState<VoiceNotePlayer> {
  AudioPlayer? _player;
  Timer? _sim;
  Duration _pos = Duration.zero;
  bool _playing = false;
  bool _loading = false;
  final _subs = <StreamSubscription<dynamic>>[];

  Duration get _total => Duration(seconds: math.max(1, widget.durationSec));

  @override
  void dispose() {
    _sim?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    _player?.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      _sim?.cancel();
      await _player?.pause();
      setState(() => _playing = false);
      return;
    }
    if (widget.url.startsWith('seed:')) {
      setState(() => _playing = true);
      if (_pos >= _total) _pos = Duration.zero;
      _sim = Timer.periodic(const Duration(milliseconds: 100), (t) {
        if (!mounted) return t.cancel();
        setState(() {
          _pos += const Duration(milliseconds: 100);
          if (_pos >= _total) {
            _pos = _total;
            _playing = false;
            t.cancel();
          }
        });
      });
      return;
    }
    try {
      if (_player == null) {
        setState(() => _loading = true);
        final p = AudioPlayer();
        _player = p;
        _subs.add(p.onPositionChanged.listen((d) => mounted ? setState(() => _pos = d) : null));
        _subs.add(p.onPlayerComplete.listen((_) => mounted ? setState(() {
              _playing = false;
              _pos = _total;
            }) : null));
        if (widget.url.startsWith('mem://')) {
          final bytes = await ref.read(chatRepositoryProvider).read(widget.url);
          if (bytes == null) throw StateError('missing audio');
          await p.setSource(BytesSource(bytes, mimeType: 'audio/wav'));
        } else {
          await p.setSource(UrlSource(widget.url));
        }
      }
      if (_pos >= _total) await _player!.seek(Duration.zero);
      await _player!.resume();
      if (mounted) {
        setState(() {
          _playing = true;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Voice note playback failed: $e');
      if (mounted) {
        setState(() => _loading = false);
        showToast(context, context.l10n.msgVoiceCantPlay);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final progress = (_pos.inMilliseconds / _total.inMilliseconds).clamp(0.0, 1.0);
    final shown = _playing || _pos > Duration.zero ? _pos.inSeconds : widget.durationSec;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        tooltip: _playing ? l.msgPause : l.msgPlayVoice,
        onPressed: _loading ? null : _toggle,
        icon: _loading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: widget.color))
            : Icon(_playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded, color: widget.color, size: 34),
      ),
      SizedBox(
        width: 120,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          _Wave(progress: progress, color: widget.color),
          const SizedBox(height: 2),
          Text(formatSeconds(shown), style: context.text.labelSmall),
        ]),
      ),
    ]);
  }
}

/// Simple bar "waveform" that fills as the note plays.
class _Wave extends StatelessWidget {
  const _Wave({required this.progress, required this.color});
  final double progress;
  final Color color;
  static const _heights = [6.0, 10, 16, 12, 20, 14, 8, 18, 22, 12, 9, 15, 19, 11, 7, 13, 17, 10, 6, 12];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        for (var i = 0; i < _heights.length; i++)
          Expanded(
            child: Center(
              child: Container(
                width: 3,
                height: _heights[i].toDouble(),
                decoration: BoxDecoration(
                  color: i / _heights.length <= progress ? color : color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

/// The bar that replaces the composer while recording.
class RecordingBar extends StatefulWidget {
  const RecordingBar({super.key, required this.recorder, required this.onCancel, required this.onSend});
  final VoiceRecorder recorder;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  @override
  State<RecordingBar> createState() => _RecordingBarState();
}

class _RecordingBarState extends State<RecordingBar> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      if (widget.recorder.elapsed >= maxVoiceNote) {
        _t?.cancel();
        widget.onSend();
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final secs = widget.recorder.elapsed.inSeconds;
    return Row(children: [
      IconButton(tooltip: l.msgCancelRecording, onPressed: widget.onCancel, icon: Icon(Icons.delete_outline_rounded, color: context.paw.error)),
      Icon(Icons.fiber_manual_record_rounded, color: context.paw.sos, size: 16),
      const SizedBox(width: Space.sm),
      Expanded(
        child: Text(
          widget.recorder.isDemo ? l.msgRecordingDemo(formatSeconds(secs)) : l.msgRecording(formatSeconds(secs), formatSeconds(maxVoiceNote.inSeconds)),
          style: context.text.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      IconButton.filled(tooltip: l.msgSendVoice, onPressed: widget.onSend, icon: const Icon(Icons.send_rounded)),
    ]);
  }
}
