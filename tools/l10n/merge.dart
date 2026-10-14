// Merges the per-feature string files in lib/core/l10n/src/*.json into the
// ARB files used by Flutter gen-l10n (app_en.arb, app_hi.arb, app_te.arb).
//
// Each source file maps a key to its three translations, so English, Hindi
// and Telugu always stay together:
//   "petAgeYears": {"en": "{years} yrs", "hi": "{years} वर्ष", "te": "{years} సం.",
//                   "ph": {"years": "int"}}
//
// Run:  dart run tools/l10n/merge.dart && flutter gen-l10n
import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('lib/core/l10n/src');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  final out = {
    'en': <String, Object?>{'@@locale': 'en'},
    'hi': <String, Object?>{'@@locale': 'hi'},
    'te': <String, Object?>{'@@locale': 'te'},
  };
  final seen = <String, String>{};
  var problems = 0;
  for (final f in files) {
    final map = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    for (final e in map.entries) {
      final key = e.key;
      if (seen.containsKey(key)) {
        stderr.writeln('Duplicate key "$key" in ${f.path} (also in ${seen[key]})');
        problems++;
      }
      seen[key] = f.path;
      final v = e.value as Map<String, dynamic>;
      for (final lang in ['en', 'hi', 'te']) {
        final text = v[lang] as String?;
        if (text == null) {
          stderr.writeln('Missing "$lang" for "$key" in ${f.path}');
          problems++;
          continue;
        }
        out[lang]![key] = text;
      }
      final ph = v['ph'] as Map<String, dynamic>?;
      if (ph != null) {
        out['en']!['@$key'] = {
          'placeholders': {for (final p in ph.entries) p.key: {'type': p.value}},
        };
      }
    }
  }
  const enc = JsonEncoder.withIndent('  ');
  for (final lang in out.keys) {
    File('lib/core/l10n/app_$lang.arb').writeAsStringSync('${enc.convert(out[lang])}\n');
  }
  stdout.writeln('Merged ${seen.length} strings from ${files.length} files.');
  if (problems > 0) exit(1);
}
