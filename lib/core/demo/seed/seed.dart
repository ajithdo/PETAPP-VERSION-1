/// Demo data for Version 1 (spec section 12). Pure Dart, no Flutter imports:
/// used by the standalone demo (lib/core/demo/demo_store.dart) and by the
/// emulator seed tool (tools/seed/seed.dart).
///
/// Every person, clinic, seller, phone number and email is fictional.
/// Phones use +91 90000 000xx, emails @example.com, registration numbers
/// DEMO-VC-xxxx. Dates are relative to [now] so the demo always looks fresh.
library;

import 'seed_people.dart';
import 'seed_places.dart';
import 'seed_shop.dart';
import 'seed_activity.dart';

typedef SeedData = Map<String, Map<String, Map<String, dynamic>>>;

class DemoSeed {
  /// Bump when the seed changes so saved standalone demo data is replaced.
  static const version = 12;

  static SeedData build(DateTime now) {
    final data = <String, Map<String, Map<String, dynamic>>>{};
    void add(String col, String id, Map<String, dynamic> doc) => (data[col] ??= {})[id] = doc;

    seedConfig(add, now);
    seedPeople(add, now);
    seedPlaces(add, now);
    seedShop(add, now);
    seedActivity(add, now, data);
    return data;
  }
}

typedef Add = void Function(String col, String id, Map<String, dynamic> doc);

/// Admin-configurable values (spec section 8). The app reads config/app.
void seedConfig(Add add, DateTime now) {
  add('config', 'app', {
    'plans': {'plusMonthly': 99, 'plusYearly': 799, 'trialDays': 7},
    'limits': {
      'free': {
        'pets': 3,
        'teleVetPerMonth': 1,
        'teleVetMessages': 20,
        'teleVetWords': 60,
        'teleVetHours': 24,
        'aiQuestions': 5,
        'storageGb': 1,
        'family': 2,
        'videoSeconds': 60,
      },
      'plus': {
        'pets': 999,
        'teleVetPerMonth': 999,
        'teleVetMessages': 100,
        'teleVetWords': 300,
        'teleVetHours': 72,
        'aiQuestions': 9999,
        'storageGb': 25,
        'family': 8,
        'videoSeconds': 180,
      },
    },
    'commission': {'bookingPercent': 10, 'foodMarginPercent': 8, 'otherMarginPercent': 15, 'videoDiscountPercent': 10, 'freeDeliveryAbove': 499},
    'shop': {'deliveryFee': 49, 'freeDeliveryAbove': 999},
    'flags': {'aiAssistant': true, 'smartDevices': true, 'lostPetAlerts': true, 'referrals': true},
    'updatedAt': now,
  });
}

/// Small deterministic random generator so the demo is the same every time.
class SeedRandom {
  SeedRandom(this._state);
  int _state;
  int next(int max) {
    _state = (_state * 1103515245 + 12345) & 0x7fffffff;
    return _state % max;
  }

  double nextDouble() => next(1000000) / 1000000.0;
  T pick<T>(List<T> items) => items[next(items.length)];
  bool chance(double p) => nextDouble() < p;
}

String demoPhone(int n) => '+91 90000 ${n.toString().padLeft(5, '0')}';
