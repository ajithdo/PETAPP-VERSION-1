import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/core/demo/seed/seed_vault.dart';
import 'package:pawsetu/features/album/domain/album.dart';
import 'package:pawsetu/features/pets/domain/breeds.dart';
import 'package:pawsetu/features/health/domain/vaccine_schedule.dart';
import 'package:pawsetu/features/vault/domain/auto_read.dart';
import 'package:pawsetu/features/vault/domain/insurance.dart';
import 'package:pawsetu/features/vault/domain/pin_hash.dart';
import 'package:pawsetu/features/vault/domain/scan_bounds.dart';
import 'package:pawsetu/features/vault/domain/share_rules.dart';
import 'package:pawsetu/features/vault/domain/storage_quota.dart';
import 'package:pawsetu/features/vault/domain/vault_models.dart';

void main() {
  final now = DateTime(2026, 10, 14, 11);

  group('vault PIN', () {
    test('4 to 6 digits only', () {
      expect(isValidPin('2580'), isTrue);
      expect(isValidPin('258046'), isTrue);
      expect(isValidPin('258'), isFalse);
      expect(isValidPin('2580461'), isFalse);
      expect(isValidPin('25a0'), isFalse);
    });

    test('easy-to-guess PINs are refused', () {
      for (final p in ['1111', '1234', '4321', '123456', '987654']) {
        expect(isWeakPin(p), isTrue, reason: p);
      }
      for (final p in ['2580', '1357', '908172']) {
        expect(isWeakPin(p), isFalse, reason: p);
      }
    });

    test('stored as a salted hash that only the right PIN matches', () {
      final h = hashPin('2580', random: Random(1));
      expect(h, startsWith('pbkdf2\$$pinIterations\$'));
      expect(h, isNot(contains('2580')));
      expect(verifyPin('2580', h), isTrue);
      expect(verifyPin('2581', h), isFalse);
      expect(verifyPin('2580', null), isFalse);
      expect(verifyPin('2580', 'plain-text'), isFalse);
      // A fresh salt every time.
      expect(hashPin('2580', random: Random(2)), isNot(h));
    });

    test('share tokens are long and share PINs are never weak', () {
      final r = Random(7);
      final token = newShareToken(r);
      expect(token.length, 22);
      expect(RegExp(r'^[A-HJ-NP-Za-km-z2-9]+$').hasMatch(token), isTrue);
      for (var i = 0; i < 50; i++) {
        expect(isWeakPin(randomSharePin(r)), isFalse);
      }
    });
  });

  group('share links', () {
    ShareLink link(Map<String, dynamic> raw) => ShareLink('t', {'ownerId': 'u1', 'petId': 'p1', 'kind': 'docs', ...raw});

    test('open, expired, revoked and missing links', () {
      expect(checkShare(null, now: now), ShareStatus.notFound);
      expect(checkShare(link({}), now: now), ShareStatus.ok);
      expect(checkShare(link({'expiresAt': now.add(const Duration(hours: 1))}), now: now), ShareStatus.ok);
      expect(checkShare(link({'expiresAt': now}), now: now), ShareStatus.expired);
      expect(checkShare(link({'revoked': true}), now: now), ShareStatus.revoked);
      // Revoking wins over expiry so the vet hears what the owner did.
      expect(checkShare(link({'revoked': true, 'expiresAt': now.subtract(const Duration(days: 1))}), now: now), ShareStatus.revoked);
    });

    test('a link stops working the moment it is revoked', () {
      final raw = <String, dynamic>{'expiresAt': ShareExpiry.days7.from(now)};
      expect(checkShare(link(raw), now: now), ShareStatus.ok);
      raw['revoked'] = true;
      expect(checkShare(link(raw), now: now.add(const Duration(seconds: 1))), ShareStatus.revoked);
    });

    test('PIN links ask for the PIN and lock after 5 wrong tries', () {
      final pinHash = hashPin('2580', random: Random(3));
      expect(checkShare(link({'pinHash': pinHash}), now: now), ShareStatus.needsPin);
      expect(checkShare(link({'pinHash': pinHash}), pin: '1111', now: now), ShareStatus.wrongPin);
      expect(checkShare(link({'pinHash': pinHash}), pin: '2580', now: now), ShareStatus.ok);
      final wrong = [for (var i = 0; i < 5; i++) {'at': now.subtract(Duration(minutes: i)), 'device': 'Web browser', 'ok': false}];
      expect(checkShare(link({'pinHash': pinHash, 'accessLog': wrong}), pin: '2580', now: now), ShareStatus.locked);
      // Old wrong tries no longer count.
      expect(checkShare(link({'pinHash': pinHash, 'accessLog': wrong}), pin: '2580', now: now.add(const Duration(minutes: 20))), ShareStatus.ok);
    });

    test('expiry choices', () {
      expect(ShareExpiry.hour1.from(now), now.add(const Duration(hours: 1)));
      expect(ShareExpiry.hours24.from(now), now.add(const Duration(hours: 24)));
      expect(ShareExpiry.never.from(now), isNull);
      expect(shareUrl('abc', webBase: 'https://x.test/'), 'https://x.test/#/share/abc');
    });
  });

  group('auto-read', () {
    test('the sample rabies certificate reads what is printed on it', () async {
      final d = await const SimulatedDocumentReader(delay: Duration.zero)
          .read(sampleKey: 'rabies_certificate', petName: 'Bruno', issuedOn: DateTime(2026, 9, 1, 15));
      expect(d.found, isTrue);
      expect(d.isVaccine, isTrue);
      expect(d.vaccineName, 'Anti-rabies');
      expect(d.dateGiven, DateTime(2026, 9, 1));
      expect(d.nextDue, DateTime(2027, 9, 1));
      expect(d.petName, 'Bruno');
    });

    test('real files are not read in the demo: the type is guessed from the name', () async {
      final d = await const SimulatedDocumentReader(delay: Duration.zero)
          .read(fileName: 'Bruno_insurance_policy.pdf', petName: 'Bruno', issuedOn: now);
      expect(d.found, isFalse);
      expect(d.type, 'insurance');
      expect(guessTypeFromName('blood_report.jpg'), 'lab');
      expect(guessTypeFromName('IMG_2041.jpg'), 'other');
    });

    test('a read vaccine fills the right row of the schedule', () {
      final birthday = DateTime(2026, 5, 1);
      expect(vaccineSeries('Anti-rabies'), 'rabies');
      expect(vaccineSeries('DHPPi + Lepto'), 'dhppi');
      // Puppy without doses yet: first DHPPi dose.
      expect(
        matchVaccineTemplate(species: Species.dog, vaccineName: 'DHPPi + Lepto', birthday: birthday, givenDate: DateTime(2026, 6, 15), records: const []),
        'dhppi_1',
      );
      // Adult dog: the yearly booster.
      expect(
        matchVaccineTemplate(species: Species.dog, vaccineName: 'Anti-rabies', birthday: DateTime(2022, 1, 1), givenDate: DateTime(2026, 9, 1), records: const []),
        'rabies_booster',
      );
      expect(
        matchVaccineTemplate(species: Species.dog, vaccineName: 'Something new', birthday: birthday, givenDate: now, records: const <VaccineRecord>[]),
        'other',
      );
    });

    test('demo seed documents carry exactly what their sample prints', () {
      for (final key in sampleDocKeys) {
        final on = DateTime(2025, 11, 3);
        final app = sampleDetails(key, petName: 'Bruno', issuedOn: on).toMap();
        expect(printedSample(key, 'Bruno', on), app, reason: key);
        expect(sampleType(key), sampleDocType(key), reason: key);
      }
    });
  });

  group('documents', () {
    VaultDoc doc(String id, Map<String, dynamic> raw) => VaultDoc(id, {'createdAt': now, ...raw});

    test('expiry: valid, soon (30 days), expired', () {
      expect(expiryState(null, now), ExpiryState.none);
      expect(expiryState(now.add(const Duration(days: 31)), now), ExpiryState.valid);
      expect(expiryState(now.add(const Duration(days: 30)), now), ExpiryState.soon);
      expect(expiryState(DateTime(2026, 10, 14), now), ExpiryState.soon);
      expect(expiryState(DateTime(2026, 10, 13), now), ExpiryState.expired);
    });

    test('expiry reminder 14 days before at 10 am, or tomorrow when that has passed', () {
      expect(expiryReminderAt(DateTime(2026, 12, 1), now), DateTime(2026, 11, 17, 10));
      expect(expiryReminderAt(DateTime(2026, 10, 20), now), DateTime(2026, 10, 15, 10));
      expect(expiryReminderAt(DateTime(2026, 10, 1), now), isNull);
    });

    test('search looks at the title, tags, notes and read details', () {
      final d = doc('a', {
        'title': 'Anti-rabies certificate',
        'tags': ['2025'],
        'extracted': {'clinicName': 'Gulmohar Vet Studio'},
      });
      expect(docMatches(d, 'rabies'), isTrue);
      expect(docMatches(d, 'gulmohar 2025'), isTrue);
      expect(docMatches(d, 'Bruno', petName: 'Bruno'), isTrue);
      expect(docMatches(d, 'insurance'), isFalse);
    });

    test('documents waiting for review come first, then those expiring soon', () {
      final list = sortDocs([
        doc('old', {'createdAt': now.subtract(const Duration(days: 9))}),
        doc('soon', {'expiry': now.add(const Duration(days: 5)), 'createdAt': now.subtract(const Duration(days: 300))}),
        doc('review', {'readStatus': 'pending', 'createdAt': now.subtract(const Duration(days: 20))}),
        doc('new', {}),
      ], now);
      expect(list.map((d) => d.id), ['review', 'soon', 'new', 'old']);
    });

    test('tags are cleaned and counted', () {
      expect(cleanTags([' rabies ', 'Rabies', '', 'lab  report']), ['rabies', 'lab report']);
      final docs = [
        doc('a', {'tags': ['rabies', '2025']}),
        doc('b', {'tags': ['rabies']}),
      ];
      expect(popularTags(docs), ['rabies', '2025']);
    });
  });

  group('storage', () {
    test('free 1 GB and Plus 25 GB', () {
      final free = computeUsage(docSizes: [300 * 1024 * 1024], albumSizes: [650 * 1024 * 1024], limitGb: 1);
      expect(free.usedBytes, 950 * 1024 * 1024);
      expect(free.nearlyFull, isTrue);
      expect(free.canAdd(100 * 1024 * 1024), isFalse);
      final plus = computeUsage(docSizes: [300 * 1024 * 1024], albumSizes: [650 * 1024 * 1024], limitGb: 25);
      expect(plus.nearlyFull, isFalse);
      expect(plus.canAdd(100 * 1024 * 1024), isTrue);
    });

    test('sizes read naturally', () {
      expect(formatBytes(512), '512 B');
      expect(formatBytes(950 * 1024), '950 KB');
      expect(formatBytes((12.4 * 1024 * 1024).round()), '12.4 MB');
      expect(formatBytes(1024 * 1024 * 1024), '1 GB');
    });

    test('video length limits: 60 s free, 3 min Plus', () {
      expect(videoWithinLimit(60, 60), isTrue);
      expect(videoWithinLimit(61, 60), isFalse);
      expect(videoWithinLimit(170, 180), isTrue);
    });
  });

  group('insurance', () {
    final policy = InsurancePolicy('p', {
      'cover': 100000,
      'claims': [
        {'id': 'a', 'date': DateTime(2026, 5, 1), 'amount': 4200, 'settledAmount': 3800, 'status': 'paid'},
        {'id': 'b', 'date': DateTime(2026, 9, 3), 'amount': 1850, 'status': 'in_review'},
      ],
    });

    test('cover left counts only paid claims', () {
      expect(policy.claims.first.id, 'b');
      expect(policy.claimedThisYear, 3800);
      expect(policy.coverLeft, 96200);
    });

    test('renewal states', () {
      expect(renewalState(null, now), RenewalState.unknown);
      expect(renewalState(now.add(const Duration(days: 20)), now), RenewalState.renewSoon);
      expect(renewalState(now.add(const Duration(days: 60)), now), RenewalState.active);
      expect(renewalState(now.subtract(const Duration(days: 1)), now), RenewalState.lapsed);
    });

    test('claim steps and the documents checklist', () {
      expect(nextClaimStatuses('draft'), ['submitted']);
      expect(nextClaimStatuses('in_review'), ['approved', 'rejected']);
      expect(nextClaimStatuses('paid'), isEmpty);
      final c = Claim({'checklist': {'claim_form': true}});
      expect(readyToSubmit(c.checklist), isFalse);
      expect(readyToSubmit({...c.checklist, 'vet_bills': true}), isTrue);
      expect(checklistProgress({'a': true, 'b': false}), 0.5);
    });
  });

  group('album', () {
    AlbumItem item(String id, DateTime at, {String type = 'photo', String? milestone}) =>
        AlbumItem(id, {'type': type, 'url': type == 'milestone' ? null : 'seed:album:dog:1', 'takenAt': at, 'milestone': milestone});

    test('photos are grouped by month, newest first', () {
      final groups = groupByMonth([
        item('a', DateTime(2026, 9, 3)),
        item('b', DateTime(2026, 10, 1)),
        item('c', DateTime(2026, 9, 28)),
        item('d', DateTime(2025, 10, 14)),
      ]);
      expect(groups.map((g) => g.month), [DateTime(2026, 10), DateTime(2026, 9), DateTime(2025, 10)]);
      expect(groups[1].items.map((i) => i.id), ['c', 'a']);
    });

    test('On this day finds earlier years only', () {
      final list = onThisDay([
        item('lastYear', DateTime(2025, 10, 14, 8)),
        item('today', DateTime(2026, 10, 14, 7)),
        item('otherDay', DateTime(2025, 10, 15)),
        item('noPhoto', DateTime(2024, 10, 14), type: 'milestone', milestone: 'custom'),
      ], now);
      expect(list.map((i) => i.id), ['lastYear']);
    });

    test('milestones read like a story and earn badges', () {
      final items = [
        item('walk', DateTime(2024, 3, 1), milestone: 'first_walk'),
        item('home', DateTime(2024, 1, 1), milestone: 'gotcha'),
        item('plain', DateTime(2024, 2, 1)),
      ];
      expect(milestones(items).map((i) => i.id), ['home', 'walk']);
      expect(earnedBadges(items), {'gotcha', 'first_walk'});
      expect(latestMemory(items)!.id, 'walk');
    });

    test('birthdays, including 29 February', () {
      expect(nextBirthday(DateTime(2023, 10, 14), now), DateTime(2026, 10, 14));
      expect(isBirthdayToday(DateTime(2023, 10, 14), now), isTrue);
      expect(nextBirthday(DateTime(2023, 10, 13), now), DateTime(2027, 10, 13));
      expect(nextBirthday(DateTime(2024, 2, 29), now), DateTime(2027, 2, 28));
      expect(turningAge(DateTime(2023, 10, 14), DateTime(2026, 10, 14)), 3);
      expect(daysUntil(DateTime(2026, 10, 20), now), 6);
    });
  });

  group('document scan', () {
    test('finds a bright page on a dark table', () {
      const w = 40, h = 40;
      final px = <int>[];
      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          final page = x >= 8 && x < 32 && y >= 4 && y < 36;
          final v = page ? 240 : 40;
          px.addAll([v, v, v, 255]);
        }
      }
      final r = findDocumentBounds(px, w, h);
      expect(r.left, closeTo(0.2, 0.05));
      expect(r.right, closeTo(0.8, 0.05));
      expect(r.top, closeTo(0.1, 0.05));
      expect(r.bottom, closeTo(0.9, 0.05));
    });

    test('falls back to the whole photo when there is no clear page', () {
      expect(findDocumentBounds(List.filled(20 * 20 * 4, 128), 20, 20), NormRect.fallback);
    });
  });

  group('demo data', () {
    final data = DemoSeed.build(now);

    test('Bruno has documents, a policy with claims, and an album across months', () {
      final docs = data['documents']!.values.where((d) => d['petId'] == 'pet_bruno').toList();
      expect(docs.length, greaterThanOrEqualTo(5));
      final album = [for (final e in data['album']!.entries) if (e.value['petId'] == 'pet_bruno') AlbumItem(e.key, e.value)];
      expect(album.length, inInclusiveRange(10, 20));
      expect(groupByMonth(album.where((i) => i.hasMedia)).length, greaterThanOrEqualTo(6));
      expect(onThisDay(album, now), isNotEmpty);
      final policy = InsurancePolicy('ins_bruno', data['insurance']!['ins_bruno']!);
      expect(policy.claims.length, 2);
      expect(data['documents']![policy.docId], isNotNull);
    });

    test('one active, one revoked and one PIN share link for Bruno', () {
      final links = [for (final e in data['shareLinks']!.entries) ShareLink(e.key, e.value)];
      final bruno = links.where((l) => l.petId == 'pet_bruno').toList();
      expect(bruno.map((l) => checkShare(l, now: now)), containsAll([ShareStatus.ok, ShareStatus.revoked, ShareStatus.needsPin]));
      final family = bruno.firstWhere((l) => l.kind == 'album');
      expect(checkShare(family, pin: '2580', now: now), ShareStatus.ok);
      // functions/src/phase7.test.ts checks the server accepts this same hash.
      expect(family.pinHash, 'pbkdf2\$1000\$CzBVep/E6Q4zWH2ix+wRNg==\$kLYhXiEs6+eIC4XBYSJh8qUlT0TO5pJY1cOG2rOJm8U=');
      for (final l in links) {
        for (final id in l.docIds) {
          expect(data['documents']![id], isNotNull, reason: id);
        }
      }
    });

    test('certificates are linked to their vaccine records', () {
      final linked = data['vaccinations']!.values.where((v) => v['certificateDocId'] != null).toList();
      expect(linked.length, greaterThanOrEqualTo(6));
      for (final v in linked) {
        final d = data['documents']![v['certificateDocId']]!;
        expect(d['petId'], v['petId']);
        expect((d['extracted'] as Map)['dateGiven'], DateTime((v['givenDate'] as DateTime).year, (v['givenDate'] as DateTime).month, (v['givenDate'] as DateTime).day));
      }
    });
  });
}
