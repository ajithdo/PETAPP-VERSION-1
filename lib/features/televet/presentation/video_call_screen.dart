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
import '../../../core/theme/ph.dart';

/// Tele-vet video call (spec 7.7): mute, camera on/off, switch camera,
/// speaker, end, timer and a weak-network indicator. DEMO VERSION 1 is a
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
    final call = Stack(children: [
        // "Remote video": an animated placeholder (no real camera in DEMO VERSION 1).
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2 + 0.05 * math.sin(_pulse.value * math.pi)),
                  radius: 1.1,
                  colors: const [MediaColors.callGlow, MediaColors.callBackground],
                ),
              ),
              child: Center(
                child: Semantics(
                  label: l.tvRemoteVideo(other),
                  child: Transform.scale(
                    scale: context.reduceMotion ? 1 : 1 + 0.03 * _pulse.value,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CircleAvatar(
                        radius: Sizes.callAvatar / 2,
                        backgroundColor: MediaColors.callAvatar,
                        child: Icon(isOwner ? Ph.firstAidKit : Ph.pawPrint, size: IconSizes.hero, color: MediaColors.onCallAvatar),
                      ),
                      const SizedBox(height: Space.lg),
                      Text(other, style: context.text.titleLarge?.copyWith(color: MediaColors.foreground)),
                      if (c != null && !isOwner) Text(c.petName, style: context.text.bodyMedium?.copyWith(color: MediaColors.callSubtitle)),
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
                    padding: const EdgeInsets.symmetric(horizontal: Space.sm + Space.xxs, vertical: Space.xs),
                    decoration: BoxDecoration(color: MediaColors.callDemo, borderRadius: BorderRadius.circular(Radii.full)),
                    child: Text(l.tvDemoCall, style: context.text.labelSmall?.copyWith(color: MediaColors.onCallDemo, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: Space.sm),
                  Semantics(
                    liveRegion: true,
                    child: Text(status, style: context.textX.mono.copyWith(color: MediaColors.foreground, fontSize: context.text.titleMedium?.fontSize, fontWeight: FontWeight.w700)),
                  ),
                  if (_weak && _connected)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Row(children: [
                        const Icon(Ph.cellSignalLow, color: MediaColors.callWarning, size: IconSizes.chip),
                        const SizedBox(width: Space.xs),
                        Flexible(child: Text(l.tvWeakNetwork, style: context.text.bodySmall?.copyWith(color: MediaColors.callWarning))),
                      ]),
                    )
                  else if (_connected)
                    Padding(
                      padding: const EdgeInsets.only(top: Space.xs),
                      child: Semantics(
                        label: l.tvGoodNetwork,
                        child: const Icon(Ph.cellSignalHigh, color: MediaColors.callGood, size: IconSizes.chip),
                      ),
                    ),
                ]),
              ),
              // Self view (picture in picture).
              Semantics(
                label: _cameraOn ? l.tvSelfView : l.tvCameraOff,
                child: Container(
                  width: Sizes.selfViewWidth,
                  height: Sizes.selfViewHeight,
                  decoration: BoxDecoration(
                    color: MediaColors.callTile,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    border: Border.all(color: MediaColors.control),
                  ),
                  child: Center(
                    child: _cameraOn
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            PetFace(species: c?.petSpecies ?? 'dog', color: PetTagColors.of('amber'), size: Sizes.thumb),
                            const SizedBox(height: Space.xs),
                            Text(_frontCamera ? l.tvFrontCamera : l.tvBackCamera, style: context.text.labelSmall?.copyWith(color: MediaColors.foregroundMuted)),
                          ])
                        : const Icon(Ph.videoCameraSlash, color: MediaColors.foregroundMuted),
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
                  Padding(padding: const EdgeInsets.only(bottom: Space.md), child: Text(l.tvCallLiveLater, style: context.text.bodyMedium?.copyWith(color: MediaColors.foregroundMuted), textAlign: TextAlign.center)),
                Wrap(alignment: WrapAlignment.center, spacing: Space.md, runSpacing: Space.md, children: [
                  _CallButton(
                    icon: _muted ? Ph.microphoneSlash : Ph.microphone,
                    label: _muted ? l.tvUnmute : l.tvMute,
                    active: _muted,
                    onTap: () => setState(() => _muted = !_muted),
                  ),
                  _CallButton(
                    icon: _cameraOn ? Ph.videoCamera : Ph.videoCameraSlash,
                    label: _cameraOn ? l.tvCameraOffAction : l.tvCameraOnAction,
                    active: !_cameraOn,
                    onTap: () => setState(() => _cameraOn = !_cameraOn),
                  ),
                  _CallButton(
                    icon: Ph.cameraRotate,
                    label: l.tvSwitchCamera,
                    onTap: _cameraOn ? () => setState(() => _frontCamera = !_frontCamera) : null,
                  ),
                  _CallButton(
                    icon: _speaker ? Ph.speakerHigh : Ph.ear,
                    label: _speaker ? l.tvSpeakerOn : l.tvSpeakerOff,
                    active: !_speaker,
                    onTap: () => setState(() => _speaker = !_speaker),
                  ),
                  _CallButton(icon: Ph.phoneDisconnect, label: l.tvEndCall, danger: true, onTap: () => _end(c)),
                ]),
              ]),
            ),
          ),
        ),
      ]);
    if (context.screenSize != ScreenSize.desktop) {
      return Scaffold(backgroundColor: MediaColors.callBackground, body: call);
    }
    // Desktop (UI Design 2 tele-vet): the call in a rounded card on the page,
    // who you are talking to under it, and what the visit is about beside it.
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.gutter),
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Radii.xxl),
                    child: ColoredBox(color: MediaColors.callBackground, child: call),
                  ),
                ),
                const SizedBox(height: Space.lg),
                PawCard(
                  child: Row(children: [
                    CircleAvatar(
                      radius: Sizes.avatarMd / 2,
                      backgroundColor: context.paw.primaryContainer,
                      child: Icon(isOwner ? Ph.firstAidKit : Ph.pawPrint, color: context.paw.brand),
                    ),
                    const SizedBox(width: Space.md),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(other, style: context.text.titleLarge),
                        if (c != null)
                          Text([if (c.clinicName.isNotEmpty) c.clinicName, c.petName].join(' · '), style: context.text.bodyMedium),
                      ]),
                    ),
                    StatusChip(l.tvVideoFeeLabel, tone: ChipTone.info, icon: Ph.videoCamera),
                  ]),
                ),
              ]),
            ),
            const SizedBox(width: Space.xl),
            SizedBox(
              width: Sizes.sidePanelWide,
              child: PawCard(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(l.teleVet, style: context.textX.overline.copyWith(color: context.paw.brand)),
                  const SizedBox(height: Space.xs),
                  Text(c?.petName ?? '', style: context.text.titleLarge),
                  const SizedBox(height: Space.lg),
                  Container(
                    padding: const EdgeInsets.all(Space.md),
                    decoration: BoxDecoration(color: context.paw.surfaceSubtle, borderRadius: BorderRadius.circular(Radii.lg)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.tvProblemLabel, style: context.textX.overline.copyWith(color: context.paw.textSecondary)),
                      const SizedBox(height: Space.xs),
                      Text((c?.problem.isNotEmpty ?? false) ? c!.problem : '–', style: context.text.bodyLarge),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
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
    final bg = danger ? PawColors.light.error : (active ? MediaColors.foreground : MediaColors.control);
    final fg = danger ? context.paw.onSos : (active ? MediaColors.callBackground : MediaColors.foreground);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Material(
          color: onTap == null ? MediaColors.controlDisabled : bg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    onTap!();
                  },
            child: SizedBox(width: danger ? Sizes.callButtonEnd : Sizes.callButton, height: danger ? Sizes.callButtonEnd : Sizes.callButton, child: Icon(icon, color: fg, size: IconSizes.action)),
          ),
        ),
        const SizedBox(height: Space.xs + Space.xxs),
        SizedBox(
          width: Sizes.callLabel,
          child: Text(label, textAlign: TextAlign.center, maxLines: 2, style: context.text.labelSmall?.copyWith(color: MediaColors.foreground)),
        ),
      ]),
    );
  }
}
