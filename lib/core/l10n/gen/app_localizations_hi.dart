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

  @override
  String get albumPhotos => 'फ़ोटो';

  @override
  String get albumTimeline => 'टाइमलाइन';

  @override
  String get albumAlbums => 'एल्बम';

  @override
  String get albumFavourites => 'पसंदीदा';

  @override
  String get albumAdd => 'फ़ोटो या वीडियो जोड़ें';

  @override
  String albumAddTitle(String pet) {
    return '$pet के एल्बम में जोड़ें';
  }

  @override
  String albumAddFirst(String pet) {
    return '$pet की पहली फ़ोटो जोड़ें';
  }

  @override
  String get albumChoosePhotos => 'फ़ोटो चुनें';

  @override
  String get albumChooseVideo => 'वीडियो चुनें';

  @override
  String get albumRecordVideo => 'वीडियो रिकॉर्ड करें';

  @override
  String get albumCaption => 'कैप्शन';

  @override
  String get albumCaptionHint => 'इस पल में क्या हो रहा है?';

  @override
  String get albumDateTaken => 'तारीख़';

  @override
  String get albumMilestone => 'ख़ास पल';

  @override
  String get albumNoMilestone => 'कोई ख़ास पल नहीं';

  @override
  String get albumAddMilestone => 'ख़ास पल के रूप में जोड़ें';

  @override
  String get albumMilestoneTitle => 'ख़ास पल का नाम';

  @override
  String get albumMilestoneTitleHint => 'जैसे पहली बार तैरना';

  @override
  String get albumMsGotcha => 'घर आने का दिन';

  @override
  String get albumMsFirstWalk => 'पहली सैर';

  @override
  String get albumMsFirstVaccine => 'पहला टीका';

  @override
  String get albumMsBirthday => 'जन्मदिन';

  @override
  String get albumMsCustom => 'ख़ास पल';

  @override
  String get albumNewAlbum => 'नया एल्बम';

  @override
  String get albumAlbumName => 'एल्बम का नाम';

  @override
  String get albumUploading => 'आपकी यादें जोड़ रहे हैं…';

  @override
  String albumPhotosAdded(int count) {
    return '$count यादें जोड़ी गईं';
  }

  @override
  String albumSaved(String pet) {
    return '$pet के एल्बम में सेव हुआ';
  }

  @override
  String albumAddedToAlbum(String album) {
    return '$album में जोड़ा गया';
  }

  @override
  String get albumStorageNote =>
      'फ़ोटो और वीडियो आपके प्लान की स्टोरेज इस्तेमाल करते हैं। Free में 1 मिनट तक, Plus में 3 मिनट तक के वीडियो।';

  @override
  String albumVideoMaxSec(int seconds) {
    return '$seconds सेकंड तक के वीडियो';
  }

  @override
  String get albumVideoTooLongTitle => 'यह वीडियो बहुत लंबा है';

  @override
  String albumVideoTooLong(int seconds, int limit) {
    return 'यह $seconds सेकंड का है; आपका प्लान $limit सेकंड तक की अनुमति देता है।';
  }

  @override
  String get albumVideoPlusBody =>
      'इसे फ़ोन पर छोटा करें, या PawSetu Plus से 3 मिनट तक के वीडियो पाएँ।';

  @override
  String get albumEmptyTitle => 'अभी कोई यादें नहीं';

  @override
  String albumEmptyBody(String pet) {
    return '$pet की फ़ोटो और वीडियो जोड़ें। ये महीने के हिसाब से बँटेंगे और ख़ास पल टाइमलाइन पर दिखेंगे।';
  }

  @override
  String albumMonthCount(int count) {
    return '$count यादें';
  }

  @override
  String get albumOnThisDay => 'आज के दिन';

  @override
  String get albumLatestMemory => 'ताज़ा याद';

  @override
  String albumOfPet(String pet) {
    return '$pet के साथ एक पल';
  }

  @override
  String get albumSeeAlbum => 'एल्बम देखें';

  @override
  String albumYearsAgo(int count) {
    return '$count साल पहले';
  }

  @override
  String albumTimelineBorn(String pet) {
    return '$pet का जन्म';
  }

  @override
  String albumTimelineEmpty(String pet) {
    return 'फ़ोटो जोड़ते समय ख़ास पल चुनें, $pet की कहानी यहाँ दिखेगी।';
  }

  @override
  String get albumCelebrate => 'जश्न मनाएँ';

  @override
  String get albumBadges => 'ख़ास पलों के बैज';

  @override
  String get albumBadgeLocked => 'अभी नहीं';

  @override
  String get albumNoAlbums => 'अभी कोई एल्बम नहीं';

  @override
  String get albumNoAlbumsBody =>
      'यादों को एल्बम में रखें, जैसे \"गोवा ट्रिप\" या \"पहला साल\"।';

  @override
  String get albumNoFavourites => 'अभी कोई पसंदीदा नहीं';

  @override
  String get albumNoFavouritesBody =>
      'किसी फ़ोटो पर दिल दबाएँ, वह यहाँ दिखेगी।';

  @override
  String albumChooseForAlbum(String album) {
    return '$album के लिए यादें चुनें';
  }

  @override
  String albumItemsSelected(int count) {
    return '$count चुने गए';
  }

  @override
  String get albumRenameAlbum => 'एल्बम का नाम बदलें';

  @override
  String get albumDeleteAlbum => 'एल्बम हटाएँ';

  @override
  String albumDeleteAlbumBody(String pet) {
    return 'फ़ोटो $pet के एल्बम में रहेंगी। सिर्फ़ यह समूह हटेगा।';
  }

  @override
  String get albumRemoveFromAlbum => 'एल्बम से हटाएँ';

  @override
  String get albumVideo => 'वीडियो';

  @override
  String albumOfCount(int index, int total) {
    return '$total में से $index';
  }

  @override
  String get albumClose => 'बंद करें';

  @override
  String get albumPrevious => 'पिछला';

  @override
  String get albumFavourite => 'पसंदीदा में जोड़ें';

  @override
  String get albumUnfavourite => 'पसंदीदा से हटाएँ';

  @override
  String get albumEditCaption => 'कैप्शन बदलें';

  @override
  String get albumAddToAlbum => 'एल्बम में जोड़ें';

  @override
  String get albumShare => 'शेयर करें';

  @override
  String get albumDelete => 'हटाएँ';

  @override
  String get albumDeleteQ => 'यह याद हटाएँ?';

  @override
  String albumDeleteBody(String pet) {
    return 'यह परिवार के सभी लोगों के लिए $pet के एल्बम से हट जाएगी।';
  }

  @override
  String get albumDeleted => 'याद हटा दी गई';

  @override
  String albumAddedBy(String name) {
    return '$name ने जोड़ा';
  }

  @override
  String get albumPlay => 'चलाएँ';

  @override
  String get albumPause => 'रोकें';

  @override
  String get albumVideoFailed => 'यह वीडियो यहाँ नहीं चल सकता।';

  @override
  String get albumDemoVideo => 'डेमो वीडियो: असली फ़ाइल की जगह नमूना क्लिप।';

  @override
  String get albumShareTitle => 'यादें शेयर करें';

  @override
  String get albumShareBody =>
      'WhatsApp या किसी भी ऐप पर भेजें, या परिवार के लिए निजी लिंक बनाएँ।';

  @override
  String get albumShareToApps => 'ऐप्स पर शेयर करें';

  @override
  String get albumShareFailed => 'शेयर नहीं हो पाया। फिर कोशिश करें।';

  @override
  String get albumWatermark => 'PawSetu वॉटरमार्क लगाएँ';

  @override
  String get albumWatermarkPhotosOnly =>
      'सिर्फ़ फ़ोटो पर; वीडियो जैसे हैं वैसे शेयर होंगे।';

  @override
  String get albumWatermarkText => 'PawSetu से बना';

  @override
  String get albumFamilyLink => 'परिवार के लिए निजी लिंक';

  @override
  String albumFamilyLinkBody(String pet) {
    return 'लिंक वाला कोई भी $pet की ये यादें लिंक की अवधि तक देख सकता है। आप इसे कभी भी बंद कर सकते हैं।';
  }

  @override
  String get albumFamilyLinkWhich => 'क्या शेयर करें';

  @override
  String get albumWholeAlbum => 'पूरा एल्बम';

  @override
  String albumFamilyLinkText(String pet, String url) {
    return 'PawSetu पर $pet की फ़ोटो: $url';
  }

  @override
  String albumSharedBy(String owner, String pet) {
    return '$owner ने $pet की यादें शेयर कीं';
  }

  @override
  String get albumBirthdayScreenTitle => 'जन्मदिन';

  @override
  String albumBirthdayToday(String pet) {
    return 'जन्मदिन मुबारक हो, $pet!';
  }

  @override
  String albumBirthdayIn(int days, String pet, int age) {
    return '$pet $days दिन में $age साल का होगा';
  }

  @override
  String albumBirthdaySubtitle(int age, String pet) {
    return '$pet आज $age साल का हो गया';
  }

  @override
  String albumBirthdayWishes(String pet) {
    return '$pet को इस साल ढेर सारी सैर, ट्रीट और प्यार की शुभकामनाएँ!';
  }

  @override
  String get albumBirthdayMemories => 'इस साल की यादें';

  @override
  String get albumBirthdayAddPhoto => 'जन्मदिन की फ़ोटो जोड़ें';

  @override
  String albumBirthdayReminder(String pet) {
    return '$pet के जन्मदिन से पहले याद दिलाएँ';
  }

  @override
  String albumBirthdayReminderTitle(String pet) {
    return '$pet का जन्मदिन आने वाला है';
  }

  @override
  String get albumBirthdayReminderOn => 'जन्मदिन रिमाइंडर चालू';

  @override
  String albumNoBirthday(String pet) {
    return 'यहाँ जश्न मनाने के लिए $pet का जन्मदिन जोड़ें।';
  }

  @override
  String get vaultSetupTitle => 'अपना वॉल्ट सुरक्षित करें';

  @override
  String get vaultSetupBody =>
      '4 से 6 अंकों का PIN चुनें। वॉल्ट खोलते समय हर बार यह डालना होगा।';

  @override
  String get vaultSetupBodyBio =>
      'बैकअप के लिए 4 से 6 अंकों का PIN चुनें। फिर आप फ़िंगरप्रिंट या चेहरे से खोल सकेंगे।';

  @override
  String get vaultChoosePin => 'PIN चुनें';

  @override
  String get vaultConfirmPin => 'PIN फिर से डालें';

  @override
  String get vaultCurrentPin => 'मौजूदा PIN';

  @override
  String get vaultSetPinButton => 'PIN सेट करें';

  @override
  String get vaultPinMismatch => 'PIN मेल नहीं खाते। फिर कोशिश करें।';

  @override
  String get vaultPinWeak =>
      'यह PIN आसानी से पता चल सकता है। 1234 या एक जैसे अंक न रखें।';

  @override
  String get vaultPinSet => 'वॉल्ट PIN सेट हो गया';

  @override
  String get vaultPinChanged => 'PIN बदल गया';

  @override
  String get vaultChangePin => 'PIN बदलें';

  @override
  String vaultPinDigits(int count) {
    return '$count अंक डाले गए';
  }

  @override
  String get vaultPinBackspace => 'आख़िरी अंक हटाएँ';

  @override
  String get vaultLockedTitle => 'वॉल्ट लॉक है';

  @override
  String get vaultLockedBody =>
      'आपके पालतू के दस्तावेज़ सुरक्षित हैं। आगे बढ़ने के लिए अनलॉक करें।';

  @override
  String get vaultUnlock => 'अनलॉक करें';

  @override
  String get vaultUseBiometrics => 'फ़िंगरप्रिंट या चेहरा इस्तेमाल करें';

  @override
  String get vaultBiometricReason => 'अपना PawSetu दस्तावेज़ वॉल्ट खोलें';

  @override
  String get vaultBiometricsToggle => 'फ़िंगरप्रिंट या चेहरे से खोलें';

  @override
  String get vaultWrongPin => 'ग़लत PIN।';

  @override
  String vaultTriesLeft(int count) {
    return '$count कोशिशें बाकी।';
  }

  @override
  String vaultLockedOut(int seconds) {
    return 'बहुत ज़्यादा ग़लत कोशिशें। $seconds सेकंड बाद फिर कोशिश करें।';
  }

  @override
  String get vaultForgotPin => 'PIN भूल गए?';

  @override
  String get vaultForgotPinTitle => 'वॉल्ट PIN रीसेट करें';

  @override
  String get vaultForgotPinBody =>
      'यह साबित करने के लिए फिर से साइन इन करें कि यह आप ही हैं, फिर नया PIN चुनें। आपके दस्तावेज़ सुरक्षित रहेंगे।';

  @override
  String get vaultSignInAgain => 'फिर से साइन इन करें';

  @override
  String get vaultAutoLockNote =>
      '2 मिनट दूर रहने पर वॉल्ट अपने आप लॉक हो जाता है।';

  @override
  String get vaultLockNow => 'अभी लॉक करें';

  @override
  String get vaultLockSettings => 'वॉल्ट लॉक';

  @override
  String vaultOfPet(String pet) {
    return '$pet के दस्तावेज़';
  }

  @override
  String get vaultAllDocs => 'सभी दस्तावेज़';

  @override
  String vaultDocCount(int count) {
    return '$count दस्तावेज़';
  }

  @override
  String get vaultSearchHint => 'शीर्षक, टैग या डॉक्टर खोजें';

  @override
  String get vaultClearSearch => 'खोज हटाएँ';

  @override
  String get vaultNeedsAttention => 'ध्यान दें';

  @override
  String get vaultNeedsReview => 'जानकारी जाँचें';

  @override
  String vaultAddedOn(String date) {
    return '$date को जोड़ा';
  }

  @override
  String get vaultEmptyTitle => 'आपका वॉल्ट ख़ाली है';

  @override
  String get vaultEmptyBody =>
      'टीका प्रमाणपत्र, पर्चे, लैब रिपोर्ट और बीमा एक ही जगह सुरक्षित रखें।';

  @override
  String get vaultAddDocument => 'दस्तावेज़ जोड़ें';

  @override
  String get vaultStorageTitle => 'स्टोरेज';

  @override
  String vaultStorageUsed(String used, String limit) {
    return '$limit में से $used इस्तेमाल';
  }

  @override
  String vaultStorageSplit(String docs, String album) {
    return 'दस्तावेज़ $docs · एल्बम $album';
  }

  @override
  String get vaultStorageFullTitle => 'स्टोरेज भर गई';

  @override
  String vaultStorageFullBody(String used, String limit) {
    return 'आपने $limit में से $used इस्तेमाल कर लिया है। पुरानी फ़ाइलें हटाएँ या PawSetu Plus से 25 GB पाएँ।';
  }

  @override
  String vaultStorageFullBodyPlus(String used, String limit) {
    return 'आपने $limit में से $used इस्तेमाल कर लिया है। जगह बनाने के लिए पुरानी फ़ाइलें हटाएँ।';
  }

  @override
  String get vaultTooBig => 'यह फ़ाइल बहुत बड़ी है। 20 MB से छोटी फ़ाइल चुनें।';

  @override
  String get vaultTypeVaccination => 'टीका प्रमाणपत्र';

  @override
  String get vaultTypePrescription => 'पर्चा';

  @override
  String get vaultTypeLab => 'लैब रिपोर्ट';

  @override
  String get vaultTypeInsurance => 'बीमा';

  @override
  String get vaultTypeInvoice => 'बिल';

  @override
  String get vaultTypeLicence => 'नगर निगम लाइसेंस';

  @override
  String get vaultTypeAdoption => 'गोद लेने या ख़रीद के काग़ज़';

  @override
  String get vaultTypeTravel => 'यात्रा या स्वास्थ्य प्रमाणपत्र';

  @override
  String get vaultTypeOther => 'अन्य';

  @override
  String get vaultExpired => 'समाप्त';

  @override
  String get vaultExpiresSoon => 'जल्द समाप्त';

  @override
  String vaultExpiresOn(String date) {
    return '$date को समाप्त';
  }

  @override
  String vaultExpiredOn(String date) {
    return '$date को समाप्त हुआ';
  }

  @override
  String get vaultNoExpiry => 'कोई समाप्ति तारीख़ नहीं';

  @override
  String get vaultUploadTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get vaultForPet => 'किस पालतू के लिए?';

  @override
  String get vaultScanCamera => 'कैमरे से स्कैन करें';

  @override
  String get vaultScanCameraHint =>
      'किनारे अपने आप मिलते हैं; ज़रूरत हो तो कोने ठीक करें';

  @override
  String get vaultFromGallery => 'गैलरी से फ़ोटो';

  @override
  String get vaultFromPdf => 'PDF फ़ाइल';

  @override
  String get vaultPdfOnly => 'कृपया PDF फ़ाइल चुनें।';

  @override
  String get vaultTrySample =>
      'डेमो: ऑटो-रीड देखने के लिए नमूना दस्तावेज़ आज़माएँ';

  @override
  String get vaultSampleRabies => 'नमूना रेबीज़ प्रमाणपत्र';

  @override
  String get vaultSampleLab => 'नमूना ख़ून जाँच रिपोर्ट';

  @override
  String get vaultSampleInsurance => 'नमूना बीमा पॉलिसी';

  @override
  String get vaultUploading => 'सुरक्षित रूप से सेव हो रहा है…';

  @override
  String get vaultScanTitle => 'स्कैन ठीक करें';

  @override
  String get vaultScanHint => 'कोनों को पन्ने के किनारों तक खींचें।';

  @override
  String get vaultScanAuto =>
      'पन्ने के किनारे मिल गए। ज़रूरत हो तो कोने ठीक करें।';

  @override
  String get vaultScanBw => 'ब्लैक एंड व्हाइट (साफ़ अक्षर)';

  @override
  String get vaultScanCorner => 'कोने का हैंडल, ठीक करने के लिए खींचें';

  @override
  String get vaultUseScan => 'यह स्कैन इस्तेमाल करें';

  @override
  String get vaultPreviewFailed => 'इस फ़ाइल का पूर्वावलोकन नहीं दिखा सके।';

  @override
  String get vaultReading => 'दस्तावेज़ पढ़ रहे हैं…';

  @override
  String get vaultCheckDetails => 'जानकारी जाँचें';

  @override
  String get vaultCheckDetailsHint =>
      'ये जानकारी दस्तावेज़ से पढ़ी गई है। कृपया पुष्टि करें या सुधारें।';

  @override
  String get vaultAddDetails => 'जानकारी जोड़ें';

  @override
  String get vaultFoundTitle => 'हमें ये जानकारी मिली';

  @override
  String get vaultFoundBody =>
      'सेव करने से पहले हर जानकारी जाँचें। आपकी पुष्टि के बिना कुछ सेव नहीं होगा।';

  @override
  String get vaultNotFoundTitle => 'इसे पढ़ नहीं पाए';

  @override
  String get vaultNotFoundBody =>
      'जानकारी ख़ुद जोड़ें, या छोड़ें और बाद में जोड़ें।';

  @override
  String get vaultDemoReadNote =>
      'डेमो ऑटो-रीड: जानकारी नमूना दस्तावेज़ से आती है, आपकी फ़ाइल के असली स्कैन से नहीं।';

  @override
  String vaultPetMismatch(String docPet, String pet) {
    return 'दस्तावेज़ में $docPet लिखा है, पर आपने $pet चुना है। सेव करने से पहले पालतू जाँचें।';
  }

  @override
  String get vaultFieldDocType => 'दस्तावेज़ का प्रकार';

  @override
  String get vaultFieldTitle => 'शीर्षक';

  @override
  String get vaultFieldTags => 'टैग';

  @override
  String get vaultTagHint => 'जैसे रेबीज़, 2026';

  @override
  String get vaultAddTag => 'टैग जोड़ें';

  @override
  String vaultAddToHealth(String pet) {
    return '$pet के स्वास्थ्य रिकॉर्ड में जोड़ें';
  }

  @override
  String get vaultAddToHealthHint =>
      'टीका दर्ज होगा और अगली खुराक अपने आप तय हो जाएगी।';

  @override
  String get vaultVaccineNeeded =>
      'स्वास्थ्य रिकॉर्ड में सेव करने के लिए टीके का नाम और तारीख़ जोड़ें।';

  @override
  String get vaultTrackInsurance => 'इस पॉलिसी को बीमा में ट्रैक करें';

  @override
  String get vaultExpiryReminderNote =>
      'समाप्ति से 30 दिन पहले हम याद दिलाएँगे।';

  @override
  String get vaultSaveDetails => 'सेव करें';

  @override
  String get vaultSkipDetails => 'अभी छोड़ें';

  @override
  String get vaultSaved => 'वॉल्ट में सेव हुआ';

  @override
  String vaultSavedVaccine(String vaccine, String pet) {
    return '$pet का $vaccine दर्ज हुआ';
  }

  @override
  String vaultReminderTitle(String title, String pet) {
    return '$pet का $title जल्द समाप्त होगा';
  }

  @override
  String vaultTitleVaccineCert(String vaccine) {
    return '$vaccine प्रमाणपत्र';
  }

  @override
  String vaultTitlePolicy(String insurer) {
    return '$insurer पॉलिसी';
  }

  @override
  String get vaultDocDetails => 'दस्तावेज़ की जानकारी';

  @override
  String get vaultDetailsRead => 'जानकारी';

  @override
  String get vaultEditDetails => 'जानकारी बदलें';

  @override
  String vaultConfirmedBy(String name, String date) {
    return '$date को $name ने जाँचा';
  }

  @override
  String get vaultFieldPetName => 'पालतू का नाम';

  @override
  String get vaultFieldIssuedOn => 'जारी करने की तारीख़';

  @override
  String get vaultFieldExpiry => 'कब तक मान्य';

  @override
  String get vaultFieldIssuer => 'जारी करने वाले';

  @override
  String get vaultFieldVetReg => 'डॉक्टर रजि. नं.';

  @override
  String get vaultFieldReference => 'संदर्भ संख्या';

  @override
  String get vaultFieldTest => 'जाँच';

  @override
  String get vaultFieldAmount => 'राशि';

  @override
  String get vaultFileType => 'फ़ाइल प्रकार';

  @override
  String get vaultFileSize => 'आकार';

  @override
  String get vaultAddedLabel => 'जोड़ा गया';

  @override
  String get vaultPdf => 'PDF';

  @override
  String get vaultPhoto => 'फ़ोटो';

  @override
  String get vaultSample => 'नमूना';

  @override
  String get vaultTapToZoom => 'बड़ा करने के लिए टैप करें';

  @override
  String get vaultSecureNote =>
      'आपके खाते में निजी रूप से सुरक्षित। सिर्फ़ आप और जिनसे आप लिंक शेयर करें, वही देख सकते हैं।';

  @override
  String vaultLinkedVaccine(String pet) {
    return '$pet के टीका रिकॉर्ड से जुड़ा';
  }

  @override
  String get vaultOpenInApp => 'PawSetu में खोलें';

  @override
  String get vaultOpenPolicy => 'पॉलिसी खोलें';

  @override
  String get vaultTrackPolicy => 'बीमा में ट्रैक करें';

  @override
  String get vaultShareWithVet => 'डॉक्टर से शेयर करें';

  @override
  String get vaultDeleteDoc => 'दस्तावेज़ हटाएँ';

  @override
  String vaultDeleteDocQ(String title) {
    return '\"$title\" हटाएँ?';
  }

  @override
  String vaultDeleteDocBody(String pet) {
    return 'यह $pet के वॉल्ट से हट जाएगा और इसके शेयर लिंक काम करना बंद कर देंगे।';
  }

  @override
  String get vaultDeleted => 'दस्तावेज़ हटा दिया गया';

  @override
  String get vaultShareTitle => 'डॉक्टर से शेयर करें';

  @override
  String get vaultShareBody =>
      'ऐसा लिंक बनाएँ जो सीमित समय के लिए सिर्फ़ आपके चुने दस्तावेज़ खोले।';

  @override
  String get vaultChooseDocs => 'शेयर करने वाले दस्तावेज़';

  @override
  String get vaultSelectOneDoc => 'कम से कम एक दस्तावेज़ चुनें।';

  @override
  String get vaultLinkValidFor => 'लिंक कितनी देर चलेगा';

  @override
  String get vaultExpiry1h => '1 घंटा';

  @override
  String get vaultExpiry24h => '24 घंटे';

  @override
  String get vaultExpiry7d => '7 दिन';

  @override
  String get vaultExpiryNever => 'जब तक मैं बंद न करूँ';

  @override
  String get vaultAddPin => 'PIN माँगें';

  @override
  String get vaultAddPinHint =>
      'लिंक खोलने के लिए डॉक्टर यह 4 से 6 अंकों का PIN डालेंगे।';

  @override
  String get vaultPinFormat => 'PIN 4 से 6 अंकों का होना चाहिए।';

  @override
  String get vaultCreateLink => 'लिंक बनाएँ';

  @override
  String get vaultLinkReady => 'लिंक तैयार';

  @override
  String vaultLinkPinIs(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get vaultSendTo => 'लिंक भेजें';

  @override
  String get vaultSendPhoneTo => 'डॉक्टर का फ़ोन नंबर';

  @override
  String get vaultSendEmailTo => 'डॉक्टर का ईमेल';

  @override
  String get vaultSend => 'भेजें';

  @override
  String vaultSentTo(String target) {
    return 'लिंक $target को भेजा गया (डेमो: डेमो आउटबॉक्स में)';
  }

  @override
  String get vaultShareCopiedInstead =>
      'लिंक कॉपी हो गया। किसी भी ऐप में पेस्ट करें।';

  @override
  String get vaultShareEmailSubject =>
      'PawSetu से पालतू के स्वास्थ्य दस्तावेज़';

  @override
  String vaultShareText(String name, String pet, String url) {
    return '$name ने PawSetu पर $pet के स्वास्थ्य दस्तावेज़ आपसे शेयर किए: $url';
  }

  @override
  String get vaultShareLinks => 'शेयर लिंक';

  @override
  String get vaultLinksNote =>
      'लिंक सिर्फ़ आपके चुने दस्तावेज़ खोलते हैं और समय पूरा होने या आपके बंद करने पर काम करना बंद कर देते हैं।';

  @override
  String get vaultLinksOld => 'समाप्त और बंद';

  @override
  String get vaultNoLinks => 'अभी कोई शेयर लिंक नहीं';

  @override
  String get vaultNoLinksBody =>
      'वॉल्ट के किसी भी दस्तावेज़ से डॉक्टर को शेयर करें।';

  @override
  String get vaultLinkActive => 'चालू';

  @override
  String get vaultLinkExpired => 'समाप्त';

  @override
  String get vaultLinkRevoked => 'बंद';

  @override
  String vaultLinkDocs(int count) {
    return '$count दस्तावेज़';
  }

  @override
  String get vaultLinkAlbum => 'एल्बम लिंक';

  @override
  String vaultLinkWorksUntil(String when) {
    return '$when तक चलेगा';
  }

  @override
  String get vaultLinkNoEnd => 'आपके बंद करने तक चलेगा';

  @override
  String vaultLinkOpened(int count) {
    return '$count बार खोला गया';
  }

  @override
  String get vaultHasPin => 'PIN';

  @override
  String vaultCreatedOn(String when) {
    return '$when को बनाया';
  }

  @override
  String vaultRevokedOn(String when) {
    return '$when को बंद किया';
  }

  @override
  String get vaultAccessLog => 'खोलने का रिकॉर्ड';

  @override
  String get vaultNoAccess => 'अभी तक किसी ने यह लिंक नहीं खोला।';

  @override
  String get vaultAccessOk => 'खोला गया';

  @override
  String get vaultAccessWrongPin => 'ग़लत PIN डाला गया';

  @override
  String get vaultRevoke => 'लिंक बंद करें';

  @override
  String get vaultRevokeQ => 'यह लिंक बंद करें?';

  @override
  String get vaultRevokeBody =>
      'इसे खोलने वाले को दिखेगा कि यह अब काम नहीं करता। आपके दस्तावेज़ वॉल्ट में रहेंगे।';

  @override
  String get vaultRevoked => 'लिंक बंद हो गया';

  @override
  String vaultSharedBy(String owner, String pet) {
    return '$owner ने $pet के दस्तावेज़ शेयर किए';
  }

  @override
  String vaultSharedUntil(String when) {
    return '$when तक उपलब्ध';
  }

  @override
  String get vaultViewOnly => 'सिर्फ़ देखने के लिए';

  @override
  String get vaultNoMatches => 'इस लिंक में कोई दस्तावेज़ नहीं';

  @override
  String get vaultSharedFooter =>
      'PawSetu से सुरक्षित रूप से शेयर किया गया। पालतू-माता-पिता यह लिंक कभी भी बंद कर सकते हैं।';

  @override
  String get vaultGetPawSetu => 'PawSetu पाएँ';

  @override
  String get vaultEnterSharePin => 'PIN डालें';

  @override
  String vaultEnterSharePinBody(String owner) {
    return '$owner ने इन दस्तावेज़ों पर PIN लगाया है। उनसे PIN माँगें।';
  }

  @override
  String get vaultLinkPin => 'PIN';

  @override
  String get vaultOpenLink => 'खोलें';

  @override
  String get vaultShareWrongPin => 'ग़लत PIN। फिर कोशिश करें।';

  @override
  String get vaultShareLocked =>
      'बहुत ज़्यादा ग़लत कोशिशें। 15 मिनट बाद फिर कोशिश करें।';

  @override
  String get vaultLinkStopped => 'यह लिंक उपलब्ध नहीं है';

  @override
  String vaultLinkExpiredBody(String when) {
    return 'यह $when को समाप्त हो गया। पालतू-माता-पिता से नया लिंक माँगें।';
  }

  @override
  String get vaultLinkRevokedBody =>
      'पालतू-माता-पिता ने यह लिंक बंद कर दिया है। उनसे नया लिंक माँगें।';

  @override
  String get vaultLinkNotFoundBody => 'जाँचें कि लिंक पूरा कॉपी हुआ है।';

  @override
  String get vaultInsuranceTitle => 'पालतू बीमा';

  @override
  String get vaultInsuranceNote =>
      'PawSetu बीमा नहीं बेचता। अपनी पॉलिसी, रिन्यूअल और क्लेम यहाँ ट्रैक करें।';

  @override
  String get vaultNoPolicies => 'अभी कोई पॉलिसी नहीं';

  @override
  String get vaultNoPoliciesBody =>
      'कवर, रिन्यूअल की तारीख़ और क्लेम ट्रैक करने के लिए पालतू का बीमा जोड़ें।';

  @override
  String get vaultAddPolicy => 'पॉलिसी जोड़ें';

  @override
  String get vaultEditPolicy => 'पॉलिसी बदलें';

  @override
  String vaultPolicyFor(String pet) {
    return '$pet की पॉलिसी';
  }

  @override
  String get vaultFieldInsurer => 'बीमा कंपनी';

  @override
  String get vaultPlanName => 'प्लान का नाम';

  @override
  String get vaultFieldPolicyNo => 'पॉलिसी नंबर';

  @override
  String get vaultFieldCover => 'बीमा राशि (₹)';

  @override
  String get vaultFieldPremium => 'सालाना प्रीमियम (₹)';

  @override
  String get vaultFieldCoverStart => 'कवर शुरू';

  @override
  String get vaultFieldRenewal => 'रिन्यूअल की तारीख़';

  @override
  String get vaultRenewalReminderNote =>
      'रिन्यूअल से 30 दिन पहले हम याद दिलाएँगे।';

  @override
  String vaultInsuranceReminderTitle(String pet) {
    return '$pet का बीमा जल्द रिन्यू होगा';
  }

  @override
  String get vaultPolicyDoc => 'पॉलिसी दस्तावेज़';

  @override
  String get vaultLinkDoc => 'वॉल्ट से पॉलिसी दस्तावेज़ जोड़ें';

  @override
  String get vaultNoDocLinked => 'कोई दस्तावेज़ नहीं जुड़ा';

  @override
  String get vaultAttachDoc => 'वॉल्ट से जोड़ें';

  @override
  String vaultAttached(String title) {
    return 'जोड़ा गया: $title';
  }

  @override
  String get vaultDocMissing => 'यह पॉलिसी अब उपलब्ध नहीं है।';

  @override
  String get vaultCover => 'कवर';

  @override
  String vaultCoverLeft(String amount) {
    return 'इस साल $amount कवर बाकी';
  }

  @override
  String get vaultPremium => 'प्रीमियम';

  @override
  String vaultPremiumYear(String amount) {
    return '$amount सालाना';
  }

  @override
  String get vaultPolicyActive => 'चालू';

  @override
  String get vaultPolicyLapsed => 'समाप्त';

  @override
  String get vaultRenewSoon => 'जल्द रिन्यू करें';

  @override
  String get vaultDeletePolicyQ => 'यह पॉलिसी हटाएँ?';

  @override
  String get vaultDeletePolicyBody =>
      'इसके क्लेम भी हट जाएँगे। पॉलिसी दस्तावेज़ वॉल्ट में रहेगा।';

  @override
  String get vaultClaims => 'क्लेम';

  @override
  String vaultOpenClaims(int count) {
    return '$count चालू';
  }

  @override
  String get vaultNoClaims => 'अभी कोई क्लेम नहीं';

  @override
  String get vaultNewClaim => 'नया क्लेम';

  @override
  String get vaultClaimFor => 'क्लेम किस लिए है?';

  @override
  String get vaultClaimForHint => 'जैसे ब्रूनो के पैर का एक्स-रे और इलाज';

  @override
  String get vaultClaimAmount => 'क्लेम की राशि';

  @override
  String get vaultClaimDate => 'इलाज की तारीख़';

  @override
  String get vaultClaimChecklist => 'दस्तावेज़ों की सूची';

  @override
  String vaultChecklistProgress(int done, int total) {
    return '$total में से $done तैयार';
  }

  @override
  String get vaultCkClaimForm => 'भरा हुआ क्लेम फ़ॉर्म';

  @override
  String get vaultCkVetBills => 'डॉक्टर के बिल और रसीदें';

  @override
  String get vaultCkPrescription => 'पर्चा';

  @override
  String get vaultCkLabReports => 'लैब या एक्स-रे रिपोर्ट';

  @override
  String get vaultCkPolicyCopy => 'पॉलिसी की कॉपी';

  @override
  String get vaultCkPetPhoto => 'पालतू की हाल की फ़ोटो';

  @override
  String get vaultCkIdProof => 'आपका पहचान पत्र';

  @override
  String get vaultReadyToSubmit =>
      'जमा करने से पहले सूची के सभी दस्तावेज़ों पर टिक करें।';

  @override
  String vaultMarkAs(String status) {
    return '$status के रूप में चिह्नित करें';
  }

  @override
  String get vaultClaimDraft => 'ड्राफ़्ट';

  @override
  String get vaultClaimSubmitted => 'जमा किया';

  @override
  String get vaultClaimInReview => 'जाँच में';

  @override
  String get vaultClaimApproved => 'मंज़ूर';

  @override
  String get vaultClaimRejected => 'अस्वीकार';

  @override
  String get vaultClaimPaid => 'भुगतान हुआ';

  @override
  String vaultClaimedAmount(String amount) {
    return '$amount का क्लेम';
  }

  @override
  String vaultPaidAmount(String amount) {
    return '$amount मिले';
  }

  @override
  String get vaultSettledAmount => 'बीमा कंपनी द्वारा दी गई राशि';

  @override
  String get vaultClaimSaved => 'क्लेम सेव हुआ';

  @override
  String get edit => 'बदलें';

  @override
  String get close => 'बंद करें';

  @override
  String get change => 'बदलें';

  @override
  String get catFood => 'खाना';

  @override
  String get catTreats => 'ट्रीट्स';

  @override
  String get catToys => 'खिलौने';

  @override
  String get catGrooming => 'ग्रूमिंग';

  @override
  String get catHealthHygiene => 'सेहत और सफ़ाई';

  @override
  String get catBeds => 'बिस्तर';

  @override
  String get catCollars => 'पट्टे और कॉलर';

  @override
  String get catBowls => 'कटोरे और फ़ीडर';

  @override
  String get catLitter => 'लिटर और बिल्ली की देखभाल';

  @override
  String get catBird => 'पक्षी का दाना और पिंजरे';

  @override
  String get catRabbit => 'खरगोश की घास और देखभाल';

  @override
  String get catClothing => 'कपड़े';

  @override
  String get catTravel => 'यात्रा';

  @override
  String get shopStageYoung => 'पिल्ला / बिल्ली का बच्चा';

  @override
  String get shopStageAdult => 'वयस्क';

  @override
  String get shopStageSenior => 'बुज़ुर्ग';

  @override
  String get shopStageAll => 'हर उम्र';

  @override
  String get shopSizeSmall => 'छोटी नस्लें';

  @override
  String get shopSizeMedium => 'मध्यम नस्लें';

  @override
  String get shopSizeLarge => 'बड़ी नस्लें';

  @override
  String get shopSizeGiant => 'बहुत बड़ी नस्लें';

  @override
  String get shopSizeAll => 'हर आकार';

  @override
  String get sortPopular => 'लोकप्रिय';

  @override
  String get sortPriceLow => 'कीमत: कम से ज़्यादा';

  @override
  String get sortPriceHigh => 'कीमत: ज़्यादा से कम';

  @override
  String get sortDiscount => 'सबसे ज़्यादा छूट';

  @override
  String get sortNewest => 'नए';

  @override
  String get shopTitle => 'शॉप';

  @override
  String get shopSearchHint => 'खाना, खिलौने, बिस्तर खोजें…';

  @override
  String get shopSearchTitle => 'खोजें';

  @override
  String get shopClearSearch => 'खोज हटाएँ';

  @override
  String shopForPet(String pet) {
    return '$pet के लिए';
  }

  @override
  String shopAvoiding(String items) {
    return 'इनसे बचें: $items';
  }

  @override
  String get shopNoPicks => 'अभी कोई सुझाव नहीं। शॉप में खोजकर देखें।';

  @override
  String get shopBuyAgain => 'फिर से खरीदें';

  @override
  String get shopReorder => 'फिर से मँगाएँ';

  @override
  String shopReorderPrice(String price) {
    return 'फिर से मँगाएँ · $price';
  }

  @override
  String get shopCategories => 'कैटेगरी';

  @override
  String get shopDeals => 'ऑफ़र';

  @override
  String get shopPartnerStores => 'पार्टनर स्टोर';

  @override
  String get shopPartnerStoresNote =>
      'ये आप पार्टनर की अपनी वेबसाइट पर खरीदते हैं। PawSetu को थोड़ा कमीशन मिल सकता है।';

  @override
  String shopListings(int count) {
    return '$count प्रोडक्ट';
  }

  @override
  String shopPlusDeliveryNote(String amount) {
    return 'Plus सदस्यों को $amount से ऊपर फ़्री डिलीवरी।';
  }

  @override
  String get shopPartnerStore => 'पार्टनर स्टोर';

  @override
  String shopSoldOn(String store) {
    return '$store पर';
  }

  @override
  String shopOffPercent(int percent) {
    return '$percent% छूट';
  }

  @override
  String shopPriceSemantics(String price, String mrp, int percent) {
    return '$price, पहले $mrp, $percent% छूट';
  }

  @override
  String shopRatingSemantics(String rating, int count) {
    return '$count लोगों ने 5 में से $rating रेटिंग दी';
  }

  @override
  String get shopNoReviewsYet => 'अभी कोई रिव्यू नहीं';

  @override
  String get shopOutOfStock => 'स्टॉक में नहीं';

  @override
  String get shopInStock => 'स्टॉक में है';

  @override
  String shopOnlyLeft(int count) {
    return 'सिर्फ़ $count बचे';
  }

  @override
  String shopResults(int count) {
    return '$count प्रोडक्ट';
  }

  @override
  String shopFiltersCount(int count) {
    return 'फ़िल्टर ($count)';
  }

  @override
  String get shopNoResults => 'कुछ नहीं मिला';

  @override
  String get shopNoResultsBody => 'कोई और शब्द आज़माएँ या फ़िल्टर हटाएँ।';

  @override
  String get shopClearFilters => 'फ़िल्टर हटाएँ';

  @override
  String get shopCategory => 'कैटेगरी';

  @override
  String get shopPrice => 'कीमत';

  @override
  String get shopMinPrice => 'न्यूनतम कीमत';

  @override
  String get shopMaxPrice => 'अधिकतम कीमत';

  @override
  String get shopBrand => 'ब्रांड';

  @override
  String shopRatingAtLeast(String rating) {
    return '$rating★ और ऊपर';
  }

  @override
  String get shopHidePartner => 'पार्टनर स्टोर वाले प्रोडक्ट छिपाएँ';

  @override
  String get shopHidePartnerHint =>
      'सिर्फ़ वही दिखाएँ जो PawSetu में खरीद सकते हैं';

  @override
  String get shopShowResults => 'नतीजे दिखाएँ';

  @override
  String get shopProduct => 'प्रोडक्ट';

  @override
  String get shopProductGone => 'यह प्रोडक्ट अब उपलब्ध नहीं है';

  @override
  String shopShareText(String name, String price) {
    return 'PawSetu पर $name $price में';
  }

  @override
  String get shopInclTaxes => 'सभी टैक्स शामिल';

  @override
  String shopAffiliateNote(String store) {
    return 'यह आप $store पर खरीदेंगे। PawSetu को थोड़ा कमीशन मिल सकता है; आपके लिए कीमत वही रहती है।';
  }

  @override
  String shopSoldBy(String seller, String city) {
    return 'विक्रेता: $seller, $city';
  }

  @override
  String get shopSuitableFor => 'किसके लिए';

  @override
  String get shopCheckDelivery => 'डिलीवरी देखें';

  @override
  String get shopEnterPin => 'डिलीवरी की तारीख देखने के लिए पिन कोड डालें';

  @override
  String shopDeliveryBetween(String from, String to) {
    return 'डिलीवरी $from – $to';
  }

  @override
  String shopReturnable(int days) {
    return 'डिलीवरी के $days दिन के अंदर आसान वापसी';
  }

  @override
  String get shopNotReturnable =>
      'खाना और ट्रीट्स डिलीवरी के बाद वापस नहीं होते';

  @override
  String get shopAbout => 'इस प्रोडक्ट के बारे में';

  @override
  String get shopPackSize => 'पैक का साइज़';

  @override
  String get shopIngredients => 'सामग्री';

  @override
  String get shopReturnPolicy => 'वापसी नीति';

  @override
  String get shopVerifiedBuyer => 'पक्का खरीदार';

  @override
  String shopSellerReplied(String reply) {
    return 'विक्रेता: $reply';
  }

  @override
  String shopBuyOn(String store) {
    return '$store पर खरीदें';
  }

  @override
  String get shopAddToCart => 'कार्ट में डालें';

  @override
  String get shopBuyNow => 'अभी खरीदें';

  @override
  String get shopAddedToCart => 'कार्ट में डाला';

  @override
  String get shopViewCart => 'कार्ट देखें';

  @override
  String shopLeavingTitle(String store) {
    return 'आप $store पर खरीदेंगे';
  }

  @override
  String shopLeavingBody(String store) {
    return 'हम आपके ब्राउज़र में $store खोलेंगे। भुगतान, डिलीवरी और वापसी $store संभालेगा। PawSetu को थोड़ा कमीशन मिल सकता है।';
  }

  @override
  String shopContinueTo(String store) {
    return '$store पर जाएँ';
  }

  @override
  String get shopCart => 'कार्ट';

  @override
  String shopCartWithCount(int count) {
    return 'कार्ट, $count आइटम';
  }

  @override
  String get shopQuantity => 'मात्रा';

  @override
  String shopQtySemantics(int count) {
    return 'मात्रा $count';
  }

  @override
  String shopQtyShort(int count) {
    return 'मात्रा $count';
  }

  @override
  String shopLessOf(String item) {
    return 'एक कम $item';
  }

  @override
  String shopMoreOf(String item) {
    return 'एक और $item';
  }

  @override
  String shopRemoveItem(String item) {
    return '$item हटाएँ';
  }

  @override
  String shopStars(int count) {
    return '$count स्टार';
  }

  @override
  String get shopReviewText => 'आपको कैसा लगा? (ज़रूरी नहीं)';

  @override
  String get shopPostReview => 'रिव्यू भेजें';

  @override
  String get shopThanksReview => 'रिव्यू के लिए धन्यवाद!';

  @override
  String get shopRate => 'रेट करें';

  @override
  String get shopForWhichPet => 'किस पालतू के लिए?';

  @override
  String get shopReorderTitle => 'फिर से मँगाएँ';

  @override
  String shopReorderFor(String pet) {
    return '$pet के लिए फिर से मँगाएँ';
  }

  @override
  String shopDeliveryOn(String date) {
    return '$date को डिलीवरी';
  }

  @override
  String get shopItemsTotal => 'सामान का कुल';

  @override
  String get shopDeliveryFee => 'डिलीवरी';

  @override
  String get shopFree => 'फ़्री';

  @override
  String get shopToPay => 'देना है';

  @override
  String shopPlaceOrderAmount(String amount) {
    return 'ऑर्डर करें · $amount';
  }

  @override
  String get shopOrderPlacedToast => 'ऑर्डर हो गया!';

  @override
  String get shopOrderFailed => 'ऑर्डर नहीं हो पाया। कृपया फिर कोशिश करें।';

  @override
  String get addrBook => 'पते';

  @override
  String get addrAdd => 'पता जोड़ें';

  @override
  String get addrEdit => 'पता बदलें';

  @override
  String get addrAddFirst => 'डिलीवरी का पता जोड़ें';

  @override
  String get addrNone => 'अभी कोई पता नहीं';

  @override
  String get addrNoneBody => 'जल्दी चेकआउट के लिए घर का पता जोड़ें।';

  @override
  String get addrDeleteQ => 'यह पता हटाएँ?';

  @override
  String get addrChoose => 'यहाँ डिलीवर करें';

  @override
  String get addrHome => 'घर';

  @override
  String get addrWork => 'ऑफ़िस';

  @override
  String get addrOther => 'अन्य';

  @override
  String get addrName => 'नाम';

  @override
  String get addrPhoneInvalid => '10 अंकों का मोबाइल नंबर डालें';

  @override
  String get addrLine1 => 'मकान / फ़्लैट और गली';

  @override
  String get addrLine2 => 'पास की जगह (ज़रूरी नहीं)';

  @override
  String get addrArea => 'इलाका';

  @override
  String get addrCity => 'शहर';

  @override
  String get addrPin => 'पिन कोड';

  @override
  String get addrPinInvalid => '6 अंकों का पिन कोड डालें';

  @override
  String get cartEmpty => 'आपका कार्ट खाली है';

  @override
  String get cartEmptyBody =>
      'आपके पालतू के लिए खाना, खिलौने और बहुत कुछ एक टैप दूर।';

  @override
  String get cartStartShopping => 'खरीदारी शुरू करें';

  @override
  String cartSoldBy(String seller) {
    return 'विक्रेता: $seller';
  }

  @override
  String get cartSkipped => 'इन्हें अभी यहाँ से ऑर्डर नहीं कर सकते';

  @override
  String get cartPartnerOnly => 'इसे पार्टनर स्टोर पर खरीदें';

  @override
  String get cartPetHint => 'इससे इस पालतू का खर्च और खाना ट्रैक होता है।';

  @override
  String get cartDeliverTo => 'डिलीवरी का पता';

  @override
  String get cartSlot => 'डिलीवरी का समय';

  @override
  String get cartCoupon => 'कूपन';

  @override
  String get couponCode => 'कूपन कोड';

  @override
  String get couponApply => 'लगाएँ';

  @override
  String get couponApplied => 'कूपन लग गया';

  @override
  String couponSaved(String code, String amount) {
    return '$code लगा: आपकी बचत $amount';
  }

  @override
  String get couponNotFound => 'यह कूपन कोड सही नहीं है';

  @override
  String get couponExpired => 'यह कूपन खत्म हो गया है';

  @override
  String couponMinOrder(int amount) {
    return 'यह कूपन ₹$amount या उससे ज़्यादा के ऑर्डर पर लगेगा';
  }

  @override
  String get couponUsedUp => 'यह कूपन पूरा इस्तेमाल हो चुका है';

  @override
  String get cartPayment => 'भुगतान';

  @override
  String get payOnlineDemo => 'ऑनलाइन भुगतान (डेमो)';

  @override
  String get payOnDelivery => 'डिलीवरी पर भुगतान';

  @override
  String get cartBill => 'बिल';

  @override
  String cartMrpTotal(int count) {
    return 'कीमत ($count आइटम)';
  }

  @override
  String get cartMrpDiscount => 'MRP पर छूट';

  @override
  String get cartCouponDiscount => 'कूपन';

  @override
  String cartCouponDiscountCode(String code) {
    return 'कूपन $code';
  }

  @override
  String cartAddForFree(String amount) {
    return 'फ़्री डिलीवरी के लिए $amount का और सामान लें';
  }

  @override
  String get cartPlusFreeDelivery => 'Plus के साथ फ़्री डिलीवरी';

  @override
  String cartSplitNote(int count) {
    return 'सामान $count विक्रेताओं से आएगा, इसलिए $count डिलीवरी होंगी। भुगतान एक बार।';
  }

  @override
  String cartYouSave(String amount) {
    return 'आपकी बचत $amount';
  }

  @override
  String cartPay(String amount) {
    return '$amount चुकाएँ';
  }

  @override
  String get cartPlaceOrder => 'ऑर्डर करें';

  @override
  String cartPaymentFor(int count) {
    return 'PawSetu ऑर्डर, $count आइटम';
  }

  @override
  String get payFailedTryAgain =>
      'भुगतान नहीं हुआ। आपका कार्ट सेव है; फिर कोशिश करें।';

  @override
  String get payPaidOnline => 'ऑनलाइन भुगतान हुआ';

  @override
  String get payPending => 'भुगतान बाकी';

  @override
  String get payRefunded => 'पैसे वापस';

  @override
  String get payPendingNote =>
      'आपका भुगतान पक्का हो रहा है। न हो तो फिर से भुगतान करें या डिलीवरी पर दें।';

  @override
  String get payNow => 'अभी भुगतान करें';

  @override
  String get ordMyOrders => 'मेरे ऑर्डर';

  @override
  String get ordTabOrders => 'ऑर्डर';

  @override
  String get ordNone => 'अभी कोई ऑर्डर नहीं';

  @override
  String get ordPlaced => 'ऑर्डर हुआ';

  @override
  String get ordPacked => 'पैक हुआ';

  @override
  String get ordShipped => 'भेजा गया';

  @override
  String get ordOutForDelivery => 'डिलीवरी के लिए निकला';

  @override
  String get ordDelivered => 'डिलीवर हुआ';

  @override
  String get ordCancelled => 'रद्द';

  @override
  String get ordReturnRequested => 'वापसी माँगी';

  @override
  String get ordReturned => 'वापस हुआ';

  @override
  String get ordReturnRejected => 'वापसी नामंज़ूर';

  @override
  String ordItemsMore(String name, int count) {
    return '$name +$count और';
  }

  @override
  String ordArrivingBy(String date) {
    return '$date तक आएगा';
  }

  @override
  String ordExpected(String date) {
    return 'अनुमान $date';
  }

  @override
  String get ordPlacedTitle => 'ऑर्डर हो गया';

  @override
  String get ordPlacedHeading => 'धन्यवाद! आपका ऑर्डर हो गया।';

  @override
  String get ordPlacedBody => 'रास्ते में होने पर हम बताएँगे।';

  @override
  String ordPlacedSplit(int count) {
    return 'यह $count डिलीवरी में आएगा, हर विक्रेता से एक।';
  }

  @override
  String get ordTrack => 'ऑर्डर ट्रैक करें';

  @override
  String get ordContinueShopping => 'खरीदारी जारी रखें';

  @override
  String get ordDetail => 'ऑर्डर की जानकारी';

  @override
  String get ordNotFound => 'यह ऑर्डर नहीं मिला';

  @override
  String ordNumber(String number) {
    return 'ऑर्डर $number';
  }

  @override
  String ordPlacedOn(String date) {
    return '$date को ऑर्डर किया';
  }

  @override
  String get ordTracking => 'ट्रैकिंग';

  @override
  String ordItems(int count) {
    return '$count आइटम';
  }

  @override
  String ordSlot(String date, String window) {
    return 'समय: $date, $window';
  }

  @override
  String ordForPet(String pet) {
    return '$pet के लिए';
  }

  @override
  String get ordTotal => 'कुल';

  @override
  String get ordPayment => 'भुगतान';

  @override
  String get ordInvoice => 'बिल (PDF)';

  @override
  String get ordCancel => 'ऑर्डर रद्द करें';

  @override
  String get ordReturn => 'वापस करें';

  @override
  String get ordHelp => 'मदद लें';

  @override
  String ordReturnWindowOver(int days) {
    return '$days दिन की वापसी का समय खत्म हो गया।';
  }

  @override
  String get ordCancelTitle => 'आप क्यों रद्द करना चाहते हैं?';

  @override
  String get ordReturnTitle => 'आप क्यों वापस कर रहे हैं?';

  @override
  String get ordReasonChangedMind => 'मेरा मन बदल गया';

  @override
  String get ordReasonWrongItem => 'गलत सामान या साइज़';

  @override
  String get ordReasonTooLate => 'डिलीवरी बहुत देर से है';

  @override
  String get ordReasonDamaged => 'टूटा-फूटा आया';

  @override
  String get ordReasonNotSuitable => 'मेरे पालतू के लिए ठीक नहीं';

  @override
  String get ordReasonOther => 'कुछ और';

  @override
  String get ordCancelledToast => 'ऑर्डर रद्द हुआ';

  @override
  String get ordCancelledRefund =>
      'ऑर्डर रद्द हुआ। आपका रिफ़ंड आ रहा है (डेमो)।';

  @override
  String get ordReturnRequestedToast =>
      'वापसी माँगी गई। विक्रेता जल्द जवाब देगा।';

  @override
  String ordReason(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get ordStepDone => 'पूरा';

  @override
  String get invTitle => 'टैक्स इनवॉइस';

  @override
  String get invFooter =>
      'PawSetu मार्केटप्लेस · यह इनवॉइस विक्रेता ने PawSetu से बनाया है।';

  @override
  String get invSoldBy => 'विक्रेता';

  @override
  String get invBillTo => 'खरीदार';

  @override
  String invGstin(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get invMarketplace => 'PawSetu मार्केटप्लेस से बेचा गया';

  @override
  String get invOrder => 'ऑर्डर';

  @override
  String invInvoiceNo(String number) {
    return 'इनवॉइस $number';
  }

  @override
  String invPayment(String method) {
    return 'भुगतान: $method';
  }

  @override
  String get invItems => 'सामान';

  @override
  String get invItem => 'सामान';

  @override
  String get invQty => 'मात्रा';

  @override
  String get invPrice => 'कीमत';

  @override
  String get invAmount => 'राशि';

  @override
  String get invTax => 'GST';

  @override
  String get invTaxPlaceholder => 'शामिल';

  @override
  String get invDemoNote =>
      'डेमो इनवॉइस: कोई पैसा नहीं लिया गया और GST जानकारी नमूना है।';

  @override
  String get orderEmailSubject => 'आपका PawSetu ऑर्डर हो गया';

  @override
  String orderEmailBody(String name, String amount, String date) {
    return 'नमस्ते $name, $amount के ऑर्डर के लिए धन्यवाद। यह $date तक पहुँच जाना चाहिए।';
  }

  @override
  String get subsTitle => 'अपने-आप दोबारा ऑर्डर';

  @override
  String get subsHint =>
      'हर 2, 4 या 6 हफ़्ते में डिलीवरी। कभी भी रोकें या बंद करें।';

  @override
  String get subsEvery => 'कितने समय में';

  @override
  String subsWeeks(int count) {
    return 'हर $count हफ़्ते';
  }

  @override
  String subsFirstOn(String date) {
    return 'पहली डिलीवरी लगभग $date को, डिलीवरी पर भुगतान।';
  }

  @override
  String get subsStart => 'ऑटो-ऑर्डर शुरू करें';

  @override
  String get subsCreated => 'ऑटो-ऑर्डर चालू है';

  @override
  String get subsTab => 'ऑटो-ऑर्डर';

  @override
  String get subsNone => 'कोई ऑटो-ऑर्डर नहीं';

  @override
  String get subsNoneBody =>
      'किसी भी खाने के पेज से शुरू करें ताकि खाना कभी खत्म न हो।';

  @override
  String subsNext(String date) {
    return 'अगली डिलीवरी $date';
  }

  @override
  String get subsPaused => 'रुका हुआ';

  @override
  String get subsPause => 'रोकें';

  @override
  String get subsResume => 'फिर शुरू करें';

  @override
  String get subsCancel => 'बंद करें';

  @override
  String get subsCancelQ => 'यह ऑटो-ऑर्डर बंद करें?';

  @override
  String subsOrderedToast(int count) {
    return '$count ऑटो-ऑर्डर हो गए';
  }

  @override
  String ntfNewOrder(String item, int count) {
    return 'नया ऑर्डर: $item';
  }

  @override
  String ntfOrderCancelled(String number) {
    return 'ग्राहक ने ऑर्डर $number रद्द किया';
  }

  @override
  String ntfOrderCancelledBySeller(String item) {
    return 'माफ़ कीजिए, विक्रेता ने $item का ऑर्डर रद्द किया। भुगतान वापस होगा।';
  }

  @override
  String ntfOrderPacked(String item) {
    return '$item पैक हो गया';
  }

  @override
  String ntfOrderShipped(String item) {
    return '$item रास्ते में है';
  }

  @override
  String ntfOrderOutForDelivery(String item) {
    return '$item आज डिलीवरी के लिए निकला';
  }

  @override
  String ntfOrderDelivered(String item) {
    return '$item डिलीवर हो गया';
  }

  @override
  String ntfOrderUpdated(String item) {
    return '$item का ऑर्डर अपडेट हुआ';
  }

  @override
  String ntfReturnAccepted(String item) {
    return '$item की वापसी मंज़ूर। रिफ़ंड आ रहा है।';
  }

  @override
  String ntfReturnRejected(String item) {
    return '$item की वापसी नामंज़ूर। मदद के लिए टैप करें।';
  }

  @override
  String ntfReturnRequested(String number) {
    return 'ऑर्डर $number की वापसी माँगी गई';
  }

  @override
  String ntfSubscriptionOrdered(String item) {
    return 'ऑटो-ऑर्डर हुआ: $item';
  }

  @override
  String foodRunsOutIn(String pet, int days) {
    return '$pet का खाना लगभग $days दिन में खत्म हो सकता है। फिर से मँगाएँ?';
  }

  @override
  String foodRanOut(String pet) {
    return '$pet का खाना शायद खत्म हो गया है। फिर से मँगाएँ?';
  }

  @override
  String foodPortionLine(int grams, String bag) {
    return 'रोज़ $grams ग्राम · $bag का पैक';
  }

  @override
  String get foodEditPortion => 'मात्रा बदलें';

  @override
  String foodOnTheWay(String pet) {
    return '$pet का नया खाना रास्ते में है';
  }

  @override
  String foodPlanTitle(String pet) {
    return '$pet का खाना';
  }

  @override
  String get foodDailyPortion => 'रोज़ की मात्रा';

  @override
  String foodSuggested(int grams) {
    return 'शुरुआत के लिए रोज़ $grams ग्राम। पैक या अपने डॉक्टर की सलाह मानें।';
  }

  @override
  String get foodBagSize => 'पैक का साइज़';

  @override
  String get foodOpenedOn => 'पैक कब खोला';

  @override
  String get expAdd => 'खर्च जोड़ें';

  @override
  String get expEdit => 'खर्च बदलें';

  @override
  String get expThisMonth => 'इस महीने';

  @override
  String get expLastMonth => 'पिछले महीने';

  @override
  String expPeriodTotal(int months) {
    return 'पिछले $months महीने';
  }

  @override
  String get expByMonth => 'महीने के हिसाब से खर्च';

  @override
  String expMonths(int count) {
    return '$count महीने';
  }

  @override
  String get expByCategory => 'कैटेगरी के हिसाब से';

  @override
  String expChartSemantics(String values) {
    return 'महीने के हिसाब से खर्च: $values';
  }

  @override
  String get expNone => 'अभी कोई खर्च नहीं';

  @override
  String get expNoneBody =>
      'बुकिंग और ऑर्डर यहाँ अपने-आप जुड़ते हैं। आप दूसरे खर्च भी जोड़ सकते हैं।';

  @override
  String get expVet => 'डॉक्टर';

  @override
  String get expGrooming => 'ग्रूमिंग';

  @override
  String get expTraining => 'ट्रेनिंग';

  @override
  String get expBoarding => 'बोर्डिंग';

  @override
  String get expWalking => 'वॉकिंग';

  @override
  String get expFood => 'खाना';

  @override
  String get expSupplies => 'सामान';

  @override
  String get expInsurance => 'बीमा';

  @override
  String get expOther => 'अन्य';

  @override
  String get expFromBooking => 'बुकिंग से';

  @override
  String get expFromOrder => 'ऑर्डर से';

  @override
  String get expFromTeleVet => 'टेली-वेट से';

  @override
  String get expAmount => 'राशि';

  @override
  String get expAmountInvalid => 'राशि डालें';

  @override
  String get expCategory => 'कैटेगरी';

  @override
  String get expForPet => 'किसके लिए';

  @override
  String get expAllPets => 'सभी पालतू';

  @override
  String get expNote => 'नोट';

  @override
  String get expNoteHint => 'जैसे: रेबीज़ बूस्टर, नया पट्टा';

  @override
  String get expSaved => 'खर्च सेव हुआ';

  @override
  String get expDeleteQ => 'यह खर्च हटाएँ?';

  @override
  String get selToPack => 'पैक करने वाले ऑर्डर';

  @override
  String get selOnTheWay => 'रास्ते में';

  @override
  String get selLowStock => 'कम स्टॉक';

  @override
  String selReturnsWaiting(int count) {
    return '$count वापसी आपके जवाब का इंतज़ार कर रही हैं';
  }

  @override
  String get selNewOrders => 'नए ऑर्डर';

  @override
  String get selNoNewOrders => 'अभी कोई नया ऑर्डर नहीं';

  @override
  String selStockLeft(int count) {
    return '$count स्टॉक में';
  }

  @override
  String get selAddProduct => 'प्रोडक्ट जोड़ें';

  @override
  String get selEditProduct => 'प्रोडक्ट बदलें';

  @override
  String get selCsvUpload => 'CSV से एक साथ अपलोड';

  @override
  String get selSearchProducts => 'अपने प्रोडक्ट खोजें';

  @override
  String selProductCount(int count) {
    return '$count प्रोडक्ट';
  }

  @override
  String get selHidden => 'शॉप में छिपा है';

  @override
  String get selProductName => 'प्रोडक्ट का नाम';

  @override
  String get selPrice => 'बिक्री कीमत';

  @override
  String get selMrp => 'MRP';

  @override
  String get selPriceInvalid => 'कीमत डालें';

  @override
  String get selMrpInvalid => 'MRP कीमत से कम नहीं हो सकता';

  @override
  String get selStock => 'स्टॉक';

  @override
  String get selPackKg => 'पैक साइज़ किलो में (खाना)';

  @override
  String get selDescription => 'विवरण';

  @override
  String get selVisible => 'शॉप में दिखाएँ';

  @override
  String get selVisibleHint => 'बिना हटाए छिपाने के लिए बंद करें';

  @override
  String get selNoRxNote =>
      'सिर्फ़ पर्चे वाली दवाएँ PawSetu पर नहीं बिक सकतीं।';

  @override
  String get selSaved => 'प्रोडक्ट सेव हुआ';

  @override
  String selCsvHelp(String columns) {
    return 'कॉलम: $columns। प्रजाति कई हो सकती हैं, जैसे dog|cat।';
  }

  @override
  String get selCsvChoose => 'CSV फ़ाइल चुनें';

  @override
  String get selCsvSample => 'नमूना आज़माएँ';

  @override
  String get selCsvCopyTemplate => 'टेम्पलेट कॉपी करें';

  @override
  String get selCsvCopied => 'टेम्पलेट कॉपी हुआ';

  @override
  String get selCsvPaste => 'या CSV यहाँ पेस्ट करें';

  @override
  String selCsvPreview(int ok, int bad) {
    return 'झलक: $ok तैयार, $bad ठीक करने हैं';
  }

  @override
  String selCsvLine(int line) {
    return 'लाइन $line';
  }

  @override
  String selCsvProblems(String fields) {
    return 'जाँचें: $fields';
  }

  @override
  String selCsvImport(int count) {
    return '$count प्रोडक्ट जोड़ें';
  }

  @override
  String selCsvImported(int count) {
    return '$count प्रोडक्ट जुड़े';
  }

  @override
  String get selTabNew => 'नए';

  @override
  String get selTabPacked => 'पैक हुए';

  @override
  String get selTabShipping => 'भेजे गए';

  @override
  String get selTabDelivered => 'डिलीवर हुए';

  @override
  String get selTabCancelled => 'रद्द / वापस';

  @override
  String get selNoOrdersHere => 'यहाँ कोई ऑर्डर नहीं';

  @override
  String get selReturnsOpen => 'आपके जवाब का इंतज़ार';

  @override
  String get selReturnsDone => 'पूरे हुए';

  @override
  String get selNoReturns => 'कोई वापसी नहीं';

  @override
  String get selAcceptReturn => 'वापसी मंज़ूर करें';

  @override
  String get selRejectReturn => 'वापसी नामंज़ूर करें';

  @override
  String get selPayoutDemo => 'डेमो भुगतान: असली पैसा नहीं जाता।';

  @override
  String get selPayoutPending => 'बाकी';

  @override
  String get selPayoutReady => 'भुगतान के लिए तैयार';

  @override
  String get selPayoutPaid => 'भुगतान हुआ';

  @override
  String get selPayoutOnHold => 'वापसी के समय में';

  @override
  String get selCommissionPaid => 'PawSetu कमीशन';

  @override
  String selRunPayout(String amount) {
    return 'अभी $amount का भुगतान करें (डेमो)';
  }

  @override
  String selPayoutDone(int count) {
    return '$count ऑर्डर का भुगतान हुआ';
  }

  @override
  String selPayoutRule(int days) {
    return '$days दिन की वापसी का समय खत्म होने पर हर हफ़्ते भुगतान होता है।';
  }

  @override
  String get selPayoutOrders => 'ऑर्डर';

  @override
  String selPayoutLine(String gross, String commission) {
    return 'बिक्री $gross · कमीशन $commission';
  }

  @override
  String selReviewSummary(String rating, int count) {
    return '★ $rating, $count रिव्यू';
  }

  @override
  String get selReplyText => 'आपका जवाब';

  @override
  String get selSendReply => 'जवाब भेजें';

  @override
  String get selApproved => 'मंज़ूर';

  @override
  String get selKyc => 'KYC दस्तावेज़';

  @override
  String get selVerified => 'जाँचा गया';

  @override
  String get selCancelQ => 'यह ऑर्डर रद्द करें?';

  @override
  String get selCancelBody => 'ग्राहक को बताया जाएगा और भुगतान वापस होगा।';

  @override
  String get selCancelOrder => 'ऑर्डर रद्द करें';

  @override
  String get selOutOfStockReason => 'स्टॉक खत्म';

  @override
  String get selMarkPacked => 'पैक हुआ';

  @override
  String get selMarkShipped => 'भेज दिया';

  @override
  String get selMarkOut => 'डिलीवरी के लिए निकला';

  @override
  String get selMarkDelivered => 'डिलीवर हुआ';

  @override
  String get selCommission => 'PawSetu कमीशन';

  @override
  String get selYourPayout => 'आपको मिलेगा';

  @override
  String get selShipTo => 'यहाँ भेजें';

  @override
  String get selPhoneHidden =>
      'ग्राहक का फ़ोन छिपा है; कूरियर PawSetu से कॉल करता है।';

  @override
  String get faChokingTitle => 'गले में कुछ फँसना';

  @override
  String get faChokingSigns =>
      'मुँह पर पंजा मारना, उबकाई, खाँसी, नीले मसूड़े या साँस लेने में तकलीफ़।';

  @override
  String get faChokingSteps =>
      'शांत रहें और पालतू को स्थिर रखें। अगर वह खाँस पा रहा है, तो उसे खुद निकालने दें।\nधीरे से मुँह खोलें और टॉर्च से अंदर देखें।\nअगर चीज़ दिख रही है और आसानी से पहुँच में है, तो उँगलियों से निकालें। उसे और अंदर न धकेलें।\nछोटा कुत्ता या बिल्ली: कूल्हों से उल्टा पकड़ें और कंधों के बीच 5 बार ज़ोर से थपथपाएँ।\nबड़ा कुत्ता: पीछे खड़े होकर मुट्ठी पसलियों के ठीक नीचे रखें और 5 बार तेज़ी से अंदर और ऊपर की ओर दबाएँ।\nमुँह फिर से देखें। चीज़ निकल जाए तब भी तुरंत डॉक्टर के पास जाएँ।';

  @override
  String get faChokingAvoid =>
      'बिना देखे गले में उँगली न डालें।\nखाना या पानी न दें।\nदिखने वाला धागा या डोरी न खींचें; वह अंदर किसी चीज़ में फँसा हो सकता है।';

  @override
  String get faChokingVet =>
      'गले में कुछ फँसने के बाद हमेशा डॉक्टर को दिखाएँ, भले ही पालतू ठीक लगे। अगर वह गिर जाए या साँस न ले पाए तो SOS का इस्तेमाल करें।';

  @override
  String get faPoisoningTitle => 'ज़हर खा लेना';

  @override
  String get faPoisoningSigns =>
      'उल्टी, लार गिरना, काँपना, लड़खड़ाकर चलना, दौरे, अचानक सुस्ती, या पास में चबाया हुआ पैकेट।';

  @override
  String get faPoisoningSteps =>
      'पालतू को ज़हर से दूर ले जाएँ और मुँह में बचा हुआ हिस्सा निकाल दें।\nपता करें कि क्या खाया, कितना और कब। पैकेट रखें या पौधे की फ़ोटो लें।\nअभी अपने डॉक्टर को फ़ोन करें, या SOS से सबसे पास का क्लिनिक खोजें।\nअगर ज़हर बालों या त्वचा पर लगा है, तो गुनगुने पानी से अच्छी तरह धोएँ।\nक्लिनिक जाते समय पालतू को गर्म और शांत रखें।';

  @override
  String get faPoisoningAvoid =>
      'डॉक्टर के कहे बिना उल्टी न कराएँ।\nदूध, नमक, तेल या घरेलू नुस्खे न दें।\nलक्षणों का इंतज़ार न करें; कुछ ज़हर घंटों बाद असर करते हैं।';

  @override
  String get faPoisoningVet => 'अभी जाएँ। ज़हर में जल्दी इलाज से जान बचती है।';

  @override
  String get faHeatstrokeTitle => 'लू लगना';

  @override
  String get faHeatstrokeSigns =>
      'गर्म दिन में तेज़ हाँफना, गाढ़ी लार, बहुत लाल या पीले मसूड़े, कमज़ोरी, उल्टी या गिर जाना।';

  @override
  String get faHeatstrokeSteps =>
      'पालतू को तुरंत छाँव या ठंडे कमरे में ले जाएँ।\nशरीर पर ठंडा (बर्फ़ जैसा नहीं) पानी डालें, ख़ासकर पेट, गर्दन और पंजों पर।\nपंखा चलाएँ या गीले तौलिये रखें, और उन्हें बार-बार बदलें ताकि गर्मी न रुके।\nठंडे पानी के छोटे घूँट दें; ज़बरदस्ती न पिलाएँ।\nपालतू बेहतर लगे तब भी डॉक्टर के पास जाएँ।';

  @override
  String get faHeatstrokeAvoid =>
      'बर्फ़ या बर्फ़ जैसा ठंडा पानी इस्तेमाल न करें।\nपालतू को गीले तौलिये से ढककर छोड़ न दें।\nदोपहर की गर्मी में न घुमाएँ, और पालतू को कभी खड़ी कार में न छोड़ें।';

  @override
  String get faHeatstrokeVet =>
      'लू से अंगों को घंटों बाद नुकसान हो सकता है। आज ही डॉक्टर को दिखाएँ। चपटे चेहरे वाली नस्लों को ज़्यादा ख़तरा होता है।';

  @override
  String get faBleedingTitle => 'ख़ून बहना';

  @override
  String get faBleedingSigns => 'घाव, पंजे, कान या नाक से ख़ून।';

  @override
  String get faBleedingSteps =>
      'घाव पर साफ़ कपड़ा या गॉज़ रखकर ज़ोर से दबाएँ।\nकम से कम 5 मिनट तक बिना हटाए दबाए रखें।\nख़ून कपड़े से रिसे तो ऊपर और कपड़ा रखें और दबाते रहें।\nपट्टी मज़बूती से बाँधें, पर बहुत टाइट नहीं।\nपालतू को शांत रखें और डॉक्टर के पास जाएँ।';

  @override
  String get faBleedingAvoid =>
      'डॉक्टर के कहे बिना टाइट बंधन (टूर्निकेट) न बाँधें।\nघाव में फँसी चीज़ बाहर न खींचें।\nगहरे घाव पर हल्दी, पाउडर या क्रीम न लगाएँ।';

  @override
  String get faBleedingVet =>
      'बहुत ज़्यादा ख़ून, फव्वारे जैसा ख़ून, या 10 मिनट दबाने पर भी कम न होने पर SOS का इस्तेमाल करें।';

  @override
  String get faFractureTitle => 'हड्डी टूटना';

  @override
  String get faFractureSigns =>
      'पैर पर वज़न न डालना, सूजन, अजीब मोड़, छूने पर रोना।';

  @override
  String get faFractureSteps =>
      'पालतू को जितना हो सके स्थिर रखें। डरा हुआ पालतू काट सकता है, इसलिए धीरे से संभालें।\nछोटे पालतू को तौलिया बिछे डिब्बे या टोकरी में ले जाएँ।\nबड़े कुत्ते के लिए तख़्ता या कंबल को स्ट्रेचर की तरह इस्तेमाल करें।\nखुले घाव को साफ़ कपड़े से ढकें।\nतुरंत डॉक्टर के पास जाएँ।';

  @override
  String get faFractureAvoid =>
      'हड्डी सीधी करने की कोशिश न करें।\nइंसानों की दर्द की दवा न दें; कई दवाएँ पालतू के लिए ज़हरीली हैं।\nपालतू को उस पैर पर चलने न दें।';

  @override
  String get faFractureVet =>
      'हड्डी टूटने के हर शक पर डॉक्टर को दिखाएँ; अक्सर एक्स-रे की ज़रूरत होती है।';

  @override
  String get faSeizureTitle => 'दौरा पड़ना';

  @override
  String get faSeizureSigns =>
      'गिर जाना, पैरों का अकड़ना या झटके, पैर चलाना, लार गिरना, कोई जवाब न देना।';

  @override
  String get faSeizureSteps =>
      'शांत रहें और दौरा शुरू होने का समय नोट करें।\nफ़र्नीचर और नुकीली चीज़ें दूर करें। रोशनी कम करें और शांति रखें।\nअपने हाथ मुँह से दूर रखें।\nदौरे के बाद पालतू को गर्म रखें और आराम करने दें; वह कुछ देर उलझन में रह सकता है।\nडॉक्टर को फ़ोन करें और बताएँ कि दौरा कितनी देर चला।';

  @override
  String get faSeizureAvoid =>
      'पालतू को ज़बरदस्ती न पकड़ें।\nमुँह में कुछ न डालें; पालतू अपनी जीभ नहीं निगलते।\nपूरी तरह होश आने तक खाना या पानी न दें।';

  @override
  String get faSeizureVet =>
      'दौरा 5 मिनट से ज़्यादा चले या एक के बाद एक आएँ तो SOS का इस्तेमाल करें। पहले दौरे पर हमेशा डॉक्टर को दिखाएँ।';

  @override
  String get faBurnTitle => 'जलना';

  @override
  String get faBurnSigns =>
      'लाल या छिली त्वचा, छाले, झुलसे बाल, या गर्म तरल, आग या केमिकल से संपर्क।';

  @override
  String get faBurnSteps =>
      'जली जगह को 10 मिनट तक बहते ठंडे पानी से ठंडा करें।\nकेमिकल से जलने पर 15 मिनट तक ख़ूब पानी से धोएँ; दस्ताने पहनें।\nसाफ़, गीले, रोएँ रहित कपड़े से हल्के से ढकें।\nबाकी शरीर को लपेटकर गर्म रखें और डॉक्टर के पास जाएँ।';

  @override
  String get faBurnAvoid =>
      'बर्फ़, मक्खन, तेल, टूथपेस्ट या हल्दी न लगाएँ।\nछाले न फोड़ें।\nपालतू को जली जगह चाटने न दें।';

  @override
  String get faBurnVet =>
      'जलन दिखने से ज़्यादा गहरी हो सकती है। उसी दिन डॉक्टर को दिखाएँ।';

  @override
  String get faBiteTitle => 'साँप या कीड़े का काटना';

  @override
  String get faBiteSigns =>
      'अचानक सूजन, दर्द, दाँतों के निशान, ख़ून, कमज़ोरी, लार गिरना या साँस लेने में तकलीफ़।';

  @override
  String get faBiteSteps =>
      'पालतू को शांत और जितना हो सके स्थिर रखें; हो सके तो गोद में उठाकर ले जाएँ।\nकाटे गए हिस्से को दिल के बराबर या नीचे रखें।\nगर्दन या चेहरा सूज रहा हो तो पट्टा (कॉलर) उतार दें।\nमधुमक्खी के डंक को कार्ड से खुरचकर निकालें।\nतुरंत सबसे पास के क्लिनिक जाएँ। खुला क्लिनिक खोजने के लिए SOS का इस्तेमाल करें।\nसुरक्षित हो तो साँप का रंग और आकार याद रखें, या दूर से फ़ोटो लें।';

  @override
  String get faBiteAvoid =>
      'घाव को न काटें और ज़हर चूसकर निकालने की कोशिश न करें।\nकाटे गए हिस्से के ऊपर टाइट पट्टी न बाँधें।\nसाँप को पकड़ने की कोशिश न करें।';

  @override
  String get faBiteVet =>
      'साँप का हर काटना इमरजेंसी है। पालतू ठीक लगे तब भी जाएँ।';

  @override
  String get faTickTitle => 'किलनी (टिक) निकालना';

  @override
  String get faTickSigns =>
      'त्वचा से चिपका छोटा भूरा-स्लेटी दाना, अक्सर कान, गर्दन, बगल या उँगलियों के बीच।';

  @override
  String get faTickSteps =>
      'हो सके तो दस्ताने पहनें। बाल हटाकर किलनी को साफ़ देखें।\nपतली चिमटी या टिक हुक से किलनी को त्वचा के पास से पकड़ें।\nधीरे और लगातार सीधा बाहर खींचें, बिना घुमाए या दबाए।\nजगह को एंटीसेप्टिक से साफ़ करें और हाथ धोएँ।\nकिलनी को अल्कोहल में डालें, या टेप में बंद करके फेंकें।\nअगले 3 हफ़्ते बुख़ार, सुस्ती या पीले मसूड़ों पर नज़र रखें।';

  @override
  String get faTickAvoid =>
      'किलनी को जलाएँ नहीं, न ही तेल, केरोसिन या पेट्रोल लगाएँ।\nकिलनी का शरीर न दबाएँ।\nनंगी उँगलियों से किलनी न मसलें।';

  @override
  String get faTickVet =>
      'बुख़ार, सुस्ती, खाना न खाना या बहुत सारी किलनियाँ हों तो डॉक्टर को दिखाएँ। किलनी से बचाव के बारे में पूछें।';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get closedNow => 'अभी बंद';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get openInMaps => 'मैप्स में खोलें';

  @override
  String get draftVetReview => 'ड्राफ़्ट, डॉक्टर द्वारा जाँच बाकी';

  @override
  String get sosCallNearest => 'सबसे पास के क्लिनिक को कॉल करें';

  @override
  String get sosGetAddress => 'सबसे पास के क्लिनिक का पता';

  @override
  String get sosFinding => 'आपके पास के क्लिनिक खोज रहे हैं…';

  @override
  String get sosLocating => 'आपकी जगह पता कर रहे हैं…';

  @override
  String get sosUsingGps => 'आपकी अभी की जगह इस्तेमाल हो रही है';

  @override
  String sosUsingLastKnown(String time) {
    return 'आपकी पिछली जगह इस्तेमाल हो रही है ($time की)';
  }

  @override
  String sosUsingArea(String area) {
    return 'लोकेशन बंद है। $area के पास के क्लिनिक दिखा रहे हैं।';
  }

  @override
  String sosLocatingNear(String area) {
    return 'आपकी लोकेशन खोज रहे हैं… तब तक $area के पास के क्लिनिक।';
  }

  @override
  String get sosLocatingLastKnown =>
      'आपकी लोकेशन खोज रहे हैं… तब तक आपकी पिछली जगह के पास के क्लिनिक।';

  @override
  String get sosLocationOffHint => 'जगह ग़लत है? बदलें ताकि सूची सही रहे।';

  @override
  String get sosTryLocation => 'मेरी लोकेशन फिर से आज़माएँ';

  @override
  String get sosChangeArea => 'जगह बदलें';

  @override
  String sosSavedClinics(String when) {
    return 'इंटरनेट कमज़ोर है: $when को सेव किए क्लिनिक दिखा रहे हैं।';
  }

  @override
  String get sosNoClinics =>
      'पास में कोई क्लिनिक नहीं मिला। दूसरी जगह आज़माएँ।';

  @override
  String sosCallClinic(String name) {
    return '$name को कॉल करें';
  }

  @override
  String sosAway(String km) {
    return '$km दूर';
  }

  @override
  String sosDemoCall(String phone) {
    return 'डेमो: यह $phone पर कॉल करता। डेमो में असली कॉल नहीं होती।';
  }

  @override
  String get sosShowVet => 'यह डॉक्टर को दिखाएँ';

  @override
  String get firstAidTitle => 'प्राथमिक उपचार';

  @override
  String get firstAidOfflineHint => 'बिना इंटरनेट के चलने वाली आसान गाइड';

  @override
  String get firstAidOffline => 'बिना इंटरनेट के चलता है';

  @override
  String get firstAidEmergencyNote =>
      'साँस नहीं ले रहा, गिर गया या बहुत ख़ून बह रहा है? अभी SOS दबाए रखें और क्लिनिक जाएँ। ये गाइड रास्ते में मदद करेंगी।';

  @override
  String get firstAidSigns => 'लक्षण';

  @override
  String get firstAidWhatToDo => 'क्या करें';

  @override
  String get firstAidAvoid => 'क्या न करें';

  @override
  String get firstAidWhenVet => 'डॉक्टर को कब दिखाएँ';

  @override
  String get firstAidTalkToVet => 'अभी डॉक्टर से बात करें';

  @override
  String get toxTitle => 'क्या यह सुरक्षित है?';

  @override
  String get toxTileHint =>
      'अपने पालतू के लिए खाना, पौधे और घर की चीज़ें जाँचें';

  @override
  String get toxSearchLabel => 'खाना, पौधा या घर की चीज़';

  @override
  String get toxSearchHint => 'जैसे: अंगूर, लिली, चॉकलेट';

  @override
  String get toxForWhichPet => 'किस पालतू के लिए?';

  @override
  String get toxKindAll => 'सभी';

  @override
  String get toxKindFood => 'खाना';

  @override
  String get toxKindPlant => 'पौधे';

  @override
  String get toxKindHome => 'घर की चीज़ें';

  @override
  String get toxDanger => 'ख़तरनाक';

  @override
  String get toxCaution => 'सावधान रहें';

  @override
  String get toxSafe => 'थोड़ी मात्रा में सुरक्षित';

  @override
  String get toxForEachPet => 'हर तरह के पालतू के लिए';

  @override
  String get toxAteIt =>
      'पहले ही खा लिया? लक्षणों का इंतज़ार न करें। अभी मदद लें और पैकेट या फ़ोटो साथ ले जाएँ।';

  @override
  String get toxPoisoningGuide => 'ज़हर वाली गाइड खोलें';

  @override
  String get toxNoMatch => 'अभी हमारी सूची में नहीं है';

  @override
  String get toxNoMatchHint => 'पक्का न हो तो न दें, और डॉक्टर से पूछें।';

  @override
  String get lostIntro =>
      'हर पालतू को एक QR टैग मिलता है। इसे स्कैन करने वाला आपके पालतू की फ़ोटो वाला पेज देखता है और आपको संदेश भेज सकता है या अपनी जगह बता सकता है। आपका फ़ोन नंबर छिपा रहता है।';

  @override
  String get lostSafeAtHome => 'घर पर सुरक्षित';

  @override
  String lostSinceShort(String when) {
    return '$when से लापता';
  }

  @override
  String lostPetTitle(String pet) {
    return '$pet · QR टैग';
  }

  @override
  String lostIfMissing(String pet) {
    return 'अगर $pet खो जाए';
  }

  @override
  String get lostIfMissingBody =>
      'लापता मार्क करें: एक पेज शेयर करें, चाहें तो पास के PawSetu यूज़र्स को अलर्ट भेजें, और एक टैप में पोस्टर बनाएँ।';

  @override
  String lostMarkLost(String pet) {
    return '$pet को लापता मार्क करें';
  }

  @override
  String get lostWhereSeen => 'आपका पालतू आख़िरी बार कहाँ दिखा?';

  @override
  String get lostUsingGps => 'आपकी अभी की जगह';

  @override
  String get lostNearMe => 'मेरी जगह के पास';

  @override
  String get lostWhenSeen => 'कब?';

  @override
  String get lostWhenNow => 'अभी-अभी';

  @override
  String get lostWhenHour => 'क़रीब एक घंटा पहले';

  @override
  String get lostWhenMorning => 'आज सुबह';

  @override
  String get lostWhenYesterday => 'कल शाम';

  @override
  String get lostNoteLabel => 'पहचानने में मदद करने वाली कोई बात';

  @override
  String get lostNoteHint => 'जैसे: लाल पट्टा, अजनबियों से डरता है';

  @override
  String get lostAlertNearby => '5 किमी के अंदर PawSetu यूज़र्स को अलर्ट भेजें';

  @override
  String get lostAlertNearbyHint =>
      'सिर्फ़ उन्हें मिलेगा जिन्होंने लापता पालतू अलर्ट चालू किए हैं। वे लापता पेज देखेंगे, आपका नंबर कभी नहीं।';

  @override
  String get lostMarkLostConfirm => 'लापता मार्क करें';

  @override
  String lostMarked(String pet) {
    return '$pet को लापता मार्क किया गया। आपके परिवार को बता दिया गया है।';
  }

  @override
  String lostDemoAlert(int count, String area) {
    return 'डेमो: अलर्ट $area के 5 किमी के अंदर $count PawSetu यूज़र्स तक पहुँचा जिन्होंने लापता पालतू अलर्ट चालू किए हैं। संदेश डेमो आउटबॉक्स में हैं; कोई असली अलर्ट नहीं भेजा गया।';
  }

  @override
  String lostBannerTitle(String pet) {
    return '$pet लापता मार्क है';
  }

  @override
  String lostBannerBody(String when, String area) {
    return '$when से, $area के पास।';
  }

  @override
  String lostAlertsSent(int count) {
    return 'पास के $count लोगों को अलर्ट भेजा गया';
  }

  @override
  String get lostSightings => 'कहाँ दिखा';

  @override
  String get lostNoSightings =>
      'अभी तक कहीं नहीं दिखा। लापता पेज और पोस्टर शेयर करें ताकि ज़्यादा लोग मदद कर सकें।';

  @override
  String get lostSightingNoDetails => 'जगह शेयर की गई';

  @override
  String get lostMakePoster => 'पोस्टर बनाएँ (PDF)';

  @override
  String get lostShareLink => 'लापता पेज शेयर करें';

  @override
  String lostShareText(String pet, String area, String url) {
    return 'कृपया मदद करें! $pet $area के पास लापता है। दिखे तो यह खोलें: $url';
  }

  @override
  String lostMarkFound(String pet) {
    return '$pet मिल गया';
  }

  @override
  String lostFoundConfirmTitle(String pet) {
    return 'क्या $pet सुरक्षित घर आ गया?';
  }

  @override
  String get lostFoundConfirmBody =>
      'हम लापता पेज हटा देंगे और आपके परिवार को बता देंगे।';

  @override
  String get lostFoundConfirm => 'हाँ, मिल गया';

  @override
  String lostWelcomeHome(String pet) {
    return 'घर में स्वागत है, $pet!';
  }

  @override
  String lostFamilyTitle(String pet) {
    return '$pet लापता है';
  }

  @override
  String lostFamilyBody(String name, String area) {
    return '$name ने $area के पास लापता मार्क किया। शेयर करने के लिए लापता पेज खोलें।';
  }

  @override
  String lostFoundTitle(String pet) {
    return 'अच्छी ख़बर: $pet सुरक्षित घर आ गया';
  }

  @override
  String lostNearbyTitle(String pet) {
    return 'क्या आपने $pet को देखा? आपके पास एक पालतू लापता है';
  }

  @override
  String lostNearbyBody(String area) {
    return 'आख़िरी बार $area के पास दिखा। फ़ोटो देखने और परिवार को बताने के लिए टैप करें।';
  }

  @override
  String qrTagHint(String pet) {
    return 'इसे $pet के पट्टे के टैग के लिए प्रिंट करें। स्कैन करने वाला आपका नंबर देखे बिना आपको संदेश भेज सकता है।';
  }

  @override
  String qrForPet(String pet) {
    return '$pet के टैग का QR कोड';
  }

  @override
  String get qrPrintTags => 'QR टैग प्रिंट करें (PDF)';

  @override
  String get qrOpenPage => 'पेज खोलें';

  @override
  String qrTagsTitle(String pet) {
    return '$pet के QR टैग';
  }

  @override
  String get qrTagsSubtitle => 'एक टैग काटकर पट्टे पर लगाएँ';

  @override
  String get qrTagsFooter =>
      'PawSetu से बना। टैग स्कैन करने पर परिवार का फ़ोन नंबर कभी नहीं दिखता।';

  @override
  String get qrTagScanLine =>
      'मैं अकेला दिखूँ तो स्कैन करके मेरे परिवार को बताएँ';

  @override
  String posterTitle(String pet) {
    return '$pet का लापता पोस्टर';
  }

  @override
  String posterHeadline(String species) {
    return 'लापता $species';
  }

  @override
  String posterLastSeen(String area, String when) {
    return 'आख़िरी बार $area के पास दिखा, $when';
  }

  @override
  String get posterScan => 'मुझे देखा? इसे स्कैन करें';

  @override
  String get posterScanBody =>
      'संदेश भेजें या बताएँ कि मुझे कहाँ देखा। मेरे परिवार को तुरंत मिलेगा।';

  @override
  String get lostTagInactive => 'यह टैग चालू नहीं है';

  @override
  String get lostTagInactiveHint =>
      'लिंक पुराना या ग़लत हो सकता है। अगर आपको कोई पालतू मिला है, तो उसे पास के क्लिनिक ले जाएँ: वहाँ माइक्रोचिप स्कैन हो सकती है।';

  @override
  String get finderDemoNote =>
      'डेमो पेज: संदेश और जगह डेमो आउटबॉक्स में जाते हैं, किसी असली परिवार को नहीं।';

  @override
  String get finderDemoSuffix => '(डेमो)';

  @override
  String finderLostHeadline(String pet) {
    return '$pet लापता है';
  }

  @override
  String finderLastSeen(String area, String when) {
    return 'आख़िरी बार $area के पास · $when';
  }

  @override
  String finderHello(String pet) {
    return 'नमस्ते, मैं $pet हूँ!';
  }

  @override
  String finderHelloLost(String pet) {
    return 'मैं $pet हूँ। मुझे घर पहुँचने में मदद करें!';
  }

  @override
  String get finderAsk =>
      'अगर मैं अकेला हूँ, तो मेरे परिवार को बताएँ। वे मुझे लेने आएँगे।';

  @override
  String get finderLostAsk =>
      'मेरा परिवार मुझे ढूँढ रहा है। हो सके तो मुझे सुरक्षित रखें और उन्हें संदेश या अपनी जगह भेजें।';

  @override
  String get finderContact => 'मेरे परिवार से संपर्क करें';

  @override
  String get finderShareLocation => 'मेरी जगह शेयर करें';

  @override
  String get finderPrivacy =>
      'PawSetu आपका संदेश पहुँचाता है। परिवार का नंबर निजी रहता है; वापस कॉल चाहिए तो ही अपना नंबर दें।';

  @override
  String get finderTips =>
      'पानी और छाँव दें, पालतू को पट्टे पर या बंद जगह में रखें, और डरे हुए पालतू का पीछा न करें।';

  @override
  String get finderContactHint =>
      'आपका संदेश सीधे PawSetu ऐप में परिवार तक जाता है।';

  @override
  String get finderMessageLabel => 'आपका संदेश';

  @override
  String finderMessageStart(String pet) {
    return 'नमस्ते, मुझे $pet यहाँ मिला: ';
  }

  @override
  String get finderYourName => 'आपका नाम (वैकल्पिक)';

  @override
  String get finderYourPhone => 'आपका फ़ोन (वैकल्पिक)';

  @override
  String get finderPhoneHelper =>
      'सिर्फ़ तब, जब आप चाहें कि परिवार आपको कॉल करे';

  @override
  String get finderSend => 'भेजें';

  @override
  String finderSent(String pet) {
    return '$pet के परिवार को संदेश भेज दिया। धन्यवाद!';
  }

  @override
  String finderLocationSent(String pet) {
    return '$pet के परिवार को जगह भेज दी। धन्यवाद!';
  }

  @override
  String get finderTooMany =>
      'इस टैग पर अभी बहुत संदेश आ चुके हैं। कृपया एक घंटे बाद कोशिश करें।';

  @override
  String get finderWhereSeen => 'आप कहाँ हैं?';

  @override
  String get finderLocationOff =>
      'आपकी लोकेशन बंद है। इलाका चुनें और कोई पहचान की जगह लिखें।';

  @override
  String get finderLandmark => 'पहचान की जगह';

  @override
  String get finderLandmarkHint => 'जैसे: मेट्रो स्टेशन के पास';

  @override
  String finderMessageTitle(String pet) {
    return 'टैग स्कैन करने वाले से $pet के बारे में संदेश';
  }

  @override
  String finderFrom(String from) {
    return 'भेजने वाले: $from';
  }

  @override
  String finderSightingTitle(String pet) {
    return 'किसी ने बताया कि $pet कहाँ दिखा';
  }

  @override
  String get devDemoNote =>
      'डेमो डिवाइस: रीडिंग नकली हैं ताकि आप सब कुछ आज़मा सकें।';

  @override
  String get devAdd => 'डिवाइस जोड़ें';

  @override
  String get devNoneTitle => 'अभी कोई डिवाइस नहीं';

  @override
  String get devNoneBody =>
      'GPS कॉलर, एक्टिविटी ट्रैकर, फ़ीडर, पानी का फ़व्वारा, कैमरा या लिटर बॉक्स जोड़ें।';

  @override
  String get devGpsCollar => 'GPS कॉलर';

  @override
  String get devGpsCollarHint => 'लाइव लोकेशन और सेफ़ ज़ोन अलर्ट';

  @override
  String get devActivityTracker => 'एक्टिविटी ट्रैकर';

  @override
  String get devActivityTrackerHint => 'क़दम और सक्रिय मिनट';

  @override
  String get devFeeder => 'स्मार्ट फ़ीडर';

  @override
  String get devFeederHint => 'समय पर खाना, आप बाहर हों तब भी';

  @override
  String get devFountain => 'पानी का फ़व्वारा';

  @override
  String get devFountainHint => 'पानी का स्तर और फ़िल्टर रिमाइंडर';

  @override
  String get devCamera => 'पेट कैमरा';

  @override
  String get devCameraHint => 'दूर रहकर भी अपने पालतू को देखें';

  @override
  String get devLitterBox => 'स्मार्ट लिटर बॉक्स';

  @override
  String get devLitterBoxHint => 'इस्तेमाल और सफ़ाई रिमाइंडर';

  @override
  String get devPairDemo =>
      'डेमो पेयरिंग: हम आपके लिए एक डेमो डिवाइस ढूँढेंगे। ब्लूटूथ से कुछ नहीं जुड़ता।';

  @override
  String get devStepType => '1. कौन-सा डिवाइस?';

  @override
  String get devStepPet => '2. किस पालतू के लिए?';

  @override
  String get devStepFind => '3. डिवाइस खोजें';

  @override
  String get devStepName => '4. नाम दें';

  @override
  String get devNotForAll =>
      'कुछ पालतू धुंधले हैं क्योंकि यह डिवाइस उनके लिए नहीं है।';

  @override
  String get devSearch => 'डिवाइस खोजें';

  @override
  String get devSearching => 'आसपास खोज रहे हैं…';

  @override
  String devDefaultName(String pet, String type) {
    return '$pet का $type';
  }

  @override
  String get devNameLabel => 'डिवाइस का नाम';

  @override
  String devSafeZoneRadius(int metres) {
    return 'सेफ़ ज़ोन: घर के आसपास $metres मीटर';
  }

  @override
  String get devSafeZoneHint =>
      'कॉलर इस घेरे से बाहर जाते ही आपको अलर्ट मिलेगा।';

  @override
  String get devPair => 'डिवाइस जोड़ें';

  @override
  String devPaired(String name) {
    return '$name जुड़ गया';
  }

  @override
  String get devLiveTitle => 'वर्ज़न 2 में आएगा';

  @override
  String get devLiveBody =>
      'असली डिवाइस लाइव वर्ज़न में जुड़ेंगे। अभी डेमो डिवाइस आज़माएँ।';

  @override
  String get devConnected => 'जुड़ा हुआ';

  @override
  String devInsideZone(int metres) {
    return 'सेफ़ ज़ोन के अंदर · घर से $metres मीटर';
  }

  @override
  String devOutsideZone(int metres) {
    return 'सेफ़ ज़ोन से बाहर! घर से $metres मीटर';
  }

  @override
  String devStepsToday(String steps) {
    return 'आज $steps क़दम';
  }

  @override
  String devNextMeal(String time) {
    return 'अगला खाना $time बजे';
  }

  @override
  String devWaterLevel(int pct) {
    return 'पानी का स्तर: $pct%';
  }

  @override
  String get devCameraReady => 'तैयार';

  @override
  String devLitterVisits(int count) {
    return 'आज $count बार';
  }

  @override
  String devUpdated(String time) {
    return '$time पर अपडेट';
  }

  @override
  String get devLocate => 'अभी ढूँढें';

  @override
  String get devLocated => 'लोकेशन अपडेट हुई';

  @override
  String get devEditZone => 'सेफ़ ज़ोन बदलें';

  @override
  String get devNoZone =>
      'अभी कोई सेफ़ ज़ोन नहीं है। अलर्ट के लिए इसे सेट करें।';

  @override
  String get devAlertSent =>
      'इस पालतू की देखभाल करने वाले सभी को अलर्ट गया (पुश और SMS)।';

  @override
  String get devBackInside => 'सेफ़ ज़ोन में वापस।';

  @override
  String get devDemoControls => 'डेमो कंट्रोल';

  @override
  String get devDemoControlsHint => 'घर से निकले बिना सेफ़ ज़ोन अलर्ट आज़माएँ।';

  @override
  String devDemoWalkOut(String pet) {
    return 'डेमो: $pet को सेफ़ ज़ोन से बाहर ले जाएँ';
  }

  @override
  String devDemoComeHome(String pet) {
    return 'डेमो: $pet को घर वापस लाएँ';
  }

  @override
  String get devToday => 'आज';

  @override
  String devActiveMinutes(int active, int goal) {
    return '$goal में से $active सक्रिय मिनट';
  }

  @override
  String get devNoSessions => 'आज अभी तक कोई सैर या खेल दर्ज नहीं हुआ।';

  @override
  String devWalkSession(int minutes, String km) {
    return 'सैर · $minutes मिनट · $km किमी';
  }

  @override
  String devPlaySession(int minutes) {
    return 'खेल · $minutes मिनट';
  }

  @override
  String get devInRoutine => 'रोज़ की दिनचर्या में जोड़ा गया';

  @override
  String devFlowsToRoutine(String pet) {
    return 'इस डिवाइस से सैर और खेल अपने-आप $pet की रोज़ की दिनचर्या में जुड़ जाते हैं।';
  }

  @override
  String devSynced(int count, String pet) {
    return '$pet की दिनचर्या में $count गतिविधियाँ जोड़ी गईं';
  }

  @override
  String devHopper(int pct) {
    return 'फ़ीडर में बचा खाना: $pct%';
  }

  @override
  String get devMealsToday => 'आज का खाना';

  @override
  String get devNoMealsYet => 'आज अभी तक खाना नहीं दिया गया।';

  @override
  String devMealGrams(int grams) {
    return '$grams ग्राम परोसा';
  }

  @override
  String get devFeedNow => 'अभी थोड़ा खाना दें';

  @override
  String devFed(String pet) {
    return '$pet को थोड़ा खाना दिया गया और आज के खाने में जोड़ा गया।';
  }

  @override
  String devFilterDays(int days) {
    return '$days दिन में फ़िल्टर बदलें';
  }

  @override
  String get devRefillSoon => 'पानी कम हो रहा है। जल्द फ़व्वारा भरें।';

  @override
  String get devCameraPlaceholder =>
      'लाइव वीडियो असली कैमरों के साथ वर्ज़न 2 में आएगा।';

  @override
  String get devSnapshot => 'फ़ोटो लें';

  @override
  String get devSnapshotDemo =>
      'डेमो: असली कैमरा यहाँ आपके पालतू की फ़ोटो भेजता।';

  @override
  String devLastVisit(String time) {
    return 'आख़िरी बार $time बजे';
  }

  @override
  String get devCleanSoon => 'जल्द साफ़ करें';

  @override
  String get devLitterClean => 'साफ़';

  @override
  String get devRemove => 'डिवाइस हटाएँ';

  @override
  String devRemoveTitle(String name) {
    return '$name हटाएँ?';
  }

  @override
  String get devRemoveBody =>
      'यह डेटा भेजना बंद कर देगा। दिनचर्या में दर्ज रिकॉर्ड बने रहेंगे।';

  @override
  String zoneLeftTitle(String pet) {
    return '$pet सेफ़ ज़ोन से बाहर चला गया';
  }

  @override
  String zoneLeftBody(String device, int metres) {
    return '$device: अभी घर से $metres मीटर दूर। देखने के लिए टैप करें।';
  }

  @override
  String zoneBackTitle(String pet) {
    return '$pet सेफ़ ज़ोन में वापस आ गया';
  }

  @override
  String get toxChocolateName => 'चॉकलेट';

  @override
  String get toxChocolateWhy =>
      'इसमें थियोब्रोमीन और कैफ़ीन होते हैं, जिनसे उल्टी, तेज़ धड़कन और दौरे हो सकते हैं। डार्क चॉकलेट और कोको पाउडर सबसे ख़तरनाक हैं।';

  @override
  String get toxGrapesName => 'अंगूर और किशमिश';

  @override
  String get toxGrapesWhy =>
      'थोड़े से अंगूर या किशमिश भी कुत्तों और बिल्लियों में अचानक किडनी फ़ेल कर सकते हैं। पक्षी और खरगोश: कभी-कभार सिर्फ़ छोटा टुकड़ा।';

  @override
  String get toxOnionGarlicName => 'प्याज़ और लहसुन';

  @override
  String get toxOnionGarlicWhy =>
      'कच्चे, पके या पाउडर, करी और ग्रेवी में भी, ये ख़ून की लाल कोशिकाओं को नुकसान पहुँचाते हैं और कुछ दिन बाद कमज़ोरी आती है।';

  @override
  String get toxXylitolName => 'ज़ाइलिटॉल (शुगर-फ़्री मिठास)';

  @override
  String get toxXylitolWhy =>
      'शुगर-फ़्री च्युइंग गम, मिंट, कुछ पीनट बटर और दवाओं में होता है। कुत्तों में इससे अचानक ब्लड शुगर गिरती है और लिवर ख़राब होता है। इसे सभी पालतुओं से दूर रखें।';

  @override
  String get toxAlcoholName => 'शराब';

  @override
  String get toxAlcoholWhy =>
      'थोड़ी सी मात्रा से भी उल्टी, लड़खड़ाहट, साँस की तकलीफ़ और बेहोशी हो सकती है। ख़मीर वाला कच्चा आटा भी पेट में शराब बनाता है।';

  @override
  String get toxCaffeineName => 'चाय, कॉफ़ी और कैफ़ीन';

  @override
  String get toxCaffeineWhy =>
      'चाय, कॉफ़ी, एनर्जी ड्रिंक और कैफ़ीन की गोलियों से बेचैनी, तेज़ धड़कन और दौरे हो सकते हैं।';

  @override
  String get toxAvocadoName => 'एवोकाडो';

  @override
  String get toxAvocadoWhy =>
      'पक्षियों और खरगोशों के लिए बहुत ख़तरनाक: दिल को नुकसान पहुँचा सकता है। कुत्तों और बिल्लियों में गुठली आँतों में फँस सकती है, और छिलका व पत्ते पेट ख़राब करते हैं।';

  @override
  String get toxCookedBonesName => 'पकी हुई हड्डियाँ';

  @override
  String get toxCookedBonesWhy =>
      'पकी हुई चिकन या मटन की हड्डियाँ टूटकर नुकीली हो जाती हैं और गले में फँस सकती हैं या आँतें फाड़ सकती हैं। पकी हड्डियाँ कभी न दें।';

  @override
  String get toxMilkName => 'दूध';

  @override
  String get toxMilkWhy =>
      'ज़्यादातर बड़ी बिल्लियाँ और कुत्ते दूध ठीक से नहीं पचा पाते और उन्हें दस्त हो जाते हैं। पक्षियों और खरगोशों को दूध न दें।';

  @override
  String get toxSaltySnacksName => 'नमकीन स्नैक्स (नमकीन, चिप्स)';

  @override
  String get toxSaltySnacksWhy =>
      'नमकीन, चिप्स और पापड़ से प्यास और उल्टी होती है; ज़्यादा खाने पर नमक का ज़हर चढ़ सकता है। पक्षी इसके लिए ख़ास तौर पर संवेदनशील हैं।';

  @override
  String get toxSpicyFoodName => 'मसालेदार खाना';

  @override
  String get toxSpicyFoodWhy =>
      'मिर्च और मसाले पेट ख़राब करते हैं, उल्टी और दस्त होते हैं। करी में अक्सर प्याज़ और लहसुन भी होते हैं।';

  @override
  String get toxFattyFoodName => 'तला और चिकनाई वाला खाना';

  @override
  String get toxFattyFoodWhy =>
      'तले हुए स्नैक्स, घी, चर्बी और भारी बचा हुआ खाना पैंक्रियाटाइटिस कर सकता है, जो अग्न्याशय की दर्दनाक सूजन है।';

  @override
  String get toxSweetsName => 'मिठाई';

  @override
  String get toxSweetsWhy =>
      'मीठी मिठाइयों से वज़न बढ़ता है और पेट ख़राब होता है, और कई में घी, चॉकलेट, किशमिश या शुगर-फ़्री मिठास होती है।';

  @override
  String get toxFruitSeedsName => 'फलों की गुठली और बीज';

  @override
  String get toxFruitSeedsWhy =>
      'आम की गुठली, सेब के बीज और आलूबुखारा, आड़ू, चेरी की गुठलियाँ गले या आँतों में फँस सकती हैं, और कुछ में साइनाइड होता है।';

  @override
  String get toxTomatoName => 'टमाटर';

  @override
  String get toxTomatoWhy =>
      'थोड़ा पका टमाटर आमतौर पर ठीक है। हरे टमाटर, पत्ते और डंठल नुकसानदायक हैं।';

  @override
  String get toxPeanutsName => 'मूँगफली';

  @override
  String get toxPeanutsWhy =>
      'सिर्फ़ सादी, बिना नमक की मूँगफली, एक बार में कुछ ही। नमकीन या मसाला मूँगफली सुरक्षित नहीं है, और पीनट बटर में ज़ाइलिटॉल नहीं होना चाहिए।';

  @override
  String get toxMangoName => 'आम';

  @override
  String get toxMangoWhy =>
      'पके आम का गूदा छोटे ट्रीट के रूप में ठीक है। छिलका और गुठली हटा दें। ज़्यादा खाने से दस्त होते हैं।';

  @override
  String get toxAppleName => 'सेब';

  @override
  String get toxAppleWhy =>
      'बीज और बीच का हिस्सा हटाकर सेब के टुकड़े एक सेहतमंद, कुरकुरा ट्रीट हैं।';

  @override
  String get toxBananaName => 'केला';

  @override
  String get toxBananaWhy =>
      'छोटा टुकड़ा अच्छा ट्रीट है। इसमें शक्कर ज़्यादा होती है, इसलिए थोड़ा ही दें।';

  @override
  String get toxWatermelonName => 'तरबूज़';

  @override
  String get toxWatermelonWhy =>
      'बिना बीज और छिलके के टुकड़े गर्मियों का ठंडा ट्रीट हैं।';

  @override
  String get toxCarrotName => 'गाजर';

  @override
  String get toxCarrotWhy =>
      'कच्ची या पकी गाजर सेहतमंद ट्रीट है। खरगोशों को गाजर थोड़ी ही दें, क्योंकि इसमें शक्कर होती है।';

  @override
  String get toxRiceName => 'सादे पके चावल';

  @override
  String get toxRiceWhy =>
      'बिना नमक, घी, प्याज़ या मसाले के सादे चावल थोड़ी मात्रा में पेट के लिए हल्के हैं। खरगोशों को चावल नहीं, सूखी घास चाहिए।';

  @override
  String get toxEggName => 'पका हुआ अंडा';

  @override
  String get toxEggWhy =>
      'पूरी तरह पका अंडा प्रोटीन वाला अच्छा ट्रीट है। कच्चा अंडा न दें। खरगोश सिर्फ़ पौधे खाते हैं।';

  @override
  String get toxLilyName => 'लिली';

  @override
  String get toxLilyWhy =>
      'लिली का हर हिस्सा, यहाँ तक कि पराग या फूलदान का पानी भी, बिल्लियों में किडनी फ़ेल कर सकता है। बिल्ली वाले घर में लिली न रखें।';

  @override
  String get toxSagoPalmName => 'साइकस (सागो पाम)';

  @override
  String get toxSagoPalmWhy =>
      'हर हिस्सा ज़हरीला है, बीज सबसे ज़्यादा। इससे उल्टी और लिवर फ़ेल हो सकता है।';

  @override
  String get toxOleanderName => 'कनेर';

  @override
  String get toxOleanderWhy =>
      'कनेर दिल पर असर करता है। कुछ पत्ते या फूल भी जानलेवा हो सकते हैं।';

  @override
  String get toxCastorName => 'अरंडी';

  @override
  String get toxCastorWhy =>
      'अरंडी के बीजों में रिसिन होता है। एक-दो बीज चबाना भी जानलेवा हो सकता है।';

  @override
  String get toxDaturaName => 'धतूरा';

  @override
  String get toxDaturaWhy =>
      'इसके बीज और फूल से तेज़ धड़कन, फैली पुतलियाँ, बेचैनी और दौरे होते हैं।';

  @override
  String get toxLantanaName => 'लैंटाना';

  @override
  String get toxLantanaWhy =>
      'इस आम झाड़ी के बेर और पत्ते लिवर को नुकसान पहुँचा सकते हैं।';

  @override
  String get toxAloeVeraName => 'एलोवेरा';

  @override
  String get toxAloeVeraWhy =>
      'पारदर्शी जेल आमतौर पर ठीक है, लेकिन छिलके के नीचे का कड़वा पीला रस उल्टी और दस्त करता है।';

  @override
  String get toxMoneyPlantName => 'मनी प्लांट';

  @override
  String get toxMoneyPlantWhy =>
      'पत्ते चबाने से मुँह में दर्द, लार गिरना और उल्टी होती है।';

  @override
  String get toxSnakePlantName => 'स्नेक प्लांट';

  @override
  String get toxSnakePlantWhy =>
      'इसे चबाने से लार गिरना, उल्टी और दस्त हो सकते हैं।';

  @override
  String get toxMarigoldName => 'गेंदा';

  @override
  String get toxMarigoldWhy =>
      'गेंदे के फूल चबाने से मुँह में हल्की जलन और पेट ख़राब हो सकता है।';

  @override
  String get toxTulsiName => 'तुलसी';

  @override
  String get toxTulsiWhy =>
      'तुलसी पालतुओं के लिए ज़हरीली नहीं मानी जाती। फिर भी ज़्यादा खाने से पेट ख़राब हो सकता है।';

  @override
  String get toxArecaPalmName => 'एरिका पाम';

  @override
  String get toxArecaPalmWhy => 'पालतुओं के लिए सुरक्षित घरेलू पौधा।';

  @override
  String get toxSpiderPlantName => 'स्पाइडर प्लांट';

  @override
  String get toxSpiderPlantWhy =>
      'ज़हरीला नहीं है, हालाँकि बिल्लियाँ इसे चबाना पसंद करती हैं और थोड़ी उल्टी कर सकती हैं।';

  @override
  String get toxRatPoisonName => 'चूहे मारने की दवा';

  @override
  String get toxRatPoisonWhy =>
      'इससे अंदरूनी ख़ून बहना या दौरे होते हैं, कभी-कभी कई दिन बाद। पैकेट डॉक्टर के पास ले जाएँ।';

  @override
  String get toxHumanMedicinesName => 'इंसानों की दवाएँ';

  @override
  String get toxHumanMedicinesWhy =>
      'पैरासिटामोल और आइबुप्रोफ़ेन जैसी दर्द की दवाएँ पालतुओं के लिए ज़हरीली हैं। पैरासिटामोल की एक गोली भी बिल्ली की जान ले सकती है। सिर्फ़ डॉक्टर की लिखी दवा ही दें।';

  @override
  String get toxMosquitoRepellentName => 'मच्छर कॉइल और लिक्विड वेपोराइज़र';

  @override
  String get toxMosquitoRepellentWhy =>
      'इनका धुआँ पक्षियों के फेफड़ों को नुकसान पहुँचा सकता है। पालतुओं से दूर इस्तेमाल करें और कमरे में हवा आने दें।';

  @override
  String get toxMothballsName => 'नेफ़्थलीन की गोलियाँ';

  @override
  String get toxMothballsWhy =>
      'चबाने पर ज़हरीली हैं, और इनकी गंध पक्षियों को नुकसान पहुँचाती है। इन्हें बंद अलमारी में रखें।';

  @override
  String get toxNonStickFumesName => 'नॉन-स्टिक पैन का धुआँ';

  @override
  String get toxNonStickFumesWhy =>
      'ज़्यादा गर्म नॉन-स्टिक पैन से निकलने वाला धुआँ कुछ ही मिनटों में पक्षी की जान ले सकता है। पक्षियों को रसोई से दूर रखें।';

  @override
  String get toxPhenylName => 'फ़िनाइल और फ़र्श क्लीनर';

  @override
  String get toxPhenylWhy =>
      'फ़िनाइल और कई फ़र्श क्लीनर में फ़ीनॉल होता है, जो ख़ासकर बिल्लियों के लिए ज़हरीला है। पालतुओं के चलने से पहले फ़र्श सूखने दें।';

  @override
  String reviewedBy(String name) {
    return '$name द्वारा जाँचा गया';
  }

  @override
  String get featurePaused => 'यह सुविधा अभी बंद है';

  @override
  String get featurePausedBody =>
      'PawSetu टीम ने इसे रोका है। कृपया बाद में देखें।';

  @override
  String get shopFeatured => 'ख़ास चुने हुए';

  @override
  String admUsers(int owners, int partners) {
    return 'यूज़र: $owners पालतू माता-पिता, $partners पार्टनर';
  }

  @override
  String get admPets => 'पालतू';

  @override
  String get admBookings30 => 'बुकिंग, पिछले 30 दिन';

  @override
  String get admOrderValue30 => 'ऑर्डर की रक़म, पिछले 30 दिन';

  @override
  String get admCommission30 => 'कमाया कमीशन, पिछले 30 दिन';

  @override
  String get admPlusMembers => 'Plus सदस्य';

  @override
  String get admSos30 => 'SOS इस्तेमाल, पिछले 30 दिन';

  @override
  String get admByDay => 'दिन के हिसाब से';

  @override
  String get admByWeek => 'हफ़्ते के हिसाब से';

  @override
  String get admByMonth => 'महीने के हिसाब से';

  @override
  String get admCommissionReport => 'कमीशन रिपोर्ट';

  @override
  String get admNoNumbers => 'अभी कोई आँकड़े नहीं';

  @override
  String get admChartBookingsOrders => 'बुकिंग और ऑर्डर';

  @override
  String get admLegendBookings => 'बुकिंग';

  @override
  String get admLegendOrders => 'ऑर्डर';

  @override
  String get admChartMoney => 'ऑर्डर की रक़म और कमीशन';

  @override
  String get admLegendOrderValue => 'ऑर्डर की रक़म';

  @override
  String get admLegendCommission => 'कमीशन';

  @override
  String get admChartGrowth => 'नए यूज़र, पालतू और Plus सदस्य';

  @override
  String get admLegendUsers => 'नए यूज़र';

  @override
  String get admLegendPets => 'नए पालतू';

  @override
  String get admLegendPlus => 'नए Plus';

  @override
  String get admChartSos => 'SOS इस्तेमाल';

  @override
  String get admLegendSos => 'SOS';

  @override
  String get admTopClinics => 'सबसे ज़्यादा बुक हुए क्लिनिक';

  @override
  String get admTopProducts => 'सबसे ज़्यादा बिके प्रोडक्ट';

  @override
  String get admBookingsUnit => 'बुकिंग';

  @override
  String get admSoldUnit => 'बिके';

  @override
  String admChange(String change) {
    return 'पहले से $change%';
  }

  @override
  String get admNothingYet => 'अभी कुछ नहीं';

  @override
  String get admKindClinic => 'क्लिनिक';

  @override
  String get admStatusRejected => 'नामंज़ूर';

  @override
  String get admStatusSuspended => 'रोका गया';

  @override
  String get admAllKinds => 'सभी';

  @override
  String admWaitingCount(int count) {
    return '$count जाँच का इंतज़ार कर रहे हैं';
  }

  @override
  String get admNoPending => 'मंज़ूरी के लिए कुछ बाकी नहीं';

  @override
  String get admNothingHere => 'यहाँ कुछ नहीं है';

  @override
  String admRejectTitle(String name) {
    return '$name को नामंज़ूर करें?';
  }

  @override
  String admSuspendTitle(String name) {
    return '$name को रोकें?';
  }

  @override
  String get admReasonDocs => 'दस्तावेज़ साफ़ नहीं हैं';

  @override
  String get admReasonRegNo => 'रजिस्ट्रेशन नंबर मेल नहीं खाता';

  @override
  String get admReasonDetails => 'जानकारी अधूरी है';

  @override
  String admApprovedToast(String name) {
    return '$name को मंज़ूरी मिली';
  }

  @override
  String admRejectedToast(String name) {
    return '$name नामंज़ूर';
  }

  @override
  String admSuspendedToast(String name) {
    return '$name को रोका गया';
  }

  @override
  String admAppliedOn(String date) {
    return '$date को आवेदन';
  }

  @override
  String admRegNo(String regNo) {
    return 'रजिस्ट्रेशन नंबर: $regNo';
  }

  @override
  String get admRegMissing => 'रजिस्ट्रेशन नंबर नहीं है';

  @override
  String get admRegLooksRight => 'फ़ॉर्मैट सही लगता है';

  @override
  String get admRegCheck => 'यह नंबर जाँचें';

  @override
  String get admRegHint =>
      'इसे हमेशा राज्य पशु चिकित्सा परिषद के रजिस्टर से मिलाएँ।';

  @override
  String get admKycDocs => 'KYC दस्तावेज़';

  @override
  String get admNoDocs => 'अभी कोई दस्तावेज़ अपलोड नहीं हुआ';

  @override
  String admReasonGiven(String reason) {
    return 'कारण: $reason';
  }

  @override
  String get admApprove => 'मंज़ूर करें';

  @override
  String get admReinstate => 'फिर से मंज़ूर करें';

  @override
  String get admReject => 'नामंज़ूर करें';

  @override
  String get admSuspend => 'रोकें';

  @override
  String get admSampleStamp => 'नमूना';

  @override
  String get admDocDemoNote =>
      'डेमो: सिर्फ़ नमूना दस्तावेज़। असली ऐप में KYC फ़ाइलें यहीं खुलेंगी।';

  @override
  String get admReasonLabel => 'कारण (पार्टनर को दिखेगा)';

  @override
  String get admSearchUsers => 'नाम, ईमेल, फ़ोन या शहर से खोजें';

  @override
  String get admFilterOwners => 'पालतू माता-पिता';

  @override
  String get admFilterPartners => 'पार्टनर';

  @override
  String get admFilterAdmins => 'एडमिन';

  @override
  String admPeopleCount(int count) {
    return '$count लोग';
  }

  @override
  String get plusTrialChip => 'Plus ट्रायल';

  @override
  String get admDeletionPending => 'डिलीट करने का अनुरोध';

  @override
  String admRoleConfirm(String name, String role) {
    return '$name को $role बनाएँ?';
  }

  @override
  String get admRoleChanged => 'भूमिका बदल गई। अगली बार ऐप खोलने पर लागू होगी।';

  @override
  String admSuspendUserTitle(String name) {
    return '$name का खाता रोकें?';
  }

  @override
  String get admReasonAbuse => 'बुरा बर्ताव';

  @override
  String get admReasonFraud => 'पेमेंट में धोखाधड़ी';

  @override
  String get admReasonFake => 'नकली खाता';

  @override
  String admUserSuspended(String name) {
    return '$name का खाता रोका गया';
  }

  @override
  String admUserRestored(String name) {
    return '$name का खाता फिर से चालू है';
  }

  @override
  String get admCity => 'शहर';

  @override
  String get admPlanLabel => 'प्लान';

  @override
  String admPlusTill(String date) {
    return '$date तक Plus';
  }

  @override
  String admTrialTill(String date) {
    return '$date तक Plus ट्रायल';
  }

  @override
  String get admJoined => 'जुड़े';

  @override
  String admDeletionOn(String date) {
    return 'खाता $date को डिलीट होगा';
  }

  @override
  String get admNotYourself =>
      'आप अपनी भूमिका नहीं बदल सकते, न ख़ुद को रोक सकते हैं।';

  @override
  String get admSaveRole => 'भूमिका सेव करें';

  @override
  String get admUnsuspend => 'फिर से चालू करें';

  @override
  String get admSuspendUser => 'खाता रोकें';

  @override
  String get admTabProducts => 'प्रोडक्ट';

  @override
  String get admTabCategories => 'श्रेणियाँ';

  @override
  String get admTabPlaces => 'क्लिनिक और सेवाएँ';

  @override
  String get admTabSellers => 'विक्रेता';

  @override
  String get admTabPartners => 'पार्टनर दुकानें';

  @override
  String get admTabBanners => 'बैनर';

  @override
  String get admSearchProducts => 'प्रोडक्ट, ब्रांड या विक्रेता खोजें';

  @override
  String get admFeatured => 'ख़ास';

  @override
  String get admHidden => 'छिपे हुए';

  @override
  String get admLowStock => 'कम स्टॉक';

  @override
  String get admPartnerLinks => 'पार्टनर लिंक';

  @override
  String admShowingOf(int shown, int total) {
    return '$total में से $shown दिखा रहे हैं। कम करने के लिए खोजें।';
  }

  @override
  String admProductsCount(int count) {
    return '$count प्रोडक्ट';
  }

  @override
  String get admPartnerLink => 'पार्टनर लिंक';

  @override
  String admStock(int count) {
    return 'स्टॉक $count';
  }

  @override
  String get admUnfeature => 'ख़ास से हटाएँ';

  @override
  String get admFeature => 'शॉप में ख़ास दिखाएँ';

  @override
  String get admShowInShop => 'शॉप में दिखाएँ';

  @override
  String admCategoryNote(String food, String other) {
    return 'डिफ़ॉल्ट मार्जिन: खाने पर $food%, बाकी सब पर $other%। किसी भी श्रेणी का अलग मार्जिन रख सकते हैं।';
  }

  @override
  String admMarginCustom(String pct) {
    return 'मार्जिन $pct% (अपनी दर)';
  }

  @override
  String admMarginDefault(String pct) {
    return 'मार्जिन $pct% (डिफ़ॉल्ट)';
  }

  @override
  String admMarginFor(String name) {
    return '$name का मार्जिन';
  }

  @override
  String get admEmptyDefault => 'डिफ़ॉल्ट के लिए ख़ाली छोड़ें';

  @override
  String get admSellerNote =>
      'विक्रेताओं को मंज़ूरी \'मंज़ूरियाँ\' में मिलती है। यहाँ किसी विक्रेता का अपना मार्जिन रख सकते हैं।';

  @override
  String get admMarginStandard => 'सामान्य मार्जिन';

  @override
  String get admEditMargin => 'दर बदलें';

  @override
  String get admPartnersNote =>
      'एफ़िलिएट पार्टनर दुकानें: लोग पार्टनर की वेबसाइट पर ख़रीदते हैं और PawSetu को कमीशन मिलता है।';

  @override
  String admPartnerLine(String pct, int clicks) {
    return 'कमीशन $pct% · $clicks क्लिक';
  }

  @override
  String get admAddPartner => 'पार्टनर दुकान जोड़ें';

  @override
  String get admPartnerName => 'दुकान का नाम';

  @override
  String get admPartnerUrl => 'वेबसाइट (https://…)';

  @override
  String get admPartnerCommission => 'कमीशन';

  @override
  String get admBannersNote =>
      'बैनर होम या शॉप में दिखते हैं। सिर्फ़ चालू बैनर दिखते हैं।';

  @override
  String get admPlaceShop => 'शॉप';

  @override
  String get admPlaceHome => 'होम';

  @override
  String get admBannerShown => 'यह बैनर दिखाएँ';

  @override
  String get admNewBanner => 'नया बैनर';

  @override
  String get admEditBanner => 'बैनर बदलें';

  @override
  String get admBannerTitle => 'शीर्षक';

  @override
  String get admBannerBody => 'छोटा संदेश';

  @override
  String get admBannerLink => 'खुलेगा (ऐप पेज)';

  @override
  String get admBannerLinkHelp =>
      'जैसे /me/plus या /shop/search?q=food। लिंक नहीं चाहिए तो ख़ाली छोड़ें।';

  @override
  String get admToneOffer => 'ऑफ़र (नारंगी)';

  @override
  String get admToneNews => 'ख़बर (हरा)';

  @override
  String get admBannerAudience => 'किसे दिखेगा';

  @override
  String get admAudienceFree => 'सिर्फ़ Free प्लान वालों को';

  @override
  String get admAudiencePlus => 'सिर्फ़ Plus सदस्यों को';

  @override
  String get admPlacesNote =>
      'हर क्लिनिक या सेवा देने वाले का बुकिंग कमीशन। ख़ाली हो तो \'प्लान और सेटिंग्स\' में उसके प्रकार की दर लगेगी।';

  @override
  String admRateCustom(String pct) {
    return 'कमीशन $pct% (अपनी दर)';
  }

  @override
  String admRateStandard(String pct) {
    return 'कमीशन $pct% (सामान्य)';
  }

  @override
  String admRateFor(String name) {
    return '$name का कमीशन';
  }

  @override
  String get hpStatusOpen => 'खुला';

  @override
  String get hpStatusInProgress => 'काम चल रहा है';

  @override
  String get hpStatusResolved => 'हल हो गया';

  @override
  String get admNeedsReply => 'जवाब देना है';

  @override
  String get admNotResolved => 'हल नहीं हुए';

  @override
  String get admEveryone => 'सभी';

  @override
  String get admNoTickets => 'यहाँ कोई टिकट नहीं';

  @override
  String get hpSupportTeam => 'PawSetu सहायता';

  @override
  String get hpNewReply => 'नया जवाब';

  @override
  String hpRefunded(String amount) {
    return '$amount वापस किए';
  }

  @override
  String get admTicketTitle => 'टिकट';

  @override
  String get admTicketMissing => 'यह टिकट उपलब्ध नहीं है';

  @override
  String get admAssignee => 'किसे सौंपा';

  @override
  String get admUnassigned => 'किसी को नहीं सौंपा';

  @override
  String get admConversation => 'बातचीत';

  @override
  String admReplyHint(String name) {
    return '$name को जवाब दें';
  }

  @override
  String admReplySent(String name) {
    return 'जवाब भेजा गया। $name को सूचना मिलेगी।';
  }

  @override
  String get admResolveAfter => 'भेजने के बाद हल हुआ मानें';

  @override
  String admLinkMissing(String type) {
    return 'जुड़ी हुई चीज़ नहीं मिली ($type)।';
  }

  @override
  String admOrderLine(int count, String seller) {
    return '$seller से $count सामान';
  }

  @override
  String admTotal(String amount) {
    return 'कुल $amount';
  }

  @override
  String admRefundDone(String amount, String date) {
    return '$date को $amount वापस किए (डेमो)';
  }

  @override
  String get admRefundButton => 'पैसे वापस करें (डेमो)';

  @override
  String get admRefundAmount => 'वापसी की रक़म';

  @override
  String admRefundMax(String amount) {
    return '$amount तक, जितना चुकाया गया';
  }

  @override
  String admRefundConfirm(String amount, String name) {
    return '$name को $amount वापस करें?';
  }

  @override
  String get admRefundDemoTitle => 'डेमो रिफ़ंड';

  @override
  String admRefundDemoBody(String amount, String name) {
    return '$name को बताया गया कि $amount वापस हुए। यह डेमो है: असली पैसे नहीं गए।';
  }

  @override
  String hpRaisedOn(String date) {
    return '$date को दर्ज';
  }

  @override
  String admAssignedTo(String name) {
    return '$name को सौंपा';
  }

  @override
  String get hpWriteReply => 'जवाब लिखें';

  @override
  String get hpTopicRefund => 'पैसे वापसी';

  @override
  String get hpTopicLate => 'देर हुई या नहीं आए';

  @override
  String get hpTopicQuality => 'क्वालिटी की समस्या';

  @override
  String get hpTopicBehaviour => 'बदतमीज़ी या असुरक्षित बर्ताव';

  @override
  String get hpTopicApp => 'ऐप में समस्या';

  @override
  String get hpTopicOther => 'कुछ और';

  @override
  String get hpLinkBooking => 'बुकिंग';

  @override
  String get hpLinkOrder => 'ऑर्डर';

  @override
  String get hpLinkChat => 'चैट';

  @override
  String get hpLinkOther => 'सामान्य';

  @override
  String admReportsOpen(int count) {
    return 'खुले ($count)';
  }

  @override
  String get admReportsClosed => 'बंद';

  @override
  String get admNoReports => 'जाँचने के लिए कोई रिपोर्ट नहीं';

  @override
  String get admReviewHidden => 'रिव्यू छिपाया गया';

  @override
  String get admReviewRestored => 'रिव्यू फिर से दिखेगा';

  @override
  String get admReportHandled => 'निपटाया गया';

  @override
  String get admReportDismissed => 'रिपोर्ट ख़ारिज';

  @override
  String get admReportReview => 'रिपोर्ट किया गया रिव्यू';

  @override
  String get admReportChat => 'रिपोर्ट की गई चैट';

  @override
  String get admReportContent => 'रिपोर्ट की गई सामग्री';

  @override
  String admReporterSays(String text) {
    return 'रिपोर्ट करने वाले ने कहा: $text';
  }

  @override
  String admReportedBy(String name) {
    return '$name ने रिपोर्ट किया';
  }

  @override
  String admClosedOn(String date) {
    return '$date को बंद';
  }

  @override
  String get admHideReview => 'रिव्यू छिपाएँ';

  @override
  String get admMarkHandled => 'निपटाया हुआ मानें';

  @override
  String get admDismiss => 'ख़ारिज करें';

  @override
  String get admRestoreReview => 'रिव्यू फिर से दिखाएँ';

  @override
  String get admSearchOutbox => 'फ़ोन, ईमेल या संदेश से खोजें';

  @override
  String admAllCount(int count) {
    return 'सभी ($count)';
  }

  @override
  String get admChannelSms => 'SMS';

  @override
  String get admChannelWhatsapp => 'WhatsApp';

  @override
  String get admChannelEmail => 'ईमेल';

  @override
  String get admChannelPush => 'पुश';

  @override
  String get admAuditNote => 'एडमिन पैनल में किया हर बदलाव, नया सबसे ऊपर।';

  @override
  String get admSearchAudit => 'व्यक्ति, काम या चीज़ से खोजें';

  @override
  String get admActApprove => 'पार्टनर को मंज़ूरी दी';

  @override
  String get admActReject => 'पार्टनर को नामंज़ूर किया';

  @override
  String get admActSuspendPartner => 'पार्टनर को रोका';

  @override
  String get admActSuspendUser => 'खाता रोका';

  @override
  String get admActUnsuspendUser => 'खाता फिर से चालू किया';

  @override
  String get admActRole => 'भूमिका बदली';

  @override
  String get admActTicketReply => 'टिकट का जवाब दिया';

  @override
  String get admActTicketStatus => 'टिकट की स्थिति बदली';

  @override
  String get admActTicketAssign => 'टिकट सौंपा';

  @override
  String get admActRefund => 'डेमो रिफ़ंड दिया';

  @override
  String get admActHide => 'रिव्यू छिपाया';

  @override
  String get admActRestore => 'रिव्यू फिर से दिखाया';

  @override
  String get admActDismiss => 'रिपोर्ट ख़ारिज की';

  @override
  String get admActHandled => 'रिपोर्ट निपटाई';

  @override
  String get admActCouponNew => 'कूपन बनाया';

  @override
  String get admActCouponEdit => 'कूपन बदला';

  @override
  String get admActProduct => 'प्रोडक्ट बदला';

  @override
  String get admActBannerNew => 'बैनर बनाया';

  @override
  String get admActBannerEdit => 'बैनर बदला';

  @override
  String get admActSeller => 'विक्रेता बदला';

  @override
  String get admActPartnerStore => 'पार्टनर दुकान बदली';

  @override
  String get admActPlace => 'क्लिनिक या सेवा देने वाला बदला';

  @override
  String get admActSettings => 'सेटिंग्स बदलीं';

  @override
  String get admSettingsNote =>
      'बदलाव तुरंत ऐप में पहुँचते हैं, अपडेट की ज़रूरत नहीं।';

  @override
  String admLastChanged(String when) {
    return 'पिछला बदलाव $when।';
  }

  @override
  String get admPlanPrices => 'प्लान की क़ीमतें';

  @override
  String get admPlusMonthly => 'Plus, महीने का';

  @override
  String get admPlusYearly => 'Plus, साल का';

  @override
  String get admTrialDays => 'मुफ़्त ट्रायल';

  @override
  String get admDaysUnit => 'दिन';

  @override
  String get admPlanLimits => 'प्लान की सीमाएँ';

  @override
  String get admBookingCommission => 'बुकिंग कमीशन';

  @override
  String get admDefaultRate => 'डिफ़ॉल्ट दर';

  @override
  String get admRateClinic => 'पशु क्लिनिक';

  @override
  String get admRateGroomer => 'ग्रूमर';

  @override
  String get admRateTrainer => 'ट्रेनर';

  @override
  String get admRateBoarder => 'बोर्डिंग और देखभाल';

  @override
  String get admRateWalker => 'डॉग वॉकर';

  @override
  String get admProviderRateNote =>
      'किसी क्लिनिक या सेवा देने वाले की अपनी दर भी हो सकती है: कैटलॉग → क्लिनिक और सेवाएँ।';

  @override
  String get admShopMoney => 'शॉप मार्जिन और डिलीवरी';

  @override
  String get admFoodMargin => 'खाने पर मार्जिन';

  @override
  String get admOtherMargin => 'बाकी सामान पर मार्जिन';

  @override
  String get admVideoDiscount => 'वीडियो डॉक्टर फ़ीस पर Plus छूट';

  @override
  String get admDeliveryFee => 'डिलीवरी शुल्क';

  @override
  String get admFreeDeliveryFree => 'इससे ऊपर मुफ़्त डिलीवरी (Free प्लान)';

  @override
  String get admFreeDeliveryPlus => 'इससे ऊपर मुफ़्त डिलीवरी (Plus)';

  @override
  String get admFeatureFlags => 'सुविधाओं के स्विच';

  @override
  String get admReferrals => 'रेफ़रल';

  @override
  String get admReferralReward => 'हर दोस्त का इनाम';

  @override
  String get admCoupons => 'कूपन';

  @override
  String get admNewCoupon => 'नया कूपन';

  @override
  String get admVaccineSchedules => 'टीकों का शेड्यूल';

  @override
  String get admVaccineNote =>
      'अनुमानित समय। डॉक्टर की जाँच के बाद समय बदलें; हर पालतू का शेड्यूल बदल जाएगा।';

  @override
  String get admContentReview => 'सामग्री की डॉक्टर से जाँच';

  @override
  String get admContentReviewNote =>
      'डॉक्टर की जाँच तक इस सामग्री पर \"ड्राफ़्ट, डॉक्टर द्वारा जाँच बाकी\" दिखेगा।';

  @override
  String get admUsesDefault => 'डिफ़ॉल्ट';

  @override
  String get admSavedLive => 'सेव हो गया। ऐप अब नई वैल्यू इस्तेमाल करेगा।';

  @override
  String get admLimit => 'सीमा';

  @override
  String get admLimitPets => 'पालतू';

  @override
  String get admLimitFamily => 'परिवार के सदस्य';

  @override
  String get admLimitTeleVet => 'महीने में टेली-वेट चैट';

  @override
  String get admLimitMessages => 'हर टेली-वेट चैट में संदेश';

  @override
  String get admLimitWords => 'हर संदेश में शब्द';

  @override
  String get admLimitHours => 'टेली-वेट चैट कितनी देर खुली';

  @override
  String get admLimitAi => 'महीने में Ask PawSetu सवाल';

  @override
  String get admLimitStorage => 'स्टोरेज';

  @override
  String get admLimitVideo => 'वीडियो की लंबाई';

  @override
  String get admHoursUnit => 'घंटे';

  @override
  String get admSecondsUnit => 'सेकंड';

  @override
  String get admUnlimited => 'असीमित';

  @override
  String get admUnlimitedNote => '999 या उससे ज़्यादा का मतलब असीमित।';

  @override
  String get admFlagAi => 'Ask PawSetu';

  @override
  String get admFlagAiHint => 'AI पालतू सहायक';

  @override
  String get admFlagDevices => 'जुड़े डिवाइस';

  @override
  String get admFlagDevicesHint => 'कॉलर, फ़ीडर और दूसरे स्मार्ट डिवाइस';

  @override
  String get admFlagLost => 'पास में खोए पालतू के अलर्ट';

  @override
  String get admFlagLostHint => '5 किमी के अंदर के यूज़र को अलर्ट';

  @override
  String get admFlagReferrals => 'दोस्त को बुलाएँ';

  @override
  String get admFlagReferralsHint => 'रेफ़रल कोड और इनाम';

  @override
  String admCouponPercent(int pct, String max) {
    return '$max तक $pct% छूट';
  }

  @override
  String admCouponFlat(String amount) {
    return '$amount की छूट';
  }

  @override
  String admCouponMin(String amount) {
    return 'कम से कम ऑर्डर $amount';
  }

  @override
  String admCouponTill(String date) {
    return '$date तक';
  }

  @override
  String admCouponUses(int used, int max) {
    return '$max में से $used बार इस्तेमाल';
  }

  @override
  String get admCouponActive => 'कूपन चालू';

  @override
  String admPersonalCoupons(int count) {
    return '$count निजी रेफ़रल कूपन यहाँ नहीं दिखाए गए।';
  }

  @override
  String get admCouponCodeHelp => '4 से 16 अक्षर या अंक, जैसे DIWALI20';

  @override
  String get admCouponDescription => 'लोगों को दिखने वाला विवरण';

  @override
  String get admCouponTypePercent => 'प्रतिशत छूट';

  @override
  String get admCouponTypeFlat => 'रक़म की छूट';

  @override
  String get admCouponPercentOff => 'प्रतिशत छूट';

  @override
  String get admCouponAmountOff => 'छूट की रक़म';

  @override
  String get admCouponMaxDiscount => 'अधिकतम छूट';

  @override
  String get admCouponMinOrder => 'कम से कम ऑर्डर';

  @override
  String get admCouponMaxUses => 'कितनी बार इस्तेमाल हो सकता है';

  @override
  String get admCouponValidTill => 'कब तक मान्य';

  @override
  String get admDogSchedule => 'कुत्ते';

  @override
  String get admCatSchedule => 'बिल्लियाँ';

  @override
  String get admAskVetTiming => 'ज़रूरी नहीं, समय डॉक्टर की सलाह से';

  @override
  String admEveryYears(int count) {
    return 'हर $count साल';
  }

  @override
  String admWeeksRange(int from, int to) {
    return 'उम्र $from से $to हफ़्ते';
  }

  @override
  String admBoosterEvery(String name) {
    return '$name बूस्टर: कितने साल में?';
  }

  @override
  String get admYearsUnit => 'साल';

  @override
  String admFromWeek(String name) {
    return '$name: किस हफ़्ते की उम्र से?';
  }

  @override
  String admToWeek(String name) {
    return '$name: किस हफ़्ते की उम्र तक?';
  }

  @override
  String get admWeeksUnit => 'हफ़्ते';

  @override
  String get admAreaFirstAid => 'प्राथमिक उपचार गाइड';

  @override
  String get admAreaToxic => 'ज़हरीले खाने और पौधों की जाँच';

  @override
  String get admAreaVaccines => 'टीकों का शेड्यूल';

  @override
  String get admDraft => 'ड्राफ़्ट';

  @override
  String get admReviewed => 'जाँचा गया';

  @override
  String get admReviewSheetNote =>
      'इस सामग्री की जाँच करने वाले डॉक्टर का नाम और रजिस्ट्रेशन नंबर लिखें।';

  @override
  String get admReviewerName => 'डॉक्टर का नाम और रजिस्ट्रेशन नंबर';

  @override
  String get admMarkReviewed => 'जाँचा हुआ मानें';

  @override
  String get admBackToDraft => 'वापस ड्राफ़्ट करें';

  @override
  String get admKindShop => 'शॉप';

  @override
  String get admKindBooking => 'बुकिंग';

  @override
  String get admDownloadCsv => 'CSV डाउनलोड करें';

  @override
  String get admColPartner => 'पार्टनर';

  @override
  String get admColType => 'प्रकार';

  @override
  String get admColCount => 'गिनती';

  @override
  String get admColGross => 'कुल';

  @override
  String get admColCommission => 'कमीशन';

  @override
  String get admColPayout => 'भुगतान';

  @override
  String get admBookingCommissionShort => 'बुकिंग कमीशन';

  @override
  String get admShopMargin => 'शॉप मार्जिन';

  @override
  String get admPlusRevenue => 'Plus भुगतान';

  @override
  String get admRefunds => 'रिफ़ंड';

  @override
  String get admPlatformTotal => 'PawSetu की कमाई';

  @override
  String get admReportDemoNote =>
      'डेमो पैसे: वर्शन 1 के सारे भुगतान नक़ली हैं। टैक्स के खाने सिर्फ़ जगह के लिए हैं।';

  @override
  String get admByPartner => 'पार्टनर के हिसाब से';

  @override
  String admLineCount(int count) {
    return '$count बिक्री';
  }

  @override
  String admNoteApproved(String name) {
    return '$name को मंज़ूरी मिली, अब पालतू माता-पिता को दिखेगा';
  }

  @override
  String admNoteRejected(String name) {
    return '$name को मंज़ूरी नहीं मिली';
  }

  @override
  String admNoteSuspended(String name) {
    return '$name को रोका गया है';
  }

  @override
  String hpReplyTitle(String subject) {
    return 'सहायता टीम का जवाब: $subject';
  }

  @override
  String hpResolvedTitle(String subject) {
    return 'हल हो गया: $subject';
  }

  @override
  String hpRefundTitle(int amount) {
    return '₹$amount का रिफ़ंड आ रहा है';
  }

  @override
  String get hpRefundBody => 'डेमो रिफ़ंड: असली पैसे नहीं गए।';

  @override
  String hpNewForSupport(String name) {
    return '$name का नया संदेश';
  }

  @override
  String get hpIntroTitle => 'हम मदद के लिए हैं';

  @override
  String get hpIntroBody =>
      'बुकिंग, ऑर्डर या चैट के बारे में शिकायत या सवाल भेजें। हम आमतौर पर एक दिन में जवाब देते हैं।';

  @override
  String get hpIntroPlus =>
      'Plus सदस्यों को पहले मदद: हम आमतौर पर 4 घंटे में जवाब देते हैं।';

  @override
  String get hpRaise => 'शिकायत दर्ज करें';

  @override
  String get hpYourTickets => 'आपके टिकट';

  @override
  String get hpNoTickets => 'अभी कोई टिकट नहीं। कुछ गड़बड़ हो तो यहाँ बताएँ।';

  @override
  String get hpQuickAnswers => 'झटपट जवाब';

  @override
  String get hpFaqRefundQ => 'पैसे वापसी कैसे होती है?';

  @override
  String get hpFaqRefundA =>
      'अगर आपने ऑनलाइन भुगतान किया और समय पर रद्द किया, तो पैसे 5 से 7 कामकाजी दिनों में उसी तरीके में लौट आते हैं। बाकी समस्याओं के लिए शिकायत दर्ज करें, हम जाँचेंगे।';

  @override
  String get hpFaqCancelQ => 'बुकिंग कैसे रद्द करें?';

  @override
  String get hpFaqCancelA =>
      'बुक खोलें, फिर मेरी बुकिंग। बुकिंग चुनें और बुकिंग रद्द करें दबाएँ। क्लिनिक का रद्द करने का समय वहीं दिखता है।';

  @override
  String get hpFaqUrgentQ => 'मेरे पालतू को अभी मदद चाहिए';

  @override
  String get hpFaqUrgentA =>
      'होम पर लाल SOS बटन इस्तेमाल करें: सबसे पास के क्लिनिक तक पहुँचने के लिए इसे 2 सेकंड दबाए रखें। यहाँ जवाब का इंतज़ार न करें।';

  @override
  String get hpFaqDataQ => 'अपना डेटा कैसे लें या डिलीट करें?';

  @override
  String get hpFaqDataA =>
      'मैं, फिर प्राइवेसी सेंटर में जाकर अपना डेटा डाउनलोड करें या खाता डिलीट करें।';

  @override
  String get hpAbout => 'यह किस बारे में है?';

  @override
  String get hpPickItem => 'बुकिंग या ऑर्डर चुनें';

  @override
  String get hpSomethingElse => 'कुछ और';

  @override
  String get hpTopic => 'विषय';

  @override
  String get hpSubject => 'विषय पंक्ति (ज़रूरी नहीं)';

  @override
  String get hpDetails => 'क्या हुआ?';

  @override
  String get hpDetailsHelp =>
      'कम से कम 10 अक्षर। हो सके तो तारीख़, नाम और रक़म लिखें।';

  @override
  String get hpSend => 'सहायता टीम को भेजें';

  @override
  String get hpSent => 'PawSetu सहायता को भेजा गया';

  @override
  String get hpReplyTime => 'हम आमतौर पर एक दिन में जवाब देते हैं।';

  @override
  String get hpReplyTimePlus =>
      'Plus प्राथमिक सहायता: हम आमतौर पर 4 घंटे में जवाब देते हैं।';

  @override
  String get hpTicketTitle => 'आपका टिकट';

  @override
  String get hpResolvedNote =>
      'हल हुआ माना गया। अब भी मदद चाहिए तो नीचे जवाब दें।';

  @override
  String get hpReopenHint => 'अब भी मदद चाहिए? दोबारा खोलने के लिए यहाँ लिखें';

  @override
  String get hpGetHelpBooking => 'इस बुकिंग में मदद लें';

  @override
  String get plusTrialStartedTitle => 'आपका मुफ़्त ट्रायल शुरू हो गया';

  @override
  String plusTrialStartedBody(int days, String date) {
    return '$date तक $days दिन आपके पास Plus की हर सुविधा है। डेमो: कोई पैसा नहीं कटेगा।';
  }

  @override
  String get plusTrialUsed => 'आप मुफ़्त ट्रायल पहले ही ले चुके हैं।';

  @override
  String get plusPayYearly => 'PawSetu Plus, 1 साल';

  @override
  String get plusPayMonthly => 'PawSetu Plus, 1 महीना';

  @override
  String get plusWelcomeTitle => 'PawSetu Plus में स्वागत है!';

  @override
  String plusWelcomeBody(String date) {
    return 'Plus चालू है। यह $date को रिन्यू होगा। यह डेमो भुगतान था: कोई पैसा नहीं गया।';
  }

  @override
  String get plusKeepAfterTrial => 'ट्रायल के बाद भी Plus रखें';

  @override
  String get plusChoosePlan => 'अपना प्लान चुनें';

  @override
  String plusBuy(String amount) {
    return '$amount में Plus लें';
  }

  @override
  String plusStartsAfterTrial(String date) {
    return 'आपका पेड प्लान $date को ट्रायल ख़त्म होने पर शुरू होगा।';
  }

  @override
  String plusStartTrial(int days) {
    return '$days दिन का मुफ़्त ट्रायल शुरू करें';
  }

  @override
  String plusTrialNote(int days) {
    return '$days दिन मुफ़्त। डेमो में कार्ड की ज़रूरत नहीं।';
  }

  @override
  String get plusAutoRenew => 'अपने आप रिन्यू करें';

  @override
  String plusAutoRenewOn(String date) {
    return '$date को रिन्यू होगा';
  }

  @override
  String plusAutoRenewOff(String date) {
    return 'Plus $date तक रहेगा, फिर आप Free पर आ जाएँगे';
  }

  @override
  String get plusDemoNote =>
      'डेमो: कोई पैसा नहीं कटता और असल में कुछ रिन्यू नहीं होता।';

  @override
  String plusOnTrial(int days) {
    return 'Plus ट्रायल: $days दिन बाकी';
  }

  @override
  String plusTrialEnds(String date) {
    return 'आपका ट्रायल $date को ख़त्म होगा।';
  }

  @override
  String get plusYouHavePlus => 'आपके पास PawSetu Plus है';

  @override
  String plusRenewsOn(String date) {
    return '$date को रिन्यू होगा';
  }

  @override
  String plusEndsOn(String date) {
    return '$date को ख़त्म होगा';
  }

  @override
  String get plusYouAreFree => 'आप Free प्लान पर हैं';

  @override
  String get plusFreeBody =>
      'वीडियो डॉक्टर कॉल, असीमित पालतू और बहुत कुछ के लिए अपग्रेड करें।';

  @override
  String plusMinutes(int count) {
    return '$count मिनट';
  }

  @override
  String plusSeconds(int count) {
    return '$count सेकंड';
  }

  @override
  String get plusRowPets => 'पालतू';

  @override
  String get plusRowFamily => 'परिवार के सदस्य';

  @override
  String get plusRowVideo => 'वीडियो डॉक्टर कॉल';

  @override
  String get plusRowTeleVet => 'टेली-वेट चैट';

  @override
  String get plusRowMessages => 'चैट की लंबाई';

  @override
  String get plusRowAi => 'Ask PawSetu';

  @override
  String get plusRowStorage => 'फ़ोटो और दस्तावेज़ स्टोरेज';

  @override
  String get plusRowVideoLength => 'एल्बम में वीडियो की लंबाई';

  @override
  String get plusRowVideoDiscount => 'वीडियो डॉक्टर फ़ीस पर छूट';

  @override
  String get plusRowDelivery => 'मुफ़्त डिलीवरी';

  @override
  String get plusRowSupport => 'सहायता';

  @override
  String get plusYes => 'हाँ';

  @override
  String plusPerMonth(String value) {
    return 'हर महीने $value';
  }

  @override
  String plusMessagesWords(String messages, String words) {
    return '$messages संदेश, हर एक में $words शब्द';
  }

  @override
  String plusAbove(String amount) {
    return '$amount से ऊपर';
  }

  @override
  String get plusStandard => 'सामान्य';

  @override
  String get plusPriority => 'पहले';

  @override
  String get plusYearly => 'सालाना';

  @override
  String get plusMonthly => 'मासिक';

  @override
  String get plusPerYear => 'हर साल';

  @override
  String get plusPerMonthPrice => 'हर महीने';

  @override
  String plusSave(int pct) {
    return '$pct% बचाएँ';
  }

  @override
  String plusTrialEndingSoon(int days) {
    return 'आपका Plus ट्रायल $days दिन में ख़त्म होगा। Plus रखने के लिए प्लान चुनें।';
  }

  @override
  String get referTitle => 'दोस्त को बुलाएँ';

  @override
  String get referInvalid =>
      'यह कोड सही नहीं है, या आप पहले ही कोड इस्तेमाल कर चुके हैं।';

  @override
  String get referDoneTitle => 'कोड लग गया!';

  @override
  String referDoneBody(String amount, String code) {
    return 'आपको और आपके दोस्त को $amount की छूट मिली। आपका कूपन: $code। शॉप में पेमेंट के समय इस्तेमाल करें।';
  }

  @override
  String get referPaused => 'दोस्त को बुलाना अभी रुका हुआ है।';

  @override
  String referHeadline(String amount) {
    return '$amount दें, $amount पाएँ';
  }

  @override
  String referBody(String amount) {
    return 'जब कोई दोस्त आपके कोड से PawSetu में जुड़ता है, तो दोनों को $amount का शॉप कूपन मिलता है।';
  }

  @override
  String get referYourCode => 'आपका कोड';

  @override
  String referShareText(String code, String amount) {
    return 'PawSetu पर मेरे साथ जुड़ें, पालतू माता-पिता का ऐप! मेरा कोड $code इस्तेमाल करें और हम दोनों को PawSetu शॉप में $amount की छूट मिलेगी।';
  }

  @override
  String referFriendsJoined(int count) {
    return 'आपके कोड से $count दोस्त जुड़े';
  }

  @override
  String get referHaveCode => 'दोस्त का कोड है?';

  @override
  String get referEnterCode => 'दोस्त का कोड';

  @override
  String get referApply => 'कोड लगाएँ';

  @override
  String get referYourRewards => 'आपके इनाम कूपन';

  @override
  String referCouponLine(String amount, String min, String date) {
    return '$min से ऊपर के ऑर्डर पर $amount छूट, $date तक';
  }

  @override
  String get referUsed => 'इस्तेमाल हो गया';

  @override
  String get referDemoNote =>
      'डेमो: कूपन डेमो शॉप में चलते हैं। असली पैसे नहीं।';

  @override
  String prvExportReady(int parts, int kb) {
    return 'आपकी फ़ाइल तैयार है: $parts हिस्से, $kb KB।';
  }

  @override
  String get prvExportSubject => 'मेरा PawSetu डेटा';

  @override
  String get prvDeleteConfirmTitle => 'अपना खाता डिलीट करें?';

  @override
  String prvDeleteConfirmBody(String date, int days) {
    return 'आपका खाता, पालतू और रिकॉर्ड $date को डिलीट होंगे। मन बदले तो $days दिनों में साइन इन करके रद्द करें।';
  }

  @override
  String get prvDeleteButton => 'मेरा खाता डिलीट करें';

  @override
  String get prvDeleteRequestedTitle => 'डिलीट होना तय हुआ';

  @override
  String prvDeleteRequestedBody(String date) {
    return 'आपका खाता $date को डिलीट होगा। डेमो: असल में कुछ डिलीट नहीं होगा।';
  }

  @override
  String get prvConsentLost => 'मेरे पास खोए पालतू के अलर्ट';

  @override
  String get prvConsentLostHint => '5 किमी के अंदर कोई पालतू खोए तो अलर्ट पाएँ';

  @override
  String get prvConsentAnalytics => 'PawSetu को बेहतर बनाने में मदद करें';

  @override
  String get prvConsentAnalyticsHint =>
      'बिना नाम का ऐप इस्तेमाल डेटा भेजें (नाम या फ़ोटो नहीं)';

  @override
  String get prvConsentMarketing => 'ऑफ़र और ख़बरें';

  @override
  String get prvConsentMarketingHint => 'कभी-कभी SMS, WhatsApp या ईमेल से ऑफ़र';

  @override
  String get prvConsentPartners =>
      'जिन क्लिनिक में बुक करूँ, उनसे सेहत का सारांश साझा करें';

  @override
  String get prvConsentPartnersHint =>
      'आपके आने से पहले डॉक्टर तैयारी कर पाते हैं';

  @override
  String prvDeletionPending(String date) {
    return 'आपका खाता $date को डिलीट होगा। रखने के लिए दबाएँ।';
  }

  @override
  String get prvCancelDeletion => 'मेरा खाता रखें';

  @override
  String get prvDeletionCancelled => 'डिलीट रद्द। आपका खाता बना रहेगा।';

  @override
  String get prvIntro =>
      'आपका डेटा आपके हाथ में है। चुनें क्या साझा करना है, सबकी कॉपी डाउनलोड करें, या खाता डिलीट करें।';

  @override
  String get prvConsents => 'आप क्या साझा करते हैं';

  @override
  String get prvDownloadTitle => 'मेरा डेटा डाउनलोड करें';

  @override
  String get prvDownloadBody =>
      'अपनी प्रोफ़ाइल, पालतू, सेहत रिकॉर्ड, बुकिंग, ऑर्डर, चैट और बाकी सब की फ़ाइल पाएँ।';

  @override
  String get prvDownloadButton => 'मेरा डेटा डाउनलोड करें';

  @override
  String get prvDeleteTitle => 'मेरा खाता डिलीट करें';

  @override
  String prvDeleteBody(int days) {
    return 'अनुरोध के $days दिन बाद खाता डिलीट होता है। तब तक आप साइन इन करके रद्द कर सकते हैं।';
  }

  @override
  String get prvDemoNote =>
      'डेमो: फ़ाइल आपके डिवाइस पर बनती है। असली ऐप में हम डाउनलोड लिंक ईमेल भी करेंगे।';

  @override
  String get suspTitle => 'आपका खाता रोका गया है';

  @override
  String get suspBody =>
      'हमारी टीम ने यह खाता रोका है। अगर आपको लगता है कि यह ग़लती है, तो PawSetu सहायता से संपर्क करें।';

  @override
  String get suspContact => 'सहायता से संपर्क करें';

  @override
  String get suspContactBody =>
      'डेमो: support@example.com पर लिखें। असली ऐप में यह आपका ईमेल खोलेगा।';

  @override
  String get showMore => 'और दिखाएँ';

  @override
  String get showEarlierMessages => 'पहले के संदेश दिखाएँ';

  @override
  String get offlineBanner =>
      'आप ऑफ़लाइन हैं। सेव की हुई जानकारी चलती रहेगी, और नई एंट्री इंटरनेट आने पर सेव हो जाएँगी।';

  @override
  String albumTitle(String pet) {
    return '$pet की यादें';
  }
}
