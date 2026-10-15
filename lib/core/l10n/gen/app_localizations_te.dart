// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'PawSetu';

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get confirm => 'నిర్ధారించండి';

  @override
  String get next => 'తరువాత';

  @override
  String get skip => 'దాటవేయండి';

  @override
  String get skipForNow => 'ఇప్పటికి దాటవేయండి';

  @override
  String get notNow => 'ఇప్పుడు కాదు';

  @override
  String get or => 'లేదా';

  @override
  String get loading => 'లోడ్ అవుతోంది';

  @override
  String get tryAgain => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get errorTitle => 'ఏదో తప్పు జరిగింది';

  @override
  String get errorBody =>
      'ఇది లోడ్ కాలేదు. ఇంటర్నెట్ చూసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get fieldRequired => 'దయచేసి దీన్ని నింపండి';

  @override
  String get comingSoon => 'త్వరలో వస్తోంది';

  @override
  String comingInPhase(int phase) {
    return 'PawSetuలో ఈ భాగం దశ $phaseలో వస్తుంది. మిగతావన్నీ ఇప్పటికే పనిచేస్తాయి.';
  }

  @override
  String get notFoundTitle => 'ఆ పేజీ దొరకలేదు';

  @override
  String get notFoundBody =>
      'లింక్ పాతది కావచ్చు. మిమ్మల్ని హోమ్‌కి తీసుకెళ్తాం.';

  @override
  String get goHome => 'హోమ్‌కి వెళ్ళండి';

  @override
  String stepOf(int step, int total) {
    return 'దశ $step / $total';
  }

  @override
  String get tabHome => 'హోమ్';

  @override
  String get tabHealth => 'ఆరోగ్యం';

  @override
  String get tabBook => 'బుక్';

  @override
  String get tabShop => 'షాప్';

  @override
  String get tabMe => 'నేను';

  @override
  String get messages => 'సందేశాలు';

  @override
  String get notifications => 'నోటిఫికేషన్లు';

  @override
  String get switchPet => 'పెంపుడు జంతువును మార్చండి';

  @override
  String get allPets => 'అన్ని పెంపుడు జంతువులు';

  @override
  String get addPet => 'పెంపుడు జంతువును జోడించండి';

  @override
  String get petProfile => 'పెంపుడు జంతువు ప్రొఫైల్';

  @override
  String openPetProfile(String name) {
    return '$name ప్రొఫైల్ తెరవండి';
  }

  @override
  String get petParent => 'పెంపుడు తల్లిదండ్రి';

  @override
  String get sosTitle => 'అత్యవసర సహాయం';

  @override
  String get sosSemantic => 'SOS అత్యవసర బటన్';

  @override
  String get sosHoldHint => 'ప్రారంభించడానికి 2 సెకన్లు నొక్కి ఉంచండి';

  @override
  String get sosConfirmTitle => 'అత్యవసర సహాయం కావాలా?';

  @override
  String get sosConfirmBody =>
      'దగ్గరలో తెరిచి ఉన్న క్లినిక్‌లు చూపిస్తాం, మీరు కాల్ చేయవచ్చు లేదా వెళ్ళవచ్చు.';

  @override
  String get sosGetHelp => 'ఇప్పుడే సహాయం పొందండి';

  @override
  String get goodMorning => 'శుభోదయం';

  @override
  String get goodAfternoon => 'శుభ మధ్యాహ్నం';

  @override
  String get goodEvening => 'శుభ సాయంత్రం';

  @override
  String get noPetsTitle => 'మీ మొదటి పెంపుడు జంతువును జోడిద్దాం';

  @override
  String get noPetsBody =>
      'పేరు, జాతి మాత్రమే చాలు. మిగతావి తర్వాత జోడించవచ్చు.';

  @override
  String get quickActions => 'త్వరిత చర్యలు';

  @override
  String get qaBookVet => 'వెట్‌ను బుక్ చేయండి';

  @override
  String get qaLogWalk => 'నడక నమోదు';

  @override
  String get qaAskVet => 'వెట్‌ని అడగండి';

  @override
  String get qaAddPhoto => 'ఫోటో జోడించండి';

  @override
  String weightValue(String value) {
    return '$value';
  }

  @override
  String get speciesDog => 'కుక్క';

  @override
  String get speciesCat => 'పిల్లి';

  @override
  String get speciesBird => 'పక్షి';

  @override
  String get speciesRabbit => 'కుందేలు';

  @override
  String get species => 'జాతి రకం';

  @override
  String get petName => 'పెంపుడు జంతువు పేరు';

  @override
  String ageYears(int years) {
    return '$years సం.';
  }

  @override
  String ageMonths(int months) {
    return '$months నెలలు';
  }

  @override
  String ageYearsMonths(int years, int months) {
    return '$years సం. $months నె.';
  }

  @override
  String get stagePuppy => 'కుక్కపిల్ల';

  @override
  String get stageKitten => 'పిల్లి పిల్ల';

  @override
  String get stageYoung => 'చిన్నది';

  @override
  String get stageAdult => 'పెద్దది';

  @override
  String get stageSenior => 'వృద్ధ';

  @override
  String get genderMale => 'మగ';

  @override
  String get genderFemale => 'ఆడ';

  @override
  String get genderUnknown => 'తెలియదు';

  @override
  String get birdLegalNote =>
      'రోజ్-రింగ్డ్ (ఇండియన్ రింగ్‌నెక్), అలెగ్జాండ్రిన్, ప్లమ్-హెడెడ్ చిలుకలు, మునియాలు, మైనాలు వంటి దేశీయ భారతీయ పక్షులు వన్యప్రాణి (సంరక్షణ) చట్టం, 1972 కింద రక్షించబడ్డాయి. వీటిని చట్టబద్ధంగా పెంచలేరు, అందుకే జాబితాలో లేవు.';

  @override
  String get roleOwner => 'యజమాని';

  @override
  String get roleCoowner => 'సహ-యజమాని';

  @override
  String get roleCarer => 'సంరక్షకుడు';

  @override
  String get roleViewer => 'వీక్షకుడు';

  @override
  String get rolePetParent => 'పెంపుడు తల్లిదండ్రి';

  @override
  String get roleVet => 'పశువైద్యుడు';

  @override
  String get roleClinicAdmin => 'క్లినిక్ అడ్మిన్';

  @override
  String get roleGroomer => 'గ్రూమర్';

  @override
  String get roleTrainer => 'ట్రైనర్';

  @override
  String get roleBoarder => 'బోర్డింగ్ & సిట్టింగ్';

  @override
  String get roleWalker => 'డాగ్ వాకర్';

  @override
  String get roleSeller => 'విక్రేత';

  @override
  String get roleAdmin => 'ప్లాట్‌ఫామ్ అడ్మిన్';

  @override
  String get welcome1Title =>
      'మీ పెంపుడు జంతువుకు కావలసిన ప్రతి సంరక్షణ, ఒకే చోట';

  @override
  String get welcome1Body =>
      'ఇంట్లోని ప్రతి పెంపుడు జంతువు నడక, ఆహారం, మూడ్ ట్రాక్ చేయండి.';

  @override
  String get welcome2Title => 'ఏ టీకా, మందూ మర్చిపోకండి';

  @override
  String get welcome2Body =>
      'సున్నితమైన రిమైండర్లు, ఆరోగ్య రికార్డులు, వెట్‌తో పంచుకోగల రిపోర్ట్.';

  @override
  String get welcome3Title => 'వెట్‌లు, గ్రూమర్లు, షాపులు, అన్నీ కలిసి';

  @override
  String get welcome3Body =>
      'కొన్ని ట్యాప్‌లలో బుక్ చేయండి, వెట్‌తో చాట్ చేయండి, అత్యవసరంలో వెంటనే సహాయం పొందండి.';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String get language => 'భాష';

  @override
  String get signInTitle => 'PawSetuకి స్వాగతం';

  @override
  String get signInSubtitle => 'మీ పెంపుడు జంతువుల సంరక్షణకు సైన్ ఇన్ చేయండి';

  @override
  String get email => 'ఈమెయిల్';

  @override
  String get password => 'పాస్‌వర్డ్';

  @override
  String get passwordHelper => 'కనీసం 6 అక్షరాలు';

  @override
  String get showPassword => 'పాస్‌వర్డ్ చూపించండి';

  @override
  String get hidePassword => 'పాస్‌వర్డ్ దాచండి';

  @override
  String get forgotPassword => 'పాస్‌వర్డ్ మర్చిపోయారా?';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get signOut => 'సైన్ అవుట్';

  @override
  String get signOutConfirm => 'PawSetu నుండి సైన్ అవుట్ చేయాలా?';

  @override
  String get continueWithGoogle => 'Googleతో కొనసాగండి';

  @override
  String get continueWithPhone => 'ఫోన్ నంబర్‌తో కొనసాగండి';

  @override
  String get continueWithApple => 'Appleతో కొనసాగండి';

  @override
  String get newHere => 'PawSetuకి కొత్తా?';

  @override
  String get createAccount => 'ఖాతా సృష్టించండి';

  @override
  String get exploreDemo => 'డెమో యూజర్‌గా చూడండి';

  @override
  String get exploreDemoHint =>
      'ఒక్క ట్యాప్‌తో ప్రతి పాత్ర ప్రయత్నించండి. సైన్-అప్ అవసరం లేదు.';

  @override
  String get signUpTitle => 'మీ ఖాతా సృష్టించండి';

  @override
  String get signUpSubtitle => 'ఒక్క నిమిషం కూడా పట్టదు';

  @override
  String get yourName => 'మీ పేరు';

  @override
  String get termsNote =>
      'ఖాతా సృష్టించడం ద్వారా మీరు నిబంధనలు, గోప్యతా విధానానికి అంగీకరిస్తున్నారు.';

  @override
  String get resetTitle => 'పాస్‌వర్డ్ రీసెట్ చేయండి';

  @override
  String get resetSubtitle => 'కొత్తది ఎంచుకోవడానికి లింక్ ఈమెయిల్ చేస్తాం.';

  @override
  String get sendResetLink => 'రీసెట్ లింక్ పంపండి';

  @override
  String resetSent(String email) {
    return '$emailకి ఖాతా ఉంటే, రీసెట్ లింక్ పంపాం.';
  }

  @override
  String get backToSignIn => 'సైన్ ఇన్‌కి తిరిగి';

  @override
  String get phoneTitle => 'ఫోన్‌తో సైన్ ఇన్ చేయండి';

  @override
  String get phoneSubtitle => 'SMS ద్వారా 6 అంకెల కోడ్ పంపుతాం.';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get phoneInvalid => '10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి';

  @override
  String get sendCode => 'కోడ్ పంపండి';

  @override
  String get enterCodeTitle => 'కోడ్ నమోదు చేయండి';

  @override
  String enterCodeSubtitle(String phone) {
    return '$phoneకి 6 అంకెల కోడ్ పంపాం';
  }

  @override
  String get sixDigitCode => '6 అంకెల కోడ్';

  @override
  String get verifyAndContinue => 'ధృవీకరించి కొనసాగండి';

  @override
  String get changeNumber => 'నంబర్ మార్చండి';

  @override
  String get verifyTitle => 'మీ ఈమెయిల్ చూడండి';

  @override
  String verifySubtitle(String email) {
    return '$emailకి లింక్ పంపాం. అది మీరేనని నిర్ధారించడానికి దాన్ని ట్యాప్ చేయండి.';
  }

  @override
  String get verifyDemoNote =>
      'డెమో: ఈమెయిల్ డెమో అవుట్‌బాక్స్‌కి వెళ్ళింది. తెరవడానికి కింద ట్యాప్ చేయండి.';

  @override
  String get openDemoEmail => 'డెమో ఈమెయిల్ తెరిచి ధృవీకరించండి';

  @override
  String get iveVerified => 'నేను ఈమెయిల్ ధృవీకరించాను';

  @override
  String get resendEmail => 'ఈమెయిల్ మళ్ళీ పంపండి';

  @override
  String get emailResent => 'మళ్ళీ పంపాం. ఇన్‌బాక్స్, స్పామ్ చూడండి.';

  @override
  String get authErrNoAccount =>
      'ఆ ఈమెయిల్‌తో ఖాతా లేదు. స్పెల్లింగ్ చూడండి లేదా ఖాతా సృష్టించండి.';

  @override
  String get authErrWrongPassword =>
      'ఈమెయిల్, పాస్‌వర్డ్ సరిపోలలేదు. మళ్ళీ ప్రయత్నించండి లేదా రీసెట్ చేయండి.';

  @override
  String get authErrEmailInUse =>
      'ఈ ఈమెయిల్‌కి ఇప్పటికే ఖాతా ఉంది. సైన్ ఇన్ చేయండి.';

  @override
  String get authErrWeakPassword => 'కనీసం 6 అక్షరాలు వాడండి';

  @override
  String get authErrInvalidEmail => 'ఇది ఈమెయిల్ చిరునామాలా లేదు';

  @override
  String get authErrInvalidCode =>
      'కోడ్ సరైనది కాదు. SMS చూసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get authErrNetwork => 'ఇంటర్నెట్ లేదు. చూసి మళ్ళీ ప్రయత్నించండి.';

  @override
  String get authErrCancelled => 'సైన్ ఇన్ రద్దయింది.';

  @override
  String get demoTitle => 'డెమో';

  @override
  String get demoBadge => 'డెమో';

  @override
  String demoSocialBody(String provider) {
    return 'డెమో: లైవ్ యాప్‌లో ఇది $provider సైన్ ఇన్ తెరుస్తుంది. ఇక్కడ డెమో ఖాతాతో కొనసాగుతారు.';
  }

  @override
  String demoOtpBody(String code) {
    return 'డెమో: SMS పంపలేదు. కోడ్ $code వాడండి.';
  }

  @override
  String get demoOutboxNote =>
      'డెమో: నిజంగా ఏదీ పంపలేదు. సందేశం అడ్మిన్ ప్యానెల్‌లోని డెమో అవుట్‌బాక్స్‌లో ఉంది.';

  @override
  String get demoLoginNote =>
      'ఇవి డెమో ఖాతాలు. వ్యక్తులు, క్లినిక్‌లు, డేటా కల్పితం. ఇక్కడ ఏదీ నిజం కాదు, డబ్బు కట్ కాదు, సందేశాలు వెళ్ళవు.';

  @override
  String get demoGroupOwners => 'పెంపుడు తల్లిదండ్రులు';

  @override
  String get demoGroupFamily => 'కుటుంబం, పెట్ సిట్టర్';

  @override
  String get demoGroupPartners => 'భాగస్వాములు';

  @override
  String get demoGroupPlatform => 'ప్లాట్‌ఫామ్';

  @override
  String get demoPriya =>
      'బెంగళూరు · Plus · లాబ్రడార్ బ్రూనో, పర్షియన్ పిల్లి మిస్టీ';

  @override
  String get demoRavi =>
      'హైదరాబాద్ · Free · తెలుగు · దేశీ కుక్కపిల్ల సింబా, కాకటీల్ కివీ';

  @override
  String get demoAnjali =>
      'ఢిల్లీ NCR · Free · హిందీ · ఈజీ మోడ్ · కుందేలు కోకో, వృద్ధ పిల్లి టైగర్';

  @override
  String get demoArjun =>
      'ముంబై · Plus · జర్మన్ షెపర్డ్ మ్యాక్స్, బీగల్ కుక్కపిల్ల లూనా';

  @override
  String get demoRohan => 'ప్రియ భర్త · బ్రూనో, మిస్టీల సంరక్షకుడు';

  @override
  String get demoMeera =>
      'అర్జున్ పెట్ సిట్టర్ · యాక్సెస్ 3 రోజుల్లో ముగుస్తుంది';

  @override
  String get demoClinicAdmin =>
      'క్లినిక్ అడ్మిన్ · గోల్కొండ గేట్ పెట్ క్లినిక్, హైదరాబాద్';

  @override
  String get demoVet => 'వెట్ · బుకింగ్‌లు, టెలీ-వెట్ క్యూ, ప్రిస్క్రిప్షన్లు';

  @override
  String get demoGroomer => 'గ్రూమర్ · బుకింగ్ అభ్యర్థనలు స్వీకరిస్తారు';

  @override
  String get demoTrainer => 'డాగ్ ట్రైనర్';

  @override
  String get demoBoarder => 'హోమ్ బోర్డింగ్, పెట్ సిట్టింగ్';

  @override
  String get demoWalker => 'డాగ్ వాకర్ · లైవ్ నడక మార్గం';

  @override
  String get demoSeller => 'విక్రేత · ఉత్పత్తులు, ఆర్డర్లు, చెల్లింపులు';

  @override
  String get demoAdmin =>
      'ప్లాట్‌ఫామ్ అడ్మిన్ · ఆమోదాలు, ఫిర్యాదులు, డెమో అవుట్‌బాక్స్';

  @override
  String demoCredentials(String password, String otp) {
    return 'చేతితో సైన్ ఇన్? ప్రతి డెమో ఖాతా పాస్‌వర్డ్ $password. డెమో ఫోన్ కోడ్: $otp.';
  }

  @override
  String setupHello(String name) {
    return 'హాయ్ $name, సెటప్ చేద్దాం';
  }

  @override
  String get setupHelloNoName => 'సెటప్ చేద్దాం';

  @override
  String get setupPrefsSubtitle =>
      'PawSetu ఎలా కనిపించాలో, చదవాలో ఎంచుకోండి. సెట్టింగ్స్‌లో ఎప్పుడైనా మార్చవచ్చు.';

  @override
  String get setupPetTitle => 'మనం ఎవరిని చూసుకుంటాం?';

  @override
  String get setupPetSubtitle => 'ఇప్పటికి పేరు, జాతి మాత్రమే.';

  @override
  String get setupNotifTitle =>
      'రిమైండర్లు మీ పెంపుడు జంతువును ఆరోగ్యంగా ఉంచుతాయి';

  @override
  String get setupNotifSubtitle =>
      'నోటిఫికేషన్లు అనుమతించండి, వీటి గురించి గుర్తు చేస్తాం:';

  @override
  String get notifReasonVaccines => 'రావలసిన టీకాలు, డీవార్మింగ్';

  @override
  String get notifReasonMedicines => 'మందుల సమయం, ఒక్క ట్యాప్‌తో \'ఇచ్చాను\'';

  @override
  String get notifReasonBookings => 'వెట్, గ్రూమింగ్ అపాయింట్‌మెంట్లు';

  @override
  String get notifReasonMessages => 'వెట్‌లు, సేవా ప్రదాతల జవాబులు';

  @override
  String get allowNotifications => 'నోటిఫికేషన్లు అనుమతించండి';

  @override
  String get settings => 'సెట్టింగ్స్';

  @override
  String get appearance => 'రూపం';

  @override
  String get themeLight => 'లైట్';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get themeSystem => 'సిస్టమ్ డిఫాల్ట్';

  @override
  String get accessibility => 'సౌలభ్యం';

  @override
  String get easyMode => 'ఈజీ మోడ్';

  @override
  String get easyModeHint =>
      'పెద్ద అక్షరాలు, బటన్లు, సరళమైన హోమ్, సులభమైన పదాలు.';

  @override
  String get textSize => 'అక్షరాల పరిమాణం';

  @override
  String get highContrast => 'హై కాంట్రాస్ట్';

  @override
  String get highContrastHint => 'ముదురు అక్షరాలు, స్పష్టమైన అంచులు.';

  @override
  String get notificationChannels => 'రిమైండర్లు, మాధ్యమాలు';

  @override
  String get notificationChannelsHint =>
      'పుష్, ఈమెయిల్, SMS లేదా WhatsApp, నిశ్శబ్ద సమయం';

  @override
  String get demoData => 'డెమో డేటా';

  @override
  String get demoModeOn => 'డెమో మోడ్ ఆన్‌లో ఉంది';

  @override
  String get demoStandaloneHint =>
      'అన్నీ ఈ పరికరంలోనే నడుస్తాయి. నిజమైన డబ్బు, సందేశాలు, కాల్స్ లేవు.';

  @override
  String get demoEmulatorHint =>
      'మీ కంప్యూటర్‌లోని Firebase ఎమ్యులేటర్లకు కనెక్ట్ అయింది.';

  @override
  String get resetDemoData => 'డెమో డేటా రీసెట్ చేయండి';

  @override
  String get resetDemoDataHint => 'మీ మార్పులు తీసేసి మళ్ళీ మొదలుపెట్టండి';

  @override
  String get resetDemoDataConfirm =>
      'ఇది డెమోలో మీరు జోడించినవన్నీ తీసేసి, మిమ్మల్ని సైన్ అవుట్ చేస్తుంది.';

  @override
  String get about => 'గురించి';

  @override
  String aboutVersion(String version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get mapCredit => 'మ్యాప్స్ © OpenStreetMap సహకారులు';

  @override
  String get designGallery => 'డిజైన్ గ్యాలరీ';

  @override
  String get myPets => 'నా పెంపుడు జంతువులు';

  @override
  String get familySharing => 'కుటుంబం, షేరింగ్';

  @override
  String get documentVault => 'డాక్యుమెంట్ వాల్ట్';

  @override
  String get memoryAlbum => 'జ్ఞాపకాల ఆల్బమ్';

  @override
  String get connectedDevices => 'కనెక్ట్ చేసిన పరికరాలు';

  @override
  String get lostPetMode => 'తప్పిపోయిన పెంపుడు జంతువు మోడ్, QR ట్యాగ్';

  @override
  String get expenses => 'ఖర్చులు';

  @override
  String get pawsetuPlus => 'PawSetu Plus';

  @override
  String get helpAndComplaints => 'సహాయం, ఫిర్యాదులు';

  @override
  String get privacyCentre => 'గోప్యతా కేంద్రం';

  @override
  String get planFree => 'Free';

  @override
  String get planPlus => 'Plus';

  @override
  String partnerPortalFor(String role) {
    return 'భాగస్వామి పోర్టల్ · $role';
  }

  @override
  String get pDashboard => 'డాష్‌బోర్డ్';

  @override
  String get pCalendar => 'క్యాలెండర్, స్లాట్లు';

  @override
  String get pRequests => 'బుకింగ్ అభ్యర్థనలు';

  @override
  String get pTeleVetQueue => 'టెలీ-వెట్ క్యూ';

  @override
  String get pServices => 'సేవలు, ధరలు';

  @override
  String get pStaff => 'సిబ్బంది, వెట్‌లు';

  @override
  String get pChat => 'చాట్ ఇన్‌బాక్స్';

  @override
  String get pReviews => 'సమీక్షలు';

  @override
  String get pPayouts => 'చెల్లింపులు';

  @override
  String get pProfileKyc => 'ప్రొఫైల్, KYC';

  @override
  String get pEmergency => 'అత్యవసర సెట్టింగ్స్';

  @override
  String get pProducts => 'ఉత్పత్తులు, స్టాక్';

  @override
  String get pOrders => 'ఆర్డర్లు';

  @override
  String get pReturns => 'రిటర్న్‌లు';

  @override
  String get adminPanel => 'అడ్మిన్ ప్యానెల్';

  @override
  String get aDashboard => 'డాష్‌బోర్డ్';

  @override
  String get aApprovals => 'ఆమోదాలు';

  @override
  String get aUsers => 'వినియోగదారులు';

  @override
  String get aCatalogue => 'కేటలాగ్';

  @override
  String get aComplaints => 'ఫిర్యాదులు, టికెట్లు';

  @override
  String get aModeration => 'మోడరేషన్';

  @override
  String get aSettings => 'ప్లాన్లు, సెట్టింగ్స్';

  @override
  String get aOutbox => 'డెమో అవుట్‌బాక్స్';

  @override
  String get aAudit => 'ఆడిట్ లాగ్';

  @override
  String get accept => 'అంగీకరించండి';

  @override
  String get decline => 'తిరస్కరించండి';

  @override
  String get back => 'వెనక్కి';

  @override
  String get done => 'పూర్తయింది';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get none => 'ఏదీ లేదు';

  @override
  String get you => 'మీరు';

  @override
  String get share => 'షేర్ చేయండి';

  @override
  String get copyLink => 'లింక్ కాపీ చేయండి';

  @override
  String get copied => 'కాపీ అయింది';

  @override
  String get link => 'లింక్';

  @override
  String get phone => 'ఫోన్';

  @override
  String get manage => 'నిర్వహించండి';

  @override
  String get moreOptions => 'మరిన్ని ఎంపికలు';

  @override
  String get saveChanges => 'మార్పులు సేవ్ చేయండి';

  @override
  String get details => 'వివరాలు';

  @override
  String get notAdded => 'ఇంకా జోడించలేదు';

  @override
  String get addPhoto => 'ఫోటో జోడించండి';

  @override
  String get addPhotoTitle => 'ఫోటో జోడించండి';

  @override
  String get takePhoto => 'ఫోటో తీయండి';

  @override
  String get chooseFromGallery => 'గ్యాలరీ నుండి ఎంచుకోండి';

  @override
  String get cropPhoto => 'జరిపి జూమ్ చేయండి';

  @override
  String get cropHint => 'జూమ్‌కి చిటికెడు, జరపడానికి లాగండి';

  @override
  String get editPet => 'పెంపుడు జంతువును సవరించండి';

  @override
  String get petBasicsTitle => 'ప్రాథమిక వివరాలు';

  @override
  String petAboutTitle(String name) {
    return '$name గురించి';
  }

  @override
  String get petAboutSubtitle => 'అన్నీ ఐచ్ఛికం. ఇప్పుడు తెలిసినవి జోడించండి.';

  @override
  String get breed => 'జాతి';

  @override
  String get chooseBreed => 'జాతి ఎంచుకోండి';

  @override
  String get searchBreeds => 'జాతులు వెతకండి';

  @override
  String get breedMixed => 'మిశ్రమ / దేశీ';

  @override
  String get breedOther => 'ఇతర (టైప్ చేయండి)';

  @override
  String get typeBreed => 'జాతి పేరు';

  @override
  String get noBreedMatch => 'సరిపోలలేదు. \'ఇతర (టైప్ చేయండి)\' ప్రయత్నించండి.';

  @override
  String get colourTag => 'రంగు ట్యాగ్';

  @override
  String get colourTagHint => 'ఒక్క చూపులో పెంపుడు జంతువులను గుర్తించడానికి';

  @override
  String get colourAmber => 'అంబర్';

  @override
  String get colourLavender => 'లావెండర్';

  @override
  String get colourSky => 'ఆకాశ నీలం';

  @override
  String get colourRose => 'గులాబీ';

  @override
  String get colourMint => 'పుదీనా ఆకుపచ్చ';

  @override
  String get colourSand => 'ఇసుక రంగు';

  @override
  String get birthday => 'పుట్టినరోజు';

  @override
  String get exactDate => 'ఖచ్చితమైన తేదీ';

  @override
  String get approxAge => 'సుమారు వయస్సు';

  @override
  String get chooseDate => 'తేదీ ఎంచుకోండి';

  @override
  String get years => 'సంవత్సరాలు';

  @override
  String get months => 'నెలలు';

  @override
  String get gender => 'లింగం';

  @override
  String get weight => 'బరువు';

  @override
  String get weightKg => 'బరువు (కి.గ్రా.)';

  @override
  String get weightGrams => 'బరువు (గ్రాములు)';

  @override
  String get age => 'వయస్సు';

  @override
  String get moreDetails => 'మరిన్ని వివరాలు';

  @override
  String get moreDetailsHint =>
      'గుర్తులు, మైక్రోచిప్, అలెర్జీలు, ఆహారం, క్లినిక్';

  @override
  String get markings => 'రంగు, గుర్తులు';

  @override
  String get microchip => 'మైక్రోచిప్ ID';

  @override
  String get neutered => 'స్టెరిలైజ్ చేశారు';

  @override
  String get allergies => 'అలెర్జీలు';

  @override
  String get allergiesHint => 'కామాలతో వేరు చేయండి, ఉదా. చికెన్, గోధుమ';

  @override
  String get dietType => 'ఆహారం';

  @override
  String get regularClinic => 'సాధారణ క్లినిక్';

  @override
  String get temperament => 'స్వభావం గురించి';

  @override
  String get insuranceInVault => 'బీమా పాలసీలు డాక్యుమెంట్ వాల్ట్‌లో ఉంటాయి.';

  @override
  String petAdded(String name) {
    return '$name జోడించబడింది';
  }

  @override
  String petLimitTitle(int limit) {
    return 'ఫ్రీ ప్లాన్‌లో $limit పెంపుడు జంతువుల వరకు';
  }

  @override
  String get petLimitBody =>
      'PawSetu Plusలో అపరిమిత పెంపుడు జంతువులు, వీడియో వెట్ కాల్స్ ఇంకా మరిన్ని.';

  @override
  String petsUsed(int used, int limit) {
    return 'ఫ్రీ ప్లాన్‌లో $limitలో $used పెంపుడు జంతువులు';
  }

  @override
  String get petNotFound => 'ఈ పెంపుడు జంతువు దొరకలేదు';

  @override
  String get petCare => 'సంరక్షణ';

  @override
  String get routine => 'దినచర్య';

  @override
  String get family => 'కుటుంబం';

  @override
  String get petSectionHealth => 'టీకాలు, మందులు, వెట్ సందర్శనలు';

  @override
  String get petSectionRoutine => 'నడకలు, భోజనం, ఆట, మూడ్';

  @override
  String get petSectionDocs => 'సర్టిఫికెట్లు, బీమా, రిపోర్టులు';

  @override
  String get petSectionMemories => 'ఫోటోలు, వీడియోలు, మైలురాళ్లు';

  @override
  String get flatFacedChip => 'వేడికి జాగ్రత్త';

  @override
  String get qrTag => 'QR ట్యాగ్';

  @override
  String get archivePet => 'పెంపుడు జంతువును ఆర్కైవ్ చేయండి';

  @override
  String get restorePet => 'యాక్టివ్ పెంపుడు జంతువుల్లోకి తిరిగి తీసుకురండి';

  @override
  String archiveTitle(String name) {
    return '$nameని ఆర్కైవ్ చేయండి';
  }

  @override
  String get archiveBody =>
      'రికార్డులు, జ్ఞాపకాలు సురక్షితంగా ఉంటాయి. రిమైండర్లు ఆగిపోతాయి.';

  @override
  String get passedAway => 'మరణించింది';

  @override
  String get passedAwayHint => '\"ప్రేమపూర్వక జ్ఞాపకంలో\" కింద ఉంచుతాం';

  @override
  String get rehomed => 'కొత్త ఇంటికి వెళ్ళింది';

  @override
  String get rehomedHint => 'కొత్త కుటుంబం దొరికింది';

  @override
  String get memorialNote => 'కొన్ని మాటలు (ఐచ్ఛికం)';

  @override
  String get memorialNoteHint => 'ఉదా. ఎప్పటికీ మా హృదయాల్లో';

  @override
  String get inLovingMemory => 'ప్రేమపూర్వక జ్ఞాపకంలో';

  @override
  String archivedMemorial(String name) {
    return '$name ప్రేమపూర్వక జ్ఞాపకంలో ఉంది. జ్ఞాపకాలు సురక్షితం.';
  }

  @override
  String archivedRehomed(String name) {
    return '$name ఆర్కైవ్ అయింది';
  }

  @override
  String get people => 'వ్యక్తులు';

  @override
  String get activity => 'కార్యకలాపం';

  @override
  String peopleCount(int count) {
    return '$count మంది';
  }

  @override
  String get invite => 'ఆహ్వానించండి';

  @override
  String get invitesForYou => 'మీకు ఆహ్వానాలు';

  @override
  String get familyRolesHelp =>
      'వీక్షకుడు: అన్నీ చూడగలరు, దినచర్య నమోదు చేయగలరు. సంరక్షకుడు: మందులు ఇవ్వగలరు, సేవలు బుక్ చేయగలరు. సహ-యజమాని: పెంపుడు జంతువును తొలగించడం తప్ప అన్నీ.';

  @override
  String get roleViewerHint => 'అన్నీ చూస్తారు, నడకలు, భోజనం నమోదు చేయగలరు';

  @override
  String get roleCarerHint => 'మందులు ఇస్తారు, సేవలు బుక్ చేస్తారు';

  @override
  String get roleCoownerHint =>
      'పెంపుడు జంతువును తొలగించడం లేదా మిమ్మల్ని తీసేయడం తప్ప అన్నీ';

  @override
  String get role => 'పాత్ర';

  @override
  String inviteTitle(String pet) {
    return '$pet సంరక్షణకు ఎవరినైనా ఆహ్వానించండి';
  }

  @override
  String get temporaryAccess => 'పెట్ సిట్టర్ (యాక్సెస్ ఒక తేదీన ముగుస్తుంది)';

  @override
  String get temporaryAccessHint => 'యాక్సెస్ ఆటోమేటిగ్గా ఆగిపోతుంది';

  @override
  String accessUntil(String date) {
    return '$date వరకు యాక్సెస్';
  }

  @override
  String get accessEnded => 'యాక్సెస్ ముగిసింది';

  @override
  String get sendInvite => 'ఆహ్వానం పంపండి';

  @override
  String get createLink => 'ఆహ్వాన లింక్ సృష్టించండి';

  @override
  String inviteSent(String contact) {
    return '$contactకి ఆహ్వానం పంపాం';
  }

  @override
  String get inviteLinkReady => 'మీ ఆహ్వాన లింక్ సిద్ధం';

  @override
  String inviteShareText(String pet, String link) {
    return 'PawSetuలో $pet సంరక్షణలో నాకు సహాయం చేయండి: $link';
  }

  @override
  String get inviteLink => 'ఆహ్వాన లింక్';

  @override
  String invitePending(String role) {
    return 'అంగీకారం కోసం వేచి ఉంది · $role';
  }

  @override
  String get cancelInvite => 'ఆహ్వానం రద్దు చేయండి';

  @override
  String inviteReceived(String from, String pet, String role) {
    return '$from మిమ్మల్ని $pet సంరక్షణకు $roleగా ఆహ్వానించారు';
  }

  @override
  String inviteAccepted(String pet) {
    return 'ఇప్పుడు మీరు $pet సంరక్షణలో సహాయం చేయవచ్చు';
  }

  @override
  String get inviteInvalid => 'ఈ ఆహ్వానం గడువు ముగిసింది లేదా ఇప్పటికే వాడారు';

  @override
  String get signInToAccept => 'అంగీకరించడానికి సైన్ ఇన్ చేయండి';

  @override
  String get changeRole => 'పాత్ర మార్చండి';

  @override
  String get removeAccess => 'యాక్సెస్ తీసేయండి';

  @override
  String removeAccessConfirm(String name, String pet) {
    return '$petకి $name యాక్సెస్ తీసేయాలా?';
  }

  @override
  String familyLimitTitle(int limit) {
    return 'ఫ్రీ ప్లాన్‌లో $limit మందితో షేర్ చేయవచ్చు';
  }

  @override
  String get familyLimitBody =>
      'PawSetu Plusలో 8 మంది కుటుంబ సభ్యులు సహాయం చేయవచ్చు.';

  @override
  String sharedWithYou(String role) {
    return 'మీతో షేర్ చేశారు · $role';
  }

  @override
  String get noActivityTitle => 'ఇంకా కార్యకలాపం లేదు';

  @override
  String get noActivityBody =>
      'కుటుంబ సభ్యులు నడకలు నమోదు చేసినప్పుడు లేదా మందులు ఇచ్చినప్పుడు ఇక్కడ కనిపిస్తుంది.';

  @override
  String actMedicineGiven(String who, String pet, String detail) {
    return '$who $petకి $detail ఇచ్చారు';
  }

  @override
  String actWalk(String who, String pet, String detail) {
    return '$who $petని నడిపించారు ($detail)';
  }

  @override
  String actMeal(String who, String pet) {
    return '$who $petకి ఆహారం పెట్టారు';
  }

  @override
  String actMemberJoined(String who, String pet) {
    return '$who $pet కుటుంబంలో చేరారు';
  }

  @override
  String actMemberRemoved(String who, String name, String pet) {
    return '$who $nameని $pet కుటుంబం నుండి తీసేశారు';
  }

  @override
  String actRoleChanged(String who, String pet) {
    return '$who $pet కోసం పాత్ర మార్చారు';
  }

  @override
  String actGeneric(String who, String pet) {
    return '$who $petని అప్‌డేట్ చేశారు';
  }

  @override
  String get plusPerkPets => 'అపరిమిత పెంపుడు జంతువులు, 8 మంది కుటుంబ సభ్యులు';

  @override
  String get plusPerkVideo =>
      'వీడియో వెట్ కాల్స్, ఎక్కువ చాట్, వీడియో ఫీజుపై 10% తగ్గింపు';

  @override
  String get plusPerkAi => 'Ask PawSetuలో అపరిమిత ప్రశ్నలు';

  @override
  String get plusPerkStorage => 'ఫోటోలు, డాక్యుమెంట్లకు 25 GB';

  @override
  String get seePlus => 'PawSetu Plus చూడండి';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get seeAll => 'అన్నీ చూడండి';

  @override
  String get today => 'ఈరోజు';

  @override
  String get week => 'వారం';

  @override
  String get month => 'నెల';

  @override
  String get increase => 'పెంచండి';

  @override
  String get decrease => 'తగ్గించండి';

  @override
  String get continueLabel => 'కొనసాగండి';

  @override
  String get noteOptional => 'నోట్ (ఐచ్ఛికం)';

  @override
  String minutesShort(int minutes) {
    return '$minutes ని.';
  }

  @override
  String daysCount(int count) {
    return '$count రోజులు';
  }

  @override
  String get logWalk => 'నడక';

  @override
  String get logPlay => 'ఆట';

  @override
  String get logMeal => 'భోజనం';

  @override
  String get logWater => 'నీళ్ళు';

  @override
  String get logPotty => 'మల విసర్జన';

  @override
  String get logSleep => 'నిద్ర / కునుకు';

  @override
  String get logGrooming => 'గ్రూమింగ్';

  @override
  String get logTraining => 'శిక్షణ';

  @override
  String get logMood => 'మూడ్';

  @override
  String get logWeight => 'బరువు';

  @override
  String get logBehaviour => 'ప్రవర్తన';

  @override
  String logFor(String name) {
    return '$name కోసం నమోదు చేయండి';
  }

  @override
  String get logSomething => 'నమోదు';

  @override
  String logNow(String type) {
    return 'ఇప్పుడు $type నమోదు చేయండి';
  }

  @override
  String logged(String type, String name) {
    return '$name కోసం $type నమోదైంది';
  }

  @override
  String get addDetails => 'వివరాలు జోడించండి';

  @override
  String get amountGrams => 'పరిమాణం (గ్రాములు)';

  @override
  String get distanceKm => 'దూరం (కి.మీ.)';

  @override
  String get durationMinutes => 'వ్యవధి (నిమిషాలు)';

  @override
  String get enterWeight => 'బరువు నమోదు చేయండి';

  @override
  String get chooseOneTag => 'కనీసం ఒక ప్రవర్తన ఎంచుకోండి';

  @override
  String howIsPet(String name) {
    return '$name ఈరోజు ఎలా ఉంది?';
  }

  @override
  String get behaviourPrompt => 'మీరు ఏమి గమనించారు?';

  @override
  String get behaviourHint =>
      'మార్చడానికి మళ్ళీ ట్యాప్ చేయండి: తేలిక, మధ్యస్థం, బలంగా';

  @override
  String get intensityMild => 'తేలిక';

  @override
  String get intensityModerate => 'మధ్యస్థం';

  @override
  String get intensityStrong => 'బలంగా';

  @override
  String get moodHappy => 'సంతోషం';

  @override
  String get moodCalm => 'ప్రశాంతం';

  @override
  String get moodPlayful => 'ఆటపాటలు';

  @override
  String get moodTired => 'అలసట';

  @override
  String get moodAnxious => 'ఆందోళన';

  @override
  String get moodUnwell => 'అనారోగ్యంగా';

  @override
  String get tagPlayful => 'ఆటపాటలు';

  @override
  String get tagCalm => 'ప్రశాంతం';

  @override
  String get tagAnxious => 'ఆందోళన';

  @override
  String get tagLeashPulling => 'పట్టీ లాగడం';

  @override
  String get tagBarking => 'మొరగడం';

  @override
  String get tagAggressionDogs => 'కుక్కలపై దూకుడు';

  @override
  String get tagSeparationAnxiety => 'ఒంటరిగా వదిలితే ఆందోళన';

  @override
  String get tagScratching => 'ఫర్నిచర్ గీకడం';

  @override
  String get tagChewing => 'వస్తువులు నమలడం';

  @override
  String get tagJumping => 'మనుషులపై దూకడం';

  @override
  String get tagHiding => 'దాక్కోవడం';

  @override
  String get tagNotEating => 'సరిగా తినకపోవడం';

  @override
  String todayFor(String name) {
    return '$name రోజు';
  }

  @override
  String get todayAllPets => 'అన్ని పెంపుడు జంతువులకు ఈరోజు';

  @override
  String allDoneToday(String name) {
    return 'ఈరోజు అన్నీ పూర్తయ్యాయి. $name కోసం బాగా చేశారు!';
  }

  @override
  String tasksLeft(int count) {
    return 'ఈరోజు $count పనులు మిగిలాయి';
  }

  @override
  String streakDays(int count) {
    return 'వరుసగా $count రోజులు';
  }

  @override
  String playProgress(int done, int goal) {
    return 'ఆట · $done / $goal ని.';
  }

  @override
  String routineOf(String name) {
    return '$name దినచర్య';
  }

  @override
  String get tabLog => 'లాగ్';

  @override
  String get tabCharts => 'చార్టులు';

  @override
  String get tabBehaviour => 'ప్రవర్తన';

  @override
  String get tabPlan => 'రోజువారీ ప్రణాళిక';

  @override
  String noLogsTitle(String name) {
    return '$name కోసం ఇంకా ఏదీ నమోదు కాలేదు';
  }

  @override
  String get noLogsBody =>
      'భోజనం, నడక లేదా ఆట జోడించడానికి \'నమోదు\' నొక్కండి.';

  @override
  String get deleteLogConfirm => 'ఈ ఎంట్రీ తొలగించాలా?';

  @override
  String get totalWalked => 'నడిచిన దూరం';

  @override
  String get streak => 'వరుస';

  @override
  String get mealsLogged => 'నమోదైన భోజనాలు';

  @override
  String get chartWalkKm => 'నడక (రోజుకు కి.మీ.)';

  @override
  String get chartPlayMinutes => 'ఆట (రోజుకు నిమిషాలు)';

  @override
  String get chartMeals => 'రోజుకు భోజనాలు';

  @override
  String get chartMood => 'మూడ్';

  @override
  String get noMoodLogs => 'ఈ కాలంలో మూడ్ నమోదు కాలేదు.';

  @override
  String get noBehaviourTitle => 'ఇంకా ప్రవర్తన నోట్స్ లేవు';

  @override
  String noBehaviourBody(String name) {
    return 'పట్టీ లాగడం, మొరగడం వంటివి నమోదు చేయండి, $nameలో మార్పులు కనిపిస్తాయి.';
  }

  @override
  String get trendUp => 'పెరుగుతోంది';

  @override
  String get trendDown => 'మెరుగవుతోంది';

  @override
  String get trendSteady => 'స్థిరంగా';

  @override
  String get trendNew => 'కొత్తది';

  @override
  String get shareWithTrainerVet => 'ట్రైనర్ లేదా వెట్‌తో షేర్ చేయండి';

  @override
  String behaviourSummaryTitle(String name) {
    return '$name ప్రవర్తన (PawSetu)';
  }

  @override
  String dailyPlanFor(String name) {
    return '$name రోజువారీ ప్రణాళిక';
  }

  @override
  String get dailyPlanHint => 'దీని ఆధారంగా హోమ్‌లో \'ఈరోజు\' జాబితా వస్తుంది.';

  @override
  String get walksPerDay => 'రోజుకు నడకలు';

  @override
  String get mealsPerDay => 'రోజుకు భోజనాలు';

  @override
  String get playMinutesPerDay => 'రోజుకు ఆట నిమిషాలు';

  @override
  String suggestedGoalsText(String walks, int meals, int play) {
    return 'ఈ పెంపుడు జంతువుకు సూచన: $walksరోజుకు $meals భోజనాలు, $play నిమిషాల ఆట. సుమారు మాత్రమే, వెట్‌ని తప్పక అడగండి.';
  }

  @override
  String suggestedWalks(int count, int minutes) {
    return '$count నడకలు (మొత్తం $minutes ని.), ';
  }

  @override
  String get useSuggested => 'సూచించిన లక్ష్యాలు వాడండి';

  @override
  String get savePlan => 'ప్రణాళిక సేవ్ చేయండి';

  @override
  String get planSaved => 'రోజువారీ ప్రణాళిక సేవ్ అయింది';

  @override
  String get planReminderNote =>
      'ప్రణాళిక రిమైండర్లు సెట్టింగ్స్ → రిమైండర్లు, మాధ్యమాలులో సెట్ చేయండి.';

  @override
  String walkWith(String name) {
    return '$nameతో నడక';
  }

  @override
  String get distance => 'దూరం';

  @override
  String get duration => 'సమయం';

  @override
  String get pace => 'వేగం';

  @override
  String paceValue(String value) {
    return '$value ని./కి.మీ.';
  }

  @override
  String get startWalk => 'నడక ప్రారంభించండి';

  @override
  String get startDemoWalk => 'డెమో నడక ప్రయత్నించండి';

  @override
  String get pause => 'ఆపు';

  @override
  String get resume => 'కొనసాగించు';

  @override
  String get stop => 'ముగించు';

  @override
  String get saveWalk => 'నడక సేవ్ చేయండి';

  @override
  String get discardWalk => 'నడక తీసేయండి';

  @override
  String walkSaved(String name, String distance) {
    return '$name నడక సేవ్ అయింది: $distance';
  }

  @override
  String get walkLeaveTitle => 'ఈ నడక ఆపాలా?';

  @override
  String get walkLeaveBody => 'ఇప్పటి వరకు మార్గం సేవ్ కాదు.';

  @override
  String get walkNotificationTitle => 'PawSetu మీ నడకను ట్రాక్ చేస్తోంది';

  @override
  String get walkNotificationText =>
      'తెరవడానికి ట్యాప్ చేయండి. ఇంటికి చేరాక యాప్‌లో నడక ముగించండి.';

  @override
  String get walkWebNote =>
      'లైవ్ GPS నడకలు Android, iPhone యాప్‌లలో పనిచేస్తాయి. వెబ్‌సైట్‌లో చేతితో నడక జోడించవచ్చు.';

  @override
  String get enterWalkManually => 'చేతితో నడక జోడించండి';

  @override
  String get demoWalkBanner => 'డెమో నడక: మార్గం మీ ఇంటి దగ్గర అనుకరించబడింది.';

  @override
  String get locationWhyTitle => 'మీ లొకేషన్ వాడాలా?';

  @override
  String get locationWhyWalk =>
      'నడిచేటప్పుడు మాత్రమే మార్గం గీయడానికి, దూరం కొలవడానికి వాడతాం.';

  @override
  String get locationOffTitle => 'లొకేషన్ ఆఫ్‌లో ఉంది';

  @override
  String get locationOffBody =>
      'నిజమైన నడక ట్రాక్ చేయడానికి లొకేషన్ ఆన్ చేయండి, లేదా ఇప్పుడు డెమో నడక ప్రయత్నించండి.';

  @override
  String get useDemoWalk => 'డెమో నడక వాడండి';

  @override
  String get walkWeather => 'నడక వాతావరణం';

  @override
  String heatOk(String name) {
    return '$name నడకకు మంచి వాతావరణం';
  }

  @override
  String get heatWarm => 'వేడిగా ఉంది. నడకలు చిన్నగా, నీడలో ఉంచండి.';

  @override
  String heatHot(String name) {
    return '$nameతో ఎక్కువ నడకకు చాలా వేడిగా ఉంది';
  }

  @override
  String heatDanger(String name) {
    return 'ప్రమాదకరమైన వేడి. ఇప్పుడు $name నడక వద్దు';
  }

  @override
  String get heatTipTime =>
      'ఉదయాన్నే (8 గంటల ముందు) లేదా సూర్యాస్తమయం తర్వాత నడిపించండి.';

  @override
  String get heatTipWater =>
      'నీళ్ళు తీసుకెళ్ళండి, వేడి రోడ్లను నివారించండి; పాదాలు కాలుతాయి.';

  @override
  String heatTipFlatFaced(String name) {
    return '$name ముక్కు చిన్నది, మిగతా వాటికంటే త్వరగా వేడెక్కుతుంది.';
  }

  @override
  String get demoTemperature => 'డెమో ఉష్ణోగ్రత';

  @override
  String get add => 'జోడించండి';

  @override
  String get record => 'నమోదు';

  @override
  String get date => 'తేదీ';

  @override
  String get status => 'స్థితి';

  @override
  String get type => 'రకం';

  @override
  String get owner => 'యజమాని';

  @override
  String get from => 'నుండి';

  @override
  String get to => 'వరకు';

  @override
  String get markDone => 'పూర్తయిందని గుర్తించండి';

  @override
  String get indicativeNote =>
      'సుమారు మాత్రమే, ఎల్లప్పుడూ మీ వెట్‌తో నిర్ధారించుకోండి.';

  @override
  String healthOf(String name) {
    return '$name ఆరోగ్యం';
  }

  @override
  String get choosePetForHealth => 'ఒక పెంపుడు జంతువును ఎంచుకోండి';

  @override
  String itemsNeedAttention(int count) {
    return '$count గమనించాలి';
  }

  @override
  String get nextUp => 'తర్వాత ఏమిటి';

  @override
  String nothingDue(String name) {
    return '$nameకి ప్రస్తుతం ఏమీ బాకీ లేదు.';
  }

  @override
  String get nothingDueAll => 'అన్నీ పూర్తి. ఈ వారం ఏమీ బాకీ లేదు.';

  @override
  String get healthReport => 'ఆరోగ్య నివేదిక';

  @override
  String healthReportOf(String name) {
    return '$name ఆరోగ్య నివేదిక';
  }

  @override
  String get medicalCard => 'మెడికల్ కార్డ్';

  @override
  String get statusDone => 'పూర్తి';

  @override
  String get statusOverdue => 'గడువు దాటింది';

  @override
  String get statusDueSoon => 'త్వరలో';

  @override
  String get statusUpcoming => 'రాబోతోంది';

  @override
  String get statusAskVet => 'వెట్‌ని అడగండి';

  @override
  String get askYourVet => 'మీ వెట్‌ని అడగండి';

  @override
  String get dose => 'మోతాదు';

  @override
  String doseN(int n) {
    return 'మోతాదు $n';
  }

  @override
  String get booster => 'బూస్టర్';

  @override
  String get optionalVaccine => 'ఐచ్ఛికం (వెట్ సలహాతో)';

  @override
  String get vaccinations => 'టీకాలు';

  @override
  String get vaccine => 'టీకా';

  @override
  String get vaccineName => 'టీకా పేరు';

  @override
  String get otherVaccine => 'ఇతర టీకా';

  @override
  String recordVaccineFor(String name) {
    return '$name టీకా నమోదు చేయండి';
  }

  @override
  String get dateGiven => 'ఇచ్చిన తేదీ';

  @override
  String get vaccineBrand => 'టీకా బ్రాండ్';

  @override
  String get batchNumber => 'బ్యాచ్ నంబర్';

  @override
  String get vetName => 'వెట్ పేరు';

  @override
  String get clinicName => 'క్లినిక్';

  @override
  String get attachCertificate => 'సర్టిఫికెట్ ఫోటో జోడించండి';

  @override
  String get certificateAttached => 'సర్టిఫికెట్ జోడించారు (వాల్ట్‌లో సేవ్)';

  @override
  String vaccineRecorded(String vaccine, String name) {
    return '$name కోసం $vaccine నమోదైంది';
  }

  @override
  String givenOn(String date) {
    return '$dateన ఇచ్చారు';
  }

  @override
  String dueOn(String date) {
    return '$dateకి రావాలి';
  }

  @override
  String get nextDueShort => 'తదుపరి';

  @override
  String get catchUpNote =>
      'ఇంకా టీకాల చరిత్ర లేదు. క్యాచ్-అప్ ప్లాన్ కోసం వెట్‌ని అడగండి, పాత టీకాలు \'నమోదు\'తో జోడించండి.';

  @override
  String get rabbitVaccineNote =>
      'భారతదేశంలో కుందేళ్ళకు ప్రామాణిక టీకా షెడ్యూల్ లేదు. ఎక్సోటిక్ జంతువుల వెట్‌ని అడగండి; ప్రతి 6–12 నెలలకు ఆరోగ్య పరీక్ష మంచిది.';

  @override
  String get birdVaccineNote =>
      'సాధారణ పెంపుడు పక్షులకు రొటీన్ టీకాలు అవసరం లేదు. ఏటా పక్షుల వెట్ పరీక్ష చేయించండి, గోళ్ళు, ముక్కు గమనించండి.';

  @override
  String get medicines => 'మందులు';

  @override
  String get medicineName => 'మందు';

  @override
  String addMedicineFor(String name) {
    return '$name కోసం మందు జోడించండి';
  }

  @override
  String get editMedicine => 'మందు సవరించండి';

  @override
  String get unit => 'యూనిట్';

  @override
  String get unitTablet => 'మాత్ర';

  @override
  String get unitMl => 'మి.లీ.';

  @override
  String get unitDrops => 'చుక్కలు';

  @override
  String get unitMg => 'మి.గ్రా.';

  @override
  String get unitCapsule => 'క్యాప్సూల్';

  @override
  String get unitSachet => 'సాచెట్';

  @override
  String get frequency => 'ఎంత తరచుగా';

  @override
  String get freqOnce => 'రోజుకు ఒకసారి';

  @override
  String get freqTwice => 'రోజుకు రెండుసార్లు';

  @override
  String freqEveryHours(int hours) {
    return 'ప్రతి $hours గంటలకు';
  }

  @override
  String get freqWeekly => 'వారానికి ఒకసారి';

  @override
  String get freqCustom => 'అనుకూల సమయాలు';

  @override
  String get doseTimes => 'మోతాదు సమయాలు';

  @override
  String get firstDoseAt => 'మొదటి మోతాదు';

  @override
  String get addTime => 'సమయం జోడించండి';

  @override
  String get withFood => 'ఆహారంతో';

  @override
  String get startDate => 'ప్రారంభ తేదీ';

  @override
  String get noEndDate => 'ముగింపు తేదీ లేదు';

  @override
  String endsOn(String date) {
    return '$dateన ముగుస్తుంది';
  }

  @override
  String get setEndDate => 'ముగింపు తేదీ సెట్ చేయండి';

  @override
  String get stockCount => 'స్టాక్‌లో మోతాదులు (ఐచ్ఛికం)';

  @override
  String get stockHint => '5 మిగిలినప్పుడు రీఫిల్ చేయమని గుర్తు చేస్తాం';

  @override
  String medicineSaved(String name) {
    return '$name సేవ్ అయింది';
  }

  @override
  String noMedicines(String name) {
    return '$name ఏ మందూ తీసుకోవడం లేదు.';
  }

  @override
  String nextDoseAt(String time) {
    return 'తదుపరి: $time';
  }

  @override
  String stockLeft(int count) {
    return '$count మిగిలాయి';
  }

  @override
  String get refill => 'రీఫిల్';

  @override
  String refillNeeded(String name) {
    return '$name రీఫిల్ చేయండి';
  }

  @override
  String get given => 'ఇచ్చాను';

  @override
  String get snooze15 => '15 ని. తర్వాత';

  @override
  String doseGiven(String name) {
    return '$name ఇచ్చినట్టు గుర్తించాం';
  }

  @override
  String get doseSkipped => 'మోతాదు దాటవేశారు';

  @override
  String get doseSnoozed => '15 నిమిషాల్లో గుర్తు చేస్తాం';

  @override
  String todayAt(String time) {
    return 'ఈరోజు, $time';
  }

  @override
  String overdueBy(int days) {
    return '$days రోజులు ఆలస్యం';
  }

  @override
  String get dueToday => 'ఈరోజు';

  @override
  String dueInDays(int days) {
    return '$days రోజుల్లో';
  }

  @override
  String get prevention => 'డీవార్మింగ్, ఈగలు/పేలు';

  @override
  String get deworming => 'డీవార్మింగ్';

  @override
  String get fleaTick => 'ఈగలు, పేలు నివారణ';

  @override
  String lastDone(String date) {
    return 'చివరిసారి $date';
  }

  @override
  String nextDue(String date) {
    return 'తదుపరి $date';
  }

  @override
  String get tickFeverNote =>
      'భారతదేశంలో టిక్ ఫీవర్ సాధారణం. ఈగలు, పేలు నివారణ సమయానికి చేయండి.';

  @override
  String get productUsed => 'వాడిన ఉత్పత్తి';

  @override
  String get weightNeedsTwo =>
      'చార్ట్ చూడటానికి రెండు లేదా ఎక్కువ బరువులు జోడించండి.';

  @override
  String weightRangeNote(String range) {
    return 'ఆకుపచ్చ పట్టీ: సుమారు ఆరోగ్యకర పరిధి $range. వెట్‌ని తప్పక అడగండి.';
  }

  @override
  String get weightGrowingNote =>
      'ఇంకా పెరుగుతోంది. సరైన బరువు మీ వెట్ చెబుతారు.';

  @override
  String get vetVisit => 'వెట్ సందర్శన';

  @override
  String get vetVisits => 'వెట్ సందర్శనలు';

  @override
  String get reasonForVisit => 'సందర్శన కారణం';

  @override
  String get diagnosis => 'నిర్ధారణ లేదా సలహా';

  @override
  String get noVisits => 'ఇంకా వెట్ సందర్శనలు నమోదు కాలేదు.';

  @override
  String get symptom => 'లక్షణం';

  @override
  String get symptomDiary => 'లక్షణాల డైరీ';

  @override
  String get noSymptoms => 'లక్షణాలు లేవు. మంచి వార్త.';

  @override
  String get severity => 'ఎంత తీవ్రంగా ఉంది?';

  @override
  String get severeSymptomNote =>
      'శ్వాస సమస్య, కుప్పకూలడం, మూర్ఛ లేదా విషం తిన్నట్టు అనుమానం ఉంటే ఇప్పుడే SOS వాడండి.';

  @override
  String get shareWithVet => 'వెట్‌తో షేర్ చేయండి';

  @override
  String symptomShareTitle(String name) {
    return '$name లక్షణాల డైరీ (PawSetu)';
  }

  @override
  String get symVomiting => 'వాంతులు';

  @override
  String get symDiarrhoea => 'విరేచనాలు';

  @override
  String get symNotEating => 'తినడం లేదు';

  @override
  String get symLimping => 'కుంటడం';

  @override
  String get symItching => 'దురద';

  @override
  String get symCoughing => 'దగ్గు';

  @override
  String get symLethargy => 'చాలా నీరసం';

  @override
  String get symSneezing => 'తుమ్ములు';

  @override
  String get symOther => 'ఇతర';

  @override
  String savedFor(String what, String name) {
    return '$name కోసం $what సేవ్ అయింది';
  }

  @override
  String get reminders => 'రిమైండర్లు';

  @override
  String get noReminders => 'అనుకూల రిమైండర్లు లేవు.';

  @override
  String newReminderFor(String name) {
    return '$name కోసం కొత్త రిమైండర్';
  }

  @override
  String get reminderTitle => 'దేని గురించి గుర్తు చేయాలి?';

  @override
  String get repeat => 'పునరావృతం';

  @override
  String get repeatNone => 'పునరావృతం వద్దు';

  @override
  String get repeatMonthly => 'ప్రతి నెల';

  @override
  String get repeatYearly => 'ప్రతి సంవత్సరం';

  @override
  String get reminderSet => 'రిమైండర్ సెట్ అయింది';

  @override
  String get remTypeLicence => 'లైసెన్స్ పునరుద్ధరణ';

  @override
  String get remTypeInsurance => 'బీమా పునరుద్ధరణ';

  @override
  String get remTypeGrooming => 'గ్రూమింగ్ సమయం';

  @override
  String get remTypeNailTrim => 'గోళ్ళు కత్తిరించడం';

  @override
  String get remTypeBirthday => 'పుట్టినరోజు';

  @override
  String get remTypeCustom => 'ఇంకేదైనా';

  @override
  String remVaccineDue(String name, String vaccine) {
    return '$name $vaccine త్వరలో ఇవ్వాలి';
  }

  @override
  String remVaccineOverdue(String name, String vaccine) {
    return '$name $vaccine గడువు దాటింది';
  }

  @override
  String remMedicine(String name, String medicine) {
    return '$name $medicine సమయం';
  }

  @override
  String remRefill(String medicine, String name) {
    return '$name కోసం $medicine తక్కువగా ఉంది';
  }

  @override
  String remDeworming(String name) {
    return '$name డీవార్మింగ్ సమయం';
  }

  @override
  String remFleaTick(String name) {
    return '$name ఈగలు, పేలు నివారణ సమయం';
  }

  @override
  String get remTapToOpen => 'PawSetu తెరవడానికి ట్యాప్ చేయండి';

  @override
  String get remSnoozed => '15 నిమిషాలు వాయిదా';

  @override
  String get markAllRead => 'అన్నీ చదివినట్టు';

  @override
  String get filterAll => 'అన్నీ';

  @override
  String get filterUnread => 'చదవనివి';

  @override
  String get filterBookings => 'బుకింగ్‌లు';

  @override
  String get filterOrdersMessages => 'ఆర్డర్లు, సందేశాలు';

  @override
  String get noNotificationsTitle => 'అన్నీ చూశారు';

  @override
  String get noNotificationsBody => 'రిమైండర్లు, అప్‌డేట్లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get ntVaccines => 'టీకాలు';

  @override
  String get ntMedicines => 'మందులు';

  @override
  String get ntDeworming => 'డీవార్మింగ్, ఈగలు/పేలు';

  @override
  String get ntBookings => 'బుకింగ్‌లు';

  @override
  String get ntRoutine => 'రోజువారీ దినచర్య';

  @override
  String get ntCustom => 'నా రిమైండర్లు';

  @override
  String get chPush => 'పుష్';

  @override
  String get chEmail => 'ఈమెయిల్';

  @override
  String get chSms => 'SMS';

  @override
  String get chWhatsApp => 'WhatsApp';

  @override
  String get channelsDemoNote =>
      'డెమో: ఫోన్‌లో పుష్ రిమైండర్లు నిజమైనవి. ఈమెయిల్, SMS, WhatsApp పంపకుండా డెమో అవుట్‌బాక్స్‌కి వెళ్తాయి.';

  @override
  String get quietHours => 'నిశ్శబ్ద సమయం';

  @override
  String get quietHoursOn => 'రాత్రి ఇబ్బంది పెట్టవద్దు';

  @override
  String get quietHoursHint =>
      'రిమైండర్లు ఉదయం వరకు ఆగుతాయి. మందుల రిమైండర్లు ఎప్పుడూ సమయానికే.';

  @override
  String get notificationsOn => 'నోటిఫికేషన్లు ఆన్';

  @override
  String get notificationsOffHint =>
      'నోటిఫికేషన్లు ఆఫ్. ఫోన్ సెట్టింగ్స్‌లో ఆన్ చేయవచ్చు.';

  @override
  String get preparingDocument => 'మీ డాక్యుమెంట్ సిద్ధమవుతోంది…';

  @override
  String get sharePdf => 'PDF షేర్ లేదా సేవ్ చేయండి';

  @override
  String generatedOn(String date) {
    return '$dateన రూపొందించారు';
  }

  @override
  String get reportFooter =>
      'PawSetuతో రూపొందించారు · డెమో డేటా · సుమారు మాత్రమే, వెట్‌తో నిర్ధారించుకోండి';

  @override
  String get ownerAndClinic => 'యజమాని, క్లినిక్';

  @override
  String get noKnownAllergies => 'తెలిసిన అలెర్జీలు లేవు';

  @override
  String get currentMedicines => 'ప్రస్తుత మందులు';

  @override
  String get rabiesVaccine => 'రేబీస్ టీకా';

  @override
  String get notRecorded => 'నమోదు కాలేదు';

  @override
  String medicalCardUpdated(String date) {
    return '$dateన అప్‌డేట్';
  }

  @override
  String get medicalCardOffline =>
      'ఈ కార్డ్ ఇంటర్నెట్ లేకుండా పనిచేస్తుంది. వెట్, బోర్డింగ్ సెంటర్ లేదా ఎయిర్‌పోర్ట్‌లో చూపించండి.';

  @override
  String get bookTitle => 'సంరక్షణ బుక్ చేయండి';

  @override
  String get findAVet => 'దగ్గరలోని వెట్‌ను కనుగొనండి';

  @override
  String get kindVet => 'వెట్ క్లినిక్';

  @override
  String get kindGrooming => 'గ్రూమింగ్';

  @override
  String get kindTraining => 'శిక్షణ';

  @override
  String get kindBoarding => 'బోర్డింగ్';

  @override
  String get kindWalking => 'డాగ్ వాకింగ్';

  @override
  String get teleVet => 'టెలి-వెట్';

  @override
  String get clinicFinderMap => 'మ్యాప్‌లో క్లినిక్‌లు';

  @override
  String get clinicFinderHint =>
      'మీ చుట్టూ తెరిచి ఉన్న క్లినిక్‌లు, 24x7 అత్యవసర సేవలు చూడండి.';

  @override
  String get myBookings => 'నా బుకింగ్‌లు';

  @override
  String get upcoming => 'రాబోయేవి';

  @override
  String get requests => 'అభ్యర్థనలు';

  @override
  String get past => 'గతవి';

  @override
  String get noUpcomingBookings => 'రాబోయే బుకింగ్‌లు లేవు.';

  @override
  String get noRequests => 'వేచి ఉన్న అభ్యర్థనలు లేవు.';

  @override
  String get noPastBookings => 'ఇంకా గత బుకింగ్‌లు లేవు.';

  @override
  String get bookSomething => 'ఏదైనా బుక్ చేయండి';

  @override
  String get viewBooking => 'బుకింగ్ చూడండి';

  @override
  String get backToBook => 'బుక్‌కి తిరిగి';

  @override
  String get searchByNameOrArea => 'పేరు లేదా ప్రాంతంతో వెతకండి';

  @override
  String get useMyLocation => 'నా లొకేషన్ వాడండి';

  @override
  String get nearYou => 'మీ దగ్గర';

  @override
  String get chooseArea => 'మీ ప్రాంతాన్ని ఎంచుకోండి';

  @override
  String get locationWhyClinics =>
      'క్లినిక్‌లు, సేవలను దూరం ప్రకారం చూపడానికే PawSetu మీ లొకేషన్ వాడుతుంది. దాన్ని సేవ్ చేయదు.';

  @override
  String get locationFallback =>
      'మీ లొకేషన్ దొరకలేదు. మీరు ఎంచుకున్న ప్రాంతం చూపిస్తున్నాం.';

  @override
  String get filters => 'ఫిల్టర్లు';

  @override
  String get clearFilters => 'ఫిల్టర్లు తీసివేయండి';

  @override
  String get showResults => 'ఫలితాలు చూపండి';

  @override
  String get sortBy => 'క్రమం';

  @override
  String get sortNearest => 'అత్యంత దగ్గర';

  @override
  String get sortRating => 'అత్యధిక రేటింగ్';

  @override
  String get sortSlot => 'త్వరగా స్లాట్';

  @override
  String get sortFee => 'తక్కువ ఫీజు';

  @override
  String get openNow => 'ఇప్పుడు తెరిచి ఉంది';

  @override
  String get openNowChip => 'తెరిచి ఉంది';

  @override
  String get closedChip => 'మూసి ఉంది';

  @override
  String get open24x7 => '24x7';

  @override
  String get open24x7Long => '24 గంటలు, వారం మొత్తం తెరిచి ఉంటుంది';

  @override
  String get teleVetAvailable => 'టెలి-వెట్ అందుబాటులో';

  @override
  String get homeVisit => 'ఇంటికి వచ్చి సేవ';

  @override
  String get rating => 'రేటింగ్';

  @override
  String get rating4plus => '4★ పైన';

  @override
  String get speciesTreated => 'చికిత్స చేసే జంతువులు';

  @override
  String get languagesSpoken => 'మాట్లాడే భాషలు';

  @override
  String get consultationFee => 'కన్సల్టేషన్ ఫీజు';

  @override
  String upTo(String amount) {
    return '$amount వరకు';
  }

  @override
  String feeFrom(String amount) {
    return '$amount నుండి';
  }

  @override
  String resultsCount(int count) {
    return '$count ఫలితాలు';
  }

  @override
  String get listView => 'జాబితా';

  @override
  String get mapView => 'మ్యాప్';

  @override
  String get noResultsTitle => 'ఏదీ సరిపోలలేదు';

  @override
  String get noResultsBody =>
      'వేరే ప్రాంతం ప్రయత్నించండి లేదా కొన్ని ఫిల్టర్లు తీసేయండి.';

  @override
  String reviewsCount(int count) {
    return '$count సమీక్షలు';
  }

  @override
  String get call => 'కాల్ చేయండి';

  @override
  String get directions => 'దారి';

  @override
  String get bookNow => 'ఇప్పుడే బుక్ చేయండి';

  @override
  String demoCallBody(String phone) {
    return 'డెమో మోడ్‌లో నిజమైన కాల్స్ వెళ్లవు. అసలు యాప్‌లో ఇది $phoneకి కాల్ చేస్తుంది.';
  }

  @override
  String get hoursTitle => 'సమయాలు';

  @override
  String get closedToday => 'ఈరోజు మూసి ఉంది';

  @override
  String todayHours(String open, String close) {
    return 'ఈరోజు $open – $close';
  }

  @override
  String emergencyLine(String phone) {
    return 'అత్యవసర లైన్: $phone';
  }

  @override
  String get servicesAndPrices => 'సేవలు, ధరలు';

  @override
  String get instantBooking => 'తక్షణ బుకింగ్';

  @override
  String get requestBooking => 'బుకింగ్ అభ్యర్థన';

  @override
  String get payOnline => 'ఆన్‌లైన్ చెల్లింపు';

  @override
  String get payAtCentre => 'సెంటర్‌లో చెల్లింపు';

  @override
  String get payAtClinic => 'క్లినిక్‌లో చెల్లింపు';

  @override
  String homeVisitAvailable(int km) {
    return '$km కి.మీ. లోపు ఇంటికి వస్తారు';
  }

  @override
  String get packages => 'ప్యాకేజీలు';

  @override
  String get vetsHere => 'ఇక్కడి వెట్‌లు';

  @override
  String yearsExperience(int years) {
    return '$years సంవత్సరాల అనుభవం';
  }

  @override
  String regNo(String no) {
    return 'రిజి. నం. $no';
  }

  @override
  String get location => 'లొకేషన్';

  @override
  String get reviews => 'సమీక్షలు';

  @override
  String get noReviewsYet => 'ఇంకా సమీక్షలు లేవు.';

  @override
  String get verifiedBooking => 'ధృవీకరించిన బుకింగ్';

  @override
  String replyFrom(String name) {
    return '$name జవాబు';
  }

  @override
  String get inClinic => 'క్లినిక్‌లో';

  @override
  String get svcConsultation => 'కన్సల్టేషన్';

  @override
  String get svcVaccination => 'టీకా';

  @override
  String get svcSurgery => 'శస్త్రచికిత్స సంప్రదింపు';

  @override
  String get svcDental => 'దంతాల శుభ్రత';

  @override
  String get svcLabTests => 'ల్యాబ్ పరీక్షలు';

  @override
  String get svcXray => 'ఎక్స్-రే';

  @override
  String get svcHomeVisit => 'ఇంటికి వచ్చి చూడటం';

  @override
  String get svcGrooming => 'గ్రూమింగ్';

  @override
  String get svcBathBrush => 'స్నానం, బ్రష్';

  @override
  String get svcFullGroom => 'పూర్తి గ్రూమింగ్';

  @override
  String get svcNailTrim => 'గోళ్లు కత్తిరించడం';

  @override
  String get svcTickTreatment => 'పేల చికిత్స';

  @override
  String get svcObedience => 'విధేయత శిక్షణ';

  @override
  String get svcPuppyBasics => 'కుక్కపిల్ల ప్రాథమిక శిక్షణ';

  @override
  String get svcBehaviour => 'ప్రవర్తన సెషన్';

  @override
  String get svcBoarding => 'బోర్డింగ్';

  @override
  String get svcBoardingNight => 'బోర్డింగ్ (ఒక రాత్రికి)';

  @override
  String get svcDayCare => 'డే కేర్';

  @override
  String get svcHomeSitting => 'ఇంట్లో సంరక్షణ';

  @override
  String get svcWalk30 => '30 నిమిషాల నడక';

  @override
  String get svcWalk60 => '60 నిమిషాల నడక';

  @override
  String get stepWhoWhat => 'పెంపుడు జంతువు, సేవ';

  @override
  String get stepWhen => 'తేదీ, సమయం';

  @override
  String get stepDetails => 'వివరాలు';

  @override
  String get stepConfirm => 'నిర్ధారించండి';

  @override
  String get whichPet => 'ఏ పెంపుడు జంతువు?';

  @override
  String get whichService => 'ఏ సేవ?';

  @override
  String get chooseVet => 'వెట్‌ను ఎంచుకోండి';

  @override
  String get anyVet => 'అందుబాటులో ఉన్న ఏ వెట్ అయినా';

  @override
  String get noPetForPlace =>
      'మీ పెంపుడు జంతువులు ఏవీ ఇక్కడ బుక్ కావు. ముందు ఒకటి జోడించండి.';

  @override
  String homeVisitHint(int km, String fee) {
    return '$km కి.మీ. లోపు, ప్రయాణ ఛార్జీ $fee';
  }

  @override
  String get openSlots => 'ఖాళీ స్లాట్లు';

  @override
  String get noSlotsThatDay =>
      'ఆ రోజు ఖాళీ స్లాట్లు లేవు. వేరే రోజు ప్రయత్నించండి.';

  @override
  String requestExplainer(int hours) {
    return 'మీకు అనుకూలమైన 3 సమయాలు ఎంచుకోండి. ప్రొవైడర్ $hours గంటల్లో జవాబిస్తారు.';
  }

  @override
  String get yourPreferredTimes => 'మీకు ఇష్టమైన సమయాలు';

  @override
  String get preferredTimes => 'ఇష్టమైన సమయాలు';

  @override
  String get symptomsNotes => 'వెట్ కోసం లక్షణాలు లేదా గమనికలు';

  @override
  String get symptomsHint => 'ఉదా. నిన్నటి నుండి తినడం లేదు, రెండుసార్లు వాంతి';

  @override
  String get notesForProvider => 'ప్రొవైడర్ కోసం గమనికలు';

  @override
  String get notes => 'గమనికలు';

  @override
  String get howToPay => 'ఎలా చెల్లిస్తారు?';

  @override
  String get payOnlineHint => 'ఇప్పుడే UPI లేదా కార్డ్. వెంటనే నిర్ధారణ.';

  @override
  String get payLaterHint => 'వచ్చినప్పుడు చెల్లించండి.';

  @override
  String get when => 'ఎప్పుడు';

  @override
  String get where => 'ఎక్కడ';

  @override
  String get pet => 'పెంపుడు జంతువు';

  @override
  String get vet => 'వెట్';

  @override
  String get travelFee => 'ప్రయాణ ఛార్జీ';

  @override
  String get platformFee => 'ప్లాట్‌ఫామ్ ఫీజు';

  @override
  String get free => 'ఉచితం';

  @override
  String get totalToPay => 'మొత్తం';

  @override
  String cancellationPolicy(int hours) {
    return '$hours గంటల ముందు వరకు ఉచితంగా రద్దు. ఆ తర్వాత 50% రీఫండ్.';
  }

  @override
  String get confirmBooking => 'బుకింగ్ నిర్ధారించండి';

  @override
  String get sendRequest => 'అభ్యర్థన పంపండి';

  @override
  String get demoBookingNote => 'డెమో బుకింగ్. నిజమైన డబ్బు తీసుకోరు.';

  @override
  String get bookingConfirmedTitle => 'బుకింగ్ నిర్ధారించబడింది';

  @override
  String bookingConfirmedBody(String pet, String place, String when) {
    return '$petకి $placeలో $whenన బుకింగ్ అయింది.';
  }

  @override
  String get requestSentTitle => 'అభ్యర్థన పంపబడింది';

  @override
  String requestSentBody(String place) {
    return '$place త్వరలో జవాబిస్తారు. మేము మీకు తెలియజేస్తాం.';
  }

  @override
  String get paymentFailed =>
      'చెల్లింపు విఫలమైంది. డబ్బు తీసుకోలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get paymentPendingNote =>
      'చెల్లింపు పెండింగ్‌లో ఉంది. పూర్తయ్యాక నిర్ధారిస్తాం.';

  @override
  String get demoPaymentTitle => 'డెమో చెల్లింపు';

  @override
  String get demoPaymentNote => 'ఇది డెమో. డబ్బు ఏమీ కదలదు.';

  @override
  String get demoPaymentChoose => 'ఏమి జరగాలో ఎంచుకోండి:';

  @override
  String get payUpiDemo => 'UPIతో చెల్లించండి (డెమో)';

  @override
  String get simulateFailure => 'విఫలమైనట్లు చూపండి';

  @override
  String get simulatePending => 'పెండింగ్‌గా చూపండి';

  @override
  String get bookingDetails => 'బుకింగ్ వివరాలు';

  @override
  String get replyBy => 'జవాబు గడువు';

  @override
  String replyBefore(String time) {
    return '$time లోపు జవాబివ్వండి';
  }

  @override
  String get payment => 'చెల్లింపు';

  @override
  String get paidOnline => 'ఆన్‌లైన్‌లో చెల్లించారు';

  @override
  String get paymentPending => 'చెల్లింపు పెండింగ్';

  @override
  String get payAtVisit => 'వచ్చినప్పుడు చెల్లింపు';

  @override
  String get platformCommission => 'ప్లాట్‌ఫామ్ కమీషన్';

  @override
  String get yourPayout => 'మీకు వచ్చే మొత్తం';

  @override
  String get refund => 'రీఫండ్';

  @override
  String refundDemo(String amount) {
    return '$amount (డెమో, నిజమైన డబ్బు కాదు)';
  }

  @override
  String providerSuggested(String place, String when) {
    return '$place కొత్త సమయం సూచించారు: $when';
  }

  @override
  String get liveWalk => 'లైవ్ నడక';

  @override
  String get liveWalkDemo => 'డెమో కోసం అనుకరణ లైవ్ నడక.';

  @override
  String walkSoFar(String km) {
    return 'ఇప్పటివరకు $km';
  }

  @override
  String get updates => 'అప్‌డేట్‌లు';

  @override
  String get dailyUpdates => 'రోజువారీ అప్‌డేట్‌లు';

  @override
  String get addToCalendar => 'క్యాలెండర్‌కి జోడించండి';

  @override
  String get message => 'సందేశం';

  @override
  String get reschedule => 'సమయం మార్చండి';

  @override
  String rescheduledTo(String when) {
    return '$whenకి మార్చారు';
  }

  @override
  String get cancelBooking => 'బుకింగ్ రద్దు చేయండి';

  @override
  String get cancelBookingQ => 'ఈ బుకింగ్ రద్దు చేయాలా?';

  @override
  String cancelRefundInfo(String amount) {
    return 'మీకు $amount తిరిగి వస్తుంది (డెమో).';
  }

  @override
  String cancelledWithRefund(String amount) {
    return 'రద్దయింది. $amount రీఫండ్ (డెమో).';
  }

  @override
  String get bookingCancelled => 'బుకింగ్ రద్దయింది';

  @override
  String get writeReview => 'సమీక్ష రాయండి';

  @override
  String rateProvider(String name) {
    return '$name ఎలా ఉంది?';
  }

  @override
  String starsLabel(int count) {
    return '$count నక్షత్రాలు';
  }

  @override
  String get reviewText => 'ఏది బాగుందో ఇతర పెంపుడు జంతువుల యజమానులకు చెప్పండి';

  @override
  String get postReview => 'సమీక్ష పోస్ట్ చేయండి';

  @override
  String get thanksForReview => 'మీ సమీక్షకు ధన్యవాదాలు!';

  @override
  String get bsPending => 'జవాబు కోసం వేచి ఉంది';

  @override
  String get bsConfirmed => 'నిర్ధారించబడింది';

  @override
  String get bsSuggested => 'కొత్త సమయం సూచించారు';

  @override
  String get bsInProgress => 'జరుగుతోంది';

  @override
  String get bsCompleted => 'పూర్తయింది';

  @override
  String get bsCancelled => 'రద్దయింది';

  @override
  String get bsDeclined => 'తిరస్కరించారు';

  @override
  String get bsExpired => 'గడువు ముగిసింది';

  @override
  String ntfNewBooking(String pet, String when) {
    return 'కొత్త బుకింగ్: $pet, $when';
  }

  @override
  String ntfNewRequest(String pet) {
    return '$pet కోసం కొత్త బుకింగ్ అభ్యర్థన';
  }

  @override
  String ntfAccepted(String place, String when) {
    return '$place మీ $when బుకింగ్‌ను నిర్ధారించారు';
  }

  @override
  String ntfDeclined(String place) {
    return '$place మీ అభ్యర్థనను తీసుకోలేకపోయారు';
  }

  @override
  String ntfSuggested(String place, String when) {
    return '$place బదులుగా $when సూచించారు';
  }

  @override
  String ntfCancelled(String pet, String when) {
    return '$pet $when బుకింగ్ రద్దయింది';
  }

  @override
  String ntfRescheduled(String pet, String when) {
    return '$pet బుకింగ్ $whenకి మారింది';
  }

  @override
  String ntfCompleted(String pet, String place) {
    return '$placeలో $pet సందర్శన పూర్తయింది. మీ అనుభవాన్ని రేట్ చేస్తారా?';
  }

  @override
  String ntfUpdate(String place, String pet) {
    return '$place $pet గురించి అప్‌డేట్ పంపారు';
  }

  @override
  String ntfExpired(String place) {
    return '$place సమయానికి జవాబివ్వలేదు. మీ అభ్యర్థన గడువు ముగిసింది.';
  }

  @override
  String helloPartner(String name) {
    return 'నమస్తే, $name';
  }

  @override
  String get noBusinessLinked => 'ఈ ఖాతాకు ఇంకా ఏ వ్యాపారం జోడించలేదు.';

  @override
  String get waitingApproval =>
      'ఆమోదం కోసం వేచి ఉంది. PawSetu కొత్త భాగస్వాములను 2 పని దినాల్లో తనిఖీ చేస్తుంది. ఈలోగా మీ సేవలు సెట్ చేసుకోండి.';

  @override
  String get todaysBookings => 'ఈరోజు బుకింగ్‌లు';

  @override
  String get requestsWaiting => 'వేచి ఉన్న అభ్యర్థనలు';

  @override
  String get earningsThisMonth => 'ఈ నెల ఆదాయం';

  @override
  String get completedBookings => 'పూర్తయినవి';

  @override
  String get noBookingsToday => 'ఈరోజు బుకింగ్‌లు లేవు.';

  @override
  String bookingsOn(String date) {
    return '$date బుకింగ్‌లు';
  }

  @override
  String get noBookingsThisDay => 'ఈ రోజు బుకింగ్‌లు లేవు.';

  @override
  String get holidayNoBookings => 'సెలవుగా గుర్తించారు. బుకింగ్‌లు లేవు.';

  @override
  String get markHoliday => 'సెలవుగా గుర్తించండి';

  @override
  String get removeHoliday => 'సెలవు తీసివేయండి';

  @override
  String get blockTime => 'సమయం బ్లాక్ చేయండి';

  @override
  String timeBlocked(String time) {
    return '$time నుండి బ్లాక్';
  }

  @override
  String get workingHours => 'పని సమయాలు';

  @override
  String get opens => 'తెరుచుకుంటుంది';

  @override
  String get closes => 'మూసివేస్తారు';

  @override
  String get hoursAppliesMonSat =>
      'ఈ సమయాలు సోమవారం నుండి శనివారం వరకు. ఆదివారం మారదు.';

  @override
  String slotSettings(int slot, int buffer, int capacity) {
    return '$slot ని. స్లాట్ · $buffer ని. విరామం · ఒక్కో స్లాట్‌కి $capacity';
  }

  @override
  String get slotLength => 'స్లాట్ నిడివి (నిమిషాలు)';

  @override
  String get bufferTime => 'స్లాట్ల మధ్య విరామం (నిమిషాలు)';

  @override
  String get capacityPerSlot => 'ఒక్కో స్లాట్‌కి జంతువులు';

  @override
  String get noRequestsPartner => 'ప్రస్తుతం బుకింగ్ అభ్యర్థనలు లేవు.';

  @override
  String get waitingForOwner => 'యజమాని జవాబు కోసం';

  @override
  String get chooseTimeToAccept => 'అంగీకరించడానికి సమయం ఎంచుకోండి';

  @override
  String get suggestTime => 'వేరే సమయం సూచించండి';

  @override
  String get suggestionSent => 'యజమానికి కొత్త సమయం పంపాం';

  @override
  String requestAccepted(String pet) {
    return '$pet బుకింగ్ నిర్ధారించబడింది';
  }

  @override
  String declineRequestQ(String pet) {
    return '$pet అభ్యర్థనను తిరస్కరించాలా?';
  }

  @override
  String get services => 'సేవలు';

  @override
  String get servicesHelp =>
      'మీ ధరలు, సమయం, బుకింగ్ విధానం సెట్ చేయండి. మార్పులు వెంటనే యాప్‌లో కనిపిస్తాయి.';

  @override
  String get priceRupees => 'ధర (₹)';

  @override
  String get minutes => 'నిమిషాలు';

  @override
  String get bookingMode => 'బుకింగ్ విధానం';

  @override
  String get paymentOptions => 'చెల్లింపు ఎంపికలు';

  @override
  String get saved => 'సేవ్ అయింది';

  @override
  String get addVet => 'వెట్‌ను జోడించండి';

  @override
  String get vcRegNumber => 'వెటర్నరీ కౌన్సిల్ రిజి. నంబర్';

  @override
  String get vcRegHelp =>
      'వెట్ బుకింగ్‌లు తీసుకునే ముందు PawSetu దీన్ని ధృవీకరిస్తుంది.';

  @override
  String get vetAddedPending => 'వెట్‌ను జోడించాం. ధృవీకరణ కోసం వేచి ఉంది.';

  @override
  String get reply => 'జవాబివ్వండి';

  @override
  String get yourReply => 'మీ జవాబు';

  @override
  String get postReply => 'జవాబు పోస్ట్ చేయండి';

  @override
  String get totalPayouts => 'మొత్తం చెల్లింపులు';

  @override
  String get payoutPending => 'పెండింగ్';

  @override
  String get settled => 'చెల్లించారు';

  @override
  String get payoutHistory => 'చెల్లింపుల చరిత్ర';

  @override
  String get noPayoutsYet => 'ఇంకా చెల్లింపులు లేవు.';

  @override
  String commissionLine(String amount) {
    return 'కమీషన్ $amount';
  }

  @override
  String get demoPayoutsNote => 'డెమో చెల్లింపులు. నిజమైన డబ్బు కదలదు.';

  @override
  String get statusApproved => 'ఆమోదించబడింది';

  @override
  String get statusPendingApproval => 'ఆమోదం పెండింగ్';

  @override
  String get kycDocuments => 'KYC పత్రాలు';

  @override
  String get uploadKyc => 'పత్రం అప్‌లోడ్ చేయండి';

  @override
  String get kycUploaded => 'పత్రం సమీక్షకు అప్‌లోడ్ అయింది';

  @override
  String get emergencyPhone => 'అత్యవసర ఫోన్';

  @override
  String get emergencySettingsHelp =>
      '24x7 క్లినిక్‌లు SOSలో ముందు కనిపిస్తాయి. మీ అత్యవసర నంబర్‌ను తాజాగా ఉంచండి.';

  @override
  String get allowEnquiries => 'ఇప్పుడు అత్యవసర కాల్స్ తీసుకోండి';

  @override
  String get allowEnquiriesHint =>
      'ఖాళీ లేకపోతే ఆపేయండి. యజమానులకు తదుపరి క్లినిక్ కనిపిస్తుంది.';

  @override
  String get startService => 'ప్రారంభించండి';

  @override
  String get markCompleted => 'పూర్తయినట్లు గుర్తించండి';

  @override
  String get sendPhotoUpdate => 'ఫోటో అప్‌డేట్ పంపండి';

  @override
  String defaultUpdateText(String pet) {
    return '$pet చక్కగా ఉంది!';
  }

  @override
  String updateSent(String name) {
    return '$nameకి అప్‌డేట్ పంపాం';
  }

  @override
  String get partnerCancelNote =>
      'యజమానికి పూర్తి రీఫండ్, నోటిఫికేషన్ వస్తాయి.';

  @override
  String get messageOwner => 'యజమానికి సందేశం పంపండి';

  @override
  String get partnerSignupLink =>
      'పెంపుడు జంతువుల వ్యాపారం ఉందా? భాగస్వామిగా చేరండి';

  @override
  String get partnerSignupTitle => 'PawSetu భాగస్వామిగా చేరండి';

  @override
  String get partnerSignupSubtitle =>
      'క్లినిక్‌లు, గ్రూమర్లు, ట్రైనర్లు, బోర్డింగ్, వాకర్లు, పెట్ షాపుల కోసం. చేరడం ఉచితం.';

  @override
  String get businessType => 'ఏ రకమైన వ్యాపారం?';

  @override
  String get kindSeller => 'పెట్ షాప్';

  @override
  String get businessName => 'వ్యాపారం పేరు';

  @override
  String get areaCity => 'ప్రాంతం, నగరం';

  @override
  String get businessPhone => 'వ్యాపార ఫోన్';

  @override
  String get businessAddress => 'చిరునామా (ఐచ్ఛికం)';

  @override
  String get kycHelp =>
      'గుర్తింపు పత్రం, వ్యాపార రిజిస్ట్రేషన్ జోడించండి. మీ లిస్టింగ్ లైవ్ అయ్యే ముందు PawSetu వాటిని తనిఖీ చేస్తుంది.';

  @override
  String get useSampleDoc => 'నమూనా పత్రం వాడండి (డెమో)';

  @override
  String get sampleIdProof => 'గుర్తింపు పత్రం (నమూనా)';

  @override
  String get kycNeeded => 'కనీసం ఒక పత్రం జోడించండి.';

  @override
  String get yourAccount => 'మీ ఖాతా';

  @override
  String get submitApplication => 'దరఖాస్తు పంపండి';

  @override
  String get partnerApprovalNote =>
      'పంపిన తర్వాత మీ లిస్టింగ్ ఆమోదం కోసం వేచి ఉంటుంది. ఈలోగా సేవలు, ధరలు సెట్ చేసుకోవచ్చు.';

  @override
  String get remove => 'తీసివేయండి';

  @override
  String get aiTitle => 'PawSetu ని అడగండి';

  @override
  String get aiIntroTitle => 'రోజువారీ పెంపుడు జంతువు ప్రశ్నలకు త్వరిత జవాబులు';

  @override
  String get aiIntroBody =>
      'ఆహారం, స్నానం, టీకాలు, పేలు ఇంకా ఎన్నో అడగండి. ఏదైనా తీవ్రంగా అనిపిస్తే వెట్‌తో మాట్లాడండి.';

  @override
  String get aiHint => 'మీ ప్రశ్న రాయండి';

  @override
  String get aiAsk => 'అడగండి';

  @override
  String get aiPopular => 'తరచుగా అడిగే ప్రశ్నలు';

  @override
  String get aiDisclaimer =>
      'ఇది సాధారణ సలహా మాత్రమే, నిర్ధారణ కాదు. మీ పెంపుడు జంతువు గురించి మీ వెట్‌కే బాగా తెలుసు.';

  @override
  String get aiNotDiagnosis =>
      'ఇది నిర్ధారణ కాదు. మీ పెంపుడు జంతువు అనారోగ్యంగా అనిపిస్తే వెట్‌తో మాట్లాడండి.';

  @override
  String get aiUnknown =>
      'దీనికి ఇంకా నా దగ్గర జవాబు లేదు. తరచుగా అడిగే ప్రశ్నల్లో ఒకటి ఎంచుకోండి, లేదా టెలి-వెట్‌లో వెట్‌ని అడగండి.';

  @override
  String get aiTalkToVet => 'వెట్‌ని అడగండి';

  @override
  String get aiTalkToVetNow => 'ఇప్పుడే వెట్‌తో మాట్లాడండి';

  @override
  String get aiUnlimited => 'Plus తో అపరిమితం';

  @override
  String aiLeft(int left, int limit) {
    return 'ఈ నెల $limitలో $left ప్రశ్నలు మిగిలాయి';
  }

  @override
  String aiLimitTitle(int limit) {
    return 'ఈ నెల మీ $limit ప్రశ్నలు అయిపోయాయి';
  }

  @override
  String aiLimitBody(String date) {
    return '$dateన మళ్లీ ప్రశ్నలు వస్తాయి, లేదా PawSetu Plus తో అపరిమితంగా అడగండి. అత్యవసర ప్రశ్నలకు ఎప్పుడూ జవాబు ఉంటుంది.';
  }

  @override
  String get aiRedFlagTitle => 'ఇది అత్యవసర పరిస్థితి కావచ్చు';

  @override
  String aiRedFlagBody(String sign) {
    return '$signకి వెంటనే వెట్ అవసరం. దగ్గరలో తెరిచి ఉన్న క్లినిక్‌ని చేరడానికి SOS వాడండి, లేదా ఇప్పుడే వెట్‌తో మాట్లాడండి.';
  }

  @override
  String aiRedFlagShort(String sign) {
    return 'అత్యవసరం కావచ్చు: $sign';
  }

  @override
  String aiTileHint(int left) {
    return 'రోజువారీ ప్రశ్నలకు వెంటనే జవాబులు. ఈ నెల $left మిగిలాయి.';
  }

  @override
  String get aiTileHintPlus =>
      'రోజువారీ ప్రశ్నలకు వెంటనే జవాబులు. Plus తో అపరిమితం.';

  @override
  String get rfBreathing => 'శ్వాస తీసుకోవడంలో ఇబ్బంది';

  @override
  String get rfCollapse => 'కుప్పకూలడం లేదా స్పృహ తప్పడం';

  @override
  String get rfSeizure => 'మూర్ఛ (ఫిట్స్)';

  @override
  String get rfPoisoning => 'విషం తిన్నట్లు అనుమానం';

  @override
  String get rfBleeding => 'ఎక్కువ రక్తస్రావం';

  @override
  String get rfBloat => 'ఉబ్బిన, గట్టిగా ఉన్న కడుపు';

  @override
  String get rfHeatstroke => 'వడదెబ్బ';

  @override
  String get rfUrine => 'మూత్రం రాకపోవడం';

  @override
  String get rfInjury => 'తీవ్రమైన గాయం';

  @override
  String get aiQBath => 'కుక్కకు ఎన్నిసార్లు స్నానం చేయించాలి?';

  @override
  String get aiQFeeding => 'నా పెంపుడు జంతువుకు ఎంత ఆహారం పెట్టాలి?';

  @override
  String get aiQToxicFood => 'మనుషుల ఆహారంలో ఏవి పెంపుడు జంతువులకు ప్రమాదం?';

  @override
  String get aiQVaccines => 'నా పెంపుడు జంతువుకు ఏ టీకాలు అవసరం?';

  @override
  String get aiQDeworming => 'నులిపురుగుల మందు ఎంత తరచుగా ఇవ్వాలి?';

  @override
  String get aiQTicks => 'పేలు, ఈగపురుగుల నుండి ఎలా కాపాడాలి?';

  @override
  String get aiQHeat => 'వేసవిలో పెంపుడు జంతువును చల్లగా ఎలా ఉంచాలి?';

  @override
  String get aiQVomiting => 'నా పెంపుడు జంతువు వాంతి చేసుకుంది. ఏం చేయాలి?';

  @override
  String get aiQDiarrhoea =>
      'నా పెంపుడు జంతువుకు విరేచనాలు అవుతున్నాయి. ఏం చేయాలి?';

  @override
  String get aiQNotEating => 'నా పెంపుడు జంతువు తినడం లేదు. ఆందోళన పడాలా?';

  @override
  String get aiQItching => 'నా కుక్క ఎందుకు పదేపదే గోక్కుంటోంది?';

  @override
  String get aiQLimping => 'నా కుక్క కుంటుతోంది. ఏం చేయాలి?';

  @override
  String get aiQLitter => 'నా పిల్లి లిట్టర్ బాక్స్ వాడడం లేదు. ఎందుకు?';

  @override
  String get aiQChewing => 'కుక్కపిల్ల కొరకడం, నమలడం ఎలా ఆపాలి?';

  @override
  String get aiQNails => 'పెంపుడు జంతువు గోళ్లు ఎలా కత్తిరించాలి?';

  @override
  String get aiQTeeth => 'పెంపుడు జంతువు దంతాలను ఎలా చూసుకోవాలి?';

  @override
  String get aiQBirdDiet => 'నా పక్షికి ఏం పెట్టాలి?';

  @override
  String get aiQRabbitDiet => 'నా కుందేలుకు ఏం పెట్టాలి?';

  @override
  String get aiQWeight => 'నా పెంపుడు జంతువు బరువు ఎక్కువగా ఉందా?';

  @override
  String get aiQAnxiety =>
      'నా పెంపుడు జంతువు టపాసులు, ఉరుములకు భయపడుతుంది. ఎలా సహాయం చేయాలి?';

  @override
  String get aiABath =>
      'చాలా కుక్కలకు 3 నుండి 4 వారాలకు ఒకసారి స్నానం సరిపోతుంది; మురికిగా లేదా వాసన వస్తేనే ఎక్కువసార్లు. కుక్కల షాంపూ, గోరువెచ్చని నీళ్లు వాడండి (మనుషుల షాంపూ చర్మాన్ని పొడిబారుస్తుంది), బాగా కడగండి. ఫంగల్ ఇన్ఫెక్షన్ రాకుండా, ముఖ్యంగా వర్షాకాలంలో, చెవులు, బొచ్చు పూర్తిగా ఆరబెట్టండి. వారానికి కొన్నిసార్లు బ్రష్ చేస్తే బొచ్చు శుభ్రంగా ఉంటుంది. పిల్లులకు స్నానం చాలా అరుదుగా అవసరం.';

  @override
  String get aiAFeeding =>
      'ఇది మీ పెంపుడు జంతువు బరువు, వయసు, చురుకుదనం మీద ఆధారపడి ఉంటుంది. ఆహారం ప్యాకెట్‌పై సరైన బరువుకు రాసిన మొత్తంతో మొదలుపెట్టండి; పెద్ద కుక్కలు, పిల్లులకు 2 సార్లుగా (కుక్కపిల్లలు, పిల్లి పిల్లలకు 3 నుండి 4 సార్లు) పెట్టండి. కొన్ని వారాలకు ఒకసారి నడుము, పక్కటెముకలు చూడండి: పక్కటెముకలు సులభంగా తగలాలి. ట్రీట్లు రోజువారీ ఆహారంలో పదో వంతు కంటే తక్కువ ఉండాలి. ఎప్పుడూ మంచినీళ్లు అందుబాటులో ఉంచండి. సరైన మొత్తం మీ వెట్ చెప్పగలరు.';

  @override
  String get aiAToxicFood =>
      'చాక్లెట్, ద్రాక్ష లేదా కిస్‌మిస్, ఉల్లి, వెల్లుల్లి, జైలిటాల్ (కొన్ని షుగర్-ఫ్రీ చూయింగ్ గమ్, స్వీట్లలో ఉంటుంది), మద్యం, కెఫీన్, వండిన ఎముకలు, ఎక్కువ ఉప్పు లేదా కారం ఉన్న ఆహారం ఎప్పుడూ పెట్టవద్దు. పండుగ స్వీట్లలో చాలావాటిలో చాక్లెట్, కిస్‌మిస్ లేదా జైలిటాల్ ఉంటాయి, వాటిని దూరంగా ఉంచండి. లిల్లీ పూలు పిల్లులకు కూడా హానికరం. వీటిలో ఏదైనా తిన్నట్లయితే, బాగానే కనిపించినా, SOS వాడండి లేదా వెంటనే వెట్‌కి ఫోన్ చేయండి.';

  @override
  String get aiAVaccines =>
      'కుక్కలకు లెప్టోస్పైరోసిస్‌తో DHPPi (6 నుండి 8 వారాల వయసు నుండి కుక్కపిల్లకు 3 మోతాదులు), సుమారు 3 నెలలకు రేబీస్ టీకా, ప్రతి సంవత్సరం బూస్టర్ అవసరం. పిల్లులకు ట్రైక్యాట్ టీకా, రేబీస్ టీకా, ప్రతి సంవత్సరం బూస్టర్ అవసరం. భారతదేశంలో కుందేళ్లు, పక్షులకు సాధారణంగా రోజువారీ టీకాలు అవసరం లేదు. మీ పెంపుడు జంతువు ఆరోగ్యం ట్యాబ్‌లో పూర్తి షెడ్యూల్, ఏది బాకీ, ఏది ఆలస్యమైంది అన్నీ కనిపిస్తాయి. తుది ప్రణాళిక మీ వెట్ నిర్ణయిస్తారు.';

  @override
  String get aiADeworming =>
      'కుక్కపిల్లలు, పిల్లి పిల్లలు: 3 నెలల వరకు ప్రతి 2 వారాలకు, తర్వాత 6 నెలల వరకు ప్రతి నెల. పెద్దవి: ప్రతి 3 నెలలకు. ప్రతి మోతాదుకు ముందు బరువు చూడండి, ఎందుకంటే మోతాదు బరువు మీద ఆధారపడుతుంది. తదుపరి మోతాదు సమయం వచ్చినప్పుడు PawSetu గుర్తు చేస్తుంది. ఏ మందు సరిపోతుందో మీ వెట్‌ని అడగండి.';

  @override
  String get aiATicks =>
      'వెట్ సూచించిన పేలు, ఈగపురుగుల నివారణ మందు సంవత్సరం పొడవునా వాడండి: స్పాట్-ఆన్, నమిలే మాత్ర లేదా కాలర్. భారతదేశంలో పేలు సాధారణం, ముఖ్యంగా వర్షాకాలంలో. నడక తర్వాత చెవులు, వేళ్ల మధ్య, కాలర్ కింద చూడండి. పరుపు శుభ్రంగా, పొడిగా ఉంచండి. కుక్కల మందులు పిల్లులకు ఎప్పుడూ వాడవద్దు. పేలు కుట్టిన తర్వాత నీరసంగా ఉన్నా, చిగుళ్లు తెల్లగా ఉన్నా, జ్వరం ఉన్నా వెంటనే వెట్‌కి చూపించండి.';

  @override
  String get aiAHeat =>
      'తెల్లవారుజామున లేదా సూర్యాస్తమయం తర్వాత నడిపించండి, రోడ్డును చేతితో పరీక్షించండి: 5 సెకన్లు చేయి ఉంచలేనంత వేడిగా ఉంటే పాదాలకు కూడా అంతే వేడి. రోజంతా చల్లని నీళ్లు, నీడ అందుబాటులో ఉంచండి. పెంపుడు జంతువును ఆపిన కారులో ఎప్పుడూ వదలవద్దు. పగ్, పర్షియన్ పిల్లి వంటి చదునైన ముఖం ఉన్న జాతులు త్వరగా వేడెక్కుతాయి. ఎక్కువగా ఆయాసపడటం, చొంగ కారడం, తూలడం, ఎర్రని చిగుళ్లు వడదెబ్బ లక్షణాలు: SOS వాడండి.';

  @override
  String get aiAVomiting =>
      'ఒక్కసారి వాంతి చేసుకుని మామూలుగా ఆడుకుంటుంటే చాలాసార్లు తగ్గిపోతుంది: కొన్ని గంటలు ఆహారం ఆపండి (నీళ్లు ఇవ్వండి), తర్వాత ఉడికించిన అన్నం, ఉడికించిన చికెన్ వంటి సాదా ఆహారం కొద్దికొద్దిగా పెట్టండి. వాంతులు మళ్లీ మళ్లీ వస్తే, రక్తం కనిపిస్తే, కుక్కపిల్ల లేదా పిల్లి పిల్ల అయితే, నీరసంగా ఉంటే, కడుపు ఉబ్బితే, లేదా విషపూరితమైనది లేదా బొమ్మ మింగినట్లు అనుమానం ఉంటే అదే రోజు వెట్‌కి చూపించండి.';

  @override
  String get aiADiarrhoea =>
      'నీరసం రాకుండా మంచినీళ్లు అందుబాటులో ఉంచండి, ఒకటి రెండు రోజులు సాదా ఆహారం కొద్దికొద్దిగా పెట్టండి (కుక్కలకు ఉడికించిన అన్నం, ఉడికించిన చికెన్ లేదా పెరుగన్నం). పాలు, ట్రీట్లు ఇవ్వవద్దు. ఒక రోజుకు మించి ఉంటే, రక్తం లేదా నల్లని మలం కనిపిస్తే, వాంతులు కూడా అవుతుంటే, నీరసంగా ఉంటే, లేదా కుక్కపిల్ల/పిల్లి పిల్ల అయితే వెట్‌కి చూపించండి.';

  @override
  String get aiANotEating =>
      'వేడి, ఒత్తిడి లేదా ఆహారం మార్చినప్పుడు ఒక పూట తినకపోవచ్చు. తాజా ఆహారం, నీళ్లు ఇచ్చి ఇతర లక్షణాలు గమనించండి. కుక్క ఒక రోజుకు మించి, పిల్లి 24 గంటలకు మించి, కుందేలు కొన్ని గంటలైనా తినకపోతే (కుందేళ్లు త్వరగా జబ్బు పడతాయి), లేదా వాంతులు, నీరసం, నొప్పి, జ్వరం ఉంటే వెట్‌కి చూపించండి.';

  @override
  String get aiAItching =>
      'సాధారణ కారణాలు పేలు, ఈగపురుగులు, చర్మ ఇన్ఫెక్షన్లు (తరచుగా వర్షాకాలంలో), ఆహారం లేదా దుమ్ము అలర్జీ, తరచు స్నానం వల్ల పొడిబారిన చర్మం. చర్మంపై పేలు, ఎరుపు, వెంట్రుకలు ఊడిన మచ్చలు, వాసన ఉన్నాయేమో చూడండి. పేలు నివారణ కొనసాగించండి, స్నానం, వర్షం తర్వాత కుక్కను బాగా ఆరబెట్టండి. దురద కొన్ని రోజులకు మించి ఉన్నా, చర్మం చిట్లినా వెట్‌కి చూపించండి.';

  @override
  String get aiALimping =>
      'పాదంలో ముల్లు, గాజు, కోత, విరిగిన గోరు లేదా వేళ్ల మధ్య పేను ఉందేమో చూడండి, వాపు ఉందేమో గమనించండి. కుక్కకు విశ్రాంతి ఇవ్వండి: ఒక రోజు చిన్న నడకలు మాత్రమే, పరుగు, దూకడం వద్దు. మనుషుల నొప్పి మాత్రలు ఎప్పుడూ ఇవ్వవద్దు; చాలావి పెంపుడు జంతువులకు విషం. కుంటడం ఒక రోజుకు మించి ఉన్నా, కాలుపై బరువు వేయలేకపోయినా, నొప్పితో అరిచినా, లేదా పడిపోయిన/ప్రమాదం తర్వాత అయితే వెట్‌కి చూపించండి.';

  @override
  String get aiALitter =>
      'బాక్స్‌ను శుభ్రంగా ఉంచండి (రోజూ శుభ్రం చేయండి), ఆహారానికి దూరంగా ప్రశాంతమైన చోట పెట్టండి, ప్రతి పిల్లికి ఒక బాక్స్‌తో పాటు ఒకటి అదనంగా ఉంచండి. కొన్ని పిల్లులకు సువాసన ఉన్న లిట్టర్ లేదా మూత ఉన్న బాక్స్ నచ్చదు. కొత్త పెంపుడు జంతువు లేదా ఇల్లు మారడం వంటి ఒత్తిడి కూడా కారణం కావచ్చు. బాక్స్‌లో ముక్కుతూ మూత్రం కొంచెమే వస్తే లేదా అసలు రాకపోతే అది అత్యవసరం, ముఖ్యంగా మగ పిల్లిలో: SOS వాడండి.';

  @override
  String get aiAChewing =>
      'కుక్కపిల్లలు నోటితో ప్రపంచాన్ని తెలుసుకుంటాయి, పళ్లు వచ్చే సమయంలో (3 నుండి 6 నెలలు) ఎక్కువగా నములుతాయి. సురక్షితమైన నమిలే బొమ్మలు ఇవ్వండి, వేరే వస్తువు పట్టుకుంటే దానికి బదులు బొమ్మ ఇవ్వండి. కొరికితే కొన్ని సెకన్లు ఆట ఆపి, మళ్లీ నెమ్మదిగా ఆడండి. ప్రశాంతంగా ఆడితే మెచ్చుకోండి. వైర్లు, చెప్పులు, మందులు అందకుండా ఉంచండి. ఎక్కువ నడక, ఆట వల్ల నమలడం తగ్గుతుంది. 6 నెలల తర్వాత కూడా కొనసాగితే ట్రైనర్ సహాయం చేయగలరు.';

  @override
  String get aiANails =>
      '3 నుండి 4 వారాలకు ఒకసారి, లేదా నేలపై గోళ్ల టక్-టక్ శబ్దం వినిపించినప్పుడు కత్తిరించండి. పెంపుడు జంతువుల నెయిల్ కట్టర్ వాడి, గులాబీ రంగు భాగం (క్విక్) కంటే కింద చివర మాత్రమే కత్తిరించండి (నల్లని గోళ్లకు కొంచెం కొంచెంగా). రక్తం వస్తే వాడడానికి స్టిప్టిక్ పౌడర్ లేదా మొక్కజొన్న పిండి దగ్గర ఉంచుకోండి. ప్రతి పాదం తర్వాత ట్రీట్ ఇవ్వండి. అస్సలు ఇష్టపడకపోతే గ్రూమర్ లేదా వెట్ కొన్ని నిమిషాల్లో చేస్తారు. పక్షులు, కుందేళ్లకు కూడా గోళ్లు కత్తిరించాలి.';

  @override
  String get aiATeeth =>
      'కుక్క లేదా పిల్లి దంతాలను వారానికి 2 నుండి 3 సార్లు పెంపుడు జంతువుల టూత్‌బ్రష్, టూత్‌పేస్ట్‌తో తోమండి (మనుషుల టూత్‌పేస్ట్ మింగడం సురక్షితం కాదు). ఫింగర్ బ్రష్‌తో నెమ్మదిగా మొదలుపెట్టి బాగా మెచ్చుకోండి. డెంటల్ చూస్ కొంచెం సహాయపడతాయి. నోటి దుర్వాసన, ఎర్రని చిగుళ్లు, విరిగిన పన్ను, ఆహారం జారవిడవడం దంత వ్యాధి సంకేతాలు కావచ్చు: మీ వెట్ దగ్గర దంత పరీక్ష బుక్ చేయండి.';

  @override
  String get aiABirdDiet =>
      'గింజలు మాత్రమే సరిపోవు. కాకటీల్, బడ్జీలకు మంచి నాణ్యత పెల్లెట్లతో పాటు రోజూ తాజా కూరగాయలు (పాలకూర, క్యారెట్, బీన్స్, బఠానీలు), కొంచెం పండ్లు, ట్రీట్‌గా కొన్ని గింజలు ఉత్తమం. రోజూ మంచినీళ్లు పెట్టండి. అవకాడో, చాక్లెట్, కెఫీన్, ఉప్పు, ఉల్లి ఎప్పుడూ పెట్టవద్దు. భారతదేశంలో చాలా చిలుక జాతులు సంరక్షించబడినవి; చట్టబద్ధంగా అనుమతి ఉన్న పక్షులను మాత్రమే పెంచండి.';

  @override
  String get aiARabbitDiet =>
      'కుందేలు ఆహారంలో సుమారు 80% ఎండుగడ్డి (హే) ఉండాలి, రోజంతా అందుబాటులో ఉండాలి: ఇది పళ్లు, జీర్ణకోశాన్ని ఆరోగ్యంగా ఉంచుతుంది. రోజూ గుప్పెడు ఆకుకూరలు (కొత్తిమీర, పుదీనా, లెట్యూస్, క్యారెట్ ఆకులు), కొంచెం కుందేలు పెల్లెట్లు ఇవ్వండి, పండ్లు అప్పుడప్పుడు ట్రీట్‌గా మాత్రమే. ఎప్పుడూ మంచినీళ్లు ఉంచండి. కొన్ని గంటలైనా కుందేలు తినడం లేదా మలవిసర్జన ఆపేస్తే వెంటనే వెట్‌కి చూపించండి.';

  @override
  String get aiAWeight =>
      'పక్కటెముకలు తాకి చూడండి: సన్నని పొర కింద సులభంగా తగలాలి, పై నుండి చూస్తే నడుము కనిపించాలి. అలా లేకపోతే బరువు ఎక్కువ ఉండవచ్చు. జాతికి తగిన ఆరోగ్యకర పరిధితో పోల్చడానికి PawSetu‌లో ప్రతి నెల బరువు నమోదు చేయండి. ట్రీట్లు, మిగిలిన భోజనం తగ్గించండి, ఆహారం కొలిచి పెట్టండి, కొంచెం ఎక్కువ నడక లేదా ఆట జోడించండి. ఆహారంలో పెద్ద మార్పు చేసే ముందు వెట్‌ని అడగండి.';

  @override
  String get aiAAnxiety =>
      'దీపావళి లేదా తుఫానుకు ముందు ప్రశాంతమైన చోటు సిద్ధం చేయండి: మూత ఉన్న క్రేట్ లేదా వాటి పరుపు ఉన్న మూల, కర్టెన్లు మూసి, ఫ్యాన్ లేదా మెల్లని సంగీతం పెట్టండి. కుక్కను పగటిపూటే త్వరగా నడిపించి, టపాసులు మొదలైనప్పుడు గుర్తింపు ట్యాగ్‌తో ఇంట్లోనే ఉంచండి. ప్రశాంతంగా దగ్గరగా ఉండండి, కానీ బలవంతంగా హత్తుకోవద్దు. భయపడినందుకు తిట్టవద్దు. తీవ్రమైన భయం ఉంటే ముందుగానే ప్రశాంతపరిచే మార్గాల గురించి వెట్‌ని అడగండి.';

  @override
  String get msgEmptyTitle => 'ఇంకా చాట్‌లు లేవు';

  @override
  String get msgEmptyBody =>
      'బుక్ చేసిన తర్వాత లేదా ప్రశ్న అడిగిన తర్వాత మీ వెట్, క్లినిక్, గ్రూమర్ లేదా వాకర్‌తో చాట్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get msgEmptyPartnerBody =>
      'పెంపుడు జంతువుల యజమానులు బుక్ చేసినప్పుడు లేదా విచారణ పంపినప్పుడు వారి చాట్‌లు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get msgEmptyFilter => 'ఈ జాబితాలో చాట్‌లు లేవు';

  @override
  String msgNoResults(String query) {
    return '\"$query\" కోసం ఏమీ దొరకలేదు';
  }

  @override
  String get msgSearchHint => 'చాట్‌లు, సందేశాలు వెతకండి';

  @override
  String get msgClearSearch => 'వెతుకులాట తీసివేయండి';

  @override
  String get msgFoundInMessages => 'సందేశాల్లో దొరికింది';

  @override
  String get msgEnquiries => 'విచారణలు';

  @override
  String get msgEnquiry => 'విచారణ';

  @override
  String get msgMuted => 'మ్యూట్';

  @override
  String get msgNoMessagesYet => 'ఇంకా సందేశాలు లేవు';

  @override
  String msgUnreadCount(int count) {
    return '$count చదవని సందేశాలు';
  }

  @override
  String get msgYouPrefix => 'మీరు';

  @override
  String msgYou(String name) {
    return '$name (మీరు)';
  }

  @override
  String get msgOpening => 'చాట్ తెరుస్తోంది…';

  @override
  String get msgPickChat => 'ఒక చాట్ ఎంచుకోండి';

  @override
  String get msgPickChatHint =>
      'వెట్‌లు, క్లినిక్‌లు, సేవలు అందించేవారితో మీ సంభాషణలు ఇక్కడ తెరుచుకుంటాయి.';

  @override
  String get msgPickChatHintPartner =>
      'పెంపుడు జంతువుల యజమానులతో మీ సంభాషణలు ఇక్కడ తెరుచుకుంటాయి.';

  @override
  String get msgNotFound => 'ఈ చాట్ ఇక ఇప్పుడు అందుబాటులో లేదు.';

  @override
  String get msgPreviewPhoto => 'ఫోటో';

  @override
  String get msgPreviewPdf => 'PDF పత్రం';

  @override
  String get msgPreviewVoice => 'వాయిస్ నోట్';

  @override
  String get msgClose => 'చాట్ మూసివేయండి';

  @override
  String get msgChatInfo => 'చాట్ వివరాలు';

  @override
  String get msgCallMasked => 'కాల్ చేయండి (నంబర్ దాచబడుతుంది)';

  @override
  String msgMaskedCallDemo(String name, String number) {
    return 'డెమో మోడ్‌లో నిజమైన కాల్స్ వెళ్లవు. అసలు యాప్‌లో ఇది $nameకి దాచిన నంబర్ ($number) ద్వారా కాల్ చేస్తుంది, కాబట్టి ఎవరూ ఇంకొకరి అసలు నంబర్ చూడరు.';
  }

  @override
  String get msgMaskedCallLive =>
      'కాల్స్ దాచిన నంబర్ ద్వారా వెళ్తాయి, కాబట్టి ఎవరూ ఇంకొకరి అసలు నంబర్ చూడరు.';

  @override
  String get msgMaskedInfo =>
      'PawSetu చాట్‌లు, కాల్స్‌లో ఫోన్ నంబర్లు దాచబడతాయి. చెల్లింపులు యాప్‌లోనే చేయండి.';

  @override
  String get msgMore => 'మరిన్ని ఎంపికలు';

  @override
  String get msgSearchInChat => 'చాట్‌లో వెతకండి';

  @override
  String msgMatches(int count) {
    return '$count దొరికాయి';
  }

  @override
  String get msgMute => 'నోటిఫికేషన్లు మ్యూట్ చేయండి';

  @override
  String get msgUnmute => 'నోటిఫికేషన్లు ఆన్ చేయండి';

  @override
  String get msgMutedToast => 'చాట్ మ్యూట్ అయింది';

  @override
  String get msgUnmutedToast => 'ఈ చాట్‌కు నోటిఫికేషన్లు ఆన్';

  @override
  String get msgBlock => 'బ్లాక్ చేయండి';

  @override
  String get msgUnblock => 'అన్‌బ్లాక్ చేయండి';

  @override
  String msgBlockTitle(String name) {
    return '$nameని బ్లాక్ చేయాలా?';
  }

  @override
  String get msgBlockBody =>
      'మీరు అన్‌బ్లాక్ చేసే వరకు ఈ చాట్‌లో ఎవరూ సందేశాలు పంపలేరు. మీ బుకింగ్‌లపై ప్రభావం ఉండదు.';

  @override
  String get msgBlockedToast => 'బ్లాక్ అయింది';

  @override
  String get msgUnblockedToast => 'అన్‌బ్లాక్ అయింది';

  @override
  String get msgYouBlocked =>
      'మీరు ఈ చాట్‌ను బ్లాక్ చేశారు. సందేశాలు పంపడానికి మెనూ నుండి అన్‌బ్లాక్ చేయండి.';

  @override
  String get msgBlockedByOther =>
      'ఈ చాట్ మూసివేయబడింది. మీరు ఇక్కడ సందేశాలు పంపలేరు.';

  @override
  String get msgReport => 'రిపోర్ట్ చేయండి';

  @override
  String get msgReportTitle => 'ఈ చాట్‌ను రిపోర్ట్ చేయండి';

  @override
  String get msgReportHint =>
      'PawSetu బృందం ప్రతి రిపోర్ట్‌ను సాధారణంగా ఒక రోజులో పరిశీలిస్తుంది.';

  @override
  String get msgReasonSpam => 'స్పామ్ లేదా ప్రకటనలు';

  @override
  String get msgReasonAbuse => 'అసభ్యంగా లేదా దూషణగా';

  @override
  String get msgReasonPayment => 'PawSetu బయట చెల్లించమని అడిగారు';

  @override
  String get msgReasonFake => 'నకిలీ ప్రొఫైల్ లేదా మోసం';

  @override
  String get msgReasonOther => 'ఇంకేదైనా';

  @override
  String get msgReportDetails => 'వివరాలు (ఐచ్ఛికం)';

  @override
  String get msgReportSend => 'రిపోర్ట్ పంపండి';

  @override
  String get msgReportedToast => 'ధన్యవాదాలు. మేము దీన్ని పరిశీలిస్తాం.';

  @override
  String get msgGetHelp => 'సహాయం పొందండి';

  @override
  String get msgTypingShort => 'టైప్ చేస్తున్నారు…';

  @override
  String msgTyping(String name) {
    return '$name టైప్ చేస్తున్నారు…';
  }

  @override
  String get msgTypeHint => 'సందేశం రాయండి';

  @override
  String get msgSend => 'పంపండి';

  @override
  String get msgAttach => 'ఫోటో లేదా PDF జోడించండి';

  @override
  String get msgAttachTitle => 'ఫైల్ పంపండి';

  @override
  String get msgAttachPdf => 'PDF పత్రం';

  @override
  String get msgAttachPdfHint =>
      'రిపోర్టులు, ప్రిస్క్రిప్షన్లు, సర్టిఫికెట్లు (10 MB వరకు)';

  @override
  String get msgPdfTooBig => 'ఈ ఫైల్ 10 MB కంటే పెద్దది. చిన్న PDF పంపండి.';

  @override
  String get msgSendFailed => 'పంపలేకపోయాం. కనెక్షన్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get msgNumberHiddenToast =>
      'అందరి భద్రత కోసం చాట్‌లలో ఫోన్ నంబర్లు దాచబడతాయి.';

  @override
  String get msgNumberHidden => 'నంబర్ దాచబడింది';

  @override
  String get msgPaymentWarnTitle => 'చెల్లింపులు PawSetuలోనే చేయండి';

  @override
  String get msgPaymentWarnBody =>
      'మీ సందేశంలో చెల్లింపు వివరాలు (UPI ID, కార్డ్ నంబర్, OTP లేదా PIN) ఉన్నట్లు ఉంది. OTP లేదా PIN ఎప్పుడూ పంచుకోవద్దు. PawSetu బయట చేసిన చెల్లింపులకు రక్షణ ఉండదు.';

  @override
  String get msgSendAnyway => 'అయినా పంపండి';

  @override
  String get msgSafetyNote =>
      'నంబర్లు దాచబడతాయి, చెల్లింపులు PawSetuలోనే జరుగుతాయి. OTP లేదా PIN ఎప్పుడూ పంచుకోవద్దు.';

  @override
  String get msgRecordVoice => 'వాయిస్ నోట్ రికార్డ్ చేయండి';

  @override
  String msgRecording(String elapsed, String max) {
    return 'రికార్డింగ్ $elapsed / $max';
  }

  @override
  String msgRecordingDemo(String elapsed) {
    return 'డెమో రికార్డింగ్ $elapsed';
  }

  @override
  String get msgCancelRecording => 'రికార్డింగ్ రద్దు చేయండి';

  @override
  String get msgSendVoice => 'వాయిస్ నోట్ పంపండి';

  @override
  String get msgPlayVoice => 'వాయిస్ నోట్ ప్లే చేయండి';

  @override
  String get msgPause => 'ఆపండి';

  @override
  String get msgVoiceCantPlay => 'ఈ వాయిస్ నోట్ ఈ పరికరంలో ప్లే కాదు.';

  @override
  String get msgMicUnavailableTitle => 'మైక్రోఫోన్ అందుబాటులో లేదు';

  @override
  String get msgMicUnavailable =>
      'వాయిస్ నోట్లు పంపడానికి ఫోన్ సెట్టింగ్‌లలో మైక్రోఫోన్ అనుమతి ఇవ్వండి.';

  @override
  String get msgMicDemoBody =>
      'ఇక్కడ మైక్రోఫోన్ అందుబాటులో లేదు. బదులుగా చిన్న డెమో వాయిస్ నోట్ పంపాలా?';

  @override
  String get msgRecordDemo => 'డెమో వాయిస్ నోట్ పంపండి';

  @override
  String get msgSent => 'పంపబడింది';

  @override
  String get msgRead => 'చదివారు';

  @override
  String get msgYesterday => 'నిన్న';

  @override
  String get msgDemoReply => 'డెమో జవాబు';

  @override
  String get msgPdf => 'PDF';

  @override
  String get msgTapToOpen => 'తెరవడానికి నొక్కండి';

  @override
  String get msgFileCantOpen => 'ఈ ఫైల్ ఇక్కడ తెరవలేము.';

  @override
  String get msgSampleStamp => 'నమూనా పత్రం · డెమో';

  @override
  String get msgSampleDocBody => 'ఇది డెమో చాట్‌లో పంచుకున్న నమూనా పత్రం.';

  @override
  String msgSysBookingChat(String pet, String when) {
    return '$when నాటి $pet బుకింగ్ కోసం చాట్';
  }

  @override
  String get msgSysTvStarted => 'చాట్ సంప్రదింపు అభ్యర్థించారు';

  @override
  String get msgSysTvStartedVideo => 'వీడియో సంప్రదింపు అభ్యర్థించారు';

  @override
  String msgSysTvScheduled(String when) {
    return '$whenకి సంప్రదింపు బుక్ అయింది';
  }

  @override
  String msgSysVetJoined(String name, String until) {
    return '$name చేరారు. చాట్ $until వరకు తెరిచి ఉంటుంది.';
  }

  @override
  String get msgSysTvEnded => 'సంప్రదింపు ముగిసింది';

  @override
  String msgSysCallEnded(String duration) {
    return 'వీడియో కాల్ ముగిసింది · $duration';
  }

  @override
  String get msgYourPet => 'మీ పెంపుడు జంతువు';

  @override
  String demoReplyClinic(String pet) {
    return 'మీ సందేశానికి ధన్యవాదాలు. క్లినిక్ బృందం $pet వివరాలు చూసి త్వరలో జవాబిస్తారు.';
  }

  @override
  String demoReplyVet(String pet) {
    return 'ధన్యవాదాలు, గమనించాను. ఈరోజు $pet ఎలా తింటోంది, తాగుతోంది?';
  }

  @override
  String demoReplyGroomer(String pet) {
    return 'తప్పకుండా! $petని బాగా చూసుకుంటాం. $petకి అలవాటైన షాంపూ ఉంటే తీసుకురండి.';
  }

  @override
  String demoReplyWalker(String pet) {
    return 'అర్థమైంది! $petని రోడ్డు నీడ వైపు నడిపించి మీకు ఫోటో పంపుతాను.';
  }

  @override
  String demoReplyTrainer(String pet) {
    return 'మంచి ప్రశ్న. తదుపరి సెషన్‌లో $petతో దీన్ని సాధన చేద్దాం.';
  }

  @override
  String demoReplyBoarder(String pet) {
    return '$pet బాగుంది, చక్కగా అలవాటు పడుతోంది. సాయంత్రం ఫోటో పంపుతాను.';
  }

  @override
  String demoReplyOwner(String name) {
    return 'ధన్యవాదాలు! ఇది చాలా సహాయపడింది. – $name';
  }

  @override
  String demoReplyOwnerVet(String name) {
    return 'ధన్యవాదాలు, డా. $name! అలాగే చేస్తాను.';
  }

  @override
  String demoVetGreeting(String owner, String pet) {
    return 'నమస్తే $owner, నేను వచ్చాను. మీరు $pet గురించి రాసింది చదివాను. ముందుగా కొన్ని ప్రశ్నలు: ఎప్పటి నుండి, $pet సరిగ్గా తింటోందా, తాగుతోందా?';
  }

  @override
  String ntfNewMessage(String name) {
    return '$name నుండి కొత్త సందేశం';
  }

  @override
  String ntfTeleVetMessage(String name) {
    return 'టెలి-వెట్: $name నుండి కొత్త సందేశం';
  }

  @override
  String get tvHomeTitle => 'వెట్‌తో మాట్లాడండి';

  @override
  String get tvHomeBody =>
      'నమోదైన వెట్‌తో చాట్ లేదా వీడియోలో మాట్లాడండి, సాధారణంగా కొన్ని నిమిషాల్లోనే.';

  @override
  String get tvStart => 'సంప్రదింపు ప్రారంభించండి';

  @override
  String get tvEmergencyNote =>
      'అత్యవసరమా? చాట్ కోసం ఆగకండి. దగ్గరలో తెరిచి ఉన్న క్లినిక్‌ని చేరడానికి SOS వాడండి.';

  @override
  String get tvOpenConsults => 'కొనసాగుతున్న సంప్రదింపులు';

  @override
  String get tvPastConsults => 'గత సంప్రదింపులు';

  @override
  String get tvPartnerHere => 'టెలి-వెట్ అభ్యర్థనలు మీ పోర్టల్‌లో ఉన్నాయి';

  @override
  String get tvPlanFree => 'మీ Free ప్లాన్';

  @override
  String get tvPlanPlus => 'మీ Plus ప్లాన్';

  @override
  String get tvFreeChip => 'Free';

  @override
  String tvLinePerMonth(int limit, int used) {
    return 'నెలకు $limit సంప్రదింపులు · $used వాడారు';
  }

  @override
  String get tvLineUnlimited => 'అపరిమిత సంప్రదింపులు';

  @override
  String tvLineMessages(int messages, int words) {
    return '$messages సందేశాల వరకు, ఒక్కోదానిలో $words పదాలు';
  }

  @override
  String tvLineHours(int hours) {
    return 'వెట్ చేరిన తర్వాత చాట్ $hours గంటలు తెరిచి ఉంటుంది';
  }

  @override
  String get tvLineVideo => 'వీడియో కాల్స్ ఉన్నాయి, 10% తగ్గింపుతో';

  @override
  String get tvLineNoVideo => 'వీడియో కాల్స్‌కు Plus అవసరం';

  @override
  String get tvMonthlyUsedTitle => 'ఈ నెల ఉచిత సంప్రదింపు వాడేశారు';

  @override
  String tvMonthlyUsed(String date) {
    return 'మీ తదుపరి ఉచిత సంప్రదింపు $dateన అందుబాటులోకి వస్తుంది. Plus తో అపరిమిత చాట్‌లు, వీడియో కాల్స్ వస్తాయి.';
  }

  @override
  String get tvPlusPromptTitle => 'వెట్‌లతో ఎక్కువ సమయం';

  @override
  String get tvPlusHint =>
      'Plus తో 300 పదాల 100 సందేశాల వరకు, 72 గంటల చాట్, వీడియో కాల్స్ వస్తాయి.';

  @override
  String get tvVideoPlusTitle => 'వీడియో కాల్స్ Plus లో భాగం';

  @override
  String get tvStatusQueuedShort => 'వేచి ఉంది';

  @override
  String get tvStatusActiveShort => 'కొనసాగుతోంది';

  @override
  String get tvStatusEndedShort => 'ముగిసింది';

  @override
  String get tvConsentTitle => 'ప్రారంభించే ముందు';

  @override
  String get tvConsentIntro =>
      'ఆన్‌లైన్ సంప్రదింపులు వెటర్నరీ కౌన్సిల్ ఆఫ్ ఇండియా మార్గదర్శకాల ప్రకారం జరుగుతాయి. దయచేసి చదివి అంగీకరించండి:';

  @override
  String get tvConsent1 =>
      'మీరు చెప్పినది, చూపించినది ఆధారంగా వెట్ సలహా ఇస్తారు. ఇది పూర్తి శారీరక పరీక్ష కాదు.';

  @override
  String get tvConsent2 =>
      'PawSetuలో ప్రతి వెట్ రాష్ట్ర వెటర్నరీ కౌన్సిల్‌లో నమోదయ్యారు. వారి రిజిస్ట్రేషన్ నంబర్ మీకు కనిపిస్తుంది.';

  @override
  String get tvConsent3 =>
      'పరీక్ష లేదా టెస్టులు అవసరమైతే క్లినిక్‌కి రమ్మని వెట్ చెప్పవచ్చు.';

  @override
  String get tvConsent4 =>
      'టెలి-వెట్ అత్యవసరాలకు కాదు. శ్వాస ఇబ్బంది, కుప్పకూలడం, మూర్ఛ, విషం, ఎక్కువ రక్తస్రావం ఉంటే SOS వాడండి.';

  @override
  String get tvConsent5 =>
      'వెట్‌కి సురక్షితం అనిపించినప్పుడే ప్రిస్క్రిప్షన్ ఇస్తారు, కొన్ని మందులకు క్లినిక్‌కి వెళ్లడం అవసరం.';

  @override
  String get tvConsent6 =>
      'మీ చాట్, ఫోటోలు, మీ పెంపుడు జంతువు రికార్డులు చికిత్స చేసే వెట్‌తో మాత్రమే పంచుకోబడతాయి.';

  @override
  String get tvConsentAgree => 'నేను చదివాను, అంగీకరిస్తున్నాను';

  @override
  String get tvConsentContinue => 'కొనసాగించండి';

  @override
  String get tvStepPet => 'పెంపుడు జంతువు';

  @override
  String get tvStepProblem => 'సమస్య';

  @override
  String get tvStepHow => 'వెట్';

  @override
  String get tvWhichPet => 'ఇది ఏ పెంపుడు జంతువు గురించి?';

  @override
  String get tvNoPet =>
      'వెట్‌తో మాట్లాడడానికి ముందు పెంపుడు జంతువును జోడించండి.';

  @override
  String tvDescribe(String pet) {
    return '$petకి ఏమవుతోంది?';
  }

  @override
  String get tvDescribeHint =>
      'ఎప్పుడు మొదలైంది, మీరు ఏమి గమనించారు, తినడం-తాగడం ఎలా ఉంది, ఏదైనా తిన్నదా';

  @override
  String get tvAddPhotos => 'ఫోటోలు జోడించండి';

  @override
  String get tvPhotosHint =>
      'సమస్య స్పష్టమైన ఫోటోలు (గాయం, దద్దుర్లు, మలం లేదా వాంతి) వెట్‌కి చాలా సహాయపడతాయి.';

  @override
  String get tvContinueToVet => 'ఎలా మాట్లాడాలో ఎంచుకోండి';

  @override
  String get tvChatNow => 'ఇప్పుడే చాట్ చేయండి';

  @override
  String get tvChatNowHint =>
      'అందుబాటులో ఉన్న తదుపరి వెట్ చేరతారు, సాధారణంగా కొన్ని నిమిషాల్లో';

  @override
  String get tvVideoNow => 'ఇప్పుడే వీడియో కాల్';

  @override
  String get tvVideoNowHint =>
      'వీడియో కాల్‌లో వెట్‌కి మీ పెంపుడు జంతువును చూపించండి';

  @override
  String get tvVideoPlusOnly => 'PawSetu Plus తో అందుబాటులో';

  @override
  String get tvChooseVet => 'వెట్‌ని ఎంచుకోండి';

  @override
  String get tvChooseVetHint =>
      'భాష, అనుభవం ఆధారంగా వెట్‌ని ఎంచుకోండి, ఇప్పుడు లేదా ఈరోజు తర్వాత';

  @override
  String get tvModeChat => 'చాట్';

  @override
  String get tvModeVideo => 'వీడియో';

  @override
  String tvVideoFee(String amount) {
    return 'వీడియో $amount';
  }

  @override
  String get tvWhen => 'ఎప్పుడు';

  @override
  String get tvNow => 'ఇప్పుడు';

  @override
  String get tvTomorrow => 'రేపు';

  @override
  String get tvSummary => 'సారాంశం';

  @override
  String get tvSummaryPet => 'పెంపుడు జంతువు';

  @override
  String get tvSummaryType => 'రకం';

  @override
  String get tvSummaryVet => 'వెట్';

  @override
  String get tvNextAvailable => 'అందుబాటులో ఉన్న తదుపరి వెట్';

  @override
  String get tvFee => 'ఫీజు';

  @override
  String get tvIncluded => 'మీ ప్లాన్‌లో ఉంది';

  @override
  String get tvVideoFeeLabel => 'వీడియో సంప్రదింపు';

  @override
  String tvPlusDiscount(int percent) {
    return 'Plus తగ్గింపు ($percent%)';
  }

  @override
  String tvChatRules(int messages, int words, int hours) {
    return '$words పదాల $messages సందేశాల వరకు. వెట్ చేరిన తర్వాత చాట్ $hours గంటలు తెరిచి ఉంటుంది.';
  }

  @override
  String get tvStartChat => 'చాట్ ప్రారంభించండి';

  @override
  String get tvStartVideo => 'వీడియో కాల్ ప్రారంభించండి';

  @override
  String tvPayAndStart(String amount) {
    return '$amount చెల్లించి ప్రారంభించండి';
  }

  @override
  String tvPayDescription(String pet) {
    return '$pet కోసం వీడియో సంప్రదింపు';
  }

  @override
  String tvFindingVet(String pet) {
    return '$pet కోసం వెట్‌ని వెతుకుతున్నాం…';
  }

  @override
  String get tvFindingVetHint =>
      'చాలా చాట్‌లు కొన్ని నిమిషాల్లోనే మొదలవుతాయి. మేము మీకు తెలియజేస్తాం.';

  @override
  String get tvFindingVetShort => 'వెట్‌ని వెతుకుతున్నాం…';

  @override
  String tvScheduledTitle(String when) {
    return '$whenకి సంప్రదింపు';
  }

  @override
  String get tvScheduledHint =>
      'వెట్ ఈ సమయానికి చేరతారు. అప్పటి వరకు మీరు మరిన్ని వివరాలు జోడించవచ్చు.';

  @override
  String get tvStatusQueued => 'వెట్ కోసం వేచి ఉంది';

  @override
  String get tvStatusActive => 'సంప్రదింపు కొనసాగుతోంది';

  @override
  String get tvStatusEnded => 'సంప్రదింపు ముగిసింది';

  @override
  String tvOpenUntil(String time) {
    return '$time వరకు తెరిచి ఉంటుంది';
  }

  @override
  String tvMessagesLeft(int count) {
    return '$count సందేశాలు మిగిలాయి';
  }

  @override
  String get tvPriority => 'ప్రాధాన్యత (Plus)';

  @override
  String get tvVideoCall => 'వీడియో కాల్';

  @override
  String get tvClosedShort => 'చాట్ మూసివేయబడింది';

  @override
  String tvEndedWith(String vet) {
    return 'ముగిసింది · $vet';
  }

  @override
  String tvVetBarTitle(String pet, String owner) {
    return '$pet · $owner';
  }

  @override
  String get tvRate => 'ఈ సంప్రదింపుకు రేటింగ్ ఇవ్వండి';

  @override
  String tvRateTitle(String vet) {
    return '$vetతో మీ చాట్ ఎలా ఉంది?';
  }

  @override
  String get tvRateComment => 'ఇంకేమైనా చెప్పాలా? (ఐచ్ఛికం)';

  @override
  String get tvRateSubmit => 'రేటింగ్ పంపండి';

  @override
  String get tvRateThanks => 'రేటింగ్ ఇచ్చినందుకు ధన్యవాదాలు!';

  @override
  String tvStars(int count) {
    return '$count నక్షత్రాలు';
  }

  @override
  String tvAllowanceLine(int words, int max, int left) {
    return '$words/$max పదాలు · $left సందేశాలు మిగిలాయి';
  }

  @override
  String tvWordsOver(int words, int max) {
    return '$words/$max పదాలు. దయచేసి సందేశం చిన్నది చేయండి.';
  }

  @override
  String tvWordsTitle(int max) {
    return 'సందేశాల్లో $max పదాల వరకు ఉండవచ్చు';
  }

  @override
  String tvWordsBody(int words, int max) {
    return 'మీ సందేశంలో $words పదాలు ఉన్నాయి, పరిమితి $max. చిన్న సందేశాలుగా విభజించండి లేదా ముఖ్య విషయాలే ఉంచండి; వెట్ మరిన్ని అడగవచ్చు.';
  }

  @override
  String get tvEditMessage => 'సందేశం మార్చండి';

  @override
  String tvNoMessagesTitle(int count) {
    return 'మీరు $count సందేశాలూ వాడేశారు';
  }

  @override
  String get tvNoMessagesBody =>
      'వెట్ ఇంకా జవాబు, ప్రిస్క్రిప్షన్ పంపగలరు. మరిన్ని ప్రశ్నలకు కొత్త సంప్రదింపు ప్రారంభించండి.';

  @override
  String get tvClosedTitle => 'ఈ చాట్ మూసివేయబడింది';

  @override
  String tvClosedBanner(int hours) {
    return 'వెట్ చేరిన తర్వాత చాట్ $hours గంటలు తెరిచి ఉంటుంది. మరింత సహాయం కావాలంటే కొత్త సంప్రదింపు ప్రారంభించండి.';
  }

  @override
  String get tvEndedTitle => 'సంప్రదింపు ముగిసింది';

  @override
  String get tvEndedBanner =>
      'వెట్ ఈ సంప్రదింపును ముగించారు. మీ చాట్, ప్రిస్క్రిప్షన్ మీ పెంపుడు జంతువు రికార్డుల్లో ఉంటాయి.';

  @override
  String get tvProblemLabel => 'చెప్పిన సమస్య';

  @override
  String get tvBookVisit => 'క్లినిక్ సందర్శన బుక్ చేయండి';

  @override
  String tvRecVisitMsg(String name) {
    return 'పరీక్ష కోసం క్లినిక్‌కి వెళ్లమని $name సూచిస్తున్నారు.';
  }

  @override
  String tvRecEmergencyMsg(String name) {
    return 'దీనికి ఇప్పుడే అత్యవసర చికిత్స అవసరమని $name చెబుతున్నారు. దగ్గరలో తెరిచి ఉన్న క్లినిక్‌ని చేరడానికి SOS వాడండి.';
  }

  @override
  String get tvConnecting => 'కనెక్ట్ అవుతోంది…';

  @override
  String get tvWaitingVetJoin => 'వెట్ చేరే వరకు వేచి ఉన్నాం…';

  @override
  String get tvDemoCall => 'డెమో కాల్';

  @override
  String get tvGoodNetwork => 'మంచి కనెక్షన్';

  @override
  String get tvWeakNetwork => 'బలహీన కనెక్షన్';

  @override
  String tvRemoteVideo(String name) {
    return '$name వీడియో';
  }

  @override
  String get tvSelfView => 'మీ కెమెరా';

  @override
  String get tvCameraOff => 'కెమెరా ఆఫ్‌లో ఉంది';

  @override
  String get tvCameraOffAction => 'కెమెరా ఆఫ్ చేయండి';

  @override
  String get tvCameraOnAction => 'కెమెరా ఆన్ చేయండి';

  @override
  String get tvMute => 'మ్యూట్ చేయండి';

  @override
  String get tvUnmute => 'అన్‌మ్యూట్ చేయండి';

  @override
  String get tvSpeakerOn => 'స్పీకర్ ఆన్';

  @override
  String get tvSpeakerOff => 'స్పీకర్ ఆఫ్';

  @override
  String get tvSwitchCamera => 'కెమెరా మార్చండి';

  @override
  String get tvFrontCamera => 'ముందు కెమెరా';

  @override
  String get tvBackCamera => 'వెనుక కెమెరా';

  @override
  String get tvEndCall => 'కాల్ ముగించండి';

  @override
  String tvCallEndedToast(String duration) {
    return 'కాల్ ముగిసింది · $duration';
  }

  @override
  String get tvCallFailed => 'కాల్ కనెక్ట్ కాలేదు.';

  @override
  String get tvCallLiveLater =>
      'నిజమైన వీడియో కాల్స్ PawSetu లైవ్ వెర్షన్‌తో వస్తాయి. ఈలోగా వెట్‌తో చాట్ కొనసాగించండి.';

  @override
  String get tvQueueTitle => 'టెలి-వెట్ క్యూ';

  @override
  String get tvQueueHint =>
      'Plus సభ్యులు, అత్యవసర కేసులు ముందు వస్తాయి. చాట్ ప్రారంభించడానికి అభ్యర్థనను అంగీకరించండి.';

  @override
  String get tvQueueEmpty => 'ప్రస్తుతం ఎవరూ వేచి లేరు.';

  @override
  String get tvWaiting => 'వేచి ఉన్నవి';

  @override
  String get tvInProgress => 'కొనసాగుతున్నవి';

  @override
  String get tvDoneToday => 'ఈరోజు పూర్తయినవి';

  @override
  String get tvPrescriptionsWritten => 'ప్రిస్క్రిప్షన్లు';

  @override
  String get tvNoActive => 'కొనసాగుతున్న సంప్రదింపులు లేవు.';

  @override
  String get tvRecent => 'ఇటీవలివి';

  @override
  String get tvUrgent => 'అత్యవసరం';

  @override
  String get tvAskedForYou => 'మిమ్మల్నే అడిగారు';

  @override
  String tvWaitingFor(int minutes) {
    return '$minutes నిమిషాలుగా వేచి ఉన్నారు';
  }

  @override
  String tvScheduledFor(String when) {
    return '$whenకి బుక్ అయింది';
  }

  @override
  String get tvAccept => 'అంగీకరించండి';

  @override
  String get tvView => 'చూడండి';

  @override
  String tvAcceptHint(String pet) {
    return '$pet గురించి చాట్ ప్రారంభించడానికి అంగీకరించండి. యజమానికి తెలియజేస్తాం.';
  }

  @override
  String get tvTabChat => 'చాట్';

  @override
  String get tvTabHistory => 'చరిత్ర';

  @override
  String get tvTabTools => 'గమనికలు, టూల్స్';

  @override
  String get tvOpenVetTools => 'వెట్ టూల్స్ తెరవండి';

  @override
  String tvUrgentSign(String sign) {
    return 'అత్యవసర లక్షణం: $sign';
  }

  @override
  String get tvFreeContext =>
      'Free ప్లాన్: మీకు ప్రాథమిక ప్రొఫైల్ కనిపిస్తుంది. Plus సభ్యులు పూర్తి ఆరోగ్య చరిత్ర పంచుకుంటారు.';

  @override
  String get tvTemperament => 'స్వభావం';

  @override
  String get tvRecentHealth => 'ఇటీవలి ఆరోగ్య రికార్డులు';

  @override
  String get tvNone => 'ఏమీ లేవు';

  @override
  String get tvPrivateNotes => 'వ్యక్తిగత గమనికలు';

  @override
  String get tvPrivateNotesHint => 'ఈ గమనికలు మీకు మాత్రమే కనిపిస్తాయి.';

  @override
  String get tvNotesPlaceholder => 'పరిశీలనలు, సాధ్యమయ్యే కారణాలు, ప్రణాళిక…';

  @override
  String get tvRecommend => 'సూచించండి';

  @override
  String get tvRecVisit => 'క్లినిక్ సందర్శన';

  @override
  String get tvRecEmergency => 'అత్యవసర చికిత్స';

  @override
  String tvRecVisitConfirm(String name) {
    return 'పరీక్ష కోసం పెంపుడు జంతువును క్లినిక్‌కి తీసుకురమ్మని $nameకి చెప్పాలా?';
  }

  @override
  String tvRecEmergencyConfirm(String name) {
    return 'దీనికి ఇప్పుడే అత్యవసర చికిత్స అవసరమని $nameకి చెప్పాలా? వారికి SOS బటన్ కనిపిస్తుంది.';
  }

  @override
  String get tvRecSent => 'సూచన పంపబడింది';

  @override
  String get tvRecDoneVisit => 'క్లినిక్ సందర్శన సూచించారు';

  @override
  String get tvRecDoneEmergency => 'అత్యవసర చికిత్స సూచించారు';

  @override
  String get tvSend => 'పంపండి';

  @override
  String get tvEnd => 'సంప్రదింపు ముగించండి';

  @override
  String get tvEndTitle => 'ఈ సంప్రదింపు ముగించాలా?';

  @override
  String get tvEndBody =>
      'యజమాని ఇక సందేశాలు పంపలేరు. చాట్, ప్రిస్క్రిప్షన్ వారి రికార్డుల్లో ఉంటాయి.';

  @override
  String get tvEndBodyNoRx =>
      'మీరు ప్రిస్క్రిప్షన్ రాయలేదు. అయినా ముగించాలా? యజమాని ఇక సందేశాలు పంపలేరు.';

  @override
  String get tvEndedToast => 'సంప్రదింపు ముగిసింది';

  @override
  String get tvVetSafetyNote =>
      'పరీక్ష లేదా టెస్టులు అవసరమైతే క్లినిక్‌కి రమ్మనండి. వ్యక్తిగత ఫోన్ నంబర్లు పంచుకోవద్దు.';

  @override
  String get rxWrite => 'ప్రిస్క్రిప్షన్ రాయండి';

  @override
  String rxTitleOf(String pet) {
    return '$pet కోసం ప్రిస్క్రిప్షన్';
  }

  @override
  String get rxTitle => 'ఇ-ప్రిస్క్రిప్షన్';

  @override
  String rxRegNo(String number) {
    return 'రిజి. నం. $number';
  }

  @override
  String get rxDiagnosis => 'నిర్ధారణ లేదా అంచనా';

  @override
  String get rxDiagnosisHint => 'ఉదా. తేలికపాటి గ్యాస్ట్రైటిస్';

  @override
  String get rxMedicines => 'మందులు';

  @override
  String rxMedicineN(int n) {
    return 'మందు $n';
  }

  @override
  String get rxMedicine => 'మందు, మోతాదు బలం';

  @override
  String get rxMedicineHint => 'ఉదా. Ondansetron 4 mg మాత్ర';

  @override
  String get rxDoseHint => 'మోతాదు, ఉదా. సగం మాత్ర';

  @override
  String get rxFreqOnce => 'రోజుకు ఒకసారి';

  @override
  String get rxFreqTwice => 'రోజుకు రెండుసార్లు';

  @override
  String get rxFreqThrice => 'రోజుకు మూడుసార్లు';

  @override
  String get rxFreqNeeded => 'అవసరమైనప్పుడు';

  @override
  String get rxDuration => 'ఎన్ని రోజులు';

  @override
  String rxDays(int count) {
    return '$count రోజులు';
  }

  @override
  String get rxInstructions => 'సూచనలు';

  @override
  String get rxAfterFood => 'భోజనం తర్వాత';

  @override
  String get rxBeforeFood => 'భోజనానికి ముందు';

  @override
  String get rxApplyThin => 'పలుచని పొర రాయండి';

  @override
  String get rxAddMedicine => 'మందు జోడించండి';

  @override
  String get rxNeedMedicine => 'కనీసం ఒక మందు జోడించండి.';

  @override
  String get rxAdvice => 'యజమానికి సలహా';

  @override
  String get rxAdviceHint =>
      'ఆహారం, విశ్రాంతి, ఏమి గమనించాలి, ఎప్పుడు మళ్లీ రావాలి';

  @override
  String get rxAddFollowUp => 'ఫాలో-అప్ తేదీ జోడించండి';

  @override
  String rxFollowUpOn(String date) {
    return '$dateన ఫాలో-అప్';
  }

  @override
  String get rxFollowUp => 'ఫాలో-అప్';

  @override
  String get rxNoFollowUp => 'ఫాలో-అప్ అవసరం లేదు';

  @override
  String rxWhereItGoes(String pet) {
    return 'ఇది $pet ఆరోగ్య రికార్డులకు, యజమాని వాల్ట్‌కు వెళ్తుంది, ఫాలో-అప్ ఉంటే రిమైండర్‌తో.';
  }

  @override
  String get rxPreview => 'ముందుగా చూడండి';

  @override
  String get rxSignTitle => 'సంతకం చేసి పంపాలా?';

  @override
  String rxSignBody(String owner, String pet) {
    return 'ఈ ప్రిస్క్రిప్షన్ మీ రిజిస్ట్రేషన్ నంబర్‌తో డిజిటల్‌గా సంతకం చేయబడి $pet కోసం $ownerకి పంపబడుతుంది.';
  }

  @override
  String get rxSignSend => 'సంతకం చేసి పంపండి';

  @override
  String rxSentToast(String owner, String pet) {
    return '$pet కోసం ప్రిస్క్రిప్షన్ $ownerకి పంపబడింది';
  }

  @override
  String rxSaved(String pet) {
    return '$pet ఆరోగ్య రికార్డుల్లో సేవ్ అయింది';
  }

  @override
  String rxCardTitle(String vet) {
    return '$vet నుండి ప్రిస్క్రిప్షన్';
  }

  @override
  String get rxView => 'ప్రిస్క్రిప్షన్ చూడండి';

  @override
  String get rxSentPreview => 'ప్రిస్క్రిప్షన్';

  @override
  String get rxPatient => 'రోగి';

  @override
  String get rxPetName => 'పేరు';

  @override
  String get rxSpeciesBreed => 'జాతి, బ్రీడ్';

  @override
  String rxSignedDigitally(String when) {
    return '$whenన డిజిటల్‌గా సంతకం చేశారు';
  }

  @override
  String get rxFooter =>
      'PawSetu ఇ-ప్రిస్క్రిప్షన్ · డెమో డేటా · వెట్ రిజిస్ట్రేషన్ నంబర్‌తో మాత్రమే చెల్లుతుంది';

  @override
  String rxDocTitle(String pet, String date) {
    return '$pet ప్రిస్క్రిప్షన్, $date';
  }

  @override
  String rxEventTitle(String vet) {
    return '$vetతో టెలి-వెట్ సంప్రదింపు';
  }

  @override
  String rxEventNotes(String medicines) {
    return 'సూచించిన మందులు: $medicines';
  }

  @override
  String rxFollowUpReminder(String pet, String vet) {
    return '$vetతో $pet ఫాలో-అప్';
  }

  @override
  String ntfTeleVetRequest(String pet, String owner) {
    return 'కొత్త టెలి-వెట్ అభ్యర్థన: $pet ($owner)';
  }

  @override
  String ntfVetJoined(String vet, String pet) {
    return '$pet గురించి మీ చాట్‌లో $vet చేరారు';
  }

  @override
  String ntfConsultEnded(String pet) {
    return '$pet టెలి-వెట్ సంప్రదింపు ముగిసింది';
  }

  @override
  String ntfPrescription(String vet, String pet) {
    return '$vet $pet కోసం ప్రిస్క్రిప్షన్ పంపారు';
  }

  @override
  String get albumPhotos => 'ఫోటోలు';

  @override
  String get albumTimeline => 'టైమ్‌లైన్';

  @override
  String get albumAlbums => 'ఆల్బమ్‌లు';

  @override
  String get albumFavourites => 'ఇష్టమైనవి';

  @override
  String get albumAdd => 'ఫోటోలు లేదా వీడియోలు జోడించండి';

  @override
  String albumAddTitle(String pet) {
    return '$pet ఆల్బమ్‌కు జోడించండి';
  }

  @override
  String albumAddFirst(String pet) {
    return '$pet మొదటి ఫోటో జోడించండి';
  }

  @override
  String get albumChoosePhotos => 'ఫోటోలు ఎంచుకోండి';

  @override
  String get albumChooseVideo => 'వీడియో ఎంచుకోండి';

  @override
  String get albumRecordVideo => 'వీడియో రికార్డ్ చేయండి';

  @override
  String get albumCaption => 'క్యాప్షన్';

  @override
  String get albumCaptionHint => 'ఈ క్షణంలో ఏమి జరుగుతోంది?';

  @override
  String get albumDateTaken => 'తీసిన తేదీ';

  @override
  String get albumMilestone => 'మైలురాయి';

  @override
  String get albumNoMilestone => 'మైలురాయి లేదు';

  @override
  String get albumAddMilestone => 'మైలురాయిగా గుర్తించండి';

  @override
  String get albumMilestoneTitle => 'మైలురాయి పేరు';

  @override
  String get albumMilestoneTitleHint => 'ఉదా. మొదటిసారి ఈత';

  @override
  String get albumMsGotcha => 'ఇంటికి వచ్చిన రోజు';

  @override
  String get albumMsFirstWalk => 'మొదటి నడక';

  @override
  String get albumMsFirstVaccine => 'మొదటి టీకా';

  @override
  String get albumMsBirthday => 'పుట్టినరోజు';

  @override
  String get albumMsCustom => 'ప్రత్యేక క్షణం';

  @override
  String get albumNewAlbum => 'కొత్త ఆల్బమ్';

  @override
  String get albumAlbumName => 'ఆల్బమ్ పేరు';

  @override
  String get albumUploading => 'మీ జ్ఞాపకాలు జోడిస్తున్నాం…';

  @override
  String albumPhotosAdded(int count) {
    return '$count జ్ఞాపకాలు జోడించాం';
  }

  @override
  String albumSaved(String pet) {
    return '$pet ఆల్బమ్‌లో సేవ్ అయింది';
  }

  @override
  String albumAddedToAlbum(String album) {
    return '$albumకి జోడించాం';
  }

  @override
  String get albumStorageNote =>
      'ఫోటోలు, వీడియోలు మీ ప్లాన్ స్టోరేజ్ వాడతాయి. Free లో 1 నిమిషం, Plus లో 3 నిమిషాల వరకు వీడియోలు.';

  @override
  String albumVideoMaxSec(int seconds) {
    return '$seconds సెకన్ల వరకు వీడియోలు';
  }

  @override
  String get albumVideoTooLongTitle => 'ఈ వీడియో చాలా పొడవుగా ఉంది';

  @override
  String albumVideoTooLong(int seconds, int limit) {
    return 'ఇది $seconds సెకన్లు; మీ ప్లాన్ $limit సెకన్ల వరకు అనుమతిస్తుంది.';
  }

  @override
  String get albumVideoPlusBody =>
      'ఫోన్‌లో చిన్నది చేయండి, లేదా PawSetu Plus తో 3 నిమిషాల వీడియోలు పొందండి.';

  @override
  String get albumEmptyTitle => 'ఇంకా జ్ఞాపకాలు లేవు';

  @override
  String albumEmptyBody(String pet) {
    return '$pet ఫోటోలు, వీడియోలు జోడించండి. ఇవి నెలల వారీగా విభజించబడతాయి, మైలురాళ్లు టైమ్‌లైన్‌లో కనిపిస్తాయి.';
  }

  @override
  String albumMonthCount(int count) {
    return '$count జ్ఞాపకాలు';
  }

  @override
  String get albumOnThisDay => 'ఈ రోజున';

  @override
  String get albumLatestMemory => 'తాజా జ్ఞాపకం';

  @override
  String albumOfPet(String pet) {
    return '$petతో ఒక క్షణం';
  }

  @override
  String get albumSeeAlbum => 'ఆల్బమ్ చూడండి';

  @override
  String albumYearsAgo(int count) {
    return '$count సంవత్సరాల క్రితం';
  }

  @override
  String albumTimelineBorn(String pet) {
    return '$pet జన్మించింది';
  }

  @override
  String albumTimelineEmpty(String pet) {
    return 'ఫోటోలు జోడించేటప్పుడు మైలురాళ్లు గుర్తించండి, $pet కథ ఇక్కడ కనిపిస్తుంది.';
  }

  @override
  String get albumCelebrate => 'వేడుక చేసుకోండి';

  @override
  String get albumBadges => 'మైలురాయి బ్యాడ్జ్‌లు';

  @override
  String get albumBadgeLocked => 'ఇంకా లేదు';

  @override
  String get albumNoAlbums => 'ఇంకా ఆల్బమ్‌లు లేవు';

  @override
  String get albumNoAlbumsBody =>
      'జ్ఞాపకాలను \"గోవా ట్రిప్\" లేదా \"మొదటి సంవత్సరం\" వంటి ఆల్బమ్‌లుగా చేయండి.';

  @override
  String get albumNoFavourites => 'ఇంకా ఇష్టమైనవి లేవు';

  @override
  String get albumNoFavouritesBody =>
      'ఫోటోపై గుండె గుర్తు నొక్కితే అది ఇక్కడ ఉంటుంది.';

  @override
  String albumChooseForAlbum(String album) {
    return '$album కోసం జ్ఞాపకాలు ఎంచుకోండి';
  }

  @override
  String albumItemsSelected(int count) {
    return '$count ఎంచుకున్నారు';
  }

  @override
  String get albumRenameAlbum => 'ఆల్బమ్ పేరు మార్చండి';

  @override
  String get albumDeleteAlbum => 'ఆల్బమ్ తీసివేయండి';

  @override
  String albumDeleteAlbumBody(String pet) {
    return 'ఫోటోలు $pet ఆల్బమ్‌లోనే ఉంటాయి. ఈ గుంపు మాత్రమే తీసివేయబడుతుంది.';
  }

  @override
  String get albumRemoveFromAlbum => 'ఆల్బమ్ నుండి తీసివేయండి';

  @override
  String get albumVideo => 'వీడియో';

  @override
  String albumOfCount(int index, int total) {
    return '$totalలో $index';
  }

  @override
  String get albumClose => 'మూసివేయండి';

  @override
  String get albumPrevious => 'మునుపటిది';

  @override
  String get albumFavourite => 'ఇష్టమైనవాటికి జోడించండి';

  @override
  String get albumUnfavourite => 'ఇష్టమైనవాటి నుండి తీసివేయండి';

  @override
  String get albumEditCaption => 'క్యాప్షన్ మార్చండి';

  @override
  String get albumAddToAlbum => 'ఆల్బమ్‌కు జోడించండి';

  @override
  String get albumShare => 'షేర్ చేయండి';

  @override
  String get albumDelete => 'తొలగించండి';

  @override
  String get albumDeleteQ => 'ఈ జ్ఞాపకాన్ని తొలగించాలా?';

  @override
  String albumDeleteBody(String pet) {
    return 'కుటుంబంలో అందరికీ $pet ఆల్బమ్ నుండి ఇది తొలగిపోతుంది.';
  }

  @override
  String get albumDeleted => 'జ్ఞాపకం తొలగించబడింది';

  @override
  String albumAddedBy(String name) {
    return '$name జోడించారు';
  }

  @override
  String get albumPlay => 'ప్లే చేయండి';

  @override
  String get albumPause => 'ఆపండి';

  @override
  String get albumVideoFailed => 'ఈ వీడియో ఇక్కడ ప్లే కాదు.';

  @override
  String get albumDemoVideo => 'డెమో వీడియో: అసలు ఫైల్ బదులు నమూనా క్లిప్.';

  @override
  String get albumShareTitle => 'జ్ఞాపకాలు షేర్ చేయండి';

  @override
  String get albumShareBody =>
      'WhatsApp లేదా ఏ యాప్‌కైనా పంపండి, లేదా కుటుంబం కోసం ప్రైవేట్ లింక్ చేయండి.';

  @override
  String get albumShareToApps => 'యాప్‌లకు షేర్ చేయండి';

  @override
  String get albumShareFailed => 'షేర్ కాలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get albumWatermark => 'PawSetu వాటర్‌మార్క్ జోడించండి';

  @override
  String get albumWatermarkPhotosOnly =>
      'ఫోటోలకు మాత్రమే; వీడియోలు అలాగే షేర్ అవుతాయి.';

  @override
  String get albumWatermarkText => 'PawSetu తో చేసింది';

  @override
  String get albumFamilyLink => 'కుటుంబం కోసం ప్రైవేట్ లింక్';

  @override
  String albumFamilyLinkBody(String pet) {
    return 'లింక్ ఉన్న ఎవరైనా గడువు వరకు $pet ఈ జ్ఞాపకాలు చూడగలరు. మీరు ఎప్పుడైనా ఆపవచ్చు.';
  }

  @override
  String get albumFamilyLinkWhich => 'ఏమి షేర్ చేయాలి';

  @override
  String get albumWholeAlbum => 'పూర్తి ఆల్బమ్';

  @override
  String albumFamilyLinkText(String pet, String url) {
    return 'PawSetuలో $pet ఫోటోలు: $url';
  }

  @override
  String albumSharedBy(String owner, String pet) {
    return '$owner $pet జ్ఞాపకాలు పంచుకున్నారు';
  }

  @override
  String get albumBirthdayScreenTitle => 'పుట్టినరోజు';

  @override
  String albumBirthdayToday(String pet) {
    return 'పుట్టినరోజు శుభాకాంక్షలు, $pet!';
  }

  @override
  String albumBirthdayIn(int days, String pet, int age) {
    return '$pet $days రోజుల్లో $age ఏళ్లు నిండుతుంది';
  }

  @override
  String albumBirthdaySubtitle(int age, String pet) {
    return '$petకి ఈరోజు $age ఏళ్లు';
  }

  @override
  String albumBirthdayWishes(String pet) {
    return 'ఈ సంవత్సరం $petకి ఎన్నో నడకలు, ట్రీట్లు, ముద్దులు!';
  }

  @override
  String get albumBirthdayMemories => 'ఈ సంవత్సరం జ్ఞాపకాలు';

  @override
  String get albumBirthdayAddPhoto => 'పుట్టినరోజు ఫోటో జోడించండి';

  @override
  String albumBirthdayReminder(String pet) {
    return '$pet పుట్టినరోజుకు ముందు గుర్తు చేయండి';
  }

  @override
  String albumBirthdayReminderTitle(String pet) {
    return '$pet పుట్టినరోజు దగ్గరలో ఉంది';
  }

  @override
  String get albumBirthdayReminderOn => 'పుట్టినరోజు రిమైండర్ ఆన్';

  @override
  String albumNoBirthday(String pet) {
    return 'ఇక్కడ వేడుక చేసుకోవడానికి $pet పుట్టినరోజు జోడించండి.';
  }

  @override
  String get vaultSetupTitle => 'మీ వాల్ట్‌ను రక్షించండి';

  @override
  String get vaultSetupBody =>
      '4 నుండి 6 అంకెల PIN ఎంచుకోండి. వాల్ట్ తెరిచిన ప్రతిసారి దీన్ని నమోదు చేయాలి.';

  @override
  String get vaultSetupBodyBio =>
      'బ్యాకప్‌గా 4 నుండి 6 అంకెల PIN ఎంచుకోండి. తర్వాత వేలిముద్ర లేదా ముఖంతో తెరవవచ్చు.';

  @override
  String get vaultChoosePin => 'PIN ఎంచుకోండి';

  @override
  String get vaultConfirmPin => 'PIN మళ్లీ నమోదు చేయండి';

  @override
  String get vaultCurrentPin => 'ప్రస్తుత PIN';

  @override
  String get vaultSetPinButton => 'PIN సెట్ చేయండి';

  @override
  String get vaultPinMismatch => 'PINలు సరిపోలలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get vaultPinWeak =>
      'ఈ PIN ఊహించడం సులభం. 1234 లేదా ఒకే అంకెలు వాడవద్దు.';

  @override
  String get vaultPinSet => 'వాల్ట్ PIN సెట్ అయింది';

  @override
  String get vaultPinChanged => 'PIN మారింది';

  @override
  String get vaultChangePin => 'PIN మార్చండి';

  @override
  String vaultPinDigits(int count) {
    return '$count అంకెలు నమోదు చేశారు';
  }

  @override
  String get vaultPinBackspace => 'చివరి అంకె తొలగించండి';

  @override
  String get vaultLockedTitle => 'వాల్ట్ లాక్ అయింది';

  @override
  String get vaultLockedBody =>
      'మీ పెంపుడు జంతువు పత్రాలు సురక్షితంగా ఉన్నాయి. కొనసాగడానికి అన్‌లాక్ చేయండి.';

  @override
  String get vaultUnlock => 'అన్‌లాక్ చేయండి';

  @override
  String get vaultUseBiometrics => 'వేలిముద్ర లేదా ముఖం వాడండి';

  @override
  String get vaultBiometricReason => 'మీ PawSetu పత్రాల వాల్ట్‌ను తెరవండి';

  @override
  String get vaultBiometricsToggle => 'వేలిముద్ర లేదా ముఖంతో తెరవండి';

  @override
  String get vaultWrongPin => 'తప్పు PIN.';

  @override
  String vaultTriesLeft(int count) {
    return '$count ప్రయత్నాలు మిగిలాయి.';
  }

  @override
  String vaultLockedOut(int seconds) {
    return 'చాలా తప్పు ప్రయత్నాలు. $seconds సెకన్ల తర్వాత మళ్లీ ప్రయత్నించండి.';
  }

  @override
  String get vaultForgotPin => 'PIN మర్చిపోయారా?';

  @override
  String get vaultForgotPinTitle => 'వాల్ట్ PIN రీసెట్ చేయండి';

  @override
  String get vaultForgotPinBody =>
      'ఇది మీరేనని నిరూపించడానికి మళ్లీ సైన్ ఇన్ చేసి, కొత్త PIN ఎంచుకోండి. మీ పత్రాలు సురక్షితంగా ఉంటాయి.';

  @override
  String get vaultSignInAgain => 'మళ్లీ సైన్ ఇన్ చేయండి';

  @override
  String get vaultAutoLockNote =>
      '2 నిమిషాలు ఉపయోగించకపోతే వాల్ట్ దానంతట అదే లాక్ అవుతుంది.';

  @override
  String get vaultLockNow => 'ఇప్పుడే లాక్ చేయండి';

  @override
  String get vaultLockSettings => 'వాల్ట్ లాక్';

  @override
  String vaultOfPet(String pet) {
    return '$pet పత్రాలు';
  }

  @override
  String get vaultAllDocs => 'అన్ని పత్రాలు';

  @override
  String vaultDocCount(int count) {
    return '$count పత్రాలు';
  }

  @override
  String get vaultSearchHint => 'శీర్షికలు, ట్యాగ్‌లు లేదా వెట్‌లను వెతకండి';

  @override
  String get vaultClearSearch => 'వెతుకులాట తీసివేయండి';

  @override
  String get vaultNeedsAttention => 'గమనించాల్సినవి';

  @override
  String get vaultNeedsReview => 'వివరాలు చూడండి';

  @override
  String vaultAddedOn(String date) {
    return '$dateన జోడించారు';
  }

  @override
  String get vaultEmptyTitle => 'మీ వాల్ట్ ఖాళీగా ఉంది';

  @override
  String get vaultEmptyBody =>
      'టీకా సర్టిఫికెట్లు, ప్రిస్క్రిప్షన్లు, ల్యాబ్ రిపోర్టులు, బీమా ఒకే చోట సురక్షితంగా ఉంచండి.';

  @override
  String get vaultAddDocument => 'పత్రం జోడించండి';

  @override
  String get vaultStorageTitle => 'స్టోరేజ్';

  @override
  String vaultStorageUsed(String used, String limit) {
    return '$limitలో $used వాడారు';
  }

  @override
  String vaultStorageSplit(String docs, String album) {
    return 'పత్రాలు $docs · ఆల్బమ్ $album';
  }

  @override
  String get vaultStorageFullTitle => 'స్టోరేజ్ నిండిపోయింది';

  @override
  String vaultStorageFullBody(String used, String limit) {
    return '$limitలో $used వాడేశారు. పాత ఫైళ్లు తొలగించండి లేదా PawSetu Plus తో 25 GB పొందండి.';
  }

  @override
  String vaultStorageFullBodyPlus(String used, String limit) {
    return '$limitలో $used వాడేశారు. చోటు కోసం పాత ఫైళ్లు తొలగించండి.';
  }

  @override
  String get vaultTooBig =>
      'ఈ ఫైల్ చాలా పెద్దది. 20 MB కంటే చిన్నది ఎంచుకోండి.';

  @override
  String get vaultTypeVaccination => 'టీకా సర్టిఫికెట్';

  @override
  String get vaultTypePrescription => 'ప్రిస్క్రిప్షన్';

  @override
  String get vaultTypeLab => 'ల్యాబ్ రిపోర్ట్';

  @override
  String get vaultTypeInsurance => 'బీమా';

  @override
  String get vaultTypeInvoice => 'బిల్లు';

  @override
  String get vaultTypeLicence => 'మున్సిపల్ లైసెన్స్';

  @override
  String get vaultTypeAdoption => 'దత్తత లేదా కొనుగోలు పత్రాలు';

  @override
  String get vaultTypeTravel => 'ప్రయాణం లేదా ఆరోగ్య సర్టిఫికెట్';

  @override
  String get vaultTypeOther => 'ఇతర';

  @override
  String get vaultExpired => 'గడువు ముగిసింది';

  @override
  String get vaultExpiresSoon => 'త్వరలో గడువు';

  @override
  String vaultExpiresOn(String date) {
    return '$dateన గడువు ముగుస్తుంది';
  }

  @override
  String vaultExpiredOn(String date) {
    return '$dateన గడువు ముగిసింది';
  }

  @override
  String get vaultNoExpiry => 'గడువు తేదీ లేదు';

  @override
  String get vaultUploadTitle => 'పత్రం జోడించండి';

  @override
  String get vaultForPet => 'ఏ పెంపుడు జంతువు కోసం?';

  @override
  String get vaultScanCamera => 'కెమెరాతో స్కాన్ చేయండి';

  @override
  String get vaultScanCameraHint =>
      'అంచులు ఆటోమేటిక్‌గా దొరుకుతాయి; అవసరమైతే మూలలు సరిచేయండి';

  @override
  String get vaultFromGallery => 'గ్యాలరీ నుండి ఫోటో';

  @override
  String get vaultFromPdf => 'PDF ఫైల్';

  @override
  String get vaultPdfOnly => 'దయచేసి PDF ఫైల్ ఎంచుకోండి.';

  @override
  String get vaultTrySample =>
      'డెమో: ఆటో-రీడ్ చూడడానికి నమూనా పత్రం ప్రయత్నించండి';

  @override
  String get vaultSampleRabies => 'నమూనా రేబీస్ సర్టిఫికెట్';

  @override
  String get vaultSampleLab => 'నమూనా రక్త పరీక్ష రిపోర్ట్';

  @override
  String get vaultSampleInsurance => 'నమూనా బీమా పాలసీ';

  @override
  String get vaultUploading => 'సురక్షితంగా సేవ్ చేస్తున్నాం…';

  @override
  String get vaultScanTitle => 'స్కాన్ సరిచేయండి';

  @override
  String get vaultScanHint => 'మూలలను పేజీ అంచుల వరకు లాగండి.';

  @override
  String get vaultScanAuto => 'పేజీ అంచులు దొరికాయి. అవసరమైతే మూలలు సరిచేయండి.';

  @override
  String get vaultScanBw => 'నలుపు-తెలుపు (స్పష్టమైన అక్షరాలు)';

  @override
  String get vaultScanCorner => 'మూల హ్యాండిల్, సరిచేయడానికి లాగండి';

  @override
  String get vaultUseScan => 'ఈ స్కాన్ వాడండి';

  @override
  String get vaultPreviewFailed => 'ఈ ఫైల్ ప్రివ్యూ చూపించలేకపోయాం.';

  @override
  String get vaultReading => 'పత్రాన్ని చదువుతున్నాం…';

  @override
  String get vaultCheckDetails => 'వివరాలు సరిచూడండి';

  @override
  String get vaultCheckDetailsHint =>
      'ఇవి పత్రం నుండి చదివాం. దయచేసి నిర్ధారించండి లేదా సరిచేయండి.';

  @override
  String get vaultAddDetails => 'వివరాలు జోడించండి';

  @override
  String get vaultFoundTitle => 'మాకు ఈ వివరాలు దొరికాయి';

  @override
  String get vaultFoundBody =>
      'సేవ్ చేసే ముందు ప్రతి వివరం చూడండి. మీరు నిర్ధారించే వరకు ఏదీ సేవ్ కాదు.';

  @override
  String get vaultNotFoundTitle => 'దీన్ని చదవలేకపోయాం';

  @override
  String get vaultNotFoundBody =>
      'వివరాలు మీరే జోడించండి, లేదా వదిలేసి తర్వాత జోడించండి.';

  @override
  String get vaultDemoReadNote =>
      'డెమో ఆటో-రీడ్: వివరాలు నమూనా పత్రం నుండి వస్తాయి, మీ ఫైల్ నిజమైన స్కాన్ నుండి కాదు.';

  @override
  String vaultPetMismatch(String docPet, String pet) {
    return 'పత్రంలో $docPet అని ఉంది, కానీ మీరు $petని ఎంచుకున్నారు. సేవ్ చేసే ముందు చూడండి.';
  }

  @override
  String get vaultFieldDocType => 'పత్రం రకం';

  @override
  String get vaultFieldTitle => 'శీర్షిక';

  @override
  String get vaultFieldTags => 'ట్యాగ్‌లు';

  @override
  String get vaultTagHint => 'ఉదా. రేబీస్, 2026';

  @override
  String get vaultAddTag => 'ట్యాగ్ జోడించండి';

  @override
  String vaultAddToHealth(String pet) {
    return '$pet ఆరోగ్య రికార్డులకు జోడించండి';
  }

  @override
  String get vaultAddToHealthHint =>
      'టీకా నమోదవుతుంది, తదుపరి మోతాదు మీ కోసం షెడ్యూల్ అవుతుంది.';

  @override
  String get vaultVaccineNeeded =>
      'ఆరోగ్య రికార్డుల్లో సేవ్ చేయడానికి టీకా పేరు, ఇచ్చిన తేదీ జోడించండి.';

  @override
  String get vaultTrackInsurance => 'ఈ పాలసీని బీమాలో ట్రాక్ చేయండి';

  @override
  String get vaultExpiryReminderNote =>
      'గడువు ముగియడానికి 30 రోజుల ముందు గుర్తు చేస్తాం.';

  @override
  String get vaultSaveDetails => 'సేవ్ చేయండి';

  @override
  String get vaultSkipDetails => 'ఇప్పటికి వదిలేయండి';

  @override
  String get vaultSaved => 'వాల్ట్‌లో సేవ్ అయింది';

  @override
  String vaultSavedVaccine(String vaccine, String pet) {
    return '$pet కోసం $vaccine నమోదైంది';
  }

  @override
  String vaultReminderTitle(String title, String pet) {
    return '$pet $title గడువు త్వరలో ముగుస్తుంది';
  }

  @override
  String vaultTitleVaccineCert(String vaccine) {
    return '$vaccine సర్టిఫికెట్';
  }

  @override
  String vaultTitlePolicy(String insurer) {
    return '$insurer పాలసీ';
  }

  @override
  String get vaultDocDetails => 'పత్రం వివరాలు';

  @override
  String get vaultDetailsRead => 'వివరాలు';

  @override
  String get vaultEditDetails => 'వివరాలు మార్చండి';

  @override
  String vaultConfirmedBy(String name, String date) {
    return '$dateన $name సరిచూశారు';
  }

  @override
  String get vaultFieldPetName => 'పెంపుడు జంతువు పేరు';

  @override
  String get vaultFieldIssuedOn => 'జారీ చేసిన తేదీ';

  @override
  String get vaultFieldExpiry => 'చెల్లుబాటు గడువు';

  @override
  String get vaultFieldIssuer => 'జారీ చేసినవారు';

  @override
  String get vaultFieldVetReg => 'వెట్ రిజి. నం.';

  @override
  String get vaultFieldReference => 'రిఫరెన్స్ నం.';

  @override
  String get vaultFieldTest => 'పరీక్ష';

  @override
  String get vaultFieldAmount => 'మొత్తం';

  @override
  String get vaultFileType => 'ఫైల్ రకం';

  @override
  String get vaultFileSize => 'పరిమాణం';

  @override
  String get vaultAddedLabel => 'జోడించిన తేదీ';

  @override
  String get vaultPdf => 'PDF';

  @override
  String get vaultPhoto => 'ఫోటో';

  @override
  String get vaultSample => 'నమూనా';

  @override
  String get vaultTapToZoom => 'పెద్దది చేయడానికి నొక్కండి';

  @override
  String get vaultSecureNote =>
      'మీ ఖాతాలో ప్రైవేట్‌గా భద్రపరచబడింది. మీరు, మీరు లింక్ పంచుకున్నవారు మాత్రమే చూడగలరు.';

  @override
  String vaultLinkedVaccine(String pet) {
    return '$pet టీకా రికార్డుకు లింక్ అయింది';
  }

  @override
  String get vaultOpenInApp => 'PawSetuలో తెరవండి';

  @override
  String get vaultOpenPolicy => 'పాలసీ తెరవండి';

  @override
  String get vaultTrackPolicy => 'బీమాలో ట్రాక్ చేయండి';

  @override
  String get vaultShareWithVet => 'వెట్‌తో షేర్ చేయండి';

  @override
  String get vaultDeleteDoc => 'పత్రం తొలగించండి';

  @override
  String vaultDeleteDocQ(String title) {
    return '\"$title\" తొలగించాలా?';
  }

  @override
  String vaultDeleteDocBody(String pet) {
    return 'ఇది $pet వాల్ట్ నుండి తొలగిపోతుంది, దీని షేర్ లింక్‌లు పని చేయవు.';
  }

  @override
  String get vaultDeleted => 'పత్రం తొలగించబడింది';

  @override
  String get vaultShareTitle => 'వెట్‌తో షేర్ చేయండి';

  @override
  String get vaultShareBody =>
      'మీరు ఎంచుకున్న పత్రాలు మాత్రమే, పరిమిత సమయం వరకు తెరిచే లింక్ చేయండి.';

  @override
  String get vaultChooseDocs => 'షేర్ చేయాల్సిన పత్రాలు';

  @override
  String get vaultSelectOneDoc => 'కనీసం ఒక పత్రం ఎంచుకోండి.';

  @override
  String get vaultLinkValidFor => 'లింక్ ఎంత సేపు పని చేస్తుంది';

  @override
  String get vaultExpiry1h => '1 గంట';

  @override
  String get vaultExpiry24h => '24 గంటలు';

  @override
  String get vaultExpiry7d => '7 రోజులు';

  @override
  String get vaultExpiryNever => 'నేను ఆపే వరకు';

  @override
  String get vaultAddPin => 'PIN అడగండి';

  @override
  String get vaultAddPinHint =>
      'లింక్ తెరవడానికి వెట్ ఈ 4 నుండి 6 అంకెల PIN నమోదు చేస్తారు.';

  @override
  String get vaultPinFormat => 'PIN 4 నుండి 6 అంకెలు ఉండాలి.';

  @override
  String get vaultCreateLink => 'లింక్ చేయండి';

  @override
  String get vaultLinkReady => 'లింక్ సిద్ధం';

  @override
  String vaultLinkPinIs(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get vaultSendTo => 'లింక్ పంపండి';

  @override
  String get vaultSendPhoneTo => 'వెట్ ఫోన్ నంబర్';

  @override
  String get vaultSendEmailTo => 'వెట్ ఈమెయిల్';

  @override
  String get vaultSend => 'పంపండి';

  @override
  String vaultSentTo(String target) {
    return 'లింక్ $targetకి పంపాం (డెమో: డెమో అవుట్‌బాక్స్‌లో)';
  }

  @override
  String get vaultShareCopiedInstead =>
      'లింక్ కాపీ అయింది. ఏ యాప్‌లోనైనా పేస్ట్ చేయండి.';

  @override
  String get vaultShareEmailSubject =>
      'PawSetu నుండి పెంపుడు జంతువు ఆరోగ్య పత్రాలు';

  @override
  String vaultShareText(String name, String pet, String url) {
    return '$name PawSetuలో $pet ఆరోగ్య పత్రాలను మీతో పంచుకున్నారు: $url';
  }

  @override
  String get vaultShareLinks => 'షేర్ లింక్‌లు';

  @override
  String get vaultLinksNote =>
      'లింక్‌లు మీరు ఎంచుకున్న పత్రాలనే తెరుస్తాయి, గడువు ముగిసినప్పుడు లేదా మీరు ఆపినప్పుడు పని చేయడం ఆగిపోతుంది.';

  @override
  String get vaultLinksOld => 'ముగిసినవి, ఆపినవి';

  @override
  String get vaultNoLinks => 'ఇంకా షేర్ లింక్‌లు లేవు';

  @override
  String get vaultNoLinksBody =>
      'వాల్ట్‌లోని ఏ పత్రం నుండైనా వెట్‌తో షేర్ చేయండి.';

  @override
  String get vaultLinkActive => 'చురుకుగా ఉంది';

  @override
  String get vaultLinkExpired => 'గడువు ముగిసింది';

  @override
  String get vaultLinkRevoked => 'ఆపేశారు';

  @override
  String vaultLinkDocs(int count) {
    return '$count పత్రాలు';
  }

  @override
  String get vaultLinkAlbum => 'ఆల్బమ్ లింక్';

  @override
  String vaultLinkWorksUntil(String when) {
    return '$when వరకు పని చేస్తుంది';
  }

  @override
  String get vaultLinkNoEnd => 'మీరు ఆపే వరకు పని చేస్తుంది';

  @override
  String vaultLinkOpened(int count) {
    return '$count సార్లు తెరిచారు';
  }

  @override
  String get vaultHasPin => 'PIN';

  @override
  String vaultCreatedOn(String when) {
    return '$whenన చేశారు';
  }

  @override
  String vaultRevokedOn(String when) {
    return '$whenన ఆపేశారు';
  }

  @override
  String get vaultAccessLog => 'యాక్సెస్ లాగ్';

  @override
  String get vaultNoAccess => 'ఇంకా ఎవరూ ఈ లింక్ తెరవలేదు.';

  @override
  String get vaultAccessOk => 'తెరిచారు';

  @override
  String get vaultAccessWrongPin => 'తప్పు PIN ప్రయత్నించారు';

  @override
  String get vaultRevoke => 'లింక్ ఆపండి';

  @override
  String get vaultRevokeQ => 'ఈ లింక్ ఆపాలా?';

  @override
  String get vaultRevokeBody =>
      'దీన్ని తెరిచినవారికి ఇది ఇక పని చేయదని కనిపిస్తుంది. మీ పత్రాలు వాల్ట్‌లోనే ఉంటాయి.';

  @override
  String get vaultRevoked => 'లింక్ ఆపేశాం';

  @override
  String vaultSharedBy(String owner, String pet) {
    return '$owner $pet పత్రాలను పంచుకున్నారు';
  }

  @override
  String vaultSharedUntil(String when) {
    return '$when వరకు అందుబాటులో';
  }

  @override
  String get vaultViewOnly => 'చూడడానికి మాత్రమే';

  @override
  String get vaultNoMatches => 'ఈ లింక్‌లో పత్రాలు లేవు';

  @override
  String get vaultSharedFooter =>
      'PawSetu ద్వారా సురక్షితంగా పంచుకున్నారు. యజమాని ఈ లింక్‌ను ఎప్పుడైనా ఆపవచ్చు.';

  @override
  String get vaultGetPawSetu => 'PawSetu పొందండి';

  @override
  String get vaultEnterSharePin => 'PIN నమోదు చేయండి';

  @override
  String vaultEnterSharePinBody(String owner) {
    return '$owner ఈ పత్రాలను PIN తో రక్షించారు. వారిని PIN అడగండి.';
  }

  @override
  String get vaultLinkPin => 'PIN';

  @override
  String get vaultOpenLink => 'తెరవండి';

  @override
  String get vaultShareWrongPin => 'తప్పు PIN. మళ్లీ ప్రయత్నించండి.';

  @override
  String get vaultShareLocked =>
      'చాలా తప్పు ప్రయత్నాలు. 15 నిమిషాల తర్వాత మళ్లీ ప్రయత్నించండి.';

  @override
  String get vaultLinkStopped => 'ఈ లింక్ అందుబాటులో లేదు';

  @override
  String vaultLinkExpiredBody(String when) {
    return 'ఇది $whenన గడువు ముగిసింది. యజమానిని కొత్త లింక్ అడగండి.';
  }

  @override
  String get vaultLinkRevokedBody =>
      'యజమాని ఈ లింక్‌ను ఆపేశారు. వారిని కొత్త లింక్ అడగండి.';

  @override
  String get vaultLinkNotFoundBody => 'లింక్ పూర్తిగా కాపీ అయిందో చూడండి.';

  @override
  String get vaultInsuranceTitle => 'పెంపుడు జంతువు బీమా';

  @override
  String get vaultInsuranceNote =>
      'PawSetu బీమా అమ్మదు. మీ పాలసీ, రెన్యూవల్, క్లెయిమ్‌లను ఇక్కడ ట్రాక్ చేయండి.';

  @override
  String get vaultNoPolicies => 'ఇంకా పాలసీలు లేవు';

  @override
  String get vaultNoPoliciesBody =>
      'కవర్, రెన్యూవల్ తేదీలు, క్లెయిమ్‌లు ట్రాక్ చేయడానికి మీ పెంపుడు జంతువు బీమా జోడించండి.';

  @override
  String get vaultAddPolicy => 'పాలసీ జోడించండి';

  @override
  String get vaultEditPolicy => 'పాలసీ మార్చండి';

  @override
  String vaultPolicyFor(String pet) {
    return '$pet పాలసీ';
  }

  @override
  String get vaultFieldInsurer => 'బీమా కంపెనీ';

  @override
  String get vaultPlanName => 'ప్లాన్ పేరు';

  @override
  String get vaultFieldPolicyNo => 'పాలసీ నంబర్';

  @override
  String get vaultFieldCover => 'బీమా మొత్తం (₹)';

  @override
  String get vaultFieldPremium => 'వార్షిక ప్రీమియం (₹)';

  @override
  String get vaultFieldCoverStart => 'కవర్ ప్రారంభం';

  @override
  String get vaultFieldRenewal => 'రెన్యూవల్ తేదీ';

  @override
  String get vaultRenewalReminderNote =>
      'రెన్యూవల్‌కు 30 రోజుల ముందు గుర్తు చేస్తాం.';

  @override
  String vaultInsuranceReminderTitle(String pet) {
    return '$pet బీమా త్వరలో రెన్యూ అవుతుంది';
  }

  @override
  String get vaultPolicyDoc => 'పాలసీ పత్రం';

  @override
  String get vaultLinkDoc => 'వాల్ట్ నుండి పాలసీ పత్రాన్ని లింక్ చేయండి';

  @override
  String get vaultNoDocLinked => 'పత్రం లింక్ కాలేదు';

  @override
  String get vaultAttachDoc => 'వాల్ట్ నుండి జోడించండి';

  @override
  String vaultAttached(String title) {
    return 'జోడించారు: $title';
  }

  @override
  String get vaultDocMissing => 'ఈ పాలసీ ఇప్పుడు అందుబాటులో లేదు.';

  @override
  String get vaultCover => 'కవర్';

  @override
  String vaultCoverLeft(String amount) {
    return 'ఈ సంవత్సరం $amount కవర్ మిగిలింది';
  }

  @override
  String get vaultPremium => 'ప్రీమియం';

  @override
  String vaultPremiumYear(String amount) {
    return 'సంవత్సరానికి $amount';
  }

  @override
  String get vaultPolicyActive => 'చురుకుగా ఉంది';

  @override
  String get vaultPolicyLapsed => 'ల్యాప్స్ అయింది';

  @override
  String get vaultRenewSoon => 'త్వరలో రెన్యూ చేయండి';

  @override
  String get vaultDeletePolicyQ => 'ఈ పాలసీ తొలగించాలా?';

  @override
  String get vaultDeletePolicyBody =>
      'దీని క్లెయిమ్‌లు కూడా తొలగిపోతాయి. పాలసీ పత్రం వాల్ట్‌లోనే ఉంటుంది.';

  @override
  String get vaultClaims => 'క్లెయిమ్‌లు';

  @override
  String vaultOpenClaims(int count) {
    return '$count తెరిచి ఉన్నాయి';
  }

  @override
  String get vaultNoClaims => 'ఇంకా క్లెయిమ్‌లు లేవు';

  @override
  String get vaultNewClaim => 'కొత్త క్లెయిమ్';

  @override
  String get vaultClaimFor => 'క్లెయిమ్ దేని కోసం?';

  @override
  String get vaultClaimForHint => 'ఉదా. బ్రూనో కాలు ఎక్స్-రే, చికిత్స';

  @override
  String get vaultClaimAmount => 'క్లెయిమ్ మొత్తం';

  @override
  String get vaultClaimDate => 'చికిత్స తేదీ';

  @override
  String get vaultClaimChecklist => 'పత్రాల చెక్‌లిస్ట్';

  @override
  String vaultChecklistProgress(int done, int total) {
    return '$totalలో $done సిద్ధం';
  }

  @override
  String get vaultCkClaimForm => 'నింపిన క్లెయిమ్ ఫారం';

  @override
  String get vaultCkVetBills => 'వెట్ బిల్లులు, రసీదులు';

  @override
  String get vaultCkPrescription => 'ప్రిస్క్రిప్షన్';

  @override
  String get vaultCkLabReports => 'ల్యాబ్ లేదా ఎక్స్-రే రిపోర్టులు';

  @override
  String get vaultCkPolicyCopy => 'పాలసీ కాపీ';

  @override
  String get vaultCkPetPhoto => 'పెంపుడు జంతువు ఇటీవలి ఫోటో';

  @override
  String get vaultCkIdProof => 'మీ గుర్తింపు పత్రం';

  @override
  String get vaultReadyToSubmit =>
      'సమర్పించే ముందు చెక్‌లిస్ట్‌లో అన్ని పత్రాలకు టిక్ చేయండి.';

  @override
  String vaultMarkAs(String status) {
    return '$statusగా గుర్తించండి';
  }

  @override
  String get vaultClaimDraft => 'డ్రాఫ్ట్';

  @override
  String get vaultClaimSubmitted => 'సమర్పించారు';

  @override
  String get vaultClaimInReview => 'పరిశీలనలో ఉంది';

  @override
  String get vaultClaimApproved => 'ఆమోదించారు';

  @override
  String get vaultClaimRejected => 'తిరస్కరించారు';

  @override
  String get vaultClaimPaid => 'చెల్లించారు';

  @override
  String vaultClaimedAmount(String amount) {
    return '$amount క్లెయిమ్ చేశారు';
  }

  @override
  String vaultPaidAmount(String amount) {
    return '$amount చెల్లించారు';
  }

  @override
  String get vaultSettledAmount => 'బీమా కంపెనీ చెల్లించిన మొత్తం';

  @override
  String get vaultClaimSaved => 'క్లెయిమ్ సేవ్ అయింది';

  @override
  String get edit => 'మార్చండి';

  @override
  String get close => 'మూసివేయండి';

  @override
  String get change => 'మార్చండి';

  @override
  String get catFood => 'ఆహారం';

  @override
  String get catTreats => 'ట్రీట్స్';

  @override
  String get catToys => 'బొమ్మలు';

  @override
  String get catGrooming => 'గ్రూమింగ్';

  @override
  String get catHealthHygiene => 'ఆరోగ్యం, శుభ్రత';

  @override
  String get catBeds => 'పడకలు';

  @override
  String get catCollars => 'కాలర్లు, లీషులు';

  @override
  String get catBowls => 'గిన్నెలు, ఫీడర్లు';

  @override
  String get catLitter => 'లిట్టర్, పిల్లి సంరక్షణ';

  @override
  String get catBird => 'పక్షుల ఆహారం, పంజరాలు';

  @override
  String get catRabbit => 'కుందేలు గడ్డి, సంరక్షణ';

  @override
  String get catClothing => 'దుస్తులు';

  @override
  String get catTravel => 'ప్రయాణం';

  @override
  String get shopStageYoung => 'కుక్కపిల్ల / పిల్లిపిల్ల';

  @override
  String get shopStageAdult => 'పెద్దది';

  @override
  String get shopStageSenior => 'వృద్ధ';

  @override
  String get shopStageAll => 'అన్ని వయసులు';

  @override
  String get shopSizeSmall => 'చిన్న జాతులు';

  @override
  String get shopSizeMedium => 'మధ్యస్థ జాతులు';

  @override
  String get shopSizeLarge => 'పెద్ద జాతులు';

  @override
  String get shopSizeGiant => 'చాలా పెద్ద జాతులు';

  @override
  String get shopSizeAll => 'అన్ని సైజులు';

  @override
  String get sortPopular => 'పాపులర్';

  @override
  String get sortPriceLow => 'ధర: తక్కువ నుండి ఎక్కువ';

  @override
  String get sortPriceHigh => 'ధర: ఎక్కువ నుండి తక్కువ';

  @override
  String get sortDiscount => 'ఎక్కువ తగ్గింపు';

  @override
  String get sortNewest => 'కొత్తవి';

  @override
  String get shopTitle => 'షాప్';

  @override
  String get shopSearchHint => 'ఆహారం, బొమ్మలు, పడకలు వెతకండి…';

  @override
  String get shopSearchTitle => 'వెతకండి';

  @override
  String get shopClearSearch => 'వెతుకుట తీసివేయండి';

  @override
  String shopForPet(String pet) {
    return '$pet కోసం';
  }

  @override
  String shopAvoiding(String items) {
    return 'ఇవి లేకుండా: $items';
  }

  @override
  String get shopNoPicks => 'ఇంకా సూచనలు లేవు. షాప్‌లో వెతకండి.';

  @override
  String get shopBuyAgain => 'మళ్ళీ కొనండి';

  @override
  String get shopReorder => 'మళ్ళీ ఆర్డర్';

  @override
  String shopReorderPrice(String price) {
    return 'మళ్ళీ ఆర్డర్ · $price';
  }

  @override
  String get shopCategories => 'విభాగాలు';

  @override
  String get shopDeals => 'ఆఫర్లు';

  @override
  String get shopPartnerStores => 'పార్ట్‌నర్ స్టోర్లు';

  @override
  String get shopPartnerStoresNote =>
      'వీటిని పార్ట్‌నర్ వెబ్‌సైట్‌లోనే కొంటారు. PawSetuకి చిన్న కమీషన్ రావచ్చు.';

  @override
  String shopListings(int count) {
    return '$count ఉత్పత్తులు';
  }

  @override
  String shopPlusDeliveryNote(String amount) {
    return 'Plus సభ్యులకు $amount పైన ఉచిత డెలివరీ.';
  }

  @override
  String get shopPartnerStore => 'పార్ట్‌నర్ స్టోర్';

  @override
  String shopSoldOn(String store) {
    return '$storeలో';
  }

  @override
  String shopOffPercent(int percent) {
    return '$percent% తగ్గింపు';
  }

  @override
  String shopPriceSemantics(String price, String mrp, int percent) {
    return '$price, ముందు $mrp, $percent% తగ్గింపు';
  }

  @override
  String shopRatingSemantics(String rating, int count) {
    return '$count మంది 5కి $rating రేటింగ్ ఇచ్చారు';
  }

  @override
  String get shopNoReviewsYet => 'ఇంకా రివ్యూలు లేవు';

  @override
  String get shopOutOfStock => 'స్టాక్ లేదు';

  @override
  String get shopInStock => 'స్టాక్ ఉంది';

  @override
  String shopOnlyLeft(int count) {
    return '$count మాత్రమే మిగిలాయి';
  }

  @override
  String shopResults(int count) {
    return '$count ఉత్పత్తులు';
  }

  @override
  String shopFiltersCount(int count) {
    return 'ఫిల్టర్లు ($count)';
  }

  @override
  String get shopNoResults => 'ఏమీ దొరకలేదు';

  @override
  String get shopNoResultsBody =>
      'వేరే పదం ప్రయత్నించండి లేదా ఫిల్టర్లు తీసివేయండి.';

  @override
  String get shopClearFilters => 'ఫిల్టర్లు తీసివేయండి';

  @override
  String get shopCategory => 'విభాగం';

  @override
  String get shopPrice => 'ధర';

  @override
  String get shopMinPrice => 'కనిష్ఠ ధర';

  @override
  String get shopMaxPrice => 'గరిష్ఠ ధర';

  @override
  String get shopBrand => 'బ్రాండ్';

  @override
  String shopRatingAtLeast(String rating) {
    return '$rating★ ఆపైన';
  }

  @override
  String get shopHidePartner => 'పార్ట్‌నర్ స్టోర్ ఉత్పత్తులు దాచండి';

  @override
  String get shopHidePartnerHint => 'PawSetuలో కొనగలిగేవే చూపండి';

  @override
  String get shopShowResults => 'ఫలితాలు చూపండి';

  @override
  String get shopProduct => 'ఉత్పత్తి';

  @override
  String get shopProductGone => 'ఈ ఉత్పత్తి ఇప్పుడు అందుబాటులో లేదు';

  @override
  String shopShareText(String name, String price) {
    return 'PawSetuలో $name $priceకి';
  }

  @override
  String get shopInclTaxes => 'అన్ని పన్నులతో కలిపి';

  @override
  String shopAffiliateNote(String store) {
    return 'ఇది మీరు $storeలో కొంటారు. PawSetuకి చిన్న కమీషన్ రావచ్చు; మీకు ధర అదే.';
  }

  @override
  String shopSoldBy(String seller, String city) {
    return 'అమ్మకందారు: $seller, $city';
  }

  @override
  String get shopSuitableFor => 'ఎవరికి సరిపోతుంది';

  @override
  String get shopCheckDelivery => 'డెలివరీ చూడండి';

  @override
  String get shopEnterPin => 'డెలివరీ తేదీ కోసం పిన్ కోడ్ ఇవ్వండి';

  @override
  String shopDeliveryBetween(String from, String to) {
    return 'డెలివరీ $from – $to';
  }

  @override
  String shopReturnable(int days) {
    return 'డెలివరీ అయిన $days రోజుల్లో సులభంగా తిరిగి ఇవ్వొచ్చు';
  }

  @override
  String get shopNotReturnable =>
      'ఆహారం, ట్రీట్స్ డెలివరీ తర్వాత తిరిగి తీసుకోరు';

  @override
  String get shopAbout => 'ఈ ఉత్పత్తి గురించి';

  @override
  String get shopPackSize => 'ప్యాక్ సైజు';

  @override
  String get shopIngredients => 'పదార్థాలు';

  @override
  String get shopReturnPolicy => 'రిటర్న్ పాలసీ';

  @override
  String get shopVerifiedBuyer => 'ధృవీకరించిన కొనుగోలుదారు';

  @override
  String shopSellerReplied(String reply) {
    return 'అమ్మకందారు: $reply';
  }

  @override
  String shopBuyOn(String store) {
    return '$storeలో కొనండి';
  }

  @override
  String get shopAddToCart => 'కార్ట్‌లో వేయండి';

  @override
  String get shopBuyNow => 'ఇప్పుడే కొనండి';

  @override
  String get shopAddedToCart => 'కార్ట్‌లో వేశాం';

  @override
  String get shopViewCart => 'కార్ట్ చూడండి';

  @override
  String shopLeavingTitle(String store) {
    return 'మీరు $storeలో కొంటారు';
  }

  @override
  String shopLeavingBody(String store) {
    return 'మీ బ్రౌజర్‌లో $store తెరుస్తాం. చెల్లింపు, డెలివరీ, రిటర్న్‌లు $store చూసుకుంటుంది. PawSetuకి చిన్న కమీషన్ రావచ్చు.';
  }

  @override
  String shopContinueTo(String store) {
    return '$storeకి వెళ్ళండి';
  }

  @override
  String get shopCart => 'కార్ట్';

  @override
  String shopCartWithCount(int count) {
    return 'కార్ట్, $count వస్తువులు';
  }

  @override
  String get shopQuantity => 'పరిమాణం';

  @override
  String shopQtySemantics(int count) {
    return 'పరిమాణం $count';
  }

  @override
  String shopQtyShort(int count) {
    return 'సంఖ్య $count';
  }

  @override
  String shopLessOf(String item) {
    return 'ఒకటి తక్కువ $item';
  }

  @override
  String shopMoreOf(String item) {
    return 'ఇంకొకటి $item';
  }

  @override
  String shopRemoveItem(String item) {
    return '$item తీసివేయండి';
  }

  @override
  String shopStars(int count) {
    return '$count స్టార్లు';
  }

  @override
  String get shopReviewText => 'మీకు ఎలా అనిపించింది? (ఐచ్ఛికం)';

  @override
  String get shopPostReview => 'రివ్యూ పంపండి';

  @override
  String get shopThanksReview => 'రివ్యూకి ధన్యవాదాలు!';

  @override
  String get shopRate => 'రేట్ చేయండి';

  @override
  String get shopForWhichPet => 'ఏ పెంపుడు జంతువు కోసం?';

  @override
  String get shopReorderTitle => 'మళ్ళీ ఆర్డర్';

  @override
  String shopReorderFor(String pet) {
    return '$pet కోసం మళ్ళీ ఆర్డర్';
  }

  @override
  String shopDeliveryOn(String date) {
    return '$dateన డెలివరీ';
  }

  @override
  String get shopItemsTotal => 'వస్తువుల మొత్తం';

  @override
  String get shopDeliveryFee => 'డెలివరీ';

  @override
  String get shopFree => 'ఉచితం';

  @override
  String get shopToPay => 'చెల్లించాల్సింది';

  @override
  String shopPlaceOrderAmount(String amount) {
    return 'ఆర్డర్ చేయండి · $amount';
  }

  @override
  String get shopOrderPlacedToast => 'ఆర్డర్ అయింది!';

  @override
  String get shopOrderFailed => 'ఆర్డర్ చేయలేకపోయాం. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get addrBook => 'చిరునామాలు';

  @override
  String get addrAdd => 'చిరునామా జోడించండి';

  @override
  String get addrEdit => 'చిరునామా మార్చండి';

  @override
  String get addrAddFirst => 'డెలివరీ చిరునామా జోడించండి';

  @override
  String get addrNone => 'ఇంకా చిరునామాలు లేవు';

  @override
  String get addrNoneBody => 'త్వరగా చెక్అవుట్ కోసం ఇంటి చిరునామా జోడించండి.';

  @override
  String get addrDeleteQ => 'ఈ చిరునామా తొలగించాలా?';

  @override
  String get addrChoose => 'ఇక్కడికి డెలివరీ';

  @override
  String get addrHome => 'ఇల్లు';

  @override
  String get addrWork => 'ఆఫీసు';

  @override
  String get addrOther => 'ఇతరం';

  @override
  String get addrName => 'పేరు';

  @override
  String get addrPhoneInvalid => '10 అంకెల మొబైల్ నంబర్ ఇవ్వండి';

  @override
  String get addrLine1 => 'ఇల్లు / ఫ్లాట్, వీధి';

  @override
  String get addrLine2 => 'దగ్గర గుర్తు (ఐచ్ఛికం)';

  @override
  String get addrArea => 'ప్రాంతం';

  @override
  String get addrCity => 'నగరం';

  @override
  String get addrPin => 'పిన్ కోడ్';

  @override
  String get addrPinInvalid => '6 అంకెల పిన్ కోడ్ ఇవ్వండి';

  @override
  String get cartEmpty => 'మీ కార్ట్ ఖాళీగా ఉంది';

  @override
  String get cartEmptyBody =>
      'మీ పెంపుడు జంతువుకి ఆహారం, బొమ్మలు ఒక్క ట్యాప్ దూరంలో.';

  @override
  String get cartStartShopping => 'షాపింగ్ మొదలుపెట్టండి';

  @override
  String cartSoldBy(String seller) {
    return 'అమ్మకందారు: $seller';
  }

  @override
  String get cartSkipped => 'వీటిని ఇప్పుడు ఇక్కడ ఆర్డర్ చేయలేరు';

  @override
  String get cartPartnerOnly => 'దీన్ని పార్ట్‌నర్ స్టోర్‌లో కొనండి';

  @override
  String get cartPetHint => 'ఈ పెంపుడు జంతువు ఖర్చు, ఆహారం ట్రాక్ చేయడానికి.';

  @override
  String get cartDeliverTo => 'డెలివరీ చిరునామా';

  @override
  String get cartSlot => 'డెలివరీ సమయం';

  @override
  String get cartCoupon => 'కూపన్';

  @override
  String get couponCode => 'కూపన్ కోడ్';

  @override
  String get couponApply => 'వర్తింపజేయండి';

  @override
  String get couponApplied => 'కూపన్ వర్తించింది';

  @override
  String couponSaved(String code, String amount) {
    return '$code వర్తించింది: మీకు $amount ఆదా';
  }

  @override
  String get couponNotFound => 'ఈ కూపన్ కోడ్ చెల్లదు';

  @override
  String get couponExpired => 'ఈ కూపన్ గడువు ముగిసింది';

  @override
  String couponMinOrder(int amount) {
    return 'ఈ కూపన్ కోసం ₹$amount లేదా అంతకంటే ఎక్కువ కొనండి';
  }

  @override
  String get couponUsedUp => 'ఈ కూపన్ పూర్తిగా వాడేశారు';

  @override
  String get cartPayment => 'చెల్లింపు';

  @override
  String get payOnlineDemo => 'ఆన్‌లైన్ చెల్లింపు (డెమో)';

  @override
  String get payOnDelivery => 'డెలివరీ అప్పుడు చెల్లింపు';

  @override
  String get cartBill => 'బిల్లు వివరాలు';

  @override
  String cartMrpTotal(int count) {
    return 'ధర ($count వస్తువులు)';
  }

  @override
  String get cartMrpDiscount => 'MRPపై తగ్గింపు';

  @override
  String get cartCouponDiscount => 'కూపన్';

  @override
  String cartCouponDiscountCode(String code) {
    return 'కూపన్ $code';
  }

  @override
  String cartAddForFree(String amount) {
    return 'ఉచిత డెలివరీ కోసం ఇంకా $amount కొనండి';
  }

  @override
  String get cartPlusFreeDelivery => 'Plusతో ఉచిత డెలివరీ';

  @override
  String cartSplitNote(int count) {
    return 'వస్తువులు $count అమ్మకందారుల నుండి వస్తాయి, కాబట్టి $count డెలివరీలు. చెల్లింపు ఒక్కసారే.';
  }

  @override
  String cartYouSave(String amount) {
    return 'మీకు $amount ఆదా';
  }

  @override
  String cartPay(String amount) {
    return '$amount చెల్లించండి';
  }

  @override
  String get cartPlaceOrder => 'ఆర్డర్ చేయండి';

  @override
  String cartPaymentFor(int count) {
    return 'PawSetu ఆర్డర్, $count వస్తువులు';
  }

  @override
  String get payFailedTryAgain =>
      'చెల్లింపు విఫలమైంది. మీ కార్ట్ సేవ్ అయింది; మళ్ళీ ప్రయత్నించండి.';

  @override
  String get payPaidOnline => 'ఆన్‌లైన్‌లో చెల్లించారు';

  @override
  String get payPending => 'చెల్లింపు పెండింగ్';

  @override
  String get payRefunded => 'డబ్బు తిరిగి ఇచ్చాం';

  @override
  String get payPendingNote =>
      'మీ చెల్లింపు నిర్ధారణ అవుతోంది. విఫలమైతే మళ్ళీ చెల్లించండి లేదా డెలివరీ అప్పుడు చెల్లించండి.';

  @override
  String get payNow => 'ఇప్పుడే చెల్లించండి';

  @override
  String get ordMyOrders => 'నా ఆర్డర్లు';

  @override
  String get ordTabOrders => 'ఆర్డర్లు';

  @override
  String get ordNone => 'ఇంకా ఆర్డర్లు లేవు';

  @override
  String get ordPlaced => 'ఆర్డర్ అయింది';

  @override
  String get ordPacked => 'ప్యాక్ అయింది';

  @override
  String get ordShipped => 'పంపించాం';

  @override
  String get ordOutForDelivery => 'డెలివరీకి బయలుదేరింది';

  @override
  String get ordDelivered => 'డెలివరీ అయింది';

  @override
  String get ordCancelled => 'రద్దు';

  @override
  String get ordReturnRequested => 'రిటర్న్ కోరారు';

  @override
  String get ordReturned => 'తిరిగి ఇచ్చారు';

  @override
  String get ordReturnRejected => 'రిటర్న్ తిరస్కరించారు';

  @override
  String ordItemsMore(String name, int count) {
    return '$name +ఇంకా $count';
  }

  @override
  String ordArrivingBy(String date) {
    return '$date లోపు వస్తుంది';
  }

  @override
  String ordExpected(String date) {
    return 'అంచనా $date';
  }

  @override
  String get ordPlacedTitle => 'ఆర్డర్ అయింది';

  @override
  String get ordPlacedHeading => 'ధన్యవాదాలు! మీ ఆర్డర్ అయింది.';

  @override
  String get ordPlacedBody => 'దారిలో ఉన్నప్పుడు చెబుతాం.';

  @override
  String ordPlacedSplit(int count) {
    return 'ఇది $count డెలివరీల్లో వస్తుంది, ఒక్కో అమ్మకందారు నుండి ఒకటి.';
  }

  @override
  String get ordTrack => 'ఆర్డర్ ట్రాక్ చేయండి';

  @override
  String get ordContinueShopping => 'షాపింగ్ కొనసాగించండి';

  @override
  String get ordDetail => 'ఆర్డర్ వివరాలు';

  @override
  String get ordNotFound => 'ఈ ఆర్డర్ దొరకలేదు';

  @override
  String ordNumber(String number) {
    return 'ఆర్డర్ $number';
  }

  @override
  String ordPlacedOn(String date) {
    return '$dateన ఆర్డర్ చేశారు';
  }

  @override
  String get ordTracking => 'ట్రాకింగ్';

  @override
  String ordItems(int count) {
    return '$count వస్తువులు';
  }

  @override
  String ordSlot(String date, String window) {
    return 'సమయం: $date, $window';
  }

  @override
  String ordForPet(String pet) {
    return '$pet కోసం';
  }

  @override
  String get ordTotal => 'మొత్తం';

  @override
  String get ordPayment => 'చెల్లింపు';

  @override
  String get ordInvoice => 'ఇన్వాయిస్ (PDF)';

  @override
  String get ordCancel => 'ఆర్డర్ రద్దు చేయండి';

  @override
  String get ordReturn => 'తిరిగి ఇవ్వండి';

  @override
  String get ordHelp => 'సహాయం పొందండి';

  @override
  String ordReturnWindowOver(int days) {
    return '$days రోజుల రిటర్న్ గడువు ముగిసింది.';
  }

  @override
  String get ordCancelTitle => 'ఎందుకు రద్దు చేయాలనుకుంటున్నారు?';

  @override
  String get ordReturnTitle => 'ఎందుకు తిరిగి ఇస్తున్నారు?';

  @override
  String get ordReasonChangedMind => 'నా మనసు మారింది';

  @override
  String get ordReasonWrongItem => 'తప్పు వస్తువు లేదా సైజు';

  @override
  String get ordReasonTooLate => 'డెలివరీ చాలా ఆలస్యం';

  @override
  String get ordReasonDamaged => 'పాడైపోయి వచ్చింది';

  @override
  String get ordReasonNotSuitable => 'నా పెంపుడు జంతువుకి సరిపోలేదు';

  @override
  String get ordReasonOther => 'ఇంకేదో';

  @override
  String get ordCancelledToast => 'ఆర్డర్ రద్దయింది';

  @override
  String get ordCancelledRefund =>
      'ఆర్డర్ రద్దయింది. మీ డబ్బు తిరిగి వస్తోంది (డెమో).';

  @override
  String get ordReturnRequestedToast =>
      'రిటర్న్ కోరాం. అమ్మకందారు త్వరలో స్పందిస్తారు.';

  @override
  String ordReason(String reason) {
    return 'కారణం: $reason';
  }

  @override
  String get ordStepDone => 'పూర్తయింది';

  @override
  String get invTitle => 'టాక్స్ ఇన్వాయిస్';

  @override
  String get invFooter =>
      'PawSetu మార్కెట్‌ప్లేస్ · ఈ ఇన్వాయిస్ అమ్మకందారు PawSetu ద్వారా తయారు చేశారు.';

  @override
  String get invSoldBy => 'అమ్మకందారు';

  @override
  String get invBillTo => 'కొనుగోలుదారు';

  @override
  String invGstin(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get invMarketplace => 'PawSetu మార్కెట్‌ప్లేస్ ద్వారా అమ్మారు';

  @override
  String get invOrder => 'ఆర్డర్';

  @override
  String invInvoiceNo(String number) {
    return 'ఇన్వాయిస్ $number';
  }

  @override
  String invPayment(String method) {
    return 'చెల్లింపు: $method';
  }

  @override
  String get invItems => 'వస్తువులు';

  @override
  String get invItem => 'వస్తువు';

  @override
  String get invQty => 'సంఖ్య';

  @override
  String get invPrice => 'ధర';

  @override
  String get invAmount => 'మొత్తం';

  @override
  String get invTax => 'GST';

  @override
  String get invTaxPlaceholder => 'కలిపి ఉంది';

  @override
  String get invDemoNote =>
      'డెమో ఇన్వాయిస్: డబ్బు తీసుకోలేదు, GST వివరాలు నమూనా మాత్రమే.';

  @override
  String get orderEmailSubject => 'మీ PawSetu ఆర్డర్ అయింది';

  @override
  String orderEmailBody(String name, String amount, String date) {
    return 'నమస్తే $name, $amount ఆర్డర్‌కి ధన్యవాదాలు. ఇది $date లోపు చేరాలి.';
  }

  @override
  String get subsTitle => 'ఆటో రీఆర్డర్';

  @override
  String get subsHint =>
      'ప్రతి 2, 4 లేదా 6 వారాలకు డెలివరీ. ఎప్పుడైనా ఆపండి లేదా రద్దు చేయండి.';

  @override
  String get subsEvery => 'ఎంత కాలానికి';

  @override
  String subsWeeks(int count) {
    return 'ప్రతి $count వారాలకు';
  }

  @override
  String subsFirstOn(String date) {
    return 'మొదటి డెలివరీ సుమారు $dateన, డెలివరీ అప్పుడు చెల్లింపు.';
  }

  @override
  String get subsStart => 'ఆటో రీఆర్డర్ మొదలుపెట్టండి';

  @override
  String get subsCreated => 'ఆటో రీఆర్డర్ ఆన్ అయింది';

  @override
  String get subsTab => 'ఆటో రీఆర్డర్';

  @override
  String get subsNone => 'ఆటో రీఆర్డర్లు లేవు';

  @override
  String get subsNoneBody =>
      'ఆహారం ఎప్పుడూ అయిపోకుండా ఏదైనా ఆహార పేజీ నుండి మొదలుపెట్టండి.';

  @override
  String subsNext(String date) {
    return 'తదుపరి డెలివరీ $date';
  }

  @override
  String get subsPaused => 'ఆపారు';

  @override
  String get subsPause => 'ఆపండి';

  @override
  String get subsResume => 'మళ్ళీ మొదలుపెట్టండి';

  @override
  String get subsCancel => 'రద్దు చేయండి';

  @override
  String get subsCancelQ => 'ఈ ఆటో రీఆర్డర్ ఆపాలా?';

  @override
  String subsOrderedToast(int count) {
    return '$count ఆటో రీఆర్డర్లు చేశాం';
  }

  @override
  String ntfNewOrder(String item, int count) {
    return 'కొత్త ఆర్డర్: $item';
  }

  @override
  String ntfOrderCancelled(String number) {
    return 'కస్టమర్ ఆర్డర్ $number రద్దు చేశారు';
  }

  @override
  String ntfOrderCancelledBySeller(String item) {
    return 'క్షమించండి, అమ్మకందారు $item ఆర్డర్ రద్దు చేశారు. చెల్లింపు తిరిగి వస్తుంది.';
  }

  @override
  String ntfOrderPacked(String item) {
    return '$item ప్యాక్ అయింది';
  }

  @override
  String ntfOrderShipped(String item) {
    return '$item దారిలో ఉంది';
  }

  @override
  String ntfOrderOutForDelivery(String item) {
    return '$item ఈరోజు డెలివరీకి బయలుదేరింది';
  }

  @override
  String ntfOrderDelivered(String item) {
    return '$item డెలివరీ అయింది';
  }

  @override
  String ntfOrderUpdated(String item) {
    return '$item ఆర్డర్ అప్‌డేట్ అయింది';
  }

  @override
  String ntfReturnAccepted(String item) {
    return '$item రిటర్న్ అంగీకరించారు. డబ్బు తిరిగి వస్తోంది.';
  }

  @override
  String ntfReturnRejected(String item) {
    return '$item రిటర్న్ తిరస్కరించారు. సహాయం కోసం ట్యాప్ చేయండి.';
  }

  @override
  String ntfReturnRequested(String number) {
    return 'ఆర్డర్ $number రిటర్న్ కోరారు';
  }

  @override
  String ntfSubscriptionOrdered(String item) {
    return 'ఆటో రీఆర్డర్ చేశాం: $item';
  }

  @override
  String foodRunsOutIn(String pet, int days) {
    return '$pet ఆహారం సుమారు $days రోజుల్లో అయిపోవచ్చు. మళ్ళీ ఆర్డర్ చేయాలా?';
  }

  @override
  String foodRanOut(String pet) {
    return '$pet ఆహారం అయిపోయి ఉండవచ్చు. మళ్ళీ ఆర్డర్ చేయాలా?';
  }

  @override
  String foodPortionLine(int grams, String bag) {
    return 'రోజుకు $grams గ్రా · $bag ప్యాక్';
  }

  @override
  String get foodEditPortion => 'పరిమాణం మార్చండి';

  @override
  String foodOnTheWay(String pet) {
    return '$pet కొత్త ఆహారం దారిలో ఉంది';
  }

  @override
  String foodPlanTitle(String pet) {
    return '$pet ఆహారం';
  }

  @override
  String get foodDailyPortion => 'రోజువారీ పరిమాణం';

  @override
  String foodSuggested(int grams) {
    return 'మొదట రోజుకు $grams గ్రా. ప్యాక్ లేదా మీ వెట్ సలహా పాటించండి.';
  }

  @override
  String get foodBagSize => 'ప్యాక్ సైజు';

  @override
  String get foodOpenedOn => 'ప్యాక్ తెరిచిన తేదీ';

  @override
  String get expAdd => 'ఖర్చు జోడించండి';

  @override
  String get expEdit => 'ఖర్చు మార్చండి';

  @override
  String get expThisMonth => 'ఈ నెల';

  @override
  String get expLastMonth => 'గత నెల';

  @override
  String expPeriodTotal(int months) {
    return 'గత $months నెలలు';
  }

  @override
  String get expByMonth => 'నెలవారీ ఖర్చు';

  @override
  String expMonths(int count) {
    return '$count నెలలు';
  }

  @override
  String get expByCategory => 'విభాగాల వారీగా';

  @override
  String expChartSemantics(String values) {
    return 'నెలవారీ ఖర్చు: $values';
  }

  @override
  String get expNone => 'ఇంకా ఖర్చులు లేవు';

  @override
  String get expNoneBody =>
      'బుకింగ్‌లు, ఆర్డర్లు ఇక్కడ ఆటోమేటిక్‌గా చేరతాయి. ఇతర ఖర్చులూ జోడించవచ్చు.';

  @override
  String get expVet => 'వెట్';

  @override
  String get expGrooming => 'గ్రూమింగ్';

  @override
  String get expTraining => 'శిక్షణ';

  @override
  String get expBoarding => 'బోర్డింగ్';

  @override
  String get expWalking => 'వాకింగ్';

  @override
  String get expFood => 'ఆహారం';

  @override
  String get expSupplies => 'సామగ్రి';

  @override
  String get expInsurance => 'బీమా';

  @override
  String get expOther => 'ఇతరం';

  @override
  String get expFromBooking => 'బుకింగ్ నుండి';

  @override
  String get expFromOrder => 'ఆర్డర్ నుండి';

  @override
  String get expFromTeleVet => 'టెలీ-వెట్ నుండి';

  @override
  String get expAmount => 'మొత్తం';

  @override
  String get expAmountInvalid => 'మొత్తం ఇవ్వండి';

  @override
  String get expCategory => 'విభాగం';

  @override
  String get expForPet => 'ఎవరి కోసం';

  @override
  String get expAllPets => 'అన్ని పెంపుడు జంతువులు';

  @override
  String get expNote => 'నోట్';

  @override
  String get expNoteHint => 'ఉదా: రేబీస్ బూస్టర్, కొత్త కాలర్';

  @override
  String get expSaved => 'ఖర్చు సేవ్ అయింది';

  @override
  String get expDeleteQ => 'ఈ ఖర్చు తొలగించాలా?';

  @override
  String get selToPack => 'ప్యాక్ చేయాల్సిన ఆర్డర్లు';

  @override
  String get selOnTheWay => 'దారిలో';

  @override
  String get selLowStock => 'తక్కువ స్టాక్';

  @override
  String selReturnsWaiting(int count) {
    return '$count రిటర్న్‌లు మీ కోసం ఎదురుచూస్తున్నాయి';
  }

  @override
  String get selNewOrders => 'కొత్త ఆర్డర్లు';

  @override
  String get selNoNewOrders => 'ఇప్పుడు కొత్త ఆర్డర్లు లేవు';

  @override
  String selStockLeft(int count) {
    return 'స్టాక్‌లో $count';
  }

  @override
  String get selAddProduct => 'ఉత్పత్తి జోడించండి';

  @override
  String get selEditProduct => 'ఉత్పత్తి మార్చండి';

  @override
  String get selCsvUpload => 'CSV బల్క్ అప్‌లోడ్';

  @override
  String get selSearchProducts => 'మీ ఉత్పత్తులు వెతకండి';

  @override
  String selProductCount(int count) {
    return '$count ఉత్పత్తులు';
  }

  @override
  String get selHidden => 'షాప్‌లో కనిపించదు';

  @override
  String get selProductName => 'ఉత్పత్తి పేరు';

  @override
  String get selPrice => 'అమ్మకం ధర';

  @override
  String get selMrp => 'MRP';

  @override
  String get selPriceInvalid => 'ధర ఇవ్వండి';

  @override
  String get selMrpInvalid => 'MRP ధర కంటే తక్కువ ఉండకూడదు';

  @override
  String get selStock => 'స్టాక్';

  @override
  String get selPackKg => 'ప్యాక్ సైజు కేజీల్లో (ఆహారం)';

  @override
  String get selDescription => 'వివరణ';

  @override
  String get selVisible => 'షాప్‌లో చూపండి';

  @override
  String get selVisibleHint => 'తొలగించకుండా దాచడానికి ఆఫ్ చేయండి';

  @override
  String get selNoRxNote =>
      'ప్రిస్క్రిప్షన్‌తో మాత్రమే అమ్మే మందులు PawSetuలో అమ్మకూడదు.';

  @override
  String get selSaved => 'ఉత్పత్తి సేవ్ అయింది';

  @override
  String selCsvHelp(String columns) {
    return 'కాలమ్‌లు: $columns. జాతులు చాలా ఉండొచ్చు, ఉదా dog|cat.';
  }

  @override
  String get selCsvChoose => 'CSV ఫైల్ ఎంచుకోండి';

  @override
  String get selCsvSample => 'నమూనా ప్రయత్నించండి';

  @override
  String get selCsvCopyTemplate => 'టెంప్లేట్ కాపీ చేయండి';

  @override
  String get selCsvCopied => 'టెంప్లేట్ కాపీ అయింది';

  @override
  String get selCsvPaste => 'లేదా CSV ఇక్కడ పేస్ట్ చేయండి';

  @override
  String selCsvPreview(int ok, int bad) {
    return 'ప్రివ్యూ: $ok సిద్ధం, $bad సరిచేయాలి';
  }

  @override
  String selCsvLine(int line) {
    return 'లైన్ $line';
  }

  @override
  String selCsvProblems(String fields) {
    return 'చూడండి: $fields';
  }

  @override
  String selCsvImport(int count) {
    return '$count ఉత్పత్తులు జోడించండి';
  }

  @override
  String selCsvImported(int count) {
    return '$count ఉత్పత్తులు జోడించాం';
  }

  @override
  String get selTabNew => 'కొత్తవి';

  @override
  String get selTabPacked => 'ప్యాక్ అయినవి';

  @override
  String get selTabShipping => 'పంపినవి';

  @override
  String get selTabDelivered => 'డెలివరీ అయినవి';

  @override
  String get selTabCancelled => 'రద్దు / రిటర్న్';

  @override
  String get selNoOrdersHere => 'ఇక్కడ ఆర్డర్లు లేవు';

  @override
  String get selReturnsOpen => 'మీ కోసం ఎదురుచూస్తున్నవి';

  @override
  String get selReturnsDone => 'పూర్తయినవి';

  @override
  String get selNoReturns => 'రిటర్న్‌లు లేవు';

  @override
  String get selAcceptReturn => 'రిటర్న్ అంగీకరించండి';

  @override
  String get selRejectReturn => 'రిటర్న్ తిరస్కరించండి';

  @override
  String get selPayoutDemo => 'డెమో చెల్లింపులు: నిజమైన డబ్బు జరగదు.';

  @override
  String get selPayoutPending => 'పెండింగ్';

  @override
  String get selPayoutReady => 'చెల్లించడానికి సిద్ధం';

  @override
  String get selPayoutPaid => 'చెల్లించారు';

  @override
  String get selPayoutOnHold => 'రిటర్న్ గడువులో';

  @override
  String get selCommissionPaid => 'PawSetu కమీషన్';

  @override
  String selRunPayout(String amount) {
    return 'ఇప్పుడు $amount చెల్లించండి (డెమో)';
  }

  @override
  String selPayoutDone(int count) {
    return '$count ఆర్డర్లకు చెల్లించాం';
  }

  @override
  String selPayoutRule(int days) {
    return '$days రోజుల రిటర్న్ గడువు ముగిశాక ప్రతి వారం చెల్లిస్తాం.';
  }

  @override
  String get selPayoutOrders => 'ఆర్డర్లు';

  @override
  String selPayoutLine(String gross, String commission) {
    return 'అమ్మకం $gross · కమీషన్ $commission';
  }

  @override
  String selReviewSummary(String rating, int count) {
    return '★ $rating, $count రివ్యూలు';
  }

  @override
  String get selReplyText => 'మీ సమాధానం';

  @override
  String get selSendReply => 'సమాధానం పంపండి';

  @override
  String get selApproved => 'ఆమోదించారు';

  @override
  String get selKyc => 'KYC పత్రాలు';

  @override
  String get selVerified => 'ధృవీకరించారు';

  @override
  String get selCancelQ => 'ఈ ఆర్డర్ రద్దు చేయాలా?';

  @override
  String get selCancelBody => 'కస్టమర్‌కి చెబుతాం, చెల్లింపు తిరిగి ఇస్తాం.';

  @override
  String get selCancelOrder => 'ఆర్డర్ రద్దు చేయండి';

  @override
  String get selOutOfStockReason => 'స్టాక్ అయిపోయింది';

  @override
  String get selMarkPacked => 'ప్యాక్ అయింది';

  @override
  String get selMarkShipped => 'పంపించాం';

  @override
  String get selMarkOut => 'డెలివరీకి బయలుదేరింది';

  @override
  String get selMarkDelivered => 'డెలివరీ అయింది';

  @override
  String get selCommission => 'PawSetu కమీషన్';

  @override
  String get selYourPayout => 'మీకు వచ్చేది';

  @override
  String get selShipTo => 'ఇక్కడికి పంపండి';

  @override
  String get selPhoneHidden =>
      'కస్టమర్ ఫోన్ దాచాం; కొరియర్ PawSetu ద్వారా కాల్ చేస్తారు.';

  @override
  String get faChokingTitle => 'గొంతులో ఏదైనా ఇరుక్కోవడం';

  @override
  String get faChokingSigns =>
      'నోటిని పంజాతో గీకడం, ఓకరించడం, దగ్గు, నీలం రంగు చిగుళ్లు లేదా ఊపిరి ఆడకపోవడం.';

  @override
  String get faChokingSteps =>
      'ప్రశాంతంగా ఉండి పెంపుడు జంతువును కదలకుండా ఉంచండి. అది దగ్గగలిగితే, దానినే బయటకు తీయనివ్వండి.\nనోటిని మెల్లగా తెరిచి టార్చ్‌తో లోపల చూడండి.\nవస్తువు కనిపించి, సులభంగా అందితే, వేళ్లతో బయటకు తీయండి. దాన్ని ఇంకా లోపలికి నెట్టవద్దు.\nచిన్న కుక్క లేదా పిల్లి: తుంటి దగ్గర పట్టుకుని తలకిందులుగా ఎత్తి, భుజాల మధ్య 5 సార్లు గట్టిగా తట్టండి.\nపెద్ద కుక్క: వెనుక నిలబడి, పక్కటెముకల కింద పిడికిలి పెట్టి, 5 సార్లు వేగంగా లోపలికి, పైకి నొక్కండి.\nనోటిని మళ్లీ చూడండి. వస్తువు బయటకు వచ్చినా వెంటనే వెట్ దగ్గరికి వెళ్లండి.';

  @override
  String get faChokingAvoid =>
      'చూడకుండా గొంతులోకి వేళ్లు పెట్టవద్దు.\nఆహారం లేదా నీళ్లు ఇవ్వవద్దు.\nకనిపించే దారం లేదా తాడును లాగవద్దు; అది లోపల దేనికైనా చిక్కుకుని ఉండవచ్చు.';

  @override
  String get faChokingVet =>
      'గొంతులో ఇరుక్కున్న తర్వాత, బాగానే ఉన్నట్టు కనిపించినా, ఎప్పుడూ వెట్‌కి చూపించండి. పడిపోతే లేదా ఊపిరి ఆడకపోతే SOS వాడండి.';

  @override
  String get faPoisoningTitle => 'విషం తినడం';

  @override
  String get faPoisoningSigns =>
      'వాంతులు, చొంగ కారడం, వణుకు, తడబడుతూ నడవడం, ఫిట్స్, ఉన్నట్టుండి నీరసం, లేదా దగ్గర్లో నమిలిన ప్యాకెట్.';

  @override
  String get faPoisoningSteps =>
      'విషం నుంచి దూరంగా తీసుకెళ్లి, నోట్లో మిగిలినది తీసేయండి.\nఏమి తిన్నది, ఎంత, ఎప్పుడు అని తెలుసుకోండి. ప్యాకెట్ ఉంచండి లేదా మొక్క ఫోటో తీయండి.\nఇప్పుడే మీ వెట్‌కి ఫోన్ చేయండి, లేదా SOS తో దగ్గర్లోని క్లినిక్ చూడండి.\nవిషం బొచ్చు లేదా చర్మంపై పడితే, గోరువెచ్చని నీళ్లతో బాగా కడగండి.\nక్లినిక్‌కి వెళ్లేటప్పుడు వెచ్చగా, ప్రశాంతంగా ఉంచండి.';

  @override
  String get faPoisoningAvoid =>
      'వెట్ చెప్పకుండా వాంతి చేయించవద్దు.\nపాలు, ఉప్పు, నూనె లేదా ఇంటి చిట్కాలు ఇవ్వవద్దు.\nలక్షణాల కోసం ఎదురు చూడవద్దు; కొన్ని విషాలు గంటల తర్వాత పని చేస్తాయి.';

  @override
  String get faPoisoningVet =>
      'ఇప్పుడే వెళ్లండి. విషం విషయంలో త్వరగా చికిత్స ప్రాణాలు కాపాడుతుంది.';

  @override
  String get faHeatstrokeTitle => 'వడదెబ్బ';

  @override
  String get faHeatstrokeSigns =>
      'వేడి రోజున బాగా ఆయాసపడటం, చిక్కటి చొంగ, బాగా ఎర్రటి లేదా పాలిపోయిన చిగుళ్లు, నీరసం, వాంతులు లేదా పడిపోవడం.';

  @override
  String get faHeatstrokeSteps =>
      'వెంటనే నీడకు లేదా చల్లని గదికి తీసుకెళ్లండి.\nశరీరంపై చల్లని (ఐస్ అంత కాదు) నీళ్లు పోయండి, ముఖ్యంగా పొట్ట, మెడ, పాదాలపై.\nఫ్యాన్ వేయండి లేదా తడి టవల్స్ పెట్టండి, వేడి నిలవకుండా వాటిని తరచూ మార్చండి.\nచల్లని నీళ్లు కొద్దికొద్దిగా ఇవ్వండి; బలవంతంగా తాగించవద్దు.\nబాగానే ఉన్నట్టు అనిపించినా వెట్ దగ్గరికి వెళ్లండి.';

  @override
  String get faHeatstrokeAvoid =>
      'ఐస్ లేదా ఐస్ లాంటి చల్లని నీళ్లు వాడవద్దు.\nతడి టవల్ కప్పి అలాగే వదిలేయవద్దు.\nమధ్యాహ్నం ఎండలో నడిపించవద్దు, ఆపి ఉన్న కారులో ఎప్పుడూ వదలవద్దు.';

  @override
  String get faHeatstrokeVet =>
      'వడదెబ్బ వల్ల గంటల తర్వాత అవయవాలు దెబ్బతినవచ్చు. ఈ రోజే వెట్‌కి చూపించండి. చదునైన ముఖం ఉన్న జాతులకు ప్రమాదం ఎక్కువ.';

  @override
  String get faBleedingTitle => 'రక్తం కారడం';

  @override
  String get faBleedingSigns => 'గాయం, పాదం, చెవి లేదా ముక్కు నుంచి రక్తం.';

  @override
  String get faBleedingSteps =>
      'గాయంపై శుభ్రమైన గుడ్డ లేదా గాజ్ పెట్టి గట్టిగా నొక్కండి.\nకనీసం 5 నిమిషాలు తీయకుండా నొక్కి ఉంచండి.\nరక్తం గుడ్డలోంచి వస్తే, పైన ఇంకో గుడ్డ పెట్టి నొక్కుతూనే ఉండండి.\nకట్టు గట్టిగా కట్టండి, కానీ మరీ బిగుతుగా కాదు.\nప్రశాంతంగా ఉంచి వెట్ దగ్గరికి వెళ్లండి.';

  @override
  String get faBleedingAvoid =>
      'వెట్ చెప్పకుండా బిగుతైన కట్టు (టోర్నికెట్) కట్టవద్దు.\nగాయంలో ఇరుక్కున్నదాన్ని బయటకు లాగవద్దు.\nలోతైన గాయంపై పసుపు, పౌడర్ లేదా క్రీమ్ రాయవద్దు.';

  @override
  String get faBleedingVet =>
      'రక్తం ఎక్కువగా కారితే, చిమ్ముతుంటే, లేదా 10 నిమిషాలు నొక్కినా తగ్గకపోతే SOS వాడండి.';

  @override
  String get faFractureTitle => 'ఎముక విరగడం';

  @override
  String get faFractureSigns =>
      'కాలిపై బరువు పెట్టకపోవడం, వాపు, వింతగా వంగి ఉండటం, ముట్టుకుంటే అరవడం.';

  @override
  String get faFractureSteps =>
      'వీలైనంత కదలకుండా ఉంచండి. భయపడిన జంతువు కరవవచ్చు, కాబట్టి మెల్లగా పట్టుకోండి.\nచిన్న జంతువులను టవల్ పరిచిన డబ్బాలో లేదా బుట్టలో తీసుకెళ్లండి.\nపెద్ద కుక్కకు చెక్క పలక లేదా దుప్పటిని స్ట్రెచర్‌లా వాడండి.\nతెరిచిన గాయాన్ని శుభ్రమైన గుడ్డతో కప్పండి.\nవెంటనే వెట్ దగ్గరికి వెళ్లండి.';

  @override
  String get faFractureAvoid =>
      'ఎముకను సరిచేయడానికి ప్రయత్నించవద్దు.\nమనుషుల నొప్పి మందులు ఇవ్వవద్దు; చాలా మందులు జంతువులకు విషం.\nఆ కాలిపై నడవనివ్వవద్దు.';

  @override
  String get faFractureVet =>
      'ఎముక విరిగిందని అనుమానం వస్తే వెట్‌కి చూపించండి; సాధారణంగా ఎక్స్-రే అవసరం.';

  @override
  String get faSeizureTitle => 'ఫిట్స్ (మూర్ఛ)';

  @override
  String get faSeizureSigns =>
      'పడిపోవడం, కాళ్లు బిగుసుకుపోవడం లేదా కొట్టుకోవడం, కాళ్లు ఆడించడం, చొంగ కారడం, స్పందించకపోవడం.';

  @override
  String get faSeizureSteps =>
      'ప్రశాంతంగా ఉండి ఫిట్స్ మొదలైన సమయం గుర్తుంచుకోండి.\nఫర్నిచర్, పదునైన వస్తువులు దూరం చేయండి. లైట్లు తగ్గించి నిశ్శబ్దంగా ఉంచండి.\nమీ చేతులను నోటికి దూరంగా ఉంచండి.\nఫిట్స్ తర్వాత వెచ్చగా ఉంచి విశ్రాంతి తీసుకోనివ్వండి; కాసేపు అయోమయంగా ఉండవచ్చు.\nవెట్‌కి ఫోన్ చేసి ఫిట్స్ ఎంతసేపు ఉన్నాయో చెప్పండి.';

  @override
  String get faSeizureAvoid =>
      'బలవంతంగా పట్టి ఉంచవద్దు.\nనోట్లో ఏమీ పెట్టవద్దు; జంతువులు నాలుకను మింగవు.\nపూర్తిగా స్పృహ వచ్చే వరకు ఆహారం లేదా నీళ్లు ఇవ్వవద్దు.';

  @override
  String get faSeizureVet =>
      'ఫిట్స్ 5 నిమిషాల కంటే ఎక్కువ ఉంటే లేదా ఒకదాని తర్వాత ఒకటి వస్తే SOS వాడండి. మొదటిసారి ఫిట్స్ వస్తే ఎప్పుడూ వెట్‌కి చూపించండి.';

  @override
  String get faBurnTitle => 'కాలిన గాయాలు';

  @override
  String get faBurnSigns =>
      'ఎర్రగా లేదా పచ్చిగా ఉన్న చర్మం, బొబ్బలు, కాలిన బొచ్చు, లేదా వేడి ద్రవం, మంట లేదా రసాయనాలు తగలడం.';

  @override
  String get faBurnSteps =>
      'కాలిన చోటును 10 నిమిషాలు పారే చల్లని నీటితో చల్లబరచండి.\nరసాయనంతో కాలితే 15 నిమిషాలు బాగా నీళ్లతో కడగండి; గ్లవ్స్ వేసుకోండి.\nశుభ్రమైన, తడి, పీచు లేని గుడ్డతో వదులుగా కప్పండి.\nమిగతా శరీరాన్ని చుట్టి వెచ్చగా ఉంచి వెట్ దగ్గరికి వెళ్లండి.';

  @override
  String get faBurnAvoid =>
      'ఐస్, వెన్న, నూనె, టూత్‌పేస్ట్ లేదా పసుపు రాయవద్దు.\nబొబ్బలు చిదపవద్దు.\nకాలిన చోటును నాకనివ్వవద్దు.';

  @override
  String get faBurnVet =>
      'కాలిన గాయాలు కనిపించే దానికంటే లోతుగా ఉండవచ్చు. అదే రోజు వెట్‌కి చూపించండి.';

  @override
  String get faBiteTitle => 'పాము లేదా పురుగు కాటు';

  @override
  String get faBiteSigns =>
      'ఉన్నట్టుండి వాపు, నొప్పి, కాటు గుర్తులు, రక్తం, నీరసం, చొంగ కారడం లేదా ఊపిరి ఆడకపోవడం.';

  @override
  String get faBiteSteps =>
      'ప్రశాంతంగా, వీలైనంత కదలకుండా ఉంచండి; వీలైతే ఎత్తుకుని తీసుకెళ్లండి.\nకాటు పడిన భాగాన్ని గుండె ఎత్తులో లేదా కిందుగా ఉంచండి.\nమెడ లేదా ముఖం వాస్తుంటే కాలర్ తీసేయండి.\nతేనెటీగ కుడితే, కొండిని కార్డుతో గీకి తీసేయండి.\nవెంటనే దగ్గర్లోని క్లినిక్‌కి వెళ్లండి. తెరిచి ఉన్నది చూడటానికి SOS వాడండి.\nసురక్షితంగా ఉంటే, పాము రంగు, పరిమాణం గుర్తుంచుకోండి లేదా దూరం నుంచి ఫోటో తీయండి.';

  @override
  String get faBiteAvoid =>
      'గాయాన్ని కోయవద్దు, విషం పీల్చి తీయడానికి ప్రయత్నించవద్దు.\nకాటు పైన బిగుతైన కట్టు కట్టవద్దు.\nపామును పట్టుకోవడానికి ప్రయత్నించవద్దు.';

  @override
  String get faBiteVet =>
      'ప్రతి పాము కాటు అత్యవసరమే. బాగానే ఉన్నట్టు కనిపించినా వెళ్లండి.';

  @override
  String get faTickTitle => 'గోమారి (టిక్) తీయడం';

  @override
  String get faTickSigns =>
      'చర్మానికి అతుక్కున్న చిన్న బూడిద-గోధుమ రంగు బుడిపె, తరచుగా చెవులు, మెడ, చంకలు లేదా వేళ్ల మధ్య.';

  @override
  String get faTickSteps =>
      'వీలైతే గ్లవ్స్ వేసుకోండి. బొచ్చును విడదీసి గోమారిని స్పష్టంగా చూడండి.\nసన్నని పట్టకారు లేదా టిక్ హుక్‌తో చర్మానికి దగ్గరగా పట్టుకోండి.\nతిప్పకుండా, నొక్కకుండా, మెల్లగా స్థిరంగా నేరుగా బయటకు లాగండి.\nఆ చోటును యాంటీసెప్టిక్‌తో శుభ్రం చేసి చేతులు కడుక్కోండి.\nగోమారిని ఆల్కహాల్‌లో వేయండి, లేదా టేప్‌లో మూసి పారేయండి.\nతర్వాత 3 వారాలు జ్వరం, నీరసం లేదా పాలిపోయిన చిగుళ్లు ఉన్నాయేమో గమనించండి.';

  @override
  String get faTickAvoid =>
      'గోమారిని కాల్చవద్దు, నూనె, కిరోసిన్ లేదా పెట్రోల్ పూయవద్దు.\nగోమారి శరీరాన్ని నొక్కవద్దు.\nఒట్టి వేళ్లతో గోమారిని నలపవద్దు.';

  @override
  String get faTickVet =>
      'జ్వరం, నీరసం, తినకపోవడం లేదా చాలా గోమారులు ఉంటే వెట్‌కి చూపించండి. గోమారి నివారణ గురించి అడగండి.';

  @override
  String get clearSearch => 'వెతుకుడు తొలగించండి';

  @override
  String get closedNow => 'ఇప్పుడు మూసి ఉంది';

  @override
  String get copy => 'కాపీ చేయండి';

  @override
  String get openInMaps => 'మ్యాప్స్‌లో తెరవండి';

  @override
  String get draftVetReview => 'డ్రాఫ్ట్, వెట్ పరిశీలించాల్సి ఉంది';

  @override
  String get sosCallNearest => 'దగ్గర్లోని క్లినిక్‌కి కాల్ చేయండి';

  @override
  String get sosGetAddress => 'దగ్గర్లోని క్లినిక్ చిరునామా';

  @override
  String get sosFinding => 'మీ దగ్గర క్లినిక్‌లు వెతుకుతున్నాం…';

  @override
  String get sosLocating => 'మీరు ఎక్కడ ఉన్నారో చూస్తున్నాం…';

  @override
  String get sosUsingGps => 'మీ ప్రస్తుత లొకేషన్ వాడుతున్నాం';

  @override
  String sosUsingLastKnown(String time) {
    return 'మీ చివరి లొకేషన్ వాడుతున్నాం ($time నాటిది)';
  }

  @override
  String sosUsingArea(String area) {
    return 'లొకేషన్ ఆఫ్‌లో ఉంది. $area దగ్గర క్లినిక్‌లు చూపిస్తున్నాం.';
  }

  @override
  String sosLocatingNear(String area) {
    return 'మీ లొకేషన్ వెతుకుతున్నాం… అప్పటివరకు $area దగ్గర క్లినిక్‌లు.';
  }

  @override
  String get sosLocatingLastKnown =>
      'మీ లొకేషన్ వెతుకుతున్నాం… అప్పటివరకు మీ చివరి లొకేషన్ దగ్గర క్లినిక్‌లు.';

  @override
  String get sosLocationOffHint => 'ప్రాంతం తప్పా? సరైన జాబితా కోసం మార్చండి.';

  @override
  String get sosTryLocation => 'నా లొకేషన్ మళ్లీ ప్రయత్నించండి';

  @override
  String get sosChangeArea => 'ప్రాంతం మార్చండి';

  @override
  String sosSavedClinics(String when) {
    return 'ఇంటర్నెట్ బలహీనంగా ఉంది: $whenన సేవ్ చేసిన క్లినిక్‌లు చూపిస్తున్నాం.';
  }

  @override
  String get sosNoClinics =>
      'దగ్గర్లో క్లినిక్‌లు దొరకలేదు. వేరే ప్రాంతం ప్రయత్నించండి.';

  @override
  String sosCallClinic(String name) {
    return '$nameకి కాల్ చేయండి';
  }

  @override
  String sosAway(String km) {
    return '$km దూరం';
  }

  @override
  String sosDemoCall(String phone) {
    return 'డెమో: ఇది $phoneకి కాల్ చేస్తుంది. డెమోలో నిజమైన కాల్ వెళ్లదు.';
  }

  @override
  String get sosShowVet => 'ఇది వెట్‌కి చూపించండి';

  @override
  String get firstAidTitle => 'ప్రథమ చికిత్స';

  @override
  String get firstAidOfflineHint => 'ఇంటర్నెట్ లేకుండా పనిచేసే దశలవారీ గైడ్‌లు';

  @override
  String get firstAidOffline => 'ఇంటర్నెట్ లేకుండా పనిచేస్తుంది';

  @override
  String get firstAidEmergencyNote =>
      'ఊపిరి ఆడట్లేదా, పడిపోయిందా, లేదా రక్తం బాగా కారుతోందా? ఇప్పుడే SOS నొక్కి పట్టి క్లినిక్‌కి వెళ్లండి. దారిలో ఈ గైడ్‌లు సహాయపడతాయి.';

  @override
  String get firstAidSigns => 'లక్షణాలు';

  @override
  String get firstAidWhatToDo => 'ఏమి చేయాలి';

  @override
  String get firstAidAvoid => 'చేయకూడనివి';

  @override
  String get firstAidWhenVet => 'వెట్‌కి ఎప్పుడు చూపించాలి';

  @override
  String get firstAidTalkToVet => 'ఇప్పుడే వెట్‌తో మాట్లాడండి';

  @override
  String get toxTitle => 'ఇది సురక్షితమేనా?';

  @override
  String get toxTileHint =>
      'మీ పెంపుడు జంతువు కోసం ఆహారం, మొక్కలు, ఇంటి వస్తువులు చూడండి';

  @override
  String get toxSearchLabel => 'ఆహారం, మొక్క లేదా ఇంటి వస్తువు';

  @override
  String get toxSearchHint => 'ఉదా: ద్రాక్ష, లిల్లీ, చాక్లెట్';

  @override
  String get toxForWhichPet => 'ఏ పెంపుడు జంతువు కోసం?';

  @override
  String get toxKindAll => 'అన్నీ';

  @override
  String get toxKindFood => 'ఆహారం';

  @override
  String get toxKindPlant => 'మొక్కలు';

  @override
  String get toxKindHome => 'ఇంట్లోని వస్తువులు';

  @override
  String get toxDanger => 'ప్రమాదకరం';

  @override
  String get toxCaution => 'జాగ్రత్తగా ఉండండి';

  @override
  String get toxSafe => 'కొంచెం అయితే సురక్షితం';

  @override
  String get toxForEachPet => 'ఒక్కో రకం పెంపుడు జంతువుకు';

  @override
  String get toxAteIt =>
      'ఇప్పటికే తినేసిందా? లక్షణాల కోసం ఆగవద్దు. ఇప్పుడే సహాయం తీసుకోండి, ప్యాకెట్ లేదా ఫోటో వెంట తీసుకెళ్లండి.';

  @override
  String get toxPoisoningGuide => 'విషం గైడ్ తెరవండి';

  @override
  String get toxNoMatch => 'ఇది ఇంకా మా జాబితాలో లేదు';

  @override
  String get toxNoMatchHint =>
      'ఖచ్చితంగా తెలియకపోతే ఇవ్వవద్దు, వెట్‌ని అడగండి.';

  @override
  String get lostIntro =>
      'ప్రతి పెంపుడు జంతువుకు ఒక QR ట్యాగ్ ఉంటుంది. దాన్ని స్కాన్ చేసినవారికి మీ పెంపుడు జంతువు ఫోటోతో ఒక పేజీ కనిపిస్తుంది, వారు మీకు మెసేజ్ పంపవచ్చు లేదా తమ లొకేషన్ పంచుకోవచ్చు. మీ ఫోన్ నంబర్ దాచి ఉంటుంది.';

  @override
  String get lostSafeAtHome => 'ఇంట్లో క్షేమంగా ఉంది';

  @override
  String lostSinceShort(String when) {
    return '$when నుంచి తప్పిపోయింది';
  }

  @override
  String lostPetTitle(String pet) {
    return '$pet · QR ట్యాగ్';
  }

  @override
  String lostIfMissing(String pet) {
    return '$pet తప్పిపోతే';
  }

  @override
  String get lostIfMissingBody =>
      'తప్పిపోయిందని గుర్తించండి: ఒక పేజీ పంచుకోండి, కావాలంటే దగ్గర్లోని PawSetu యూజర్లకు అలర్ట్ పంపండి, ఒక్క ట్యాప్‌తో పోస్టర్ తయారు చేయండి.';

  @override
  String lostMarkLost(String pet) {
    return '$pet తప్పిపోయిందని గుర్తించండి';
  }

  @override
  String get lostWhereSeen => 'మీ పెంపుడు జంతువు చివరిగా ఎక్కడ కనిపించింది?';

  @override
  String get lostUsingGps => 'మీరు ఇప్పుడున్న చోటు';

  @override
  String get lostNearMe => 'నా లొకేషన్ దగ్గర';

  @override
  String get lostWhenSeen => 'ఎప్పుడు?';

  @override
  String get lostWhenNow => 'ఇప్పుడే';

  @override
  String get lostWhenHour => 'సుమారు గంట క్రితం';

  @override
  String get lostWhenMorning => 'ఈ రోజు ఉదయం';

  @override
  String get lostWhenYesterday => 'నిన్న సాయంత్రం';

  @override
  String get lostNoteLabel => 'గుర్తుపట్టడానికి సహాయపడే ఏదైనా విషయం';

  @override
  String get lostNoteHint => 'ఉదా: ఎర్ర కాలర్, కొత్తవాళ్లంటే భయం';

  @override
  String get lostAlertNearby =>
      '5 కి.మీ. లోపల ఉన్న PawSetu యూజర్లకు అలర్ట్ పంపండి';

  @override
  String get lostAlertNearbyHint =>
      'తప్పిపోయిన పెంపుడు జంతువుల అలర్ట్‌లు ఆన్ చేసుకున్నవారికి మాత్రమే వెళ్తుంది. వారికి పేజీ కనిపిస్తుంది, మీ నంబర్ ఎప్పుడూ కాదు.';

  @override
  String get lostMarkLostConfirm => 'తప్పిపోయిందని గుర్తించండి';

  @override
  String lostMarked(String pet) {
    return '$pet తప్పిపోయిందని గుర్తించాం. మీ కుటుంబానికి తెలియజేశాం.';
  }

  @override
  String lostDemoAlert(int count, String area) {
    return 'డెమో: $areaకి 5 కి.మీ. లోపల తప్పిపోయిన పెంపుడు జంతువుల అలర్ట్‌లు ఆన్ చేసుకున్న $count PawSetu యూజర్లకు అలర్ట్ చేరింది. మెసేజ్‌లు డెమో అవుట్‌బాక్స్‌లో ఉన్నాయి; నిజమైన అలర్ట్ ఏదీ పంపలేదు.';
  }

  @override
  String lostBannerTitle(String pet) {
    return '$pet తప్పిపోయినట్టు గుర్తించారు';
  }

  @override
  String lostBannerBody(String when, String area) {
    return '$when నుంచి, $area దగ్గర.';
  }

  @override
  String lostAlertsSent(int count) {
    return 'దగ్గర్లోని $count మందికి అలర్ట్ పంపాం';
  }

  @override
  String get lostSightings => 'ఎక్కడ కనిపించింది';

  @override
  String get lostNoSightings =>
      'ఇంకా ఎక్కడా కనిపించలేదు. ఎక్కువ మంది సహాయం చేయడానికి పేజీ, పోస్టర్ పంచుకోండి.';

  @override
  String get lostSightingNoDetails => 'లొకేషన్ పంచుకున్నారు';

  @override
  String get lostMakePoster => 'పోస్టర్ తయారు చేయండి (PDF)';

  @override
  String get lostShareLink => 'తప్పిపోయిన పేజీ పంచుకోండి';

  @override
  String lostShareText(String pet, String area, String url) {
    return 'దయచేసి సహాయం చేయండి! $pet $area దగ్గర తప్పిపోయింది. కనిపిస్తే ఇది తెరవండి: $url';
  }

  @override
  String lostMarkFound(String pet) {
    return '$pet దొరికింది';
  }

  @override
  String lostFoundConfirmTitle(String pet) {
    return '$pet క్షేమంగా ఇంటికి వచ్చిందా?';
  }

  @override
  String get lostFoundConfirmBody =>
      'తప్పిపోయిన పేజీ తీసేసి మీ కుటుంబానికి చెబుతాం.';

  @override
  String get lostFoundConfirm => 'అవును, దొరికింది';

  @override
  String lostWelcomeHome(String pet) {
    return 'ఇంటికి స్వాగతం, $pet!';
  }

  @override
  String lostFamilyTitle(String pet) {
    return '$pet తప్పిపోయింది';
  }

  @override
  String lostFamilyBody(String name, String area) {
    return '$name $area దగ్గర తప్పిపోయిందని గుర్తించారు. పంచుకోవడానికి పేజీ తెరవండి.';
  }

  @override
  String lostFoundTitle(String pet) {
    return 'శుభవార్త: $pet క్షేమంగా ఇంటికి వచ్చింది';
  }

  @override
  String lostNearbyTitle(String pet) {
    return '$petని చూశారా? మీ దగ్గర ఒక పెంపుడు జంతువు తప్పిపోయింది';
  }

  @override
  String lostNearbyBody(String area) {
    return 'చివరిగా $area దగ్గర కనిపించింది. ఫోటో చూసి కుటుంబానికి చెప్పడానికి ట్యాప్ చేయండి.';
  }

  @override
  String qrTagHint(String pet) {
    return 'దీన్ని $pet కాలర్ ట్యాగ్ కోసం ప్రింట్ చేయండి. స్కాన్ చేసినవారు మీ నంబర్ చూడకుండానే మీకు మెసేజ్ పంపగలరు.';
  }

  @override
  String qrForPet(String pet) {
    return '$pet ట్యాగ్ QR కోడ్';
  }

  @override
  String get qrPrintTags => 'QR ట్యాగ్‌లు ప్రింట్ చేయండి (PDF)';

  @override
  String get qrOpenPage => 'పేజీ తెరవండి';

  @override
  String qrTagsTitle(String pet) {
    return '$pet కోసం QR ట్యాగ్‌లు';
  }

  @override
  String get qrTagsSubtitle => 'ఒక ట్యాగ్ కత్తిరించి కాలర్‌కు పెట్టండి';

  @override
  String get qrTagsFooter =>
      'PawSetuతో తయారైంది. ట్యాగ్ స్కాన్ చేస్తే కుటుంబం ఫోన్ నంబర్ ఎప్పుడూ కనిపించదు.';

  @override
  String get qrTagScanLine =>
      'నేను ఒంటరిగా కనిపిస్తే, స్కాన్ చేసి నా కుటుంబానికి చెప్పండి';

  @override
  String posterTitle(String pet) {
    return '$pet తప్పిపోయిన పోస్టర్';
  }

  @override
  String posterHeadline(String species) {
    return 'తప్పిపోయిన $species';
  }

  @override
  String posterLastSeen(String area, String when) {
    return 'చివరిగా $area దగ్గర కనిపించింది, $when';
  }

  @override
  String get posterScan => 'నన్ను చూశారా? దీన్ని స్కాన్ చేయండి';

  @override
  String get posterScanBody =>
      'మెసేజ్ పంపండి లేదా నన్ను ఎక్కడ చూశారో చెప్పండి. నా కుటుంబానికి వెంటనే చేరుతుంది.';

  @override
  String get lostTagInactive => 'ఈ ట్యాగ్ యాక్టివ్‌గా లేదు';

  @override
  String get lostTagInactiveHint =>
      'లింక్ పాతది లేదా తప్పుగా ఉండవచ్చు. మీకు ఏదైనా పెంపుడు జంతువు దొరికితే, దగ్గర్లోని క్లినిక్‌కి తీసుకెళ్లండి: అక్కడ మైక్రోచిప్ స్కాన్ చేయగలరు.';

  @override
  String get finderDemoNote =>
      'డెమో పేజీ: మెసేజ్‌లు, లొకేషన్‌లు డెమో అవుట్‌బాక్స్‌కి వెళ్తాయి, నిజమైన కుటుంబానికి కాదు.';

  @override
  String get finderDemoSuffix => '(డెమో)';

  @override
  String finderLostHeadline(String pet) {
    return '$pet తప్పిపోయింది';
  }

  @override
  String finderLastSeen(String area, String when) {
    return 'చివరిగా $area దగ్గర · $when';
  }

  @override
  String finderHello(String pet) {
    return 'నమస్తే, నేను $pet!';
  }

  @override
  String finderHelloLost(String pet) {
    return 'నేను $pet. నన్ను ఇంటికి చేర్చడంలో సహాయం చేయండి!';
  }

  @override
  String get finderAsk =>
      'నేను ఒంటరిగా ఉంటే, నా కుటుంబానికి చెప్పండి. వాళ్లు నా కోసం వస్తారు.';

  @override
  String get finderLostAsk =>
      'నా కుటుంబం నా కోసం వెతుకుతోంది. వీలైతే నన్ను సురక్షితంగా ఉంచి, వాళ్లకు మెసేజ్ లేదా మీ లొకేషన్ పంపండి.';

  @override
  String get finderContact => 'నా కుటుంబాన్ని సంప్రదించండి';

  @override
  String get finderShareLocation => 'నా లొకేషన్ పంచుకోండి';

  @override
  String get finderPrivacy =>
      'PawSetu మీ మెసేజ్‌ను చేరవేస్తుంది. కుటుంబం నంబర్ ప్రైవేట్‌గా ఉంటుంది; మీకు తిరిగి కాల్ కావాలంటేనే మీ నంబర్ ఇవ్వండి.';

  @override
  String get finderTips =>
      'నీళ్లు, నీడ ఇవ్వండి, పట్టీతో లేదా మూసి ఉన్న చోట ఉంచండి, భయపడిన జంతువును వెంబడించవద్దు.';

  @override
  String get finderContactHint =>
      'మీ మెసేజ్ నేరుగా PawSetu యాప్‌లో కుటుంబానికి వెళ్తుంది.';

  @override
  String get finderMessageLabel => 'మీ మెసేజ్';

  @override
  String finderMessageStart(String pet) {
    return 'నమస్తే, నాకు $pet ఇక్కడ దొరికింది: ';
  }

  @override
  String get finderYourName => 'మీ పేరు (ఐచ్ఛికం)';

  @override
  String get finderYourPhone => 'మీ ఫోన్ (ఐచ్ఛికం)';

  @override
  String get finderPhoneHelper => 'కుటుంబం మీకు కాల్ చేయాలనుకుంటేనే';

  @override
  String get finderSend => 'పంపండి';

  @override
  String finderSent(String pet) {
    return '$pet కుటుంబానికి మెసేజ్ పంపాం. ధన్యవాదాలు!';
  }

  @override
  String finderLocationSent(String pet) {
    return '$pet కుటుంబానికి లొకేషన్ పంపాం. ధన్యవాదాలు!';
  }

  @override
  String get finderTooMany =>
      'ఈ ట్యాగ్‌కి ఇప్పుడు చాలా మెసేజ్‌లు వచ్చాయి. దయచేసి గంట తర్వాత ప్రయత్నించండి.';

  @override
  String get finderWhereSeen => 'మీరు ఎక్కడ ఉన్నారు?';

  @override
  String get finderLocationOff =>
      'మీ లొకేషన్ ఆఫ్‌లో ఉంది. ప్రాంతం ఎంచుకుని, ఏదైనా గుర్తు రాయండి.';

  @override
  String get finderLandmark => 'గుర్తు (ల్యాండ్‌మార్క్)';

  @override
  String get finderLandmarkHint => 'ఉదా: మెట్రో స్టేషన్ దగ్గర';

  @override
  String finderMessageTitle(String pet) {
    return 'ట్యాగ్ స్కాన్ చేసినవారి నుంచి $pet గురించి మెసేజ్';
  }

  @override
  String finderFrom(String from) {
    return 'పంపినవారు: $from';
  }

  @override
  String finderSightingTitle(String pet) {
    return '$pet ఎక్కడ కనిపించిందో ఎవరో పంచుకున్నారు';
  }

  @override
  String get devDemoNote =>
      'డెమో పరికరాలు: అన్నీ ప్రయత్నించడానికి రీడింగ్‌లు అనుకరణవి.';

  @override
  String get devAdd => 'పరికరం జోడించండి';

  @override
  String get devNoneTitle => 'ఇంకా పరికరాలు లేవు';

  @override
  String get devNoneBody =>
      'GPS కాలర్, యాక్టివిటీ ట్రాకర్, ఫీడర్, నీటి ఫౌంటెన్, కెమెరా లేదా లిట్టర్ బాక్స్ జత చేయండి.';

  @override
  String get devGpsCollar => 'GPS కాలర్';

  @override
  String get devGpsCollarHint => 'లైవ్ లొకేషన్, సేఫ్ జోన్ అలర్ట్';

  @override
  String get devActivityTracker => 'యాక్టివిటీ ట్రాకర్';

  @override
  String get devActivityTrackerHint => 'అడుగులు, చురుకైన నిమిషాలు';

  @override
  String get devFeeder => 'స్మార్ట్ ఫీడర్';

  @override
  String get devFeederHint => 'మీరు బయట ఉన్నా సమయానికి భోజనం';

  @override
  String get devFountain => 'నీటి ఫౌంటెన్';

  @override
  String get devFountainHint => 'నీటి మట్టం, ఫిల్టర్ రిమైండర్లు';

  @override
  String get devCamera => 'పెట్ కెమెరా';

  @override
  String get devCameraHint => 'మీరు దూరంగా ఉన్నా మీ పెంపుడు జంతువును చూడండి';

  @override
  String get devLitterBox => 'స్మార్ట్ లిట్టర్ బాక్స్';

  @override
  String get devLitterBoxHint => 'వాడకం, శుభ్రత రిమైండర్లు';

  @override
  String get devPairDemo =>
      'డెమో జత చేయడం: మీ కోసం ఒక డెమో పరికరం కనుగొంటాం. బ్లూటూత్‌తో ఏదీ కనెక్ట్ అవ్వదు.';

  @override
  String get devStepType => '1. ఏ రకం పరికరం?';

  @override
  String get devStepPet => '2. ఏ పెంపుడు జంతువు కోసం?';

  @override
  String get devStepFind => '3. పరికరాన్ని కనుగొనండి';

  @override
  String get devStepName => '4. పేరు పెట్టండి';

  @override
  String get devNotForAll =>
      'ఈ పరికరం సరిపోనందున కొన్ని పెంపుడు జంతువులు బూడిద రంగులో ఉన్నాయి.';

  @override
  String get devSearch => 'పరికరం కోసం వెతకండి';

  @override
  String get devSearching => 'దగ్గర్లో వెతుకుతున్నాం…';

  @override
  String devDefaultName(String pet, String type) {
    return '$pet $type';
  }

  @override
  String get devNameLabel => 'పరికరం పేరు';

  @override
  String devSafeZoneRadius(int metres) {
    return 'సేఫ్ జోన్: ఇంటి చుట్టూ $metres మీ.';
  }

  @override
  String get devSafeZoneHint => 'కాలర్ ఈ వృత్తం దాటగానే మీకు అలర్ట్ వస్తుంది.';

  @override
  String get devPair => 'పరికరం జత చేయండి';

  @override
  String devPaired(String name) {
    return '$name జత అయింది';
  }

  @override
  String get devLiveTitle => 'వెర్షన్ 2లో వస్తుంది';

  @override
  String get devLiveBody =>
      'నిజమైన పరికరాలు లైవ్ వెర్షన్‌లో కనెక్ట్ అవుతాయి. ప్రస్తుతానికి డెమో పరికరాలు ప్రయత్నించండి.';

  @override
  String get devConnected => 'కనెక్ట్ అయింది';

  @override
  String devInsideZone(int metres) {
    return 'సేఫ్ జోన్ లోపల · ఇంటి నుంచి $metres మీ.';
  }

  @override
  String devOutsideZone(int metres) {
    return 'సేఫ్ జోన్ బయట! ఇంటి నుంచి $metres మీ.';
  }

  @override
  String devStepsToday(String steps) {
    return 'ఈ రోజు $steps అడుగులు';
  }

  @override
  String devNextMeal(String time) {
    return 'తదుపరి భోజనం $timeకి';
  }

  @override
  String devWaterLevel(int pct) {
    return 'నీటి మట్టం: $pct%';
  }

  @override
  String get devCameraReady => 'సిద్ధంగా ఉంది';

  @override
  String devLitterVisits(int count) {
    return 'ఈ రోజు $count సార్లు';
  }

  @override
  String devUpdated(String time) {
    return '$timeకి అప్‌డేట్ అయింది';
  }

  @override
  String get devLocate => 'ఇప్పుడే కనుగొనండి';

  @override
  String get devLocated => 'లొకేషన్ అప్‌డేట్ అయింది';

  @override
  String get devEditZone => 'సేఫ్ జోన్ మార్చండి';

  @override
  String get devNoZone =>
      'ఇంకా సేఫ్ జోన్ పెట్టలేదు. అలర్ట్‌ల కోసం సెట్ చేయండి.';

  @override
  String get devAlertSent =>
      'ఈ పెంపుడు జంతువును చూసుకునే అందరికీ అలర్ట్ వెళ్లింది (పుష్, SMS).';

  @override
  String get devBackInside => 'సేఫ్ జోన్‌లోకి తిరిగి వచ్చింది.';

  @override
  String get devDemoControls => 'డెమో నియంత్రణలు';

  @override
  String get devDemoControlsHint =>
      'ఇంటి నుంచి కదలకుండా సేఫ్ జోన్ అలర్ట్ ప్రయత్నించండి.';

  @override
  String devDemoWalkOut(String pet) {
    return 'డెమో: $petని సేఫ్ జోన్ బయటకు తీసుకెళ్లండి';
  }

  @override
  String devDemoComeHome(String pet) {
    return 'డెమో: $petని ఇంటికి తీసుకురండి';
  }

  @override
  String get devToday => 'ఈ రోజు';

  @override
  String devActiveMinutes(int active, int goal) {
    return '$goalలో $active చురుకైన నిమిషాలు';
  }

  @override
  String get devNoSessions => 'ఈ రోజు ఇంకా నడక లేదా ఆట నమోదు కాలేదు.';

  @override
  String devWalkSession(int minutes, String km) {
    return 'నడక · $minutes ని. · $km కి.మీ.';
  }

  @override
  String devPlaySession(int minutes) {
    return 'ఆట · $minutes ని.';
  }

  @override
  String get devInRoutine => 'రోజువారీ దినచర్యలో చేర్చారు';

  @override
  String devFlowsToRoutine(String pet) {
    return 'ఈ పరికరం నుంచి నడకలు, ఆటలు ఆటోమేటిక్‌గా $pet రోజువారీ దినచర్యలో చేరతాయి.';
  }

  @override
  String devSynced(int count, String pet) {
    return '$pet దినచర్యలో $count కార్యకలాపాలు చేర్చాం';
  }

  @override
  String devHopper(int pct) {
    return 'ఫీడర్‌లో మిగిలిన ఆహారం: $pct%';
  }

  @override
  String get devMealsToday => 'ఈ రోజు భోజనాలు';

  @override
  String get devNoMealsYet => 'ఈ రోజు ఇంకా భోజనం పెట్టలేదు.';

  @override
  String devMealGrams(int grams) {
    return '$grams గ్రా. పెట్టింది';
  }

  @override
  String get devFeedNow => 'ఇప్పుడు కొంచెం ఆహారం పెట్టండి';

  @override
  String devFed(String pet) {
    return '$petకి కొంచెం ఆహారం పెట్టి ఈ రోజు భోజనాల్లో చేర్చాం.';
  }

  @override
  String devFilterDays(int days) {
    return '$days రోజుల్లో ఫిల్టర్ మార్చాలి';
  }

  @override
  String get devRefillSoon => 'నీళ్లు తగ్గుతున్నాయి. త్వరలో ఫౌంటెన్ నింపండి.';

  @override
  String get devCameraPlaceholder =>
      'లైవ్ వీడియో నిజమైన కెమెరాలతో వెర్షన్ 2లో వస్తుంది.';

  @override
  String get devSnapshot => 'స్నాప్‌షాట్ తీయండి';

  @override
  String get devSnapshotDemo =>
      'డెమో: నిజమైన కెమెరా మీ పెంపుడు జంతువు ఫోటోను ఇక్కడికి పంపుతుంది.';

  @override
  String devLastVisit(String time) {
    return 'చివరిసారి $timeకి';
  }

  @override
  String get devCleanSoon => 'త్వరలో శుభ్రం చేయండి';

  @override
  String get devLitterClean => 'శుభ్రంగా ఉంది';

  @override
  String get devRemove => 'పరికరం తొలగించండి';

  @override
  String devRemoveTitle(String name) {
    return '$name తొలగించాలా?';
  }

  @override
  String get devRemoveBody =>
      'ఇది డేటా పంపడం ఆపేస్తుంది. దినచర్యలో ఉన్న రికార్డులు అలాగే ఉంటాయి.';

  @override
  String zoneLeftTitle(String pet) {
    return '$pet సేఫ్ జోన్ దాటి వెళ్లింది';
  }

  @override
  String zoneLeftBody(String device, int metres) {
    return '$device: ఇప్పుడు ఇంటి నుంచి $metres మీ. దూరంలో ఉంది. ఎక్కడో చూడటానికి ట్యాప్ చేయండి.';
  }

  @override
  String zoneBackTitle(String pet) {
    return '$pet సేఫ్ జోన్‌లోకి తిరిగి వచ్చింది';
  }

  @override
  String get toxChocolateName => 'చాక్లెట్';

  @override
  String get toxChocolateWhy =>
      'ఇందులో థియోబ్రోమిన్, కెఫీన్ ఉంటాయి. వీటి వల్ల వాంతులు, గుండె వేగంగా కొట్టుకోవడం, ఫిట్స్ రావచ్చు. డార్క్ చాక్లెట్, కోకో పౌడర్ అత్యంత ప్రమాదకరం.';

  @override
  String get toxGrapesName => 'ద్రాక్ష, కిస్మిస్';

  @override
  String get toxGrapesWhy =>
      'కొన్ని ద్రాక్షలు లేదా కిస్మిస్ కూడా కుక్కలు, పిల్లుల్లో ఉన్నట్టుండి కిడ్నీలు పాడయ్యేలా చేయవచ్చు. పక్షులు, కుందేళ్లు: అప్పుడప్పుడు చిన్న ముక్క మాత్రమే.';

  @override
  String get toxOnionGarlicName => 'ఉల్లి, వెల్లుల్లి';

  @override
  String get toxOnionGarlicWhy =>
      'పచ్చిగా, వండినా, పొడిగా, కూరలు, గ్రేవీల్లో ఉన్నా, ఇవి ఎర్ర రక్త కణాలను దెబ్బతీసి కొన్ని రోజుల తర్వాత నీరసం తెస్తాయి.';

  @override
  String get toxXylitolName => 'జైలిటాల్ (షుగర్-ఫ్రీ తీపి)';

  @override
  String get toxXylitolWhy =>
      'షుగర్-ఫ్రీ చూయింగ్ గమ్, మింట్స్, కొన్ని పీనట్ బటర్లు, మందుల్లో ఉంటుంది. కుక్కల్లో ఉన్నట్టుండి రక్తంలో చక్కెర పడిపోయి, లివర్ దెబ్బతింటుంది. అన్ని పెంపుడు జంతువులకు దూరంగా ఉంచండి.';

  @override
  String get toxAlcoholName => 'మద్యం';

  @override
  String get toxAlcoholWhy =>
      'కొంచెం తాగినా వాంతులు, తడబాటు, ఊపిరి సమస్యలు, స్పృహ కోల్పోవడం జరగవచ్చు. ఈస్ట్ కలిపిన పచ్చి పిండి కూడా పొట్టలో ఆల్కహాల్‌ను తయారు చేస్తుంది.';

  @override
  String get toxCaffeineName => 'టీ, కాఫీ, కెఫీన్';

  @override
  String get toxCaffeineWhy =>
      'టీ, కాఫీ, ఎనర్జీ డ్రింక్స్, కెఫీన్ మాత్రల వల్ల అశాంతి, గుండె వేగంగా కొట్టుకోవడం, ఫిట్స్ రావచ్చు.';

  @override
  String get toxAvocadoName => 'అవకాడో';

  @override
  String get toxAvocadoWhy =>
      'పక్షులు, కుందేళ్లకు చాలా ప్రమాదం: గుండెను దెబ్బతీయవచ్చు. కుక్కలు, పిల్లుల్లో గింజ పేగుల్లో అడ్డుపడవచ్చు, తొక్క, ఆకులు కడుపు పాడు చేస్తాయి.';

  @override
  String get toxCookedBonesName => 'ఉడికించిన ఎముకలు';

  @override
  String get toxCookedBonesWhy =>
      'ఉడికించిన చికెన్ లేదా మటన్ ఎముకలు పదునుగా విరిగి గొంతులో ఇరుక్కోవచ్చు లేదా పేగులను చీల్చవచ్చు. ఉడికించిన ఎముకలు ఎప్పుడూ ఇవ్వవద్దు.';

  @override
  String get toxMilkName => 'పాలు';

  @override
  String get toxMilkWhy =>
      'చాలా పెద్ద పిల్లులు, కుక్కలు పాలు సరిగా అరిగించుకోలేవు, విరేచనాలు అవుతాయి. పక్షులు, కుందేళ్లకు పాలు ఇవ్వవద్దు.';

  @override
  String get toxSaltySnacksName => 'ఉప్పు స్నాక్స్ (మిక్చర్, చిప్స్)';

  @override
  String get toxSaltySnacksWhy =>
      'మిక్చర్, చిప్స్, అప్పడాల వల్ల దాహం, వాంతులు వస్తాయి; ఎక్కువ తింటే ఉప్పు విషంగా మారవచ్చు. పక్షులకు ఇది మరీ ప్రమాదం.';

  @override
  String get toxSpicyFoodName => 'కారం ఉన్న ఆహారం';

  @override
  String get toxSpicyFoodWhy =>
      'కారం, మసాలాలు కడుపు పాడు చేసి వాంతులు, విరేచనాలు తెస్తాయి. కూరల్లో సాధారణంగా ఉల్లి, వెల్లుల్లి కూడా ఉంటాయి.';

  @override
  String get toxFattyFoodName => 'వేయించిన, కొవ్వు ఆహారం';

  @override
  String get toxFattyFoodWhy =>
      'వేయించిన స్నాక్స్, నెయ్యి, కొవ్వు ముక్కలు, భారీ మిగిలిన ఆహారం వల్ల ప్యాంక్రియాటైటిస్ రావచ్చు, ఇది క్లోమం నొప్పితో వాచిపోవడం.';

  @override
  String get toxSweetsName => 'స్వీట్లు (మిఠాయి)';

  @override
  String get toxSweetsWhy =>
      'తీపి స్వీట్ల వల్ల బరువు పెరుగుతుంది, కడుపు పాడవుతుంది. చాలా వాటిలో నెయ్యి, చాక్లెట్, కిస్మిస్ లేదా షుగర్-ఫ్రీ తీపి ఉంటాయి.';

  @override
  String get toxFruitSeedsName => 'పండ్ల టెంకలు, గింజలు';

  @override
  String get toxFruitSeedsWhy =>
      'మామిడి టెంక, ఆపిల్ గింజలు, ప్లమ్, పీచ్, చెర్రీ టెంకలు గొంతులో లేదా పేగుల్లో అడ్డుపడవచ్చు, కొన్నింటిలో సైనైడ్ ఉంటుంది.';

  @override
  String get toxTomatoName => 'టమాటా';

  @override
  String get toxTomatoWhy =>
      'కొంచెం పండిన టమాటా సాధారణంగా పర్వాలేదు. పచ్చి టమాటాలు, ఆకులు, కాడలు హానికరం.';

  @override
  String get toxPeanutsName => 'వేరుశనగ';

  @override
  String get toxPeanutsWhy =>
      'ఉప్పు లేని, సాదా వేరుశనగలు మాత్రమే, ఒకసారి కొన్ని మాత్రమే. ఉప్పు లేదా మసాలా వేరుశనగలు సురక్షితం కాదు, పీనట్ బటర్‌లో జైలిటాల్ ఉండకూడదు.';

  @override
  String get toxMangoName => 'మామిడి';

  @override
  String get toxMangoWhy =>
      'పండిన మామిడి గుజ్జు చిన్న ట్రీట్‌గా పర్వాలేదు. తొక్క, టెంక తీసేయండి. ఎక్కువైతే విరేచనాలు అవుతాయి.';

  @override
  String get toxAppleName => 'ఆపిల్';

  @override
  String get toxAppleWhy =>
      'గింజలు, మధ్య భాగం తీసేసిన ఆపిల్ ముక్కలు ఆరోగ్యకరమైన, కరకరలాడే ట్రీట్.';

  @override
  String get toxBananaName => 'అరటి పండు';

  @override
  String get toxBananaWhy =>
      'చిన్న ముక్క మంచి ట్రీట్. ఇందులో చక్కెర ఎక్కువ, కాబట్టి కొంచెమే ఇవ్వండి.';

  @override
  String get toxWatermelonName => 'పుచ్చకాయ';

  @override
  String get toxWatermelonWhy =>
      'గింజలు, తొక్క లేని ముక్కలు వేసవిలో చల్లని ట్రీట్.';

  @override
  String get toxCarrotName => 'క్యారెట్';

  @override
  String get toxCarrotWhy =>
      'పచ్చి లేదా ఉడికించిన క్యారెట్ ఆరోగ్యకరమైన ట్రీట్. కుందేళ్లకు కొంచెమే ఇవ్వండి, ఎందుకంటే ఇందులో చక్కెర ఉంటుంది.';

  @override
  String get toxRiceName => 'సాదా అన్నం';

  @override
  String get toxRiceWhy =>
      'ఉప్పు, నెయ్యి, ఉల్లి, మసాలా లేని సాదా అన్నం కొంచెం ఇస్తే కడుపుకు తేలిక. కుందేళ్లకు అన్నం కాదు, ఎండు గడ్డి కావాలి.';

  @override
  String get toxEggName => 'ఉడికించిన గుడ్డు';

  @override
  String get toxEggWhy =>
      'బాగా ఉడికించిన గుడ్డు ప్రోటీన్ ఉన్న మంచి ట్రీట్. పచ్చి గుడ్డు ఇవ్వవద్దు. కుందేళ్లు మొక్కలు మాత్రమే తింటాయి.';

  @override
  String get toxLilyName => 'లిల్లీ పూలు';

  @override
  String get toxLilyWhy =>
      'లిల్లీ ప్రతి భాగం, పుప్పొడి లేదా పూల కుండీ నీళ్లు కూడా, పిల్లుల్లో కిడ్నీలను పాడు చేయవచ్చు. పిల్లి ఉన్న ఇంట్లో లిల్లీలు ఉంచవద్దు.';

  @override
  String get toxSagoPalmName => 'సైకస్ (సాగో పామ్)';

  @override
  String get toxSagoPalmWhy =>
      'ప్రతి భాగం విషం, ముఖ్యంగా గింజలు. వాంతులు, లివర్ పాడవడం జరుగుతుంది.';

  @override
  String get toxOleanderName => 'గన్నేరు';

  @override
  String get toxOleanderWhy =>
      'గన్నేరు గుండెపై ప్రభావం చూపుతుంది. కొన్ని ఆకులు లేదా పూలు కూడా ప్రాణాంతకం.';

  @override
  String get toxCastorName => 'ఆముదం మొక్క';

  @override
  String get toxCastorWhy =>
      'ఆముదం గింజల్లో రిసిన్ ఉంటుంది. ఒకటి రెండు గింజలు నమిలినా ప్రాణాంతకం.';

  @override
  String get toxDaturaName => 'ఉమ్మెత్త';

  @override
  String get toxDaturaWhy =>
      'దీని గింజలు, పూల వల్ల గుండె వేగంగా కొట్టుకోవడం, కనుపాపలు పెద్దవవడం, అయోమయం, ఫిట్స్ వస్తాయి.';

  @override
  String get toxLantanaName => 'లాంటానా';

  @override
  String get toxLantanaWhy =>
      'సాధారణంగా కంచెగా పెరిగే ఈ మొక్క పండ్లు, ఆకులు లివర్‌ను దెబ్బతీయవచ్చు.';

  @override
  String get toxAloeVeraName => 'కలబంద';

  @override
  String get toxAloeVeraWhy =>
      'పారదర్శక జెల్ సాధారణంగా పర్వాలేదు, కానీ తొక్క కింద ఉండే చేదు పసుపు రసం వాంతులు, విరేచనాలు తెస్తుంది.';

  @override
  String get toxMoneyPlantName => 'మనీ ప్లాంట్';

  @override
  String get toxMoneyPlantWhy =>
      'ఆకులు నమిలితే నోటిలో నొప్పి, చొంగ కారడం, వాంతులు వస్తాయి.';

  @override
  String get toxSnakePlantName => 'స్నేక్ ప్లాంట్';

  @override
  String get toxSnakePlantWhy =>
      'దీన్ని నమిలితే చొంగ కారడం, వాంతులు, విరేచనాలు రావచ్చు.';

  @override
  String get toxMarigoldName => 'బంతి పూలు';

  @override
  String get toxMarigoldWhy =>
      'బంతి పూలు నమిలితే నోటిలో కొంచెం మంట, కడుపు పాడవడం జరగవచ్చు.';

  @override
  String get toxTulsiName => 'తులసి';

  @override
  String get toxTulsiWhy =>
      'తులసి పెంపుడు జంతువులకు విషం కాదని భావిస్తారు. అయినా ఎక్కువ తింటే కడుపు పాడవవచ్చు.';

  @override
  String get toxArecaPalmName => 'అరెకా పామ్';

  @override
  String get toxArecaPalmWhy => 'పెంపుడు జంతువులకు సురక్షితమైన ఇంటి మొక్క.';

  @override
  String get toxSpiderPlantName => 'స్పైడర్ ప్లాంట్';

  @override
  String get toxSpiderPlantWhy =>
      'విషం కాదు, కానీ పిల్లులు దీన్ని నమలడం ఇష్టపడతాయి, కొంచెం వాంతి చేసుకోవచ్చు.';

  @override
  String get toxRatPoisonName => 'ఎలుకల మందు';

  @override
  String get toxRatPoisonWhy =>
      'దీని వల్ల లోపల రక్తస్రావం లేదా ఫిట్స్ వస్తాయి, కొన్నిసార్లు రోజుల తర్వాత. ప్యాకెట్‌ను వెట్ దగ్గరికి తీసుకెళ్లండి.';

  @override
  String get toxHumanMedicinesName => 'మనుషుల మందులు';

  @override
  String get toxHumanMedicinesWhy =>
      'పారాసిటమాల్, ఐబుప్రోఫెన్ లాంటి నొప్పి మందులు జంతువులకు విషం. ఒక్క పారాసిటమాల్ మాత్ర కూడా పిల్లి ప్రాణం తీయవచ్చు. వెట్ రాసిన మందులే ఇవ్వండి.';

  @override
  String get toxMosquitoRepellentName => 'దోమల కాయిల్స్, లిక్విడ్ వేపరైజర్లు';

  @override
  String get toxMosquitoRepellentWhy =>
      'వీటి పొగ పక్షుల ఊపిరితిత్తులను దెబ్బతీయవచ్చు. పెంపుడు జంతువులకు దూరంగా వాడండి, గదిలో గాలి ఆడనివ్వండి.';

  @override
  String get toxMothballsName => 'నాఫ్తలీన్ ఉండలు';

  @override
  String get toxMothballsWhy =>
      'నమిలితే విషం, వాటి వాసన పక్షులకు హాని చేస్తుంది. మూసి ఉన్న అల్మారాల్లో ఉంచండి.';

  @override
  String get toxNonStickFumesName => 'నాన్-స్టిక్ పాన్ పొగ';

  @override
  String get toxNonStickFumesWhy =>
      'బాగా వేడెక్కిన నాన్-స్టిక్ పాన్ నుంచి వచ్చే పొగ నిమిషాల్లో పక్షి ప్రాణం తీయవచ్చు. పక్షులను వంటగదికి దూరంగా ఉంచండి.';

  @override
  String get toxPhenylName => 'ఫినాయిల్, ఫ్లోర్ క్లీనర్లు';

  @override
  String get toxPhenylWhy =>
      'ఫినాయిల్, చాలా ఫ్లోర్ క్లీనర్లలో ఫినాల్స్ ఉంటాయి, ఇవి ముఖ్యంగా పిల్లులకు విషం. పెంపుడు జంతువులు నడిచే ముందు నేల ఆరనివ్వండి.';

  @override
  String reviewedBy(String name) {
    return '$name పరిశీలించారు';
  }

  @override
  String get featurePaused => 'ఈ సదుపాయం ప్రస్తుతం ఆఫ్‌లో ఉంది';

  @override
  String get featurePausedBody =>
      'PawSetu బృందం దీన్ని ఆపింది. దయచేసి తర్వాత చూడండి.';

  @override
  String get shopFeatured => 'ప్రత్యేకంగా ఎంచుకున్నవి';

  @override
  String admUsers(int owners, int partners) {
    return 'యూజర్లు: $owners పెట్ పేరెంట్స్, $partners భాగస్వాములు';
  }

  @override
  String get admPets => 'పెంపుడు జంతువులు';

  @override
  String get admBookings30 => 'బుకింగ్‌లు, గత 30 రోజులు';

  @override
  String get admOrderValue30 => 'ఆర్డర్ విలువ, గత 30 రోజులు';

  @override
  String get admCommission30 => 'సంపాదించిన కమిషన్, గత 30 రోజులు';

  @override
  String get admPlusMembers => 'Plus సభ్యులు';

  @override
  String get admSos30 => 'SOS వినియోగం, గత 30 రోజులు';

  @override
  String get admByDay => 'రోజు వారీగా';

  @override
  String get admByWeek => 'వారం వారీగా';

  @override
  String get admByMonth => 'నెల వారీగా';

  @override
  String get admCommissionReport => 'కమిషన్ రిపోర్ట్';

  @override
  String get admNoNumbers => 'ఇంకా లెక్కలు లేవు';

  @override
  String get admChartBookingsOrders => 'బుకింగ్‌లు మరియు ఆర్డర్‌లు';

  @override
  String get admLegendBookings => 'బుకింగ్‌లు';

  @override
  String get admLegendOrders => 'ఆర్డర్‌లు';

  @override
  String get admChartMoney => 'ఆర్డర్ విలువ మరియు కమిషన్';

  @override
  String get admLegendOrderValue => 'ఆర్డర్ విలువ';

  @override
  String get admLegendCommission => 'కమిషన్';

  @override
  String get admChartGrowth => 'కొత్త యూజర్లు, పెట్స్ మరియు Plus సభ్యులు';

  @override
  String get admLegendUsers => 'కొత్త యూజర్లు';

  @override
  String get admLegendPets => 'కొత్త పెట్స్';

  @override
  String get admLegendPlus => 'కొత్త Plus';

  @override
  String get admChartSos => 'SOS వినియోగం';

  @override
  String get admLegendSos => 'SOS';

  @override
  String get admTopClinics => 'ఎక్కువగా బుక్ అయిన క్లినిక్‌లు';

  @override
  String get admTopProducts => 'ఎక్కువగా అమ్ముడైన ఉత్పత్తులు';

  @override
  String get admBookingsUnit => 'బుకింగ్‌లు';

  @override
  String get admSoldUnit => 'అమ్ముడయ్యాయి';

  @override
  String admChange(String change) {
    return 'ముందుతో పోలిస్తే $change%';
  }

  @override
  String get admNothingYet => 'ఇంకా ఏమీ లేదు';

  @override
  String get admKindClinic => 'క్లినిక్';

  @override
  String get admStatusRejected => 'తిరస్కరించారు';

  @override
  String get admStatusSuspended => 'నిలిపివేశారు';

  @override
  String get admAllKinds => 'అన్నీ';

  @override
  String admWaitingCount(int count) {
    return '$count పరిశీలన కోసం వేచి ఉన్నాయి';
  }

  @override
  String get admNoPending => 'ఆమోదం కోసం ఏమీ వేచి లేదు';

  @override
  String get admNothingHere => 'ఇక్కడ ఏమీ లేదు';

  @override
  String admRejectTitle(String name) {
    return '$nameని తిరస్కరించాలా?';
  }

  @override
  String admSuspendTitle(String name) {
    return '$nameని నిలిపివేయాలా?';
  }

  @override
  String get admReasonDocs => 'పత్రాలు స్పష్టంగా లేవు';

  @override
  String get admReasonRegNo => 'రిజిస్ట్రేషన్ నంబర్ సరిపోలడం లేదు';

  @override
  String get admReasonDetails => 'వివరాలు అసంపూర్తిగా ఉన్నాయి';

  @override
  String admApprovedToast(String name) {
    return '$nameని ఆమోదించారు';
  }

  @override
  String admRejectedToast(String name) {
    return '$nameని తిరస్కరించారు';
  }

  @override
  String admSuspendedToast(String name) {
    return '$nameని నిలిపివేశారు';
  }

  @override
  String admAppliedOn(String date) {
    return '$dateన దరఖాస్తు';
  }

  @override
  String admRegNo(String regNo) {
    return 'రిజిస్ట్రేషన్ నంబర్: $regNo';
  }

  @override
  String get admRegMissing => 'రిజిస్ట్రేషన్ నంబర్ లేదు';

  @override
  String get admRegLooksRight => 'ఫార్మాట్ సరిగ్గా ఉంది';

  @override
  String get admRegCheck => 'ఈ నంబర్‌ని తనిఖీ చేయండి';

  @override
  String get admRegHint =>
      'దీన్ని ఎల్లప్పుడూ రాష్ట్ర వెటర్నరీ కౌన్సిల్ రిజిస్టర్‌తో సరిచూడండి.';

  @override
  String get admKycDocs => 'KYC పత్రాలు';

  @override
  String get admNoDocs => 'ఇంకా పత్రాలు అప్‌లోడ్ కాలేదు';

  @override
  String admReasonGiven(String reason) {
    return 'కారణం: $reason';
  }

  @override
  String get admApprove => 'ఆమోదించండి';

  @override
  String get admReinstate => 'మళ్లీ ఆమోదించండి';

  @override
  String get admReject => 'తిరస్కరించండి';

  @override
  String get admSuspend => 'నిలిపివేయండి';

  @override
  String get admSampleStamp => 'నమూనా';

  @override
  String get admDocDemoNote =>
      'డెమో: నమూనా పత్రాలు మాత్రమే. నిజమైన యాప్‌లో KYC ఫైళ్లు ఇక్కడే తెరుచుకుంటాయి.';

  @override
  String get admReasonLabel => 'కారణం (భాగస్వామికి కనిపిస్తుంది)';

  @override
  String get admSearchUsers => 'పేరు, ఈమెయిల్, ఫోన్ లేదా నగరంతో వెతకండి';

  @override
  String get admFilterOwners => 'పెట్ పేరెంట్స్';

  @override
  String get admFilterPartners => 'భాగస్వాములు';

  @override
  String get admFilterAdmins => 'అడ్మిన్‌లు';

  @override
  String admPeopleCount(int count) {
    return '$count మంది';
  }

  @override
  String get plusTrialChip => 'Plus ట్రయల్';

  @override
  String get admDeletionPending => 'తొలగింపు అభ్యర్థన';

  @override
  String admRoleConfirm(String name, String role) {
    return '$nameని $roleగా మార్చాలా?';
  }

  @override
  String get admRoleChanged =>
      'పాత్ర మారింది. వారు తదుపరి యాప్ తెరిచినప్పుడు వర్తిస్తుంది.';

  @override
  String admSuspendUserTitle(String name) {
    return '$name ఖాతాను నిలిపివేయాలా?';
  }

  @override
  String get admReasonAbuse => 'అసభ్య ప్రవర్తన';

  @override
  String get admReasonFraud => 'చెల్లింపు మోసం';

  @override
  String get admReasonFake => 'నకిలీ ఖాతా';

  @override
  String admUserSuspended(String name) {
    return '$name ఖాతా నిలిపివేయబడింది';
  }

  @override
  String admUserRestored(String name) {
    return '$name ఖాతా మళ్లీ యాక్టివ్‌గా ఉంది';
  }

  @override
  String get admCity => 'నగరం';

  @override
  String get admPlanLabel => 'ప్లాన్';

  @override
  String admPlusTill(String date) {
    return '$date వరకు Plus';
  }

  @override
  String admTrialTill(String date) {
    return '$date వరకు Plus ట్రయల్';
  }

  @override
  String get admJoined => 'చేరిన తేదీ';

  @override
  String admDeletionOn(String date) {
    return 'ఖాతా $dateన తొలగించబడుతుంది';
  }

  @override
  String get admNotYourself =>
      'మీ పాత్రను మార్చలేరు, మిమ్మల్ని మీరు నిలిపివేయలేరు.';

  @override
  String get admSaveRole => 'పాత్రను సేవ్ చేయండి';

  @override
  String get admUnsuspend => 'మళ్లీ యాక్టివ్ చేయండి';

  @override
  String get admSuspendUser => 'ఖాతాను నిలిపివేయండి';

  @override
  String get admTabProducts => 'ఉత్పత్తులు';

  @override
  String get admTabCategories => 'వర్గాలు';

  @override
  String get admTabPlaces => 'క్లినిక్‌లు మరియు సేవలు';

  @override
  String get admTabSellers => 'విక్రేతలు';

  @override
  String get admTabPartners => 'భాగస్వామి దుకాణాలు';

  @override
  String get admTabBanners => 'బ్యానర్‌లు';

  @override
  String get admSearchProducts =>
      'ఉత్పత్తులు, బ్రాండ్‌లు లేదా విక్రేతలను వెతకండి';

  @override
  String get admFeatured => 'ప్రత్యేకం';

  @override
  String get admHidden => 'దాచినవి';

  @override
  String get admLowStock => 'తక్కువ స్టాక్';

  @override
  String get admPartnerLinks => 'భాగస్వామి లింక్‌లు';

  @override
  String admShowingOf(int shown, int total) {
    return '$totalలో $shown చూపిస్తున్నాం. తగ్గించడానికి వెతకండి.';
  }

  @override
  String admProductsCount(int count) {
    return '$count ఉత్పత్తులు';
  }

  @override
  String get admPartnerLink => 'భాగస్వామి లింక్';

  @override
  String admStock(int count) {
    return 'స్టాక్ $count';
  }

  @override
  String get admUnfeature => 'ప్రత్యేకం నుండి తీసివేయండి';

  @override
  String get admFeature => 'షాప్‌లో ప్రత్యేకంగా చూపండి';

  @override
  String get admShowInShop => 'షాప్‌లో చూపండి';

  @override
  String admCategoryNote(String food, String other) {
    return 'డిఫాల్ట్ మార్జిన్: ఆహారంపై $food%, మిగతా వాటిపై $other%. ఏ వర్గానికైనా వేరే మార్జిన్ పెట్టవచ్చు.';
  }

  @override
  String admMarginCustom(String pct) {
    return 'మార్జిన్ $pct% (సొంత రేటు)';
  }

  @override
  String admMarginDefault(String pct) {
    return 'మార్జిన్ $pct% (డిఫాల్ట్)';
  }

  @override
  String admMarginFor(String name) {
    return '$name మార్జిన్';
  }

  @override
  String get admEmptyDefault => 'డిఫాల్ట్ కోసం ఖాళీగా వదలండి';

  @override
  String get admSellerNote =>
      'విక్రేతలను \'ఆమోదాలు\'లో ఆమోదిస్తారు. ఇక్కడ విక్రేతకు సొంత మార్జిన్ ఇవ్వవచ్చు.';

  @override
  String get admMarginStandard => 'సాధారణ మార్జిన్';

  @override
  String get admEditMargin => 'రేటు మార్చండి';

  @override
  String get admPartnersNote =>
      'అఫిలియేట్ భాగస్వామి దుకాణాలు: ప్రజలు భాగస్వామి వెబ్‌సైట్‌లో కొంటారు, PawSetuకి కమిషన్ వస్తుంది.';

  @override
  String admPartnerLine(String pct, int clicks) {
    return 'కమిషన్ $pct% · $clicks క్లిక్‌లు';
  }

  @override
  String get admAddPartner => 'భాగస్వామి దుకాణం జోడించండి';

  @override
  String get admPartnerName => 'దుకాణం పేరు';

  @override
  String get admPartnerUrl => 'వెబ్‌సైట్ (https://…)';

  @override
  String get admPartnerCommission => 'కమిషన్';

  @override
  String get admBannersNote =>
      'బ్యానర్‌లు హోమ్ లేదా షాప్‌లో కనిపిస్తాయి. ఆన్‌లో ఉన్నవే కనిపిస్తాయి.';

  @override
  String get admPlaceShop => 'షాప్';

  @override
  String get admPlaceHome => 'హోమ్';

  @override
  String get admBannerShown => 'ఈ బ్యానర్ చూపండి';

  @override
  String get admNewBanner => 'కొత్త బ్యానర్';

  @override
  String get admEditBanner => 'బ్యానర్ మార్చండి';

  @override
  String get admBannerTitle => 'శీర్షిక';

  @override
  String get admBannerBody => 'చిన్న సందేశం';

  @override
  String get admBannerLink => 'తెరుచుకుంటుంది (యాప్ పేజీ)';

  @override
  String get admBannerLinkHelp =>
      'ఉదా: /me/plus లేదా /shop/search?q=food. లింక్ వద్దంటే ఖాళీగా వదలండి.';

  @override
  String get admToneOffer => 'ఆఫర్ (నారింజ)';

  @override
  String get admToneNews => 'వార్త (ఆకుపచ్చ)';

  @override
  String get admPlacesNote =>
      'ప్రతి క్లినిక్ లేదా సేవ అందించేవారి బుకింగ్ కమిషన్. ఖాళీగా ఉంటే \'ప్లాన్‌లు మరియు సెట్టింగ్‌లు\'లో వాటి రకం రేటు వర్తిస్తుంది.';

  @override
  String admRateCustom(String pct) {
    return 'కమిషన్ $pct% (సొంత రేటు)';
  }

  @override
  String admRateStandard(String pct) {
    return 'కమిషన్ $pct% (సాధారణ)';
  }

  @override
  String admRateFor(String name) {
    return '$name కమిషన్';
  }

  @override
  String get hpStatusOpen => 'తెరిచి ఉంది';

  @override
  String get hpStatusInProgress => 'పని జరుగుతోంది';

  @override
  String get hpStatusResolved => 'పరిష్కారమైంది';

  @override
  String get admNeedsReply => 'జవాబు ఇవ్వాలి';

  @override
  String get admNotResolved => 'పరిష్కారం కానివి';

  @override
  String get admEveryone => 'అందరూ';

  @override
  String get admNoTickets => 'ఇక్కడ టికెట్‌లు లేవు';

  @override
  String get hpSupportTeam => 'PawSetu సహాయం';

  @override
  String get hpNewReply => 'కొత్త జవాబు';

  @override
  String hpRefunded(String amount) {
    return '$amount తిరిగి ఇచ్చారు';
  }

  @override
  String get admTicketTitle => 'టికెట్';

  @override
  String get admTicketMissing => 'ఈ టికెట్ అందుబాటులో లేదు';

  @override
  String get admAssignee => 'ఎవరికి అప్పగించారు';

  @override
  String get admUnassigned => 'ఎవరికీ అప్పగించలేదు';

  @override
  String get admConversation => 'సంభాషణ';

  @override
  String admReplyHint(String name) {
    return '$nameకి జవాబు ఇవ్వండి';
  }

  @override
  String admReplySent(String name) {
    return 'జవాబు పంపాం. $nameకి నోటిఫికేషన్ వస్తుంది.';
  }

  @override
  String get admResolveAfter => 'పంపిన తర్వాత పరిష్కారమైందిగా గుర్తించండి';

  @override
  String admLinkMissing(String type) {
    return 'జత చేసిన అంశం దొరకలేదు ($type).';
  }

  @override
  String admOrderLine(int count, String seller) {
    return '$seller నుండి $count వస్తువులు';
  }

  @override
  String admPaid(String amount) {
    return '$amount చెల్లించారు';
  }

  @override
  String admRefundDone(String amount, String date) {
    return '$dateన $amount తిరిగి ఇచ్చారు (డెమో)';
  }

  @override
  String get admRefundButton => 'డబ్బు తిరిగి ఇవ్వండి (డెమో)';

  @override
  String get admRefundAmount => 'తిరిగి ఇచ్చే మొత్తం';

  @override
  String admRefundMax(String amount) {
    return '$amount వరకు, చెల్లించినంత';
  }

  @override
  String admRefundConfirm(String amount, String name) {
    return '$nameకి $amount తిరిగి ఇవ్వాలా?';
  }

  @override
  String get admRefundDemoTitle => 'డెమో రిఫండ్';

  @override
  String admRefundDemoBody(String amount, String name) {
    return '$amount తిరిగి ఇచ్చామని $nameకి తెలియజేశాం. ఇది డెమో: నిజమైన డబ్బు కదలలేదు.';
  }

  @override
  String hpRaisedOn(String date) {
    return '$dateన నమోదు';
  }

  @override
  String admAssignedTo(String name) {
    return '$nameకి అప్పగించారు';
  }

  @override
  String get hpWriteReply => 'జవాబు రాయండి';

  @override
  String get hpTopicRefund => 'డబ్బు వాపసు';

  @override
  String get hpTopicLate => 'ఆలస్యం లేదా రాలేదు';

  @override
  String get hpTopicQuality => 'నాణ్యత సమస్య';

  @override
  String get hpTopicBehaviour => 'అమర్యాద లేదా ప్రమాదకర ప్రవర్తన';

  @override
  String get hpTopicApp => 'యాప్ సమస్య';

  @override
  String get hpTopicOther => 'ఇంకేదైనా';

  @override
  String get hpLinkBooking => 'బుకింగ్';

  @override
  String get hpLinkOrder => 'ఆర్డర్';

  @override
  String get hpLinkChat => 'చాట్';

  @override
  String get hpLinkOther => 'సాధారణం';

  @override
  String admReportsOpen(int count) {
    return 'తెరిచినవి ($count)';
  }

  @override
  String get admReportsClosed => 'మూసినవి';

  @override
  String get admNoReports => 'పరిశీలించడానికి రిపోర్ట్‌లు లేవు';

  @override
  String get admReviewHidden => 'రివ్యూ దాచారు';

  @override
  String get admReviewRestored => 'రివ్యూ మళ్లీ కనిపిస్తుంది';

  @override
  String get admReportHandled => 'పరిష్కరించినట్లు గుర్తించారు';

  @override
  String get admReportDismissed => 'రిపోర్ట్ కొట్టివేశారు';

  @override
  String get admReportReview => 'రిపోర్ట్ చేసిన రివ్యూ';

  @override
  String get admReportChat => 'రిపోర్ట్ చేసిన చాట్';

  @override
  String get admReportContent => 'రిపోర్ట్ చేసిన కంటెంట్';

  @override
  String admReporterSays(String text) {
    return 'రిపోర్ట్ చేసినవారు చెప్పింది: $text';
  }

  @override
  String admReportedBy(String name) {
    return '$name రిపోర్ట్ చేశారు';
  }

  @override
  String admClosedOn(String date) {
    return '$dateన ముగిసింది';
  }

  @override
  String get admHideReview => 'రివ్యూ దాచండి';

  @override
  String get admMarkHandled => 'పరిష్కరించినట్లు గుర్తించండి';

  @override
  String get admDismiss => 'కొట్టివేయండి';

  @override
  String get admRestoreReview => 'రివ్యూ మళ్లీ చూపండి';

  @override
  String get admSearchOutbox => 'ఫోన్, ఈమెయిల్ లేదా సందేశంతో వెతకండి';

  @override
  String admAllCount(int count) {
    return 'అన్నీ ($count)';
  }

  @override
  String get admChannelSms => 'SMS';

  @override
  String get admChannelWhatsapp => 'WhatsApp';

  @override
  String get admChannelEmail => 'ఈమెయిల్';

  @override
  String get admChannelPush => 'పుష్';

  @override
  String get admAuditNote =>
      'అడ్మిన్ ప్యానెల్‌లో చేసిన ప్రతి మార్పు, కొత్తది ముందు.';

  @override
  String get admSearchAudit => 'వ్యక్తి, చర్య లేదా అంశంతో వెతకండి';

  @override
  String get admActApprove => 'భాగస్వామిని ఆమోదించారు';

  @override
  String get admActReject => 'భాగస్వామిని తిరస్కరించారు';

  @override
  String get admActSuspendPartner => 'భాగస్వామిని నిలిపివేశారు';

  @override
  String get admActSuspendUser => 'ఖాతాను నిలిపివేశారు';

  @override
  String get admActUnsuspendUser => 'ఖాతాను మళ్లీ యాక్టివ్ చేశారు';

  @override
  String get admActRole => 'పాత్ర మార్చారు';

  @override
  String get admActTicketReply => 'టికెట్‌కి జవాబు ఇచ్చారు';

  @override
  String get admActTicketStatus => 'టికెట్ స్థితి మార్చారు';

  @override
  String get admActTicketAssign => 'టికెట్ అప్పగించారు';

  @override
  String get admActRefund => 'డెమో రిఫండ్ ఇచ్చారు';

  @override
  String get admActHide => 'రివ్యూ దాచారు';

  @override
  String get admActRestore => 'రివ్యూ మళ్లీ చూపించారు';

  @override
  String get admActDismiss => 'రిపోర్ట్ కొట్టివేశారు';

  @override
  String get admActHandled => 'రిపోర్ట్ పరిష్కరించారు';

  @override
  String get admActCouponNew => 'కూపన్ సృష్టించారు';

  @override
  String get admActCouponEdit => 'కూపన్ మార్చారు';

  @override
  String get admActProduct => 'ఉత్పత్తి మార్చారు';

  @override
  String get admActBannerNew => 'బ్యానర్ సృష్టించారు';

  @override
  String get admActBannerEdit => 'బ్యానర్ మార్చారు';

  @override
  String get admActSeller => 'విక్రేతను మార్చారు';

  @override
  String get admActPartnerStore => 'భాగస్వామి దుకాణం మార్చారు';

  @override
  String get admActPlace => 'క్లినిక్ లేదా సేవ అందించేవారిని మార్చారు';

  @override
  String get admActSettings => 'సెట్టింగ్‌లు మార్చారు';

  @override
  String get admSettingsNote =>
      'మార్పులు వెంటనే యాప్‌కి చేరతాయి, అప్‌డేట్ అవసరం లేదు.';

  @override
  String admLastChanged(String when) {
    return 'చివరి మార్పు $when.';
  }

  @override
  String get admPlanPrices => 'ప్లాన్ ధరలు';

  @override
  String get admPlusMonthly => 'Plus, నెలకు';

  @override
  String get admPlusYearly => 'Plus, సంవత్సరానికి';

  @override
  String get admTrialDays => 'ఉచిత ట్రయల్';

  @override
  String get admDaysUnit => 'రోజులు';

  @override
  String get admPlanLimits => 'ప్లాన్ పరిమితులు';

  @override
  String get admBookingCommission => 'బుకింగ్ కమిషన్';

  @override
  String get admDefaultRate => 'డిఫాల్ట్ రేటు';

  @override
  String get admRateClinic => 'వెట్ క్లినిక్‌లు';

  @override
  String get admRateGroomer => 'గ్రూమర్‌లు';

  @override
  String get admRateTrainer => 'ట్రైనర్‌లు';

  @override
  String get admRateBoarder => 'బోర్డింగ్ మరియు సిట్టింగ్';

  @override
  String get admRateWalker => 'డాగ్ వాకర్‌లు';

  @override
  String get admProviderRateNote =>
      'క్లినిక్ లేదా సేవ అందించేవారికి సొంత రేటు కూడా ఉండవచ్చు: కేటలాగ్ → క్లినిక్‌లు మరియు సేవలు.';

  @override
  String get admShopMoney => 'షాప్ మార్జిన్‌లు మరియు డెలివరీ';

  @override
  String get admFoodMargin => 'ఆహారంపై మార్జిన్';

  @override
  String get admOtherMargin => 'ఇతర వస్తువులపై మార్జిన్';

  @override
  String get admVideoDiscount => 'వీడియో వెట్ ఫీజుపై Plus తగ్గింపు';

  @override
  String get admDeliveryFee => 'డెలివరీ ఛార్జీ';

  @override
  String get admFreeDeliveryFree => 'దీనికి పైన ఉచిత డెలివరీ (Free ప్లాన్)';

  @override
  String get admFreeDeliveryPlus => 'దీనికి పైన ఉచిత డెలివరీ (Plus)';

  @override
  String get admFeatureFlags => 'సదుపాయాల స్విచ్‌లు';

  @override
  String get admReferrals => 'రెఫరల్స్';

  @override
  String get admReferralReward => 'ప్రతి స్నేహితుడికి బహుమతి';

  @override
  String get admCoupons => 'కూపన్‌లు';

  @override
  String get admNewCoupon => 'కొత్త కూపన్';

  @override
  String get admVaccineSchedules => 'టీకాల షెడ్యూల్';

  @override
  String get admVaccineNote =>
      'సుమారు సమయాలు. వెట్ పరిశీలించాక సమయం మార్చండి; ప్రతి పెట్ షెడ్యూల్ మారుతుంది.';

  @override
  String get admContentReview => 'కంటెంట్ వెట్ పరిశీలన';

  @override
  String get admContentReviewNote =>
      'వెట్ పరిశీలించే వరకు ఈ కంటెంట్‌పై \"డ్రాఫ్ట్, వెట్ పరిశీలించాల్సి ఉంది\" అని కనిపిస్తుంది.';

  @override
  String get admUsesDefault => 'డిఫాల్ట్';

  @override
  String get admSavedLive =>
      'సేవ్ అయింది. యాప్ ఇప్పుడు కొత్త విలువను వాడుతుంది.';

  @override
  String get admLimit => 'పరిమితి';

  @override
  String get admLimitPets => 'పెట్స్';

  @override
  String get admLimitFamily => 'కుటుంబ సభ్యులు';

  @override
  String get admLimitTeleVet => 'నెలకు టెలీ-వెట్ చాట్‌లు';

  @override
  String get admLimitMessages => 'ప్రతి టెలీ-వెట్ చాట్‌లో సందేశాలు';

  @override
  String get admLimitWords => 'ప్రతి సందేశంలో పదాలు';

  @override
  String get admLimitHours => 'టెలీ-వెట్ చాట్ ఎంతసేపు తెరిచి ఉంటుంది';

  @override
  String get admLimitAi => 'నెలకు Ask PawSetu ప్రశ్నలు';

  @override
  String get admLimitStorage => 'స్టోరేజ్';

  @override
  String get admLimitVideo => 'వీడియో నిడివి';

  @override
  String get admHoursUnit => 'గంటలు';

  @override
  String get admSecondsUnit => 'సెకన్లు';

  @override
  String get admUnlimited => 'అపరిమితం';

  @override
  String get admUnlimitedNote => '999 లేదా అంతకంటే ఎక్కువ అంటే అపరిమితం.';

  @override
  String get admFlagAi => 'Ask PawSetu';

  @override
  String get admFlagAiHint => 'AI పెట్ సహాయకుడు';

  @override
  String get admFlagDevices => 'కనెక్ట్ చేసిన పరికరాలు';

  @override
  String get admFlagDevicesHint =>
      'కాలర్‌లు, ఫీడర్‌లు మరియు ఇతర స్మార్ట్ పరికరాలు';

  @override
  String get admFlagLost => 'దగ్గర్లో తప్పిపోయిన పెట్ హెచ్చరికలు';

  @override
  String get admFlagLostHint => '5 కి.మీ. లోపు యూజర్లకు హెచ్చరికలు';

  @override
  String get admFlagReferrals => 'స్నేహితుడిని ఆహ్వానించండి';

  @override
  String get admFlagReferralsHint => 'రెఫరల్ కోడ్‌లు మరియు బహుమతులు';

  @override
  String admCouponPercent(int pct, String max) {
    return '$max వరకు $pct% తగ్గింపు';
  }

  @override
  String admCouponFlat(String amount) {
    return '$amount తగ్గింపు';
  }

  @override
  String admCouponMin(String amount) {
    return 'కనీస ఆర్డర్ $amount';
  }

  @override
  String admCouponTill(String date) {
    return '$date వరకు';
  }

  @override
  String admCouponUses(int used, int max) {
    return '$maxలో $used సార్లు వాడారు';
  }

  @override
  String get admCouponActive => 'కూపన్ ఆన్';

  @override
  String admPersonalCoupons(int count) {
    return '$count వ్యక్తిగత రెఫరల్ కూపన్‌లు ఇక్కడ చూపలేదు.';
  }

  @override
  String get admCouponCodeHelp =>
      '4 నుండి 16 అక్షరాలు లేదా అంకెలు, ఉదా: DIWALI20';

  @override
  String get admCouponDescription => 'ప్రజలకు కనిపించే వివరణ';

  @override
  String get admCouponTypePercent => 'శాతం తగ్గింపు';

  @override
  String get admCouponTypeFlat => 'మొత్తం తగ్గింపు';

  @override
  String get admCouponPercentOff => 'శాతం తగ్గింపు';

  @override
  String get admCouponAmountOff => 'తగ్గింపు మొత్తం';

  @override
  String get admCouponMaxDiscount => 'గరిష్ఠ తగ్గింపు';

  @override
  String get admCouponMinOrder => 'కనీస ఆర్డర్';

  @override
  String get admCouponMaxUses => 'ఎన్నిసార్లు వాడవచ్చు';

  @override
  String get admCouponValidTill => 'ఎప్పటి వరకు చెల్లుతుంది';

  @override
  String get admDogSchedule => 'కుక్కలు';

  @override
  String get admCatSchedule => 'పిల్లులు';

  @override
  String get admAskVetTiming => 'ఐచ్ఛికం, సమయం వెట్ సలహా ప్రకారం';

  @override
  String admEveryYears(int count) {
    return 'ప్రతి $count సంవత్సరాలకు';
  }

  @override
  String admWeeksRange(int from, int to) {
    return 'వయసు $from నుండి $to వారాలు';
  }

  @override
  String admBoosterEvery(String name) {
    return '$name బూస్టర్: ఎన్ని సంవత్సరాలకు?';
  }

  @override
  String get admYearsUnit => 'సంవత్సరాలు';

  @override
  String admFromWeek(String name) {
    return '$name: ఏ వారం వయసు నుండి?';
  }

  @override
  String admToWeek(String name) {
    return '$name: ఏ వారం వయసు వరకు?';
  }

  @override
  String get admWeeksUnit => 'వారాలు';

  @override
  String get admAreaFirstAid => 'ప్రథమ చికిత్స గైడ్‌లు';

  @override
  String get admAreaToxic => 'విషపూరిత ఆహారం మరియు మొక్కల తనిఖీ';

  @override
  String get admAreaVaccines => 'టీకాల షెడ్యూల్';

  @override
  String get admDraft => 'డ్రాఫ్ట్';

  @override
  String get admReviewed => 'పరిశీలించారు';

  @override
  String get admReviewSheetNote =>
      'ఈ కంటెంట్‌ను తనిఖీ చేసిన వెట్ పేరు మరియు రిజిస్ట్రేషన్ నంబర్ రాయండి.';

  @override
  String get admReviewerName => 'వెట్ పేరు మరియు రిజిస్ట్రేషన్ నంబర్';

  @override
  String get admMarkReviewed => 'పరిశీలించినట్లు గుర్తించండి';

  @override
  String get admBackToDraft => 'మళ్లీ డ్రాఫ్ట్ చేయండి';

  @override
  String get admKindShop => 'షాప్';

  @override
  String get admKindBooking => 'బుకింగ్‌లు';

  @override
  String get admDownloadCsv => 'CSV డౌన్‌లోడ్ చేయండి';

  @override
  String get admColPartner => 'భాగస్వామి';

  @override
  String get admColType => 'రకం';

  @override
  String get admColCount => 'సంఖ్య';

  @override
  String get admColGross => 'మొత్తం';

  @override
  String get admColCommission => 'కమిషన్';

  @override
  String get admColPayout => 'చెల్లింపు';

  @override
  String get admBookingCommissionShort => 'బుకింగ్ కమిషన్';

  @override
  String get admShopMargin => 'షాప్ మార్జిన్';

  @override
  String get admPlusRevenue => 'Plus చెల్లింపులు';

  @override
  String get admRefunds => 'రిఫండ్‌లు';

  @override
  String get admPlatformTotal => 'PawSetu సంపాదన';

  @override
  String get admReportDemoNote =>
      'డెమో డబ్బు: వెర్షన్ 1లో అన్ని చెల్లింపులు అనుకరణ మాత్రమే. పన్ను ఫీల్డ్‌లు తాత్కాలికం.';

  @override
  String get admByPartner => 'భాగస్వామి వారీగా';

  @override
  String admLineCount(int count) {
    return '$count అమ్మకాలు';
  }

  @override
  String admNoteApproved(String name) {
    return '$name ఆమోదం పొందింది, ఇప్పుడు పెట్ పేరెంట్స్‌కి కనిపిస్తుంది';
  }

  @override
  String admNoteRejected(String name) {
    return '$nameకి ఆమోదం రాలేదు';
  }

  @override
  String admNoteSuspended(String name) {
    return '$name నిలిపివేయబడింది';
  }

  @override
  String hpReplyTitle(String subject) {
    return 'సహాయ బృందం జవాబు: $subject';
  }

  @override
  String hpResolvedTitle(String subject) {
    return 'పరిష్కారమైంది: $subject';
  }

  @override
  String hpRefundTitle(int amount) {
    return '₹$amount రిఫండ్ వస్తోంది';
  }

  @override
  String get hpRefundBody => 'డెమో రిఫండ్: నిజమైన డబ్బు కదలలేదు.';

  @override
  String hpNewForSupport(String name) {
    return '$name నుండి కొత్త సందేశం';
  }

  @override
  String get hpIntroTitle => 'సహాయానికి మేమున్నాం';

  @override
  String get hpIntroBody =>
      'బుకింగ్, ఆర్డర్ లేదా చాట్ గురించి ఫిర్యాదు లేదా ప్రశ్న పంపండి. సాధారణంగా ఒక రోజులో జవాబిస్తాం.';

  @override
  String get hpIntroPlus =>
      'Plus సభ్యులకు ముందుగా సహాయం: సాధారణంగా 4 గంటల్లో జవాబిస్తాం.';

  @override
  String get hpRaise => 'ఫిర్యాదు నమోదు చేయండి';

  @override
  String get hpYourTickets => 'మీ టికెట్‌లు';

  @override
  String get hpNoTickets =>
      'ఇంకా టికెట్‌లు లేవు. ఏదైనా తప్పు జరిగితే ఇక్కడ చెప్పండి.';

  @override
  String get hpQuickAnswers => 'త్వరిత జవాబులు';

  @override
  String get hpFaqRefundQ => 'డబ్బు వాపసు ఎలా జరుగుతుంది?';

  @override
  String get hpFaqRefundA =>
      'ఆన్‌లైన్‌లో చెల్లించి సమయానికి రద్దు చేస్తే, డబ్బు 5 నుండి 7 పని దినాల్లో అదే పద్ధతికి తిరిగి వస్తుంది. ఇతర సమస్యలకు ఫిర్యాదు నమోదు చేయండి, మేము చూస్తాం.';

  @override
  String get hpFaqCancelQ => 'బుకింగ్‌ని ఎలా రద్దు చేయాలి?';

  @override
  String get hpFaqCancelA =>
      'బుక్ తెరిచి, నా బుకింగ్‌లు చూడండి. బుకింగ్ ఎంచుకుని బుకింగ్ రద్దు చేయండి నొక్కండి. క్లినిక్ రద్దు సమయం అక్కడే కనిపిస్తుంది.';

  @override
  String get hpFaqUrgentQ => 'నా పెట్‌కి ఇప్పుడే సహాయం కావాలి';

  @override
  String get hpFaqUrgentA =>
      'హోమ్‌లో ఎరుపు SOS బటన్ వాడండి: దగ్గర్లోని క్లినిక్‌ని చేరడానికి 2 సెకన్లు నొక్కి ఉంచండి. ఇక్కడ జవాబు కోసం వేచి ఉండకండి.';

  @override
  String get hpFaqDataQ => 'నా డేటాను ఎలా పొందాలి లేదా తొలగించాలి?';

  @override
  String get hpFaqDataA =>
      'నేను, తర్వాత ప్రైవసీ సెంటర్‌కి వెళ్లి మీ డేటా డౌన్‌లోడ్ చేయండి లేదా ఖాతా తొలగించండి.';

  @override
  String get hpAbout => 'ఇది దేని గురించి?';

  @override
  String get hpPickItem => 'బుకింగ్ లేదా ఆర్డర్ ఎంచుకోండి';

  @override
  String get hpSomethingElse => 'ఇంకేదైనా';

  @override
  String get hpTopic => 'విషయం';

  @override
  String get hpSubject => 'విషయ శీర్షిక (ఐచ్ఛికం)';

  @override
  String get hpDetails => 'ఏం జరిగింది?';

  @override
  String get hpDetailsHelp =>
      'కనీసం 10 అక్షరాలు. వీలైతే తేదీలు, పేర్లు, మొత్తాలు రాయండి.';

  @override
  String get hpSend => 'సహాయ బృందానికి పంపండి';

  @override
  String get hpSent => 'PawSetu సహాయానికి పంపాం';

  @override
  String get hpReplyTime => 'సాధారణంగా ఒక రోజులో జవాబిస్తాం.';

  @override
  String get hpReplyTimePlus =>
      'Plus ప్రాధాన్య సహాయం: సాధారణంగా 4 గంటల్లో జవాబిస్తాం.';

  @override
  String get hpTicketTitle => 'మీ టికెట్';

  @override
  String get hpResolvedNote =>
      'పరిష్కారమైందిగా గుర్తించారు. ఇంకా సహాయం కావాలంటే కింద జవాబు ఇవ్వండి.';

  @override
  String get hpReopenHint => 'ఇంకా సహాయం కావాలా? మళ్లీ తెరవడానికి ఇక్కడ రాయండి';

  @override
  String get hpGetHelpBooking => 'ఈ బుకింగ్‌కి సహాయం పొందండి';

  @override
  String get plusTrialStartedTitle => 'మీ ఉచిత ట్రయల్ మొదలైంది';

  @override
  String plusTrialStartedBody(int days, String date) {
    return '$date వరకు $days రోజులు మీకు Plus సదుపాయాలన్నీ ఉంటాయి. డెమో: ఏమీ వసూలు చేయం.';
  }

  @override
  String get plusTrialUsed => 'మీరు ఇప్పటికే ఉచిత ట్రయల్ వాడారు.';

  @override
  String get plusPayYearly => 'PawSetu Plus, 1 సంవత్సరం';

  @override
  String get plusPayMonthly => 'PawSetu Plus, 1 నెల';

  @override
  String get plusWelcomeTitle => 'PawSetu Plusకి స్వాగతం!';

  @override
  String plusWelcomeBody(String date) {
    return 'Plus ఆన్ అయింది. ఇది $dateన రెన్యూ అవుతుంది. ఇది డెమో చెల్లింపు: డబ్బు కదలలేదు.';
  }

  @override
  String get plusKeepAfterTrial => 'ట్రయల్ తర్వాత కూడా Plus ఉంచుకోండి';

  @override
  String get plusChoosePlan => 'మీ ప్లాన్ ఎంచుకోండి';

  @override
  String plusBuy(String amount) {
    return '$amountకి Plus పొందండి';
  }

  @override
  String plusStartsAfterTrial(String date) {
    return 'మీ చెల్లింపు ప్లాన్ ట్రయల్ ముగిసే $dateన మొదలవుతుంది.';
  }

  @override
  String plusStartTrial(int days) {
    return '$days రోజుల ఉచిత ట్రయల్ ప్రారంభించండి';
  }

  @override
  String plusTrialNote(int days) {
    return '$days రోజులు ఉచితం. డెమోలో కార్డు అవసరం లేదు.';
  }

  @override
  String get plusAutoRenew => 'ఆటోమేటిక్‌గా రెన్యూ చేయండి';

  @override
  String plusAutoRenewOn(String date) {
    return '$dateన రెన్యూ అవుతుంది';
  }

  @override
  String plusAutoRenewOff(String date) {
    return 'Plus $date వరకు ఉంటుంది, తర్వాత మీరు Freeకి మారతారు';
  }

  @override
  String get plusDemoNote => 'డెమో: డబ్బు వసూలు చేయం, నిజంగా ఏదీ రెన్యూ కాదు.';

  @override
  String plusOnTrial(int days) {
    return 'Plus ట్రయల్: $days రోజులు మిగిలాయి';
  }

  @override
  String plusTrialEnds(String date) {
    return 'మీ ట్రయల్ $dateన ముగుస్తుంది.';
  }

  @override
  String get plusYouHavePlus => 'మీకు PawSetu Plus ఉంది';

  @override
  String plusRenewsOn(String date) {
    return '$dateన రెన్యూ అవుతుంది';
  }

  @override
  String plusEndsOn(String date) {
    return '$dateన ముగుస్తుంది';
  }

  @override
  String get plusYouAreFree => 'మీరు Free ప్లాన్‌లో ఉన్నారు';

  @override
  String get plusFreeBody =>
      'వీడియో వెట్ కాల్స్, అపరిమిత పెట్స్ మరియు మరిన్నింటి కోసం అప్‌గ్రేడ్ చేయండి.';

  @override
  String plusMinutes(int count) {
    return '$count నిమి';
  }

  @override
  String plusSeconds(int count) {
    return '$count సె';
  }

  @override
  String get plusRowPets => 'పెట్స్';

  @override
  String get plusRowFamily => 'కుటుంబ సభ్యులు';

  @override
  String get plusRowVideo => 'వీడియో వెట్ కాల్స్';

  @override
  String get plusRowTeleVet => 'టెలీ-వెట్ చాట్‌లు';

  @override
  String get plusRowMessages => 'చాట్ నిడివి';

  @override
  String get plusRowAi => 'Ask PawSetu';

  @override
  String get plusRowStorage => 'ఫోటో మరియు పత్రాల స్టోరేజ్';

  @override
  String get plusRowVideoLength => 'ఆల్బమ్‌లో వీడియో నిడివి';

  @override
  String get plusRowVideoDiscount => 'వీడియో వెట్ ఫీజుపై తగ్గింపు';

  @override
  String get plusRowDelivery => 'ఉచిత డెలివరీ';

  @override
  String get plusRowSupport => 'సహాయం';

  @override
  String get plusYes => 'అవును';

  @override
  String plusPerMonth(String value) {
    return 'నెలకు $value';
  }

  @override
  String plusMessagesWords(String messages, String words) {
    return '$messages సందేశాలు, ఒక్కోదానిలో $words పదాలు';
  }

  @override
  String plusAbove(String amount) {
    return '$amount పైన';
  }

  @override
  String get plusStandard => 'సాధారణ';

  @override
  String get plusPriority => 'ప్రాధాన్యం';

  @override
  String get plusYearly => 'సంవత్సరానికి';

  @override
  String get plusMonthly => 'నెలవారీ';

  @override
  String get plusPerYear => 'సంవత్సరానికి';

  @override
  String get plusPerMonthPrice => 'నెలకు';

  @override
  String plusSave(int pct) {
    return '$pct% ఆదా';
  }

  @override
  String plusTrialEndingSoon(int days) {
    return 'మీ Plus ట్రయల్ $days రోజుల్లో ముగుస్తుంది. Plus ఉంచుకోవడానికి ప్లాన్ ఎంచుకోండి.';
  }

  @override
  String get referTitle => 'స్నేహితుడిని ఆహ్వానించండి';

  @override
  String get referInvalid =>
      'ఈ కోడ్ సరైనది కాదు, లేదా మీరు ఇప్పటికే కోడ్ వాడారు.';

  @override
  String get referDoneTitle => 'కోడ్ వర్తించింది!';

  @override
  String referDoneBody(String amount, String code) {
    return 'మీకు మరియు మీ స్నేహితుడికి చెరొక $amount తగ్గింపు. మీ కూపన్: $code. షాప్‌లో చెల్లించేటప్పుడు వాడండి.';
  }

  @override
  String get referPaused => 'స్నేహితుడిని ఆహ్వానించడం ప్రస్తుతం ఆపివేశారు.';

  @override
  String referHeadline(String amount) {
    return '$amount ఇవ్వండి, $amount పొందండి';
  }

  @override
  String referBody(String amount) {
    return 'మీ కోడ్‌తో స్నేహితుడు PawSetuలో చేరితే, ఇద్దరికీ $amount షాప్ కూపన్ వస్తుంది.';
  }

  @override
  String get referYourCode => 'మీ కోడ్';

  @override
  String referShareText(String code, String amount) {
    return 'పెట్ పేరెంట్స్ యాప్ PawSetuలో నాతో చేరండి! నా కోడ్ $code వాడండి, మన ఇద్దరికీ PawSetu షాప్‌లో $amount తగ్గింపు వస్తుంది.';
  }

  @override
  String referFriendsJoined(int count) {
    return 'మీ కోడ్‌తో $count మంది స్నేహితులు చేరారు';
  }

  @override
  String get referHaveCode => 'స్నేహితుడి కోడ్ ఉందా?';

  @override
  String get referEnterCode => 'స్నేహితుడి కోడ్';

  @override
  String get referApply => 'కోడ్ వర్తింపజేయండి';

  @override
  String get referYourRewards => 'మీ బహుమతి కూపన్‌లు';

  @override
  String referCouponLine(String amount, String min, String date) {
    return '$min పైన ఆర్డర్‌లపై $amount తగ్గింపు, $date వరకు';
  }

  @override
  String get referUsed => 'వాడేశారు';

  @override
  String get referDemoNote =>
      'డెమో: కూపన్‌లు డెమో షాప్‌లో పనిచేస్తాయి. నిజమైన డబ్బు కాదు.';

  @override
  String prvExportReady(int parts, int kb) {
    return 'మీ ఫైల్ సిద్ధం: $parts విభాగాలు, $kb KB.';
  }

  @override
  String get prvExportSubject => 'నా PawSetu డేటా';

  @override
  String get prvDeleteConfirmTitle => 'మీ ఖాతాను తొలగించాలా?';

  @override
  String prvDeleteConfirmBody(String date, int days) {
    return 'మీ ఖాతా, పెట్స్ మరియు రికార్డులు $dateన తొలగించబడతాయి. మనసు మారితే $days రోజుల్లో సైన్ ఇన్ చేసి రద్దు చేయండి.';
  }

  @override
  String get prvDeleteButton => 'నా ఖాతాను తొలగించండి';

  @override
  String get prvDeleteRequestedTitle => 'తొలగింపు షెడ్యూల్ అయింది';

  @override
  String prvDeleteRequestedBody(String date) {
    return 'మీ ఖాతా $dateన తొలగించబడుతుంది. డెమో: నిజంగా ఏదీ తొలగించం.';
  }

  @override
  String get prvConsentLost => 'నా దగ్గర తప్పిపోయిన పెట్ హెచ్చరికలు';

  @override
  String get prvConsentLostHint =>
      '5 కి.మీ. లోపు పెట్ తప్పిపోతే హెచ్చరిక పొందండి';

  @override
  String get prvConsentAnalytics => 'PawSetuని మెరుగుపరచడంలో సహాయపడండి';

  @override
  String get prvConsentAnalyticsHint =>
      'పేరు లేని యాప్ వినియోగం పంచుకోండి (పేర్లు, ఫోటోలు కాదు)';

  @override
  String get prvConsentMarketing => 'ఆఫర్లు మరియు వార్తలు';

  @override
  String get prvConsentMarketingHint =>
      'అప్పుడప్పుడు SMS, WhatsApp లేదా ఈమెయిల్ ద్వారా ఆఫర్లు';

  @override
  String get prvConsentPartners =>
      'నేను బుక్ చేసే క్లినిక్‌లతో ఆరోగ్య సారాంశం పంచుకోండి';

  @override
  String get prvConsentPartnersHint =>
      'మీరు వచ్చే ముందు వెట్ సిద్ధం కావడానికి సహాయపడుతుంది';

  @override
  String prvDeletionPending(String date) {
    return 'మీ ఖాతా $dateన తొలగించబడుతుంది. ఉంచుకోవడానికి నొక్కండి.';
  }

  @override
  String get prvCancelDeletion => 'నా ఖాతాను ఉంచండి';

  @override
  String get prvDeletionCancelled => 'తొలగింపు రద్దు. మీ ఖాతా ఉంటుంది.';

  @override
  String get prvIntro =>
      'మీ డేటా మీ చేతిలో ఉంది. ఏం పంచుకోవాలో ఎంచుకోండి, అన్నింటి కాపీ డౌన్‌లోడ్ చేయండి, లేదా ఖాతా తొలగించండి.';

  @override
  String get prvConsents => 'మీరు ఏం పంచుకుంటారు';

  @override
  String get prvDownloadTitle => 'నా డేటా డౌన్‌లోడ్ చేయండి';

  @override
  String get prvDownloadBody =>
      'మీ ప్రొఫైల్, పెట్స్, ఆరోగ్య రికార్డులు, బుకింగ్‌లు, ఆర్డర్‌లు, చాట్‌లు మరియు మరిన్నింటితో ఫైల్ పొందండి.';

  @override
  String get prvDownloadButton => 'నా డేటా డౌన్‌లోడ్ చేయండి';

  @override
  String get prvDeleteTitle => 'నా ఖాతాను తొలగించండి';

  @override
  String prvDeleteBody(int days) {
    return 'మీరు అడిగిన $days రోజుల తర్వాత ఖాతా తొలగించబడుతుంది. అప్పటివరకు సైన్ ఇన్ చేసి రద్దు చేయవచ్చు.';
  }

  @override
  String get prvDemoNote =>
      'డెమో: ఫైల్ మీ పరికరంలోనే తయారవుతుంది. నిజమైన యాప్‌లో డౌన్‌లోడ్ లింక్ ఈమెయిల్ కూడా చేస్తాం.';

  @override
  String get suspTitle => 'మీ ఖాతా నిలిపివేయబడింది';

  @override
  String get suspBody =>
      'మా బృందం ఈ ఖాతాను నిలిపివేసింది. ఇది పొరపాటు అనిపిస్తే PawSetu సహాయాన్ని సంప్రదించండి.';

  @override
  String get suspContact => 'సహాయాన్ని సంప్రదించండి';

  @override
  String get suspContactBody =>
      'డెమో: support@example.comకి రాయండి. నిజమైన యాప్‌లో ఇది మీ ఈమెయిల్ తెరుస్తుంది.';
}
