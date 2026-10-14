import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/data/converters.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/vault_models.dart';
import 'sample_docs.dart';
import 'vault_labels.dart';

/// The date printed on a sample document.
DateTime sampleIssuedOn(VaultDoc d) =>
    parseDate(d.raw['sampleIssuedOn']) ?? parseDate(d.extracted?['issuedOn']) ?? d.createdAt.subtract(const Duration(days: 1));

/// Secure preview of a vault file: rendered on the device (samples and
/// PDFs as page images, photos from memory), never saved to the gallery.
class DocPreview extends ConsumerWidget {
  const DocPreview({super.key, required this.doc, required this.petName, this.onTap});
  final VaultDoc doc;
  final String petName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final Widget body;
    if (doc.isSample) {
      body = AspectRatio(
        aspectRatio: SampleDocument.size.aspectRatio,
        child: FittedBox(child: SampleDocument(sampleKey: doc.sampleKey!, petName: petName, issuedOn: sampleIssuedOn(doc))),
      );
    } else if (doc.url == null) {
      body = _Placeholder(type: doc.type, text: l.vaultPreviewFailed);
    } else if (doc.isPdf) {
      body = _PdfPages(url: doc.url!, title: doc.title);
    } else if (doc.isImage || doc.url!.startsWith('seed:')) {
      body = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 560),
        child: MediaImage(url: doc.url!, fit: BoxFit.contain, semanticLabel: doc.title),
      );
    } else {
      body = _Placeholder(type: doc.type, text: l.vaultPreviewFailed);
    }
    return Semantics(
      label: '${doc.title}. ${l.vaultTapToZoom}',
      button: onTap != null,
      child: Material(
        color: context.paw.background,
        borderRadius: BorderRadius.circular(Radii.button),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.paw.outline),
              borderRadius: BorderRadius.circular(Radii.button),
            ),
            child: Center(child: body),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.type, required this.text});
  final String type;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          DocTypeBadge(type: type, size: 64),
          const SizedBox(height: Space.md),
          Text(text, textAlign: TextAlign.center, style: context.text.bodySmall),
        ]),
      );
}

final _pdfPagesProvider = FutureProvider.autoDispose.family<List<Uint8List>, String>((ref, url) async {
  final bytes = await ref.read(storageServiceProvider).read(url);
  if (bytes == null) throw StateError('missing file');
  final out = <Uint8List>[];
  await for (final page in Printing.raster(bytes, pages: const [0, 1, 2], dpi: 110)) {
    out.add(await page.toPng());
  }
  return out;
});

class _PdfPages extends ConsumerWidget {
  const _PdfPages({required this.url, required this.title});
  final String url;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = ref.watch(_pdfPagesProvider(url));
    return pages.when(
      loading: () => const Padding(padding: EdgeInsets.all(Space.xl), child: CircularProgressIndicator()),
      error: (_, _) => _Placeholder(type: 'other', text: '${context.l10n.vaultPdf} · ${context.l10n.vaultPreviewFailed}'),
      data: (imgs) => Column(mainAxisSize: MainAxisSize.min, children: [
        for (final p in imgs)
          Padding(
            padding: const EdgeInsets.all(Space.sm),
            child: Image.memory(p, semanticLabel: title, gaplessPlayback: true),
          ),
      ]),
    );
  }
}

/// Full-screen, zoomable view of a document.
Future<void> openDocViewer(BuildContext context, VaultDoc doc, String petName) {
  return Navigator.of(context).push(MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (ctx) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(doc.title, overflow: TextOverflow.ellipsis),
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Space.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: DocPreview(doc: doc, petName: petName),
            ),
          ),
        ),
      ),
    ),
  ));
}
