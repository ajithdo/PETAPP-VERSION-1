/// Toxic food and plant checker (spec 7.14): what is dangerous for which
/// species. Version 1 content is a draft, to be reviewed by a vet. Names and
/// explanations live in the ARB files (`tox<Id>Name`, `tox<Id>Why`); the search
/// keywords below are only used to find items, never shown.
///
/// Pure Dart: shared by the app and the unit tests.
library;

enum ToxLevel { danger, caution, safe }

enum ToxKind { food, plant, home }

class ToxItem {
  const ToxItem(this.id, this.kind, this.levels, this.keywords);

  final String id;
  final ToxKind kind;

  /// Species (dog, cat, bird, rabbit) → level. A missing species means the
  /// item is not a known concern for it (for example cooking fumes and dogs).
  final Map<String, ToxLevel> levels;

  /// Extra search words: other English names and Hindi, Telugu and
  /// Hinglish words. Matched anywhere in the query.
  final List<String> keywords;

  ToxLevel? levelFor(String? species) => species == null ? worst : levels[species];

  /// The most serious level across species.
  ToxLevel get worst => levels.values.reduce((a, b) => a.index <= b.index ? a : b);
}

const _d = ToxLevel.danger;
const _c = ToxLevel.caution;
const _s = ToxLevel.safe;

Map<String, ToxLevel> _all(ToxLevel dog, ToxLevel cat, ToxLevel bird, ToxLevel rabbit) => {'dog': dog, 'cat': cat, 'bird': bird, 'rabbit': rabbit};

final toxItems = <ToxItem>[
  // ---------- food ----------
  ToxItem('chocolate', ToxKind.food, _all(_d, _d, _d, _d), const ['chocolate', 'cocoa', 'brownie', 'choco', 'चॉकलेट', 'कोको', 'చాక్లెట్', 'కోకో']),
  ToxItem('grapes', ToxKind.food, _all(_d, _d, _c, _c), const ['grape', 'raisin', 'kishmish', 'munakka', 'अंगूर', 'किशमिश', 'ద్రాక్ష', 'కిస్మిస్']),
  ToxItem('onionGarlic', ToxKind.food, _all(_d, _d, _d, _d),
      const ['onion', 'garlic', 'pyaz', 'lahsun', 'leek', 'chives', 'प्याज', 'प्याज़', 'लहसुन', 'ఉల్లి', 'ఉల్లిపాయ', 'వెల్లుల్లి']),
  ToxItem('xylitol', ToxKind.food, _all(_d, _d, _d, _d),
      const ['xylitol', 'sugar free', 'sugar-free', 'chewing gum', 'gum', 'mints', 'peanut butter', 'ज़ाइलिटॉल', 'शुगर फ्री', 'शुगर-फ़्री', 'च्युइंग गम', 'జైలిటాల్', 'షుగర్ ఫ్రీ', 'షుగర్-ఫ్రీ', 'చూయింగ్ గమ్']),
  ToxItem('alcohol', ToxKind.food, _all(_d, _d, _d, _d),
      const ['alcohol', 'beer', 'wine', 'whisky', 'rum', 'vodka', 'toddy', 'dough', 'yeast', 'शराब', 'बीयर', 'ख़मीर', 'खमीर', 'మద్యం', 'బీర్', 'కల్లు', 'ఈస్ట్']),
  ToxItem('caffeine', ToxKind.food, _all(_d, _d, _d, _d),
      const ['tea', 'chai', 'coffee', 'caffeine', 'energy drink', 'cola', 'चाय', 'कॉफ़ी', 'कॉफी', 'कैफ़ीन', 'కాఫీ', 'టీ', 'కెఫీన్']),
  ToxItem('avocado', ToxKind.food, _all(_c, _c, _d, _d), const ['avocado', 'butter fruit', 'एवोकाडो', 'అవకాడో', 'బటర్ ఫ్రూట్']),
  const ToxItem('cookedBones', ToxKind.food, {'dog': _d, 'cat': _d},
      ['bone', 'chicken bone', 'mutton bone', 'fish bone', 'हड्डी', 'हड्डियाँ', 'ఎముక', 'ఎముకలు']),
  ToxItem('milk', ToxKind.food, _all(_c, _c, _c, _c), const ['milk', 'dairy', 'doodh', 'lassi', 'दूध', 'పాలు']),
  ToxItem('saltySnacks', ToxKind.food, _all(_c, _c, _d, _c),
      const ['salt', 'namkeen', 'chips', 'crisps', 'papad', 'bhujia', 'mixture', 'नमक', 'नमकीन', 'चिप्स', 'पापड़', 'भुजिया', 'ఉప్పు', 'మిక్చర్', 'చిప్స్', 'అప్పడం']),
  ToxItem('spicyFood', ToxKind.food, _all(_c, _c, _c, _c),
      const ['spicy', 'chilli', 'chili', 'masala', 'curry', 'pickle', 'मिर्च', 'मसाला', 'करी', 'अचार', 'కారం', 'మసాలా', 'కూర', 'మిరపకాయ', 'పచ్చడి']),
  ToxItem('fattyFood', ToxKind.food, _all(_c, _c, _c, _c),
      const ['fried', 'fat', 'ghee', 'oil', 'pakoda', 'pakora', 'samosa', 'biryani', 'तला', 'घी', 'पकौड़ा', 'समोसा', 'बिरयानी', 'వేయించిన', 'నెయ్యి', 'పకోడీ', 'సమోసా', 'బిర్యానీ']),
  ToxItem('sweets', ToxKind.food, _all(_c, _c, _c, _c),
      const ['sweet', 'mithai', 'sugar', 'laddu', 'jalebi', 'candy', 'cake', 'मिठाई', 'चीनी', 'लड्डू', 'जलेबी', 'స్వీట్', 'మిఠాయి', 'చక్కెర', 'లడ్డు', 'జిలేబీ']),
  ToxItem('fruitSeeds', ToxKind.food, _all(_d, _d, _d, _d),
      const ['seed', 'stone', 'pit', 'mango stone', 'apple seed', 'cherry', 'plum', 'peach', 'गुठली', 'बीज', 'టెంక', 'గింజ']),
  ToxItem('tomato', ToxKind.food, _all(_c, _c, _c, _c), const ['tomato', 'tamatar', 'टमाटर', 'టమాటా', 'టమోటా']),
  ToxItem('peanuts', ToxKind.food, _all(_c, _c, _c, _c), const ['peanut', 'groundnut', 'moongphali', 'मूँगफली', 'मूंगफली', 'వేరుశనగ', 'పల్లీలు']),
  ToxItem('mango', ToxKind.food, _all(_s, _c, _s, _c), const ['mango', 'aam', 'आम', 'మామిడి']),
  ToxItem('apple', ToxKind.food, _all(_s, _s, _s, _s), const ['apple', 'seb', 'सेब', 'ఆపిల్']),
  ToxItem('banana', ToxKind.food, _all(_s, _s, _s, _s), const ['banana', 'kela', 'केला', 'అరటి']),
  ToxItem('watermelon', ToxKind.food, _all(_s, _s, _s, _s), const ['watermelon', 'tarbooz', 'तरबूज़', 'तरबूज', 'పుచ్చకాయ']),
  ToxItem('carrot', ToxKind.food, _all(_s, _s, _s, _s), const ['carrot', 'gajar', 'गाजर', 'క్యారెట్']),
  ToxItem('rice', ToxKind.food, _all(_s, _s, _s, _c), const ['rice', 'chawal', 'चावल', 'అన్నం', 'బియ్యం']),
  ToxItem('egg', ToxKind.food, _all(_s, _s, _s, _c), const ['egg', 'anda', 'अंडा', 'గుడ్డు']),
  // ---------- plants ----------
  ToxItem('lily', ToxKind.plant, _all(_c, _d, _c, _c), const ['lily', 'lilies', 'लिली', 'లిల్లీ']),
  ToxItem('sagoPalm', ToxKind.plant, _all(_d, _d, _d, _d), const ['sago', 'cycas', 'साइकस', 'సైకస్']),
  ToxItem('oleander', ToxKind.plant, _all(_d, _d, _d, _d), const ['oleander', 'kaner', 'कनेर', 'గన్నేరు']),
  ToxItem('castor', ToxKind.plant, _all(_d, _d, _d, _d), const ['castor', 'arandi', 'अरंडी', 'ఆముదం']),
  ToxItem('datura', ToxKind.plant, _all(_d, _d, _d, _d), const ['datura', 'dhatura', 'धतूरा', 'ఉమ్మెత్త']),
  ToxItem('lantana', ToxKind.plant, _all(_d, _d, _d, _d), const ['lantana', 'लैंटाना', 'లాంటానా']),
  ToxItem('aloeVera', ToxKind.plant, _all(_c, _c, _c, _c), const ['aloe', 'aloe vera', 'ghritkumari', 'एलोवेरा', 'కలబంద']),
  ToxItem('moneyPlant', ToxKind.plant, _all(_c, _c, _c, _c), const ['money plant', 'pothos', 'मनी प्लांट', 'మనీ ప్లాంట్']),
  ToxItem('snakePlant', ToxKind.plant, _all(_c, _c, _c, _c), const ['snake plant', 'sansevieria', 'स्नेक प्लांट', 'స్నేక్ ప్లాంట్']),
  ToxItem('marigold', ToxKind.plant, _all(_c, _c, _c, _c), const ['marigold', 'genda', 'गेंदा', 'బంతి']),
  ToxItem('tulsi', ToxKind.plant, _all(_s, _s, _s, _s), const ['tulsi', 'holy basil', 'basil', 'तुलसी', 'తులసి']),
  ToxItem('arecaPalm', ToxKind.plant, _all(_s, _s, _s, _s), const ['areca', 'palm', 'एरिका', 'అరెకా']),
  ToxItem('spiderPlant', ToxKind.plant, _all(_s, _s, _s, _s), const ['spider plant', 'स्पाइडर प्लांट', 'స్పైడర్ ప్లాంట్']),
  // ---------- around the home ----------
  ToxItem('ratPoison', ToxKind.home, _all(_d, _d, _d, _d), const ['rat poison', 'rodent', 'rat', 'mouse', 'चूहे', 'चूहा', 'ఎలుక', 'ఎలుకల మందు']),
  ToxItem('humanMedicines', ToxKind.home, _all(_d, _d, _d, _d),
      const ['paracetamol', 'ibuprofen', 'aspirin', 'painkiller', 'medicine', 'tablet', 'दवा', 'गोली', 'पैरासिटामोल', 'మందు', 'మాత్ర', 'పారాసిటమాల్']),
  ToxItem('mosquitoRepellent', ToxKind.home, _all(_c, _c, _d, _c),
      const ['mosquito', 'coil', 'repellent', 'vaporiser', 'vaporizer', 'मच्छर', 'कॉइल', 'దోమ', 'కాయిల్']),
  ToxItem('mothballs', ToxKind.home, _all(_d, _d, _d, _d), const ['naphthalene', 'mothball', 'moth ball', 'नेफ़्थलीन', 'नैफ्थलीन', 'నాఫ్తలీన్']),
  const ToxItem('nonStickFumes', ToxKind.home, {'bird': _d}, ['teflon', 'non-stick', 'non stick', 'nonstick', 'fumes', 'नॉन-स्टिक', 'नॉन स्टिक', 'నాన్-స్టిక్', 'నాన్ స్టిక్']),
  ToxItem('phenyl', ToxKind.home, _all(_c, _d, _c, _c),
      const ['phenyl', 'floor cleaner', 'cleaner', 'bleach', 'disinfectant', 'फ़िनाइल', 'फिनाइल', 'क्लीनर', 'ఫినాయిల్', 'క్లీనర్']),
];

ToxItem? toxItem(String id) {
  for (final t in toxItems) {
    if (t.id == id) return t;
  }
  return null;
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();

final _latin = RegExp(r'^[a-z0-9 \-]+$');

/// English words must appear as whole words ("rat" is not in "carrot"),
/// allowing a plural ending; Hindi and Telugu words match anywhere, because
/// they often take endings.
bool _mentions(String query, String word) {
  if (!_latin.hasMatch(word)) return query.contains(word);
  return RegExp('(^|[^a-z])${RegExp.escape(word)}(s|es)?([^a-z]|\$)').hasMatch(query);
}

/// Finds items for a search like "chocolate", "can my dog eat grapes?",
/// "ప్యాజ్"… [names] gives the words to match for each item: its name in the
/// app language and in English. Items for other species are left out when
/// [species] is set. Best matches first; an empty query lists everything,
/// most dangerous first.
List<ToxItem> searchToxic(
  String query, {
  String? species,
  ToxKind? kind,
  List<String> Function(ToxItem item)? names,
}) {
  final q = _norm(query);
  final pool = toxItems.where((t) => (kind == null || t.kind == kind) && (species == null || t.levels.containsKey(species)));
  int severity(ToxItem t) => (t.levelFor(species) ?? ToxLevel.safe).index;
  if (q.isEmpty) {
    final list = pool.toList();
    final order = {for (var i = 0; i < toxItems.length; i++) toxItems[i].id: i};
    list.sort((a, b) {
      final s = severity(a).compareTo(severity(b));
      return s != 0 ? s : order[a.id]!.compareTo(order[b.id]!);
    });
    return list;
  }
  final scored = <(ToxItem, int)>[];
  for (final t in pool) {
    var best = 0;
    for (final n in names?.call(t) ?? const <String>[]) {
      final name = _norm(n);
      if (name.isEmpty) continue;
      if (name == q) {
        best = 100;
      } else if (name.startsWith(q)) {
        best = best < 80 ? 80 : best;
      } else if (name.contains(q) || q.contains(name)) {
        best = best < 60 ? 60 : best;
      }
    }
    for (final k in t.keywords) {
      final w = _norm(k);
      if (w == q) {
        best = best < 90 ? 90 : best;
      } else if (w.startsWith(q) && q.length >= 2) {
        best = best < 70 ? 70 : best;
      } else if (w.length >= 3 && _mentions(q, w)) {
        // "can my dog eat chocolate" mentions "chocolate"; longer words weigh more.
        final s = 40 + (w.length > 20 ? 20 : w.length);
        best = best < s ? s : best;
      }
    }
    if (best > 0) scored.add((t, best));
  }
  scored.sort((a, b) {
    final s = b.$2.compareTo(a.$2);
    return s != 0 ? s : severity(a.$1).compareTo(severity(b.$1));
  });
  return [for (final s in scored) s.$1];
}
