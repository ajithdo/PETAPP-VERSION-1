import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'illustrations.dart';
import 'media_image.dart';

/// The arch every pet stands in (UI Design 6 "Toran": pets are arches,
/// people are circles, places and things are rounded tiles). A half circle on
/// top and softly rounded feet.
ShapeBorder archShape(double width, [BorderSide side = BorderSide.none]) => RoundedRectangleBorder(
  side: side,
  borderRadius: BorderRadius.vertical(top: Radius.circular(width / 2), bottom: Radius.circular(width * 0.18)),
);

/// Clips [child] to the pet arch.
class ArchClip extends StatelessWidget {
  const ArchClip({super.key, required this.width, required this.child});
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipPath(clipper: ShapeBorderClipper(shape: archShape(width)), child: child);
}

/// Pet photo (or illustrated face) in its arch, edged in the pet's colour tag.
/// [size] is the height; the arch is [size] / [Sizes.archAspect] wide, so it
/// fits wherever a round avatar of the same size used to.
class PetAvatar extends StatelessWidget {
  const PetAvatar({
    super.key,
    required this.species,
    required this.colorTag,
    this.photoUrl,
    this.size = 48,
    this.name,
    this.selected = false,
    this.heroTag,
    this.ring = true,
  });

  final String species;
  final String? colorTag;
  final String? photoUrl;
  final double size;
  final String? name;
  final bool selected;
  final String? heroTag;

  /// The edge in the pet's colour tag, with a thin gap. Off for small arches
  /// in pills and lists, where the design shows the plain arch.
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final ring = PetTagColors.of(colorTag);
    if (!this.ring) return _plain(context, ring);
    final big = size > Sizes.heroAvatar - Space.md;
    final gap = big ? Space.xxs + Strokes.hairline : Space.xxs - Strokes.hairline;
    final ringWidth = selected ? Strokes.avatarRingSelected : Strokes.avatarRing;
    final width = (size / Sizes.archAspect).roundToDouble();
    final innerW = width - 2 * (gap + Strokes.avatarRing);
    final innerH = size - 2 * (gap + Strokes.avatarRing);
    Widget face = ArchClip(
      width: innerW,
      child: SizedBox(
        width: innerW,
        height: innerH,
        child: photoUrl != null
            ? MediaImage(url: photoUrl!, width: innerW, height: innerH, fit: BoxFit.cover)
            : ColoredBox(
                color: ring.withValues(alpha: Opacities.tintStrong),
                child: Align(alignment: Alignment.bottomCenter, child: PetFace(species: species, color: ring, size: innerW)),
              ),
      ),
    );
    if (heroTag != null) face = Hero(tag: heroTag!, child: face);
    return Semantics(
      label: name,
      image: true,
      child: Container(
        width: width,
        height: size,
        padding: EdgeInsets.all(gap),
        decoration: ShapeDecoration(
          shape: archShape(width, BorderSide(color: ring, width: ringWidth)),
          color: context.paw.surface,
        ),
        child: face,
      ),
    );
  }

  Widget _plain(BuildContext context, Color tag) {
    final width = (size / Sizes.archAspect).roundToDouble();
    Widget face = ArchClip(
      width: width,
      child: SizedBox(
        width: width,
        height: size,
        child: photoUrl != null
            ? MediaImage(url: photoUrl!, width: width, height: size, fit: BoxFit.cover)
            : ColoredBox(
                color: tag.withValues(alpha: Opacities.tintStrong),
                child: Align(alignment: Alignment.bottomCenter, child: PetFace(species: species, color: tag, size: width)),
              ),
      ),
    );
    if (heroTag != null) face = Hero(tag: heroTag!, child: face);
    return Semantics(label: name, image: true, child: face);
  }
}
