# Counts hard-coded style values and shared-widget use in lib/ (UI revamp audit).
# Usage: python3 docs/ui-revamp/count_hardcoded.py .
# Skips token/theme files, printable documents and vector artwork.
import re, os, sys, collections
root = sys.argv[1]
files = []
for d, _, fs in os.walk(os.path.join(root, 'lib')):
    for f in fs:
        if f.endswith('.dart') and not f.endswith(('.g.dart', '.freezed.dart')) and '/l10n/' not in d:
            files.append(os.path.join(d, f))
token_files = {'lib/core/theme/tokens.dart', 'lib/core/theme/app_theme.dart',
 # print documents (drawn to PNG for PDFs) and vector artwork: fixed values are fine there
 'lib/features/televet/presentation/prescription_pdf.dart','lib/features/health/presentation/health_report.dart',
 'lib/features/shop/presentation/invoice.dart','lib/features/vault/presentation/sample_docs.dart',
 'lib/core/widgets/document_preview.dart','lib/core/widgets/illustrations.dart','lib/core/widgets/logo.dart'}
pats = {
  'hex Color(0x..)': r'Color\(0x[0-9A-Fa-f]{8}\)',
  'Colors.* (material palette)': r'\bColors\.(?!transparent\b)\w+',
  'ad-hoc alpha tints .withValues(alpha:)': r'\.withValues\(alpha:',
  'fontSize: literal': r'fontSize:\s*[0-9]',
  'FontWeight.wNNN overrides': r'FontWeight\.w\d00',
  'EdgeInsets with number literal': r'EdgeInsets\.\w+\([^)]*\b\d+(\.\d+)?\b',
  'SizedBox gap literal (height/width: N)': r'SizedBox\((?:[^)]*?)(?:height|width):\s*\d',
  'BorderRadius/Radius.circular(N)': r'Radius\.circular\(\s*\d',
  'BoxShadow(': r'BoxShadow\(',
  'elevation: N': r'elevation:\s*\d',
  'Icon size: N': r'Icon\([^;]*?size:\s*\d',
  'raw FilledButton/ElevatedButton': r'\b(FilledButton|ElevatedButton)(\.icon|\.tonal|\.tonalIcon)?\(',
  'raw OutlinedButton': r'\bOutlinedButton(\.icon)?\(',
  'raw TextButton': r'\bTextButton(\.icon)?\(',
  'raw TextField/TextFormField': r'\b(TextField|TextFormField)\(',
  'raw Card(': r'(?<![A-Za-z])Card\(',
  'raw AlertDialog(': r'\bAlertDialog\(',
  'raw showModalBottomSheet(': r'\bshowModalBottomSheet',
  'raw SnackBar(': r'(?<![A-Za-z])SnackBar\(',
  'CircularProgressIndicator (spinner)': r'CircularProgressIndicator\(',
  'LinearProgressIndicator': r'LinearProgressIndicator\(',
  'Skeleton/SkeletonList use': r'\bSkeleton(List)?\(',
  'EmptyState use': r'\bEmptyState\(',
  'ErrorState use': r'\bErrorState\(',
  'AsyncView use': r'\bAsyncView',
  '.when( (manual async)': r'\.when\(',
  'raw ListTile(': r'\bListTile\(',
  'Icons non-rounded': r'\bIcons\.(?!\w+_rounded\b)\w+',
  'Icons rounded': r'\bIcons\.\w+_rounded\b',
  'PawCard use': r'\bPawCard\(',
  'PrimaryButton use': r'\bPrimaryButton\(',
  'SecondaryButton use': r'\bSecondaryButton\(',
  'PawTextField use': r'\bPawTextField\(',
  'StatusChip use': r'\bStatusChip\(',
  'raw Chip/ChoiceChip/FilterChip': r'\b(Chip|ChoiceChip|FilterChip|ActionChip|InputChip)\(',
  'raw AppBar(': r'\bAppBar\(',
  'Image.network/Image.asset/Image.memory': r'Image\.(network|asset|memory|file)\(',
  'MediaImage use': r'\bMediaImage\(',
  'BoxFit.* ': r'BoxFit\.\w+',
  'ClipRRect(': r'ClipRRect\(',
  'maxLines: 1 + ellipsis': r'TextOverflow\.ellipsis',
  'GestureDetector(': r'GestureDetector\(',
  'InkWell(': r'InkWell\(',
  'Tooltip(': r'Tooltip\(',
  'TextStyle( inline': r'(?<!\.)TextStyle\(',
  'copyWith(color: (text recolour)': r'copyWith\([^)]*color:',
}
tot = collections.Counter(); perfile = collections.defaultdict(collections.Counter)
values = collections.defaultdict(collections.Counter)
for f in files:
    rel = os.path.relpath(f, root)
    src = open(f, encoding='utf8').read()
    for k, p in pats.items():
        n = len(re.findall(p, src, flags=re.S if 'Icon size' in k else 0))
        if rel in token_files: continue
        tot[k] += n; perfile[k][rel] += n
    if rel in token_files: continue
    for m in re.findall(r'Color\(0x([0-9A-Fa-f]{8})\)', src): values['hex'][m.upper()] += 1
    for m in re.findall(r'fontSize:\s*([0-9.]+)', src): values['fontSize'][m] += 1
    for m in re.findall(r'Radius\.circular\(\s*([0-9.]+)', src): values['radius'][m] += 1
    for m in re.findall(r'FontWeight\.w(\d00)', src): values['weight'][m] += 1
    for m in re.findall(r'EdgeInsets\.\w+\(([^)]*)\)', src):
        for n in re.findall(r'(?<![\w.])(\d+(?:\.\d+)?)(?![\w.])', m): values['edgeinsets'][n] += 1
    for m in re.findall(r'SizedBox\([^)]*?(?:height|width):\s*(\d+(?:\.\d+)?)', src): values['sizedbox'][m] += 1
    for m in re.findall(r'Icon\([^;]*?size:\s*(\d+(?:\.\d+)?)', src, flags=re.S): values['iconsize'][m] += 1
    for m in re.findall(r'\bColors\.(?!transparent\b)(\w+)', src): values['Colors'][m] += 1
print('dart files scanned:', len(files))
for k in pats:
    top = ', '.join(f'{os.path.basename(a)}:{b}' for a, b in perfile[k].most_common(4) if b)
    print(f'{tot[k]:5}  {k:45} {top}')
for k, c in values.items():
    print(f'\n{k}: {len(c)} distinct ->', ', '.join(f'{a}×{b}' for a, b in c.most_common(30)))
