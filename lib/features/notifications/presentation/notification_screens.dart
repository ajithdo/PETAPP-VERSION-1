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
        'vaccines' => Icons.vaccines_rounded,
        'medicines' => Icons.medication_rounded,
        'deworming' => Icons.bug_report_rounded,
        'bookings' => Icons.event_available_rounded,
        'messages' => Icons.chat_rounded,
        'orders' => Icons.local_shipping_rounded,
        'lost' => Icons.travel_explore_rounded,
        'device' => Icons.watch_rounded,
        'sos' => Icons.emergency_rounded,
        'support' => Icons.support_agent_rounded,
        'account' => Icons.verified_user_rounded,
        'plan' => Icons.workspace_premium_rounded,
        _ => Icons.notifications_rounded,
      };

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
            child: Text(l.markAllRead),
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.tune_rounded),
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
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: context.gutter),
                      itemCount: list.length + (more ? 1 : 0),
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        if (i == list.length) {
                          return ShowMoreButton(onPressed: () => ref.read(listLimitProvider('notifications').notifier).more());
                        }
                        final d = list[i].data();
                        final unread = d['read'] != true;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: unread ? context.paw.primaryContainer : context.paw.outline.withValues(alpha: 0.5),
                            child: Icon(_icon(d['type'] as String?), color: context.colors.primary),
                          ),
                          title: Text((d['title'] as String?) ?? '', style: unread ? const TextStyle(fontWeight: FontWeight.w700) : null),
                          subtitle: Text([
                            if ((d['body'] as String?)?.isNotEmpty == true) d['body'] as String,
                            Fmt.dateTime(parseDate(d['createdAt']) ?? DateTime.now(), context.lang),
                          ].join(' · ')),
                          onTap: () async {
                            await list[i].reference.update({'read': true});
                            final link = d['link'] as String?;
                            if (link != null && context.mounted) context.push(link);
                          },
                        );
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
      ('vaccines', l.ntVaccines, Icons.vaccines_rounded),
      ('medicines', l.ntMedicines, Icons.medication_rounded),
      ('deworming', l.ntDeworming, Icons.bug_report_rounded),
      ('bookings', l.ntBookings, Icons.event_available_rounded),
      ('routine', l.ntRoutine, Icons.directions_walk_rounded),
      ('custom', l.ntCustom, Icons.alarm_rounded),
    ];
    final channels = [('push', l.chPush), ('email', l.chEmail), ('sms', l.chSms), ('whatsapp', l.chWhatsApp)];
    String hour(int h) => Fmt.time(DateTime(2000, 1, 1, h), context.lang);
    return Scaffold(
      appBar: AppBar(title: Text(l.notificationChannels)),
      body: PageBody(maxWidth: 720, children: [
        if (isDemo) ...[const SizedBox(height: Space.sm), DemoBanner(l.channelsDemoNote)],
        const SizedBox(height: Space.sm),
        OutlinedButton.icon(
          icon: const Icon(Icons.notifications_active_rounded),
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
