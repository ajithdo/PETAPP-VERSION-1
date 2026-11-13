import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/service_providers.dart';
import '../services/storage_service.dart';
import '../theme/tokens.dart';
import 'illustrations.dart';
import '../theme/ph.dart';

/// Shows an image from any of our URL kinds:
///  - mem://id        standalone demo upload
///  - seed:kind:n     placeholder for demo data: a bundled demo photo where
///                     there is one, otherwise an illustration
///  - asset:path      a photo bundled with the app (demo pets)
///  - http(s)://...   Cloud Storage or network, kept in a disk cache on
///                     phones (the browser's cache on the web) and decoded
///                     at the size shown
class MediaImage extends ConsumerWidget {
  const MediaImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover, this.semanticLabel});
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (url.startsWith('seed:')) {
      return SeedArt(seed: url, width: width, height: height);
    }
    if (url.startsWith('asset:')) {
      return Image.asset(url.substring(6), width: width, height: height, fit: fit, semanticLabel: semanticLabel, gaplessPlayback: true);
    }
    if (url.startsWith('mem://')) {
      final cached = DemoStorageService.cached(url);
      if (cached != null) return _mem(cached);
      return FutureBuilder<Uint8List?>(
        future: ref.read(storageServiceProvider).read(url),
        builder: (context, snap) {
          if (snap.data != null) return _mem(snap.data!);
          return SizedBox(width: width, height: height, child: ColoredBox(color: context.paw.outline));
        },
      );
    }
    final image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: width != null && width!.isFinite ? (width! * 2).round() : null,
      placeholder: (context, _) => SizedBox(width: width, height: height, child: ColoredBox(color: context.paw.outline)),
      errorWidget: (context, _, _) => SizedBox(
        width: width,
        height: height,
        child: Icon(Ph.imageBroken, color: context.paw.textSecondary),
      ),
    );
    return semanticLabel == null ? image : Semantics(image: true, label: semanticLabel, child: image);
  }

  Widget _mem(Uint8List bytes) => Image.memory(bytes,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      cacheWidth: width != null && width!.isFinite ? (width! * 2).round() : null,
      gaplessPlayback: true);
}

/// Illustrated placeholder "photo" for demo data, e.g. seed:album:dog:bruno:3.
class SeedArt extends StatelessWidget {
  const SeedArt({super.key, required this.seed, this.width, this.height});
  final String seed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // Demo photos (public domain) for clinics, providers and album pictures.
    final photo = demoPhotoFor(seed);
    if (photo != null) {
      return SizedBox(width: width, height: height, child: Image.asset(photo, width: width, height: height, fit: BoxFit.cover, gaplessPlayback: true));
    }
    final parts = seed.split(':');
    final n = int.tryParse(parts.last) ?? seed.hashCode;
    final pal = SeedArtColors.pairs[n.abs() % SeedArtColors.pairs.length];
    final species = parts.length > 3 ? parts[2] : null;
    final kind = parts.length > 1 ? parts[1] : '';
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [pal[0], Color.lerp(pal[0], pal[1], 0.45)!],
          ),
        ),
        child: LayoutBuilder(builder: (context, c) {
          final s = c.biggest.shortestSide.isFinite ? c.biggest.shortestSide : 120.0;
          if (species != null) {
            return Center(child: PetFace(species: species, color: pal[1], size: s * 0.7));
          }
          final icon = switch (kind) {
            'clinic' => Ph.firstAid,
            'product' => Ph.bag,
            'provider' => Ph.scissors,
            'doc' => Ph.fileText,
            _ => Ph.pawPrint,
          };
          return Center(child: Icon(icon, size: s * 0.38, color: pal[1]));
        }),
      ),
    );
  }
}

/// The drawn demo pets that have their own album scenes.
const demoPetKeys = {'bruno', 'misty', 'simba', 'kiwi', 'coco', 'tiger', 'max', 'luna', 'sheru'};

/// The pet whose drawings stand in for a species when no pet is named.
const _speciesPet = {'dog': 'bruno', 'cat': 'misty', 'rabbit': 'coco', 'bird': 'kiwi'};

/// Number of drawn shopfronts (the design kit has five).
const _shopfronts = 5;

/// Number of drawn album scenes per pet (park, beach, festival, home, rain,
/// party, bath, night, vet).
const _albumScenes = 9;

/// The bundled demo drawing for a placeholder seed ("seed:clinic:3",
/// "seed:provider:1", "seed:album:dog:bruno:2" or "seed:album:dog:2"), or null
/// to draw the plain illustration. The drawings come from the UI Design 6 kit.
String? demoPhotoFor(String seed) {
  final parts = seed.split(':');
  if (parts.length < 3) return null;
  final n = (int.tryParse(parts.last) ?? seed.hashCode).abs();
  switch (parts[1]) {
    case 'clinic':
      return 'assets/images/demo/places/clinic_${n % _shopfronts}.png';
    // The same shopfront with "24" on its sign (round-the-clock clinics).
    case 'clinic24':
      return 'assets/images/demo/places/clinic24_${n % _shopfronts}.png';
    case 'provider':
      return 'assets/images/demo/places/provider_${n % _shopfronts}.png';
    case 'album' when parts.length > 3:
      final named = parts.length > 4 && demoPetKeys.contains(parts[3]) ? parts[3] : null;
      final pet = named ?? _speciesPet[parts[2]];
      return pet == null ? null : 'assets/images/demo/album/${pet}_${n % _albumScenes}.png';
    default:
      return null;
  }
}
