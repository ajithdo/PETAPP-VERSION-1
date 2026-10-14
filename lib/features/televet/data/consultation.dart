import '../../../core/data/converters.dart';
import '../../pets/domain/pet.dart';
import '../domain/televet_rules.dart';

/// A tele-vet consultation (collection `consultations`).
class Consultation {
  Consultation(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;

  String get ownerId => (raw['ownerId'] as String?) ?? '';
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String get petId => (raw['petId'] as String?) ?? '';
  String get petName => (raw['petName'] as String?) ?? '';
  String get petSpecies => (raw['petSpecies'] as String?) ?? 'dog';
  Map<String, dynamic> get petSnapshot => ((raw['petSnapshot'] as Map?) ?? const {}).cast<String, dynamic>();
  String? get vetId => raw['vetId'] as String?;
  String? get vetUid => raw['vetUid'] as String?;
  String get vetName => (raw['vetName'] as String?) ?? '';
  String? get clinicId => raw['clinicId'] as String?;
  String get clinicName => (raw['clinicName'] as String?) ?? '';

  /// queued, active or ended.
  String get status => (raw['status'] as String?) ?? 'queued';
  bool get isQueued => status == 'queued';
  bool get isActive => status == 'active';
  bool get isEnded => status == 'ended';

  /// chat or video.
  String get mode => (raw['mode'] as String?) ?? 'chat';
  bool get isVideo => mode == 'video';
  String get problem => (raw['problem'] as String?) ?? '';
  List<String> get photos => ((raw['photos'] as List?) ?? const []).cast<String>();
  String get plan => (raw['plan'] as String?) ?? 'free';
  bool get isPlus => plan == 'plus' || plan == 'trial';
  TeleVetLimits get limits => TeleVetLimits.fromStored(raw['limits'] as Map?, plus: isPlus);
  int get messagesUsed => (raw['messagesUsed'] as num?)?.toInt() ?? 0;
  int get messagesLeft => (limits.messages - messagesUsed).clamp(0, limits.messages);
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.now();
  DateTime? get startedAt => parseDate(raw['startedAt']);
  DateTime? get endsAt => parseDate(raw['endsAt']);
  DateTime? get endedAt => parseDate(raw['endedAt']);
  DateTime? get scheduledAt => parseDate(raw['scheduledAt']);
  int? get rating => (raw['rating'] as num?)?.toInt();
  String? get ratingText => raw['ratingText'] as String?;
  String? get prescriptionId => raw['prescriptionId'] as String?;
  String get privateNotes => (raw['privateNotes'] as String?) ?? '';
  String get conversationId => (raw['conversationId'] as String?) ?? 'tv_$id';
  int get total => (raw['total'] as num?)?.toInt() ?? 0;
  int get fee => (raw['fee'] as num?)?.toInt() ?? 0;
  int get discount => (raw['discount'] as num?)?.toInt() ?? 0;

  /// in_person or emergency, when the vet recommended it.
  String? get recommendation => raw['recommendation'] as String?;
  String? get redFlag => raw['redFlag'] as String?;
  bool get priority => (raw['priority'] as bool?) ?? isPlus;

  /// Owner's chat window has closed (the vet can still wrap up).
  bool closedFor(DateTime now) => isEnded || (endsAt != null && now.isAfter(endsAt!));

  /// The pet as it was when the consultation started (vets cannot read the
  /// pet document itself; the snapshot gives them the context they need).
  Pet get pet => Pet.fromJson({
        'id': petId,
        'ownerId': ownerId,
        'name': petName,
        'species': petSpecies,
        ...petSnapshot,
      });

  /// Medicines copied at start (Plus: full history context).
  List<Map<String, dynamic>> get medicines =>
      [for (final m in (petSnapshot['medicines'] as List?) ?? const []) (m as Map).cast<String, dynamic>()];
}

/// A tele-vet e-prescription (collection `prescriptions`).
class Prescription {
  Prescription(this.id, this.raw);
  final String id;
  final Map<String, dynamic> raw;
  String get consultationId => (raw['consultationId'] as String?) ?? '';
  String get petId => (raw['petId'] as String?) ?? '';
  String get petName => (raw['petName'] as String?) ?? '';
  String get petSpecies => (raw['petSpecies'] as String?) ?? 'dog';
  String get ownerName => (raw['ownerName'] as String?) ?? '';
  String get vetName => (raw['vetName'] as String?) ?? '';
  String get qualification => (raw['qualification'] as String?) ?? '';
  String get regNo => (raw['regNo'] as String?) ?? '';
  String get clinicName => (raw['clinicName'] as String?) ?? '';
  String get clinicAddress => (raw['clinicAddress'] as String?) ?? '';
  String get diagnosis => (raw['diagnosis'] as String?) ?? '';
  String get notes => (raw['notes'] as String?) ?? '';
  DateTime? get followUp => parseDate(raw['followUp']);
  DateTime get createdAt => parseDate(raw['createdAt']) ?? DateTime.now();
  String? get url => raw['url'] as String?;
  Map<String, dynamic> get petInfo => ((raw['petInfo'] as Map?) ?? const {}).cast<String, dynamic>();
  List<PrescriptionItem> get items => [
        for (final i in (raw['items'] as List?) ?? const []) PrescriptionItem.fromMap((i as Map).cast<String, dynamic>()),
      ];
}

class PrescriptionItem {
  const PrescriptionItem({required this.medicine, this.dose = '', this.frequency = '', this.duration = '', this.instructions = ''});
  final String medicine;
  final String dose;
  final String frequency;
  final String duration;
  final String instructions;

  factory PrescriptionItem.fromMap(Map<String, dynamic> m) => PrescriptionItem(
        medicine: (m['medicine'] as String?) ?? '',
        dose: (m['dose'] as String?) ?? '',
        frequency: (m['frequency'] as String?) ?? '',
        duration: (m['duration'] as String?) ?? '',
        instructions: (m['instructions'] as String?) ?? '',
      );

  Map<String, dynamic> toMap() => {'medicine': medicine, 'dose': dose, 'frequency': frequency, 'duration': duration, 'instructions': instructions};
}
