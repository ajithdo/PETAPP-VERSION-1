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
}
