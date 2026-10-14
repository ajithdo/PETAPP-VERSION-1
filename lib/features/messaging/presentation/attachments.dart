import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/widget_capture.dart';
import '../../../core/widgets/document_preview.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../data/chat_models.dart';
import '../data/chat_repository.dart';

/// A file the user picked to send in a chat.
typedef PickedFile = ({Uint8List bytes, String name, String contentType});

/// Max PDF size for chat (the storage rules allow 25 MB).
const maxChatPdfBytes = 10 * 1024 * 1024;

/// Asks what to attach: gallery photo, camera photo or a PDF file.
Future<(String type, PickedFile file)?> pickChatAttachment(BuildContext context) async {
  final l = context.l10n;
  final choice = await showPawSheet<String>(
    context,
    builder: (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(l.msgAttachTitle, style: ctx.text.titleMedium),
      const SizedBox(height: Space.md),
      ListTile(leading: const Icon(Icons.photo_library_rounded), title: Text(l.chooseFromGallery), onTap: () => Navigator.pop(ctx, 'gallery')),
      ListTile(leading: const Icon(Icons.photo_camera_rounded), title: Text(l.takePhoto), onTap: () => Navigator.pop(ctx, 'camera')),
      ListTile(
        leading: const Icon(Icons.picture_as_pdf_rounded),
        title: Text(l.msgAttachPdf),
        subtitle: Text(l.msgAttachPdfHint),
        onTap: () => Navigator.pop(ctx, 'pdf'),
      ),
    ]),
  );
  if (choice == null || !context.mounted) return null;
  if (choice == 'pdf') {
    final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['pdf']);
    if (f == null) return null;
    final bytes = await f.readAsBytes();
    if (bytes.length > maxChatPdfBytes) {
      if (context.mounted) showToast(context, l.msgPdfTooBig);
      return null;
    }
    return ('pdf', (bytes: bytes, name: f.name, contentType: 'application/pdf'));
  }
  final img = await pickImage(context, choice == 'camera' ? ImageSource.camera : ImageSource.gallery);
  if (img == null) return null;
  return ('photo', (bytes: img.bytes, name: img.name, contentType: 'image/jpeg'));
}

String fileSizeLabel(int bytes) {
  if (bytes <= 0) return '';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).ceil()} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// Opens a PDF from a chat: prescriptions open the prescription viewer;
/// other files are shared or downloaded (the phone's or browser's PDF
/// viewer opens them). Sample files in the demo are generated on the fly.
Future<void> openChatPdf(BuildContext context, WidgetRef ref, ChatMessage m) async {
  final l = context.l10n;
  if (m.prescriptionId != null) {
    context.push('/prescriptions/${m.prescriptionId}');
    return;
  }
  final url = m.url;
  if (url == null) return;
  final name = m.fileName ?? 'document.pdf';
  try {
    if (url.startsWith('http')) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return;
    }
    Uint8List? bytes;
    if (url.startsWith('seed:')) {
      bytes = await samplePdf(context, name);
    } else {
      bytes = await ref.read(chatRepositoryProvider).read(url);
    }
    if (bytes == null) throw StateError('missing file');
    await Printing.sharePdf(bytes: bytes, filename: name);
  } catch (e) {
    debugPrint('Open PDF failed: $e');
    if (context.mounted) showToast(context, l.msgFileCantOpen);
  }
}

/// A one-page "SAMPLE" PDF for demo files that have no real content.
Future<Uint8List> samplePdf(BuildContext context, String title) async {
  final l = context.l10n;
  final page = A4Page(
    title: title,
    subtitle: l.msgSampleStamp,
    footer: l.reportFooter,
    children: [
      const SizedBox(height: 120),
      Center(
        child: Transform.rotate(
          angle: -0.35,
          child: Text(l.msgSampleStamp, style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w800, color: Color(0x33B91C1C))),
        ),
      ),
      const SizedBox(height: 60),
      Text(l.msgSampleDocBody, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
    ],
  );
  final png = await renderWidgetToPng(
    page,
    view: View.of(context),
    theme: AppTheme.build(brightness: Brightness.light, locale: context.lang),
    logicalSize: a4Logical,
  );
  return pngPagesToPdf([png], title: title);
}

/// Full-screen photo with pinch to zoom.
class PhotoViewerScreen extends StatelessWidget {
  const PhotoViewerScreen({super.key, required this.url, this.caption});
  final String url;
  final String? caption;

  static Future<void> open(BuildContext context, String url, {String? caption}) =>
      Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => PhotoViewerScreen(url: url, caption: caption)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: caption == null ? null : Text(caption!, style: const TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: InteractiveViewer(
          maxScale: 5,
          child: Center(child: MediaImage(url: url, fit: BoxFit.contain, semanticLabel: context.l10n.msgPreviewPhoto)),
        ),
      ),
    );
  }
}
