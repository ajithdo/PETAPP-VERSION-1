#!/usr/bin/env bash
# Proof search for the Design 2 rule "no hand-typed style values outside
# lib/core/theme/tokens.dart". Lists every literal colour, font size, gap,
# corner, icon size, stroke, opacity or letter spacing in the files that have
# been moved to Design 2. An empty result means they use tokens only.
# usage: bash docs/ui-revamp/check_design2_tokens.sh
cd "$(dirname "$0")/../.."
FILES=(
  lib/core/theme/app_theme.dart
  lib/core/widgets/buttons.dart
  lib/core/widgets/cards.dart
  lib/core/widgets/pills.dart
  lib/core/widgets/sos_button.dart
  lib/core/widgets/dialogs.dart
  lib/features/shell/presentation/owner_shell.dart
  lib/features/home/presentation/home_screen.dart
  lib/features/home/presentation/home_sections.dart
  lib/features/home/presentation/home_extras.dart
  lib/features/routine/presentation/today_card.dart
  lib/core/widgets/states.dart
  lib/core/widgets/inputs.dart
  lib/core/widgets/offline_banner.dart
  lib/core/widgets/pet_avatar.dart
  lib/core/widgets/media_image.dart
  lib/core/widgets/photo_picker.dart
  lib/features/routine/presentation/heat_card.dart
  lib/features/routine/presentation/quick_log_sheet.dart
  lib/features/routine/presentation/routine_labels.dart
  lib/features/routine/presentation/routine_screen.dart
  lib/features/routine/presentation/walk_tracker_screen.dart
  lib/core/widgets/pass_card.dart
  lib/core/widgets/timeline.dart
  lib/features/health/presentation/health_screen.dart
  lib/features/health/presentation/health_sheets.dart
  lib/features/health/presentation/health_labels.dart
  lib/core/routing/pet_links.dart
  lib/features/pets/presentation/archive_sheet.dart
  lib/features/pets/presentation/breed_picker.dart
  lib/features/pets/presentation/my_pets_screen.dart
  lib/features/pets/presentation/pet_form_screen.dart
  lib/features/pets/presentation/pet_labels.dart
  lib/features/pets/presentation/pet_profile_screen.dart
  lib/features/booking/presentation/book_home_screen.dart
  lib/features/booking/presentation/booking_flow_screen.dart
  lib/features/booking/presentation/booking_labels.dart
  lib/features/booking/presentation/my_bookings_screen.dart
  lib/features/booking/presentation/place_finder_screen.dart
  lib/features/booking/presentation/place_screen.dart
  lib/features/sos/presentation/devices_screens.dart
  lib/features/sos/presentation/first_aid_screens.dart
  lib/features/sos/presentation/public_lost_screen.dart
  lib/features/sos/presentation/safety_labels.dart
  lib/features/sos/presentation/sos_screen.dart
  lib/features/sos/presentation/toxic_screen.dart
)
grep -nE "Color\(0x|(^|[^A-Za-z])Colors\.(white|black|grey|red|green|blue|orange|amber|teal)|fontSize: [0-9]|letterSpacing: [0-9]|strokeWidth: [0-9]|alpha: 0\.|SizedBox\((height|width): [0-9]|(height|width|minHeight|maxWidth|size): [0-9]|EdgeInsets\.[a-zA-Z]+\([^)]*[^a-zA-Z.0-9][1-9][0-9]{0,2}[,)]|circular\([0-9]|(Space|IconSizes|Radii|TapTarget)\.[a-z0-9]+ [-+/*] [0-9]" "${FILES[@]}" | grep -v "^\s*//"
echo "checked ${#FILES[@]} files; matches above (none = clean)"
