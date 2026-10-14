import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../theme/tokens.dart';
import '../utils/widget_capture.dart';
import 'widgets.dart';

/// Builds A4 page widgets into images and shows them with Share / Download.
/// Used by the health report, prescriptions, invoices, QR tags and posters.
class DocumentPreviewScreen extends StatefulWidget {
  const DocumentPreviewScreen({super.key, required this.title, required this.fileName, required this.pages});
  final String title;
  final String fileName;

  /// Each page is an A4-sized (595 × 842) widget.
  final List<Widget> Function(BuildContext context) pages;

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  List<Uint8List>? _images;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_images == null && _error == null) _render();
  }

  Future<void> _render() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    try {
      final view = View.of(context);
      final theme = Theme.of(context);
      final pages = widget.pages(context);
      final out = <Uint8List>[];
      for (final p in pages) {
        if (!mounted) return;
        out.add(await renderWidgetToPng(p, view: view, theme: theme, logicalSize: a4Logical, pixelRatio: 2));
      }
      if (mounted) setState(() => _images = out);
    } catch (e) {
      debugPrint('Document render failed: $e');
      if (mounted) setState(() => _error = '$e');
    }
  }

  Future<void> _share() async {
    final pdf = await pngPagesToPdf(_images!, title: widget.title);
    await Printing.sharePdf(bytes: pdf, filename: widget.fileName);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_images != null)
            IconButton(tooltip: l.sharePdf, onPressed: _share, icon: const Icon(Icons.ios_share_rounded)),
        ],
      ),
      body: _error != null
          ? ErrorState(onRetry: () {
              setState(() => _error = null);
              _render();
            })
          : _images == null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: Space.md),
                  Text(l.preparingDocument),
                ]))
              : Column(children: [
                  Expanded(
                    child: InteractiveViewer(
                      maxScale: 4,
                      child: ListView(
                        padding: EdgeInsets.all(context.gutter),
                        children: [
                          for (final img in _images!)
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: Space.lg),
                                constraints: const BoxConstraints(maxWidth: 700),
                                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12)]),
                                child: Image.memory(img, semanticLabel: widget.title),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.all(context.gutter),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: PrimaryButton(label: l.sharePdf, icon: Icons.ios_share_rounded, onPressed: _share),
                      ),
                    ),
                  ),
                ]),
    );
  }
}

/// Shared look for generated A4 pages: header band, body, footer.
class A4Page extends StatelessWidget {
  const A4Page({super.key, required this.title, required this.subtitle, required this.children, required this.footer, this.pageLabel});
  final String title;
  final String subtitle;
  final List<Widget> children;
  final String footer;
  final String? pageLabel;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0F766E);
    return Container(
      color: Colors.white,
      width: a4Logical.width,
      height: a4Logical.height,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: teal,
          padding: const EdgeInsets.fromLTRB(32, 22, 32, 18),
          child: Row(children: [
            const _MiniLogo(),
            const SizedBox(width: 10),
            const Text('PawSetu', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans')),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: Color(0xFFCCFBF1), fontSize: 9)),
            ]),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 18, 32, 8),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Color(0xFF1C2B2D), fontSize: 10, height: 1.35),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 14),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE5E1DA)))),
          child: Row(children: [
            Expanded(child: Text(footer, style: const TextStyle(color: Color(0xFF5B6B6E), fontSize: 8))),
            if (pageLabel != null) Text(pageLabel!, style: const TextStyle(color: Color(0xFF5B6B6E), fontSize: 8)),
          ]),
        ),
      ]),
    );
  }
}

class _MiniLogo extends StatelessWidget {
  const _MiniLogo();
  @override
  Widget build(BuildContext context) => Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: const Icon(Icons.pets_rounded, size: 18, color: Color(0xFF0F766E)),
      );
}

/// Section title + simple table used on generated pages.
class A4Section extends StatelessWidget {
  const A4Section({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFF0F766E), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 4),
          child,
        ]),
      );
}

class A4Table extends StatelessWidget {
  const A4Table({super.key, required this.header, required this.rows, this.flex});
  final List<String> header;
  final List<List<String>> rows;
  final List<int>? flex;
  @override
  Widget build(BuildContext context) {
    Widget row(List<String> cells, {bool head = false}) => Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
            color: head ? const Color(0xFFF1EDE8) : null,
            border: const Border(bottom: BorderSide(color: Color(0xFFE5E1DA))),
          ),
          child: Row(children: [
            for (var i = 0; i < cells.length; i++)
              Expanded(
                flex: flex?[i] ?? 1,
                child: Text(cells[i], style: TextStyle(fontSize: head ? 8.5 : 9.5, fontWeight: head ? FontWeight.w700 : FontWeight.w400)),
              ),
          ]),
        );
    return Column(children: [
      row(header, head: true),
      if (rows.isEmpty) row([for (final _ in header) '–']),
      for (final r in rows) row(r),
    ]);
  }
}
