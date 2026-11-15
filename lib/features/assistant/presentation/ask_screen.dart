import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../admin/admin_slots.dart' show featureOn;
import '../../messaging/data/chat_models.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../../televet/domain/televet_rules.dart';
import '../data/assistant_repository.dart';
import '../domain/assistant_engine.dart';
import 'assistant_labels.dart';
import '../../../core/theme/ph.dart';
import '../../pets/data/pets_repository.dart';

/// "Ask PawSetu" (spec 7.14): quick care answers, never a diagnosis. Red
/// flags show SOS and a tele-vet button straight away.
class AskScreen extends ConsumerStatefulWidget {
  const AskScreen({super.key});
  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  final _ctrl = TextEditingController();
  bool _busy = false;
  bool _limitHit = false;

  /// A red flag spotted after the allowance ran out (still shown, never stored).
  String? _localRedFlag;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _ask(String text, {String? topic}) async {
    final q = text.trim();
    final me = ref.read(currentUserProvider);
    if (q.isEmpty || me == null || _busy) return;
    final allowance = ref.read(assistantAllowanceProvider);
    final flag = detectRedFlag(q);
    setState(() {
      _busy = true;
      _localRedFlag = null;
    });
    try {
      if (allowance.exhausted && flag == null) {
        setState(() => _limitHit = true);
        return;
      }
      await ref.read(assistantBackendProvider).ask(me, q, topic: topic, limit: allowance.limit);
      _ctrl.clear();
    } on AssistantLimitException {
      setState(() {
        _limitHit = true;
        _localRedFlag = flag;
      });
    } catch (e) {
      debugPrint('Ask failed: $e');
      if (mounted) showToast(context, context.l10n.msgSendFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!featureOn(ref, 'aiAssistant')) {
      return Scaffold(appBar: AppBar(title: Text(l.aiTitle)), body: EmptyState(title: l.featurePaused, message: l.featurePausedBody));
    }
    final msgs = ref.watch(assistantMessagesProvider);
    final a = ref.watch(assistantAllowanceProvider);
    final pet = ref.watch(selectedPetProvider);
    final list = msgs.value ?? const <ChatMessage>[];
    final asked = {for (final m in list) if (m.type == 'question' && m.topic != null) m.topic};
    final suggestions = assistantTopics.where((t) => !asked.contains(t)).take(8).toList();
    final items = <Widget>[];
    for (final m in list) {
      if (m.type == 'question') {
        items.add(_QuestionBubble(text: m.text, at: m.createdAt));
      } else if (m.type == 'answer') {
        items.add(m.redFlag != null ? _RedFlagCard(flag: m.redFlag!) : _AnswerCard(topic: m.topic));
      }
    }
    if (_localRedFlag != null) items.add(_RedFlagCard(flag: _localRedFlag!));
    if (_limitHit || (a.exhausted && list.isNotEmpty)) items.add(_LimitCard(limit: a.limit));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.aiTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Space.md),
            child: Center(
              // Marigold "Unlimited with Plus"; a quiet count on the free plan.
              child: a.unlimited
                  ? PawTag(l.aiUnlimited, kind: TagKind.plus, icon: Ph.infinity)
                  : PawTag(l.aiLeft(a.left, a.limit), kind: a.left <= 1 ? TagKind.gold : TagKind.neutral),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: list.isEmpty && !_limitHit
              ? _Intro(onPick: (t) => _ask(aiQuestion(context, t), topic: t))
              : Align(
                alignment: Alignment.topCenter,
                child: ListView(
                  reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.md),
                  children: [
                    for (final w in items.reversed) Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: Space.readingWidth), child: w)),
                    // One quiet line at the very top: whose answers these
                    // are, and that they are not a diagnosis.
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Semantics(
                        label: l.aiDisclaimer,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Ph.sparkle, size: IconSizes.sm, color: context.paw.textSecondary),
                          const SizedBox(width: Space.sm),
                          Flexible(
                            child: Text(
                              pet == null ? l.aiCareAnswersAll : l.aiCareAnswers(pet.name),
                              textAlign: TextAlign.center,
                              style: context.text.bodySmall?.copyWith(color: context.paw.textSecondary),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
        ),
        if (list.isNotEmpty && suggestions.isNotEmpty && !a.exhausted)
          ChipStrip(chips: [
            for (final t in suggestions) ActionChip(label: Text(aiQuestion(context, t)), onPressed: _busy ? null : () => _ask(aiQuestion(context, t), topic: t)),
          ]),
        Material(
          color: context.paw.background,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(context.gutter, Space.xs, context.gutter - Space.sm, Space.sm),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Space.readingWidth),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (v) => _ask(v),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: l.aiHint,
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.full), borderSide: BorderSide(color: context.tint.line2, width: Strokes.strong)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.full), borderSide: BorderSide(color: context.tint.line2, width: Strokes.strong)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md + Space.xxs),
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.md),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: context.paw.action, foregroundColor: context.paw.onAction, minimumSize: const Size.square(Sizes.field), fixedSize: const Size.square(Sizes.field)),
                      tooltip: l.aiAsk,
                      onPressed: _busy || _ctrl.text.trim().isEmpty ? null : () => _ask(_ctrl.text),
                      icon: _busy
                          ? const SizedBox(width: IconSizes.chip, height: IconSizes.chip, child: CircularProgressIndicator(strokeWidth: Strokes.focus))
                          : const Icon(Ph.paperPlaneRightFill),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PageBody(maxWidth: Space.readingWidth, children: [
      const SizedBox(height: Space.lg),
      const Center(child: Illustration(Scene.chat, size: Sizes.illustrationSm)),
      const SizedBox(height: Space.md),
      Text(l.aiIntroTitle, style: context.text.titleLarge, textAlign: TextAlign.center),
      const SizedBox(height: Space.xs),
      Text(l.aiIntroBody, style: context.text.bodyMedium?.copyWith(color: context.paw.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: Space.md),
      InfoNote(l.aiDisclaimer),
      SectionHeader(l.aiPopular),
      Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
        for (final t in assistantTopics) ActionChip(label: Text(aiQuestion(context, t)), onPressed: () => onPick(t)),
      ]),
    ]);
  }
}

class _QuestionBubble extends StatelessWidget {
  const _QuestionBubble({required this.text, required this.at});
  final String text;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(top: Space.lg, bottom: Space.lg, left: Space.x3l),
        padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs, vertical: Space.sm + Space.xxs),
        // UI Design 6: your words in an ink bubble on the right.
        decoration: BoxDecoration(
          color: context.paw.textPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Radii.lg + Space.xxs),
            topRight: Radius.circular(Radii.lg + Space.xxs),
            bottomLeft: Radius.circular(Radii.lg + Space.xxs),
            bottomRight: Radius.circular(Radii.xs + Space.xxs),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(text, style: context.text.bodyMedium?.copyWith(color: context.paw.background)),
          const SizedBox(height: Space.xs),
          Text(Fmt.time(at, context.lang), style: context.text.labelSmall?.copyWith(color: context.paw.background.withValues(alpha: Opacities.onDarkMuted), fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.topic});
  final String? topic;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final known = topic != null;
    final paw = context.paw;
    // UI Design 6: the answer as a white bubble on the left, signed "Ask
    // PawSetu" with the demo tag, the reminder that it is not a diagnosis as
    // a note inside it, and the way to a vet as a small marigold button.
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: Space.x3l + Space.md),
        padding: const EdgeInsets.symmetric(horizontal: Space.md + Space.xxs, vertical: Space.md),
        decoration: BoxDecoration(
          color: paw.surface,
          boxShadow: Theme.of(context).brightness == Brightness.light ? Shadows.card(paw.ink) : null,
          border: Theme.of(context).brightness == Brightness.light ? null : Border.all(color: paw.outline),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Radii.lg + Space.xxs),
            topRight: Radius.circular(Radii.lg + Space.xxs),
            bottomRight: Radius.circular(Radii.lg + Space.xxs),
            bottomLeft: Radius.circular(Radii.xs + Space.xxs),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Wrap(spacing: Space.sm, runSpacing: Space.xs, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Icon(Ph.sparkleFill, color: paw.textSecondary, size: IconSizes.xs),
            Text(l.aiTitle, style: context.text.labelSmall?.copyWith(color: paw.textSecondary, fontWeight: FontWeight.w500)),
            PawTag(l.demoBadge, kind: TagKind.gold),
          ]),
          const SizedBox(height: Space.sm),
          Text(known ? aiAnswer(context, topic!) : l.aiUnknown, style: context.text.bodyMedium),
          const SizedBox(height: Space.md),
          InfoNote(l.aiNotDiagnosis),
          const SizedBox(height: Space.md),
          PawButton(label: l.aiTalkToVet, icon: Ph.videoCamera, onPressed: () => context.push('/televet')),
        ]),
      ),
    );
  }
}

class _RedFlagCard extends ConsumerWidget {
  const _RedFlagCard({required this.flag});
  final String flag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.xs),
      child: PawCard(
        borderColor: Colors.transparent,
        color: context.paw.sosContainer,
        flat: true,
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(Ph.warningFill, size: IconSizes.md, color: context.paw.error),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(l.aiRedFlagTitle, style: context.text.labelLarge?.copyWith(color: context.paw.error))),
          ]),
          const SizedBox(height: Space.sm),
          Text(l.aiRedFlagBody(redFlagLabel(context, flag))),
          const SizedBox(height: Space.md),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            PawButton(label: l.sosGetHelp, icon: Ph.asterisk, kind: BtnKind.sos, size: BtnSize.regular, onPressed: () => openSos(context, ref)),
            PawButton(label: l.aiTalkToVetNow, icon: Ph.videoCamera, kind: BtnKind.ink, size: BtnSize.regular, onPressed: () => context.push('/televet/new')),
          ]),
        ]),
      ),
    );
  }
}

class _LimitCard extends StatelessWidget {
  const _LimitCard({required this.limit});
  final int limit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: PawCard(
        color: context.paw.accent.withValues(alpha: Opacities.chip),
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(Ph.hourglassLow, color: context.paw.onAccentContainer),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(l.aiLimitTitle(limit), style: context.text.titleSmall)),
          ]),
          const SizedBox(height: Space.sm),
          Text(l.aiLimitBody(Fmt.date(nextMonthStart(DateTime.now()), context.lang))),
          const SizedBox(height: Space.md),
          PrimaryButton(
            label: l.seePlus,
            icon: Ph.crownSimple,
            onPressed: () => showPlusPrompt(context, title: l.aiLimitTitle(limit), body: l.plusPerkAi),
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.aiTalkToVet, icon: Ph.videoCamera, onPressed: () => context.push('/televet')),
        ]),
      ),
    );
  }
}
