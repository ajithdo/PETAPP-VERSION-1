import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/demo/seed/seed_places.dart';
import '../../../core/providers.dart';
import '../../../core/services/service_providers.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/photo_picker.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/presentation/auth_widgets.dart';
import '../../booking/presentation/booking_labels.dart';
import '../data/partner_signup_repository.dart';

/// Partner sign-up (spec 6): business type, details, KYC documents and the
/// account. It ends on the partner dashboard with "Waiting for approval".
class PartnerSignupScreen extends ConsumerStatefulWidget {
  const PartnerSignupScreen({super.key});
  @override
  ConsumerState<PartnerSignupScreen> createState() => _PartnerSignupScreenState();
}

class _PartnerSignupScreenState extends ConsumerState<PartnerSignupScreen> {
  final _form = GlobalKey<FormState>();
  final _business = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _vcReg = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _kind = 'groomer';
  String _area = 'banjara';
  final _docs = <({String name, Uint8List? bytes})>[];
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_business, _phone, _address, _vcReg, _name, _email, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _addDoc() async {
    final pick = await pickImage(context, ImageSource.gallery);
    if (pick != null) setState(() => _docs.add((name: pick.name, bytes: pick.bytes)));
  }

  Future<void> _submit() async {
    final l = context.l10n;
    if (!(_form.currentState?.validate() ?? false)) return;
    if (_docs.isEmpty) {
      setState(() => _error = l.kycNeeded);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    // Read everything needed before the account exists: signing up makes
    // the router move to email verification and this screen goes away.
    final auth = ref.read(authServiceProvider);
    final storage = ref.read(storageServiceProvider);
    final repo = ref.read(partnerSignupRepositoryProvider);
    final language = ref.read(settingsProvider).locale;
    final app = PartnerApplication(
      kind: _kind,
      businessName: _business.text,
      areaKey: _area,
      phone: _phone.text,
      address: _address.text,
      vcRegNo: _kind == 'clinic' ? _vcReg.text.trim() : null,
      kycDocs: [for (final d in _docs) d.name],
    );
    try {
      var user = ref.read(currentUserProvider);
      if (user == null) {
        await auth.signUpWithEmail(_name.text.trim(), _email.text, _password.text);
        user = auth.current;
      }
      if (user == null) throw StateError('no user');
      for (final d in _docs.where((d) => d.bytes != null)) {
        await storage.upload(d.bytes!, path: 'partners/${user.uid}/kyc/${d.name}', contentType: 'image/jpeg');
      }
      await repo.submit(user.uid, language, app);
      if (mounted) context.go('/partner');
    } catch (e) {
      if (mounted) setState(() => _error = authErrorText(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final signedIn = ref.watch(currentUserProvider) != null;
    final demo = ref.watch(appConfigProvider).isDemo;
    return AuthScaffold(
      showBack: true,
      title: l.partnerSignupTitle,
      subtitle: l.partnerSignupSubtitle,
      children: [
        Form(
          key: _form,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l.businessType, style: context.text.titleSmall),
            const SizedBox(height: Space.sm),
            ChoiceRow<String>(
              options: partnerKinds,
              selected: _kind,
              onSelected: (k) => setState(() => _kind = k),
              label: (k) => k == 'seller' ? l.kindSeller : kindLabel(context, k),
              icons: kindIcon,
            ),
            const SizedBox(height: Space.lg),
            PawTextField(
              label: l.businessName,
              controller: _business,
              prefixIcon: Icons.storefront_rounded,
              validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _area,
              isExpanded: true,
              decoration: InputDecoration(labelText: l.areaCity, prefixIcon: const Icon(Icons.place_rounded)),
              items: [
                for (final e in areas.entries) DropdownMenuItem(value: e.key, child: Text('${e.value.name}, ${e.value.city}')),
              ],
              onChanged: (v) => setState(() => _area = v ?? _area),
            ),
            const SizedBox(height: Space.md),
            PawTextField(
              label: l.businessPhone,
              controller: _phone,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.call_rounded,
              validator: (v) => (v == null || v.replaceAll(RegExp(r'\D'), '').length < 10) ? l.phoneInvalid : null,
            ),
            PawTextField(label: l.businessAddress, controller: _address, prefixIcon: Icons.home_work_rounded),
            if (_kind == 'clinic')
              PawTextField(
                label: l.vcRegNumber,
                controller: _vcReg,
                helper: l.vcRegHelp,
                prefixIcon: Icons.verified_user_rounded,
                validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
              ),
            const SizedBox(height: Space.sm),
            Text(l.kycDocuments, style: context.text.titleSmall),
            const SizedBox(height: Space.xs),
            Text(l.kycHelp, style: context.text.bodySmall),
            const SizedBox(height: Space.sm),
            for (final d in _docs)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.description_rounded, color: context.colors.primary),
                title: Text(d.name),
                trailing: IconButton(
                  tooltip: l.remove,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => setState(() => _docs.remove(d)),
                ),
              ),
            Wrap(spacing: Space.sm, runSpacing: Space.sm, children: [
              OutlinedButton.icon(onPressed: _addDoc, icon: const Icon(Icons.upload_file_rounded), label: Text(l.uploadKyc)),
              if (demo)
                TextButton(
                  onPressed: () => setState(() => _docs.add((name: l.sampleIdProof, bytes: null))),
                  child: Text(l.useSampleDoc),
                ),
            ]),
            if (!signedIn) ...[
              const SizedBox(height: Space.lg),
              Text(l.yourAccount, style: context.text.titleSmall),
              const SizedBox(height: Space.sm),
              PawTextField(
                label: l.yourName,
                controller: _name,
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.trim().isEmpty) ? l.fieldRequired : null,
              ),
              PawTextField(
                label: l.email,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                validator: (v) => validateEmail(context, v),
              ),
              PawTextField(
                label: l.password,
                controller: _password,
                obscure: true,
                helper: l.passwordHelper,
                prefixIcon: Icons.lock_outline_rounded,
                validator: (v) => (v == null || v.length < 6) ? l.authErrWeakPassword : null,
              ),
            ],
          ]),
        ),
        const SizedBox(height: Space.md),
        if (_error != null) ...[
          InfoNote(_error!, icon: Icons.error_outline_rounded, tone: ChipTone.error),
          const SizedBox(height: Space.md),
        ],
        PrimaryButton(label: l.submitApplication, loading: _busy, onPressed: _submit),
        const SizedBox(height: Space.md),
        Text(l.partnerApprovalNote, style: context.text.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}
