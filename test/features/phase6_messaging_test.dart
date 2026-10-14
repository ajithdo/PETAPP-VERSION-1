import 'package:flutter_test/flutter_test.dart';
import 'package:pawsetu/features/assistant/domain/assistant_engine.dart';
import 'package:pawsetu/features/messaging/domain/chat_rules.dart';
import 'package:pawsetu/features/televet/domain/televet_rules.dart';

void main() {
  group('chat safety', () {
    test('phone numbers are hidden in every common format', () {
      for (final t in ['Call me on 9876543210', 'my no is +91 98765 43210', 'landline 040-2345 6789', 'ring 09876543210']) {
        final r = maskPhoneNumbers(t);
        expect(r.masked, isTrue, reason: t);
        expect(r.text, contains(hiddenNumber));
        expect(RegExp(r'\d{6,}').hasMatch(r.text.replaceAll(' ', '')), isFalse, reason: r.text);
      }
    });

    test('short numbers, prices and times are left alone', () {
      for (final t in ['Bruno weighs 29 kg', 'It costs ₹1,499', 'See you at 10:30 on 14 Oct 2026']) {
        expect(maskPhoneNumbers(t).masked, isFalse, reason: t);
      }
    });

    test('payment details are flagged, including Hindi and Telugu words', () {
      expect(looksLikePaymentDetails('pay me at ravi.teja@oksbi'), isTrue);
      expect(looksLikePaymentDetails('Please send the OTP you got'), isTrue);
      expect(looksLikePaymentDetails('card 4111 1111 1111 1111'), isTrue);
      expect(looksLikePaymentDetails('ఓటీపీ చెప్పండి'), isTrue);
      expect(looksLikePaymentDetails('See you tomorrow at 7'), isFalse);
      expect(looksLikePaymentDetails('Call 9876543210'), isFalse);
    });

    test('masked phone keeps only the first 5 and last 2 digits', () {
      expect(maskedPhone('+91 90000 00012'), '+91 90000 •••12');
      expect(maskedPhone(null), '+91 ••••• •••••');
    });

    test('unread counts: everyone else +1, the sender back to 0', () {
      final out = bumpUnread({'a': 2, 'b': 0}, ['a', 'b', 'c'], 'a');
      expect(out, {'a': 0, 'b': 1, 'c': 1});
    });

    test('search needs every word somewhere in the fields', () {
      expect(matchesSearch('bruno vet', ['Bruno', 'Dr. Sameer Khan · vet']), isTrue);
      expect(matchesSearch('bruno groomer', ['Bruno', 'vet']), isFalse);
      expect(matchesSearch('  ', ['anything']), isTrue);
    });

    test('typing shows only for a few seconds', () {
      final now = DateTime(2026, 10, 14, 12);
      expect(typingIsFresh(now.subtract(const Duration(seconds: 3)), now), isTrue);
      expect(typingIsFresh(now.subtract(const Duration(seconds: 20)), now), isFalse);
      expect(typingIsFresh(null, now), isFalse);
    });

    test('voice notes are wrapped as a valid WAV header', () {
      final wav = pcm16ToWav(List.filled(320, 0));
      expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
      expect(String.fromCharCodes(wav.sublist(8, 12)), 'WAVE');
      expect(wav.length, 44 + 320);
    });
  });

  group('tele-vet limits', () {
    final free = TeleVetLimits.fromPlan({'teleVetPerMonth': 1, 'teleVetMessages': 20, 'teleVetWords': 60, 'teleVetHours': 24}, plus: false);
    final plus = TeleVetLimits.fromPlan({'teleVetPerMonth': 999, 'teleVetMessages': 100, 'teleVetWords': 300, 'teleVetHours': 72}, plus: true);
    final now = DateTime(2026, 10, 14, 12);
    String words(int n) => List.filled(n, 'word').join(' ');

    test('a 61-word message on Free gets the word-limit notice; 60 is fine', () {
      final over = checkTeleVetMessage(text: words(61), fromOwner: true, limits: free, messagesUsed: 3, status: 'active', now: now);
      expect(over.block, TeleVetBlock.tooManyWords);
      expect(over.words, 61);
      expect(over.maxWords, 60);
      final ok = checkTeleVetMessage(text: words(60), fromOwner: true, limits: free, messagesUsed: 3, status: 'active', now: now);
      expect(ok.ok, isTrue);
      expect(ok.messagesLeft, 16);
    });

    test('Plus allows 300 words', () {
      expect(checkTeleVetMessage(text: words(61), fromOwner: true, limits: plus, messagesUsed: 0, status: 'active', now: now).ok, isTrue);
      expect(checkTeleVetMessage(text: words(301), fromOwner: true, limits: plus, messagesUsed: 0, status: 'active', now: now).block, TeleVetBlock.tooManyWords);
    });

    test('message count runs out for owners but never for vets', () {
      expect(checkTeleVetMessage(text: 'hi', fromOwner: true, limits: free, messagesUsed: 20, status: 'active', now: now).block, TeleVetBlock.noMessagesLeft);
      expect(checkTeleVetMessage(text: words(200), fromOwner: false, limits: free, messagesUsed: 20, status: 'active', now: now).ok, isTrue);
    });

    test('the owner side closes after the window; ended consultations are closed for all', () {
      final endsAt = now.subtract(const Duration(minutes: 1));
      expect(checkTeleVetMessage(text: 'hi', fromOwner: true, limits: free, messagesUsed: 0, status: 'active', now: now, endsAt: endsAt).block, TeleVetBlock.chatClosed);
      expect(checkTeleVetMessage(text: 'advice', fromOwner: false, limits: free, messagesUsed: 0, status: 'active', now: now, endsAt: endsAt).ok, isTrue);
      expect(checkTeleVetMessage(text: 'hi', fromOwner: false, limits: free, messagesUsed: 0, status: 'ended', now: now).block, TeleVetBlock.ended);
    });

    test('photos and voice notes count as a message without words', () {
      final c = checkTeleVetMessage(text: '', fromOwner: true, limits: free, messagesUsed: 0, status: 'active', now: now, attachment: true);
      expect(c.ok, isTrue);
      expect(checkTeleVetMessage(text: '  ', fromOwner: true, limits: free, messagesUsed: 0, status: 'active', now: now).block, TeleVetBlock.empty);
    });

    test('words are counted the same way in Hindi and Telugu', () {
      expect(countWords('टाइगर दो दिन से कम खा रहा है'), 8);
      expect(countWords('సింబా రెండు రోజులుగా చెవులు గోక్కుంటోంది'), 5);
    });

    test('monthly allowance and video need Plus', () {
      expect(consultationsThisMonth([DateTime(2026, 10, 2), DateTime(2026, 9, 30)], now), 1);
      expect(canStartConsultation(usedThisMonth: 1, limits: free, video: false), StartBlock.monthlyLimit);
      expect(canStartConsultation(usedThisMonth: 0, limits: free, video: true), StartBlock.videoNeedsPlus);
      expect(canStartConsultation(usedThisMonth: 40, limits: plus, video: true), StartBlock.none);
      expect(nextMonthStart(DateTime(2026, 12, 20)), DateTime(2027, 1));
    });

    test('video price: Plus discount, commission from the total', () {
      final p = priceTeleVet(video: true, videoFee: 400, plus: true, discountPercent: 10, commissionPercent: 10);
      expect(p.discount, 40);
      expect(p.total, 360);
      expect(p.commission, 36);
      expect(p.payout, 324);
      expect(priceTeleVet(video: false, videoFee: 400, plus: false, discountPercent: 10, commissionPercent: 10).total, 0);
    });

    test('queue puts Plus first, then whoever waited longest', () {
      final early = DateTime(2026, 10, 14, 9);
      final late = DateTime(2026, 10, 14, 10);
      expect(compareQueue(aPriority: true, aAt: late, bPriority: false, bAt: early), lessThan(0));
      expect(compareQueue(aPriority: false, aAt: early, bPriority: false, bAt: late), lessThan(0));
    });
  });

  group('Ask PawSetu', () {
    test('red flags win over everything, in all three languages', () {
      expect(replyTo('My dog ate chocolate and is vomiting').redFlag, 'poisoning');
      expect(replyTo('He has trouble breathing after the walk').redFlag, 'breathing');
      expect(detectRedFlag('कुत्ते को दौरे पड़ रहे हैं'), 'seizure');
      expect(detectRedFlag('మా పిల్లికి మూత్రం రావడం లేదు'), 'urine');
      expect(detectRedFlag('She is bleeding a lot from the paw'), 'bleeding');
    });

    test('everyday questions match their topic', () {
      expect(matchTopic('How often should I bathe my dog?'), 'bath');
      expect(matchTopic('What should I feed my cockatiel?'), 'bird_diet');
      expect(matchTopic('my puppy keeps biting'), 'chewing');
      expect(matchTopic('कुत्ते को कितना खाना देना चाहिए'), 'feeding');
      expect(matchTopic('పేలు ఎలా పోగొట్టాలి'), 'ticks');
      expect(matchTopic('Tell me a joke'), isNull);
    });

    test('there are exactly 20 scripted topics', () {
      expect(assistantTopics.length, 20);
      expect(assistantTopics.toSet().length, 20);
    });

    test('a tapped suggestion keeps its topic unless it is an emergency', () {
      expect(replyTo('anything', topic: 'nails').topic, 'nails');
      expect(replyTo('he collapsed', topic: 'nails').isRedFlag, isTrue);
    });

    test('monthly allowance ignores red-flag questions and last month', () {
      final now = DateTime(2026, 10, 14);
      final used = questionsThisMonth([
        (at: DateTime(2026, 10, 2), redFlag: false),
        (at: DateTime(2026, 10, 3), redFlag: true),
        (at: DateTime(2026, 9, 29), redFlag: false),
      ], now);
      expect(used, 1);
      expect(const AssistantAllowance(used: 5, limit: 5).exhausted, isTrue);
      expect(const AssistantAllowance(used: 50, limit: 9999).unlimited, isTrue);
    });
  });
}
