# Batch D — partner portals and admin: Impeccable audit (8 Nov 2026)

Method: code-level audit of a native (Flutter) app against the Android / Material 3 reference and DESIGN.md (calm register, compact tables).
Screenshots: this folder (UI Design 5) next to `../ui-design-4-baseline/` (`phone360-portal-clinic.jpg`, `desktop1280-portal-clinic.jpg`, `phone360-admin.jpg`, `desktop1280-admin.jpg`…). Accounts: Kavya Rao (clinic), Dr. Sameer Khan (vet), Tail Treats Traders (seller), Lakshmi Groom Studio (groomer), PawSetu Admin.

Why this batch was not moved earlier: the audit found the portals in good shape after the foundation (theme, cards, chips, date blocks); they were not "much weaker than everything else", so the owner's order (pet-parent screens first) was kept.

| # | Dimension | Score | Key finding |
|---|---|---|---|
| 1 | Accessibility | 3 → 4 | The selected sidebar item was unreadable in light mode (dark text on the cocoa pill); fixed in the theme |
| 2 | Performance | 3 | Charts redraw only on data change |
| 3 | Appearance and theming | 4 | Quiet top bar (was a solid brand bar); red only for SOS figures |
| 4 | Platform conformance | 4 | Material navigation drawer, data cards, filter chips |
| 5 | Adaptivity | 4 | Sidebar on wide screens, drawer on phones; 200% text sweep passes |
| **Total** | | **19/20** | **Excellent** |

## Fixed
- **[P1] Selected sidebar item invisible in light mode** — the navigation drawer now uses the on-brand colour for the selected icon and label.
- **[P2] Solid brand top bar** — the same quiet light bar as the rest of the app, with a hairline.

## Positive findings
- Stat cards and date-led booking rows read like a business dashboard; Telugu fits.
- "Approve" is the one filled action; "Reject" outlined.
