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
}
