import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../messaging/data/chat_models.dart';
import '../../plans/presentation/plus_prompt.dart';
import '../../shell/presentation/sos_launcher.dart';
import '../../televet/domain/televet_rules.dart';
import '../data/assistant_repository.dart';
import '../domain/assistant_engine.dart';
import 'assistant_labels.dart';

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
    final msgs = ref.watch(assistantMessagesProvider);
    final a = ref.watch(assistantAllowanceProvider);
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
              child: StatusChip(
                a.unlimited ? l.aiUnlimited : l.aiLeft(a.left, a.limit),
                tone: a.unlimited ? ChipTone.success : (a.left <= 1 ? ChipTone.warning : ChipTone.info),
                icon: a.unlimited ? Icons.all_inclusive_rounded : Icons.help_outline_rounded,
              ),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: list.isEmpty && !_limitHit
              ? _Intro(onPick: (t) => _ask(aiQuestion(context, t), topic: t))
              : ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.md),
                  children: [
                    for (final w in items.reversed) Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 760), child: w)),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Padding(padding: const EdgeInsets.only(bottom: Space.md), child: InfoNote(l.aiDisclaimer)),
                      ),
                    ),
                  ],
                ),
        ),
        if (list.isNotEmpty && suggestions.isNotEmpty && !a.exhausted)
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.xs),
              children: [
                for (final t in suggestions)
                  Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: ActionChip(label: Text(aiQuestion(context, t)), onPressed: _busy ? null : () => _ask(aiQuestion(context, t), topic: t)),
                  ),
              ],
            ),
          ),
        Material(
          color: context.paw.background,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(context.gutter, Space.xs, context.gutter - 8, Space.sm),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md),
                        ),
                      ),
                    ),
                    const SizedBox(width: Space.xs),
                    IconButton.filled(
                      tooltip: l.aiAsk,
                      onPressed: _busy || _ctrl.text.trim().isEmpty ? null : () => _ask(_ctrl.text),
                      icon: _busy
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send_rounded),
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
    return PageBody(maxWidth: 760, children: [
      const SizedBox(height: Space.lg),
      const Center(child: Illustration(Scene.chat, size: 120)),
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
        margin: const EdgeInsets.only(top: Space.md, bottom: Space.xs, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        decoration: BoxDecoration(
          color: context.paw.primaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(text, style: context.text.bodyMedium?.copyWith(color: context.colors.onPrimaryContainer)),
          Text(Fmt.time(at, context.lang), style: context.text.labelSmall),
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
    return Padding(
      padding: const EdgeInsets.only(right: 24, bottom: Space.xs),
      child: PawCard(
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.auto_awesome_rounded, color: context.colors.primary, size: 20),
            const SizedBox(width: Space.sm),
            Text(l.aiTitle, style: context.text.labelLarge?.copyWith(color: context.colors.primary)),
            const SizedBox(width: Space.sm),
            StatusChip(l.demoBadge, tone: ChipTone.accent),
          ]),
          const SizedBox(height: Space.sm),
          Text(known ? aiAnswer(context, topic!) : l.aiUnknown, style: context.text.bodyMedium),
          const SizedBox(height: Space.sm),
          Text(l.aiNotDiagnosis, style: context.text.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.push('/televet'),
              icon: const Icon(Icons.video_call_rounded),
              label: Text(l.aiTalkToVet),
            ),
          ),
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
        borderColor: context.paw.sos,
        color: context.paw.sos.withValues(alpha: 0.07),
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(Icons.emergency_rounded, color: context.paw.sos),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(l.aiRedFlagTitle, style: context.text.titleMedium)),
          ]),
          const SizedBox(height: Space.sm),
          Text(l.aiRedFlagBody(redFlagLabel(context, flag))),
          const SizedBox(height: Space.md),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: context.paw.sos, foregroundColor: context.paw.onSos),
              onPressed: () => openSos(context, ref),
              icon: const Icon(Icons.emergency_rounded),
              label: Text(l.sosGetHelp),
            ),
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.aiTalkToVetNow, icon: Icons.video_call_rounded, onPressed: () => context.push('/televet/new')),
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
        color: context.paw.accent.withValues(alpha: 0.12),
        padding: const EdgeInsets.all(Space.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Icon(Icons.hourglass_bottom_rounded, color: context.paw.onAccent),
            const SizedBox(width: Space.sm),
            Expanded(child: Text(l.aiLimitTitle(limit), style: context.text.titleSmall)),
          ]),
          const SizedBox(height: Space.sm),
          Text(l.aiLimitBody(Fmt.date(nextMonthStart(DateTime.now()), context.lang))),
          const SizedBox(height: Space.md),
          PrimaryButton(
            label: l.seePlus,
            icon: Icons.workspace_premium_rounded,
            onPressed: () => showPlusPrompt(context, title: l.aiLimitTitle(limit), body: l.plusPerkAi),
          ),
          const SizedBox(height: Space.sm),
          SecondaryButton(label: l.aiTalkToVet, icon: Icons.video_call_rounded, onPressed: () => context.push('/televet')),
        ]),
      ),
    );
  }
}
