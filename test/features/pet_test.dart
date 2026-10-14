import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/features/pets/domain/breeds.dart';
import 'package:pawsetu/features/pets/domain/pet.dart';

void main() {
  final now = DateTime(2026, 10, 14);
  Pet pet(String species, String breed, DateTime birthday) =>
      Pet(ownerId: 'u1', name: 'X', species: species, breedId: breed, birthday: birthday);

  test('life stage depends on species and size', () {
    expect(pet('dog', 'labrador', DateTime(2026, 5, 1)).lifeStage(now), 'young');
    expect(pet('dog', 'labrador', DateTime(2023, 1, 1)).lifeStage(now), 'adult');
    expect(pet('dog', 'great_dane', DateTime(2020, 1, 1)).lifeStage(now), 'senior');
    expect(pet('dog', 'pug', DateTime(2020, 1, 1)).lifeStage(now), 'adult');
    expect(pet('cat', 'indie_cat', DateTime(2015, 1, 1)).lifeStage(now), 'senior');
  });

  test('family roles: carer access expires', () {
    final p = Pet(ownerId: 'o', name: 'Max', species: 'dog', members: {
      'o': const PetMember(role: 'owner'),
      's': PetMember(role: 'carer', expiresAt: DateTime.now().add(const Duration(days: 3))),
      'old': PetMember(role: 'carer', expiresAt: DateTime.now().subtract(const Duration(days: 1))),
      'v': const PetMember(role: 'viewer'),
    });
    expect(p.roleOf('o'), PetRole.owner);
    expect(p.canCare('s'), isTrue);
    expect(p.canDelete('s'), isFalse);
    expect(p.canCare('old'), isFalse);
    expect(p.canEdit('v'), isFalse);
  });

  test('bird list leaves out protected native species', () {
    final birds = breedsFor(Species.bird).map((b) => b.en.toLowerCase()).join(' ');
    for (final banned in ['ringneck', 'alexandrine', 'plum-headed', 'munia', 'myna']) {
      expect(birds.contains(banned), isFalse, reason: banned);
    }
    expect(breedsFor(Species.dog).length, greaterThanOrEqualTo(40));
  });
}
