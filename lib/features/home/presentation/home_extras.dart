import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pets/domain/pet.dart';

/// Home sections owned by later phases. Each phase replaces its function:
/// Next up (Phase 4), food running low (Phase 8), latest memory (Phase 7).
List<Widget> nextUpSection(BuildContext context, WidgetRef ref, {required List<Pet> pets}) => const [];
List<Widget> foodLowSection(BuildContext context, WidgetRef ref, Pet pet) => const [];
List<Widget> latestMemorySection(BuildContext context, WidgetRef ref, Pet pet) => const [];

String get askVetLink => '/coming-soon?phase=6&title=Tele-vet';
String addPhotoLink(String petId) => '/coming-soon?phase=7&title=Album';
