import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/app_user.dart';

/// Returns the body for a partner portal section, or null if that section
/// is built in a later phase. Phases 5, 6 and 8 fill this in.
Widget? partnerSectionBody(BuildContext context, WidgetRef ref, AppUser user, String section) => null;
