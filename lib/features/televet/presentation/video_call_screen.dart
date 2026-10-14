import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../messaging/presentation/voice_note.dart';
import '../data/consultation.dart';
import '../data/televet_repository.dart';
import '../data/video_service.dart';

/// Tele-vet video call (spec 7.7): mute, camera on/off, switch camera,
/// speaker, end, timer and a weak-network indicator. Version 1 is a
/// simulated call: no camera, microphone or network is used.
class VideoCallScreen extends ConsumerStatefulWidget {
  const VideoCallScreen({super.key, required this.consultationId});
  final String consultationId;
  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  Timer? _tick;
  bool _connected = false;
  String? _error;
  int _seconds = 0;
  bool _muted = false;
  bool _cameraOn = true;
  bool _frontCamera = true;
  bool _speaker = true;
  bool _weak = false;
  bool _ending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _join());
  }

  Future<void> _join() async {
    final me = ref.read(currentUserProvider);
    if (me == null) return;
    try {
      await ref.read(videoCallServiceProvider).join(consultationId: widget.consultationId, uid: me.uid);
      if (!mounted) return;
      setState(() => _connected = true);
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _seconds++;
          // Simulated network: a short weak patch every 40 seconds.
          _weak = _seconds % 40 >= 30 && _seconds % 40 < 35;
        });
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _end(Consultation? c) async {
    if (_ending) return;
    _ending = true;
    HapticFeedback.mediumImpact();
    _tick?.cancel();
    await ref.read(videoCallServiceProvider).leave();
    final me = ref.read(currentUserProvider);
    if (c != null && me != null && _connected && _seconds > 0) {
      try {
        await ref.read(teleVetBackendProvider).send(c, me, type: 'call', event: 'call_ended', meta: {'seconds': _seconds});
      } catch (e) {
        debugPrint('Call log failed: $e');
      }
    }
    if (!mounted) return;
    final l = context.l10n;
    showToast(context, l.tvCallEndedToast(formatSeconds(_seconds)));
    if (context.canPop()) {
      context.pop();
    } else if (c != null) {
      context.go('/messages/${c.conversationId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = ref.watch(consultationProvider(widget.consultationId)).value;
    final me = ref.watch(currentUserProvider);
    final isOwner = me?.uid == c?.ownerId;
    final other = c == null ? '' : (isOwner ? (c.vetName.isEmpty ? l.tvFindingVetShort : c.vetName) : c.ownerName);
    final waitingForVet = c != null && c.isQueued;
    final status = _error != null
        ? l.tvCallFailed
        : !_connected
            ? l.tvConnecting
            : waitingForVet
                ? l.tvWaitingVetJoin
                : formatSeconds(_seconds);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1214),
      body: Stack(children: [
        // "Remote video": an animated placeholder (no real camera in V1).
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2 + 0.05 * math.sin(_pulse.value * math.pi)),
                  radius: 1.1,
                  colors: const [Color(0xFF134E4A), Color(0xFF0B1214)],
                ),
              ),
              child: Center(
                child: Semantics(
                  label: l.tvRemoteVideo(other),
                  child: Transform.scale(
                    scale: context.reduceMotion ? 1 : 1 + 0.03 * _pulse.value,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: const Color(0xFF2DD4BF),
                        child: Icon(isOwner ? Icons.medical_services_rounded : Icons.pets_rounded, size: 60, color: const Color(0xFF04201D)),
                      ),
                      const SizedBox(height: Space.lg),
                      Text(other, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      if (c != null && !isOwner) Text(c.petName, style: const TextStyle(color: Color(0xFFCCFBF1), fontSize: 15)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Top bar: name, timer, network.
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0x33F4A261), borderRadius: BorderRadius.circular(100)),
                    child: Text(l.tvDemoCall, style: const TextStyle(color: Color(0xFFF6BD8A), fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: Space.sm),
                  Semantics(
                    liveRegion: true,
                    child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
                  ),
                  if (_weak && _connected)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Row(children: [
                        const Icon(Icons.signal_cellular_alt_1_bar_rounded, color: Color(0xFFFBBF24), size: 18),
                        const SizedBox(width: 4),
                        Flexible(child: Text(l.tvWeakNetwork, style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 13))),
                      ]),
                    )
                  else if (_connected)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Semantics(
                        label: l.tvGoodNetwork,
                        child: const Icon(Icons.signal_cellular_alt_rounded, color: Color(0xFF4ADE80), size: 18),
                      ),
                    ),
                ]),
              ),
              // Self view (picture in picture).
              Semantics(
                label: _cameraOn ? l.tvSelfView : l.tvCameraOff,
                child: Container(
                  width: 104,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF172124),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Center(
                    child: _cameraOn
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            PetFace(species: c?.petSpecies ?? 'dog', color: const Color(0xFFF4A261), size: 56),
                            const SizedBox(height: 4),
                            Text(_frontCamera ? l.tvFrontCamera : l.tvBackCamera, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                          ])
                        : const Icon(Icons.videocam_off_rounded, color: Colors.white54),
                  ),
                ),
              ),
            ]),
          ),
        ),
        // Controls.
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Space.xl, left: Space.md, right: Space.md),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (_error != null)
                  Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(l.tvCallLiveLater, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center)),
                Wrap(alignment: WrapAlignment.center, spacing: Space.md, runSpacing: Space.md, children: [
                  _CallButton(
                    icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _muted ? l.tvUnmute : l.tvMute,
                    active: _muted,
                    onTap: () => setState(() => _muted = !_muted),
                  ),
                  _CallButton(
                    icon: _cameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                    label: _cameraOn ? l.tvCameraOffAction : l.tvCameraOnAction,
                    active: !_cameraOn,
                    onTap: () => setState(() => _cameraOn = !_cameraOn),
                  ),
                  _CallButton(
                    icon: Icons.cameraswitch_rounded,
                    label: l.tvSwitchCamera,
                    onTap: _cameraOn ? () => setState(() => _frontCamera = !_frontCamera) : null,
                  ),
                  _CallButton(
                    icon: _speaker ? Icons.volume_up_rounded : Icons.hearing_rounded,
                    label: _speaker ? l.tvSpeakerOn : l.tvSpeakerOff,
                    active: !_speaker,
                    onTap: () => setState(() => _speaker = !_speaker),
                  ),
                  _CallButton(icon: Icons.call_end_rounded, label: l.tvEndCall, danger: true, onTap: () => _end(c)),
                ]),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _CallButton extends StatelessWidget {
  const _CallButton({required this.icon, required this.label, required this.onTap, this.active = false, this.danger = false});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool active;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final bg = danger ? context.paw.sos : (active ? Colors.white : Colors.white.withValues(alpha: 0.16));
    final fg = danger ? Colors.white : (active ? const Color(0xFF0B1214) : Colors.white);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Material(
          color: onTap == null ? Colors.white10 : bg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap!();
                  },
            child: SizedBox(width: danger ? 68 : 58, height: danger ? 68 : 58, child: Icon(icon, color: fg, size: 28)),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 76,
          child: Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ]),
    );
  }
}
