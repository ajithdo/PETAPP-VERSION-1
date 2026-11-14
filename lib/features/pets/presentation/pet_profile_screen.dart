import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/routing/pet_links.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../data/pets_repository.dart';
import '../domain/pet.dart';
import 'archive_sheet.dart';
import 'pet_labels.dart';
import '../../../core/theme/ph.dart';

/// Pet profile (spec 7.1): hero photo, quick stats, details, family, and
/// sections that later phases fill (Health, Routine, Documents, Memories).
class PetProfileScreen extends ConsumerWidget {
  const PetProfileScreen({super.key, required this.petId});
  final String petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petProvider(petId));
    return Scaffold(
      body: AsyncView<Pet?>(
        value: petAsync,
        onRetry: () => ref.invalidate(petProvider(petId)),
        data: (pet) {
          if (pet == null) {
            return Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                scene: Scene.search,
                title: context.l10n.petNotFound,
                actionLabel: context.l10n.goHome,
                onAction: () => context.go('/home'),
              ),
            );
          }
          return _Profile(pet: pet);
        },
      ),
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider)!;
    final canEdit = pet.canEdit(user.uid);
    final myRole = pet.roleOf(user.uid);
    final age = petAgeLabel(context, pet);
    final weight = pet.weightKg == null ? '–' : Fmt.weight(pet.weightKg!, grams: pet.isBird);

    final paw = context.paw;
    final lang = context.lang;
    final wide = context.screenSize == ScreenSize.desktop;
    const gap = SizedBox(height: Sizes.sectionGap);
    final big = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    // The cover: the pet in a big arch on a marigold wash, with faint
    // doorways behind, the name, and who the pet is.
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(Radii.xxl),
      child: CustomPaint(
        painter: _DoorwayArcs(color: paw.accent.withValues(alpha: Opacities.focus)),
        child: Container(
          color: paw.accentContainer.withValues(alpha: 0),
          foregroundDecoration: const BoxDecoration(),
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, Space.lg + Space.xs),
          child: Column(children: [
            Container(
              decoration: ShapeDecoration(shape: archShape(Sizes.coverArch + 2 * Space.xs, BorderSide(color: paw.surface, width: Space.xs))),
              padding: const EdgeInsets.all(Space.xs),
              child: PetAvatar(
                species: pet.species,
                colorTag: pet.colorTag,
                photoUrl: pet.photoUrl,
                size: (big ? Sizes.coverArch * 0.75 : Sizes.coverArch) * Sizes.archAspect,
                heroTag: 'pet-${pet.id}',
                name: pet.name,
                ring: false,
              ),
            ),
            const SizedBox(height: Space.lg),
            Semantics(header: true, child: Text(pet.name, style: context.text.displaySmall, textAlign: TextAlign.center)),
            Text(
              [pet.breedName(lang), if (age.isNotEmpty) age].where((x) => x.isNotEmpty).join(', '),
              style: context.text.bodyMedium?.copyWith(color: paw.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Space.md),
            Wrap(alignment: WrapAlignment.center, spacing: Space.sm, runSpacing: Space.sm, children: [
              PawTag(lifeStageLabel(context, pet)),
              PawTag(l.youAreRole(petRoleLabel(context, myRole.name).toLowerCase()), kind: TagKind.gold, icon: Ph.userFill),
              if (pet.birthday != null) PawTag(l.birthdayOnDate(Fmt.dateShort(pet.birthday!, lang)), icon: Ph.cakeFill),
              if (pet.flatFaced) PawTag(l.flatFacedChip, kind: TagKind.gold, icon: Ph.thermometerFill),
            ]),
          ]),
        ),
      ),
    );
    // Four facts in one hairline grid.
    Widget stat(IconData icon, String label, String value, {bool right = false, bool bottom = false}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.md + Space.xxs),
          decoration: BoxDecoration(
            border: Border(right: right ? BorderSide(color: paw.outline) : BorderSide.none, bottom: bottom ? BorderSide(color: paw.outline) : BorderSide.none),
          ),
          child: Semantics(
            label: '$label: $value',
            excludeSemantics: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(icon, size: IconSizes.xs, color: paw.textSecondary),
                const SizedBox(width: Space.xs),
                Flexible(child: Text(label, style: context.text.bodySmall?.copyWith(color: paw.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: Space.xxs),
              FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(value, style: context.text.titleLarge?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]))),
            ]),
          ),
        );
    final stats = PawPanel(
      padding: EdgeInsets.zero,
      child: Column(children: [
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: stat(Ph.cake, l.age, age.isEmpty ? '–' : age, right: true, bottom: true)),
            Expanded(child: stat(Ph.scales, l.weight, weight, bottom: true)),
          ]),
        ),
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: stat(pet.gender == 'female' ? Ph.genderFemale : Ph.genderMale, l.gender, genderLabel(context, pet.gender), right: true)),
            Expanded(child: stat(Ph.shieldCheck, l.neutered, pet.neutered ? l.yes : l.no)),
          ]),
        ),
      ]),
    );
    final qr = PawPanel(
      onTap: () => context.push(petQrLink(pet.id)),
      semanticLabel: l.qrActiveTitle,
      child: Row(children: [
        PawTile(icon: Ph.qrCode, size: Sizes.tileLg, fill: paw.surface, ink: paw.textPrimary),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.qrActiveTitle, style: context.text.labelLarge),
            Text(l.qrActiveSub(pet.name), style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
          ]),
        ),
        const SizedBox(width: Space.md),
        const Chev(),
      ]),
    );
    final sections = petSections(context, pet);
    const tones = [Tone.red, Tone.green, Tone.gold, Tone.sky];
    final care = <Widget>[
      SecHead(l.petCare),
      LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth > 560 ? 4 : (MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1 : 2);
        return TileGrid(columns: cols, children: [
          for (final (i, sec) in sections.indexed)
            PawCard(
              padding: const EdgeInsets.all(Space.md + Space.xxs),
              onTap: () => context.push(sec.route),
              semanticLabel: sec.title,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                PawTile(icon: i == 0 ? Ph.heartbeat : sec.icon, tone: tones[i % tones.length]),
                const SizedBox(height: Space.md),
                Text(sec.title, style: context.text.labelLarge),
                Text(sec.subtitle, style: context.text.bodySmall?.copyWith(color: paw.textSecondary)),
              ]),
            ),
        ]);
      }),
    ];
    final clinic = ref.watch(_clinicNameProvider(pet.clinicId)).value;
    String orNone(String? v) => v == null || v.isEmpty ? l.notAdded : v;
    final details = <Widget>[
      SecHead(l.details, action: canEdit ? l.edit : null, onAction: () => context.push('/pets/${pet.id}/edit')),
      PawPanel(
        child: KvList(rows: [
          (l.markings, orNone(pet.markings), null),
          (l.microchip, orNone(pet.microchip), null),
          (l.allergies, pet.allergies.isEmpty ? l.noKnownAllergies : pet.allergies.join(', '), pet.allergies.isEmpty ? null : Tone.red),
          (l.dietType, orNone(pet.dietType), null),
          (l.regularClinic, orNone(clinic), null),
          (l.temperament, orNone(pet.temperament), null),
        ]),
      ),
    ];
    final family = <Widget>[
      SecHead(l.whoLooksAfter(pet.name), action: l.familySharing, onAction: () => context.push('/me/family?pet=${pet.id}')),
      Wrap(spacing: Space.lg, runSpacing: Space.md, crossAxisAlignment: WrapCrossAlignment.center, children: [
        for (final e in pet.members.entries)
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: Sizes.avatarSm,
              height: Sizes.avatarSm,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: e.key == user.uid ? paw.textPrimary : context.tint.paper3, shape: BoxShape.circle),
              child: Text(
                initials(e.value.name),
                style: context.text.labelMedium?.copyWith(color: e.key == user.uid ? paw.background : paw.textPrimary, fontFamily: FontFamilies.heading, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: Space.sm),
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(e.value.name.split(' ').first + (e.key == user.uid ? ' (${l.you})' : ''), style: context.text.labelLarge),
              Text(
                [petRoleLabel(context, e.value.role), if (e.value.expiresAt != null) l.accessUntil(Fmt.dateShort(e.value.expiresAt!, lang))].join(', '),
                style: context.text.bodySmall?.copyWith(color: paw.textSecondary),
              ),
            ]),
          ]),
        IconButton(
          tooltip: l.familySharing,
          onPressed: () => context.push('/me/family?pet=${pet.id}'),
          style: IconButton.styleFrom(
            shape: CircleBorder(side: BorderSide(color: context.tint.line2, width: Strokes.strong)),
            minimumSize: const Size.square(Sizes.topControl),
            fixedSize: const Size.square(Sizes.topControl),
            padding: EdgeInsets.zero,
          ),
          icon: Icon(Ph.plus, size: IconSizes.md, color: paw.textPrimary),
        ),
      ]),
    ];
    Widget col(List<Widget> c) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: c);
    final left = [
      if (pet.archived) ...[_MemorialBanner(pet: pet), gap],
      DecoratedBox(decoration: BoxDecoration(color: paw.accentContainer, borderRadius: BorderRadius.circular(Radii.xxl)), child: cover),
      gap,
      stats,
      if (!pet.archived) ...[gap, qr],
    ];
    final right = [...care, gap, ...details, gap, ...family];
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          if (canEdit)
            IconButton(
              tooltip: l.editPet,
              icon: const Icon(Ph.pencilSimple),
              onPressed: () => context.push('/pets/${pet.id}/edit'),
            ),
          PopupMenuButton<String>(
            tooltip: l.moreOptions,
            icon: const Icon(Ph.dotsThreeVertical),
            onSelected: (v) async {
              switch (v) {
                case 'family':
                  context.push('/me/family?pet=${pet.id}');
                case 'archive':
                  await showArchiveSheet(context, ref, pet);
                case 'restore':
                  await ref.read(petsRepositoryProvider).restorePet(pet.id);
                case 'qr':
                  context.push(petQrLink(pet.id));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'family', child: Text(l.familySharing)),
              if (!pet.archived) PopupMenuItem(value: 'qr', child: Text(l.qrTag)),
              if (pet.canDelete(user.uid) && !pet.archived) PopupMenuItem(value: 'archive', child: Text(l.archivePet)),
              if (pet.canDelete(user.uid) && pet.archived) PopupMenuItem(value: 'restore', child: Text(l.restorePet)),
            ],
          ),
        ],
      ),
      body: PageBody(maxWidth: wide ? Space.maxContentWidth : Space.wideWidth, children: [
        const SizedBox(height: Space.sm),
        if (wide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 5, child: col(left)),
            const SizedBox(width: Space.xl),
            Expanded(flex: 7, child: col(right)),
          ])
        else ...[...left, gap, ...right],
      ]),
    );
  }
}

final _clinicNameProvider = FutureProvider.family<String?, String?>((ref, id) async {
  if (id == null) return null;
  final d = await ref.watch(firestoreProvider).collection('clinics').doc(id).get();
  return d.data()?['name'] as String?;
});

class _MemorialBanner extends StatelessWidget {
  const _MemorialBanner({required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final memorial = pet.memorial;
    return PawCard(
      color: context.paw.accent.withValues(alpha: Opacities.chip),
      child: Row(children: [
        Icon(memorial ? Ph.heartFill : Ph.house, color: context.paw.accent, size: IconSizes.xl),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(memorial ? l.inLovingMemory : l.rehomed, style: context.text.titleMedium),
            if (pet.birthday != null && pet.archivedAt != null)
              Text('${pet.birthday!.year} – ${pet.archivedAt!.year}', style: context.text.bodySmall),
            if (pet.memorialNote != null) ...[
              const SizedBox(height: Space.xs),
              Text(pet.memorialNote!, style: context.text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
            ],
          ]),
        ),
      ]),
    );
  }
}

/// Faint doorway outlines behind the pet's arch in the profile header.
class _DoorwayArcs extends CustomPainter {
  _DoorwayArcs({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = Strokes.strong
      ..color = color;
    final cx = size.width / 2;
    // Two doorways behind the arch: 208 and 272 px wide, standing on the
    // arch's feet.
    final foot = Space.xl + Sizes.coverArch * Sizes.archAspect + Space.xl;
    for (final (w, h) in const [(208.0, 232.0), (272.0, 272.0)]) {
      final r = w / 2;
      final path = Path()
        ..moveTo(cx - r, foot)
        ..lineTo(cx - r, foot - h + r)
        ..arcToPoint(Offset(cx + r, foot - h + r), radius: Radius.circular(r))
        ..lineTo(cx + r, foot);
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(_DoorwayArcs o) => o.color != color;
}
