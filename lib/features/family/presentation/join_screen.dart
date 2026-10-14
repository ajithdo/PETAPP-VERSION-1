import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/logo.dart';
import '../../../core/widgets/widgets.dart';
import '../../pets/presentation/pet_labels.dart';
import '../data/family_repository.dart';

/// Opens an invite link: `https://pawsetu.app/#/join/<token>`
class JoinScreen extends ConsumerWidget {
  const JoinScreen({super.key, required this.token});
  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(currentUserProvider);
    final invite = ref.watch(_inviteProvider(token));
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: EdgeInsets.all(context.gutter),
            child: AsyncView<PetInvite?>(
              value: invite,
              data: (inv) {
                if (inv == null || inv.data['status'] != 'pending') {
                  return EmptyState(
                    scene: Scene.search,
                    title: l.inviteInvalid,
                    actionLabel: l.goHome,
                    onAction: () => context.go('/splash'),
                  );
                }
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  const PawSetuLogo(size: 56),
                  const SizedBox(height: Space.lg),
                  Text(
                    l.inviteReceived(inv.invitedByName, inv.petName, petRoleLabel(context, inv.role)),
                    style: context.text.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Space.xl),
                  if (user == null)
                    PrimaryButton(
                      label: l.signInToAccept,
                      onPressed: () {
                        ref.read(prefsProvider).setString('pending_join', token);
                        context.go('/signin');
                      },
                    )
                  else
                    PrimaryButton(
                      label: l.accept,
                      onPressed: () async {
                        await ref.read(familyRepositoryProvider).accept(inv, user);
                        if (context.mounted) {
                          showToast(context, l.inviteAccepted(inv.petName));
                          context.go('/pets/${inv.petId}');
                        }
                      },
                    ),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

final _inviteProvider = FutureProvider.family<PetInvite?, String>(
    (ref, token) => ref.watch(familyRepositoryProvider).findByToken(token));
