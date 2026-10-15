import 'dart:math' as math;

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/auth/app_user.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/core/demo/seed/seed_places.dart';
import 'package:pawsetu/core/l10n/gen/app_localizations.dart';
import 'package:pawsetu/core/services/messaging_service.dart';
import 'package:pawsetu/features/pets/domain/pet.dart';
import 'package:pawsetu/features/routine/data/routine_repository.dart';
import 'package:pawsetu/features/sos/data/device_repository.dart';
import 'package:pawsetu/features/sos/data/lost_repository.dart';
import 'package:pawsetu/features/sos/data/safety_notify.dart';
import 'package:pawsetu/features/sos/domain/devices.dart';
import 'package:pawsetu/features/sos/domain/lost_rules.dart';
import 'package:pawsetu/features/sos/domain/sos_rules.dart';
import 'package:pawsetu/features/sos/domain/toxic.dart';
import 'package:pawsetu/features/sos/presentation/safety_labels.dart';

void main() {
  final now = DateTime(2026, 10, 14, 11); // a Wednesday, 11 am
  final en = lookupAppLocalizations(const Locale('en'));
  final hi = lookupAppLocalizations(const Locale('hi'));
  final te = lookupAppLocalizations(const Locale('te'));

  List<String> names(ToxItem t) => [toxText(en, t.id).$1, toxText(hi, t.id).$1, toxText(te, t.id).$1];

  group('toxic food and plant checker (spec 7.14)', () {
    test('finds items by name, in a question, and in Hindi and Telugu', () {
      expect(searchToxic('chocolate', names: names).first.id, 'chocolate');
      expect(searchToxic('Can my dog eat grapes?', names: names).first.id, 'grapes');
      expect(searchToxic('kishmish', names: names).first.id, 'grapes');
      expect(searchToxic('प्याज', names: names).first.id, 'onionGarlic');
      expect(searchToxic('ద్రాక్ష', names: names).first.id, 'grapes');
      expect(searchToxic('kaner', names: names).first.id, 'oleander');
    });

    test('English words match whole words only ("rat" is not in "carrot")', () {
      final r = searchToxic('carrot', names: names);
      expect(r.first.id, 'carrot');
      expect(r.map((t) => t.id), isNot(contains('ratPoison')));
      expect(searchToxic('steak', names: names).map((t) => t.id), isNot(contains('caffeine')));
    });

    test('species-aware: lilies are dangerous for cats, avocado for birds', () {
      expect(toxItem('lily')!.levelFor('cat'), ToxLevel.danger);
      expect(toxItem('lily')!.levelFor('dog'), ToxLevel.caution);
      expect(toxItem('avocado')!.levelFor('bird'), ToxLevel.danger);
      expect(toxItem('apple')!.levelFor('rabbit'), ToxLevel.safe);
      // Cooking fumes are a bird problem only.
      expect(searchToxic('', species: 'dog').map((t) => t.id), isNot(contains('nonStickFumes')));
      expect(searchToxic('', species: 'bird').map((t) => t.id), contains('nonStickFumes'));
    });

    test('an empty search lists the most dangerous first, and kinds filter', () {
      final all = searchToxic('', species: 'cat');
      expect(all.first.levelFor('cat'), ToxLevel.danger);
      expect(all.last.levelFor('cat'), ToxLevel.safe);
      expect(searchToxic('', kind: ToxKind.plant).every((t) => t.kind == ToxKind.plant), isTrue);
    });

    test('every item and guide has text in all three languages', () {
      for (final t in toxItems) {
        for (final l in [en, hi, te]) {
          final (n, why) = toxText(l, t.id);
          expect(n, isNotEmpty, reason: t.id);
          expect(why, isNotEmpty, reason: t.id);
        }
      }
      expect(toxItems.map((t) => t.id).toSet(), hasLength(toxItems.length));
      for (final id in firstAidIds) {
        for (final l in [en, hi, te]) {
          final g = firstAidText(l, id);
          expect(g.steps.length, greaterThanOrEqualTo(4), reason: '$id ${l.localeName}');
          expect(g.avoid.length, greaterThanOrEqualTo(3), reason: '$id ${l.localeName}');
        }
        // The same number of steps in every language.
        expect(firstAidText(hi, id).steps.length, firstAidText(en, id).steps.length, reason: id);
        expect(firstAidText(te, id).steps.length, firstAidText(en, id).steps.length, reason: id);
      }
    });
  });

  group('SOS (spec 7.12)', () {
    SosClinic clinic(String id, double lat, double lng, {bool is24x7 = false, bool openNow = true}) => SosClinic(
          id: id,
          name: id,
          address: 'Road',
          area: 'Area',
          city: 'City',
          lat: lat,
          lng: lng,
          phone: '+91 90000 00099',
          emergencyPhone: is24x7 ? '+91 90000 00012' : null,
          is24x7: is24x7,
          hours: is24x7 ? standardHours(true) : (openNow ? standardHours(false) : const {}),
        );

    test('open-now and 24x7 clinics first, each group nearest first', () {
      final here = areas['indiranagar']!;
      final ranked = rankSosClinics([
        clinic('closed-near', here.lat + 0.001, here.lng, openNow: false),
        clinic('open-far', here.lat + 0.05, here.lng),
        clinic('24x7-mid', here.lat + 0.02, here.lng, is24x7: true),
        clinic('open-near', here.lat + 0.004, here.lng),
      ], lat: here.lat, lng: here.lng, now: now);
      expect(ranked.map((r) => r.clinic.id), ['open-near', '24x7-mid', 'open-far', 'closed-near']);
      expect(ranked[1].clinic.callNumber, '+91 90000 00012');
    });

    test('location: GPS, then a recent last-known fix, then the chosen area', () {
      const chosen = SosSpot(lat: 1, lng: 1, source: SosSource.chosen, label: 'Indiranagar');
      final gps = SosSpot(lat: 2, lng: 2, source: SosSource.gps, at: now);
      final recent = SosSpot(lat: 3, lng: 3, source: SosSource.lastKnown, at: now.subtract(const Duration(hours: 2)));
      final old = SosSpot(lat: 4, lng: 4, source: SosSource.lastKnown, at: now.subtract(const Duration(days: 2)));
      expect(pickSosSpot(gps: gps, lastKnown: recent, chosen: chosen, now: now).source, SosSource.gps);
      expect(pickSosSpot(lastKnown: recent, chosen: chosen, now: now).lat, 3);
      // Location off and no recent fix: falls back to the chosen area.
      expect(pickSosSpot(lastKnown: old, chosen: chosen, now: now).source, SosSource.chosen);
      expect(pickSosSpot(chosen: chosen, now: now).label, 'Indiranagar');
      expect(sosSourceId(SosSource.lastKnown), 'last_known');
    });

    test('saved clinics survive a round trip (works on weak internet)', () {
      final list = [clinic('a', 12.9, 77.6, is24x7: true), clinic('b', 12.95, 77.65)];
      final back = decodeSavedClinics(encodeSavedClinics(list, now))!;
      expect(back.at, now);
      expect(back.clinics.map((c) => c.id), ['a', 'b']);
      expect(back.clinics.first.openAt(now), isTrue);
      expect(decodeSavedClinics('not json'), isNull);
      final spot = decodeSpot(encodeSpot(SosSpot(lat: 12.97, lng: 77.64, source: SosSource.gps, at: now)))!;
      expect(spot.source, SosSource.lastKnown);
      expect(spot.at, now);
    });

    test('only the nearest clinics are saved', () {
      final here = areas['banjara']!;
      final many = [for (var i = 0; i < 30; i++) clinic('c$i', here.lat + i * 0.01, here.lng)];
      final saved = clinicsToSave(many.reversed, lat: here.lat, lng: here.lng);
      expect(saved, hasLength(savedClinicsCount));
      expect(saved.first.id, 'c0');
    });
  });

  group('connected devices (spec 7.13)', () {
    const zone = SafeZone(lat: 19.0596, lng: 72.8295, radiusM: 400);
    final collar = Device('dev_max_collar', {'type': 'gps_collar', 'safeZone': zone.toMap(), 'name': "Max's GPS collar", 'petId': 'pet_max'});

    test('safe-zone alert fires once, when the collar goes out', () {
      expect(shouldAlertLeftZone(wasInside: true, isInside: false), isTrue);
      expect(shouldAlertLeftZone(wasInside: null, isInside: false), isTrue);
      expect(shouldAlertLeftZone(wasInside: false, isInside: false), isFalse);
      expect(shouldAlertLeftZone(wasInside: false, isInside: true), isFalse);
      expect(insideZone(zone.lat, zone.lng, zone), isTrue);
      expect(insideZone(zone.lat + 0.01, zone.lng, zone), isFalse); // about 1.1 km north
    });

    test('the demo collar stays inside, and walks out when asked', () {
      for (var m = 0; m < 120; m += 7) {
        expect(demoCollarFix(collar, now.add(Duration(minutes: m))).inside, isTrue);
      }
      final start = now;
      final halfway = demoCollarFix(collar, start.add(const Duration(seconds: 2)), walkOutAt: start);
      expect(halfway.inside, isTrue);
      final out = demoCollarFix(collar, start.add(const Duration(seconds: 25)), walkOutAt: start);
      expect(out.inside, isFalse);
      expect(out.metersFromHome, closeTo(640, 15)); // 1.6 × 400 m
    });

    test('activity sessions count only once they have happened, with stable ids', () {
      final tracker = Device('dev_bruno_tracker', {'type': 'activity_tracker'});
      final morning = demoActivity(tracker, now, DateTime(2026, 10, 14, 5));
      expect(morning.sessions, isEmpty);
      final night = demoActivity(tracker, now, DateTime(2026, 10, 14, 23));
      expect(night.sessions, hasLength(3));
      expect(night.sessions.map((s) => s.kind), ['walk', 'play', 'walk']);
      expect(night.steps, greaterThan(night.sessions.fold<int>(0, (a, s) => a + s.steps)));
      expect(demoActivity(tracker, now, DateTime(2026, 10, 14, 23)).sessions.first.id, night.sessions.first.id);
      expect(night.sessions.first.id, startsWith('dev_dev_bruno_tracker_20261014_'));
    });

    test('which devices suit which pets', () {
      expect(deviceSuits(DeviceType.litterBox, 'cat'), isTrue);
      expect(deviceSuits(DeviceType.litterBox, 'dog'), isFalse);
      expect(deviceSuits(DeviceType.gpsCollar, 'bird'), isFalse);
      expect(deviceSuits(DeviceType.fountain, 'rabbit'), isTrue);
      expect(deviceTypeFrom('gps_collar'), DeviceType.gpsCollar);
    });
  });

  group('lost pet mode (spec 7.14)', () {
    test('tags are long, random and unambiguous; the page link is public', () {
      final a = newQrToken(math.Random(1)), b = newQrToken(math.Random(2));
      expect(a, hasLength(16));
      expect(a, isNot(b));
      expect(RegExp(r'^[A-HJ-NP-Za-km-z2-9]+$').hasMatch(a), isTrue);
      expect(lostPageUrl('Bq7KpX2mVn9RtLw4', webBase: 'http://localhost:8090/'), 'http://localhost:8090/#/lost/Bq7KpX2mVn9RtLw4');
    });

    test('the public view never shows the family, phone or medical details', () {
      final v = publicPetView({
        'name': 'Bruno',
        'species': 'dog',
        'ownerId': 'u_priya',
        'memberIds': ['u_priya', 'u_rohan'],
        'members': {'u_priya': {'role': 'owner'}},
        'allergies': ['chicken'],
        'microchip': '9851',
        'lost': {'since': now, 'area': 'Indiranagar', 'reportId': 'r1', 'note': 'Red collar'},
      });
      expect(v.keys, isNot(containsAll(['ownerId', 'memberIds', 'members', 'allergies', 'microchip'])));
      expect(v['name'], 'Bruno');
      expect((v['lost'] as Map)['area'], 'Indiranagar');
      expect((v['lost'] as Map).containsKey('reportId'), isFalse);
    });

    test('nearby alerts: opted-in people within 5 km, not the family', () {
      final home = areas['indiranagar']!;
      final uids = nearbyAlertUids([
        (uid: 'near', lat: home.lat + 0.01, lng: home.lng, optIn: true),
        (uid: 'near-but-off', lat: home.lat + 0.01, lng: home.lng, optIn: false),
        (uid: 'far', lat: home.lat + 0.2, lng: home.lng, optIn: true),
        (uid: 'family', lat: home.lat, lng: home.lng, optIn: true),
        (uid: 'unknown-home', lat: null, lng: null, optIn: true),
      ], lat: home.lat, lng: home.lng, except: {'family'});
      expect(uids, ['near']);
    });

    test('a finder can send at most 5 messages per tag per hour', () {
      final recent = [for (var i = 0; i < 5; i++) now.subtract(Duration(minutes: i * 5))];
      expect(relayAllowed(recent.take(4), now), isTrue);
      expect(relayAllowed(recent, now), isFalse);
      expect(relayAllowed(recent, now.add(const Duration(hours: 2))), isTrue);
    });
  });

  group('with the demo data', () {
    late FakeFirebaseFirestore db;
    late SafetyNotifier notifier;
    const priya = AppUser(uid: 'u_priya', role: UserRole.owner, name: 'Priya Sharma', email: 'priya@example.com');
    const arjun = AppUser(uid: 'u_arjun', role: UserRole.owner, name: 'Arjun Mehta', email: 'arjun@example.com');

    setUp(() async {
      db = FakeFirebaseFirestore();
      await DemoStore.loadInto(db, DemoSeed.build(now));
      notifier = SafetyNotifier(db, DemoMessagingService(db));
    });

    Future<Pet> pet(String id) async {
      final d = await db.collection('pets').doc(id).get();
      return Pet.fromJson({...d.data()!, 'id': d.id});
    }

    test('every pet has a working tag; Bruno and Max have a device', () async {
      final pets = await db.collection('pets').get();
      for (final p in pets.docs) {
        expect((p.data()['qrToken'] as String).length, 16, reason: p.id);
      }
      final devices = await db.collection('devices').get();
      expect(devices.docs.map((d) => d.data()['petId']), containsAll(['pet_bruno', 'pet_max']));
      final collar = devices.docs.firstWhere((d) => d.id == 'dev_max_collar').data();
      expect((collar['safeZone'] as Map)['radiusM'], 400);
      expect((await db.collection('sosLogs').get()).docs.length, greaterThanOrEqualTo(10));
    });

    test("opening Bruno's QR link shows his page, without private details", () async {
      final service = LocalLostPageService(db, notifier);
      final v = await service.open('Bq7KpX2mVn9RtLw4');
      expect(v.status, LostPageStatus.ok);
      expect(v.name, 'Bruno');
      expect(v.pet.containsKey('memberIds'), isFalse);
      expect((await service.open('nope')).status, LostPageStatus.notFound);
    });

    test('mark Bruno lost: family told, 3 neighbours within 5 km alerted, then found', () async {
      final repo = LostRepository(db, notifier, standalone: true);
      final bruno = await pet('pet_bruno');
      final home = areas['indiranagar']!;
      final sent = await repo.markLost(pet: bruno, by: priya, since: now, area: 'Indiranagar', lat: home.lat, lng: home.lng, note: 'Red collar', alert: true);
      expect(sent, 3);
      final lost = await pet('pet_bruno');
      expect(lost.lost?['area'], 'Indiranagar');
      final notes = await db.collection('notifications').where('type', isEqualTo: 'lost').get();
      final to = notes.docs.map((d) => d.data()['uid']).toSet();
      expect(to, containsAll(['u_rohan', 'u_nb_blr_1', 'u_nb_blr_2', 'u_nb_blr_3']));
      expect(to, isNot(contains('u_priya')));
      expect(to, isNot(contains('u_nb_hyd_1')));
      // The Hindi-speaking neighbour gets it in Hindi.
      final arif = notes.docs.firstWhere((d) => d.data()['uid'] == 'u_nb_blr_2').data();
      expect(arif['title'], hi.lostNearbyTitle('Bruno'));

      // The public page now says he is lost.
      final view = await LocalLostPageService(db, notifier).open('Bq7KpX2mVn9RtLw4');
      expect(view.isLost, isTrue);

      await repo.markFound(pet: lost, by: priya, reportId: lost.lost!['reportId'] as String);
      expect((await pet('pet_bruno')).lost, isNull);
      final report = await db.collection('lostReports').doc(lost.lost!['reportId'] as String).get();
      expect(report.data()!['status'], 'found');
    });

    test("a finder's message and location reach the family; their number stays hidden", () async {
      final service = LocalLostPageService(db, notifier);
      final s = await service.contact('Mx9LcV5tGp2YqHn7', message: 'Found Max near the bandstand', name: 'Sneha', phone: '+91 90000 00099');
      expect(s, LostPageStatus.ok);
      final notes = await db.collection('notifications').where('type', isEqualTo: 'lost').get();
      expect(notes.docs.map((d) => d.data()['uid']).toSet(), containsAll(['u_arjun', 'u_meera']));
      final sms = await db.collection('outbox').where('channel', isEqualTo: 'sms').where('type', isEqualTo: 'lost').get();
      expect(sms.docs, isNotEmpty);
      expect(await service.shareLocation('Mx9LcV5tGp2YqHn7', lat: 19.06, lng: 72.83), LostPageStatus.ok);
    });

    test("Max's collar leaving the safe zone alerts everyone who looks after him", () async {
      final repo = DeviceRepository(db, notifier, RoutineRepository(db), standalone: true);
      final max = await pet('pet_max');
      final d = await repo.watch('dev_max_collar').first;
      final out = demoCollarFix(d!, now.add(const Duration(seconds: 30)), walkOutAt: now);
      expect(out.inside, isFalse);
      expect(await repo.recordZone(device: d, pet: max, fix: out), isTrue);
      final alerts = await db.collection('notifications').where('type', isEqualTo: 'device').where('title', isEqualTo: en.zoneLeftTitle('Max')).get();
      expect(alerts.docs.map((x) => x.data()['uid']).toSet(), containsAll(['u_arjun', 'u_meera']));
      final push = await db.collection('outbox').where('type', isEqualTo: 'device').get();
      expect(push.docs.map((x) => x.data()['channel']).toSet(), containsAll(['push', 'sms']));
      // Still outside on the next reading: no second alert.
      final again = await repo.watch('dev_max_collar').first;
      expect(await repo.recordZone(device: again!, pet: max, fix: out), isFalse);
    });

    test('device activity flows into the routine tracker once', () async {
      final repo = DeviceRepository(db, notifier, RoutineRepository(db), standalone: true);
      final bruno = await pet('pet_bruno');
      final d = (await repo.watch('dev_bruno_tracker').first)!;
      final day = demoActivity(d, now, DateTime(2026, 10, 14, 23));
      expect(await repo.syncActivity(device: d, pet: bruno, by: priya, day: day), 3);
      expect(await repo.syncActivity(device: d, pet: bruno, by: priya, day: day), 0);
      final logs = await db.collection('logs').where('petId', isEqualTo: 'pet_bruno').get();
      final fromDevice = logs.docs.where((x) => (x.data()['data'] as Map?)?['source'] == 'device').toList();
      expect(fromDevice, hasLength(3));
      expect(fromDevice.map((x) => x.data()['type']).toSet(), {'walk', 'play'});
      expect(arjun.uid, 'u_arjun');
    });
  });
}
