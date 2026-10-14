// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'PawSetu';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पक्का करें';

  @override
  String get next => 'आगे';

  @override
  String get skip => 'छोड़ें';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get or => 'या';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get tryAgain => 'फिर से कोशिश करें';

  @override
  String get errorTitle => 'कुछ गड़बड़ हो गई';

  @override
  String get errorBody =>
      'यह लोड नहीं हो पाया। इंटरनेट जाँचें और फिर से कोशिश करें।';

  @override
  String get fieldRequired => 'कृपया इसे भरें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String comingInPhase(int phase) {
    return 'PawSetu का यह हिस्सा चरण $phase में आएगा। बाकी सब अभी से काम करता है।';
  }

  @override
  String get notFoundTitle => 'यह पेज नहीं मिला';

  @override
  String get notFoundBody =>
      'शायद लिंक पुराना है। चलिए आपको होम पर ले चलते हैं।';

  @override
  String get goHome => 'होम पर जाएँ';

  @override
  String stepOf(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get tabHome => 'होम';

  @override
  String get tabHealth => 'सेहत';

  @override
  String get tabBook => 'बुक करें';

  @override
  String get tabShop => 'दुकान';

  @override
  String get tabMe => 'मैं';

  @override
  String get messages => 'संदेश';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get switchPet => 'पालतू बदलें';

  @override
  String get allPets => 'सभी पालतू';

  @override
  String get addPet => 'पालतू जोड़ें';

  @override
  String get petProfile => 'पालतू प्रोफ़ाइल';

  @override
  String openPetProfile(String name) {
    return '$name की प्रोफ़ाइल खोलें';
  }

  @override
  String get petParent => 'पालतू अभिभावक';

  @override
  String get sosTitle => 'आपातकालीन मदद';

  @override
  String get sosSemantic => 'SOS आपातकालीन बटन';

  @override
  String get sosHoldHint => 'चालू करने के लिए 2 सेकंड दबाए रखें';

  @override
  String get sosConfirmTitle => 'आपातकालीन मदद चाहिए?';

  @override
  String get sosConfirmBody =>
      'हम सबसे पास के खुले क्लिनिक दिखाएँगे ताकि आप कॉल करें या वहाँ जाएँ।';

  @override
  String get sosGetHelp => 'अभी मदद लें';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्ते';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get noPetsTitle => 'चलिए अपना पहला पालतू जोड़ें';

  @override
  String get noPetsBody =>
      'बस नाम और प्रजाति चाहिए। बाकी बाद में जोड़ सकते हैं।';

  @override
  String get quickActions => 'झटपट काम';

  @override
  String get qaBookVet => 'डॉक्टर बुक करें';

  @override
  String get qaLogWalk => 'सैर दर्ज करें';

  @override
  String get qaAskVet => 'डॉक्टर से पूछें';

  @override
  String get qaAddPhoto => 'फ़ोटो जोड़ें';

  @override
  String weightValue(String value) {
    return '$value';
  }

  @override
  String get speciesDog => 'कुत्ता';

  @override
  String get speciesCat => 'बिल्ली';

  @override
  String get speciesBird => 'पक्षी';

  @override
  String get speciesRabbit => 'खरगोश';

  @override
  String get species => 'प्रजाति';

  @override
  String get petName => 'पालतू का नाम';

  @override
  String ageYears(int years) {
    return '$years वर्ष';
  }

  @override
  String ageMonths(int months) {
    return '$months महीने';
  }

  @override
  String ageYearsMonths(int years, int months) {
    return '$years वर्ष $months महीने';
  }

  @override
  String get stagePuppy => 'पिल्ला';

  @override
  String get stageKitten => 'बिल्ली का बच्चा';

  @override
  String get stageYoung => 'छोटा';

  @override
  String get stageAdult => 'वयस्क';

  @override
  String get stageSenior => 'बुज़ुर्ग';

  @override
  String get genderMale => 'नर';

  @override
  String get genderFemale => 'मादा';

  @override
  String get genderUnknown => 'पता नहीं';

  @override
  String get birdLegalNote =>
      'तोता (रोज़-रिंग्ड/इंडियन रिंगनेक), अलेक्ज़ेंड्रिन और प्लम-हेडेड तोते, मुनिया और मैना जैसे देसी भारतीय पक्षी वन्यजीव (संरक्षण) अधिनियम, 1972 के तहत संरक्षित हैं। इन्हें कानूनी रूप से पाला नहीं जा सकता, इसलिए ये सूची में नहीं हैं।';

  @override
  String get roleOwner => 'मालिक';

  @override
  String get roleCoowner => 'सह-मालिक';

  @override
  String get roleCarer => 'देखभालकर्ता';

  @override
  String get roleViewer => 'दर्शक';

  @override
  String get rolePetParent => 'पालतू अभिभावक';

  @override
  String get roleVet => 'पशु चिकित्सक';

  @override
  String get roleClinicAdmin => 'क्लिनिक एडमिन';

  @override
  String get roleGroomer => 'ग्रूमर';

  @override
  String get roleTrainer => 'ट्रेनर';

  @override
  String get roleBoarder => 'बोर्डिंग और सिटिंग';

  @override
  String get roleWalker => 'डॉग वॉकर';

  @override
  String get roleSeller => 'विक्रेता';

  @override
  String get roleAdmin => 'प्लेटफ़ॉर्म एडमिन';

  @override
  String get welcome1Title => 'आपके पालतू की हर देखभाल, एक ही जगह';

  @override
  String get welcome1Body => 'घर के हर पालतू की सैर, खाना और मूड एक साथ देखें।';

  @override
  String get welcome2Title => 'कोई टीका या दवा न छूटे';

  @override
  String get welcome2Body =>
      'हल्के रिमाइंडर, सेहत का रिकॉर्ड और डॉक्टर को भेजने लायक रिपोर्ट।';

  @override
  String get welcome3Title => 'डॉक्टर, ग्रूमर और दुकानें, सब जुड़े हुए';

  @override
  String get welcome3Body =>
      'कुछ टैप में बुक करें, डॉक्टर से चैट करें, आपात स्थिति में तुरंत मदद पाएँ।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get language => 'भाषा';

  @override
  String get signInTitle => 'PawSetu में आपका स्वागत है';

  @override
  String get signInSubtitle => 'अपने पालतुओं की देखभाल के लिए साइन इन करें';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHelper => 'कम से कम 6 अक्षर';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get signOutConfirm => 'PawSetu से साइन आउट करें?';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get continueWithPhone => 'फ़ोन नंबर से जारी रखें';

  @override
  String get continueWithApple => 'Apple से जारी रखें';

  @override
  String get newHere => 'PawSetu पर नए हैं?';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get exploreDemo => 'डेमो यूज़र के रूप में देखें';

  @override
  String get exploreDemoHint =>
      'एक टैप में हर भूमिका आज़माएँ। साइन-अप की ज़रूरत नहीं।';

  @override
  String get signUpTitle => 'अपना खाता बनाएँ';

  @override
  String get signUpSubtitle => 'एक मिनट से कम लगेगा';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get termsNote =>
      'खाता बनाकर आप नियमों और गोपनीयता नीति से सहमत होते हैं।';

  @override
  String get resetTitle => 'पासवर्ड रीसेट करें';

  @override
  String get resetSubtitle => 'नया पासवर्ड चुनने का लिंक हम ईमेल करेंगे।';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String resetSent(String email) {
    return 'अगर $email का खाता है, तो रीसेट लिंक भेज दिया गया है।';
  }

  @override
  String get backToSignIn => 'साइन इन पर वापस';

  @override
  String get phoneTitle => 'फ़ोन से साइन इन करें';

  @override
  String get phoneSubtitle => 'हम SMS से 6 अंकों का कोड भेजेंगे।';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get phoneInvalid => '10 अंकों का मोबाइल नंबर डालें';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get enterCodeTitle => 'कोड डालें';

  @override
  String enterCodeSubtitle(String phone) {
    return '$phone पर 6 अंकों का कोड भेजा गया';
  }

  @override
  String get sixDigitCode => '6 अंकों का कोड';

  @override
  String get verifyAndContinue => 'पुष्टि करें और आगे बढ़ें';

  @override
  String get changeNumber => 'नंबर बदलें';

  @override
  String get verifyTitle => 'अपना ईमेल देखें';

  @override
  String verifySubtitle(String email) {
    return 'हमने $email पर एक लिंक भेजा है। पुष्टि के लिए उसे टैप करें।';
  }

  @override
  String get verifyDemoNote =>
      'डेमो: ईमेल डेमो आउटबॉक्स में गया है। खोलने के लिए नीचे टैप करें।';

  @override
  String get openDemoEmail => 'डेमो ईमेल खोलें और पुष्टि करें';

  @override
  String get iveVerified => 'मैंने ईमेल की पुष्टि कर दी';

  @override
  String get resendEmail => 'ईमेल फिर से भेजें';

  @override
  String get emailResent => 'फिर से भेज दिया। इनबॉक्स और स्पैम देखें।';

  @override
  String get authErrNoAccount =>
      'इस ईमेल का कोई खाता नहीं है। वर्तनी जाँचें या खाता बनाएँ।';

  @override
  String get authErrWrongPassword =>
      'ईमेल और पासवर्ड मेल नहीं खाते। फिर कोशिश करें या पासवर्ड रीसेट करें।';

  @override
  String get authErrEmailInUse => 'इस ईमेल का खाता पहले से है। साइन इन करें।';

  @override
  String get authErrWeakPassword => 'कम से कम 6 अक्षर रखें';

  @override
  String get authErrInvalidEmail => 'यह ईमेल पता सही नहीं लगता';

  @override
  String get authErrInvalidCode => 'कोड सही नहीं है। SMS देखकर फिर कोशिश करें।';

  @override
  String get authErrNetwork => 'इंटरनेट नहीं है। जाँचें और फिर कोशिश करें।';

  @override
  String get authErrCancelled => 'साइन इन रद्द हो गया।';

  @override
  String get demoTitle => 'डेमो';

  @override
  String get demoBadge => 'डेमो';

  @override
  String demoSocialBody(String provider) {
    return 'डेमो: असली ऐप में यह $provider साइन इन खोलेगा। यहाँ आप डेमो खाते से आगे बढ़ेंगे।';
  }

  @override
  String demoOtpBody(String code) {
    return 'डेमो: कोई SMS नहीं भेजा गया। कोड $code डालें।';
  }

  @override
  String get demoOutboxNote =>
      'डेमो: असल में कुछ नहीं भेजा गया। संदेश एडमिन पैनल के डेमो आउटबॉक्स में है।';

  @override
  String get demoLoginNote =>
      'ये डेमो खाते हैं, लोग, क्लिनिक और डेटा काल्पनिक हैं। यहाँ कुछ भी असली नहीं है, कोई पैसा नहीं कटता और कोई संदेश नहीं जाता।';

  @override
  String get demoGroupOwners => 'पालतू अभिभावक';

  @override
  String get demoGroupFamily => 'परिवार और पेट सिटर';

  @override
  String get demoGroupPartners => 'पार्टनर';

  @override
  String get demoGroupPlatform => 'प्लेटफ़ॉर्म';

  @override
  String get demoPriya =>
      'बेंगलुरु · Plus · लैब्राडोर ब्रूनो और पर्शियन बिल्ली मिस्टी';

  @override
  String get demoRavi =>
      'हैदराबाद · Free · तेलुगु · देसी पिल्ला सिम्बा और कॉकटेल कीवी';

  @override
  String get demoAnjali =>
      'दिल्ली NCR · Free · हिन्दी · आसान मोड · खरगोश कोको और बुज़ुर्ग बिल्ली टाइगर';

  @override
  String get demoArjun =>
      'मुंबई · Plus · जर्मन शेफर्ड मैक्स और बीगल पिल्ला लूना';

  @override
  String get demoRohan => 'प्रिया के पति · ब्रूनो और मिस्टी के देखभालकर्ता';

  @override
  String get demoMeera => 'अर्जुन की पेट सिटर · पहुँच 3 दिन में खत्म';

  @override
  String get demoClinicAdmin =>
      'क्लिनिक एडमिन · गोलकोंडा गेट पेट क्लिनिक, हैदराबाद';

  @override
  String get demoVet => 'पशु चिकित्सक · बुकिंग, टेली-वेट कतार और पर्चे';

  @override
  String get demoGroomer => 'ग्रूमर · बुकिंग अनुरोध स्वीकार करता है';

  @override
  String get demoTrainer => 'डॉग ट्रेनर';

  @override
  String get demoBoarder => 'होम बोर्डिंग और पेट सिटिंग';

  @override
  String get demoWalker => 'डॉग वॉकर · लाइव सैर रूट';

  @override
  String get demoSeller => 'विक्रेता · उत्पाद, ऑर्डर और भुगतान';

  @override
  String get demoAdmin =>
      'प्लेटफ़ॉर्म एडमिन · मंज़ूरी, शिकायतें, डेमो आउटबॉक्स';

  @override
  String demoCredentials(String password, String otp) {
    return 'हाथ से साइन इन? हर डेमो खाते का पासवर्ड $password है। डेमो फ़ोन कोड: $otp।';
  }

  @override
  String setupHello(String name) {
    return 'नमस्ते $name, चलिए सेटअप करें';
  }

  @override
  String get setupHelloNoName => 'चलिए सेटअप करें';

  @override
  String get setupPrefsSubtitle =>
      'PawSetu कैसा दिखे और पढ़ा जाए, चुनें। इसे कभी भी सेटिंग्स में बदल सकते हैं।';

  @override
  String get setupPetTitle => 'हम किसकी देखभाल करेंगे?';

  @override
  String get setupPetSubtitle => 'अभी बस नाम और प्रजाति।';

  @override
  String get setupNotifTitle => 'रिमाइंडर से पालतू स्वस्थ रहता है';

  @override
  String get setupNotifSubtitle => 'सूचनाएँ चालू करें ताकि हम याद दिला सकें:';

  @override
  String get notifReasonVaccines => 'बकाया टीके और कृमिनाशक';

  @override
  String get notifReasonMedicines => 'दवा का समय, एक टैप में \'दे दी\'';

  @override
  String get notifReasonBookings => 'डॉक्टर और ग्रूमिंग अपॉइंटमेंट';

  @override
  String get notifReasonMessages => 'डॉक्टरों और सेवा देने वालों के जवाब';

  @override
  String get allowNotifications => 'सूचनाएँ चालू करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appearance => 'रूप';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get themeSystem => 'सिस्टम जैसा';

  @override
  String get accessibility => 'सुलभता';

  @override
  String get easyMode => 'आसान मोड';

  @override
  String get easyModeHint => 'बड़े अक्षर और बटन, सरल होम और आसान शब्द।';

  @override
  String get textSize => 'अक्षर का आकार';

  @override
  String get highContrast => 'हाई कॉन्ट्रास्ट';

  @override
  String get highContrastHint => 'गहरे अक्षर और साफ़ किनारे।';

  @override
  String get notificationChannels => 'रिमाइंडर और माध्यम';

  @override
  String get notificationChannelsHint =>
      'पुश, ईमेल, SMS या WhatsApp, और शांत समय';

  @override
  String get demoData => 'डेमो डेटा';

  @override
  String get demoModeOn => 'डेमो मोड चालू है';

  @override
  String get demoStandaloneHint =>
      'सब कुछ इसी डिवाइस पर चलता है। कोई असली पैसा, संदेश या कॉल नहीं।';

  @override
  String get demoEmulatorHint =>
      'आपके कंप्यूटर के Firebase एमुलेटर से जुड़ा है।';

  @override
  String get resetDemoData => 'डेमो डेटा रीसेट करें';

  @override
  String get resetDemoDataHint => 'अपने बदलाव हटाकर नए सिरे से शुरू करें';

  @override
  String get resetDemoDataConfirm =>
      'इससे डेमो में आपका जोड़ा सब हट जाएगा और आप साइन आउट हो जाएँगे।';

  @override
  String get about => 'जानकारी';

  @override
  String aboutVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get mapCredit => 'मैप © OpenStreetMap योगदानकर्ता';

  @override
  String get designGallery => 'डिज़ाइन गैलरी';

  @override
  String get myPets => 'मेरे पालतू';

  @override
  String get familySharing => 'परिवार और साझा करना';

  @override
  String get documentVault => 'दस्तावेज़ तिजोरी';

  @override
  String get memoryAlbum => 'यादों का एल्बम';

  @override
  String get connectedDevices => 'जुड़े उपकरण';

  @override
  String get lostPetMode => 'खोया पालतू मोड और QR टैग';

  @override
  String get expenses => 'खर्च';

  @override
  String get pawsetuPlus => 'PawSetu Plus';

  @override
  String get helpAndComplaints => 'मदद और शिकायतें';

  @override
  String get privacyCentre => 'गोपनीयता केंद्र';

  @override
  String get planFree => 'Free';

  @override
  String get planPlus => 'Plus';

  @override
  String partnerPortalFor(String role) {
    return 'पार्टनर पोर्टल · $role';
  }

  @override
  String get pDashboard => 'डैशबोर्ड';

  @override
  String get pCalendar => 'कैलेंडर और स्लॉट';

  @override
  String get pRequests => 'बुकिंग अनुरोध';

  @override
  String get pTeleVetQueue => 'टेली-वेट कतार';

  @override
  String get pServices => 'सेवाएँ और दाम';

  @override
  String get pStaff => 'स्टाफ़ और डॉक्टर';

  @override
  String get pChat => 'चैट इनबॉक्स';

  @override
  String get pReviews => 'समीक्षाएँ';

  @override
  String get pPayouts => 'भुगतान';

  @override
  String get pProfileKyc => 'प्रोफ़ाइल और KYC';

  @override
  String get pEmergency => 'आपातकालीन सेटिंग्स';

  @override
  String get pProducts => 'उत्पाद और स्टॉक';

  @override
  String get pOrders => 'ऑर्डर';

  @override
  String get pReturns => 'वापसी';

  @override
  String get adminPanel => 'एडमिन पैनल';

  @override
  String get aDashboard => 'डैशबोर्ड';

  @override
  String get aApprovals => 'मंज़ूरी';

  @override
  String get aUsers => 'उपयोगकर्ता';

  @override
  String get aCatalogue => 'कैटलॉग';

  @override
  String get aComplaints => 'शिकायतें और टिकट';

  @override
  String get aModeration => 'मॉडरेशन';

  @override
  String get aSettings => 'प्लान और सेटिंग्स';

  @override
  String get aOutbox => 'डेमो आउटबॉक्स';

  @override
  String get aAudit => 'ऑडिट लॉग';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'मना करें';

  @override
  String get back => 'पीछे';

  @override
  String get done => 'हो गया';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get none => 'कोई नहीं';

  @override
  String get you => 'आप';

  @override
  String get share => 'साझा करें';

  @override
  String get copyLink => 'लिंक कॉपी करें';

  @override
  String get copied => 'कॉपी हो गया';

  @override
  String get link => 'लिंक';

  @override
  String get phone => 'फ़ोन';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get moreOptions => 'और विकल्प';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get details => 'विवरण';

  @override
  String get notAdded => 'अभी नहीं जोड़ा';

  @override
  String get addPhoto => 'फ़ोटो जोड़ें';

  @override
  String get addPhotoTitle => 'फ़ोटो जोड़ें';

  @override
  String get takePhoto => 'फ़ोटो खींचें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get cropPhoto => 'खिसकाएँ और ज़ूम करें';

  @override
  String get cropHint => 'ज़ूम के लिए पिंच करें, खिसकाने के लिए खींचें';

  @override
  String get editPet => 'पालतू बदलें';

  @override
  String get petBasicsTitle => 'बुनियादी जानकारी';

  @override
  String petAboutTitle(String name) {
    return '$name के बारे में';
  }

  @override
  String get petAboutSubtitle => 'सब वैकल्पिक है। जो अभी पता है वो जोड़ें।';

  @override
  String get breed => 'नस्ल';

  @override
  String get chooseBreed => 'नस्ल चुनें';

  @override
  String get searchBreeds => 'नस्ल खोजें';

  @override
  String get breedMixed => 'मिश्रित / देसी';

  @override
  String get breedOther => 'अन्य (लिखें)';

  @override
  String get typeBreed => 'नस्ल का नाम';

  @override
  String get noBreedMatch => 'कोई मेल नहीं। \'अन्य (लिखें)\' आज़माएँ।';

  @override
  String get colourTag => 'रंग टैग';

  @override
  String get colourTagHint => 'एक नज़र में पालतू पहचानने में मदद करता है';

  @override
  String get colourAmber => 'अंबर';

  @override
  String get colourLavender => 'लैवेंडर';

  @override
  String get colourSky => 'आसमानी';

  @override
  String get colourRose => 'गुलाबी';

  @override
  String get colourMint => 'पुदीना हरा';

  @override
  String get colourSand => 'रेतीला';

  @override
  String get birthday => 'जन्मदिन';

  @override
  String get exactDate => 'सही तारीख';

  @override
  String get approxAge => 'अनुमानित उम्र';

  @override
  String get chooseDate => 'तारीख चुनें';

  @override
  String get years => 'वर्ष';

  @override
  String get months => 'महीने';

  @override
  String get gender => 'लिंग';

  @override
  String get weight => 'वज़न';

  @override
  String get weightKg => 'वज़न (किलो)';

  @override
  String get weightGrams => 'वज़न (ग्राम)';

  @override
  String get age => 'उम्र';

  @override
  String get moreDetails => 'और जानकारी';

  @override
  String get moreDetailsHint => 'निशान, माइक्रोचिप, एलर्जी, आहार, क्लिनिक';

  @override
  String get markings => 'रंग और निशान';

  @override
  String get microchip => 'माइक्रोचिप ID';

  @override
  String get neutered => 'नसबंदी हुई';

  @override
  String get allergies => 'एलर्जी';

  @override
  String get allergiesHint => 'कॉमा से अलग करें, जैसे चिकन, गेहूँ';

  @override
  String get dietType => 'आहार';

  @override
  String get regularClinic => 'नियमित क्लिनिक';

  @override
  String get temperament => 'स्वभाव के बारे में';

  @override
  String get insuranceInVault =>
      'बीमा पॉलिसी दस्तावेज़ तिजोरी में रखी जाती हैं।';

  @override
  String petAdded(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String petLimitTitle(int limit) {
    return 'फ्री प्लान में $limit पालतू तक जोड़ सकते हैं';
  }

  @override
  String get petLimitBody =>
      'PawSetu Plus में असीमित पालतू, वीडियो डॉक्टर कॉल और बहुत कुछ।';

  @override
  String petsUsed(int used, int limit) {
    return 'फ्री प्लान पर $limit में से $used पालतू';
  }

  @override
  String get petNotFound => 'यह पालतू नहीं मिला';

  @override
  String get petCare => 'देखभाल';

  @override
  String get routine => 'दिनचर्या';

  @override
  String get family => 'परिवार';

  @override
  String get petSectionHealth => 'टीके, दवाएँ, डॉक्टर विज़िट';

  @override
  String get petSectionRoutine => 'सैर, खाना, खेल, मूड';

  @override
  String get petSectionDocs => 'प्रमाणपत्र, बीमा, रिपोर्ट';

  @override
  String get petSectionMemories => 'फ़ोटो, वीडियो, खास पल';

  @override
  String get flatFacedChip => 'गर्मी से बचाएँ';

  @override
  String get qrTag => 'QR टैग';

  @override
  String get archivePet => 'पालतू संग्रहित करें';

  @override
  String get restorePet => 'सक्रिय पालतुओं में वापस लाएँ';

  @override
  String archiveTitle(String name) {
    return '$name को संग्रहित करें';
  }

  @override
  String get archiveBody =>
      'रिकॉर्ड और यादें सुरक्षित रहेंगी। रिमाइंडर बंद हो जाएँगे।';

  @override
  String get passedAway => 'गुज़र गया';

  @override
  String get passedAwayHint => '\"प्यार भरी याद में\" के तहत रखा जाएगा';

  @override
  String get rehomed => 'नए घर गया';

  @override
  String get rehomedHint => 'नया परिवार मिला';

  @override
  String get memorialNote => 'कुछ शब्द (वैकल्पिक)';

  @override
  String get memorialNoteHint => 'जैसे, हमेशा हमारे दिल में';

  @override
  String get inLovingMemory => 'प्यार भरी याद में';

  @override
  String archivedMemorial(String name) {
    return '$name प्यार भरी याद में है। उसकी यादें सुरक्षित हैं।';
  }

  @override
  String archivedRehomed(String name) {
    return '$name संग्रहित हो गया';
  }

  @override
  String get people => 'लोग';

  @override
  String get activity => 'गतिविधि';

  @override
  String peopleCount(int count) {
    return '$count लोग';
  }

  @override
  String get invite => 'आमंत्रित करें';

  @override
  String get invitesForYou => 'आपके लिए आमंत्रण';

  @override
  String get familyRolesHelp =>
      'दर्शक: सब देख सकता है और दिनचर्या दर्ज कर सकता है। देखभालकर्ता: दवा भी दे सकता है और सेवाएँ बुक कर सकता है। सह-मालिक: पालतू हटाने के अलावा सब कुछ।';

  @override
  String get roleViewerHint => 'सब देखता है, सैर और खाना दर्ज कर सकता है';

  @override
  String get roleCarerHint => 'दवा भी देता है और सेवाएँ बुक करता है';

  @override
  String get roleCoownerHint => 'पालतू हटाने या आपको हटाने के अलावा सब';

  @override
  String get role => 'भूमिका';

  @override
  String inviteTitle(String pet) {
    return '$pet की देखभाल के लिए किसी को आमंत्रित करें';
  }

  @override
  String get temporaryAccess => 'पेट सिटर (पहुँच एक तारीख पर खत्म)';

  @override
  String get temporaryAccessHint => 'पहुँच अपने आप बंद हो जाएगी';

  @override
  String accessUntil(String date) {
    return '$date तक पहुँच';
  }

  @override
  String get accessEnded => 'पहुँच खत्म हो गई';

  @override
  String get sendInvite => 'आमंत्रण भेजें';

  @override
  String get createLink => 'आमंत्रण लिंक बनाएँ';

  @override
  String inviteSent(String contact) {
    return '$contact को आमंत्रण भेजा गया';
  }

  @override
  String get inviteLinkReady => 'आपका आमंत्रण लिंक तैयार है';

  @override
  String inviteShareText(String pet, String link) {
    return 'PawSetu पर $pet की देखभाल में मेरी मदद करें: $link';
  }

  @override
  String get inviteLink => 'आमंत्रण लिंक';

  @override
  String invitePending(String role) {
    return 'स्वीकृति का इंतज़ार · $role';
  }

  @override
  String get cancelInvite => 'आमंत्रण रद्द करें';

  @override
  String inviteReceived(String from, String pet, String role) {
    return '$from ने आपको $pet की देखभाल के लिए $role के रूप में आमंत्रित किया';
  }

  @override
  String inviteAccepted(String pet) {
    return 'अब आप $pet की देखभाल में मदद कर सकते हैं';
  }

  @override
  String get inviteInvalid =>
      'यह आमंत्रण खत्म हो गया या पहले ही उपयोग हो चुका है';

  @override
  String get signInToAccept => 'स्वीकार करने के लिए साइन इन करें';

  @override
  String get changeRole => 'भूमिका बदलें';

  @override
  String get removeAccess => 'पहुँच हटाएँ';

  @override
  String removeAccessConfirm(String name, String pet) {
    return '$pet से $name की पहुँच हटाएँ?';
  }

  @override
  String familyLimitTitle(int limit) {
    return 'फ्री प्लान $limit लोगों तक साझा करता है';
  }

  @override
  String get familyLimitBody =>
      'PawSetu Plus में 8 परिवार वाले मदद कर सकते हैं।';

  @override
  String sharedWithYou(String role) {
    return 'आपके साथ साझा · $role';
  }

  @override
  String get noActivityTitle => 'अभी कोई गतिविधि नहीं';

  @override
  String get noActivityBody =>
      'जब परिवार वाले सैर दर्ज करेंगे या दवा देंगे, तो यहाँ दिखेगा।';

  @override
  String actMedicineGiven(String who, String pet, String detail) {
    return '$who ने $pet को $detail दी';
  }

  @override
  String actWalk(String who, String pet, String detail) {
    return '$who ने $pet को सैर कराई ($detail)';
  }

  @override
  String actMeal(String who, String pet) {
    return '$who ने $pet को खाना खिलाया';
  }

  @override
  String actMemberJoined(String who, String pet) {
    return '$who $pet के परिवार में शामिल हुए';
  }

  @override
  String actMemberRemoved(String who, String name, String pet) {
    return '$who ने $name को $pet के परिवार से हटाया';
  }

  @override
  String actRoleChanged(String who, String pet) {
    return '$who ने $pet के लिए भूमिका बदली';
  }

  @override
  String actGeneric(String who, String pet) {
    return '$who ने $pet को अपडेट किया';
  }

  @override
  String get plusPerkPets => 'असीमित पालतू और 8 परिवार वाले';

  @override
  String get plusPerkVideo =>
      'वीडियो डॉक्टर कॉल, लंबी चैट, वीडियो फ़ीस पर 10% छूट';

  @override
  String get plusPerkAi => 'Ask PawSetu में असीमित सवाल';

  @override
  String get plusPerkStorage => 'फ़ोटो और दस्तावेज़ों के लिए 25 GB';

  @override
  String get seePlus => 'PawSetu Plus देखें';

  @override
  String get save => 'सहेजें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get seeAll => 'सब देखें';

  @override
  String get today => 'आज';

  @override
  String get week => 'हफ़्ता';

  @override
  String get month => 'महीना';

  @override
  String get increase => 'बढ़ाएँ';

  @override
  String get decrease => 'घटाएँ';

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String minutesShort(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String daysCount(int count) {
    return '$count दिन';
  }

  @override
  String get logWalk => 'सैर';

  @override
  String get logPlay => 'खेल';

  @override
  String get logMeal => 'खाना';

  @override
  String get logWater => 'पानी';

  @override
  String get logPotty => 'शौच';

  @override
  String get logSleep => 'नींद / झपकी';

  @override
  String get logGrooming => 'ग्रूमिंग';

  @override
  String get logTraining => 'ट्रेनिंग';

  @override
  String get logMood => 'मूड';

  @override
  String get logWeight => 'वज़न';

  @override
  String get logBehaviour => 'व्यवहार';

  @override
  String logFor(String name) {
    return '$name के लिए दर्ज करें';
  }

  @override
  String get logSomething => 'दर्ज करें';

  @override
  String logNow(String type) {
    return 'अभी $type दर्ज करें';
  }

  @override
  String logged(String type, String name) {
    return '$name का $type दर्ज हुआ';
  }

  @override
  String get addDetails => 'विवरण जोड़ें';

  @override
  String get amountGrams => 'मात्रा (ग्राम)';

  @override
  String get distanceKm => 'दूरी (किमी)';

  @override
  String get durationMinutes => 'अवधि (मिनट)';

  @override
  String get enterWeight => 'वज़न डालें';

  @override
  String get chooseOneTag => 'कम से कम एक व्यवहार चुनें';

  @override
  String howIsPet(String name) {
    return '$name आज कैसा है?';
  }

  @override
  String get behaviourPrompt => 'आपने क्या देखा?';

  @override
  String get behaviourHint => 'बदलने के लिए फिर टैप करें: हल्का, मध्यम, तेज़';

  @override
  String get intensityMild => 'हल्का';

  @override
  String get intensityModerate => 'मध्यम';

  @override
  String get intensityStrong => 'तेज़';

  @override
  String get moodHappy => 'खुश';

  @override
  String get moodCalm => 'शांत';

  @override
  String get moodPlayful => 'खिलंदड़ा';

  @override
  String get moodTired => 'थका हुआ';

  @override
  String get moodAnxious => 'बेचैन';

  @override
  String get moodUnwell => 'बीमार सा';

  @override
  String get tagPlayful => 'खिलंदड़ा';

  @override
  String get tagCalm => 'शांत';

  @override
  String get tagAnxious => 'बेचैन';

  @override
  String get tagLeashPulling => 'पट्टा खींचना';

  @override
  String get tagBarking => 'भौंकना';

  @override
  String get tagAggressionDogs => 'कुत्तों पर गुस्सा';

  @override
  String get tagSeparationAnxiety => 'अकेले छोड़ने पर बेचैनी';

  @override
  String get tagScratching => 'फ़र्नीचर खरोंचना';

  @override
  String get tagChewing => 'चीज़ें चबाना';

  @override
  String get tagJumping => 'लोगों पर कूदना';

  @override
  String get tagHiding => 'छिपना';

  @override
  String get tagNotEating => 'ठीक से न खाना';

  @override
  String todayFor(String name) {
    return '$name का दिन';
  }

  @override
  String get todayAllPets => 'सभी पालतुओं का आज';

  @override
  String allDoneToday(String name) {
    return 'आज का सब हो गया। $name के लिए शाबाश!';
  }

  @override
  String tasksLeft(int count) {
    return 'आज $count काम बाकी';
  }

  @override
  String streakDays(int count) {
    return 'लगातार $count दिन';
  }

  @override
  String playProgress(int done, int goal) {
    return 'खेल · $done / $goal मिनट';
  }

  @override
  String routineOf(String name) {
    return '$name की दिनचर्या';
  }

  @override
  String get tabLog => 'रिकॉर्ड';

  @override
  String get tabCharts => 'चार्ट';

  @override
  String get tabBehaviour => 'व्यवहार';

  @override
  String get tabPlan => 'रोज़ की योजना';

  @override
  String noLogsTitle(String name) {
    return '$name के लिए अभी कुछ दर्ज नहीं';
  }

  @override
  String get noLogsBody =>
      'खाना, सैर या खेल जोड़ने के लिए \'दर्ज करें\' दबाएँ।';

  @override
  String get deleteLogConfirm => 'यह प्रविष्टि हटाएँ?';

  @override
  String get totalWalked => 'कुल सैर';

  @override
  String get streak => 'लगातार';

  @override
  String get mealsLogged => 'दर्ज खाना';

  @override
  String get chartWalkKm => 'सैर (किमी प्रति दिन)';

  @override
  String get chartPlayMinutes => 'खेल (मिनट प्रति दिन)';

  @override
  String get chartMeals => 'रोज़ का खाना';

  @override
  String get chartMood => 'मूड';

  @override
  String get noMoodLogs => 'इस दौरान कोई मूड दर्ज नहीं।';

  @override
  String get noBehaviourTitle => 'अभी व्यवहार के नोट नहीं';

  @override
  String noBehaviourBody(String name) {
    return 'पट्टा खींचना या भौंकना जैसी बातें दर्ज करें, ताकि $name में बदलाव दिखें।';
  }

  @override
  String get trendUp => 'बढ़ रहा है';

  @override
  String get trendDown => 'सुधर रहा है';

  @override
  String get trendSteady => 'स्थिर';

  @override
  String get trendNew => 'नया';

  @override
  String get shareWithTrainerVet => 'ट्रेनर या डॉक्टर से साझा करें';

  @override
  String behaviourSummaryTitle(String name) {
    return '$name का व्यवहार (PawSetu)';
  }

  @override
  String dailyPlanFor(String name) {
    return '$name की रोज़ की योजना';
  }

  @override
  String get dailyPlanHint => 'इसी से होम पर \'आज\' की सूची बनती है।';

  @override
  String get walksPerDay => 'रोज़ की सैर';

  @override
  String get mealsPerDay => 'रोज़ का खाना';

  @override
  String get playMinutesPerDay => 'रोज़ खेल के मिनट';

  @override
  String suggestedGoalsText(String walks, int meals, int play) {
    return 'इस पालतू के लिए सुझाव: $walksरोज़ $meals बार खाना और $play मिनट खेल। अनुमानित है, डॉक्टर से ज़रूर पूछें।';
  }

  @override
  String suggestedWalks(int count, int minutes) {
    return '$count सैर (कुल $minutes मिनट), ';
  }

  @override
  String get useSuggested => 'सुझाए लक्ष्य लगाएँ';

  @override
  String get savePlan => 'योजना सहेजें';

  @override
  String get planSaved => 'रोज़ की योजना सहेजी गई';

  @override
  String get planReminderNote =>
      'योजना के रिमाइंडर सेटिंग्स → रिमाइंडर और माध्यम में सेट होते हैं।';

  @override
  String walkWith(String name) {
    return '$name के साथ सैर';
  }

  @override
  String get distance => 'दूरी';

  @override
  String get duration => 'समय';

  @override
  String get pace => 'रफ़्तार';

  @override
  String paceValue(String value) {
    return '$value मिनट/किमी';
  }

  @override
  String get startWalk => 'सैर शुरू करें';

  @override
  String get startDemoWalk => 'डेमो सैर आज़माएँ';

  @override
  String get pause => 'रोकें';

  @override
  String get resume => 'फिर शुरू';

  @override
  String get stop => 'बंद करें';

  @override
  String get saveWalk => 'सैर सहेजें';

  @override
  String get discardWalk => 'सैर हटाएँ';

  @override
  String walkSaved(String name, String distance) {
    return '$name की सैर सहेजी गई: $distance';
  }

  @override
  String get walkLeaveTitle => 'यह सैर रोकें?';

  @override
  String get walkLeaveBody => 'अब तक का रास्ता सहेजा नहीं जाएगा।';

  @override
  String get walkNotificationTitle => 'PawSetu आपकी सैर ट्रैक कर रहा है';

  @override
  String get walkNotificationText =>
      'खोलने के लिए टैप करें। घर पहुँचकर ऐप में सैर बंद करें।';

  @override
  String get walkWebNote =>
      'लाइव GPS सैर Android और iPhone ऐप में चलती है। वेबसाइट पर आप हाथ से सैर जोड़ सकते हैं।';

  @override
  String get enterWalkManually => 'हाथ से सैर जोड़ें';

  @override
  String get demoWalkBanner => 'डेमो सैर: रास्ता आपके घर के पास बनाया गया है।';

  @override
  String get locationWhyTitle => 'आपकी लोकेशन इस्तेमाल करें?';

  @override
  String get locationWhyWalk =>
      'हम इसे सिर्फ़ सैर के दौरान रास्ता बनाने और दूरी नापने के लिए इस्तेमाल करते हैं।';

  @override
  String get locationOffTitle => 'लोकेशन बंद है';

  @override
  String get locationOffBody =>
      'असली सैर ट्रैक करने के लिए लोकेशन चालू करें, या अभी डेमो सैर आज़माएँ।';

  @override
  String get useDemoWalk => 'डेमो सैर चलाएँ';

  @override
  String get walkWeather => 'सैर का मौसम';

  @override
  String heatOk(String name) {
    return '$name की सैर के लिए अच्छा मौसम';
  }

  @override
  String get heatWarm => 'गर्मी है। सैर छोटी और छाँव में रखें।';

  @override
  String heatHot(String name) {
    return '$name के साथ लंबी सैर के लिए बहुत गर्मी है';
  }

  @override
  String heatDanger(String name) {
    return 'खतरनाक गर्मी। अभी $name की सैर न कराएँ';
  }

  @override
  String get heatTipTime =>
      'सुबह जल्दी (8 बजे से पहले) या सूरज ढलने के बाद सैर कराएँ।';

  @override
  String get heatTipWater =>
      'पानी साथ रखें और गर्म सड़कों से बचें, पंजे जल सकते हैं।';

  @override
  String heatTipFlatFaced(String name) {
    return '$name की नाक छोटी है, इसलिए उसे जल्दी गर्मी लगती है।';
  }

  @override
  String get demoTemperature => 'डेमो तापमान';

  @override
  String get add => 'जोड़ें';

  @override
  String get record => 'दर्ज करें';

  @override
  String get date => 'तारीख';

  @override
  String get status => 'स्थिति';

  @override
  String get type => 'प्रकार';

  @override
  String get owner => 'मालिक';

  @override
  String get from => 'से';

  @override
  String get to => 'तक';

  @override
  String get markDone => 'हो गया मार्क करें';

  @override
  String get indicativeNote =>
      'अनुमानित है, हमेशा अपने पशु चिकित्सक से पुष्टि करें।';

  @override
  String healthOf(String name) {
    return '$name की सेहत';
  }

  @override
  String get choosePetForHealth => 'एक पालतू चुनें';

  @override
  String itemsNeedAttention(int count) {
    return '$count पर ध्यान दें';
  }

  @override
  String get nextUp => 'आगे क्या है';

  @override
  String nothingDue(String name) {
    return '$name के लिए अभी कुछ बकाया नहीं।';
  }

  @override
  String get nothingDueAll => 'सब ठीक है। इस हफ़्ते कुछ बकाया नहीं।';

  @override
  String get healthReport => 'हेल्थ रिपोर्ट';

  @override
  String healthReportOf(String name) {
    return '$name की हेल्थ रिपोर्ट';
  }

  @override
  String get medicalCard => 'मेडिकल कार्ड';

  @override
  String get statusDone => 'हो गया';

  @override
  String get statusOverdue => 'समय निकल गया';

  @override
  String get statusDueSoon => 'जल्द बकाया';

  @override
  String get statusUpcoming => 'आने वाला';

  @override
  String get statusAskVet => 'डॉक्टर से पूछें';

  @override
  String get askYourVet => 'अपने डॉक्टर से पूछें';

  @override
  String get dose => 'खुराक';

  @override
  String doseN(int n) {
    return 'खुराक $n';
  }

  @override
  String get booster => 'बूस्टर';

  @override
  String get optionalVaccine => 'वैकल्पिक (डॉक्टर की सलाह पर)';

  @override
  String get vaccinations => 'टीकाकरण';

  @override
  String get vaccine => 'टीका';

  @override
  String get vaccineName => 'टीके का नाम';

  @override
  String get otherVaccine => 'अन्य टीका';

  @override
  String recordVaccineFor(String name) {
    return '$name का टीका दर्ज करें';
  }

  @override
  String get dateGiven => 'दिया गया';

  @override
  String get vaccineBrand => 'टीके का ब्रांड';

  @override
  String get batchNumber => 'बैच नंबर';

  @override
  String get vetName => 'डॉक्टर का नाम';

  @override
  String get clinicName => 'क्लिनिक';

  @override
  String get attachCertificate => 'प्रमाणपत्र की फ़ोटो लगाएँ';

  @override
  String get certificateAttached => 'प्रमाणपत्र लगा (तिजोरी में सहेजा)';

  @override
  String vaccineRecorded(String vaccine, String name) {
    return '$name का $vaccine दर्ज हुआ';
  }

  @override
  String givenOn(String date) {
    return '$date को दिया';
  }

  @override
  String dueOn(String date) {
    return '$date को बकाया';
  }

  @override
  String get nextDueShort => 'अगली बार';

  @override
  String get catchUpNote =>
      'अभी टीकों का इतिहास नहीं है। डॉक्टर से कैच-अप प्लान पूछें और पुराने टीके \'दर्ज करें\' से जोड़ें।';

  @override
  String get rabbitVaccineNote =>
      'भारत में खरगोशों के लिए कोई तय टीका कार्यक्रम नहीं है। विदेशी जानवरों के डॉक्टर से पूछें; हर 6–12 महीने जाँच कराना अच्छा है।';

  @override
  String get birdVaccineNote =>
      'आम पालतू पक्षियों को नियमित टीके नहीं चाहिए। हर साल पक्षियों के डॉक्टर से जाँच कराएँ, नाखून और चोंच पर नज़र रखें।';

  @override
  String get medicines => 'दवाएँ';

  @override
  String get medicineName => 'दवा';

  @override
  String addMedicineFor(String name) {
    return '$name के लिए दवा जोड़ें';
  }

  @override
  String get editMedicine => 'दवा बदलें';

  @override
  String get unit => 'इकाई';

  @override
  String get unitTablet => 'गोली';

  @override
  String get unitMl => 'मि.ली.';

  @override
  String get unitDrops => 'बूँदें';

  @override
  String get unitMg => 'मि.ग्रा.';

  @override
  String get unitCapsule => 'कैप्सूल';

  @override
  String get unitSachet => 'पाउच';

  @override
  String get frequency => 'कितनी बार';

  @override
  String get freqOnce => 'दिन में एक बार';

  @override
  String get freqTwice => 'दिन में दो बार';

  @override
  String freqEveryHours(int hours) {
    return 'हर $hours घंटे';
  }

  @override
  String get freqWeekly => 'हफ़्ते में एक बार';

  @override
  String get freqCustom => 'अपने समय';

  @override
  String get doseTimes => 'खुराक का समय';

  @override
  String get firstDoseAt => 'पहली खुराक';

  @override
  String get addTime => 'समय जोड़ें';

  @override
  String get withFood => 'खाने के साथ';

  @override
  String get startDate => 'शुरू होने की तारीख';

  @override
  String get noEndDate => 'कोई अंतिम तारीख नहीं';

  @override
  String endsOn(String date) {
    return '$date को खत्म';
  }

  @override
  String get setEndDate => 'अंतिम तारीख चुनें';

  @override
  String get stockCount => 'स्टॉक में खुराक (वैकल्पिक)';

  @override
  String get stockHint => '5 बचने पर हम दोबारा मँगाने की याद दिलाएँगे';

  @override
  String medicineSaved(String name) {
    return '$name सहेजी गई';
  }

  @override
  String noMedicines(String name) {
    return '$name कोई दवा नहीं ले रहा।';
  }

  @override
  String nextDoseAt(String time) {
    return 'अगली: $time';
  }

  @override
  String stockLeft(int count) {
    return '$count बची';
  }

  @override
  String get refill => 'दोबारा मँगाएँ';

  @override
  String refillNeeded(String name) {
    return '$name दोबारा मँगाएँ';
  }

  @override
  String get given => 'दे दी';

  @override
  String get snooze15 => '15 मिनट बाद';

  @override
  String doseGiven(String name) {
    return '$name दी गई';
  }

  @override
  String get doseSkipped => 'खुराक छोड़ी';

  @override
  String get doseSnoozed => 'हम 15 मिनट में याद दिलाएँगे';

  @override
  String todayAt(String time) {
    return 'आज, $time';
  }

  @override
  String overdueBy(int days) {
    return '$days दिन देर';
  }

  @override
  String get dueToday => 'आज बकाया';

  @override
  String dueInDays(int days) {
    return '$days दिन में';
  }

  @override
  String get prevention => 'कृमिनाशक और पिस्सू/किलनी';

  @override
  String get deworming => 'कृमिनाशक';

  @override
  String get fleaTick => 'पिस्सू और किलनी से बचाव';

  @override
  String lastDone(String date) {
    return 'पिछली $date';
  }

  @override
  String nextDue(String date) {
    return 'अगली $date';
  }

  @override
  String get tickFeverNote =>
      'भारत में टिक फीवर आम है। पिस्सू और किलनी से बचाव समय पर करें।';

  @override
  String get productUsed => 'इस्तेमाल की गई दवा';

  @override
  String get weightNeedsTwo => 'चार्ट देखने के लिए दो या ज़्यादा वज़न जोड़ें।';

  @override
  String weightRangeNote(String range) {
    return 'हरी पट्टी: अनुमानित स्वस्थ सीमा $range। डॉक्टर से ज़रूर पूछें।';
  }

  @override
  String get weightGrowingNote =>
      'अभी बढ़ रहा है। सही वज़न आपके डॉक्टर बताएँगे।';

  @override
  String get vetVisit => 'डॉक्टर विज़िट';

  @override
  String get vetVisits => 'डॉक्टर विज़िट';

  @override
  String get reasonForVisit => 'आने का कारण';

  @override
  String get diagnosis => 'निदान या सलाह';

  @override
  String get noVisits => 'अभी कोई डॉक्टर विज़िट दर्ज नहीं।';

  @override
  String get symptom => 'लक्षण';

  @override
  String get symptomDiary => 'लक्षण डायरी';

  @override
  String get noSymptoms => 'कोई लक्षण नहीं। यह अच्छी खबर है।';

  @override
  String get severity => 'कितना गंभीर है?';

  @override
  String get severeSymptomNote =>
      'अगर पालतू को साँस लेने में दिक्कत, बेहोशी, दौरा या ज़हर खाने का शक हो, तो अभी SOS दबाएँ।';

  @override
  String get shareWithVet => 'डॉक्टर से साझा करें';

  @override
  String symptomShareTitle(String name) {
    return '$name की लक्षण डायरी (PawSetu)';
  }

  @override
  String get symVomiting => 'उल्टी';

  @override
  String get symDiarrhoea => 'दस्त';

  @override
  String get symNotEating => 'खाना नहीं खा रहा';

  @override
  String get symLimping => 'लँगड़ाना';

  @override
  String get symItching => 'खुजली';

  @override
  String get symCoughing => 'खाँसी';

  @override
  String get symLethargy => 'बहुत सुस्त';

  @override
  String get symSneezing => 'छींकना';

  @override
  String get symOther => 'अन्य';

  @override
  String savedFor(String what, String name) {
    return '$name के लिए $what सहेजा';
  }

  @override
  String get reminders => 'रिमाइंडर';

  @override
  String get noReminders => 'कोई अपना रिमाइंडर नहीं।';

  @override
  String newReminderFor(String name) {
    return '$name के लिए नया रिमाइंडर';
  }

  @override
  String get reminderTitle => 'किस बात की याद दिलाएँ?';

  @override
  String get repeat => 'दोहराएँ';

  @override
  String get repeatNone => 'न दोहराएँ';

  @override
  String get repeatMonthly => 'हर महीने';

  @override
  String get repeatYearly => 'हर साल';

  @override
  String get reminderSet => 'रिमाइंडर लग गया';

  @override
  String get remTypeLicence => 'लाइसेंस नवीनीकरण';

  @override
  String get remTypeInsurance => 'बीमा नवीनीकरण';

  @override
  String get remTypeGrooming => 'ग्रूमिंग का समय';

  @override
  String get remTypeNailTrim => 'नाखून काटना';

  @override
  String get remTypeBirthday => 'जन्मदिन';

  @override
  String get remTypeCustom => 'कुछ और';

  @override
  String remVaccineDue(String name, String vaccine) {
    return '$name का $vaccine जल्द बकाया है';
  }

  @override
  String remVaccineOverdue(String name, String vaccine) {
    return '$name का $vaccine बकाया है';
  }

  @override
  String remMedicine(String name, String medicine) {
    return '$name की $medicine का समय';
  }

  @override
  String remRefill(String medicine, String name) {
    return '$name की $medicine कम बची है';
  }

  @override
  String remDeworming(String name) {
    return '$name का कृमिनाशक बकाया है';
  }

  @override
  String remFleaTick(String name) {
    return '$name का पिस्सू-किलनी बचाव बकाया है';
  }

  @override
  String get remTapToOpen => 'PawSetu खोलने के लिए टैप करें';

  @override
  String get remSnoozed => '15 मिनट के लिए टाला';

  @override
  String get markAllRead => 'सब पढ़ा हुआ करें';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterUnread => 'बिना पढ़े';

  @override
  String get filterBookings => 'बुकिंग';

  @override
  String get filterOrdersMessages => 'ऑर्डर और संदेश';

  @override
  String get noNotificationsTitle => 'सब देख लिया';

  @override
  String get noNotificationsBody => 'रिमाइंडर और अपडेट यहाँ दिखेंगे।';

  @override
  String get ntVaccines => 'टीके';

  @override
  String get ntMedicines => 'दवाएँ';

  @override
  String get ntDeworming => 'कृमिनाशक और पिस्सू/किलनी';

  @override
  String get ntBookings => 'बुकिंग';

  @override
  String get ntRoutine => 'रोज़ की दिनचर्या';

  @override
  String get ntCustom => 'मेरे रिमाइंडर';

  @override
  String get chPush => 'पुश';

  @override
  String get chEmail => 'ईमेल';

  @override
  String get chSms => 'SMS';

  @override
  String get chWhatsApp => 'WhatsApp';

  @override
  String get channelsDemoNote =>
      'डेमो: फ़ोन पर पुश रिमाइंडर असली हैं। ईमेल, SMS और WhatsApp भेजे नहीं जाते, डेमो आउटबॉक्स में जाते हैं।';

  @override
  String get quietHours => 'शांत समय';

  @override
  String get quietHoursOn => 'रात में परेशान न करें';

  @override
  String get quietHoursHint =>
      'रिमाइंडर सुबह तक रुकेंगे। दवा के रिमाइंडर हमेशा समय पर बजेंगे।';

  @override
  String get notificationsOn => 'सूचनाएँ चालू हैं';

  @override
  String get notificationsOffHint =>
      'सूचनाएँ बंद हैं। फ़ोन की सेटिंग्स में चालू कर सकते हैं।';

  @override
  String get preparingDocument => 'आपका दस्तावेज़ तैयार हो रहा है…';

  @override
  String get sharePdf => 'PDF साझा करें या सहेजें';

  @override
  String generatedOn(String date) {
    return '$date को बनाया';
  }

  @override
  String get reportFooter =>
      'PawSetu से बनाया · डेमो डेटा · अनुमानित, डॉक्टर से पुष्टि करें';

  @override
  String get ownerAndClinic => 'मालिक और क्लिनिक';

  @override
  String get noKnownAllergies => 'कोई ज्ञात एलर्जी नहीं';

  @override
  String get currentMedicines => 'चल रही दवाएँ';

  @override
  String get rabiesVaccine => 'रेबीज़ टीका';

  @override
  String get notRecorded => 'दर्ज नहीं';

  @override
  String medicalCardUpdated(String date) {
    return '$date को अपडेट';
  }

  @override
  String get medicalCardOffline =>
      'यह कार्ड बिना इंटरनेट के चलता है। डॉक्टर, बोर्डिंग सेंटर या एयरपोर्ट पर दिखाएँ।';

  @override
  String get bookTitle => 'देखभाल बुक करें';

  @override
  String get findAVet => 'पास का पशु-चिकित्सक ढूँढें';

  @override
  String get kindVet => 'पशु क्लिनिक';

  @override
  String get kindGrooming => 'ग्रूमिंग';

  @override
  String get kindTraining => 'ट्रेनिंग';

  @override
  String get kindBoarding => 'बोर्डिंग';

  @override
  String get kindWalking => 'डॉग वॉकिंग';

  @override
  String get teleVet => 'टेली-वेट';

  @override
  String get clinicFinderMap => 'नक्शे पर क्लिनिक';

  @override
  String get clinicFinderHint =>
      'अपने आस-पास खुले क्लिनिक और 24x7 इमरजेंसी देखें।';

  @override
  String get myBookings => 'मेरी बुकिंग';

  @override
  String get upcoming => 'आने वाली';

  @override
  String get requests => 'अनुरोध';

  @override
  String get past => 'पिछली';

  @override
  String get noUpcomingBookings => 'कोई आने वाली बुकिंग नहीं।';

  @override
  String get noRequests => 'कोई अनुरोध बाकी नहीं।';

  @override
  String get noPastBookings => 'अभी कोई पिछली बुकिंग नहीं।';

  @override
  String get bookSomething => 'कुछ बुक करें';

  @override
  String get viewBooking => 'बुकिंग देखें';

  @override
  String get backToBook => 'बुक पर वापस';

  @override
  String get searchByNameOrArea => 'नाम या इलाके से खोजें';

  @override
  String get useMyLocation => 'मेरी लोकेशन लें';

  @override
  String get nearYou => 'आपके पास';

  @override
  String get chooseArea => 'अपना इलाका चुनें';

  @override
  String get locationWhyClinics =>
      'PawSetu आपकी लोकेशन सिर्फ क्लिनिक और सेवाओं को दूरी के हिसाब से दिखाने में लेता है। इसे सेव नहीं किया जाता।';

  @override
  String get locationFallback =>
      'लोकेशन नहीं मिली। आपका चुना इलाका दिखा रहे हैं।';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get clearFilters => 'फ़िल्टर हटाएँ';

  @override
  String get showResults => 'नतीजे दिखाएँ';

  @override
  String get sortBy => 'क्रम';

  @override
  String get sortNearest => 'सबसे पास';

  @override
  String get sortRating => 'सबसे अच्छी रेटिंग';

  @override
  String get sortSlot => 'सबसे जल्दी स्लॉट';

  @override
  String get sortFee => 'सबसे कम फ़ीस';

  @override
  String get openNow => 'अभी खुला';

  @override
  String get openNowChip => 'अभी खुला';

  @override
  String get closedChip => 'बंद';

  @override
  String get open24x7 => '24x7';

  @override
  String get open24x7Long => '24 घंटे, सातों दिन खुला';

  @override
  String get teleVetAvailable => 'टेली-वेट उपलब्ध';

  @override
  String get homeVisit => 'घर पर विज़िट';

  @override
  String get rating => 'रेटिंग';

  @override
  String get rating4plus => '4★ और ऊपर';

  @override
  String get speciesTreated => 'किन जानवरों का इलाज';

  @override
  String get languagesSpoken => 'बोली जाने वाली भाषाएँ';

  @override
  String get consultationFee => 'परामर्श फ़ीस';

  @override
  String upTo(String amount) {
    return '$amount तक';
  }

  @override
  String feeFrom(String amount) {
    return '$amount से';
  }

  @override
  String resultsCount(int count) {
    return '$count नतीजे';
  }

  @override
  String get listView => 'सूची';

  @override
  String get mapView => 'नक्शा';

  @override
  String get noResultsTitle => 'कुछ नहीं मिला';

  @override
  String get noResultsBody => 'दूसरा इलाका चुनें या कुछ फ़िल्टर हटाएँ।';

  @override
  String reviewsCount(int count) {
    return '$count रिव्यू';
  }

  @override
  String get call => 'कॉल करें';

  @override
  String get directions => 'रास्ता';

  @override
  String get bookNow => 'अभी बुक करें';

  @override
  String demoCallBody(String phone) {
    return 'डेमो मोड में असली कॉल नहीं होती। असली ऐप में यह $phone पर कॉल करेगा।';
  }

  @override
  String get hoursTitle => 'समय';

  @override
  String get closedToday => 'आज बंद';

  @override
  String todayHours(String open, String close) {
    return 'आज $open – $close';
  }

  @override
  String emergencyLine(String phone) {
    return 'इमरजेंसी लाइन: $phone';
  }

  @override
  String get servicesAndPrices => 'सेवाएँ और दाम';

  @override
  String get instantBooking => 'तुरंत बुकिंग';

  @override
  String get requestBooking => 'बुकिंग का अनुरोध';

  @override
  String get payOnline => 'ऑनलाइन भुगतान';

  @override
  String get payAtCentre => 'सेंटर पर भुगतान';

  @override
  String get payAtClinic => 'क्लिनिक पर भुगतान';

  @override
  String homeVisitAvailable(int km) {
    return '$km किमी तक घर पर विज़िट';
  }

  @override
  String get packages => 'पैकेज';

  @override
  String get vetsHere => 'यहाँ के डॉक्टर';

  @override
  String yearsExperience(int years) {
    return '$years वर्ष अनुभव';
  }

  @override
  String regNo(String no) {
    return 'रजि. नं. $no';
  }

  @override
  String get location => 'लोकेशन';

  @override
  String get reviews => 'रिव्यू';

  @override
  String get noReviewsYet => 'अभी कोई रिव्यू नहीं।';

  @override
  String get verifiedBooking => 'पुष्ट बुकिंग';

  @override
  String replyFrom(String name) {
    return '$name का जवाब';
  }

  @override
  String get inClinic => 'क्लिनिक में';

  @override
  String get svcConsultation => 'परामर्श';

  @override
  String get svcVaccination => 'टीकाकरण';

  @override
  String get svcSurgery => 'सर्जरी परामर्श';

  @override
  String get svcDental => 'दाँतों की सफ़ाई';

  @override
  String get svcLabTests => 'लैब टेस्ट';

  @override
  String get svcXray => 'एक्स-रे';

  @override
  String get svcHomeVisit => 'घर पर विज़िट';

  @override
  String get svcGrooming => 'ग्रूमिंग';

  @override
  String get svcBathBrush => 'नहलाना और ब्रश';

  @override
  String get svcFullGroom => 'पूरी ग्रूमिंग';

  @override
  String get svcNailTrim => 'नाखून काटना';

  @override
  String get svcTickTreatment => 'टिक उपचार';

  @override
  String get svcObedience => 'आज्ञाकारिता ट्रेनिंग';

  @override
  String get svcPuppyBasics => 'पिल्लों की बेसिक ट्रेनिंग';

  @override
  String get svcBehaviour => 'व्यवहार सत्र';

  @override
  String get svcBoarding => 'बोर्डिंग';

  @override
  String get svcBoardingNight => 'बोर्डिंग (प्रति रात)';

  @override
  String get svcDayCare => 'डे केयर';

  @override
  String get svcHomeSitting => 'घर पर देखभाल';

  @override
  String get svcWalk30 => '30 मिनट की सैर';

  @override
  String get svcWalk60 => '60 मिनट की सैर';

  @override
  String get stepWhoWhat => 'पालतू और सेवा';

  @override
  String get stepWhen => 'तारीख और समय';

  @override
  String get stepDetails => 'जानकारी';

  @override
  String get stepConfirm => 'पुष्टि करें';

  @override
  String get whichPet => 'कौन सा पालतू?';

  @override
  String get whichService => 'कौन सी सेवा?';

  @override
  String get chooseVet => 'डॉक्टर चुनें';

  @override
  String get anyVet => 'कोई भी उपलब्ध डॉक्टर';

  @override
  String get noPetForPlace =>
      'आपका कोई पालतू यहाँ बुक नहीं हो सकता। पहले पालतू जोड़ें।';

  @override
  String homeVisitHint(int km, String fee) {
    return '$km किमी तक, यात्रा शुल्क $fee';
  }

  @override
  String get openSlots => 'खाली स्लॉट';

  @override
  String get noSlotsThatDay => 'उस दिन कोई स्लॉट खाली नहीं। दूसरा दिन चुनें।';

  @override
  String requestExplainer(int hours) {
    return 'अपनी सुविधा के 3 समय चुनें। प्रोवाइडर $hours घंटे में जवाब देगा।';
  }

  @override
  String get yourPreferredTimes => 'आपके पसंदीदा समय';

  @override
  String get preferredTimes => 'पसंदीदा समय';

  @override
  String get symptomsNotes => 'डॉक्टर के लिए लक्षण या नोट';

  @override
  String get symptomsHint => 'जैसे कल से खाना नहीं खा रहा, दो बार उल्टी';

  @override
  String get notesForProvider => 'प्रोवाइडर के लिए नोट';

  @override
  String get notes => 'नोट';

  @override
  String get howToPay => 'भुगतान कैसे करेंगे?';

  @override
  String get payOnlineHint => 'अभी UPI या कार्ड से। तुरंत पुष्टि।';

  @override
  String get payLaterHint => 'विज़िट के समय भुगतान करें।';

  @override
  String get when => 'कब';

  @override
  String get where => 'कहाँ';

  @override
  String get pet => 'पालतू';

  @override
  String get vet => 'डॉक्टर';

  @override
  String get travelFee => 'यात्रा शुल्क';

  @override
  String get platformFee => 'प्लेटफ़ॉर्म शुल्क';

  @override
  String get free => 'मुफ़्त';

  @override
  String get totalToPay => 'कुल';

  @override
  String cancellationPolicy(int hours) {
    return '$hours घंटे पहले तक मुफ़्त रद्द। उसके बाद 50% रिफ़ंड।';
  }

  @override
  String get confirmBooking => 'बुकिंग पक्की करें';

  @override
  String get sendRequest => 'अनुरोध भेजें';

  @override
  String get demoBookingNote => 'डेमो बुकिंग। कोई असली पैसा नहीं कटेगा।';

  @override
  String get bookingConfirmedTitle => 'बुकिंग पक्की';

  @override
  String bookingConfirmedBody(String pet, String place, String when) {
    return '$pet की बुकिंग $place पर $when को पक्की है।';
  }

  @override
  String get requestSentTitle => 'अनुरोध भेजा गया';

  @override
  String requestSentBody(String place) {
    return '$place जल्द जवाब देगा। हम आपको सूचित करेंगे।';
  }

  @override
  String get paymentFailed => 'भुगतान विफल। कोई पैसा नहीं कटा। फिर कोशिश करें।';

  @override
  String get paymentPendingNote =>
      'भुगतान लंबित है। पूरा होते ही पुष्टि करेंगे।';

  @override
  String get demoPaymentTitle => 'डेमो भुगतान';

  @override
  String get demoPaymentNote => 'यह डेमो है। कोई पैसा नहीं कटेगा।';

  @override
  String get demoPaymentChoose => 'चुनें क्या होगा:';

  @override
  String get payUpiDemo => 'UPI से भुगतान (डेमो)';

  @override
  String get simulateFailure => 'विफलता दिखाएँ';

  @override
  String get simulatePending => 'लंबित दिखाएँ';

  @override
  String get bookingDetails => 'बुकिंग जानकारी';

  @override
  String get replyBy => 'जवाब की समय-सीमा';

  @override
  String replyBefore(String time) {
    return '$time से पहले जवाब दें';
  }

  @override
  String get payment => 'भुगतान';

  @override
  String get paidOnline => 'ऑनलाइन भुगतान हुआ';

  @override
  String get paymentPending => 'भुगतान लंबित';

  @override
  String get payAtVisit => 'विज़िट पर भुगतान';

  @override
  String get platformCommission => 'प्लेटफ़ॉर्म कमीशन';

  @override
  String get yourPayout => 'आपका भुगतान';

  @override
  String get refund => 'रिफ़ंड';

  @override
  String refundDemo(String amount) {
    return '$amount (डेमो, असली पैसा नहीं)';
  }

  @override
  String providerSuggested(String place, String when) {
    return '$place ने नया समय सुझाया: $when';
  }

  @override
  String get liveWalk => 'लाइव सैर';

  @override
  String get liveWalkDemo => 'डेमो के लिए नकली लाइव सैर।';

  @override
  String walkSoFar(String km) {
    return 'अब तक $km';
  }

  @override
  String get updates => 'अपडेट';

  @override
  String get dailyUpdates => 'रोज़ के अपडेट';

  @override
  String get addToCalendar => 'कैलेंडर में जोड़ें';

  @override
  String get message => 'मैसेज';

  @override
  String get reschedule => 'समय बदलें';

  @override
  String rescheduledTo(String when) {
    return '$when पर बदला गया';
  }

  @override
  String get cancelBooking => 'बुकिंग रद्द करें';

  @override
  String get cancelBookingQ => 'यह बुकिंग रद्द करें?';

  @override
  String cancelRefundInfo(String amount) {
    return 'आपको $amount वापस मिलेंगे (डेमो)।';
  }

  @override
  String cancelledWithRefund(String amount) {
    return 'रद्द हुआ। $amount रिफ़ंड (डेमो)।';
  }

  @override
  String get bookingCancelled => 'बुकिंग रद्द';

  @override
  String get writeReview => 'रिव्यू लिखें';

  @override
  String rateProvider(String name) {
    return '$name कैसा रहा?';
  }

  @override
  String starsLabel(int count) {
    return '$count स्टार';
  }

  @override
  String get reviewText => 'दूसरे पालतू-माता-पिता को बताएँ क्या अच्छा रहा';

  @override
  String get postReview => 'रिव्यू पोस्ट करें';

  @override
  String get thanksForReview => 'रिव्यू के लिए धन्यवाद!';

  @override
  String get bsPending => 'जवाब का इंतज़ार';

  @override
  String get bsConfirmed => 'पक्की';

  @override
  String get bsSuggested => 'नया समय सुझाया';

  @override
  String get bsInProgress => 'चल रहा है';

  @override
  String get bsCompleted => 'पूरा हुआ';

  @override
  String get bsCancelled => 'रद्द';

  @override
  String get bsDeclined => 'अस्वीकार';

  @override
  String get bsExpired => 'समय समाप्त';

  @override
  String ntfNewBooking(String pet, String when) {
    return 'नई बुकिंग: $pet, $when';
  }

  @override
  String ntfNewRequest(String pet) {
    return '$pet के लिए नया बुकिंग अनुरोध';
  }

  @override
  String ntfAccepted(String place, String when) {
    return '$place ने $when की आपकी बुकिंग पक्की की';
  }

  @override
  String ntfDeclined(String place) {
    return '$place आपका अनुरोध नहीं ले सका';
  }

  @override
  String ntfSuggested(String place, String when) {
    return '$place ने इसकी जगह $when सुझाया';
  }

  @override
  String ntfCancelled(String pet, String when) {
    return '$pet की $when की बुकिंग रद्द हुई';
  }

  @override
  String ntfRescheduled(String pet, String when) {
    return '$pet की बुकिंग $when पर बदली';
  }

  @override
  String ntfCompleted(String pet, String place) {
    return '$place पर $pet की विज़िट पूरी हुई। अनुभव रेट करें?';
  }

  @override
  String ntfUpdate(String place, String pet) {
    return '$place ने $pet के बारे में अपडेट भेजा';
  }

  @override
  String ntfExpired(String place) {
    return '$place ने समय पर जवाब नहीं दिया। अनुरोध समाप्त हुआ।';
  }

  @override
  String helloPartner(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get noBusinessLinked => 'इस खाते से अभी कोई बिज़नेस जुड़ा नहीं है।';

  @override
  String get waitingApproval =>
      'मंज़ूरी का इंतज़ार। PawSetu नए पार्टनर की जाँच 2 कार्य-दिवस में करता है। तब तक अपनी सेवाएँ सेट करें।';

  @override
  String get todaysBookings => 'आज की बुकिंग';

  @override
  String get requestsWaiting => 'बाकी अनुरोध';

  @override
  String get earningsThisMonth => 'इस महीने की कमाई';

  @override
  String get completedBookings => 'पूरी हुईं';

  @override
  String get noBookingsToday => 'आज कोई बुकिंग नहीं।';

  @override
  String bookingsOn(String date) {
    return '$date की बुकिंग';
  }

  @override
  String get noBookingsThisDay => 'इस दिन कोई बुकिंग नहीं।';

  @override
  String get holidayNoBookings => 'छुट्टी के रूप में चिह्नित। कोई बुकिंग नहीं।';

  @override
  String get markHoliday => 'छुट्टी चिह्नित करें';

  @override
  String get removeHoliday => 'छुट्टी हटाएँ';

  @override
  String get blockTime => 'समय ब्लॉक करें';

  @override
  String timeBlocked(String time) {
    return '$time से ब्लॉक';
  }

  @override
  String get workingHours => 'काम का समय';

  @override
  String get opens => 'खुलता है';

  @override
  String get closes => 'बंद होता है';

  @override
  String get hoursAppliesMonSat =>
      'यह समय सोमवार से शनिवार तक लागू है। रविवार जैसा है वैसा रहेगा।';

  @override
  String slotSettings(int slot, int buffer, int capacity) {
    return '$slot मिनट स्लॉट · $buffer मिनट अंतर · प्रति स्लॉट $capacity';
  }

  @override
  String get slotLength => 'स्लॉट अवधि (मिनट)';

  @override
  String get bufferTime => 'स्लॉट के बीच अंतर (मिनट)';

  @override
  String get capacityPerSlot => 'प्रति स्लॉट पालतू';

  @override
  String get noRequestsPartner => 'अभी कोई बुकिंग अनुरोध नहीं।';

  @override
  String get waitingForOwner => 'मालिक के जवाब का इंतज़ार';

  @override
  String get chooseTimeToAccept => 'स्वीकार करने के लिए समय चुनें';

  @override
  String get suggestTime => 'दूसरा समय सुझाएँ';

  @override
  String get suggestionSent => 'मालिक को नया समय भेजा गया';

  @override
  String requestAccepted(String pet) {
    return '$pet की बुकिंग पक्की';
  }

  @override
  String declineRequestQ(String pet) {
    return '$pet का अनुरोध अस्वीकार करें?';
  }

  @override
  String get services => 'सेवाएँ';

  @override
  String get servicesHelp =>
      'अपने दाम, समय और बुकिंग का तरीका सेट करें। बदलाव ऐप में तुरंत दिखेंगे।';

  @override
  String get priceRupees => 'दाम (₹)';

  @override
  String get minutes => 'मिनट';

  @override
  String get bookingMode => 'बुकिंग का तरीका';

  @override
  String get paymentOptions => 'भुगतान विकल्प';

  @override
  String get saved => 'सेव हुआ';

  @override
  String get addVet => 'डॉक्टर जोड़ें';

  @override
  String get vcRegNumber => 'पशु-चिकित्सा परिषद रजि. नंबर';

  @override
  String get vcRegHelp =>
      'डॉक्टर के बुकिंग लेने से पहले PawSetu इसकी जाँच करता है।';

  @override
  String get vetAddedPending => 'डॉक्टर जोड़ा गया। जाँच का इंतज़ार।';

  @override
  String get reply => 'जवाब दें';

  @override
  String get yourReply => 'आपका जवाब';

  @override
  String get postReply => 'जवाब पोस्ट करें';

  @override
  String get totalPayouts => 'कुल भुगतान';

  @override
  String get payoutPending => 'लंबित';

  @override
  String get settled => 'चुकाया गया';

  @override
  String get payoutHistory => 'भुगतान इतिहास';

  @override
  String get noPayoutsYet => 'अभी कोई भुगतान नहीं।';

  @override
  String commissionLine(String amount) {
    return 'कमीशन $amount';
  }

  @override
  String get demoPayoutsNote => 'डेमो भुगतान। कोई असली पैसा नहीं जाता।';

  @override
  String get statusApproved => 'मंज़ूर';

  @override
  String get statusPendingApproval => 'मंज़ूरी बाकी';

  @override
  String get kycDocuments => 'KYC दस्तावेज़';

  @override
  String get uploadKyc => 'दस्तावेज़ अपलोड करें';

  @override
  String get kycUploaded => 'दस्तावेज़ जाँच के लिए अपलोड हुआ';

  @override
  String get emergencyPhone => 'इमरजेंसी फ़ोन';

  @override
  String get emergencySettingsHelp =>
      '24x7 क्लिनिक SOS में सबसे पहले दिखते हैं। अपना इमरजेंसी नंबर अपडेट रखें।';

  @override
  String get allowEnquiries => 'अभी इमरजेंसी कॉल लें';

  @override
  String get allowEnquiriesHint =>
      'भरा हो तो बंद करें। मालिकों को अगला क्लिनिक दिखेगा।';

  @override
  String get startService => 'शुरू करें';

  @override
  String get markCompleted => 'पूरा हुआ चिह्नित करें';

  @override
  String get sendPhotoUpdate => 'फ़ोटो अपडेट भेजें';

  @override
  String defaultUpdateText(String pet) {
    return '$pet बढ़िया है!';
  }

  @override
  String updateSent(String name) {
    return '$name को अपडेट भेजा';
  }

  @override
  String get partnerCancelNote => 'मालिक को पूरा रिफ़ंड और सूचना मिलेगी।';

  @override
  String get messageOwner => 'मालिक को मैसेज करें';

  @override
  String get partnerSignupLink => 'पालतू बिज़नेस चलाते हैं? पार्टनर बनें';

  @override
  String get partnerSignupTitle => 'PawSetu पार्टनर बनें';

  @override
  String get partnerSignupSubtitle =>
      'क्लिनिक, ग्रूमर, ट्रेनर, बोर्डिंग, वॉकर और पेट शॉप के लिए। जुड़ना मुफ़्त है।';

  @override
  String get businessType => 'कैसा बिज़नेस है?';

  @override
  String get kindSeller => 'पेट शॉप';

  @override
  String get businessName => 'बिज़नेस का नाम';

  @override
  String get areaCity => 'इलाका और शहर';

  @override
  String get businessPhone => 'बिज़नेस फ़ोन';

  @override
  String get businessAddress => 'पता (वैकल्पिक)';

  @override
  String get kycHelp =>
      'पहचान पत्र और बिज़नेस रजिस्ट्रेशन जोड़ें। लिस्टिंग लाइव होने से पहले PawSetu इनकी जाँच करता है।';

  @override
  String get useSampleDoc => 'नमूना दस्तावेज़ लें (डेमो)';

  @override
  String get sampleIdProof => 'पहचान पत्र (नमूना)';

  @override
  String get kycNeeded => 'कम से कम एक दस्तावेज़ जोड़ें।';

  @override
  String get yourAccount => 'आपका खाता';

  @override
  String get submitApplication => 'आवेदन भेजें';

  @override
  String get partnerApprovalNote =>
      'भेजने के बाद आपकी लिस्टिंग मंज़ूरी का इंतज़ार करेगी। तब तक सेवाएँ और दाम सेट करें।';

  @override
  String get remove => 'हटाएँ';

  @override
  String get aiTitle => 'PawSetu से पूछें';

  @override
  String get aiIntroTitle => 'पालतू के रोज़ के सवालों के झटपट जवाब';

  @override
  String get aiIntroBody =>
      'खाना, नहलाना, टीके, टिक और बहुत कुछ पूछें। कुछ गंभीर लगे तो डॉक्टर से बात करें।';

  @override
  String get aiHint => 'अपना सवाल लिखें';

  @override
  String get aiAsk => 'पूछें';

  @override
  String get aiPopular => 'लोकप्रिय सवाल';

  @override
  String get aiDisclaimer =>
      'यह सिर्फ़ सामान्य जानकारी है, बीमारी की जाँच नहीं। आपके पालतू को आपका डॉक्टर सबसे अच्छा जानता है।';

  @override
  String get aiNotDiagnosis =>
      'यह बीमारी की जाँच नहीं है। पालतू बीमार लगे तो डॉक्टर से बात करें।';

  @override
  String get aiUnknown =>
      'इसका जवाब अभी मेरे पास नहीं है। लोकप्रिय सवालों में से कोई चुनें या टेली-वेट में डॉक्टर से पूछें।';

  @override
  String get aiTalkToVet => 'डॉक्टर से पूछें';

  @override
  String get aiTalkToVetNow => 'अभी डॉक्टर से बात करें';

  @override
  String get aiUnlimited => 'Plus के साथ असीमित';

  @override
  String aiLeft(int left, int limit) {
    return 'इस महीने $limit में से $left सवाल बाकी';
  }

  @override
  String aiLimitTitle(int limit) {
    return 'आपने इस महीने के $limit सवाल पूछ लिए हैं';
  }

  @override
  String aiLimitBody(String date) {
    return '$date को और सवाल मिलेंगे, या PawSetu Plus से असीमित सवाल पूछें। इमरजेंसी का जवाब हमेशा मिलेगा।';
  }

  @override
  String get aiRedFlagTitle => 'यह इमरजेंसी हो सकती है';

  @override
  String aiRedFlagBody(String sign) {
    return '$sign में तुरंत डॉक्टर ज़रूरी है। पास के खुले क्लिनिक तक पहुँचने के लिए SOS दबाएँ, या अभी डॉक्टर से बात करें।';
  }

  @override
  String aiRedFlagShort(String sign) {
    return 'संभावित इमरजेंसी: $sign';
  }

  @override
  String aiTileHint(int left) {
    return 'रोज़ के सवालों के तुरंत जवाब। इस महीने $left बाकी।';
  }

  @override
  String get aiTileHintPlus =>
      'रोज़ के सवालों के तुरंत जवाब। Plus के साथ असीमित।';

  @override
  String get rfBreathing => 'सांस लेने में तकलीफ़';

  @override
  String get rfCollapse => 'गिर जाना या बेहोशी';

  @override
  String get rfSeizure => 'दौरा (मिर्गी)';

  @override
  String get rfPoisoning => 'ज़हर खाने की आशंका';

  @override
  String get rfBleeding => 'बहुत ज़्यादा खून बहना';

  @override
  String get rfBloat => 'फूला और सख़्त पेट';

  @override
  String get rfHeatstroke => 'लू लगना';

  @override
  String get rfUrine => 'पेशाब न आना';

  @override
  String get rfInjury => 'गंभीर चोट';

  @override
  String get aiQBath => 'कुत्ते को कितनी बार नहलाना चाहिए?';

  @override
  String get aiQFeeding => 'पालतू को कितना खाना देना चाहिए?';

  @override
  String get aiQToxicFood => 'इंसानों का कौन सा खाना पालतू के लिए ख़तरनाक है?';

  @override
  String get aiQVaccines => 'मेरे पालतू को कौन से टीके चाहिए?';

  @override
  String get aiQDeworming => 'कीड़े की दवा कितनी बार देनी चाहिए?';

  @override
  String get aiQTicks => 'टिक और पिस्सू से कैसे बचाएँ?';

  @override
  String get aiQHeat => 'गर्मी में पालतू को ठंडा कैसे रखें?';

  @override
  String get aiQVomiting => 'मेरे पालतू ने उल्टी की है। क्या करूँ?';

  @override
  String get aiQDiarrhoea => 'पालतू को दस्त हो रहे हैं। क्या करूँ?';

  @override
  String get aiQNotEating => 'पालतू खाना नहीं खा रहा। क्या चिंता की बात है?';

  @override
  String get aiQItching => 'मेरा कुत्ता बार-बार खुजलाता क्यों है?';

  @override
  String get aiQLimping => 'मेरा कुत्ता लंगड़ा रहा है। क्या करूँ?';

  @override
  String get aiQLitter => 'मेरी बिल्ली लिटर बॉक्स इस्तेमाल नहीं करती। क्यों?';

  @override
  String get aiQChewing => 'पिल्ले का चबाना और काटना कैसे रोकें?';

  @override
  String get aiQNails => 'पालतू के नाखून कैसे काटें?';

  @override
  String get aiQTeeth => 'पालतू के दाँतों का ध्यान कैसे रखें?';

  @override
  String get aiQBirdDiet => 'अपने पक्षी को क्या खिलाऊँ?';

  @override
  String get aiQRabbitDiet => 'अपने खरगोश को क्या खिलाऊँ?';

  @override
  String get aiQWeight => 'क्या मेरा पालतू मोटा है?';

  @override
  String get aiQAnxiety =>
      'मेरा पालतू पटाखों और बिजली की गड़गड़ाहट से डरता है। कैसे मदद करूँ?';

  @override
  String get aiABath =>
      'ज़्यादातर कुत्तों को हर 3 से 4 हफ़्ते में नहलाना काफ़ी है; गंदे होने या बदबू आने पर ही ज़्यादा बार। कुत्तों वाला शैम्पू और गुनगुना पानी इस्तेमाल करें (इंसानों का शैम्पू त्वचा सुखा सकता है), और अच्छे से धोएँ। कान और बाल पूरी तरह सुखाएँ, ख़ासकर बारिश के मौसम में, ताकि फंगल इन्फ़ेक्शन न हो। हफ़्ते में कुछ बार ब्रश करने से बाल साफ़ रहते हैं। बिल्लियों को नहलाने की ज़रूरत बहुत कम होती है।';

  @override
  String get aiAFeeding =>
      'यह पालतू के वज़न, उम्र और कितना खेलता है, उस पर निर्भर है। खाने के पैकेट पर पालतू के सही वज़न के हिसाब से लिखी मात्रा से शुरू करें, बड़े कुत्ते-बिल्लियों के लिए 2 बार में (पिल्लों और बिल्ली के बच्चों के लिए 3 से 4 बार)। हर कुछ हफ़्ते में कमर और पसलियाँ जाँचें: पसलियाँ आसानी से महसूस होनी चाहिए। ट्रीट रोज़ के खाने के दसवें हिस्से से कम रखें। हमेशा ताज़ा पानी रखें। सही मात्रा आपका डॉक्टर बता सकता है।';

  @override
  String get aiAToxicFood =>
      'चॉकलेट, अंगूर या किशमिश, प्याज, लहसुन, ज़ाइलिटॉल (कुछ शुगर-फ़्री च्युइंग गम और मिठाइयों में), शराब, कैफ़ीन, पकी हड्डियाँ, और बहुत नमकीन या तीखा खाना कभी न दें। त्योहार की कई मिठाइयों में चॉकलेट, किशमिश या ज़ाइलिटॉल होता है, उन्हें पहुँच से दूर रखें। लिली के फूल बिल्लियों के लिए भी ख़तरनाक हैं। अगर पालतू ने इनमें से कुछ खाया है, तो ठीक दिखे तब भी SOS दबाएँ या अभी डॉक्टर को फ़ोन करें।';

  @override
  String get aiAVaccines =>
      'कुत्तों को लेप्टोस्पायरोसिस के साथ DHPPi (6 से 8 हफ़्ते की उम्र से पिल्ले की 3 खुराक), लगभग 3 महीने पर रेबीज़ का टीका, और हर साल बूस्टर चाहिए। बिल्लियों को ट्राईकैट टीका और रेबीज़ का टीका चाहिए, साथ में हर साल बूस्टर। भारत में खरगोश और पक्षियों को आमतौर पर नियमित टीकों की ज़रूरत नहीं होती। पालतू के सेहत टैब में पूरा शेड्यूल, क्या बाकी है और क्या देर से है, सब दिखता है। आख़िरी फ़ैसला आपका डॉक्टर करता है।';

  @override
  String get aiADeworming =>
      'पिल्ले और बिल्ली के बच्चे: 3 महीने की उम्र तक हर 2 हफ़्ते, फिर 6 महीने तक हर महीने। बड़े पालतू: हर 3 महीने। हर खुराक से पहले वज़न लें, क्योंकि खुराक वज़न पर निर्भर करती है। अगली खुराक का समय होने पर PawSetu याद दिलाता है। कौन सी दवा सही है, यह डॉक्टर से पूछें।';

  @override
  String get aiATicks =>
      'डॉक्टर की बताई टिक और पिस्सू की रोकथाम पूरे साल इस्तेमाल करें: स्पॉट-ऑन, चबाने वाली गोली या कॉलर। भारत में टिक आम हैं, ख़ासकर बारिश में। सैर के बाद कान, उँगलियों के बीच और कॉलर के नीचे देखें। बिस्तर साफ़ और सूखा रखें। कुत्तों की दवा बिल्लियों पर कभी न लगाएँ। टिक के काटने के बाद पालतू कमज़ोर हो, मसूड़े पीले दिखें या बुख़ार हो, तो जल्दी डॉक्टर को दिखाएँ।';

  @override
  String get aiAHeat =>
      'सुबह जल्दी या सूरज ढलने के बाद सैर कराएँ, और सड़क को हाथ से जाँचें: अगर 5 सेकंड भी हाथ न रख सकें, तो पंजों के लिए भी बहुत गर्म है। दिन भर ठंडा पानी और छाया रखें। पालतू को खड़ी गाड़ी में कभी न छोड़ें। पग और पर्शियन बिल्ली जैसी चपटे चेहरे वाली नस्लें सबसे जल्दी गर्म होती हैं। तेज़ हाँफना, लार टपकना, लड़खड़ाना या चटक लाल मसूड़े लू के लक्षण हैं: SOS दबाएँ।';

  @override
  String get aiAVomiting =>
      'अगर पालतू ने एक बार उल्टी की है और वह सामान्य व खेलता हुआ है, तो अक्सर ठीक हो जाता है: कुछ घंटे खाना न दें (पानी दें), फिर थोड़ा-थोड़ा सादा खाना दें, जैसे उबले चावल और उबला चिकन। अगर उल्टी बार-बार हो, ख़ून दिखे, पालतू पिल्ला या बिल्ली का बच्चा हो, कमज़ोर लगे, पेट फूला हो, या कुछ ज़हरीला या खिलौना निगलने की आशंका हो, तो उसी दिन डॉक्टर को दिखाएँ।';

  @override
  String get aiADiarrhoea =>
      'ताज़ा पानी रखें ताकि शरीर में पानी की कमी न हो, और एक-दो दिन थोड़ा-थोड़ा सादा खाना दें (कुत्तों के लिए उबले चावल और उबला चिकन या दही-चावल)। दूध और ट्रीट न दें। अगर दस्त एक दिन से ज़्यादा रहें, ख़ून या काला मल दिखे, साथ में उल्टी हो, पालतू कमज़ोर लगे, या पिल्ला या बिल्ली का बच्चा हो, तो डॉक्टर को दिखाएँ।';

  @override
  String get aiANotEating =>
      'गर्मी, तनाव या खाना बदलने से एक बार खाना छोड़ना हो सकता है। ताज़ा खाना और पानी दें और दूसरे लक्षणों पर नज़र रखें। अगर कुत्ता एक दिन से ज़्यादा, बिल्ली 24 घंटे से ज़्यादा, या खरगोश कुछ घंटे भी न खाए (खरगोश जल्दी बीमार होते हैं), या उल्टी, कमज़ोरी, दर्द या बुख़ार हो, तो डॉक्टर को दिखाएँ।';

  @override
  String get aiAItching =>
      'आम वजहें हैं टिक और पिस्सू, त्वचा का इन्फ़ेक्शन (अक्सर बारिश में), खाने या धूल से एलर्जी, और बार-बार नहलाने से सूखी त्वचा। त्वचा पर टिक, लाली, गंजे धब्बे या बदबू देखें। टिक-पिस्सू की रोकथाम जारी रखें और नहलाने और बारिश के बाद कुत्ते को अच्छे से सुखाएँ। अगर खुजली कुछ दिनों से ज़्यादा रहे या त्वचा छिल जाए, तो डॉक्टर को दिखाएँ।';

  @override
  String get aiALimping =>
      'पंजे में काँटा, काँच, कट, टूटा नाखून या उँगलियों के बीच टिक देखें, और सूजन जाँचें। कुत्ते को आराम दें: एक दिन सिर्फ़ छोटी-छोटी सैर, दौड़ना-कूदना नहीं। इंसानों की दर्द की दवा कभी न दें; कई पालतू के लिए ज़हर हैं। अगर लंगड़ाना एक दिन से ज़्यादा रहे, कुत्ता पैर पर वज़न न डाल पाए, दर्द से रोए, या गिरने या दुर्घटना के बाद हो, तो डॉक्टर को दिखाएँ।';

  @override
  String get aiALitter =>
      'बॉक्स साफ़ रखें (रोज़ साफ़ करें), खाने से दूर किसी शांत जगह पर, और हर बिल्ली के लिए एक बॉक्स और एक अतिरिक्त। कुछ बिल्लियों को ख़ुशबू वाला लिटर या ढका बॉक्स पसंद नहीं होता। नया पालतू या घर बदलना जैसा तनाव भी वजह हो सकता है। अगर बिल्ली बॉक्स में ज़ोर लगाए पर पेशाब बहुत कम या बिल्कुल न आए, तो यह इमरजेंसी है, ख़ासकर नर बिल्ली में: SOS दबाएँ।';

  @override
  String get aiAChewing =>
      'पिल्ले मुँह से चीज़ें समझते हैं और दाँत निकलते समय (3 से 6 महीने) ज़्यादा चबाते हैं। सुरक्षित चबाने वाले खिलौने दें और जब पिल्ला कुछ और पकड़े, तो उसकी जगह खिलौना दें। अगर वह काटे, तो कुछ सेकंड के लिए खेल रोकें, फिर आराम से खेलें। शांत खेल की तारीफ़ करें। तार, जूते और दवाएँ पहुँच से दूर रखें। ख़ूब सैर और खेल से चबाना कम होता है। 6 महीने के बाद भी जारी रहे तो ट्रेनर मदद कर सकता है।';

  @override
  String get aiANails =>
      'हर 3 से 4 हफ़्ते में, या जब फ़र्श पर नाखूनों की खट-खट सुनाई दे, तब काटें। पालतू वाला नेल कटर इस्तेमाल करें और सिर्फ़ सिरा काटें, गुलाबी हिस्से (क्विक) से नीचे (काले नाखूनों पर बहुत थोड़ा-थोड़ा काटें)। ख़ून आने पर लगाने के लिए स्टिप्टिक पाउडर या सादा कॉर्नफ़्लोर पास रखें। हर पंजे के बाद ट्रीट दें। अगर पालतू को बिल्कुल पसंद न हो, तो ग्रूमर या डॉक्टर कुछ मिनट में कर सकते हैं। पक्षियों और खरगोशों के नाखून भी काटने पड़ते हैं।';

  @override
  String get aiATeeth =>
      'कुत्ते या बिल्ली के दाँत हफ़्ते में 2 से 3 बार पालतू वाले टूथब्रश और टूथपेस्ट से साफ़ करें (इंसानों का टूथपेस्ट निगलना सुरक्षित नहीं)। फ़िंगर ब्रश से धीरे-धीरे शुरू करें और ख़ूब तारीफ़ करें। डेंटल च्यू थोड़ी मदद करते हैं। मुँह से बदबू, लाल मसूड़े, टूटा दाँत या खाना गिराना दाँतों की बीमारी का संकेत हो सकता है: डॉक्टर से दाँतों की जाँच बुक करें।';

  @override
  String get aiABirdDiet =>
      'सिर्फ़ बीज काफ़ी नहीं हैं। कॉकटेल और बजी के लिए अच्छी क्वालिटी के पेलेट्स के साथ रोज़ ताज़ी सब्ज़ियाँ (पालक, गाजर, बीन्स, मटर) और थोड़ा फल सबसे अच्छा है, और ट्रीट के रूप में थोड़े बीज। रोज़ ताज़ा पानी दें। एवोकाडो, चॉकलेट, कैफ़ीन, नमक या प्याज कभी न दें। भारत में तोतों की कई प्रजातियाँ संरक्षित हैं; सिर्फ़ क़ानूनी रूप से अनुमत पक्षी ही रखें।';

  @override
  String get aiARabbitDiet =>
      'खरगोश के खाने का लगभग 80% हिस्सा सूखी घास (हे) होनी चाहिए, जो दिन भर मिले: इससे दाँत और पेट ठीक रहते हैं। रोज़ मुट्ठी भर हरी पत्तेदार सब्ज़ियाँ (धनिया, पुदीना, लेट्यूस, गाजर के पत्ते), थोड़े खरगोश पेलेट्स, और फल सिर्फ़ कभी-कभार ट्रीट के रूप में दें। हमेशा ताज़ा पानी रखें। अगर खरगोश कुछ घंटे भी खाना या मल त्याग बंद कर दे, तो तुरंत डॉक्टर को दिखाएँ।';

  @override
  String get aiAWeight =>
      'पसलियाँ छूकर देखें: पतली परत के नीचे आसानी से महसूस होनी चाहिए, और ऊपर से कमर दिखनी चाहिए। अगर ऐसा नहीं है, तो पालतू का वज़न ज़्यादा हो सकता है। PawSetu में हर महीने वज़न दर्ज करें ताकि नस्ल की सही रेंज से तुलना दिखे। ट्रीट और बचा हुआ खाना कम करें, खाना नापकर दें, और थोड़ी ज़्यादा सैर या खेल जोड़ें। खाने में बड़ा बदलाव करने से पहले डॉक्टर से पूछें।';

  @override
  String get aiAAnxiety =>
      'दिवाली या तूफ़ान से पहले एक शांत कोना बनाएँ: ढका हुआ क्रेट या उनके बिस्तर वाला कोना, पर्दे बंद, पंखा या हल्का संगीत चालू। कुत्ते को दिन में जल्दी सैर कराएँ और पटाखे शुरू होने पर पहचान टैग के साथ घर के अंदर रखें। शांत और पास रहें, पर ज़बरदस्ती गले न लगाएँ। डरने पर डाँटें नहीं। बहुत ज़्यादा डर हो तो शांत करने के उपायों के बारे में पहले से डॉक्टर से पूछें।';

  @override
  String get msgEmptyTitle => 'अभी कोई चैट नहीं';

  @override
  String get msgEmptyBody =>
      'बुकिंग करने या सवाल पूछने के बाद डॉक्टर, क्लिनिक, ग्रूमर या वॉकर से चैट यहाँ दिखेंगी।';

  @override
  String get msgEmptyPartnerBody =>
      'पालतू-माता-पिता बुकिंग करें या पूछताछ भेजें, तो उनकी चैट यहाँ दिखेंगी।';

  @override
  String get msgEmptyFilter => 'इस सूची में कोई चैट नहीं';

  @override
  String msgNoResults(String query) {
    return '\"$query\" के लिए कुछ नहीं मिला';
  }

  @override
  String get msgSearchHint => 'चैट और मैसेज खोजें';

  @override
  String get msgClearSearch => 'खोज हटाएँ';

  @override
  String get msgFoundInMessages => 'मैसेज में मिला';

  @override
  String get msgEnquiries => 'पूछताछ';

  @override
  String get msgEnquiry => 'पूछताछ';

  @override
  String get msgMuted => 'म्यूट';

  @override
  String get msgNoMessagesYet => 'अभी कोई मैसेज नहीं';

  @override
  String msgUnreadCount(int count) {
    return '$count अपठित मैसेज';
  }

  @override
  String get msgYouPrefix => 'आप';

  @override
  String msgYou(String name) {
    return '$name (आप)';
  }

  @override
  String get msgOpening => 'चैट खुल रही है…';

  @override
  String get msgPickChat => 'कोई चैट चुनें';

  @override
  String get msgPickChatHint =>
      'डॉक्टर, क्लिनिक और सेवा देने वालों से आपकी बातचीत यहाँ खुलेगी।';

  @override
  String get msgPickChatHintPartner =>
      'पालतू-माता-पिता से आपकी बातचीत यहाँ खुलेगी।';

  @override
  String get msgNotFound => 'यह चैट अब उपलब्ध नहीं है।';

  @override
  String get msgPreviewPhoto => 'फ़ोटो';

  @override
  String get msgPreviewPdf => 'PDF दस्तावेज़';

  @override
  String get msgPreviewVoice => 'वॉइस नोट';

  @override
  String get msgClose => 'चैट बंद करें';

  @override
  String get msgChatInfo => 'चैट की जानकारी';

  @override
  String get msgCallMasked => 'कॉल करें (नंबर छिपा रहेगा)';

  @override
  String msgMaskedCallDemo(String name, String number) {
    return 'डेमो मोड में असली कॉल नहीं होती। असली ऐप में यह $name को छिपे हुए नंबर ($number) से कॉल करेगा, ताकि कोई किसी का असली नंबर न देखे।';
  }

  @override
  String get msgMaskedCallLive =>
      'कॉल छिपे हुए नंबर से जाती है, ताकि कोई किसी का असली नंबर न देखे।';

  @override
  String get msgMaskedInfo =>
      'PawSetu की चैट और कॉल में फ़ोन नंबर छिपे रहते हैं। भुगतान सिर्फ़ ऐप के अंदर करें।';

  @override
  String get msgMore => 'और विकल्प';

  @override
  String get msgSearchInChat => 'चैट में खोजें';

  @override
  String msgMatches(int count) {
    return '$count मिले';
  }

  @override
  String get msgMute => 'सूचनाएँ म्यूट करें';

  @override
  String get msgUnmute => 'सूचनाएँ चालू करें';

  @override
  String get msgMutedToast => 'चैट म्यूट हो गई';

  @override
  String get msgUnmutedToast => 'इस चैट की सूचनाएँ चालू';

  @override
  String get msgBlock => 'ब्लॉक करें';

  @override
  String get msgUnblock => 'अनब्लॉक करें';

  @override
  String msgBlockTitle(String name) {
    return '$name को ब्लॉक करें?';
  }

  @override
  String get msgBlockBody =>
      'जब तक आप अनब्लॉक नहीं करते, इस चैट में कोई मैसेज नहीं भेज पाएगा। आपकी बुकिंग पर असर नहीं पड़ेगा।';

  @override
  String get msgBlockedToast => 'ब्लॉक हो गया';

  @override
  String get msgUnblockedToast => 'अनब्लॉक हो गया';

  @override
  String get msgYouBlocked =>
      'आपने यह चैट ब्लॉक की है। मैसेज भेजने के लिए मेन्यू से अनब्लॉक करें।';

  @override
  String get msgBlockedByOther => 'यह चैट बंद है। आप यहाँ मैसेज नहीं भेज सकते।';

  @override
  String get msgReport => 'रिपोर्ट करें';

  @override
  String get msgReportTitle => 'इस चैट की रिपोर्ट करें';

  @override
  String get msgReportHint =>
      'PawSetu की टीम हर रिपोर्ट देखती है, आमतौर पर एक दिन में।';

  @override
  String get msgReasonSpam => 'स्पैम या विज्ञापन';

  @override
  String get msgReasonAbuse => 'अभद्र या अपमानजनक';

  @override
  String get msgReasonPayment => 'PawSetu के बाहर भुगतान करने को कहा';

  @override
  String get msgReasonFake => 'नकली प्रोफ़ाइल या धोखा';

  @override
  String get msgReasonOther => 'कुछ और';

  @override
  String get msgReportDetails => 'जानकारी (वैकल्पिक)';

  @override
  String get msgReportSend => 'रिपोर्ट भेजें';

  @override
  String get msgReportedToast => 'धन्यवाद। हम इसकी जाँच करेंगे।';

  @override
  String get msgGetHelp => 'मदद लें';

  @override
  String get msgTypingShort => 'लिख रहे हैं…';

  @override
  String msgTyping(String name) {
    return '$name लिख रहे हैं…';
  }

  @override
  String get msgTypeHint => 'मैसेज लिखें';

  @override
  String get msgSend => 'भेजें';

  @override
  String get msgAttach => 'फ़ोटो या PDF जोड़ें';

  @override
  String get msgAttachTitle => 'फ़ाइल भेजें';

  @override
  String get msgAttachPdf => 'PDF दस्तावेज़';

  @override
  String get msgAttachPdfHint => 'रिपोर्ट, पर्चे, प्रमाणपत्र (10 MB तक)';

  @override
  String get msgPdfTooBig => 'यह फ़ाइल 10 MB से बड़ी है। छोटी PDF भेजें।';

  @override
  String get msgSendFailed => 'भेज नहीं पाए। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get msgNumberHiddenToast =>
      'सबकी सुरक्षा के लिए चैट में फ़ोन नंबर छिपाए जाते हैं।';

  @override
  String get msgNumberHidden => 'नंबर छिपाया गया';

  @override
  String get msgPaymentWarnTitle => 'भुगतान सिर्फ़ PawSetu में करें';

  @override
  String get msgPaymentWarnBody =>
      'आपके मैसेज में भुगतान की जानकारी (UPI ID, कार्ड नंबर, OTP या PIN) लगती है। OTP या PIN कभी शेयर न करें। PawSetu के बाहर किए भुगतान सुरक्षित नहीं होते।';

  @override
  String get msgSendAnyway => 'फिर भी भेजें';

  @override
  String get msgSafetyNote =>
      'नंबर छिपे रहते हैं और भुगतान PawSetu के अंदर ही होते हैं। OTP या PIN कभी शेयर न करें।';

  @override
  String get msgRecordVoice => 'वॉइस नोट रिकॉर्ड करें';

  @override
  String msgRecording(String elapsed, String max) {
    return 'रिकॉर्डिंग $elapsed / $max';
  }

  @override
  String msgRecordingDemo(String elapsed) {
    return 'डेमो रिकॉर्डिंग $elapsed';
  }

  @override
  String get msgCancelRecording => 'रिकॉर्डिंग रद्द करें';

  @override
  String get msgSendVoice => 'वॉइस नोट भेजें';

  @override
  String get msgPlayVoice => 'वॉइस नोट चलाएँ';

  @override
  String get msgPause => 'रोकें';

  @override
  String get msgVoiceCantPlay => 'यह वॉइस नोट इस डिवाइस पर नहीं चल सकता।';

  @override
  String get msgMicUnavailableTitle => 'माइक्रोफ़ोन उपलब्ध नहीं';

  @override
  String get msgMicUnavailable =>
      'वॉइस नोट भेजने के लिए फ़ोन की सेटिंग में माइक्रोफ़ोन की अनुमति दें।';

  @override
  String get msgMicDemoBody =>
      'यहाँ माइक्रोफ़ोन उपलब्ध नहीं है। इसकी जगह एक छोटा डेमो वॉइस नोट भेजें?';

  @override
  String get msgRecordDemo => 'डेमो वॉइस नोट भेजें';

  @override
  String get msgSent => 'भेजा गया';

  @override
  String get msgRead => 'पढ़ा गया';

  @override
  String get msgYesterday => 'कल';

  @override
  String get msgDemoReply => 'डेमो जवाब';

  @override
  String get msgPdf => 'PDF';

  @override
  String get msgTapToOpen => 'खोलने के लिए टैप करें';

  @override
  String get msgFileCantOpen => 'यह फ़ाइल यहाँ नहीं खुल सकती।';

  @override
  String get msgSampleStamp => 'नमूना दस्तावेज़ · डेमो';

  @override
  String get msgSampleDocBody =>
      'यह डेमो चैट में शेयर किया गया नमूना दस्तावेज़ है।';

  @override
  String msgSysBookingChat(String pet, String when) {
    return '$when की $pet की बुकिंग के लिए चैट';
  }

  @override
  String get msgSysTvStarted => 'चैट परामर्श का अनुरोध भेजा गया';

  @override
  String get msgSysTvStartedVideo => 'वीडियो परामर्श का अनुरोध भेजा गया';

  @override
  String msgSysTvScheduled(String when) {
    return '$when के लिए परामर्श बुक हुआ';
  }

  @override
  String msgSysVetJoined(String name, String until) {
    return '$name जुड़ गए। चैट $until तक खुली रहेगी।';
  }

  @override
  String get msgSysTvEnded => 'परामर्श समाप्त हुआ';

  @override
  String msgSysCallEnded(String duration) {
    return 'वीडियो कॉल समाप्त · $duration';
  }

  @override
  String get msgYourPet => 'आपके पालतू';

  @override
  String demoReplyClinic(String pet) {
    return 'मैसेज के लिए धन्यवाद। क्लिनिक की टीम $pet की जानकारी देखकर जल्द जवाब देगी।';
  }

  @override
  String demoReplyVet(String pet) {
    return 'धन्यवाद, नोट कर लिया। आज $pet खाना-पानी कैसे ले रहा है?';
  }

  @override
  String demoReplyGroomer(String pet) {
    return 'ज़रूर! हम $pet का अच्छे से ध्यान रखेंगे। $pet जो शैम्पू इस्तेमाल करता है, वह साथ ले आएँ।';
  }

  @override
  String demoReplyWalker(String pet) {
    return 'समझ गया! मैं $pet को सड़क की छाँव वाली तरफ़ रखूँगा और फ़ोटो भेजूँगा।';
  }

  @override
  String demoReplyTrainer(String pet) {
    return 'बढ़िया सवाल। अगले सत्र में $pet के साथ यह अभ्यास करेंगे।';
  }

  @override
  String demoReplyBoarder(String pet) {
    return '$pet ठीक है और अच्छे से घुल-मिल रहा है। शाम को फ़ोटो भेजूँगी।';
  }

  @override
  String demoReplyOwner(String name) {
    return 'धन्यवाद! इससे बहुत मदद मिली। – $name';
  }

  @override
  String demoReplyOwnerVet(String name) {
    return 'धन्यवाद, डॉ. $name! मैं ऐसा ही करूँगा।';
  }

  @override
  String demoVetGreeting(String owner, String pet) {
    return 'नमस्ते $owner, मैं आ गया हूँ। आपने $pet के बारे में जो लिखा, मैंने पढ़ लिया। शुरुआत में कुछ सवाल: यह कब से है, और क्या $pet ठीक से खा-पी रहा है?';
  }

  @override
  String ntfNewMessage(String name) {
    return '$name का नया मैसेज';
  }

  @override
  String ntfTeleVetMessage(String name) {
    return 'टेली-वेट: $name का नया मैसेज';
  }

  @override
  String get tvHomeTitle => 'डॉक्टर से बात करें';

  @override
  String get tvHomeBody =>
      'पंजीकृत पशु-चिकित्सक से चैट या वीडियो पर बात करें, आमतौर पर कुछ ही मिनटों में।';

  @override
  String get tvStart => 'परामर्श शुरू करें';

  @override
  String get tvEmergencyNote =>
      'इमरजेंसी है? चैट का इंतज़ार न करें। पास के खुले क्लिनिक तक पहुँचने के लिए SOS दबाएँ।';

  @override
  String get tvOpenConsults => 'चालू परामर्श';

  @override
  String get tvPastConsults => 'पिछले परामर्श';

  @override
  String get tvPartnerHere => 'टेली-वेट अनुरोध आपके पोर्टल में हैं';

  @override
  String get tvPlanFree => 'आपका Free प्लान';

  @override
  String get tvPlanPlus => 'आपका Plus प्लान';

  @override
  String get tvFreeChip => 'Free';

  @override
  String tvLinePerMonth(int limit, int used) {
    return 'महीने में $limit परामर्श · $used इस्तेमाल हुए';
  }

  @override
  String get tvLineUnlimited => 'असीमित परामर्श';

  @override
  String tvLineMessages(int messages, int words) {
    return '$messages मैसेज तक, हर मैसेज में $words शब्द';
  }

  @override
  String tvLineHours(int hours) {
    return 'डॉक्टर के जुड़ने के बाद चैट $hours घंटे खुली रहती है';
  }

  @override
  String get tvLineVideo => 'वीडियो कॉल शामिल, 10% छूट के साथ';

  @override
  String get tvLineNoVideo => 'वीडियो कॉल के लिए Plus चाहिए';

  @override
  String get tvMonthlyUsedTitle =>
      'आपने इस महीने का मुफ़्त परामर्श इस्तेमाल कर लिया';

  @override
  String tvMonthlyUsed(String date) {
    return 'अगला मुफ़्त परामर्श $date को मिलेगा। Plus के साथ असीमित चैट और वीडियो कॉल मिलते हैं।';
  }

  @override
  String get tvPlusPromptTitle => 'डॉक्टर के साथ ज़्यादा समय';

  @override
  String get tvPlusHint =>
      'Plus में 300 शब्दों के 100 मैसेज तक, 72 घंटे की चैट और वीडियो कॉल मिलते हैं।';

  @override
  String get tvVideoPlusTitle => 'वीडियो कॉल Plus में शामिल हैं';

  @override
  String get tvStatusQueuedShort => 'इंतज़ार में';

  @override
  String get tvStatusActiveShort => 'चालू';

  @override
  String get tvStatusEndedShort => 'समाप्त';

  @override
  String get tvConsentTitle => 'शुरू करने से पहले';

  @override
  String get tvConsentIntro =>
      'ऑनलाइन परामर्श भारतीय पशु-चिकित्सा परिषद के दिशानिर्देशों के अनुसार होते हैं। कृपया पढ़ें और सहमति दें:';

  @override
  String get tvConsent1 =>
      'डॉक्टर आपके बताए और दिखाए के आधार पर सलाह देते हैं। यह पूरी शारीरिक जाँच नहीं है।';

  @override
  String get tvConsent2 =>
      'PawSetu पर हर डॉक्टर राज्य पशु-चिकित्सा परिषद में पंजीकृत है। आपको उनका रजिस्ट्रेशन नंबर दिखेगा।';

  @override
  String get tvConsent3 =>
      'अगर पालतू को जाँच या टेस्ट की ज़रूरत हो, तो डॉक्टर क्लिनिक आने को कह सकते हैं।';

  @override
  String get tvConsent4 =>
      'टेली-वेट इमरजेंसी के लिए नहीं है। सांस की तकलीफ़, बेहोशी, दौरे, ज़हर या ज़्यादा ख़ून बहने पर SOS दबाएँ।';

  @override
  String get tvConsent5 =>
      'पर्चा तभी दिया जाता है जब डॉक्टर को सुरक्षित लगे, और कुछ दवाओं के लिए क्लिनिक जाना ज़रूरी होता है।';

  @override
  String get tvConsent6 =>
      'आपकी चैट, फ़ोटो और पालतू के रिकॉर्ड सिर्फ़ इलाज करने वाले डॉक्टर से शेयर होते हैं।';

  @override
  String get tvConsentAgree => 'मैंने पढ़ लिया है और सहमत हूँ';

  @override
  String get tvConsentContinue => 'आगे बढ़ें';

  @override
  String get tvStepPet => 'पालतू';

  @override
  String get tvStepProblem => 'समस्या';

  @override
  String get tvStepHow => 'डॉक्टर';

  @override
  String get tvWhichPet => 'यह किस पालतू के बारे में है?';

  @override
  String get tvNoPet => 'डॉक्टर से बात करने के लिए पहले पालतू जोड़ें।';

  @override
  String tvDescribe(String pet) {
    return '$pet को क्या हो रहा है?';
  }

  @override
  String get tvDescribeHint =>
      'कब शुरू हुआ, आपने क्या देखा, खाना-पीना कैसा है, कुछ ग़लत तो नहीं खाया';

  @override
  String get tvAddPhotos => 'फ़ोटो जोड़ें';

  @override
  String get tvPhotosHint =>
      'समस्या की साफ़ फ़ोटो (घाव, दाने, मल या उल्टी) डॉक्टर की बहुत मदद करती हैं।';

  @override
  String get tvContinueToVet => 'बात करने का तरीका चुनें';

  @override
  String get tvChatNow => 'अभी चैट करें';

  @override
  String get tvChatNowHint =>
      'अगले उपलब्ध डॉक्टर जुड़ेंगे, आमतौर पर कुछ मिनट में';

  @override
  String get tvVideoNow => 'अभी वीडियो कॉल';

  @override
  String get tvVideoNowHint => 'वीडियो कॉल पर डॉक्टर को पालतू दिखाएँ';

  @override
  String get tvVideoPlusOnly => 'PawSetu Plus के साथ उपलब्ध';

  @override
  String get tvChooseVet => 'डॉक्टर चुनें';

  @override
  String get tvChooseVetHint =>
      'भाषा और अनुभव के हिसाब से डॉक्टर चुनें, अभी या आज बाद में';

  @override
  String get tvModeChat => 'चैट';

  @override
  String get tvModeVideo => 'वीडियो';

  @override
  String tvVideoFee(String amount) {
    return 'वीडियो $amount';
  }

  @override
  String get tvWhen => 'कब';

  @override
  String get tvNow => 'अभी';

  @override
  String get tvTomorrow => 'कल';

  @override
  String get tvSummary => 'सारांश';

  @override
  String get tvSummaryPet => 'पालतू';

  @override
  String get tvSummaryType => 'तरीका';

  @override
  String get tvSummaryVet => 'डॉक्टर';

  @override
  String get tvNextAvailable => 'अगले उपलब्ध डॉक्टर';

  @override
  String get tvFee => 'फ़ीस';

  @override
  String get tvIncluded => 'आपके प्लान में शामिल';

  @override
  String get tvVideoFeeLabel => 'वीडियो परामर्श';

  @override
  String tvPlusDiscount(int percent) {
    return 'Plus छूट ($percent%)';
  }

  @override
  String tvChatRules(int messages, int words, int hours) {
    return '$words शब्दों के $messages मैसेज तक। डॉक्टर के जुड़ने के बाद चैट $hours घंटे खुली रहती है।';
  }

  @override
  String get tvStartChat => 'चैट शुरू करें';

  @override
  String get tvStartVideo => 'वीडियो कॉल शुरू करें';

  @override
  String tvPayAndStart(String amount) {
    return '$amount भरें और शुरू करें';
  }

  @override
  String tvPayDescription(String pet) {
    return '$pet के लिए वीडियो परामर्श';
  }

  @override
  String tvFindingVet(String pet) {
    return '$pet के लिए डॉक्टर ढूँढ रहे हैं…';
  }

  @override
  String get tvFindingVetHint =>
      'ज़्यादातर चैट कुछ मिनट में ली जाती हैं। हम आपको सूचित करेंगे।';

  @override
  String get tvFindingVetShort => 'डॉक्टर ढूँढ रहे हैं…';

  @override
  String tvScheduledTitle(String when) {
    return '$when पर परामर्श';
  }

  @override
  String get tvScheduledHint =>
      'डॉक्टर इसी समय जुड़ेंगे। तब तक आप और जानकारी जोड़ सकते हैं।';

  @override
  String get tvStatusQueued => 'डॉक्टर का इंतज़ार';

  @override
  String get tvStatusActive => 'परामर्श चालू है';

  @override
  String get tvStatusEnded => 'परामर्श समाप्त';

  @override
  String tvOpenUntil(String time) {
    return '$time तक खुला';
  }

  @override
  String tvMessagesLeft(int count) {
    return '$count मैसेज बाकी';
  }

  @override
  String get tvPriority => 'प्राथमिकता (Plus)';

  @override
  String get tvVideoCall => 'वीडियो कॉल';

  @override
  String get tvClosedShort => 'चैट बंद';

  @override
  String tvEndedWith(String vet) {
    return 'समाप्त · $vet';
  }

  @override
  String tvVetBarTitle(String pet, String owner) {
    return '$pet · $owner';
  }

  @override
  String get tvRate => 'इस परामर्श को रेट करें';

  @override
  String tvRateTitle(String vet) {
    return '$vet के साथ आपकी बातचीत कैसी रही?';
  }

  @override
  String get tvRateComment => 'कुछ और कहना है? (वैकल्पिक)';

  @override
  String get tvRateSubmit => 'रेटिंग भेजें';

  @override
  String get tvRateThanks => 'रेटिंग के लिए धन्यवाद!';

  @override
  String tvStars(int count) {
    return '$count स्टार';
  }

  @override
  String tvAllowanceLine(int words, int max, int left) {
    return '$words/$max शब्द · $left मैसेज बाकी';
  }

  @override
  String tvWordsOver(int words, int max) {
    return '$words/$max शब्द। कृपया मैसेज छोटा करें।';
  }

  @override
  String tvWordsTitle(int max) {
    return 'मैसेज में $max शब्द तक हो सकते हैं';
  }

  @override
  String tvWordsBody(int words, int max) {
    return 'आपके मैसेज में $words शब्द हैं, सीमा $max है। इसे छोटे मैसेज में बाँटें या ज़रूरी बातें ही रखें; डॉक्टर और पूछ सकते हैं।';
  }

  @override
  String get tvEditMessage => 'मैसेज बदलें';

  @override
  String tvNoMessagesTitle(int count) {
    return 'आपने सभी $count मैसेज इस्तेमाल कर लिए';
  }

  @override
  String get tvNoMessagesBody =>
      'डॉक्टर अब भी जवाब और पर्चा भेज सकते हैं। और सवालों के लिए नया परामर्श शुरू करें।';

  @override
  String get tvClosedTitle => 'यह चैट बंद हो गई है';

  @override
  String tvClosedBanner(int hours) {
    return 'डॉक्टर के जुड़ने के बाद चैट $hours घंटे खुली रहती है। और मदद चाहिए तो नया परामर्श शुरू करें।';
  }

  @override
  String get tvEndedTitle => 'परामर्श समाप्त हुआ';

  @override
  String get tvEndedBanner =>
      'डॉक्टर ने यह परामर्श समाप्त कर दिया। आपकी चैट और पर्चा पालतू के रिकॉर्ड में रहेंगे।';

  @override
  String get tvProblemLabel => 'बताई गई समस्या';

  @override
  String get tvBookVisit => 'क्लिनिक विज़िट बुक करें';

  @override
  String tvRecVisitMsg(String name) {
    return '$name जाँच के लिए क्लिनिक जाने की सलाह देते हैं।';
  }

  @override
  String tvRecEmergencyMsg(String name) {
    return '$name के अनुसार अभी इमरजेंसी इलाज ज़रूरी है। पास के खुले क्लिनिक तक पहुँचने के लिए SOS दबाएँ।';
  }

  @override
  String get tvConnecting => 'कनेक्ट हो रहा है…';

  @override
  String get tvWaitingVetJoin => 'डॉक्टर के जुड़ने का इंतज़ार…';

  @override
  String get tvDemoCall => 'डेमो कॉल';

  @override
  String get tvGoodNetwork => 'अच्छा कनेक्शन';

  @override
  String get tvWeakNetwork => 'कमज़ोर कनेक्शन';

  @override
  String tvRemoteVideo(String name) {
    return '$name का वीडियो';
  }

  @override
  String get tvSelfView => 'आपका कैमरा';

  @override
  String get tvCameraOff => 'कैमरा बंद है';

  @override
  String get tvCameraOffAction => 'कैमरा बंद करें';

  @override
  String get tvCameraOnAction => 'कैमरा चालू करें';

  @override
  String get tvMute => 'म्यूट करें';

  @override
  String get tvUnmute => 'अनम्यूट करें';

  @override
  String get tvSpeakerOn => 'स्पीकर चालू';

  @override
  String get tvSpeakerOff => 'स्पीकर बंद';

  @override
  String get tvSwitchCamera => 'कैमरा बदलें';

  @override
  String get tvFrontCamera => 'सामने का कैमरा';

  @override
  String get tvBackCamera => 'पीछे का कैमरा';

  @override
  String get tvEndCall => 'कॉल समाप्त करें';

  @override
  String tvCallEndedToast(String duration) {
    return 'कॉल समाप्त · $duration';
  }

  @override
  String get tvCallFailed => 'कॉल कनेक्ट नहीं हो सकी।';

  @override
  String get tvCallLiveLater =>
      'असली वीडियो कॉल PawSetu के लाइव संस्करण में आएँगी। तब तक डॉक्टर से चैट जारी रखें।';

  @override
  String get tvQueueTitle => 'टेली-वेट कतार';

  @override
  String get tvQueueHint =>
      'Plus सदस्य और ज़रूरी केस पहले आते हैं। चैट शुरू करने के लिए अनुरोध स्वीकार करें।';

  @override
  String get tvQueueEmpty => 'अभी कोई इंतज़ार में नहीं है।';

  @override
  String get tvWaiting => 'इंतज़ार में';

  @override
  String get tvInProgress => 'चल रहे हैं';

  @override
  String get tvDoneToday => 'आज पूरे हुए';

  @override
  String get tvPrescriptionsWritten => 'पर्चे';

  @override
  String get tvNoActive => 'कोई चालू परामर्श नहीं।';

  @override
  String get tvRecent => 'हाल के';

  @override
  String get tvUrgent => 'ज़रूरी';

  @override
  String get tvAskedForYou => 'आपको चुना';

  @override
  String tvWaitingFor(int minutes) {
    return '$minutes मिनट से इंतज़ार';
  }

  @override
  String tvScheduledFor(String when) {
    return '$when के लिए बुक';
  }

  @override
  String get tvAccept => 'स्वीकार करें';

  @override
  String get tvView => 'देखें';

  @override
  String tvAcceptHint(String pet) {
    return '$pet के बारे में चैट शुरू करने के लिए स्वीकार करें। पालतू-माता-पिता को सूचना मिलेगी।';
  }

  @override
  String get tvTabChat => 'चैट';

  @override
  String get tvTabHistory => 'इतिहास';

  @override
  String get tvTabTools => 'नोट्स और टूल्स';

  @override
  String get tvOpenVetTools => 'डॉक्टर टूल्स खोलें';

  @override
  String tvUrgentSign(String sign) {
    return 'ज़रूरी लक्षण: $sign';
  }

  @override
  String get tvFreeContext =>
      'Free प्लान: आपको बुनियादी प्रोफ़ाइल दिखती है। Plus सदस्य पूरा स्वास्थ्य इतिहास शेयर करते हैं।';

  @override
  String get tvTemperament => 'स्वभाव';

  @override
  String get tvRecentHealth => 'हाल के स्वास्थ्य रिकॉर्ड';

  @override
  String get tvNone => 'कोई नहीं';

  @override
  String get tvPrivateNotes => 'निजी नोट्स';

  @override
  String get tvPrivateNotesHint => 'ये नोट्स सिर्फ़ आप देख सकते हैं।';

  @override
  String get tvNotesPlaceholder => 'जाँच के नतीजे, संभावित बीमारियाँ, योजना…';

  @override
  String get tvRecommend => 'सलाह दें';

  @override
  String get tvRecVisit => 'क्लिनिक विज़िट';

  @override
  String get tvRecEmergency => 'इमरजेंसी इलाज';

  @override
  String tvRecVisitConfirm(String name) {
    return '$name को जाँच के लिए पालतू को क्लिनिक लाने को कहें?';
  }

  @override
  String tvRecEmergencyConfirm(String name) {
    return '$name को बताएँ कि अभी इमरजेंसी इलाज ज़रूरी है? उन्हें SOS बटन दिखेगा।';
  }

  @override
  String get tvRecSent => 'सलाह भेजी गई';

  @override
  String get tvRecDoneVisit => 'क्लिनिक विज़िट की सलाह दी गई';

  @override
  String get tvRecDoneEmergency => 'इमरजेंसी इलाज की सलाह दी गई';

  @override
  String get tvSend => 'भेजें';

  @override
  String get tvEnd => 'परामर्श समाप्त करें';

  @override
  String get tvEndTitle => 'यह परामर्श समाप्त करें?';

  @override
  String get tvEndBody =>
      'पालतू-माता-पिता अब मैसेज नहीं भेज पाएँगे। चैट और पर्चा उनके रिकॉर्ड में रहेंगे।';

  @override
  String get tvEndBodyNoRx =>
      'आपने पर्चा नहीं लिखा है। फिर भी समाप्त करें? पालतू-माता-पिता अब मैसेज नहीं भेज पाएँगे।';

  @override
  String get tvEndedToast => 'परामर्श समाप्त हुआ';

  @override
  String get tvVetSafetyNote =>
      'जाँच या टेस्ट ज़रूरी हों तो क्लिनिक बुलाएँ। निजी फ़ोन नंबर शेयर न करें।';

  @override
  String get rxWrite => 'पर्चा लिखें';

  @override
  String rxTitleOf(String pet) {
    return '$pet के लिए पर्चा';
  }

  @override
  String get rxTitle => 'ई-पर्चा';

  @override
  String rxRegNo(String number) {
    return 'रजि. नं. $number';
  }

  @override
  String get rxDiagnosis => 'निदान या आकलन';

  @override
  String get rxDiagnosisHint => 'जैसे हल्का गैस्ट्राइटिस';

  @override
  String get rxMedicines => 'दवाएँ';

  @override
  String rxMedicineN(int n) {
    return 'दवा $n';
  }

  @override
  String get rxMedicine => 'दवा और ताक़त';

  @override
  String get rxMedicineHint => 'जैसे Ondansetron 4 mg गोली';

  @override
  String get rxDoseHint => 'खुराक, जैसे आधी गोली';

  @override
  String get rxFreqOnce => 'दिन में एक बार';

  @override
  String get rxFreqTwice => 'दिन में दो बार';

  @override
  String get rxFreqThrice => 'दिन में तीन बार';

  @override
  String get rxFreqNeeded => 'ज़रूरत पड़ने पर';

  @override
  String get rxDuration => 'अवधि';

  @override
  String rxDays(int count) {
    return '$count दिन';
  }

  @override
  String get rxInstructions => 'निर्देश';

  @override
  String get rxAfterFood => 'खाने के बाद';

  @override
  String get rxBeforeFood => 'खाने से पहले';

  @override
  String get rxApplyThin => 'पतली परत लगाएँ';

  @override
  String get rxAddMedicine => 'दवा जोड़ें';

  @override
  String get rxNeedMedicine => 'कम से कम एक दवा जोड़ें।';

  @override
  String get rxAdvice => 'पालतू-माता-पिता के लिए सलाह';

  @override
  String get rxAdviceHint =>
      'खाना, आराम, किन बातों पर नज़र रखें, कब दोबारा आएँ';

  @override
  String get rxAddFollowUp => 'फ़ॉलो-अप की तारीख़ जोड़ें';

  @override
  String rxFollowUpOn(String date) {
    return '$date को फ़ॉलो-अप';
  }

  @override
  String get rxFollowUp => 'फ़ॉलो-अप';

  @override
  String get rxNoFollowUp => 'फ़ॉलो-अप की ज़रूरत नहीं';

  @override
  String rxWhereItGoes(String pet) {
    return 'यह $pet के स्वास्थ्य रिकॉर्ड और पालतू-माता-पिता के वॉल्ट में जाएगा, फ़ॉलो-अप के रिमाइंडर के साथ।';
  }

  @override
  String get rxPreview => 'पूर्वावलोकन';

  @override
  String get rxSignTitle => 'हस्ताक्षर करके भेजें?';

  @override
  String rxSignBody(String owner, String pet) {
    return 'यह पर्चा आपके रजिस्ट्रेशन नंबर के साथ डिजिटल रूप से हस्ताक्षरित होकर $pet के लिए $owner को भेजा जाएगा।';
  }

  @override
  String get rxSignSend => 'हस्ताक्षर करके भेजें';

  @override
  String rxSentToast(String owner, String pet) {
    return '$pet के लिए पर्चा $owner को भेजा गया';
  }

  @override
  String rxSaved(String pet) {
    return '$pet के स्वास्थ्य रिकॉर्ड में सेव हुआ';
  }

  @override
  String rxCardTitle(String vet) {
    return '$vet का पर्चा';
  }

  @override
  String get rxView => 'पर्चा देखें';

  @override
  String get rxSentPreview => 'पर्चा';

  @override
  String get rxPatient => 'मरीज़';

  @override
  String get rxPetName => 'नाम';

  @override
  String get rxSpeciesBreed => 'प्रजाति और नस्ल';

  @override
  String rxSignedDigitally(String when) {
    return '$when को डिजिटल हस्ताक्षर किए गए';
  }

  @override
  String get rxFooter =>
      'PawSetu ई-पर्चा · डेमो डेटा · डॉक्टर के रजिस्ट्रेशन नंबर के साथ ही मान्य';

  @override
  String rxDocTitle(String pet, String date) {
    return '$pet का पर्चा, $date';
  }

  @override
  String rxEventTitle(String vet) {
    return '$vet के साथ टेली-वेट परामर्श';
  }

  @override
  String rxEventNotes(String medicines) {
    return 'दी गई दवाएँ: $medicines';
  }

  @override
  String rxFollowUpReminder(String pet, String vet) {
    return '$vet के साथ $pet का फ़ॉलो-अप';
  }

  @override
  String ntfTeleVetRequest(String pet, String owner) {
    return 'नया टेली-वेट अनुरोध: $pet ($owner)';
  }

  @override
  String ntfVetJoined(String vet, String pet) {
    return '$vet $pet वाली आपकी चैट में जुड़ गए';
  }

  @override
  String ntfConsultEnded(String pet) {
    return '$pet का टेली-वेट परामर्श समाप्त हुआ';
  }

  @override
  String ntfPrescription(String vet, String pet) {
    return '$vet ने $pet के लिए पर्चा भेजा';
  }
}
