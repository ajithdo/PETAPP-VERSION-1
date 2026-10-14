import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/core/auth/app_user.dart';
import 'package:pawsetu/core/demo/demo_store.dart';
import 'package:pawsetu/core/demo/seed/seed.dart';
import 'package:pawsetu/core/services/messaging_service.dart';
import 'package:pawsetu/features/family/data/family_repository.dart';
import 'package:pawsetu/features/pets/domain/pet.dart';

void main() {
  late FakeFirebaseFirestore db;
  late FamilyRepository repo;
  const priya = AppUser(uid: 'u_priya', role: UserRole.owner, name: 'Priya Sharma', email: 'priya@example.com');
  const ravi = AppUser(uid: 'u_ravi', role: UserRole.owner, name: 'Ravi Teja', email: 'ravi@example.com', phone: '+91 90000 00002');

  setUp(() async {
    db = FakeFirebaseFirestore();
    await DemoStore.loadInto(db, DemoSeed.build(DateTime(2026, 10, 14)));
    repo = FamilyRepository(db, DemoMessagingService(db));
  });

  Future<Pet> bruno() async {
    final d = await db.collection('pets').doc('pet_bruno').get();
    return Pet.fromJson({...d.data()!, 'id': d.id});
  }

  test('an invite by phone reaches that account and adds them on accept', () async {
    await repo.invite(petId: 'pet_bruno', petName: 'Bruno', from: priya, role: 'viewer', contact: '+919000000002');
    final invites = await repo.watchMyInvites(ravi).first;
    expect(invites, hasLength(1));
    await repo.accept(invites.single, ravi);
    final pet = await bruno();
    expect(pet.memberIds, contains('u_ravi'));
    expect(pet.roleOf('u_ravi'), PetRole.viewer);
    expect(pet.canDelete('u_ravi'), isFalse);
    final sms = await db.collection('outbox').where('type', isEqualTo: 'family_invite').get();
    expect(sms.docs.single.data()['channel'], 'sms');
  });

  test('sitter access expires on its own', () async {
    final inv = await repo.invite(
        petId: 'pet_bruno', petName: 'Bruno', from: priya, role: 'carer',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)));
    final found = await repo.findByToken(inv.token);
    await repo.accept(found!, ravi);
    expect((await bruno()).canCare('u_ravi'), isFalse);
  });

  test('Priya\'s husband is a carer: can care, cannot delete', () async {
    final pet = await bruno();
    expect(pet.canCare('u_rohan'), isTrue);
    expect(pet.canDelete('u_rohan'), isFalse);
  });

  test('removing a member takes away access', () async {
    await repo.removeMember('pet_bruno', 'u_rohan', 'Rohan Sharma', priya);
    final pet = await bruno();
    expect(pet.memberIds, isNot(contains('u_rohan')));
    expect(pet.members.containsKey('u_rohan'), isFalse);
  });

  test('Arjun\'s sitter has an expiry date', () async {
    final d = await db.collection('pets').doc('pet_max').get();
    final max = Pet.fromJson({...d.data()!, 'id': d.id});
    expect(max.members['u_meera']!.expiresAt, isNotNull);
    expect(max.canCare('u_meera'), isTrue);
  });
}
