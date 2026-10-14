/// "Ask PawSetu" (spec 7.14). Version 1 answers 20 common questions with
/// scripted, vet-reviewed-style text (in the ARB files) and checks every
/// question for red-flag symptoms first. Version 2 swaps the matcher for
/// Gemini behind the same [AssistantReply] shape.
///
/// Pure Dart: shared by the app, the unit tests and the Cloud Function port.
library;

/// The 20 scripted topics, in the order the suggestions show them.
const assistantTopics = <String>[
  'bath',
  'feeding',
  'toxic_food',
  'vaccines',
  'deworming',
  'ticks',
  'heat',
  'vomiting',
  'diarrhoea',
  'not_eating',
  'itching',
  'limping',
  'litter',
  'chewing',
  'nails',
  'teeth',
  'bird_diet',
  'rabbit_diet',
  'weight',
  'anxiety',
];

/// Red flags that need a vet right away (spec 7.14).
const redFlags = <String>['breathing', 'collapse', 'seizure', 'poisoning', 'bleeding', 'bloat', 'heatstroke', 'urine', 'injury'];

// Keyword lists. English keywords match whole words; a trailing '*' allows
// endings ("vomit*" matches vomited, vomiting). Hindi and Telugu keywords
// match anywhere in the text. Longer phrases weigh more than single words.
const _topicKeywords = <String, List<String>>{
  'bath': ['bath*', 'bathe*', 'wash*', 'shampoo*', 'नहला', 'नहाना', 'नहलाना', 'स्नान', 'शैम्पू', 'స్నానం', 'షాంపూ', 'కడగ'],
  'feeding': ['how much food', 'how much to feed', 'how much should i feed', 'feed*', 'portion*', 'meals', 'diet', 'कितना खाना', 'खिलाना', 'खिलाऊं', 'भोजन', 'डाइट', 'ఎంత ఆహారం', 'ఎంత తినిపించ', 'తినిపించ', 'ఆహారం', 'భోజనం'],
  'toxic_food': ['toxic', 'unsafe food*', 'poisonous', 'chocolate', 'grape*', 'raisin*', 'onion*', 'garlic', 'xylitol', 'human food*', 'ज़हरीला', 'जहरीला', 'चॉकलेट', 'अंगूर', 'प्याज', 'इंसानों का खाना', 'విషపూరిత', 'చాక్లెట్', 'ద్రాక్ష', 'ఉల్లి', 'మనుషుల ఆహారం'],
  'vaccines': ['vaccin*', 'shots', 'jab*', 'rabies', 'dhppi', 'booster*', 'टीका', 'टीके', 'वैक्सीन', 'టీకా', 'టీకాలు', 'వ్యాక్సిన్'],
  'deworming': ['deworm*', 'worm*', 'कीड़े', 'कृमि', 'डीवर्म', 'నులిపురుగు', 'పురుగుల మందు', 'డీవార్మ్'],
  'ticks': ['tick', 'ticks', 'flea*', 'किलनी', 'टिक', 'पिस्सू', 'चिचड़ी', 'పేలు', 'గోమారి', 'టిక్'],
  'heat': ['summer', 'hot weather', 'heat', 'keep cool', 'cool down', 'afternoon walk*', 'गर्मी', 'ठंडा', 'धूप', 'వేసవి', 'వేడి', 'ఎండ'],
  'vomiting': ['vomit*', 'throwing up', 'threw up', 'puk*', 'उल्टी', 'వాంతి', 'వాంతులు'],
  'diarrhoea': ['diarrh*', 'loose motion*', 'loose stool*', 'runny poo*', 'दस्त', 'पतला मल', 'लूज़ मोशन', 'లూజ్ మోషన్', 'విరేచనాలు'],
  'not_eating': ['not eating', "won't eat", 'wont eat', 'refuses food', 'refusing food', 'no appetite', 'stopped eating', 'off food', 'खाना नहीं खा', 'खाना नहीं', 'भूख नहीं', 'తినడం లేదు', 'తినట్లేదు', 'ఆకలి లేదు'],
  'itching': ['itch*', 'scratch*', 'licking paws', 'hair loss', 'rash*', 'खुजली', 'खुजला', 'దురద', 'గోకు', 'గీరు'],
  'limping': ['limp*', 'lame', 'लंगड़ा', 'लंगड़ाता', 'కుంటు'],
  'litter': ['litter*', 'peeing outside', 'pooping outside', 'लिटर', 'లిట్టర్'],
  'chewing': ['chew*', 'bite', 'bites', 'biting', 'teething', 'nipping', 'mouthing', 'काटता', 'काटती', 'चबाता', 'चबाती', 'दांत निकल', 'కొరుకు', 'కొరుకుతుంది', 'నమలు', 'పళ్ళు వస్తున్న'],
  'nails': ['nail*', 'claw*', 'नाखून', 'గోళ్లు', 'గోరు'],
  'teeth': ['teeth', 'tooth', 'brush teeth', 'brushing teeth', 'toothbrush*', 'bad breath', 'dental', 'दांत साफ', 'मुंह से बदबू', 'దంతాలు', 'పళ్ళు తోమ', 'నోటి దుర్వాసన'],
  'bird_diet': ['cockatiel*', 'budgie*', 'parrot*', 'bird*', 'lovebird*', 'seed*', 'तोता', 'पक्षी', 'कॉकटेल', 'చిలుక', 'పక్షి', 'కాకటీల్'],
  'rabbit_diet': ['rabbit*', 'bunny', 'bunnies', 'hay', 'खरगोश', 'కుందేలు'],
  'weight': ['overweight', 'fat', 'weight', 'obese', 'too thin', 'underweight', 'मोटा', 'मोटी', 'वज़न', 'वजन', 'బరువు', 'లావు'],
  'anxiety': ['scared', 'fear*', 'firework*', 'cracker*', 'anxious', 'anxiety', 'alone', 'thunder*', 'डर', 'पटाखे', 'अकेला', 'భయం', 'టపాసులు', 'ఒంటరిగా'],
};

const _redFlagKeywords = <String, List<String>>{
  'breathing': ['breathing trouble', 'trouble breathing', 'difficulty breathing', 'hard to breathe', "can't breathe", 'cannot breathe', 'struggling to breathe', 'gasping', 'choking', 'blue gums', 'सांस लेने में', 'सांस नहीं', 'दम घुट', 'శ్వాస తీసుకోవడం', 'ఊపిరి ఆడ', 'ఊపిరి తీసుకోలేక'],
  'collapse': ['collapsed', 'collapse', 'fainted', 'unconscious', 'not responding', "won't wake", 'बेहोश', 'गिर गया', 'गिर गई', 'స్పృహ', 'కుప్పకూలి'],
  'seizure': ['seizure*', 'fits', 'fitting', 'convulsion*', 'दौरा', 'दौरे', 'मिर्गी', 'ఫిట్స్', 'మూర్ఛ'],
  'poisoning': ['poisoned', 'poisoning', 'rat poison', 'ate poison', 'ate chocolate', 'ate grapes', 'ate raisins', 'ate onion*', 'ate medicine', 'swallowed tablet*', 'swallowed pills', 'pesticide', 'bleach', 'ज़हर खा', 'जहर खा', 'चूहे मार', 'चॉकलेट खा', 'విషం తిన', 'విషం తాగ', 'ఎలుకల మందు', 'చాక్లెట్ తిన'],
  'bleeding': ['bleed*', 'lots of blood', 'blood everywhere', 'बहुत खून', 'खून बह', 'खून नहीं रुक', 'खून निकल', 'ఎక్కువ రక్తం', 'రక్తం ఆగ', 'రక్తం కారు', 'రక్తస్రావం'],
  'bloat': ['swollen belly', 'swollen stomach', 'stomach swollen', 'belly swollen', 'bloated', 'bloat', 'belly is hard', 'पेट फूल', 'కడుపు ఉబ్బ'],
  'heatstroke': ['heatstroke', 'heat stroke', 'overheated', 'लू लग', 'हीटस्ट्रोक', 'వడదెబ్బ'],
  'urine': ['not passing urine', "can't pee", 'cannot pee', 'not peeing', 'straining to pee', 'no urine', 'unable to urinate', "can't urinate", 'पेशाब नहीं', 'మూత్రం రావడం లేదు', 'మూత్రం పోవడం లేదు'],
  'injury': ['hit by a car', 'hit by car', 'hit by a bike', 'road accident', 'snake bite', 'snakebite', 'bitten by a snake', 'broken bone', 'एक्सीडेंट', 'सांप ने काट', 'गाड़ी से टक्कर', 'ప్రమాదం', 'పాము కాటు', 'పాము కరిచ'],
};

bool _ascii(String s) => s.codeUnits.every((c) => c < 128);

final _patternCache = <String, RegExp>{};

/// True when [keyword] appears in [lower] (already lower-cased).
bool keywordMatches(String lower, String keyword) {
  if (!_ascii(keyword)) return lower.contains(keyword);
  final re = _patternCache.putIfAbsent(keyword, () {
    final wild = keyword.endsWith('*');
    final base = RegExp.escape(wild ? keyword.substring(0, keyword.length - 1) : keyword);
    return RegExp('(^|[^a-z])$base${wild ? '' : r'($|[^a-z])'}');
  });
  return re.hasMatch(lower);
}

int _weight(String keyword) => keyword.replaceAll('*', '').trim().split(RegExp(r'\s+')).length;

/// Species-specific topics win ties against general ones ("What should I
/// feed my cockatiel?" is about bird food, not portions).
const _topicBonus = <String, int>{'bird_diet': 1, 'rabbit_diet': 1};

/// Returns the red flag a text mentions, or null. Checked before anything
/// else so an emergency always shows SOS.
String? detectRedFlag(String text) {
  final lower = text.toLowerCase();
  for (final flag in redFlags) {
    if (_redFlagKeywords[flag]!.any((k) => keywordMatches(lower, k))) return flag;
  }
  return null;
}

/// Best matching topic for a free-text question, or null.
String? matchTopic(String text) {
  final lower = text.toLowerCase();
  String? best;
  var bestScore = 0;
  for (final topic in assistantTopics) {
    var score = 0;
    for (final k in _topicKeywords[topic]!) {
      if (keywordMatches(lower, k)) score += _weight(k) + (_topicBonus[topic] ?? 0);
    }
    if (score > bestScore) {
      best = topic;
      bestScore = score;
    }
  }
  return best;
}

class AssistantReply {
  const AssistantReply({this.topic, this.redFlag});
  final String? topic;
  final String? redFlag;
  bool get isRedFlag => redFlag != null;
  bool get isUnknown => topic == null && redFlag == null;
}

/// Answers a question. [topic] is set when the user tapped a suggestion.
AssistantReply replyTo(String question, {String? topic}) {
  final flag = detectRedFlag(question);
  if (flag != null) return AssistantReply(redFlag: flag);
  if (topic != null && assistantTopics.contains(topic)) return AssistantReply(topic: topic);
  return AssistantReply(topic: matchTopic(question));
}

/// Monthly question allowance (free 5, Plus unlimited; admin-configurable).
class AssistantAllowance {
  const AssistantAllowance({required this.used, required this.limit});
  final int used;
  final int limit;
  bool get unlimited => limit >= 999;
  int get left => unlimited ? limit : (limit - used).clamp(0, limit);
  bool get exhausted => !unlimited && used >= limit;
}

/// Questions asked since the start of the month (red-flag questions are
/// always answered and are not counted).
int questionsThisMonth(Iterable<({DateTime at, bool redFlag})> asked, DateTime now) {
  final from = DateTime(now.year, now.month);
  return asked.where((q) => !q.redFlag && !q.at.isBefore(from)).length;
}
