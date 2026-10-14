import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../health/data/health_repository.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/album_repository.dart';
import '../domain/album.dart';
import 'album_add.dart';
import 'album_screen.dart';

/// A small birthday celebration (spec 7.11): confetti on the day, a
/// countdown before it, past birthday photos and the yearly reminder.
class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key, required this.petId});
  final String petId;

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _confetti = AnimationController(vsync: this, duration: const Duration(seconds: 6));
  bool _started = false;

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pet = ref.watch(petProvider(widget.petId)).value;
    if (pet == null) {
      return Scaffold(appBar: AppBar(title: Text(l.albumBirthdayScreenTitle)), body: const SkeletonList());
    }
    final now = DateTime.now();
    final birthday = pet.birthday;
    if (birthday == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.albumBirthdayScreenTitle)),
        body: EmptyState(scene: Scene.memory, title: l.albumNoBirthday(pet.name), actionLabel: l.editPet, onAction: () => context.push('/pets/${pet.id}/edit')),
      );
    }
    final next = nextBirthday(birthday, now)!;
    final days = daysUntil(next, now);
    final today = days == 0;
    final age = turningAge(birthday, next);
    if (!_started && !context.reduceMotion) {
      _started = true;
      _confetti.repeat();
      if (today) HapticFeedback.mediumImpact();
    }
    final past = (ref.watch(petAlbumProvider(pet.id)).value ?? const <AlbumItem>[])
        .where((i) => i.milestone == 'birthday' && i.hasMedia)
        .toList()
      ..sort((a, b) => b.takenAt.compareTo(a.takenAt));
    final user = ref.watch(currentUserProvider);
    final reminders = ref.watch(remindersProvider).value ?? const [];
    final reminderOn = reminders.any((r) => r.petId == pet.id && r.type == 'birthday' && !r.done);
    final canLog = user != null && pet.canLog(user.uid);
    return Scaffold(
      appBar: AppBar(title: Text(l.albumBirthdayScreenTitle)),
      body: Stack(children: [
        PageBody(maxWidth: 720, children: [
          const SizedBox(height: Space.xl),
          Center(
            child: Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.paw.accent.withValues(alpha: 0.22)),
              child: Center(child: PetAvatar(species: pet.species, colorTag: pet.colorTag, photoUrl: pet.photoUrl, size: 128)),
            ),
          ),
          const SizedBox(height: Space.lg),
          Icon(Icons.cake_rounded, size: 44, color: context.paw.accent),
          const SizedBox(height: Space.sm),
          Semantics(
            header: true,
            child: Text(
              today ? l.albumBirthdayToday(pet.name) : l.albumBirthdayIn(days, pet.name, age),
              style: context.text.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Space.xs),
          Text(
            today ? l.albumBirthdaySubtitle(age, pet.name) : Fmt.weekdayDate(next, context.lang),
            style: context.text.titleMedium?.copyWith(color: context.paw.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Space.lg),
          PawCard(
            color: context.paw.primaryContainer.withValues(alpha: 0.5),
            child: Text(l.albumBirthdayWishes(pet.name), style: context.text.bodyLarge, textAlign: TextAlign.center),
          ),
          const SizedBox(height: Space.lg),
          if (canLog)
            PrimaryButton(
              label: l.albumBirthdayAddPhoto,
              icon: Icons.add_a_photo_rounded,
              onPressed: () => showAddMemorySheet(context, ref, pet, milestone: 'birthday'),
            ),
          if (user != null && pet.ownerId == user.uid) ...[
            const SizedBox(height: Space.md),
            PawCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                secondary: Icon(Icons.notifications_active_rounded, color: context.colors.primary),
                title: Text(l.albumBirthdayReminder(pet.name)),
                subtitle: reminderOn ? Text(l.albumBirthdayReminderOn) : null,
                value: reminderOn,
                onChanged: (v) => ref.read(albumRepositoryProvider).setBirthdayReminder(
                      pet: pet,
                      ownerId: user.uid,
                      at: next,
                      title: l.albumBirthdayReminderTitle(pet.name),
                      on: v,
                    ),
              ),
            ),
          ],
          if (past.isNotEmpty) ...[
            SectionHeader(l.albumBirthdayMemories),
            MemoryGrid(items: past, onTap: (i) => context.push(viewerPath(pet.id, i.id))),
          ],
          const SizedBox(height: Space.xxl),
        ]),
        if (!context.reduceMotion)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confetti,
                builder: (_, _) => CustomPaint(painter: _ConfettiPainter(_confetti.value, today ? 70 : 24, _palette(context, pet))),
              ),
            ),
          ),
      ]),
    );
  }

  List<Color> _palette(BuildContext context, Pet pet) => [
        context.paw.accent,
        context.colors.primary,
        PetTagColors.of(pet.colorTag),
        PetTagColors.of('lavender'),
        PetTagColors.of('rose'),
        PetTagColors.of('sky'),
      ];
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.count, this.colors);
  final double t;
  final int count;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(7);
    for (var i = 0; i < count; i++) {
      final x0 = r.nextDouble() * size.width;
      final speed = 0.6 + r.nextDouble() * 0.8;
      final phase = r.nextDouble();
      final y = ((t * speed + phase) % 1.0) * (size.height + 40) - 20;
      final x = x0 + math.sin((t * 6 + phase) * math.pi) * 18;
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: 0.85);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate((t * 8 + phase) * math.pi);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-4, -7, 8, 14), const Radius.circular(2)), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
