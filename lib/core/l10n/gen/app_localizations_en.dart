// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PawSetu';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get notNow => 'Not now';

  @override
  String get or => 'or';

  @override
  String get loading => 'Loading';

  @override
  String get tryAgain => 'Try again';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorBody =>
      'We couldn\'t load this. Check your internet and try again.';

  @override
  String get fieldRequired => 'Please fill this in';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String comingInPhase(int phase) {
    return 'This part of PawSetu arrives in Phase $phase. Everything else you see already works.';
  }

  @override
  String get notFoundTitle => 'We can\'t find that page';

  @override
  String get notFoundBody => 'The link may be old. Let\'s take you home.';

  @override
  String get goHome => 'Go to Home';

  @override
  String stepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get tabHome => 'Home';

  @override
  String get tabHealth => 'Health';

  @override
  String get tabBook => 'Book';

  @override
  String get tabShop => 'Shop';

  @override
  String get tabMe => 'Me';

  @override
  String get messages => 'Messages';

  @override
  String get notifications => 'Notifications';

  @override
  String get switchPet => 'Switch pet';

  @override
  String get allPets => 'All pets';

  @override
  String get addPet => 'Add pet';

  @override
  String get petProfile => 'Pet profile';

  @override
  String openPetProfile(String name) {
    return 'Open $name\'s profile';
  }

  @override
  String get petParent => 'Pet parent';

  @override
  String get sosTitle => 'Emergency help';

  @override
  String get sosSemantic => 'SOS emergency button';

  @override
  String get sosHoldHint => 'Hold for 2 seconds to activate';

  @override
  String get sosConfirmTitle => 'Need emergency help?';

  @override
  String get sosConfirmBody =>
      'We\'ll show the nearest open clinics so you can call or go there.';

  @override
  String get sosGetHelp => 'Get help now';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get noPetsTitle => 'Let\'s add your first pet';

  @override
  String get noPetsBody =>
      'Only a name and species are needed. You can add more later.';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get qaBookVet => 'Book vet';

  @override
  String get qaLogWalk => 'Log walk';

  @override
  String get qaAskVet => 'Ask a vet';

  @override
  String get qaAddPhoto => 'Add photo';

  @override
  String weightValue(String value) {
    return '$value';
  }

  @override
  String get speciesDog => 'Dog';

  @override
  String get speciesCat => 'Cat';

  @override
  String get speciesBird => 'Bird';

  @override
  String get speciesRabbit => 'Rabbit';

  @override
  String get species => 'Species';

  @override
  String get petName => 'Pet\'s name';

  @override
  String ageYears(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years yrs',
      one: '1 yr',
    );
    return '$_temp0';
  }

  @override
  String ageMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months mo',
      one: '1 mo',
    );
    return '$_temp0';
  }

  @override
  String ageYearsMonths(int years, int months) {
    return '$years yrs $months mo';
  }

  @override
  String get stagePuppy => 'Puppy';

  @override
  String get stageKitten => 'Kitten';

  @override
  String get stageYoung => 'Young';

  @override
  String get stageAdult => 'Adult';

  @override
  String get stageSenior => 'Senior';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderUnknown => 'Not sure';

  @override
  String get birdLegalNote =>
      'Native Indian birds such as the rose-ringed (Indian ringneck), Alexandrine and plum-headed parakeets, munias and mynas are protected wildlife under the Wild Life (Protection) Act, 1972 and can\'t legally be kept as pets, so they aren\'t listed.';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleCoowner => 'Co-owner';

  @override
  String get roleCarer => 'Carer';

  @override
  String get roleViewer => 'Viewer';

  @override
  String get rolePetParent => 'Pet parent';

  @override
  String get roleVet => 'Vet';

  @override
  String get roleClinicAdmin => 'Clinic admin';

  @override
  String get roleGroomer => 'Groomer';

  @override
  String get roleTrainer => 'Trainer';

  @override
  String get roleBoarder => 'Boarding and sitting';

  @override
  String get roleWalker => 'Dog walker';

  @override
  String get roleSeller => 'Seller';

  @override
  String get roleAdmin => 'Platform admin';

  @override
  String get welcome1Title => 'Every care your pet needs, in one place';

  @override
  String get welcome1Body =>
      'Track walks, meals and moods for every pet in your home.';

  @override
  String get welcome2Title => 'Never miss a vaccine or medicine';

  @override
  String get welcome2Body =>
      'Gentle reminders, health records and a report you can share with your vet.';

  @override
  String get welcome3Title => 'Vets, groomers and shops, all connected';

  @override
  String get welcome3Body =>
      'Book in a few taps, chat with a vet, and get help fast in an emergency.';

  @override
  String get getStarted => 'Get started';

  @override
  String get language => 'Language';

  @override
  String get signInTitle => 'Welcome to PawSetu';

  @override
  String get signInSubtitle => 'Sign in to look after your pets';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get passwordHelper => 'At least 6 characters';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out of PawSetu?';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithPhone => 'Continue with phone number';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get newHere => 'New to PawSetu?';

  @override
  String get createAccount => 'Create account';

  @override
  String get exploreDemo => 'Explore as demo user';

  @override
  String get exploreDemoHint =>
      'Try every role with one tap. No sign-up needed.';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get signUpSubtitle => 'It takes less than a minute';

  @override
  String get yourName => 'Your name';

  @override
  String get termsNote =>
      'By creating an account you agree to the terms and privacy policy.';

  @override
  String get resetTitle => 'Reset your password';

  @override
  String get resetSubtitle => 'We\'ll email you a link to choose a new one.';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String resetSent(String email) {
    return 'If $email has an account, a reset link is on its way.';
  }

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get phoneTitle => 'Sign in with your phone';

  @override
  String get phoneSubtitle => 'We\'ll send a 6-digit code by SMS.';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get phoneInvalid => 'Enter a 10-digit mobile number';

  @override
  String get sendCode => 'Send code';

  @override
  String get enterCodeTitle => 'Enter the code';

  @override
  String enterCodeSubtitle(String phone) {
    return 'We sent a 6-digit code to $phone';
  }

  @override
  String get sixDigitCode => '6-digit code';

  @override
  String get verifyAndContinue => 'Verify and continue';

  @override
  String get changeNumber => 'Change number';

  @override
  String get verifyTitle => 'Check your email';

  @override
  String verifySubtitle(String email) {
    return 'We sent a link to $email. Tap it to confirm it\'s you.';
  }

  @override
  String get verifyDemoNote =>
      'Demo: the email went to the Demo Outbox. Tap below to open it.';

  @override
  String get openDemoEmail => 'Open demo email and verify';

  @override
  String get iveVerified => 'I\'ve verified my email';

  @override
  String get resendEmail => 'Send the email again';

  @override
  String get emailResent => 'Sent again. Check your inbox and spam folder.';

  @override
  String get authErrNoAccount =>
      'No account with that email. Check the spelling or create an account.';

  @override
  String get authErrWrongPassword =>
      'That email and password don\'t match. Try again or reset your password.';

  @override
  String get authErrEmailInUse =>
      'This email already has an account. Sign in instead.';

  @override
  String get authErrWeakPassword => 'Use at least 6 characters';

  @override
  String get authErrInvalidEmail => 'That doesn\'t look like an email address';

  @override
  String get authErrInvalidCode =>
      'That code isn\'t right. Check the SMS and try again.';

  @override
  String get authErrNetwork =>
      'No internet connection. Check it and try again.';

  @override
  String get authErrCancelled => 'Sign-in was cancelled.';

  @override
  String get demoTitle => 'Demo';

  @override
  String get demoBadge => 'Demo';

  @override
  String demoSocialBody(String provider) {
    return 'Demo: in the live app this opens $provider sign-in. Here you\'ll continue as a demo account.';
  }

  @override
  String demoOtpBody(String code) {
    return 'Demo: no SMS is sent. Use the code $code.';
  }

  @override
  String get demoOutboxNote =>
      'Demo: nothing was really sent. The message is in the Demo Outbox in the admin panel.';

  @override
  String get demoLoginNote =>
      'These are demo accounts with made-up people, clinics and data. Nothing here is real, no money is charged and no messages are sent.';

  @override
  String get demoGroupOwners => 'Pet parents';

  @override
  String get demoGroupFamily => 'Family and pet sitter';

  @override
  String get demoGroupPartners => 'Partners';

  @override
  String get demoGroupPlatform => 'Platform';

  @override
  String get demoPriya =>
      'Bengaluru · Plus · Bruno the Labrador and Misty the Persian cat';

  @override
  String get demoRavi =>
      'Hyderabad · Free · Telugu · Simba the Indie puppy and Kiwi the cockatiel';

  @override
  String get demoAnjali =>
      'Delhi NCR · Free · Hindi · Easy mode · Coco the rabbit and Tiger the senior cat';

  @override
  String get demoArjun =>
      'Mumbai · Plus · Max the German Shepherd and Luna the Beagle puppy';

  @override
  String get demoRohan => 'Priya\'s husband · Carer for Bruno and Misty';

  @override
  String get demoMeera => 'Pet sitter for Arjun · access ends in 3 days';

  @override
  String get demoClinicAdmin =>
      'Clinic admin · Golconda Gate Pet Clinic, Hyderabad';

  @override
  String get demoVet => 'Vet · bookings, tele-vet queue and prescriptions';

  @override
  String get demoGroomer => 'Groomer · accepts booking requests';

  @override
  String get demoTrainer => 'Dog trainer';

  @override
  String get demoBoarder => 'Home boarding and pet sitting';

  @override
  String get demoWalker => 'Dog walker · live walk route';

  @override
  String get demoSeller => 'Seller · products, orders and payouts';

  @override
  String get demoAdmin => 'Platform admin · approvals, complaints, Demo Outbox';

  @override
  String demoCredentials(String password, String otp) {
    return 'Signing in by hand? Every demo account uses the password $password. Demo phone code: $otp.';
  }

  @override
  String setupHello(String name) {
    return 'Hi $name, let\'s set things up';
  }

  @override
  String get setupHelloNoName => 'Let\'s set things up';

  @override
  String get setupPrefsSubtitle =>
      'Choose how PawSetu looks and reads. You can change this any time in Settings.';

  @override
  String get setupPetTitle => 'Who are we caring for?';

  @override
  String get setupPetSubtitle => 'Just a name and species for now.';

  @override
  String get setupNotifTitle => 'Reminders keep your pet healthy';

  @override
  String get setupNotifSubtitle =>
      'Allow notifications so we can remind you about:';

  @override
  String get notifReasonVaccines => 'Vaccines and deworming that are due';

  @override
  String get notifReasonMedicines => 'Medicine times, with one-tap Given';

  @override
  String get notifReasonBookings => 'Vet and grooming appointments';

  @override
  String get notifReasonMessages => 'Replies from vets and providers';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System default';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get easyMode => 'Easy mode';

  @override
  String get easyModeHint =>
      'Bigger text and buttons, a simpler Home and plain words.';

  @override
  String get textSize => 'Text size';

  @override
  String get highContrast => 'High contrast';

  @override
  String get highContrastHint => 'Darker text and stronger outlines.';

  @override
  String get notificationChannels => 'Reminders and channels';

  @override
  String get notificationChannelsHint =>
      'Push, email, SMS or WhatsApp, and quiet hours';

  @override
  String get demoData => 'Demo data';

  @override
  String get demoModeOn => 'Demo mode is on';

  @override
  String get demoStandaloneHint =>
      'Everything runs on this device. No real money, messages or calls.';

  @override
  String get demoEmulatorHint =>
      'Connected to the Firebase emulators on your computer.';

  @override
  String get resetDemoData => 'Reset demo data';

  @override
  String get resetDemoDataHint => 'Undo your changes and start fresh';

  @override
  String get resetDemoDataConfirm =>
      'This removes everything you added in the demo and signs you out.';

  @override
  String get about => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get mapCredit => 'Maps © OpenStreetMap contributors';

  @override
  String get designGallery => 'Design gallery';

  @override
  String get myPets => 'My pets';

  @override
  String get familySharing => 'Family and sharing';

  @override
  String get documentVault => 'Document vault';

  @override
  String get memoryAlbum => 'Memory album';

  @override
  String get connectedDevices => 'Connected devices';

  @override
  String get lostPetMode => 'Lost pet mode and QR tag';

  @override
  String get expenses => 'Expenses';

  @override
  String get pawsetuPlus => 'PawSetu Plus';

  @override
  String get helpAndComplaints => 'Help and complaints';

  @override
  String get privacyCentre => 'Privacy centre';

  @override
  String get planFree => 'Free';

  @override
  String get planPlus => 'Plus';

  @override
  String partnerPortalFor(String role) {
    return 'Partner portal · $role';
  }

  @override
  String get pDashboard => 'Dashboard';

  @override
  String get pCalendar => 'Calendar and slots';

  @override
  String get pRequests => 'Booking requests';

  @override
  String get pTeleVetQueue => 'Tele-vet queue';

  @override
  String get pServices => 'Services and prices';

  @override
  String get pStaff => 'Staff and vets';

  @override
  String get pChat => 'Chat inbox';

  @override
  String get pReviews => 'Reviews';

  @override
  String get pPayouts => 'Payouts';

  @override
  String get pProfileKyc => 'Profile and KYC';

  @override
  String get pEmergency => 'Emergency settings';

  @override
  String get pProducts => 'Products and stock';

  @override
  String get pOrders => 'Orders';

  @override
  String get pReturns => 'Returns';

  @override
  String get adminPanel => 'Admin panel';

  @override
  String get aDashboard => 'Dashboard';

  @override
  String get aApprovals => 'Approvals';

  @override
  String get aUsers => 'Users';

  @override
  String get aCatalogue => 'Catalogue';

  @override
  String get aComplaints => 'Complaints and tickets';

  @override
  String get aModeration => 'Moderation';

  @override
  String get aSettings => 'Plans and settings';

  @override
  String get aOutbox => 'Demo Outbox';

  @override
  String get aAudit => 'Audit log';
}
