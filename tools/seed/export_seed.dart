// Prints the demo seed (lib/core/demo/seed) as JSON for tools/seed/seed.js.
// Dates become {"__date": "<ISO-8601>"} so the loader can store Timestamps.
import 'dart:convert';
import 'dart:io';

import 'package:pawsetu/core/demo/seed/seed.dart';

Object? _enc(Object? v) {
  if (v is DateTime) return {'__date': v.toUtc().toIso8601String()};
  if (v is Map) return v.map((k, val) => MapEntry(k.toString(), _enc(val)));
  if (v is List) return v.map(_enc).toList();
  return v;
}

void main(List<String> args) {
  final data = DemoSeed.build(DateTime.now());
  final out = args.isNotEmpty ? File(args.first) : null;
  final text = jsonEncode(_enc(data));
  if (out != null) {
    out.writeAsStringSync(text);
  } else {
    stdout.write(text);
  }
}
