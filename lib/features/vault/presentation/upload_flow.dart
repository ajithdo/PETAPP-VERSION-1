import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../data/vault_repository.dart';
import '../domain/auto_read.dart';
import 'scan_screen.dart';
import 'vault_labels.dart';
import 'vault_screen.dart';

/// Largest file the vault accepts (matches storage.rules).
const maxVaultFileBytes = 25 * 1024 * 1024;

String sampleTitle(BuildContext context, String key) {
  final l = context.l10n;
  return switch (key) {
    'insurance_policy' => l.vaultSampleInsurance,
    'lab_report' => l.vaultSampleLab,
    _ => l.vaultSampleRabies,
  };
}

/// "Add a document": camera scan, photo, PDF, or a demo sample. The file is
/// stored, then the auto-read screen asks the owner to confirm the details.
Future<void> showUploadSheet(BuildContext context, WidgetRef ref, {Pet? pet, bool fixedPet = false}) async {
  final pets = ref.read(activePetsProvider);
  if (pets.isEmpty && pet == null) {
    showToast(context, context.l10n.noPetsTitle);
    return;
  }
  var chosen = pet ?? pets.first;
  final choice = await showPawSheet<String>(context, builder: (ctx) {
    final l = ctx.l10n;
    return StatefulBuilder(builder: (ctx, setState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.vaultUploadTitle, style: ctx.text.titleMedium),
        if (!fixedPet && pets.length > 1) ...[
          const SizedBox(height: Space.md),
          Text(l.vaultForPet, style: ctx.text.titleSmall),
          const SizedBox(height: Space.sm),
          Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
            for (final p in pets)
              ChoiceChip(
                avatar: PetAvatar(species: p.species, colorTag: p.colorTag, photoUrl: p.photoUrl, size: 24),
                label: Text(p.name),
                showCheckmark: false,
                selected: chosen.id == p.id,
                onSelected: (_) => setState(() => chosen = p),
              ),
          ]),
        ],
        const SizedBox(height: Space.md),
        ListTile(
          leading: const Icon(Icons.document_scanner_rounded),
          title: Text(l.vaultScanCamera),
          subtitle: Text(l.vaultScanCameraHint),
          onTap: () => Navigator.pop(ctx, 'scan'),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_rounded),
          title: Text(l.vaultFromGallery),
          onTap: () => Navigator.pop(ctx, 'gallery'),
        ),
        ListTile(
          leading: const Icon(Icons.picture_as_pdf_rounded),
          title: Text(l.vaultFromPdf),
          onTap: () => Navigator.pop(ctx, 'pdf'),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Space.sm),
          child: DemoBanner(l.vaultTrySample),
        ),
        for (final k in uploadSamples)
          ListTile(
            leading: DocTypeBadge(type: sampleDocType(k), size: 36),
            title: Text(sampleTitle(ctx, k)),
            onTap: () => Navigator.pop(ctx, 'sample:$k'),
          ),
      ]);
    });
  });
  if (choice == null || !context.mounted) return;
  await _addFromChoice(context, ref, chosen, choice);
}

Future<void> _addFromChoice(BuildContext context, WidgetRef ref, Pet pet, String choice) async {
  final l = context.l10n;
  final user = ref.read(currentUserProvider);
  if (user == null) return;
  final repo = ref.read(vaultRepositoryProvider);

  if (choice.startsWith('sample:')) {
    final key = choice.substring(7);
    final id = await repo.addDoc(
      pet: pet,
      by: user,
      type: sampleDocType(key),
      title: sampleTitle(context, key),
      url: 'sample:$key',
      contentType: 'sample',
      sizeBytes: 180 * 1024,
      source: 'sample',
      readStatus: 'pending',
      extra: {'sampleIssuedOn': DateTime.now().subtract(const Duration(days: 2))},
    );
    if (context.mounted) context.push('/vault/doc/$id/read?new=1');
    return;
  }

  Uint8List? bytes;
  String name = '';
  String contentType = 'image/jpeg';
  String ext = 'jpg';
  String source = choice;
  try {
    if (choice == 'scan') {
      final p = await pickImage(context, ImageSource.camera);
      if (p == null || !context.mounted) return;
      final scanned = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(fullscreenDialog: true, builder: (_) => ScanCropScreen(bytes: p.bytes)),
      );
      if (scanned == null) return;
      bytes = scanned;
      name = p.name;
      contentType = 'image/png';
      ext = 'png';
    } else if (choice == 'gallery') {
      final p = await pickImage(context, ImageSource.gallery);
      if (p == null) return;
      bytes = p.bytes;
      name = p.name;
    } else {
      final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['pdf']);
      if (f == null) return;
      if ((f.extension ?? '').toLowerCase() != 'pdf') {
        if (context.mounted) showToast(context, l.vaultPdfOnly);
        return;
      }
      bytes = await f.readAsBytes();
      name = f.name;
      contentType = 'application/pdf';
      ext = 'pdf';
    }
  } catch (e) {
    debugPrint('Vault pick failed: $e');
    if (context.mounted) showToast(context, l.errorBody);
    return;
  }
  if (!context.mounted) return;
  if (bytes.length > maxVaultFileBytes) {
    showToast(context, l.vaultTooBig);
    return;
  }
  if (!await ensureStorageRoom(context, ref, bytes.length)) return;
  if (!context.mounted) return;
  showToast(context, l.vaultUploading);
  final stored = await uploadUserFile(ref.read(storageServiceProvider), bytes, uid: user.uid, folder: 'vault', ext: ext, contentType: contentType);
  final type = guessTypeFromName(name);
  final cleanName = name.replaceAll(RegExp(r'\.[A-Za-z0-9]+$'), '').replaceAll(RegExp(r'[_\-]+'), ' ').trim();
  if (!context.mounted) return;
  final id = await repo.addDoc(
    pet: pet,
    by: user,
    type: type,
    title: cleanName.isEmpty || RegExp(r'^(image|img|scan|IMG|photo)?\s*\d*$').hasMatch(cleanName) ? docTypeLabel(context, type) : cleanName,
    url: stored.url,
    contentType: contentType,
    sizeBytes: stored.sizeBytes,
    fileName: name,
    storagePath: stored.path,
    source: source,
    readStatus: 'pending',
  );
  if (context.mounted) context.push('/vault/doc/$id/read?new=1');
}
