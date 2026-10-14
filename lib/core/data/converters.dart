import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Reads dates written by Firestore (Timestamp), the standalone demo
/// (DateTime) or restored demo data (ISO strings). Writes DateTime, which
/// Firestore stores as a Timestamp.
DateTime? parseDate(Object? v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is Map && v['_seconds'] is int) {
    return DateTime.fromMillisecondsSinceEpoch((v['_seconds'] as int) * 1000);
  }
  return null;
}

class DateConverter implements JsonConverter<DateTime, Object?> {
  const DateConverter();
  @override
  DateTime fromJson(Object? json) => parseDate(json) ?? DateTime.fromMillisecondsSinceEpoch(0);
  @override
  Object? toJson(DateTime object) => object;
}

class NullableDateConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateConverter();
  @override
  DateTime? fromJson(Object? json) => parseDate(json);
  @override
  Object? toJson(DateTime? object) => object;
}

/// Reads a Firestore document into a model, adding the document id.
T fromDoc<T>(DocumentSnapshot<Map<String, dynamic>> doc,
    T Function(Map<String, dynamic>) fromJson) {
  final data = Map<String, dynamic>.from(doc.data() ?? const {});
  data['id'] = doc.id;
  return fromJson(data);
}

List<T> fromQuery<T>(QuerySnapshot<Map<String, dynamic>> snap,
        T Function(Map<String, dynamic>) fromJson) =>
    snap.docs.map((d) => fromDoc(d, fromJson)).toList();

/// Model -> Firestore map, without the id field (the id is the doc key).
Map<String, dynamic> toDoc(Map<String, dynamic> json) =>
    Map<String, dynamic>.from(json)..remove('id');
