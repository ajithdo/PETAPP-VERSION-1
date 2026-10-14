import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';
import '../../messaging/messaging_slots.dart';
import '../../shop/shop_slots.dart';

/// Partner sections built in later phases: chat inbox and tele-vet queue
/// (Phase 6) and the seller portal (Phase 8). Null means "coming soon".
Widget? partnerLaterSection(BuildContext context, WidgetRef ref, AppUser user, String section) =>
    messagingPartnerSection(context, ref, user, section);

Widget? sellerSectionBody(BuildContext context, WidgetRef ref, AppUser user, String section) =>
    sellerSection(context, ref, user, section);
