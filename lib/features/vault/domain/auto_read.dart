/// Simulated document reading for Version 1 (spec 7.9). The sample documents
/// have realistic printed values; "reading" one returns exactly what is
/// printed on it. Version 2 swaps this for Gemini via Firebase AI Logic
/// behind [DocumentReader].
library;

import '../../../core/data/converters.dart';
import '../../health/domain/vaccine_schedule.dart';
import '../../pets/domain/breeds.dart';

/// Sample documents shipped with the demo. Each one is clearly stamped
/// SAMPLE when shown.
const sampleDocKeys = [
  'rabies_certificate',
  'dhppi_certificate',
  'fvrcp_certificate',
  'insurance_policy',
  'lab_report',
  'invoice',
  'licence',
  'adoption',
  'travel',
  'prescription',
];

/// The samples offered in the upload sheet ("Try a sample document").
const uploadSamples = ['rabies_certificate', 'insurance_policy', 'lab_report'];

String sampleDocType(String key) => switch (key) {
      'rabies_certificate' || 'dhppi_certificate' || 'fvrcp_certificate' => 'vaccination',
      'insurance_policy' => 'insurance',
      'lab_report' => 'lab',
      'invoice' => 'invoice',
      'licence' => 'licence',
      'adoption' => 'adoption',
      'travel' => 'travel',
      'prescription' => 'prescription',
      _ => 'other',
    };

/// Details read from a document. Field names match `documents.extracted`.
class ExtractedDetails {
  ExtractedDetails({
    required this.type,
    this.found = true,
    this.petName,
    this.vaccineName,
    this.brand,
    this.batch,
    this.dateGiven,
    this.nextDue,
    this.vetName,
    this.vetRegNo,
    this.clinicName,
    this.policyNo,
    this.insurer,
    this.cover,
    this.premium,
    this.coverStart,
    this.expiry,
    this.testName,
    this.amount,
    this.referenceNo,
    this.issuer,
    this.issuedOn,
  });

  /// Document type: vaccination, insurance, lab …
  String type;

  /// False when nothing could be read (the owner fills the details in).
  bool found;
  String? petName;
  String? vaccineName;
  String? brand;
  String? batch;
  DateTime? dateGiven;
  DateTime? nextDue;
  String? vetName;
  String? vetRegNo;
  String? clinicName;
  String? policyNo;
  String? insurer;
  int? cover;
  int? premium;
  DateTime? coverStart;
  DateTime? expiry;
  String? testName;
  int? amount;

  /// Invoice, licence or travel document number.
  String? referenceNo;

  /// Who issued it: a shelter, a municipal office, a lab …
  String? issuer;
  DateTime? issuedOn;

  bool get isVaccine => type == 'vaccination' && (vaccineName?.isNotEmpty ?? false);
  bool get isInsurance => type == 'insurance' && (policyNo?.isNotEmpty ?? false);

  Map<String, dynamic> toMap() => {
        'type': type,
        'petName': petName,
        'vaccineName': vaccineName,
        'brand': brand,
        'batch': batch,
        'dateGiven': dateGiven,
        'nextDue': nextDue,
        'vetName': vetName,
        'vetRegNo': vetRegNo,
        'clinicName': clinicName,
        'policyNo': policyNo,
        'insurer': insurer,
        'cover': cover,
        'premium': premium,
        'coverStart': coverStart,
        'expiry': expiry,
        'testName': testName,
        'amount': amount,
        'referenceNo': referenceNo,
        'issuer': issuer,
        'issuedOn': issuedOn,
      }..removeWhere((_, v) => v == null);

  static ExtractedDetails fromMap(Map<String, dynamic> m) => ExtractedDetails(
        type: (m['type'] as String?) ?? 'other',
        petName: m['petName'] as String?,
        vaccineName: m['vaccineName'] as String?,
        brand: m['brand'] as String?,
        batch: m['batch'] as String?,
        dateGiven: parseDate(m['dateGiven']),
        nextDue: parseDate(m['nextDue']),
        vetName: m['vetName'] as String?,
        vetRegNo: m['vetRegNo'] as String?,
        clinicName: m['clinicName'] as String?,
        policyNo: m['policyNo'] as String?,
        insurer: m['insurer'] as String?,
        cover: (m['cover'] as num?)?.toInt(),
        premium: (m['premium'] as num?)?.toInt(),
        coverStart: parseDate(m['coverStart']),
        expiry: parseDate(m['expiry']),
        testName: m['testName'] as String?,
        amount: (m['amount'] as num?)?.toInt(),
        referenceNo: m['referenceNo'] as String?,
        issuer: m['issuer'] as String?,
        issuedOn: parseDate(m['issuedOn']),
      );
}

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _plusYears(DateTime d, int y) => DateTime(d.year + y, d.month, d.day);

/// What is printed on sample document [key] made out for [petName].
/// [issuedOn] is the date on the paper.
ExtractedDetails sampleDetails(String key, {required String petName, required DateTime issuedOn}) {
  final on = _day(issuedOn);
  switch (key) {
    case 'rabies_certificate':
    case 'dhppi_certificate':
    case 'fvrcp_certificate':
      final (name, brand, batch) = switch (key) {
        'dhppi_certificate' => ('DHPPi + Lepto', 'Vaxipet (sample)', 'SAMPLE-DP-1180'),
        'fvrcp_certificate' => ('FVRCP', 'Felivax (sample)', 'SAMPLE-FV-3307'),
        _ => ('Anti-rabies', 'Rabivet (sample)', 'SAMPLE-RB-2291'),
      };
      return ExtractedDetails(
        type: 'vaccination',
        petName: petName,
        vaccineName: name,
        brand: brand,
        batch: batch,
        dateGiven: on,
        nextDue: _plusYears(on, 1),
        expiry: _plusYears(on, 1),
        vetName: 'Dr. Ananya Rao',
        vetRegNo: 'DEMO-VC-0107',
        clinicName: 'Gulmohar Vet Studio',
        issuedOn: on,
      );
    case 'insurance_policy':
      return ExtractedDetails(
        type: 'insurance',
        petName: petName,
        insurer: 'Shield Pet Cover (sample)',
        policyNo: 'SAMPLE-PI-${20431 + petName.length}',
        cover: 100000,
        premium: 6499,
        coverStart: on,
        expiry: _plusYears(on, 1).subtract(const Duration(days: 1)),
        issuedOn: on,
      );
    case 'lab_report':
      return ExtractedDetails(
        type: 'lab',
        petName: petName,
        testName: 'Complete blood count (CBC)',
        clinicName: 'Sample Diagnostics Lab',
        vetName: 'Dr. Ananya Rao',
        issuedOn: on,
        dateGiven: on,
      );
    case 'invoice':
      return ExtractedDetails(
        type: 'invoice',
        petName: petName,
        clinicName: 'Gulmohar Vet Studio',
        referenceNo: 'SAMPLE-INV-5521',
        amount: 1850,
        issuedOn: on,
      );
    case 'licence':
      return ExtractedDetails(
        type: 'licence',
        petName: petName,
        issuer: 'Municipal Corporation (sample)',
        referenceNo: 'SAMPLE-LIC-0912',
        issuedOn: on,
        expiry: _plusYears(on, 1),
      );
    case 'adoption':
      return ExtractedDetails(
        type: 'adoption',
        petName: petName,
        issuer: 'Happy Tails Shelter (sample)',
        referenceNo: 'SAMPLE-AD-4410',
        issuedOn: on,
      );
    case 'travel':
      return ExtractedDetails(
        type: 'travel',
        petName: petName,
        issuer: 'Animal Quarantine Office (sample)',
        referenceNo: 'SAMPLE-TR-7731',
        issuedOn: on,
        expiry: on.add(const Duration(days: 30)),
      );
    case 'prescription':
      return ExtractedDetails(
        type: 'prescription',
        petName: petName,
        vetName: 'Dr. Ananya Rao',
        vetRegNo: 'DEMO-VC-0107',
        clinicName: 'Gulmohar Vet Studio',
        issuedOn: on,
      );
  }
  return ExtractedDetails(type: 'other', found: false);
}

/// Guesses the type from a file name ("rabies_cert.jpg" → vaccination).
String guessTypeFromName(String? fileName) {
  final n = (fileName ?? '').toLowerCase();
  bool has(List<String> w) => w.any(n.contains);
  if (has(['rabies', 'vaccin', 'dhpp', 'fvrcp'])) return 'vaccination';
  if (has(['insur', 'policy'])) return 'insurance';
  if (has(['lab', 'report', 'blood', 'xray', 'x-ray', 'scan'])) return 'lab';
  if (has(['prescri', 'rx'])) return 'prescription';
  if (has(['invoice', 'bill', 'receipt'])) return 'invoice';
  if (has(['licen', 'registration'])) return 'licence';
  if (has(['adopt', 'purchase'])) return 'adoption';
  if (has(['travel', 'passport', 'health cert'])) return 'travel';
  return 'other';
}

/// Reads documents. V1 = [SimulatedDocumentReader]; V2 = Gemini.
abstract class DocumentReader {
  Future<ExtractedDetails> read({String? sampleKey, String? fileName, required String petName, required DateTime issuedOn});
}

class SimulatedDocumentReader implements DocumentReader {
  const SimulatedDocumentReader({this.delay = const Duration(milliseconds: 900)});
  final Duration delay;

  @override
  Future<ExtractedDetails> read({String? sampleKey, String? fileName, required String petName, required DateTime issuedOn}) async {
    await Future<void>.delayed(delay);
    if (sampleKey != null && sampleDocKeys.contains(sampleKey)) {
      return sampleDetails(sampleKey, petName: petName, issuedOn: issuedOn);
    }
    // Real files can't be read in the demo: guess the type and let the
    // owner fill in the rest.
    return ExtractedDetails(type: guessTypeFromName(fileName), found: false);
  }
}

/// Which vaccine series a printed vaccine name belongs to.
String vaccineSeries(String name) {
  final n = name.toLowerCase();
  if (n.contains('rabies')) return 'rabies';
  if (n.contains('dhpp') || n.contains('distemper') || n.contains('parvo') || n.contains('lepto')) return 'dhppi';
  if (n.contains('fvrcp') || n.contains('panleuk') || n.contains('calici')) return 'fvrcp';
  if (n.contains('kennel')) return 'kennel_cough';
  if (n.contains('felv') || n.contains('leuk')) return 'felv';
  return 'other';
}

/// Maps a read vaccine to the schedule step it fills, so the health tab
/// shows it in the right row: the next missing puppy/kitten dose for young
/// pets, otherwise the yearly booster. Unknown vaccines become "other".
String matchVaccineTemplate({
  required Species species,
  required String vaccineName,
  required DateTime? birthday,
  required DateTime givenDate,
  required List<VaccineRecord> records,
}) {
  final series = vaccineSeries(vaccineName);
  final templates = templatesFor(species);
  if (series == 'other' || templates.isEmpty) return 'other';
  final optional = templates.where((t) => t.optional && t.key == series).firstOrNull;
  if (optional != null) return optional.key;
  final doses = templates.where((t) => t.fromWeeks != null && t.key.split('_').first == series).toList();
  final booster = templates.where((t) => t.yearlyAfter == series).firstOrNull;
  if (doses.isEmpty && booster == null) return 'other';
  final ageWeeks = birthday == null ? 9999 : givenDate.difference(birthday).inDays ~/ 7;
  final done = records.map((r) => r.key).toSet();
  if (ageWeeks < 26) {
    for (final d in doses) {
      if (!done.contains(d.key)) return d.key;
    }
  }
  return booster?.key ?? doses.last.key;
}
