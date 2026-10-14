import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Renders a widget off screen to a PNG. Used for PDFs (health report,
/// prescriptions, invoices, QR tags, posters): Flutter shapes Hindi and
/// Telugu text correctly, which the PDF library cannot do on its own.
Future<Uint8List> renderWidgetToPng(
  Widget widget, {
  required ui.FlutterView view,
  required ThemeData theme,
  required Size logicalSize,
  double pixelRatio = 2.0,
}) async {
  final boundary = RenderRepaintBoundary();
  final renderView = RenderView(
    view: view,
    child: RenderPositionedBox(alignment: Alignment.topLeft, child: boundary),
    configuration: ViewConfiguration(
      logicalConstraints: BoxConstraints.tight(logicalSize),
      physicalConstraints: BoxConstraints.tight(logicalSize * pixelRatio),
      devicePixelRatio: pixelRatio,
    ),
  );
  final pipeline = PipelineOwner()..rootNode = renderView;
  renderView.prepareInitialFrame();
  final buildOwner = BuildOwner(focusManager: FocusManager());
  final root = RenderObjectToWidgetAdapter<RenderBox>(
    container: boundary,
    child: MediaQuery(
      data: MediaQueryData(size: logicalSize, devicePixelRatio: pixelRatio),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: theme,
          child: DefaultTextStyle(style: theme.textTheme.bodyMedium!, child: SizedBox.fromSize(size: logicalSize, child: widget)),
        ),
      ),
    ),
  ).attachToRenderTree(buildOwner);
  buildOwner.buildScope(root);
  buildOwner.finalizeTree();
  pipeline.flushLayout();
  pipeline.flushCompositingBits();
  pipeline.flushPaint();
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

/// A4 at 72 dpi in logical pixels.
const a4Logical = Size(595, 842);

/// Wraps page images into an A4 PDF.
Future<Uint8List> pngPagesToPdf(List<Uint8List> pages, {String title = 'PawSetu'}) async {
  final doc = pw.Document(title: title, author: 'PawSetu');
  for (final p in pages) {
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (_) => pw.Image(pw.MemoryImage(p), fit: pw.BoxFit.contain),
    ));
  }
  return doc.save();
}
