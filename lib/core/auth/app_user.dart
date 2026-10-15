import '../data/converters.dart';

/// Signed-in user. Built from the auth session plus the users/{uid} profile.
enum UserRole {
  owner,
  vet,
  clinicAdmin,
  groomer,
  trainer,
  boarder,
  walker,
  seller,
  admin;

  String get key => switch (this) { UserRole.clinicAdmin => 'clinic_admin', _ => name };

  static UserRole parse(String? s) => switch (s) {
        'clinic_admin' => UserRole.clinicAdmin,
        'vet' => UserRole.vet,
        'groomer' => UserRole.groomer,
        'trainer' => UserRole.trainer,
        'boarder' => UserRole.boarder,
        'walker' => UserRole.walker,
        'seller' => UserRole.seller,
        'admin' => UserRole.admin,
        _ => UserRole.owner,
      };

  bool get isPartner => this != UserRole.owner && this != UserRole.admin;
  bool get isProvider =>
      this == UserRole.groomer || this == UserRole.trainer || this == UserRole.boarder || this == UserRole.walker;
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.role,
    this.name = '',
    this.email,
    this.phone,
    this.emailVerified = true,
    this.plan = 'free',
    this.partnerId,
    this.onboarded = false,
    this.city,
    this.language,
    this.isDemo = false,
    this.suspended = false,
    this.trialEndsAt,
    this.trialUsedAt,
    this.planRenewsAt,
    this.deletionRequestedAt,
    this.consents = const {},
    this.referralCode,
    this.autoRenew = true,
    this.planPeriod,
  });

  final String uid;
  final UserRole role;
  final String name;
  final String? email;
  final String? phone;
  final bool emailVerified;
  final String plan;
  final String? partnerId;
  final bool onboarded;
  final String? city;
  final String? language;
  final bool isDemo;

  /// Paused by an admin: the app shows only a "suspended" screen.
  final bool suspended;
  final DateTime? trialEndsAt;
  final DateTime? trialUsedAt;
  final DateTime? planRenewsAt;

  /// Set when the person asked to delete their account (30-day grace).
  final DateTime? deletionRequestedAt;
  final Map<String, dynamic> consents;
  final String? referralCode;

  /// Plus renews at [planRenewsAt] unless turned off (Version 1: demo).
  final bool autoRenew;

  /// monthly or yearly
  final String? planPeriod;

  /// The plan that applies now: an ended trial or paid period counts as free.
  String get effectivePlan => effectivePlanAt(DateTime.now());

  String effectivePlanAt(DateTime now) {
    if (plan == 'trial') return trialEndsAt == null || trialEndsAt!.isAfter(now) ? 'trial' : 'free';
    if (plan == 'plus') return planRenewsAt == null || planRenewsAt!.isAfter(now) ? 'plus' : 'free';
    return 'free';
  }

  bool get isPlus => effectivePlan != 'free';
  bool get onTrial => effectivePlan == 'trial';
  String get firstName => name.split(' ').first;

  AppUser copyWith({UserRole? role, String? name, String? plan, bool? onboarded, String? partnerId}) => AppUser(
        uid: uid,
        role: role ?? this.role,
        name: name ?? this.name,
        email: email,
        phone: phone,
        emailVerified: emailVerified,
        plan: plan ?? this.plan,
        partnerId: partnerId ?? this.partnerId,
        onboarded: onboarded ?? this.onboarded,
        city: city,
        language: language,
        isDemo: isDemo,
        suspended: suspended,
        trialEndsAt: trialEndsAt,
        trialUsedAt: trialUsedAt,
        planRenewsAt: planRenewsAt,
        deletionRequestedAt: deletionRequestedAt,
        consents: consents,
        referralCode: referralCode,
        autoRenew: autoRenew,
        planPeriod: planPeriod,
      );

  static AppUser fromProfile(String uid, Map<String, dynamic>? p,
          {String? email, String? phone, bool emailVerified = true, String? claimRole}) =>
      AppUser(
        uid: uid,
        role: UserRole.parse(claimRole ?? p?['role'] as String?),
        name: (p?['name'] as String?) ?? '',
        email: email ?? p?['email'] as String?,
        phone: phone ?? p?['phone'] as String?,
        emailVerified: emailVerified,
        plan: (p?['plan'] as String?) ?? 'free',
        partnerId: p?['partnerId'] as String?,
        onboarded: (p?['onboarded'] as bool?) ?? false,
        city: p?['city'] as String?,
        language: p?['language'] as String?,
        isDemo: (p?['demo'] as bool?) ?? false,
        suspended: (p?['suspended'] as bool?) ?? false,
        trialEndsAt: parseDate(p?['trialEndsAt']),
        trialUsedAt: parseDate(p?['trialUsedAt']),
        planRenewsAt: parseDate(p?['planRenewsAt']),
        deletionRequestedAt: parseDate(p?['deletionRequestedAt']),
        consents: ((p?['consents'] as Map?) ?? const {}).cast<String, dynamic>(),
        referralCode: p?['referralCode'] as String?,
        autoRenew: (p?['autoRenew'] as bool?) ?? true,
        planPeriod: p?['planPeriod'] as String?,
      );
}
