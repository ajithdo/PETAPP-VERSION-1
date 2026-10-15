import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../data/shop_repository.dart';
import '../domain/shop_models.dart';
import '../domain/shop_rules.dart';

/// Address book (spec 7.10: addresses with PIN code).
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.addrBook)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => editAddress(context, ref),
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(l.addrAdd),
      ),
      body: AsyncView<List<Address>>(
        value: ref.watch(addressesProvider),
        data: (list) => list.isEmpty
            ? EmptyState(title: l.addrNone, message: l.addrNoneBody, actionLabel: l.addrAdd, onAction: () => editAddress(context, ref))
            : PageBody(maxWidth: 720, children: [
                const SizedBox(height: Space.md),
                for (final a in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: AddressCard(
                      address: a,
                      trailing: PopupMenuButton<String>(
                        tooltip: l.moreOptions,
                        onSelected: (v) async {
                          if (v == 'edit') {
                            await editAddress(context, ref, existing: a);
                            return;
                          }
                          if (v == 'delete') {
                            final ok = await confirmAction(context, title: l.addrDeleteQ, body: a.oneLine, confirmLabel: l.delete);
                            if (ok) await ref.read(shopRepositoryProvider).deleteAddress(ref.read(currentUserProvider)!.uid, a.id, list);
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(value: 'edit', child: Text(l.edit)),
                          PopupMenuItem(value: 'delete', child: Text(l.delete)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 80),
              ]),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address, this.trailing, this.selected = false, this.onTap});
  final Address address;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final a = address;
    return PawCard(
      onTap: onTap,
      borderColor: selected ? context.colors.primary : null,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(a.label.toLowerCase() == 'work' ? Icons.work_rounded : Icons.home_rounded, color: context.colors.primary),
        const SizedBox(width: Space.md),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${addressLabel(context, a.label)} · ${a.name}', style: context.text.titleSmall),
            Text(a.oneLine, style: context.text.bodyMedium),
            if (a.phone.isNotEmpty) Text(a.phone, style: context.text.bodySmall),
          ]),
        ),
        if (selected) Icon(Icons.check_circle_rounded, color: context.colors.primary),
        ?trailing,
      ]),
    );
  }
}

String addressLabel(BuildContext context, String label) {
  final l = context.l10n;
  return switch (label.toLowerCase()) { 'home' => l.addrHome, 'work' => l.addrWork, 'other' => l.addrOther, _ => label };
}

/// Lets the person choose a delivery address (or add one).
Future<Address?> pickAddress(BuildContext context, WidgetRef ref, {String? selectedId}) {
  return showPawSheet<Address>(context, builder: (ctx) {
    final l = ctx.l10n;
    return Consumer(builder: (ctx, ref, _) {
      final list = ref.watch(addressesProvider).value ?? const <Address>[];
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.addrChoose, style: ctx.text.titleMedium),
        const SizedBox(height: Space.md),
        for (final a in list)
          Padding(
            padding: const EdgeInsets.only(bottom: Space.sm),
            child: AddressCard(address: a, selected: a.id == selectedId, onTap: () => Navigator.pop(ctx, a)),
          ),
        SecondaryButton(
          label: l.addrAdd,
          icon: Icons.add_location_alt_rounded,
          onPressed: () async {
            final a = await editAddress(ctx, ref);
            if (a != null && ctx.mounted) Navigator.pop(ctx, a);
          },
        ),
      ]);
    });
  });
}

/// Add or edit an address. Returns the saved address.
Future<Address?> editAddress(BuildContext context, WidgetRef ref, {Address? existing}) {
  return showPawSheet<Address>(context, builder: (_) => _AddressForm(existing: existing));
}

class _AddressForm extends ConsumerStatefulWidget {
  const _AddressForm({this.existing});
  final Address? existing;
  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  final _form = GlobalKey<FormState>();
  late String _label = widget.existing?.label ?? 'Home';
  late final _name = TextEditingController(text: widget.existing?.name ?? ref.read(currentUserProvider)?.name ?? '');
  late final _phone = TextEditingController(text: widget.existing?.phone ?? ref.read(currentUserProvider)?.phone ?? '');
  late final _line1 = TextEditingController(text: widget.existing?.line1 ?? '');
  late final _line2 = TextEditingController(text: widget.existing?.line2 ?? '');
  late final _area = TextEditingController(text: widget.existing?.area ?? '');
  late final _city = TextEditingController(text: widget.existing?.city ?? ref.read(currentUserProvider)?.city ?? '');
  late final _pin = TextEditingController(text: widget.existing?.pin ?? '');
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _line1, _line2, _area, _city, _pin]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? need(String? v) => (v ?? '').trim().isEmpty ? l.fieldRequired : null;
    return Form(
      key: _form,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(widget.existing == null ? l.addrAdd : l.addrEdit, style: context.text.titleMedium),
        const SizedBox(height: Space.md),
        Wrap(spacing: Space.sm, children: [
          for (final k in ['Home', 'Work', 'Other'])
            ChoiceChip(label: Text(addressLabel(context, k)), selected: _label == k, onSelected: (_) => setState(() => _label = k)),
        ]),
        const SizedBox(height: Space.md),
        PawTextField(label: l.addrName, controller: _name, validator: need, autofill: const [AutofillHints.name]),
        PawTextField(
          label: l.phone,
          controller: _phone,
          keyboardType: TextInputType.phone,
          autofill: const [AutofillHints.telephoneNumber],
          validator: (v) => RegExp(r'^(\+91[\s-]?)?[6-9]\d{4}[\s-]?\d{5}$').hasMatch((v ?? '').trim()) ? null : l.addrPhoneInvalid,
        ),
        PawTextField(label: l.addrLine1, controller: _line1, validator: need, autofill: const [AutofillHints.streetAddressLine1]),
        PawTextField(label: l.addrLine2, controller: _line2, autofill: const [AutofillHints.streetAddressLine2]),
        PawTextField(label: l.addrArea, controller: _area, validator: need),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: PawTextField(label: l.addrCity, controller: _city, validator: need, autofill: const [AutofillHints.addressCity])),
          const SizedBox(width: Space.md),
          Expanded(
            child: PawTextField(
              label: l.addrPin,
              controller: _pin,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              autofill: const [AutofillHints.postalCode],
              validator: (v) => isValidPinCode(v ?? '') ? null : l.addrPinInvalid,
            ),
          ),
        ]),
        PrimaryButton(label: l.save, loading: _busy, onPressed: _save),
      ]),
    );
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final user = ref.read(currentUserProvider)!;
    final list = ref.read(addressesProvider).value ?? const <Address>[];
    final a = Address(
      id: widget.existing?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
      label: _label,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      line1: _line1.text.trim(),
      line2: _line2.text.trim(),
      area: _area.text.trim(),
      city: _city.text.trim(),
      pin: _pin.text.trim(),
    );
    await ref.read(shopRepositoryProvider).saveAddress(user.uid, a, list);
    if (mounted) Navigator.pop(context, a);
  }
}
