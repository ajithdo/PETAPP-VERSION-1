/// Built-in breed lists (spec 7.1) with names in English, Hindi and Telugu.
/// Pure Dart: also used by the seed tool.
library;

enum Species { dog, cat, bird, rabbit }

enum BreedSize { small, medium, large, giant }

class Breed {
  const Breed(this.id, this.species, this.en, this.hi, this.te,
      {this.size = BreedSize.medium, this.flatFaced = false});
  final String id;
  final Species species;
  final String en;
  final String hi;
  final String te;
  final BreedSize size;

  /// Brachycephalic breeds get stronger heat warnings (spec 7.3).
  final bool flatFaced;

  String name(String lang) => switch (lang) { 'hi' => hi, 'te' => te, _ => en };
}

const mixedBreedId = 'mixed';
const otherBreedId = 'other';

const breeds = <Breed>[
  // Dogs
  Breed('indie_dog', Species.dog, 'Indian Pariah (Indie)', 'भारतीय परिया (देसी)', 'భారతీయ పరియా (దేశీ)'),
  Breed('labrador', Species.dog, 'Labrador Retriever', 'लैब्राडोर रिट्रीवर', 'లాబ్రడార్ రిట్రీవర్', size: BreedSize.large),
  Breed('golden', Species.dog, 'Golden Retriever', 'गोल्डन रिट्रीवर', 'గోల్డెన్ రిట్రీవర్', size: BreedSize.large),
  Breed('gsd', Species.dog, 'German Shepherd', 'जर्मन शेफर्ड', 'జర్మన్ షెపర్డ్', size: BreedSize.large),
  Breed('beagle', Species.dog, 'Beagle', 'बीगल', 'బీగల్'),
  Breed('pug', Species.dog, 'Pug', 'पग', 'పగ్', size: BreedSize.small, flatFaced: true),
  Breed('shih_tzu', Species.dog, 'Shih Tzu', 'शिह त्ज़ु', 'షిహ్ త్జు', size: BreedSize.small, flatFaced: true),
  Breed('pomeranian', Species.dog, 'Pomeranian', 'पोमेरेनियन', 'పొమరేనియన్', size: BreedSize.small),
  Breed('rottweiler', Species.dog, 'Rottweiler', 'रॉटवीलर', 'రాట్‌వీలర్', size: BreedSize.large),
  Breed('dobermann', Species.dog, 'Dobermann', 'डोबरमैन', 'డోబర్‌మాన్', size: BreedSize.large),
  Breed('husky', Species.dog, 'Siberian Husky', 'साइबेरियन हस्की', 'సైబీరియన్ హస్కీ', size: BreedSize.large),
  Breed('boxer', Species.dog, 'Boxer', 'बॉक्सर', 'బాక్సర్', size: BreedSize.large, flatFaced: true),
  Breed('dachshund', Species.dog, 'Dachshund', 'डैशहुंड', 'డాక్స్‌హండ్', size: BreedSize.small),
  Breed('cocker', Species.dog, 'Cocker Spaniel', 'कॉकर स्पैनियल', 'కాకర్ స్పానియల్'),
  Breed('great_dane', Species.dog, 'Great Dane', 'ग्रेट डेन', 'గ్రేట్ డేన్', size: BreedSize.giant),
  Breed('lhasa', Species.dog, 'Lhasa Apso', 'ल्हासा एप्सो', 'లాసా ఆప్సో', size: BreedSize.small),
  Breed('maltese', Species.dog, 'Maltese', 'माल्टीज़', 'మాల్టీస్', size: BreedSize.small),
  Breed('chihuahua', Species.dog, 'Chihuahua', 'चिहुआहुआ', 'చివావా', size: BreedSize.small),
  Breed('french_bulldog', Species.dog, 'French Bulldog', 'फ्रेंच बुलडॉग', 'ఫ్రెంచ్ బుల్‌డాగ్', size: BreedSize.small, flatFaced: true),
  Breed('english_bulldog', Species.dog, 'English Bulldog', 'इंग्लिश बुलडॉग', 'ఇంగ్లీష్ బుల్‌డాగ్', flatFaced: true),
  Breed('dalmatian', Species.dog, 'Dalmatian', 'डालमेशियन', 'డాల్మేషియన్', size: BreedSize.large),
  Breed('st_bernard', Species.dog, 'Saint Bernard', 'सेंट बर्नार्ड', 'సెయింట్ బెర్నార్డ్', size: BreedSize.giant),
  Breed('border_collie', Species.dog, 'Border Collie', 'बॉर्डर कोली', 'బోర్డర్ కోలీ'),
  Breed('poodle', Species.dog, 'Poodle', 'पूडल', 'పూడిల్'),
  Breed('yorkie', Species.dog, 'Yorkshire Terrier', 'यॉर्कशायर टेरियर', 'యార్క్‌షైర్ టెర్రియర్', size: BreedSize.small),
  Breed('jack_russell', Species.dog, 'Jack Russell Terrier', 'जैक रसेल टेरियर', 'జాక్ రస్సెల్ టెర్రియర్', size: BreedSize.small),
  Breed('malinois', Species.dog, 'Belgian Malinois', 'बेल्जियन मैलिनॉइस', 'బెల్జియన్ మాలినోయిస్', size: BreedSize.large),
  Breed('cane_corso', Species.dog, 'Cane Corso', 'केन कोर्सो', 'కేన్ కోర్సో', size: BreedSize.giant),
  Breed('shiba', Species.dog, 'Shiba Inu', 'शिबा इनु', 'షిబా ఇను'),
  Breed('akita', Species.dog, 'Akita', 'अकिता', 'అకిటా', size: BreedSize.large),
  Breed('samoyed', Species.dog, 'Samoyed', 'समोयड', 'సమోయెడ్', size: BreedSize.large),
  Breed('tibetan_mastiff', Species.dog, 'Tibetan Mastiff', 'तिब्बती मास्टिफ़', 'టిబెటన్ మాస్టిఫ్', size: BreedSize.giant),
  Breed('rajapalayam', Species.dog, 'Rajapalayam', 'राजपालयम', 'రాజపాళయం', size: BreedSize.large),
  Breed('mudhol', Species.dog, 'Mudhol Hound', 'मुधोल हाउंड', 'ముధోల్ హౌండ్', size: BreedSize.large),
  Breed('kombai', Species.dog, 'Kombai', 'कोम्बई', 'కొంబై', size: BreedSize.large),
  Breed('chippiparai', Species.dog, 'Chippiparai', 'चिप्पीपराई', 'చిప్పిపరై', size: BreedSize.large),
  Breed('kanni', Species.dog, 'Kanni', 'कन्नी', 'కన్ని', size: BreedSize.large),
  Breed('rampur', Species.dog, 'Rampur Hound', 'रामपुर हाउंड', 'రాంపూర్ హౌండ్', size: BreedSize.large),
  Breed('gaddi', Species.dog, 'Gaddi Kutta', 'गद्दी कुत्ता', 'గద్దీ కుత్తా', size: BreedSize.giant),
  Breed('bakharwal', Species.dog, 'Bakharwal', 'बखरवाल', 'బఖర్వాల్', size: BreedSize.giant),
  Breed('himalayan_sheepdog', Species.dog, 'Himalayan Sheepdog', 'हिमालयन शीपडॉग', 'హిమాలయన్ షీప్‌డాగ్', size: BreedSize.large),
  Breed('jonangi', Species.dog, 'Jonangi', 'जोनांगी', 'జొనంగి'),
  Breed('pandikona', Species.dog, 'Pandikona', 'पांडिकोना', 'పందికోన'),
  // Cats
  Breed('indie_cat', Species.cat, 'Indian Domestic (Indie)', 'भारतीय घरेलू (देसी)', 'భారతీయ దేశీ పిల్లి', size: BreedSize.small),
  Breed('persian', Species.cat, 'Persian', 'पर्शियन', 'పర్షియన్', size: BreedSize.small, flatFaced: true),
  Breed('siamese', Species.cat, 'Siamese', 'स्यामी', 'సియామీస్', size: BreedSize.small),
  Breed('himalayan_cat', Species.cat, 'Himalayan', 'हिमालयन', 'హిమాలయన్', size: BreedSize.small, flatFaced: true),
  Breed('maine_coon', Species.cat, 'Maine Coon', 'मेन कून', 'మెయిన్ కూన్'),
  Breed('bengal', Species.cat, 'Bengal', 'बंगाल', 'బెంగాల్', size: BreedSize.small),
  Breed('british_sh', Species.cat, 'British Shorthair', 'ब्रिटिश शॉर्टहेयर', 'బ్రిటిష్ షార్ట్‌హెయిర్', size: BreedSize.small),
  Breed('ragdoll', Species.cat, 'Ragdoll', 'रैगडॉल', 'రాగ్‌డాల్'),
  Breed('scottish_fold', Species.cat, 'Scottish Fold', 'स्कॉटिश फोल्ड', 'స్కాటిష్ ఫోల్డ్', size: BreedSize.small),
  Breed('sphynx', Species.cat, 'Sphynx', 'स्फिंक्स', 'స్ఫింక్స్', size: BreedSize.small),
  Breed('russian_blue', Species.cat, 'Russian Blue', 'रशियन ब्लू', 'రష్యన్ బ్లూ', size: BreedSize.small),
  Breed('abyssinian', Species.cat, 'Abyssinian', 'एबिसिनियन', 'అబిసీనియన్', size: BreedSize.small),
  Breed('exotic_sh', Species.cat, 'Exotic Shorthair', 'एक्सोटिक शॉर्टहेयर', 'ఎక్సోటిక్ షార్ట్‌హెయిర్', size: BreedSize.small, flatFaced: true),
  Breed('american_sh', Species.cat, 'American Shorthair', 'अमेरिकन शॉर्टहेयर', 'అమెరికన్ షార్ట్‌హెయిర్', size: BreedSize.small),
  Breed('birman', Species.cat, 'Birman', 'बर्मन', 'బర్మన్', size: BreedSize.small),
  Breed('bombay', Species.cat, 'Bombay', 'बॉम्बे', 'బాంబే', size: BreedSize.small),
  // Birds (no protected native Indian species, see birdLegalNote)
  Breed('budgie', Species.bird, 'Budgerigar', 'बजरीगर', 'బడ్జరిగర్', size: BreedSize.small),
  Breed('cockatiel', Species.bird, 'Cockatiel', 'कॉकटेल', 'కాకటీల్', size: BreedSize.small),
  Breed('lovebird', Species.bird, 'Lovebird', 'लवबर्ड', 'లవ్‌బర్డ్', size: BreedSize.small),
  Breed('african_grey', Species.bird, 'African Grey', 'अफ्रीकन ग्रे', 'ఆఫ్రికన్ గ్రే'),
  Breed('sun_conure', Species.bird, 'Sun Conure', 'सन कोन्योर', 'సన్ కోన్యూర్', size: BreedSize.small),
  Breed('gc_conure', Species.bird, 'Green-cheeked Conure', 'ग्रीन-चीक्ड कोन्योर', 'గ్రీన్-చీక్డ్ కోన్యూర్', size: BreedSize.small),
  Breed('cockatoo', Species.bird, 'Cockatoo', 'कॉकटू', 'కాకటూ'),
  Breed('macaw', Species.bird, 'Macaw', 'मकाउ', 'మకావ్', size: BreedSize.large),
  Breed('eclectus', Species.bird, 'Eclectus', 'एक्लेक्टस', 'ఎక్లెక్టస్'),
  Breed('canary', Species.bird, 'Canary', 'कैनरी', 'కానరీ', size: BreedSize.small),
  Breed('zebra_finch', Species.bird, 'Zebra Finch', 'ज़ेबरा फिंच', 'జీబ్రా ఫించ్', size: BreedSize.small),
  Breed('java_sparrow', Species.bird, 'Java Sparrow', 'जावा स्पैरो', 'జావా స్పారో', size: BreedSize.small),
  Breed('pigeon', Species.bird, 'Domestic Pigeon', 'पालतू कबूतर', 'పెంపుడు పావురం', size: BreedSize.small),
  // Rabbits
  Breed('holland_lop', Species.rabbit, 'Holland Lop', 'हॉलैंड लॉप', 'హాలండ్ లాప్', size: BreedSize.small),
  Breed('netherland_dwarf', Species.rabbit, 'Netherland Dwarf', 'नीदरलैंड ड्वार्फ', 'నెదర్లాండ్ డ్వార్ఫ్', size: BreedSize.small),
  Breed('lionhead', Species.rabbit, 'Lionhead', 'लायनहेड', 'లయన్‌హెడ్', size: BreedSize.small),
  Breed('mini_rex', Species.rabbit, 'Mini Rex', 'मिनी रेक्स', 'మినీ రెక్స్', size: BreedSize.small),
  Breed('mini_lop', Species.rabbit, 'Mini Lop', 'मिनी लॉप', 'మినీ లాప్', size: BreedSize.small),
  Breed('dutch', Species.rabbit, 'Dutch', 'डच', 'డచ్', size: BreedSize.small),
  Breed('nz_white', Species.rabbit, 'New Zealand White', 'न्यूज़ीलैंड व्हाइट', 'న్యూజిలాండ్ వైట్'),
  Breed('flemish_giant', Species.rabbit, 'Flemish Giant', 'फ्लेमिश जायंट', 'ఫ్లెమిష్ జెయింట్', size: BreedSize.large),
  Breed('angora', Species.rabbit, 'Angora', 'अंगोरा', 'అంగోరా'),
  Breed('rex', Species.rabbit, 'Rex', 'रेक्स', 'రెక్స్'),
  Breed('himalayan_rabbit', Species.rabbit, 'Himalayan', 'हिमालयन', 'హిమాలయన్', size: BreedSize.small),
];

final Map<String, Breed> breedById = {for (final b in breeds) b.id: b};

List<Breed> breedsFor(Species s) => breeds.where((b) => b.species == s).toList();

Species speciesFromName(String? name) =>
    Species.values.firstWhere((s) => s.name == name, orElse: () => Species.dog);
