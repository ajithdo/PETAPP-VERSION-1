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
}
