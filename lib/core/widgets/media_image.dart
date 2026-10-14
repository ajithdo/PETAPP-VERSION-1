import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/service_providers.dart';
import '../services/storage_service.dart';
import '../theme/tokens.dart';
import 'illustrations.dart';

/// Shows an image from any of our URL kinds:
///  - mem://id        standalone demo upload
///  - seed:kind:n     illustrated placeholder for demo data (no real photos)
///  - http(s)://...   Cloud Storage or network
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
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      cacheWidth: width != null && width!.isFinite ? (width! * 2).round() : null,
      errorBuilder: (_, _, _) => SizedBox(
        width: width,
        height: height,
        child: Icon(Icons.broken_image_rounded, color: context.paw.textSecondary),
      ),
    );
  }

  Widget _mem(Uint8List bytes) => Image.memory(bytes,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      cacheWidth: width != null && width!.isFinite ? (width! * 2).round() : null,
      gaplessPlayback: true);
}

/// Illustrated placeholder "photo" for demo data, e.g. seed:album:dog:3.
class SeedArt extends StatelessWidget {
  const SeedArt({super.key, required this.seed, this.width, this.height});
  final String seed;
  final double? width;
  final double? height;

  static const _palettes = [
    [Color(0xFF99F6E4), Color(0xFF0F766E)],
    [Color(0xFFFDE7D3), Color(0xFFF4A261)],
    [Color(0xFFDDD6FE), Color(0xFF9B8AFB)],
    [Color(0xFFBAE6FD), Color(0xFF38BDF8)],
    [Color(0xFFFBCFE8), Color(0xFFF472B6)],
    [Color(0xFFBBF7D0), Color(0xFF34D399)],
    [Color(0xFFF5E6CC), Color(0xFFD6B98C)],
    [Color(0xFFCCFBF1), Color(0xFFF4A261)],
  ];

  @override
  Widget build(BuildContext context) {
    final parts = seed.split(':');
    final n = int.tryParse(parts.last) ?? seed.hashCode;
    final pal = _palettes[n.abs() % _palettes.length];
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
            'clinic' => Icons.local_hospital_rounded,
            'product' => Icons.shopping_bag_rounded,
            'provider' => Icons.content_cut_rounded,
            'doc' => Icons.description_rounded,
            _ => Icons.pets_rounded,
          };
          return Center(child: Icon(icon, size: s * 0.38, color: pal[1]));
        }),
      ),
    );
  }
}
