import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/converters.dart';
import '../../../core/data/paging.dart';
import '../../../core/providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/ph.dart';

/// The newest page of my notifications; "Show more" loads older ones.
final _notificationsProvider = StreamProvider.autoDispose<List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  final u = ref.watch(currentUserProvider);
  if (u == null) return Stream.value(const []);
  return ref
      .watch(firestoreProvider)
      .collection('notifications')
      .where('uid', isEqualTo: u.uid)
      .orderBy('createdAt', descending: true)
      .limit(ref.watch(listLimitProvider('notifications')))
      .snapshots()
      .map((s) => s.docs);
});

/// Notification centre: history, filters, mark all read (spec 7.14).
class NotificationCentreScreen extends ConsumerStatefulWidget {
  const NotificationCentreScreen({super.key});
  @override
  ConsumerState<NotificationCentreScreen> createState() => _NotificationCentreScreenState();
}

class _NotificationCentreScreenState extends ConsumerState<NotificationCentreScreen> {
  String _filter = 'all';

  IconData _icon(String? type) => switch (type) {
        'vaccines' => Ph.syringe,
        'medicines' => Ph.pill,
        'deworming' => Ph.bug,
        'bookings' => Ph.calendarCheck,
        'messages' => Ph.chatCircleDots,
        'orders' => Ph.truck,
        'lost' => Ph.globeHemisphereEast,
        'device' => Ph.watch,
        'sos' => Ph.asterisk,
        'support' => Ph.headset,
        'account' => Ph.shieldCheck,
        'plan' => Ph.crownSimple,
        _ => Ph.bell,
      };

  /// Tile colour for a notification type (UI Design 6: things are tiles).
  Color _tone(BuildContext context, String? type) => switch (type) {
        'vaccines' || 'medicines' || 'account' => context.paw.success,
        'deworming' || 'plan' => context.paw.accent,
        'orders' || 'device' => CategoryColors.ocean,
        'sos' || 'lost' => context.paw.sos,
        _ => context.paw.textSecondary,
      };

  /// "Today", "Yesterday" or "Earlier" for grouping.
  String _dayGroup(BuildContext context, DateTime at) {
    final now = DateTime.now();
    final d = DateTime(at.year, at.month, at.day);
    final today = DateTime(now.year, now.month, now.day);
    final l = context.l10n;
    if (!d.isBefore(today)) return l.today;
    if (!d.isBefore(today.subtract(const Duration(days: 1)))) return l.yesterday;
    return l.earlier;
  }

  bool _match(String? type) => switch (_filter) {
        'unread' => true,
        'health' => const ['vaccines', 'medicines', 'deworming', 'custom'].contains(type),
        'bookings' => type == 'bookings',
        'orders' => type == 'orders' || type == 'messages',
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final docs = ref.watch(_notificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notifications),
        actions: [
          TextButton(
            onPressed: () async {
              // Every unread one, not just the page on screen.
              final u = ref.read(currentUserProvider);
              if (u == null) return;
              final db = ref.read(firestoreProvider);
              final unread = await db.collection('notifications').where('uid', isEqualTo: u.uid).where('read', isEqualTo: false).get();
              for (var i = 0; i < unread.docs.length; i += 400) {
                final batch = db.batch();
                for (final d in unread.docs.skip(i).take(400)) {
                  batch.update(d.reference, {'read': true});
                }
                await batch.commit();
              }
            },
            child: ConstrainedBox(
              // Room for the title and the settings button at large text sizes.
              constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * StatusChip.maxWidthShare),
              child: Text(l.markAllRead, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
            ),
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Ph.slidersHorizontal),
            onPressed: () => context.push('/me/settings/notifications'),
          ),
        ],
      ),
      body: AsyncView(
        value: docs,
        data: (all) {
          final list = all.where((d) => _match(d.data()['type'] as String?) && (_filter != 'unread' || d.data()['read'] != true)).toList();
          final more = mayHaveMore(all.length, ref.watch(listLimitProvider('notifications')));
          return Column(children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.gutter, vertical: Space.sm),
              child: Row(children: [
                for (final f in [('all', l.filterAll), ('unread', l.filterUnread), ('health', l.tabHealth), ('bookings', l.filterBookings), ('orders', l.filterOrdersMessages)])
                  Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: ChoiceChip(label: Text(f.$2), selected: _filter == f.$1, onSelected: (_) => setState(() => _filter = f.$1)),
                  ),
              ]),
            ),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(scene: Scene.chat, title: l.noNotificationsTitle, message: l.noNotificationsBody)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: context.gutter),
                      itemCount: list.length + (more ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == list.length) {
                          return ShowMoreButton(onPressed: () => ref.read(listLimitProvider('notifications').notifier).more());
                        }
                        final d = list[i].data();
                        final unread = d['read'] != true;
                        final at = parseDate(d['createdAt']) ?? DateTime.now();
                        final group = _dayGroup(context, at);
                        final newGroup = i == 0 || _dayGroup(context, parseDate(list[i - 1].data()['createdAt']) ?? DateTime.now()) != group;
                        final type = d['type'] as String?;
                        final tone = _tone(context, type);
                        final body = (d['body'] as String?) ?? '';
                        // UI Design 6: grouped by day; a tinted tile, the
                        // title (bold when unread), the time, and a marigold
                        // dot for unread.
                        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          if (newGroup) SectionHeader(group, padding: EdgeInsets.only(top: i == 0 ? Space.sm : Space.lg, bottom: Space.xs)),
                          Semantics(
                            button: true,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(Radii.md),
                              onTap: () async {
                                await list[i].reference.update({'read': true});
                                final link = d['link'] as String?;
                                if (link != null && context.mounted) context.push(link);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: Space.md),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.paw.outline))),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Container(
                                    width: TapTarget.min - Space.xxs,
                                    height: TapTarget.min - Space.xxs,
                                    decoration: BoxDecoration(color: tone.withValues(alpha: Opacities.chip), borderRadius: BorderRadius.circular(Radii.md)),
                                    child: Icon(_icon(type), color: readableOn(tone, [context.paw.background], ratio: 3)),
                                  ),
                                  const SizedBox(width: Space.md),
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text((d['title'] as String?) ?? '', style: unread ? context.text.titleSmall : context.text.bodyMedium),
                                      if (body.isNotEmpty) Text(body, style: context.text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: Space.xxs),
                                      Text(Fmt.dateTime(at, context.lang), style: context.text.labelSmall),
                                    ]),
                                  ),
                                  if (unread)
                                    Padding(
                                      padding: const EdgeInsets.only(left: Space.sm, top: Space.sm),
                                      child: Container(
                                        width: Sizes.dot + Space.xxs,
                                        height: Sizes.dot + Space.xxs,
                                        decoration: BoxDecoration(color: context.paw.marigold, shape: BoxShape.circle),
                                      ),
                                    ),
                                ]),
                              ),
                            ),
                          ),
                        ]);
                      },
                    ),
            ),
          ]);
        },
      ),
    );
  }
}

/// Per-type channel choices (push, email, SMS, WhatsApp) and quiet hours.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final isDemo = ref.watch(appConfigProvider).isDemo;
    final types = [
      ('vaccines', l.ntVaccines, Ph.syringe),
      ('medicines', l.ntMedicines, Ph.pill),
      ('deworming', l.ntDeworming, Ph.bug),
      ('bookings', l.ntBookings, Ph.calendarCheck),
      ('routine', l.ntRoutine, Ph.personSimpleWalk),
      ('custom', l.ntCustom, Ph.alarm),
    ];
    final channels = [('push', l.chPush), ('email', l.chEmail), ('sms', l.chSms), ('whatsapp', l.chWhatsApp)];
    String hour(int h) => Fmt.time(DateTime(2000, 1, 1, h), context.lang);
    return Scaffold(
      appBar: AppBar(title: Text(l.notificationChannels)),
      body: PageBody(maxWidth: Space.formWidth, children: [
        if (isDemo) ...[const SizedBox(height: Space.sm), DemoBanner(l.channelsDemoNote)],
        const SizedBox(height: Space.sm),
        OutlinedButton.icon(
          icon: const Icon(Ph.bellRinging),
          label: Text(l.allowNotifications),
          onPressed: () async {
            final ok = await ref.read(notificationServiceProvider).requestPermission();
            if (context.mounted) showToast(context, ok ? l.notificationsOn : l.notificationsOffHint);
          },
        ),
        for (final t in types) ...[
          SectionHeader(t.$2),
          PawCard(
            child: Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              for (final c in channels)
                FilterChip(
                  label: Text(c.$2),
                  selected: s.channelsFor(t.$1).contains(c.$1),
                  onSelected: (on) {
                    final cur = {...s.channelsFor(t.$1)};
                    on ? cur.add(c.$1) : cur.remove(c.$1);
                    n.setChannels(t.$1, cur.toList());
                  },
                ),
            ]),
          ),
        ],
        SectionHeader(l.quietHours),
        PawCard(
          child: Column(children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: s.quietHoursOn,
              onChanged: (v) => n.setQuietHours(on: v),
              title: Text(l.quietHoursOn),
              subtitle: Text(l.quietHoursHint),
            ),
            if (s.quietHoursOn)
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: s.quietStart,
                    decoration: InputDecoration(labelText: l.from),
                    items: [for (var h = 18; h <= 23; h++) DropdownMenuItem(value: h, child: Text(hour(h)))],
                    onChanged: (v) => n.setQuietHours(start: v),
                  ),
                ),
                const SizedBox(width: Space.md),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: s.quietEnd,
                    decoration: InputDecoration(labelText: l.to),
                    items: [for (var h = 5; h <= 10; h++) DropdownMenuItem(value: h, child: Text(hour(h)))],
                    onChanged: (v) => n.setQuietHours(end: v),
                  ),
                ),
              ]),
          ]),
        ),
      ]),
    );
  }
}
