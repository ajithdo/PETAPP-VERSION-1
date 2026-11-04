#!/usr/bin/env bash
# Proof search for the Design 2 rule "no hand-typed style values outside
# lib/core/theme/tokens.dart". Lists every literal colour, font size, gap,
# corner, icon size, stroke, opacity or letter spacing in the app's Dart
# files. An empty result means the screens use tokens only.
#
# Left out on purpose (they must keep fixed values):
#   lib/core/theme/                       the token file and the theme built from it
#   lib/core/l10n/gen/                    generated translations
#   Printed pages, laid out in points for A4 paper and always white:
#     lib/core/widgets/document_preview.dart        A4 page frame
#     lib/features/health/presentation/health_report.dart   health report (its on-screen medical card uses tokens)
#     lib/features/televet/presentation/prescription_pdf.dart
#     lib/features/shop/presentation/invoice.dart
#     lib/features/vault/presentation/sample_docs.dart       demo sample documents
#     lib/features/messaging/presentation/attachments.dart   demo "SAMPLE" PDF (its photo viewer uses tokens)
#     lib/features/sos/presentation/lost_screens.dart        printable lost poster and QR tag (its screens use tokens)
#   Drawn artwork with its own palette:
#     lib/core/widgets/illustrations.dart, lib/core/widgets/logo.dart,
#     lib/features/album/presentation/birthday_screen.dart (confetti)
# Printed pages take their colours from PrintColors in tokens.dart.
#
# usage: bash docs/ui-revamp/check_design2_tokens.sh
cd "$(dirname "$0")/../.."
EXEMPT='^lib/core/theme/|^lib/core/l10n/gen/|document_preview\.dart|health_report\.dart|prescription_pdf\.dart|/invoice\.dart|sample_docs\.dart|messaging/presentation/attachments\.dart|sos/presentation/lost_screens\.dart|widgets/illustrations\.dart|widgets/logo\.dart|album/presentation/birthday_screen\.dart'
mapfile -t FILES < <(find lib -name '*.dart' | sort | grep -vE "$EXEMPT")
grep -nE "Color\(0x|(^|[^A-Za-z])Colors\.(white|black|grey|red|green|blue|orange|amber|teal)|fontSize: [0-9]|letterSpacing: [0-9]|strokeWidth: [0-9]|alpha: 0\.|SizedBox\((height|width): [0-9]|(height|width|minHeight|maxWidth|size): [0-9]|EdgeInsets\.[a-zA-Z]+\([^)]*[^a-zA-Z.0-9][1-9][0-9]{0,2}[,)]|circular\([0-9]|(Space|IconSizes|Radii|TapTarget)\.[a-z0-9]+ [-+/*] [0-9]|height: [0-9]" "${FILES[@]}" | grep -v "^\S*:\s*//"
echo "checked ${#FILES[@]} files (every Dart file in lib except the ones listed at the top); matches above (none = clean)"
