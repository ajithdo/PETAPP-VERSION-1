import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'illustrations.dart';
import 'media_image.dart';

/// Pet photo (or illustrated face) inside the pet's colour-tag ring.
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
  });

  final String species;
  final String? colorTag;
  final String? photoUrl;
  final double size;
  final String? name;
  final bool selected;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final ring = PetTagColors.of(colorTag);
    final inner = size - (size > 60 ? 8 : 6);
    Widget face = ClipOval(
      child: photoUrl != null
          ? MediaImage(url: photoUrl!, width: inner, height: inner, fit: BoxFit.cover)
          : PetFace(species: species, color: ring, size: inner),
    );
    if (heroTag != null) face = Hero(tag: heroTag!, child: face);
    return Semantics(
      label: name,
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size > 60 ? 3 : 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ring, width: selected ? 3 : 2),
          color: context.paw.surface,
        ),
        child: face,
      ),
    );
  }
}
