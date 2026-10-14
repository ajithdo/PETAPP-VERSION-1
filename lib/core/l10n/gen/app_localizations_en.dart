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

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get back => 'Back';

  @override
  String get done => 'Done';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get none => 'None';

  @override
  String get you => 'you';

  @override
  String get share => 'Share';

  @override
  String get copyLink => 'Copy link';

  @override
  String get copied => 'Copied';

  @override
  String get link => 'Link';

  @override
  String get phone => 'Phone';

  @override
  String get manage => 'Manage';

  @override
  String get moreOptions => 'More options';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get details => 'Details';

  @override
  String get notAdded => 'Not added yet';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get addPhotoTitle => 'Add a photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get cropPhoto => 'Move and zoom';

  @override
  String get cropHint => 'Pinch to zoom, drag to move';

  @override
  String get editPet => 'Edit pet';

  @override
  String get petBasicsTitle => 'The basics';

  @override
  String petAboutTitle(String name) {
    return 'About $name';
  }

  @override
  String get petAboutSubtitle => 'All optional. Add what you know now.';

  @override
  String get breed => 'Breed';

  @override
  String get chooseBreed => 'Choose breed';

  @override
  String get searchBreeds => 'Search breeds';

  @override
  String get breedMixed => 'Mixed / Indie';

  @override
  String get breedOther => 'Other (type it)';

  @override
  String get typeBreed => 'Breed name';

  @override
  String get noBreedMatch => 'No match. Try \'Other (type it)\'.';

  @override
  String get colourTag => 'Colour tag';

  @override
  String get colourTagHint => 'Helps you tell pets apart at a glance';

  @override
  String get colourAmber => 'Amber';

  @override
  String get colourLavender => 'Lavender';

  @override
  String get colourSky => 'Sky';

  @override
  String get colourRose => 'Rose';

  @override
  String get colourMint => 'Mint';

  @override
  String get colourSand => 'Sand';

  @override
  String get birthday => 'Birthday';

  @override
  String get exactDate => 'Exact date';

  @override
  String get approxAge => 'Approximate age';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get years => 'Years';

  @override
  String get months => 'Months';

  @override
  String get gender => 'Gender';

  @override
  String get weight => 'Weight';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get weightGrams => 'Weight (grams)';

  @override
  String get age => 'Age';

  @override
  String get moreDetails => 'More details';

  @override
  String get moreDetailsHint => 'Markings, microchip, allergies, diet, clinic';

  @override
  String get markings => 'Colour and markings';

  @override
  String get microchip => 'Microchip ID';

  @override
  String get neutered => 'Neutered / spayed';

  @override
  String get allergies => 'Allergies';

  @override
  String get allergiesHint => 'Separate with commas, e.g. Chicken, Wheat';

  @override
  String get dietType => 'Diet';

  @override
  String get regularClinic => 'Regular clinic';

  @override
  String get temperament => 'Temperament notes';

  @override
  String get insuranceInVault =>
      'Insurance policies are kept in the Document vault.';

  @override
  String petAdded(String name) {
    return '$name added';
  }

  @override
  String petLimitTitle(int limit) {
    return 'The free plan has room for $limit pets';
  }

  @override
  String get petLimitBody =>
      'PawSetu Plus gives you unlimited pets, plus video vet calls and more.';

  @override
  String petsUsed(int used, int limit) {
    return '$used of $limit pets on the free plan';
  }

  @override
  String get petNotFound => 'We couldn\'t find this pet';

  @override
  String get petCare => 'Care';

  @override
  String get routine => 'Routine';

  @override
  String get family => 'Family';

  @override
  String get petSectionHealth => 'Vaccines, medicines, vet visits';

  @override
  String get petSectionRoutine => 'Walks, meals, play, mood';

  @override
  String get petSectionDocs => 'Certificates, insurance, reports';

  @override
  String get petSectionMemories => 'Photos, videos, milestones';

  @override
  String get flatFacedChip => 'Feels the heat';

  @override
  String get qrTag => 'QR tag';

  @override
  String get archivePet => 'Archive pet';

  @override
  String get restorePet => 'Bring back to active pets';

  @override
  String archiveTitle(String name) {
    return 'Archive $name';
  }

  @override
  String get archiveBody =>
      'Their records and memories stay safe. Reminders stop.';

  @override
  String get passedAway => 'Passed away';

  @override
  String get passedAwayHint => 'Kept under \"In loving memory\"';

  @override
  String get rehomed => 'Rehomed';

  @override
  String get rehomedHint => 'Found a new family';

  @override
  String get memorialNote => 'A few words (optional)';

  @override
  String get memorialNoteHint => 'e.g. Forever in our hearts';

  @override
  String get inLovingMemory => 'In loving memory';

  @override
  String archivedMemorial(String name) {
    return '$name is in loving memory. Their memories are kept safe.';
  }

  @override
  String archivedRehomed(String name) {
    return '$name has been archived';
  }

  @override
  String get people => 'People';

  @override
  String get activity => 'Activity';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get invite => 'Invite';

  @override
  String get invitesForYou => 'Invites for you';

  @override
  String get familyRolesHelp =>
      'Viewer: sees everything and can log routine. Carer: also gives medicines and books services. Co-owner: everything except deleting the pet.';

  @override
  String get roleViewerHint => 'Sees everything, can log walks and meals';

  @override
  String get roleCarerHint => 'Also gives medicines and books services';

  @override
  String get roleCoownerHint =>
      'Everything except deleting the pet or removing you';

  @override
  String get role => 'Role';

  @override
  String inviteTitle(String pet) {
    return 'Invite someone to care for $pet';
  }

  @override
  String get temporaryAccess => 'Pet sitter (access ends on a date)';

  @override
  String get temporaryAccessHint => 'Access stops automatically';

  @override
  String accessUntil(String date) {
    return 'Access until $date';
  }

  @override
  String get accessEnded => 'Access has ended';

  @override
  String get sendInvite => 'Send invite';

  @override
  String get createLink => 'Create invite link';

  @override
  String inviteSent(String contact) {
    return 'Invite sent to $contact';
  }

  @override
  String get inviteLinkReady => 'Your invite link is ready';

  @override
  String inviteShareText(String pet, String link) {
    return 'Help me look after $pet on PawSetu: $link';
  }

  @override
  String get inviteLink => 'Invite link';

  @override
  String invitePending(String role) {
    return 'Waiting to accept · $role';
  }

  @override
  String get cancelInvite => 'Cancel invite';

  @override
  String inviteReceived(String from, String pet, String role) {
    return '$from invited you to care for $pet as $role';
  }

  @override
  String inviteAccepted(String pet) {
    return 'You can now help care for $pet';
  }

  @override
  String get inviteInvalid => 'This invite has expired or was already used';

  @override
  String get signInToAccept => 'Sign in to accept';

  @override
  String get changeRole => 'Change role';

  @override
  String get removeAccess => 'Remove access';

  @override
  String removeAccessConfirm(String name, String pet) {
    return 'Remove $name\'s access to $pet?';
  }

  @override
  String familyLimitTitle(int limit) {
    return 'The free plan shares with up to $limit people';
  }

  @override
  String get familyLimitBody =>
      'PawSetu Plus lets up to 8 family members help.';

  @override
  String sharedWithYou(String role) {
    return 'Shared with you · $role';
  }

  @override
  String get noActivityTitle => 'No activity yet';

  @override
  String get noActivityBody =>
      'When family members log walks or give medicines, it shows here.';

  @override
  String actMedicineGiven(String who, String pet, String detail) {
    return '$who gave $pet $detail';
  }

  @override
  String actWalk(String who, String pet, String detail) {
    return '$who walked $pet ($detail)';
  }

  @override
  String actMeal(String who, String pet) {
    return '$who fed $pet';
  }

  @override
  String actMemberJoined(String who, String pet) {
    return '$who joined $pet\'s family';
  }

  @override
  String actMemberRemoved(String who, String name, String pet) {
    return '$who removed $name from $pet\'s family';
  }

  @override
  String actRoleChanged(String who, String pet) {
    return '$who changed a role for $pet';
  }

  @override
  String actGeneric(String who, String pet) {
    return '$who updated $pet';
  }

  @override
  String get plusPerkPets => 'Unlimited pets and up to 8 family members';

  @override
  String get plusPerkVideo =>
      'Video vet calls, longer chats, 10% off video fees';

  @override
  String get plusPerkAi => 'Unlimited Ask PawSetu questions';

  @override
  String get plusPerkStorage => '25 GB for photos and documents';

  @override
  String get seePlus => 'See PawSetu Plus';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get seeAll => 'See all';

  @override
  String get today => 'Today';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get increase => 'Increase';

  @override
  String get decrease => 'Decrease';

  @override
  String get continueLabel => 'Continue';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get logWalk => 'Walk';

  @override
  String get logPlay => 'Play';

  @override
  String get logMeal => 'Meal';

  @override
  String get logWater => 'Water';

  @override
  String get logPotty => 'Potty';

  @override
  String get logSleep => 'Sleep / nap';

  @override
  String get logGrooming => 'Grooming';

  @override
  String get logTraining => 'Training';

  @override
  String get logMood => 'Mood';

  @override
  String get logWeight => 'Weight';

  @override
  String get logBehaviour => 'Behaviour';

  @override
  String logFor(String name) {
    return 'Log for $name';
  }

  @override
  String get logSomething => 'Log';

  @override
  String logNow(String type) {
    return 'Log $type now';
  }

  @override
  String logged(String type, String name) {
    return '$type logged for $name';
  }

  @override
  String get addDetails => 'Add details';

  @override
  String get amountGrams => 'Amount (grams)';

  @override
  String get distanceKm => 'Distance (km)';

  @override
  String get durationMinutes => 'Duration (minutes)';

  @override
  String get enterWeight => 'Enter the weight';

  @override
  String get chooseOneTag => 'Choose at least one behaviour';

  @override
  String howIsPet(String name) {
    return 'How is $name today?';
  }

  @override
  String get behaviourPrompt => 'What did you notice?';

  @override
  String get behaviourHint => 'Tap again to change: mild, moderate, strong';

  @override
  String get intensityMild => 'mild';

  @override
  String get intensityModerate => 'moderate';

  @override
  String get intensityStrong => 'strong';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodPlayful => 'Playful';

  @override
  String get moodTired => 'Tired';

  @override
  String get moodAnxious => 'Anxious';

  @override
  String get moodUnwell => 'Unwell';

  @override
  String get tagPlayful => 'Playful';

  @override
  String get tagCalm => 'Calm';

  @override
  String get tagAnxious => 'Anxious';

  @override
  String get tagLeashPulling => 'Leash pulling';

  @override
  String get tagBarking => 'Barking';

  @override
  String get tagAggressionDogs => 'Aggression with dogs';

  @override
  String get tagSeparationAnxiety => 'Separation anxiety';

  @override
  String get tagScratching => 'Scratching furniture';

  @override
  String get tagChewing => 'Chewing things';

  @override
  String get tagJumping => 'Jumping on people';

  @override
  String get tagHiding => 'Hiding';

  @override
  String get tagNotEating => 'Not eating well';

  @override
  String todayFor(String name) {
    return '$name\'s day';
  }

  @override
  String get todayAllPets => 'Today for all pets';

  @override
  String allDoneToday(String name) {
    return 'All done for today. Good job with $name!';
  }

  @override
  String tasksLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things left today',
      one: '1 thing left today',
    );
    return '$_temp0';
  }

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String playProgress(int done, int goal) {
    return 'Play · $done / $goal min';
  }

  @override
  String routineOf(String name) {
    return '$name\'s routine';
  }

  @override
  String get tabLog => 'Log';

  @override
  String get tabCharts => 'Charts';

  @override
  String get tabBehaviour => 'Behaviour';

  @override
  String get tabPlan => 'Daily plan';

  @override
  String noLogsTitle(String name) {
    return 'Nothing logged for $name yet';
  }

  @override
  String get noLogsBody => 'Tap Log to add a meal, walk or play time.';

  @override
  String get deleteLogConfirm => 'Delete this entry?';

  @override
  String get totalWalked => 'Walked';

  @override
  String get streak => 'Streak';

  @override
  String get mealsLogged => 'Meals logged';

  @override
  String get chartWalkKm => 'Walking (km per day)';

  @override
  String get chartPlayMinutes => 'Play (minutes per day)';

  @override
  String get chartMeals => 'Meals per day';

  @override
  String get chartMood => 'Mood';

  @override
  String get noMoodLogs => 'No mood logged in this period.';

  @override
  String get noBehaviourTitle => 'No behaviour notes yet';

  @override
  String noBehaviourBody(String name) {
    return 'Note things like leash pulling or barking to see how $name changes over time.';
  }

  @override
  String get trendUp => 'increasing';

  @override
  String get trendDown => 'improving';

  @override
  String get trendSteady => 'steady';

  @override
  String get trendNew => 'new';

  @override
  String get shareWithTrainerVet => 'Share with trainer or vet';

  @override
  String behaviourSummaryTitle(String name) {
    return '$name\'s behaviour (PawSetu)';
  }

  @override
  String dailyPlanFor(String name) {
    return '$name\'s daily plan';
  }

  @override
  String get dailyPlanHint => 'This drives the Today checklist on Home.';

  @override
  String get walksPerDay => 'Walks per day';

  @override
  String get mealsPerDay => 'Meals per day';

  @override
  String get playMinutesPerDay => 'Play minutes per day';

  @override
  String suggestedGoalsText(String walks, int meals, int play) {
    return 'Suggested for this pet: $walks$meals meals and $play minutes of play a day. Indicative, always confirm with your vet.';
  }

  @override
  String suggestedWalks(int count, int minutes) {
    return '$count walks ($minutes min in all), ';
  }

  @override
  String get useSuggested => 'Use suggested goals';

  @override
  String get savePlan => 'Save plan';

  @override
  String get planSaved => 'Daily plan saved';

  @override
  String get planReminderNote =>
      'Reminders for the plan are set in Settings → Reminders and channels.';

  @override
  String walkWith(String name) {
    return 'Walk with $name';
  }

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Time';

  @override
  String get pace => 'Pace';

  @override
  String paceValue(String value) {
    return '$value min/km';
  }

  @override
  String get startWalk => 'Start walk';

  @override
  String get startDemoWalk => 'Try a demo walk';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get stop => 'Stop';

  @override
  String get saveWalk => 'Save walk';

  @override
  String get discardWalk => 'Discard walk';

  @override
  String walkSaved(String name, String distance) {
    return '$name\'s walk saved: $distance';
  }

  @override
  String get walkLeaveTitle => 'Stop this walk?';

  @override
  String get walkLeaveBody => 'The route so far will not be saved.';

  @override
  String get walkNotificationTitle => 'PawSetu is tracking your walk';

  @override
  String get walkNotificationText =>
      'Tap to open. Stop the walk in the app when you\'re home.';

  @override
  String get walkWebNote =>
      'Live GPS walks work in the Android and iPhone apps. On the website you can add a walk by hand.';

  @override
  String get enterWalkManually => 'Add a walk by hand';

  @override
  String get demoWalkBanner =>
      'Demo walk: the route is simulated near your home area.';

  @override
  String get locationWhyTitle => 'Use your location?';

  @override
  String get locationWhyWalk =>
      'We use it only while you walk, to draw the route and measure the distance.';

  @override
  String get locationOffTitle => 'Location is off';

  @override
  String get locationOffBody =>
      'Turn on location to track a real walk, or try a demo walk now.';

  @override
  String get useDemoWalk => 'Use demo walk';

  @override
  String get walkWeather => 'Walk weather';

  @override
  String heatOk(String name) {
    return 'Good weather for $name\'s walk';
  }

  @override
  String get heatWarm => 'It\'s warm. Keep walks short and shaded.';

  @override
  String heatHot(String name) {
    return 'Too hot for a long walk with $name';
  }

  @override
  String heatDanger(String name) {
    return 'Dangerous heat. Skip the walk for $name now';
  }

  @override
  String get heatTipTime => 'Walk early morning (before 8 am) or after sunset.';

  @override
  String get heatTipWater => 'Carry water and avoid hot roads; they burn paws.';

  @override
  String heatTipFlatFaced(String name) {
    return '$name has a short nose and overheats faster than most pets.';
  }

  @override
  String get demoTemperature => 'Demo temperature';

  @override
  String get add => 'Add';

  @override
  String get record => 'Record';

  @override
  String get date => 'Date';

  @override
  String get status => 'Status';

  @override
  String get type => 'Type';

  @override
  String get owner => 'Owner';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get markDone => 'Mark done';

  @override
  String get indicativeNote => 'Indicative, always confirm with your vet.';

  @override
  String healthOf(String name) {
    return '$name\'s health';
  }

  @override
  String get choosePetForHealth => 'Choose a pet';

  @override
  String itemsNeedAttention(int count) {
    return '$count need attention';
  }

  @override
  String get nextUp => 'Next up';

  @override
  String nothingDue(String name) {
    return 'Nothing due for $name right now.';
  }

  @override
  String get nothingDueAll => 'All caught up. Nothing due this week.';

  @override
  String get healthReport => 'Health report';

  @override
  String healthReportOf(String name) {
    return '$name\'s health report';
  }

  @override
  String get medicalCard => 'Medical card';

  @override
  String get statusDone => 'Done';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusDueSoon => 'Due soon';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusAskVet => 'Ask your vet';

  @override
  String get askYourVet => 'Ask your vet';

  @override
  String get dose => 'Dose';

  @override
  String doseN(int n) {
    return 'Dose $n';
  }

  @override
  String get booster => 'Booster';

  @override
  String get optionalVaccine => 'Optional (vet advises)';

  @override
  String get vaccinations => 'Vaccinations';

  @override
  String get vaccine => 'Vaccine';

  @override
  String get vaccineName => 'Vaccine name';

  @override
  String get otherVaccine => 'Other vaccine';

  @override
  String recordVaccineFor(String name) {
    return 'Record a vaccine for $name';
  }

  @override
  String get dateGiven => 'Date given';

  @override
  String get vaccineBrand => 'Vaccine brand';

  @override
  String get batchNumber => 'Batch number';

  @override
  String get vetName => 'Vet\'s name';

  @override
  String get clinicName => 'Clinic';

  @override
  String get attachCertificate => 'Attach certificate photo';

  @override
  String get certificateAttached => 'Certificate attached (saved to the vault)';

  @override
  String vaccineRecorded(String vaccine, String name) {
    return '$vaccine recorded for $name';
  }

  @override
  String givenOn(String date) {
    return 'Given $date';
  }

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String get nextDueShort => 'Next due';

  @override
  String get catchUpNote =>
      'No vaccine history yet. Ask your vet for a catch-up plan, and add past vaccines with Record.';

  @override
  String get rabbitVaccineNote =>
      'There is no standard routine vaccine schedule for rabbits in India. Check with an exotic-animal vet; a health check every 6–12 months is a good idea.';

  @override
  String get birdVaccineNote =>
      'Common pet birds don\'t need routine vaccines. Plan a yearly avian vet check, and keep an eye on nails and beak.';

  @override
  String get medicines => 'Medicines';

  @override
  String get medicineName => 'Medicine';

  @override
  String addMedicineFor(String name) {
    return 'Add a medicine for $name';
  }

  @override
  String get editMedicine => 'Edit medicine';

  @override
  String get unit => 'Unit';

  @override
  String get unitTablet => 'tablet';

  @override
  String get unitMl => 'ml';

  @override
  String get unitDrops => 'drops';

  @override
  String get unitMg => 'mg';

  @override
  String get unitCapsule => 'capsule';

  @override
  String get unitSachet => 'sachet';

  @override
  String get frequency => 'How often';

  @override
  String get freqOnce => 'Once a day';

  @override
  String get freqTwice => 'Twice a day';

  @override
  String freqEveryHours(int hours) {
    return 'Every $hours hours';
  }

  @override
  String get freqWeekly => 'Once a week';

  @override
  String get freqCustom => 'Custom times';

  @override
  String get doseTimes => 'Dose times';

  @override
  String get firstDoseAt => 'First dose at';

  @override
  String get addTime => 'Add time';

  @override
  String get withFood => 'With food';

  @override
  String get startDate => 'Start date';

  @override
  String get noEndDate => 'No end date';

  @override
  String endsOn(String date) {
    return 'Ends $date';
  }

  @override
  String get setEndDate => 'Set end date';

  @override
  String get stockCount => 'Doses in stock (optional)';

  @override
  String get stockHint => 'We\'ll remind you to refill when 5 are left';

  @override
  String medicineSaved(String name) {
    return '$name saved';
  }

  @override
  String noMedicines(String name) {
    return '$name isn\'t on any medicine.';
  }

  @override
  String nextDoseAt(String time) {
    return 'Next: $time';
  }

  @override
  String stockLeft(int count) {
    return '$count left';
  }

  @override
  String get refill => 'Refill';

  @override
  String refillNeeded(String name) {
    return 'Refill $name';
  }

  @override
  String get given => 'Given';

  @override
  String get snooze15 => 'Snooze 15 min';

  @override
  String doseGiven(String name) {
    return '$name marked as given';
  }

  @override
  String get doseSkipped => 'Dose skipped';

  @override
  String get doseSnoozed => 'We\'ll remind you in 15 minutes';

  @override
  String todayAt(String time) {
    return 'Today, $time';
  }

  @override
  String overdueBy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String dueInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get prevention => 'Deworming and flea/tick';

  @override
  String get deworming => 'Deworming';

  @override
  String get fleaTick => 'Flea and tick prevention';

  @override
  String lastDone(String date) {
    return 'Last $date';
  }

  @override
  String nextDue(String date) {
    return 'Next $date';
  }

  @override
  String get tickFeverNote =>
      'Tick fever is common in India. Keep flea and tick prevention up to date.';

  @override
  String get productUsed => 'Product used';

  @override
  String get weightNeedsTwo => 'Add two or more weights to see the chart.';

  @override
  String weightRangeNote(String range) {
    return 'Green band: indicative healthy range $range. Always confirm with your vet.';
  }

  @override
  String get weightGrowingNote =>
      'Still growing. Your vet will tell you the right weight.';

  @override
  String get vetVisit => 'Vet visit';

  @override
  String get vetVisits => 'Vet visits';

  @override
  String get reasonForVisit => 'Reason for visit';

  @override
  String get diagnosis => 'Diagnosis or advice';

  @override
  String get noVisits => 'No vet visits recorded yet.';

  @override
  String get symptom => 'Symptom';

  @override
  String get symptomDiary => 'Symptom diary';

  @override
  String get noSymptoms => 'No symptoms noted. That\'s good news.';

  @override
  String get severity => 'How bad is it?';

  @override
  String get severeSymptomNote =>
      'If your pet has trouble breathing, collapses, has a seizure or may have eaten poison, use SOS now.';

  @override
  String get shareWithVet => 'Share with vet';

  @override
  String symptomShareTitle(String name) {
    return '$name\'s symptom diary (PawSetu)';
  }

  @override
  String get symVomiting => 'Vomiting';

  @override
  String get symDiarrhoea => 'Diarrhoea';

  @override
  String get symNotEating => 'Not eating';

  @override
  String get symLimping => 'Limping';

  @override
  String get symItching => 'Itching';

  @override
  String get symCoughing => 'Coughing';

  @override
  String get symLethargy => 'Very tired';

  @override
  String get symSneezing => 'Sneezing';

  @override
  String get symOther => 'Other';

  @override
  String savedFor(String what, String name) {
    return '$what saved for $name';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get noReminders => 'No custom reminders.';

  @override
  String newReminderFor(String name) {
    return 'New reminder for $name';
  }

  @override
  String get reminderTitle => 'What should we remind you about?';

  @override
  String get repeat => 'Repeat';

  @override
  String get repeatNone => 'Don\'t repeat';

  @override
  String get repeatMonthly => 'Every month';

  @override
  String get repeatYearly => 'Every year';

  @override
  String get reminderSet => 'Reminder set';

  @override
  String get remTypeLicence => 'Licence renewal';

  @override
  String get remTypeInsurance => 'Insurance renewal';

  @override
  String get remTypeGrooming => 'Grooming due';

  @override
  String get remTypeNailTrim => 'Nail trim';

  @override
  String get remTypeBirthday => 'Birthday';

  @override
  String get remTypeCustom => 'Something else';

  @override
  String remVaccineDue(String name, String vaccine) {
    return '$name\'s $vaccine is due soon';
  }

  @override
  String remVaccineOverdue(String name, String vaccine) {
    return '$name\'s $vaccine is overdue';
  }

  @override
  String remMedicine(String name, String medicine) {
    return 'Time for $name\'s $medicine';
  }

  @override
  String remRefill(String medicine, String name) {
    return '$medicine for $name is running low';
  }

  @override
  String remDeworming(String name) {
    return '$name\'s deworming is due';
  }

  @override
  String remFleaTick(String name) {
    return '$name\'s flea and tick prevention is due';
  }

  @override
  String get remTapToOpen => 'Tap to open PawSetu';

  @override
  String get remSnoozed => 'Snoozed for 15 minutes';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnread => 'Unread';

  @override
  String get filterBookings => 'Bookings';

  @override
  String get filterOrdersMessages => 'Orders and messages';

  @override
  String get noNotificationsTitle => 'You\'re all caught up';

  @override
  String get noNotificationsBody => 'Reminders and updates will appear here.';

  @override
  String get ntVaccines => 'Vaccines';

  @override
  String get ntMedicines => 'Medicines';

  @override
  String get ntDeworming => 'Deworming and flea/tick';

  @override
  String get ntBookings => 'Bookings';

  @override
  String get ntRoutine => 'Daily routine';

  @override
  String get ntCustom => 'My reminders';

  @override
  String get chPush => 'Push';

  @override
  String get chEmail => 'Email';

  @override
  String get chSms => 'SMS';

  @override
  String get chWhatsApp => 'WhatsApp';

  @override
  String get channelsDemoNote =>
      'Demo: push reminders are real on your phone. Email, SMS and WhatsApp go to the Demo Outbox instead of being sent.';

  @override
  String get quietHours => 'Quiet hours';

  @override
  String get quietHoursOn => 'Don\'t disturb at night';

  @override
  String get quietHoursHint =>
      'Reminders wait until morning. Medicine reminders always ring on time.';

  @override
  String get notificationsOn => 'Notifications are on';

  @override
  String get notificationsOffHint =>
      'Notifications are off. You can turn them on in your phone\'s settings.';

  @override
  String get preparingDocument => 'Preparing your document…';

  @override
  String get sharePdf => 'Share or save PDF';

  @override
  String generatedOn(String date) {
    return 'Generated $date';
  }

  @override
  String get reportFooter =>
      'Made with PawSetu · Demo data · Indicative, always confirm with your vet';

  @override
  String get ownerAndClinic => 'Owner and clinic';

  @override
  String get noKnownAllergies => 'No known allergies';

  @override
  String get currentMedicines => 'Current medicines';

  @override
  String get rabiesVaccine => 'Rabies vaccine';

  @override
  String get notRecorded => 'Not recorded';

  @override
  String medicalCardUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get medicalCardOffline =>
      'This card works without internet. Show it to a vet, a boarding centre or at the airport.';

  @override
  String get bookTitle => 'Book care';

  @override
  String get findAVet => 'Find a vet near you';

  @override
  String get kindVet => 'Vet clinic';

  @override
  String get kindGrooming => 'Grooming';

  @override
  String get kindTraining => 'Training';

  @override
  String get kindBoarding => 'Boarding';

  @override
  String get kindWalking => 'Dog walking';

  @override
  String get teleVet => 'Tele-vet';

  @override
  String get clinicFinderMap => 'Clinics on the map';

  @override
  String get clinicFinderHint =>
      'See open clinics and 24x7 emergency care around you.';

  @override
  String get myBookings => 'My bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get requests => 'Requests';

  @override
  String get past => 'Past';

  @override
  String get noUpcomingBookings => 'No upcoming bookings.';

  @override
  String get noRequests => 'No requests waiting.';

  @override
  String get noPastBookings => 'No past bookings yet.';

  @override
  String get bookSomething => 'Book something';

  @override
  String get viewBooking => 'View booking';

  @override
  String get backToBook => 'Back to Book';

  @override
  String get searchByNameOrArea => 'Search by name or area';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get nearYou => 'Near you';

  @override
  String get chooseArea => 'Choose your area';

  @override
  String get locationWhyClinics =>
      'PawSetu uses your location only to sort clinics and services by distance. It is not saved.';

  @override
  String get locationFallback =>
      'Couldn\'t get your location. Showing your chosen area instead.';

  @override
  String get filters => 'Filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get showResults => 'Show results';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortNearest => 'Nearest';

  @override
  String get sortRating => 'Top rated';

  @override
  String get sortSlot => 'Earliest slot';

  @override
  String get sortFee => 'Lowest fee';

  @override
  String get openNow => 'Open now';

  @override
  String get openNowChip => 'Open now';

  @override
  String get closedChip => 'Closed';

  @override
  String get open24x7 => '24x7';

  @override
  String get open24x7Long => 'Open 24 hours, all 7 days';

  @override
  String get teleVetAvailable => 'Tele-vet available';

  @override
  String get homeVisit => 'Home visit';

  @override
  String get rating => 'Rating';

  @override
  String get rating4plus => '4★ and above';

  @override
  String get speciesTreated => 'Animals treated';

  @override
  String get languagesSpoken => 'Languages spoken';

  @override
  String get consultationFee => 'Consultation fee';

  @override
  String upTo(String amount) {
    return 'Up to $amount';
  }

  @override
  String feeFrom(String amount) {
    return 'From $amount';
  }

  @override
  String resultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get listView => 'List';

  @override
  String get mapView => 'Map';

  @override
  String get noResultsTitle => 'Nothing matches';

  @override
  String get noResultsBody => 'Try another area or clear some filters.';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get call => 'Call';

  @override
  String get directions => 'Directions';

  @override
  String get bookNow => 'Book now';

  @override
  String demoCallBody(String phone) {
    return 'Demo mode doesn\'t place real calls. In the live app this would call $phone.';
  }

  @override
  String get hoursTitle => 'Hours';

  @override
  String get closedToday => 'Closed today';

  @override
  String todayHours(String open, String close) {
    return 'Today $open – $close';
  }

  @override
  String emergencyLine(String phone) {
    return 'Emergency line: $phone';
  }

  @override
  String get servicesAndPrices => 'Services and prices';

  @override
  String get instantBooking => 'Instant booking';

  @override
  String get requestBooking => 'Request to book';

  @override
  String get payOnline => 'Pay online';

  @override
  String get payAtCentre => 'Pay at the centre';

  @override
  String get payAtClinic => 'Pay at the clinic';

  @override
  String homeVisitAvailable(int km) {
    return 'Home visits within $km km';
  }

  @override
  String get packages => 'Packages';

  @override
  String get vetsHere => 'Vets here';

  @override
  String yearsExperience(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years experience',
      one: '1 year experience',
    );
    return '$_temp0';
  }

  @override
  String regNo(String no) {
    return 'Reg. no. $no';
  }

  @override
  String get location => 'Location';

  @override
  String get reviews => 'Reviews';

  @override
  String get noReviewsYet => 'No reviews yet.';

  @override
  String get verifiedBooking => 'Verified booking';

  @override
  String replyFrom(String name) {
    return 'Reply from $name';
  }

  @override
  String get inClinic => 'In clinic';

  @override
  String get svcConsultation => 'Consultation';

  @override
  String get svcVaccination => 'Vaccination';

  @override
  String get svcSurgery => 'Surgery consult';

  @override
  String get svcDental => 'Dental cleaning';

  @override
  String get svcLabTests => 'Lab tests';

  @override
  String get svcXray => 'X-ray';

  @override
  String get svcHomeVisit => 'Home visit';

  @override
  String get svcGrooming => 'Grooming';

  @override
  String get svcBathBrush => 'Bath and brush';

  @override
  String get svcFullGroom => 'Full groom';

  @override
  String get svcNailTrim => 'Nail trim';

  @override
  String get svcTickTreatment => 'Tick treatment';

  @override
  String get svcObedience => 'Obedience training';

  @override
  String get svcPuppyBasics => 'Puppy basics';

  @override
  String get svcBehaviour => 'Behaviour session';

  @override
  String get svcBoarding => 'Boarding';

  @override
  String get svcBoardingNight => 'Boarding (per night)';

  @override
  String get svcDayCare => 'Day care';

  @override
  String get svcHomeSitting => 'Home sitting';

  @override
  String get svcWalk30 => '30-minute walk';

  @override
  String get svcWalk60 => '60-minute walk';

  @override
  String get stepWhoWhat => 'Pet and service';

  @override
  String get stepWhen => 'Date and time';

  @override
  String get stepDetails => 'Details';

  @override
  String get stepConfirm => 'Confirm';

  @override
  String get whichPet => 'Which pet?';

  @override
  String get whichService => 'Which service?';

  @override
  String get chooseVet => 'Choose a vet';

  @override
  String get anyVet => 'Any available vet';

  @override
  String get noPetForPlace =>
      'None of your pets can be booked here. Add a pet first.';

  @override
  String homeVisitHint(int km, String fee) {
    return 'Within $km km, travel fee $fee';
  }

  @override
  String get openSlots => 'Open slots';

  @override
  String get noSlotsThatDay => 'No open slots that day. Try another day.';

  @override
  String requestExplainer(int hours) {
    return 'Pick up to 3 times that suit you. The provider replies within $hours hours.';
  }

  @override
  String get yourPreferredTimes => 'Your preferred times';

  @override
  String get preferredTimes => 'Preferred times';

  @override
  String get symptomsNotes => 'Symptoms or notes for the vet';

  @override
  String get symptomsHint => 'E.g. not eating since yesterday, vomited twice';

  @override
  String get notesForProvider => 'Notes for the provider';

  @override
  String get notes => 'Notes';

  @override
  String get howToPay => 'How would you like to pay?';

  @override
  String get payOnlineHint => 'UPI or card now. Instant confirmation.';

  @override
  String get payLaterHint => 'Pay when you visit.';

  @override
  String get when => 'When';

  @override
  String get where => 'Where';

  @override
  String get pet => 'Pet';

  @override
  String get vet => 'Vet';

  @override
  String get travelFee => 'Travel fee';

  @override
  String get platformFee => 'Platform fee';

  @override
  String get free => 'Free';

  @override
  String get totalToPay => 'Total';

  @override
  String cancellationPolicy(int hours) {
    return 'Free cancellation up to $hours hours before. After that, 50% refund.';
  }

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get sendRequest => 'Send request';

  @override
  String get demoBookingNote => 'Demo booking. No real money is charged.';

  @override
  String get bookingConfirmedTitle => 'Booking confirmed';

  @override
  String bookingConfirmedBody(String pet, String place, String when) {
    return '$pet is booked at $place on $when.';
  }

  @override
  String get requestSentTitle => 'Request sent';

  @override
  String requestSentBody(String place) {
    return '$place will reply soon. We\'ll notify you.';
  }

  @override
  String get paymentFailed => 'Payment failed. Nothing was charged. Try again.';

  @override
  String get paymentPendingNote =>
      'Payment pending. We\'ll confirm once it clears.';

  @override
  String get demoPaymentTitle => 'Demo payment';

  @override
  String get demoPaymentNote => 'This is a demo. No money will move.';

  @override
  String get demoPaymentChoose => 'Choose what happens:';

  @override
  String get payUpiDemo => 'Pay with UPI (demo)';

  @override
  String get simulateFailure => 'Simulate a failure';

  @override
  String get simulatePending => 'Simulate pending';

  @override
  String get bookingDetails => 'Booking details';

  @override
  String get replyBy => 'Reply by';

  @override
  String replyBefore(String time) {
    return 'Reply before $time';
  }

  @override
  String get payment => 'Payment';

  @override
  String get paidOnline => 'Paid online';

  @override
  String get paymentPending => 'Payment pending';

  @override
  String get payAtVisit => 'Pay at visit';

  @override
  String get platformCommission => 'Platform commission';

  @override
  String get yourPayout => 'Your payout';

  @override
  String get refund => 'Refund';

  @override
  String refundDemo(String amount) {
    return '$amount (demo, no real money)';
  }

  @override
  String providerSuggested(String place, String when) {
    return '$place suggested a new time: $when';
  }

  @override
  String get liveWalk => 'Live walk';

  @override
  String get liveWalkDemo => 'Simulated live walk for the demo.';

  @override
  String walkSoFar(String km) {
    return '$km so far';
  }

  @override
  String get updates => 'Updates';

  @override
  String get dailyUpdates => 'Daily updates';

  @override
  String get addToCalendar => 'Add to calendar';

  @override
  String get message => 'Message';

  @override
  String get reschedule => 'Reschedule';

  @override
  String rescheduledTo(String when) {
    return 'Moved to $when';
  }

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get cancelBookingQ => 'Cancel this booking?';

  @override
  String cancelRefundInfo(String amount) {
    return 'You\'ll get $amount back (demo).';
  }

  @override
  String cancelledWithRefund(String amount) {
    return 'Cancelled. $amount refunded (demo).';
  }

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get writeReview => 'Write a review';

  @override
  String rateProvider(String name) {
    return 'How was $name?';
  }

  @override
  String starsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get reviewText => 'Tell other pet parents what went well';

  @override
  String get postReview => 'Post review';

  @override
  String get thanksForReview => 'Thanks for your review!';

  @override
  String get bsPending => 'Waiting for reply';

  @override
  String get bsConfirmed => 'Confirmed';

  @override
  String get bsSuggested => 'New time suggested';

  @override
  String get bsInProgress => 'In progress';

  @override
  String get bsCompleted => 'Completed';

  @override
  String get bsCancelled => 'Cancelled';

  @override
  String get bsDeclined => 'Declined';

  @override
  String get bsExpired => 'Expired';

  @override
  String ntfNewBooking(String pet, String when) {
    return 'New booking: $pet on $when';
  }

  @override
  String ntfNewRequest(String pet) {
    return 'New booking request for $pet';
  }

  @override
  String ntfAccepted(String place, String when) {
    return '$place confirmed your booking for $when';
  }

  @override
  String ntfDeclined(String place) {
    return '$place couldn\'t take your request';
  }

  @override
  String ntfSuggested(String place, String when) {
    return '$place suggested $when instead';
  }

  @override
  String ntfCancelled(String pet, String when) {
    return 'Booking for $pet on $when was cancelled';
  }

  @override
  String ntfRescheduled(String pet, String when) {
    return '$pet\'s booking moved to $when';
  }

  @override
  String ntfCompleted(String pet, String place) {
    return '$pet\'s visit at $place is done. Rate your experience?';
  }

  @override
  String ntfUpdate(String place, String pet) {
    return '$place sent an update about $pet';
  }

  @override
  String ntfExpired(String place) {
    return '$place didn\'t reply in time. Your request expired.';
  }

  @override
  String helloPartner(String name) {
    return 'Hello, $name';
  }

  @override
  String get noBusinessLinked => 'No business is linked to this account yet.';

  @override
  String get waitingApproval =>
      'Waiting for approval. PawSetu checks new partners within 2 working days. You can set up your services meanwhile.';

  @override
  String get todaysBookings => 'Today\'s bookings';

  @override
  String get requestsWaiting => 'Requests waiting';

  @override
  String get earningsThisMonth => 'Earnings this month';

  @override
  String get completedBookings => 'Completed';

  @override
  String get noBookingsToday => 'No bookings today.';

  @override
  String bookingsOn(String date) {
    return 'Bookings on $date';
  }

  @override
  String get noBookingsThisDay => 'No bookings this day.';

  @override
  String get holidayNoBookings => 'Marked as a holiday. No bookings.';

  @override
  String get markHoliday => 'Mark holiday';

  @override
  String get removeHoliday => 'Remove holiday';

  @override
  String get blockTime => 'Block time';

  @override
  String timeBlocked(String time) {
    return 'Blocked from $time';
  }

  @override
  String get workingHours => 'Working hours';

  @override
  String get opens => 'Opens';

  @override
  String get closes => 'Closes';

  @override
  String get hoursAppliesMonSat =>
      'These hours apply Monday to Saturday. Sunday stays as it is.';

  @override
  String slotSettings(int slot, int buffer, int capacity) {
    return '$slot-min slots · $buffer-min buffer · $capacity per slot';
  }

  @override
  String get slotLength => 'Slot length (minutes)';

  @override
  String get bufferTime => 'Buffer between slots (minutes)';

  @override
  String get capacityPerSlot => 'Pets per slot';

  @override
  String get noRequestsPartner => 'No booking requests right now.';

  @override
  String get waitingForOwner => 'Waiting for the owner';

  @override
  String get chooseTimeToAccept => 'Pick a time to accept';

  @override
  String get suggestTime => 'Suggest another time';

  @override
  String get suggestionSent => 'New time sent to the owner';

  @override
  String requestAccepted(String pet) {
    return 'Booking for $pet confirmed';
  }

  @override
  String declineRequestQ(String pet) {
    return 'Decline the request for $pet?';
  }

  @override
  String get services => 'Services';

  @override
  String get servicesHelp =>
      'Set your prices, duration and how owners can book. Changes show in the app right away.';

  @override
  String get priceRupees => 'Price (₹)';

  @override
  String get minutes => 'Minutes';

  @override
  String get bookingMode => 'Booking mode';

  @override
  String get paymentOptions => 'Payment options';

  @override
  String get saved => 'Saved';

  @override
  String get addVet => 'Add a vet';

  @override
  String get vcRegNumber => 'Veterinary Council reg. number';

  @override
  String get vcRegHelp =>
      'PawSetu verifies this before the vet can take bookings.';

  @override
  String get vetAddedPending => 'Vet added. Waiting for verification.';

  @override
  String get reply => 'Reply';

  @override
  String get yourReply => 'Your reply';

  @override
  String get postReply => 'Post reply';

  @override
  String get totalPayouts => 'Total payouts';

  @override
  String get payoutPending => 'Pending';

  @override
  String get settled => 'Settled';

  @override
  String get payoutHistory => 'Payout history';

  @override
  String get noPayoutsYet => 'No payouts yet.';

  @override
  String commissionLine(String amount) {
    return 'Commission $amount';
  }

  @override
  String get demoPayoutsNote => 'Demo payouts. No real money moves.';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusPendingApproval => 'Pending approval';

  @override
  String get kycDocuments => 'KYC documents';

  @override
  String get uploadKyc => 'Upload document';

  @override
  String get kycUploaded => 'Document uploaded for review';

  @override
  String get emergencyPhone => 'Emergency phone';

  @override
  String get emergencySettingsHelp =>
      '24x7 clinics appear first in SOS. Keep your emergency number up to date.';

  @override
  String get allowEnquiries => 'Take emergency calls now';

  @override
  String get allowEnquiriesHint =>
      'Turn off if you\'re full. Owners will see the next clinic.';

  @override
  String get startService => 'Start';

  @override
  String get markCompleted => 'Mark completed';

  @override
  String get sendPhotoUpdate => 'Send photo update';

  @override
  String defaultUpdateText(String pet) {
    return '$pet is doing great!';
  }

  @override
  String updateSent(String name) {
    return 'Update sent to $name';
  }

  @override
  String get partnerCancelNote =>
      'The owner gets a full refund and a notification.';

  @override
  String get messageOwner => 'Message the owner';

  @override
  String get partnerSignupLink => 'Run a pet business? Join as a partner';

  @override
  String get partnerSignupTitle => 'Join PawSetu as a partner';

  @override
  String get partnerSignupSubtitle =>
      'For clinics, groomers, trainers, boarding, walkers and pet shops. Free to join.';

  @override
  String get businessType => 'What kind of business?';

  @override
  String get kindSeller => 'Pet shop';

  @override
  String get businessName => 'Business name';

  @override
  String get areaCity => 'Area and city';

  @override
  String get businessPhone => 'Business phone';

  @override
  String get businessAddress => 'Address (optional)';

  @override
  String get kycHelp =>
      'Add an ID proof and your business registration. PawSetu checks them before your listing goes live.';

  @override
  String get useSampleDoc => 'Use a sample document (demo)';

  @override
  String get sampleIdProof => 'ID proof (sample)';

  @override
  String get kycNeeded => 'Add at least one document.';

  @override
  String get yourAccount => 'Your account';

  @override
  String get submitApplication => 'Submit application';

  @override
  String get partnerApprovalNote =>
      'After you submit, your listing waits for approval. You can set up services and prices meanwhile.';

  @override
  String get remove => 'Remove';

  @override
  String get aiTitle => 'Ask PawSetu';

  @override
  String get aiIntroTitle => 'Quick answers to everyday pet questions';

  @override
  String get aiIntroBody =>
      'Ask about food, baths, vaccines, ticks and more. For anything serious, talk to a vet.';

  @override
  String get aiHint => 'Type your question';

  @override
  String get aiAsk => 'Ask';

  @override
  String get aiPopular => 'Popular questions';

  @override
  String get aiDisclaimer =>
      'General guidance only, not a diagnosis. Your vet knows your pet best.';

  @override
  String get aiNotDiagnosis =>
      'Not a diagnosis. If your pet seems unwell, talk to a vet.';

  @override
  String get aiUnknown =>
      'I don\'t have an answer for that yet. Try one of the popular questions, or ask a vet in tele-vet.';

  @override
  String get aiTalkToVet => 'Ask a vet';

  @override
  String get aiTalkToVetNow => 'Talk to a vet now';

  @override
  String get aiUnlimited => 'Unlimited with Plus';

  @override
  String aiLeft(int left, int limit) {
    return '$left of $limit questions left this month';
  }

  @override
  String aiLimitTitle(int limit) {
    return 'You\'ve used your $limit questions this month';
  }

  @override
  String aiLimitBody(String date) {
    return 'More questions on $date, or get unlimited questions with PawSetu Plus. Emergencies are always answered.';
  }

  @override
  String get aiRedFlagTitle => 'This could be an emergency';

  @override
  String aiRedFlagBody(String sign) {
    return '$sign needs a vet right away. Use SOS to reach the nearest open clinic, or talk to a vet now.';
  }

  @override
  String aiRedFlagShort(String sign) {
    return 'Possible emergency: $sign';
  }

  @override
  String aiTileHint(int left) {
    return 'Everyday questions answered instantly. $left left this month.';
  }

  @override
  String get aiTileHintPlus =>
      'Everyday questions answered instantly. Unlimited with Plus.';

  @override
  String get rfBreathing => 'Trouble breathing';

  @override
  String get rfCollapse => 'Collapse or fainting';

  @override
  String get rfSeizure => 'A seizure (fits)';

  @override
  String get rfPoisoning => 'Possible poisoning';

  @override
  String get rfBleeding => 'Heavy bleeding';

  @override
  String get rfBloat => 'A swollen, hard belly';

  @override
  String get rfHeatstroke => 'Heatstroke';

  @override
  String get rfUrine => 'Not passing urine';

  @override
  String get rfInjury => 'A serious injury';

  @override
  String get aiQBath => 'How often should I bathe my dog?';

  @override
  String get aiQFeeding => 'How much should I feed my pet?';

  @override
  String get aiQToxicFood => 'Which human foods are unsafe for pets?';

  @override
  String get aiQVaccines => 'Which vaccines does my pet need?';

  @override
  String get aiQDeworming => 'How often should I deworm?';

  @override
  String get aiQTicks => 'How do I prevent ticks and fleas?';

  @override
  String get aiQHeat => 'How do I keep my pet cool in summer?';

  @override
  String get aiQVomiting => 'My pet vomited. What should I do?';

  @override
  String get aiQDiarrhoea => 'My pet has loose motions. What should I do?';

  @override
  String get aiQNotEating => 'My pet is not eating. Should I worry?';

  @override
  String get aiQItching => 'Why does my dog keep scratching?';

  @override
  String get aiQLimping => 'My dog is limping. What should I do?';

  @override
  String get aiQLitter => 'My cat isn\'t using the litter box. Why?';

  @override
  String get aiQChewing => 'How do I stop my puppy chewing and biting?';

  @override
  String get aiQNails => 'How do I trim my pet\'s nails?';

  @override
  String get aiQTeeth => 'How do I look after my pet\'s teeth?';

  @override
  String get aiQBirdDiet => 'What should I feed my bird?';

  @override
  String get aiQRabbitDiet => 'What should I feed my rabbit?';

  @override
  String get aiQWeight => 'Is my pet overweight?';

  @override
  String get aiQAnxiety =>
      'My pet is scared of crackers and thunder. How can I help?';

  @override
  String get aiABath =>
      'Most dogs need a bath every 3 to 4 weeks; more often only if they get dirty or smelly. Use a dog shampoo (human shampoo can dry the skin), lukewarm water, and rinse well. Dry the ears and the coat fully, especially in the monsoon, to avoid fungal infections. Brushing a few times a week keeps the coat clean between baths. Cats rarely need baths.';

  @override
  String get aiAFeeding =>
      'It depends on your pet\'s weight, age and activity. Start with the amount on the food pack for your pet\'s ideal weight, split into 2 meals for adult dogs and cats (3 to 4 for puppies and kittens). Check the waist and ribs every few weeks: you should feel the ribs easily. Treats should be under a tenth of daily food. Keep fresh water out all the time. Your vet can suggest an exact amount.';

  @override
  String get aiAToxicFood =>
      'Never give chocolate, grapes or raisins, onion, garlic, xylitol (in some sugar-free gum and sweets), alcohol, caffeine, cooked bones, or very salty and spicy food. Many festival sweets contain chocolate, raisins or xylitol, so keep them out of reach. Cats are also harmed by lilies. If your pet has eaten any of these, use SOS or call a vet now, even if they seem fine.';

  @override
  String get aiAVaccines =>
      'Dogs need DHPPi with Leptospirosis (3 puppy doses from 6 to 8 weeks), anti-rabies at about 3 months, and yearly boosters. Cats need the tricat vaccine and anti-rabies, also with yearly boosters. Rabbits and birds usually don\'t need routine vaccines in India. Your pet\'s Health tab shows the full schedule, what\'s due and what\'s overdue. Your vet decides the final plan.';

  @override
  String get aiADeworming =>
      'Puppies and kittens: every 2 weeks until 3 months old, then monthly until 6 months. Adults: every 3 months. Weigh your pet before each dose, because the dose depends on weight. PawSetu reminds you when the next dose is due. Ask your vet which dewormer suits your pet.';

  @override
  String get aiATicks =>
      'Use a vet-recommended tick and flea preventive all year: a spot-on, a chewable tablet or a collar. Ticks are common in India, especially in the monsoon. Check ears, between the toes and under the collar after walks. Keep bedding clean and dry. Never use dog products on cats. If your pet is weak, has pale gums or a fever after tick bites, see a vet quickly.';

  @override
  String get aiAHeat =>
      'Walk early in the morning or after sunset, and test the road with your hand: if it\'s too hot for 5 seconds, it\'s too hot for paws. Keep cool water and shade available all day. Never leave a pet in a parked car. Flat-faced breeds like pugs and Persian cats overheat fastest. Heavy panting, drooling, wobbling or bright red gums are signs of heatstroke: use SOS.';

  @override
  String get aiAVomiting =>
      'One vomit with a normal, playful pet often settles: remove food for a few hours (not water), then give small, bland meals like boiled rice with boiled chicken. See a vet the same day if vomiting repeats, there is blood, your pet is a puppy or kitten, seems weak, has a swollen belly, or may have eaten something toxic or a toy.';

  @override
  String get aiADiarrhoea =>
      'Keep fresh water available so your pet doesn\'t get dehydrated, and give small bland meals (boiled rice with boiled chicken or curd rice for dogs) for a day or two. Avoid milk and treats. See a vet if it lasts more than a day, there is blood or black stool, your pet is vomiting too, seems weak, or is a puppy or kitten.';

  @override
  String get aiANotEating =>
      'Skipping one meal can happen with heat, stress or a change in food. Offer fresh food and water and watch for other signs. See a vet if a dog doesn\'t eat for more than a day, a cat for more than 24 hours, a rabbit for even a few hours (rabbits get sick quickly), or if there is vomiting, weakness, pain or a fever.';

  @override
  String get aiAItching =>
      'Common causes are fleas and ticks, skin infections (often in the monsoon), food or dust allergies, and dry skin from frequent baths. Check the skin for ticks, redness, bald patches or a smell. Keep up tick and flea prevention and dry your dog well after baths and rain. If scratching goes on for more than a few days or the skin is broken, see a vet.';

  @override
  String get aiALimping =>
      'Check the paw for thorns, glass, cuts, a broken nail or a tick between the toes, and look for swelling. Rest your dog: short toilet walks only, no running or jumping, for a day. Never give human painkillers; many are poisonous to pets. See a vet if the limp lasts more than a day, your dog can\'t put weight on the leg, cries in pain, or after a fall or accident.';

  @override
  String get aiALitter =>
      'Keep the box clean (scoop daily), in a quiet spot away from food, with one box per cat plus one extra. Some cats dislike scented litter or covered boxes. Stress, like a new pet or a move, can also cause it. A cat straining in the box with little or no urine is an emergency, especially a male cat: use SOS.';

  @override
  String get aiAChewing =>
      'Puppies explore with their mouths and chew more while teething (3 to 6 months). Give safe chew toys and swap them in when your puppy grabs something else. If they nip, stop play for a few seconds, then continue gently. Praise calm play. Keep wires, shoes and medicines out of reach. Plenty of walks and play reduce chewing. A trainer can help if it continues after 6 months.';

  @override
  String get aiANails =>
      'Trim every 3 to 4 weeks, or when you hear nails clicking on the floor. Use pet nail clippers and cut only the tip, below the pink quick (on dark nails, take tiny slices). Keep styptic powder or plain cornflour ready in case of bleeding. Reward with a treat after each paw. If your pet hates it, a groomer or vet can do it in minutes. Birds and rabbits need nail trims too.';

  @override
  String get aiATeeth =>
      'Brush your dog\'s or cat\'s teeth 2 to 3 times a week with a pet toothbrush and pet toothpaste (human toothpaste is not safe to swallow). Start slowly with a finger brush and lots of praise. Dental chews help a little. Bad breath, red gums, a broken tooth or dropping food can mean dental disease: book a dental check with your vet.';

  @override
  String get aiABirdDiet =>
      'Seeds alone are not enough. Cockatiels and budgies do best on good-quality pellets with fresh vegetables daily (spinach, carrot, beans, peas) and small amounts of fruit, plus a little seed as a treat. Give fresh water every day. Never give avocado, chocolate, caffeine, salt or onion. Many parrot species are protected in India; only keep legally allowed birds.';

  @override
  String get aiARabbitDiet =>
      'Hay should be about 80% of a rabbit\'s diet, available all day: it keeps teeth and gut healthy. Add a handful of leafy greens (coriander, mint, lettuce, carrot tops) daily, a small amount of rabbit pellets, and fruit only as a rare treat. Always keep fresh water. A rabbit that stops eating or pooping for even a few hours needs a vet urgently.';

  @override
  String get aiAWeight =>
      'Feel the ribs: you should feel them easily under a thin layer, and see a waist from above. If you can\'t, your pet may be overweight. Weigh your pet monthly in PawSetu to see the trend against the healthy range for the breed. Cut treats and table scraps, measure food, and add a little more walking or play. Ask your vet before a big diet change.';

  @override
  String get aiAAnxiety =>
      'Before Diwali or a storm, make a quiet den: a covered crate or a corner with their bed, curtains closed, a fan or soft music on. Walk your dog early in the day and keep them indoors with ID tags on when crackers start. Stay calm and close, but don\'t force cuddles. Don\'t scold fear. For severe fear, ask your vet well in advance about calming options.';

  @override
  String get msgEmptyTitle => 'No chats yet';

  @override
  String get msgEmptyBody =>
      'Chats with your vet, clinic, groomer or walker show up here after you book or ask a question.';

  @override
  String get msgEmptyPartnerBody =>
      'Chats with pet parents show up here when they book or send an enquiry.';

  @override
  String get msgEmptyFilter => 'No chats in this list';

  @override
  String msgNoResults(String query) {
    return 'Nothing found for \"$query\"';
  }

  @override
  String get msgSearchHint => 'Search chats and messages';

  @override
  String get msgClearSearch => 'Clear search';

  @override
  String get msgFoundInMessages => 'Found in messages';

  @override
  String get msgEnquiries => 'Enquiries';

  @override
  String get msgEnquiry => 'Enquiry';

  @override
  String get msgMuted => 'Muted';

  @override
  String get msgNoMessagesYet => 'No messages yet';

  @override
  String msgUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread messages',
      one: '1 unread message',
    );
    return '$_temp0';
  }

  @override
  String get msgYouPrefix => 'You';

  @override
  String msgYou(String name) {
    return '$name (you)';
  }

  @override
  String get msgOpening => 'Opening the chat…';

  @override
  String get msgPickChat => 'Pick a chat';

  @override
  String get msgPickChatHint =>
      'Your conversations with vets, clinics and service providers open here.';

  @override
  String get msgPickChatHintPartner =>
      'Your conversations with pet parents open here.';

  @override
  String get msgNotFound => 'This chat is no longer available.';

  @override
  String get msgPreviewPhoto => 'Photo';

  @override
  String get msgPreviewPdf => 'PDF document';

  @override
  String get msgPreviewVoice => 'Voice note';

  @override
  String get msgClose => 'Close chat';

  @override
  String get msgChatInfo => 'Chat details';

  @override
  String get msgCallMasked => 'Call (number stays hidden)';

  @override
  String msgMaskedCallDemo(String name, String number) {
    return 'Demo mode doesn\'t place real calls. In the live app this calls $name through a masked number ($number), so neither of you sees the other\'s real number.';
  }

  @override
  String get msgMaskedCallLive =>
      'Calls go through a masked number, so neither side sees the other\'s real number.';

  @override
  String get msgMaskedInfo =>
      'Phone numbers are hidden in PawSetu chats and calls. Pay only inside the app.';

  @override
  String get msgMore => 'More options';

  @override
  String get msgSearchInChat => 'Search in chat';

  @override
  String msgMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
      zero: 'No matches',
    );
    return '$_temp0';
  }

  @override
  String get msgMute => 'Mute notifications';

  @override
  String get msgUnmute => 'Unmute notifications';

  @override
  String get msgMutedToast => 'Chat muted';

  @override
  String get msgUnmutedToast => 'Notifications on for this chat';

  @override
  String get msgBlock => 'Block';

  @override
  String get msgUnblock => 'Unblock';

  @override
  String msgBlockTitle(String name) {
    return 'Block $name?';
  }

  @override
  String get msgBlockBody =>
      'Neither of you can send messages in this chat until you unblock. Your bookings are not affected.';

  @override
  String get msgBlockedToast => 'Blocked';

  @override
  String get msgUnblockedToast => 'Unblocked';

  @override
  String get msgYouBlocked =>
      'You blocked this chat. Unblock it from the menu to send messages.';

  @override
  String get msgBlockedByOther =>
      'This chat is closed. You can\'t send messages here.';

  @override
  String get msgReport => 'Report';

  @override
  String get msgReportTitle => 'Report this chat';

  @override
  String get msgReportHint =>
      'PawSetu\'s team reviews every report, usually within a day.';

  @override
  String get msgReasonSpam => 'Spam or advertising';

  @override
  String get msgReasonAbuse => 'Rude or abusive';

  @override
  String get msgReasonPayment => 'Asked to pay outside PawSetu';

  @override
  String get msgReasonFake => 'Fake profile or scam';

  @override
  String get msgReasonOther => 'Something else';

  @override
  String get msgReportDetails => 'Details (optional)';

  @override
  String get msgReportSend => 'Send report';

  @override
  String get msgReportedToast => 'Thanks. We\'ll look into it.';

  @override
  String get msgGetHelp => 'Get help';

  @override
  String get msgTypingShort => 'typing…';

  @override
  String msgTyping(String name) {
    return '$name is typing…';
  }

  @override
  String get msgTypeHint => 'Type a message';

  @override
  String get msgSend => 'Send';

  @override
  String get msgAttach => 'Attach a photo or PDF';

  @override
  String get msgAttachTitle => 'Send a file';

  @override
  String get msgAttachPdf => 'PDF document';

  @override
  String get msgAttachPdfHint =>
      'Reports, prescriptions, certificates (up to 10 MB)';

  @override
  String get msgPdfTooBig =>
      'That file is over 10 MB. Please send a smaller PDF.';

  @override
  String get msgSendFailed =>
      'Couldn\'t send. Check your connection and try again.';

  @override
  String get msgNumberHiddenToast =>
      'Phone numbers are hidden in chats to keep everyone safe.';

  @override
  String get msgNumberHidden => 'Number hidden';

  @override
  String get msgPaymentWarnTitle => 'Pay only inside PawSetu';

  @override
  String get msgPaymentWarnBody =>
      'Your message looks like it has payment details (UPI ID, card number, OTP or PIN). Never share an OTP or PIN. Payments made outside PawSetu are not protected.';

  @override
  String get msgSendAnyway => 'Send anyway';

  @override
  String get msgSafetyNote =>
      'Numbers are hidden and payments stay inside PawSetu. Never share an OTP or PIN.';

  @override
  String get msgRecordVoice => 'Record a voice note';

  @override
  String msgRecording(String elapsed, String max) {
    return 'Recording $elapsed / $max';
  }

  @override
  String msgRecordingDemo(String elapsed) {
    return 'Demo recording $elapsed';
  }

  @override
  String get msgCancelRecording => 'Cancel recording';

  @override
  String get msgSendVoice => 'Send voice note';

  @override
  String get msgPlayVoice => 'Play voice note';

  @override
  String get msgPause => 'Pause';

  @override
  String get msgVoiceCantPlay =>
      'This voice note can\'t be played on this device.';

  @override
  String get msgMicUnavailableTitle => 'Microphone not available';

  @override
  String get msgMicUnavailable =>
      'Allow microphone access in your phone\'s settings to send voice notes.';

  @override
  String get msgMicDemoBody =>
      'The microphone isn\'t available here. Send a short demo voice note instead?';

  @override
  String get msgRecordDemo => 'Send demo voice note';

  @override
  String get msgSent => 'Sent';

  @override
  String get msgRead => 'Read';

  @override
  String get msgYesterday => 'Yesterday';

  @override
  String get msgDemoReply => 'Demo reply';

  @override
  String get msgPdf => 'PDF';

  @override
  String get msgTapToOpen => 'Tap to open';

  @override
  String get msgFileCantOpen => 'This file can\'t be opened here.';

  @override
  String get msgSampleStamp => 'Sample document · Demo';

  @override
  String get msgSampleDocBody =>
      'This is a sample document shared in a demo chat.';

  @override
  String msgSysBookingChat(String pet, String when) {
    return 'Chat for $pet\'s booking on $when';
  }

  @override
  String get msgSysTvStarted => 'Chat consultation requested';

  @override
  String get msgSysTvStartedVideo => 'Video consultation requested';

  @override
  String msgSysTvScheduled(String when) {
    return 'Consultation booked for $when';
  }

  @override
  String msgSysVetJoined(String name, String until) {
    return '$name joined. The chat stays open until $until.';
  }

  @override
  String get msgSysTvEnded => 'Consultation ended';

  @override
  String msgSysCallEnded(String duration) {
    return 'Video call ended · $duration';
  }

  @override
  String get msgYourPet => 'your pet';

  @override
  String demoReplyClinic(String pet) {
    return 'Thanks for your message. The clinic team will check $pet\'s details and get back to you shortly.';
  }

  @override
  String demoReplyVet(String pet) {
    return 'Thanks, noted. How is $pet eating and drinking today?';
  }

  @override
  String demoReplyGroomer(String pet) {
    return 'Sure! We\'ll take good care of $pet. Please bring any shampoo $pet is used to.';
  }

  @override
  String demoReplyWalker(String pet) {
    return 'Got it! I\'ll keep $pet on the shady side of the road and send you a photo.';
  }

  @override
  String demoReplyTrainer(String pet) {
    return 'Great question. Let\'s practise this with $pet in our next session.';
  }

  @override
  String demoReplyBoarder(String pet) {
    return '$pet is doing well and settling in nicely. I\'ll send a photo this evening.';
  }

  @override
  String demoReplyOwner(String name) {
    return 'Thank you! That helps a lot. – $name';
  }

  @override
  String demoReplyOwnerVet(String name) {
    return 'Thank you, Dr. $name! I\'ll follow that.';
  }

  @override
  String demoVetGreeting(String owner, String pet) {
    return 'Hello $owner, I\'m here. I\'ve read what you wrote about $pet. A few questions to start: since when, and is $pet eating and drinking normally?';
  }

  @override
  String ntfNewMessage(String name) {
    return 'New message from $name';
  }

  @override
  String ntfTeleVetMessage(String name) {
    return 'Tele-vet: new message from $name';
  }

  @override
  String get tvHomeTitle => 'Talk to a vet';

  @override
  String get tvHomeBody =>
      'Chat or video with a registered vet, usually within minutes.';

  @override
  String get tvStart => 'Start a consultation';

  @override
  String get tvEmergencyNote =>
      'Emergency? Don\'t wait for a chat. Use SOS to reach the nearest open clinic.';

  @override
  String get tvOpenConsults => 'Open consultations';

  @override
  String get tvPastConsults => 'Past consultations';

  @override
  String get tvPartnerHere => 'Tele-vet requests are in your portal';

  @override
  String get tvPlanFree => 'Your Free plan';

  @override
  String get tvPlanPlus => 'Your Plus plan';

  @override
  String get tvFreeChip => 'Free';

  @override
  String tvLinePerMonth(int limit, int used) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit consultations a month',
      one: '1 consultation a month',
    );
    return '$_temp0 · $used used';
  }

  @override
  String get tvLineUnlimited => 'Unlimited consultations';

  @override
  String tvLineMessages(int messages, int words) {
    return 'Up to $messages messages, $words words each';
  }

  @override
  String tvLineHours(int hours) {
    return 'Chat stays open $hours hours after the vet joins';
  }

  @override
  String get tvLineVideo => 'Video calls included, with 10% off';

  @override
  String get tvLineNoVideo => 'Video calls need Plus';

  @override
  String get tvMonthlyUsedTitle =>
      'You\'ve used this month\'s free consultation';

  @override
  String tvMonthlyUsed(String date) {
    return 'Your next free consultation opens on $date. With Plus you get unlimited chats and video calls.';
  }

  @override
  String get tvPlusPromptTitle => 'More time with vets';

  @override
  String get tvPlusHint =>
      'Plus gives you up to 100 messages of 300 words, 72 hours of chat and video calls.';

  @override
  String get tvVideoPlusTitle => 'Video calls are part of Plus';

  @override
  String get tvStatusQueuedShort => 'Waiting';

  @override
  String get tvStatusActiveShort => 'Open';

  @override
  String get tvStatusEndedShort => 'Ended';

  @override
  String get tvConsentTitle => 'Before you start';

  @override
  String get tvConsentIntro =>
      'Online consultations follow the Veterinary Council of India\'s guidelines. Please read and agree:';

  @override
  String get tvConsent1 =>
      'A vet gives advice from what you describe and show. It is not a full physical examination.';

  @override
  String get tvConsent2 =>
      'Every vet on PawSetu is registered with a State Veterinary Council. You\'ll see their registration number.';

  @override
  String get tvConsent3 =>
      'The vet may ask you to visit a clinic if your pet needs an examination or tests.';

  @override
  String get tvConsent4 =>
      'Tele-vet is not for emergencies. For trouble breathing, collapse, seizures, poisoning or heavy bleeding, use SOS.';

  @override
  String get tvConsent5 =>
      'Prescriptions are issued only when the vet thinks it is safe, and some medicines need a clinic visit.';

  @override
  String get tvConsent6 =>
      'Your chat, photos and your pet\'s records are shared only with the vet treating your pet.';

  @override
  String get tvConsentAgree => 'I have read and agree';

  @override
  String get tvConsentContinue => 'Continue';

  @override
  String get tvStepPet => 'Pet';

  @override
  String get tvStepProblem => 'Problem';

  @override
  String get tvStepHow => 'Vet';

  @override
  String get tvWhichPet => 'Which pet is this about?';

  @override
  String get tvNoPet => 'Add a pet first to talk to a vet.';

  @override
  String tvDescribe(String pet) {
    return 'What\'s happening with $pet?';
  }

  @override
  String get tvDescribeHint =>
      'When did it start, what you noticed, eating and drinking, anything they may have eaten';

  @override
  String get tvAddPhotos => 'Add photos';

  @override
  String get tvPhotosHint =>
      'Clear photos of the problem (a wound, rash, stool or vomit) help the vet a lot.';

  @override
  String get tvContinueToVet => 'Choose how to talk';

  @override
  String get tvChatNow => 'Chat now';

  @override
  String get tvChatNowHint =>
      'The next available vet joins, usually within minutes';

  @override
  String get tvVideoNow => 'Video call now';

  @override
  String get tvVideoNowHint => 'Show the vet your pet on a video call';

  @override
  String get tvVideoPlusOnly => 'Available with PawSetu Plus';

  @override
  String get tvChooseVet => 'Choose a vet';

  @override
  String get tvChooseVetHint =>
      'Pick a vet by language and experience, now or later today';

  @override
  String get tvModeChat => 'Chat';

  @override
  String get tvModeVideo => 'Video';

  @override
  String tvVideoFee(String amount) {
    return 'Video $amount';
  }

  @override
  String get tvWhen => 'When';

  @override
  String get tvNow => 'Now';

  @override
  String get tvTomorrow => 'Tomorrow';

  @override
  String get tvSummary => 'Summary';

  @override
  String get tvSummaryPet => 'Pet';

  @override
  String get tvSummaryType => 'Type';

  @override
  String get tvSummaryVet => 'Vet';

  @override
  String get tvNextAvailable => 'Next available vet';

  @override
  String get tvFee => 'Fee';

  @override
  String get tvIncluded => 'Included in your plan';

  @override
  String get tvVideoFeeLabel => 'Video consultation';

  @override
  String tvPlusDiscount(int percent) {
    return 'Plus discount ($percent%)';
  }

  @override
  String tvChatRules(int messages, int words, int hours) {
    return 'Up to $messages messages of $words words. The chat stays open $hours hours after the vet joins.';
  }

  @override
  String get tvStartChat => 'Start chat';

  @override
  String get tvStartVideo => 'Start video call';

  @override
  String tvPayAndStart(String amount) {
    return 'Pay $amount and start';
  }

  @override
  String tvPayDescription(String pet) {
    return 'Video consultation for $pet';
  }

  @override
  String tvFindingVet(String pet) {
    return 'Finding a vet for $pet…';
  }

  @override
  String get tvFindingVetHint =>
      'Most chats are picked up within a few minutes. We\'ll notify you.';

  @override
  String get tvFindingVetShort => 'Finding a vet…';

  @override
  String tvScheduledTitle(String when) {
    return 'Consultation at $when';
  }

  @override
  String get tvScheduledHint =>
      'The vet will join at this time. You can add details before then.';

  @override
  String get tvStatusQueued => 'Waiting for a vet';

  @override
  String get tvStatusActive => 'Consultation open';

  @override
  String get tvStatusEnded => 'Consultation ended';

  @override
  String tvOpenUntil(String time) {
    return 'Open until $time';
  }

  @override
  String tvMessagesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages left',
      one: '1 message left',
      zero: 'No messages left',
    );
    return '$_temp0';
  }

  @override
  String get tvPriority => 'Priority (Plus)';

  @override
  String get tvVideoCall => 'Video call';

  @override
  String get tvClosedShort => 'Chat closed';

  @override
  String tvEndedWith(String vet) {
    return 'Ended · $vet';
  }

  @override
  String tvVetBarTitle(String pet, String owner) {
    return '$pet · $owner';
  }

  @override
  String get tvRate => 'Rate this consultation';

  @override
  String tvRateTitle(String vet) {
    return 'How was your chat with $vet?';
  }

  @override
  String get tvRateComment => 'Anything to add? (optional)';

  @override
  String get tvRateSubmit => 'Submit rating';

  @override
  String get tvRateThanks => 'Thanks for rating!';

  @override
  String tvStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String tvAllowanceLine(int words, int max, int left) {
    return '$words/$max words · $left messages left';
  }

  @override
  String tvWordsOver(int words, int max) {
    return '$words/$max words. Please shorten your message.';
  }

  @override
  String tvWordsTitle(int max) {
    return 'Messages can have up to $max words';
  }

  @override
  String tvWordsBody(int words, int max) {
    return 'Your message has $words words, the limit is $max. Split it into shorter messages or keep just the key points; the vet can ask for more.';
  }

  @override
  String get tvEditMessage => 'Edit message';

  @override
  String tvNoMessagesTitle(int count) {
    return 'You\'ve used all $count messages';
  }

  @override
  String get tvNoMessagesBody =>
      'The vet can still reply and send a prescription. For more questions, start a new consultation.';

  @override
  String get tvClosedTitle => 'This chat has closed';

  @override
  String tvClosedBanner(int hours) {
    return 'Chats stay open for $hours hours after the vet joins. Start a new consultation if you need more help.';
  }

  @override
  String get tvEndedTitle => 'Consultation ended';

  @override
  String get tvEndedBanner =>
      'The vet ended this consultation. Your chat and any prescription stay in your pet\'s records.';

  @override
  String get tvProblemLabel => 'Problem described';

  @override
  String get tvBookVisit => 'Book a clinic visit';

  @override
  String tvRecVisitMsg(String name) {
    return '$name recommends a clinic visit for an examination.';
  }

  @override
  String tvRecEmergencyMsg(String name) {
    return '$name says this needs emergency care now. Use SOS to reach the nearest open clinic.';
  }

  @override
  String get tvConnecting => 'Connecting…';

  @override
  String get tvWaitingVetJoin => 'Waiting for the vet to join…';

  @override
  String get tvDemoCall => 'DEMO CALL';

  @override
  String get tvGoodNetwork => 'Good connection';

  @override
  String get tvWeakNetwork => 'Weak connection';

  @override
  String tvRemoteVideo(String name) {
    return 'Video of $name';
  }

  @override
  String get tvSelfView => 'Your camera';

  @override
  String get tvCameraOff => 'Camera is off';

  @override
  String get tvCameraOffAction => 'Turn camera off';

  @override
  String get tvCameraOnAction => 'Turn camera on';

  @override
  String get tvMute => 'Mute';

  @override
  String get tvUnmute => 'Unmute';

  @override
  String get tvSpeakerOn => 'Speaker on';

  @override
  String get tvSpeakerOff => 'Speaker off';

  @override
  String get tvSwitchCamera => 'Switch camera';

  @override
  String get tvFrontCamera => 'Front camera';

  @override
  String get tvBackCamera => 'Back camera';

  @override
  String get tvEndCall => 'End call';

  @override
  String tvCallEndedToast(String duration) {
    return 'Call ended · $duration';
  }

  @override
  String get tvCallFailed => 'The call couldn\'t connect.';

  @override
  String get tvCallLiveLater =>
      'Real video calls arrive with the live version of PawSetu. Keep chatting with the vet meanwhile.';

  @override
  String get tvQueueTitle => 'Tele-vet queue';

  @override
  String get tvQueueHint =>
      'Plus members and urgent cases come first. Accept a request to start the chat.';

  @override
  String get tvQueueEmpty => 'No one is waiting right now.';

  @override
  String get tvWaiting => 'Waiting';

  @override
  String get tvInProgress => 'In progress';

  @override
  String get tvDoneToday => 'Done today';

  @override
  String get tvPrescriptionsWritten => 'Prescriptions';

  @override
  String get tvNoActive => 'No open consultations.';

  @override
  String get tvRecent => 'Recent';

  @override
  String get tvUrgent => 'Urgent';

  @override
  String get tvAskedForYou => 'Asked for you';

  @override
  String tvWaitingFor(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Waiting $minutes min',
      one: 'Waiting 1 min',
      zero: 'Just now',
    );
    return '$_temp0';
  }

  @override
  String tvScheduledFor(String when) {
    return 'Booked for $when';
  }

  @override
  String get tvAccept => 'Accept';

  @override
  String get tvView => 'View';

  @override
  String tvAcceptHint(String pet) {
    return 'Accept to start chatting about $pet. The pet parent is notified.';
  }

  @override
  String get tvTabChat => 'Chat';

  @override
  String get tvTabHistory => 'History';

  @override
  String get tvTabTools => 'Notes and tools';

  @override
  String get tvOpenVetTools => 'Open vet tools';

  @override
  String tvUrgentSign(String sign) {
    return 'Urgent sign: $sign';
  }

  @override
  String get tvFreeContext =>
      'Free plan: you see the basic profile. Plus members share their full health history.';

  @override
  String get tvTemperament => 'Temperament';

  @override
  String get tvRecentHealth => 'Recent health records';

  @override
  String get tvNone => 'None';

  @override
  String get tvPrivateNotes => 'Private notes';

  @override
  String get tvPrivateNotesHint => 'Only you can see these notes.';

  @override
  String get tvNotesPlaceholder => 'Findings, differentials, plan…';

  @override
  String get tvRecommend => 'Recommend';

  @override
  String get tvRecVisit => 'Clinic visit';

  @override
  String get tvRecEmergency => 'Emergency care';

  @override
  String tvRecVisitConfirm(String name) {
    return 'Tell $name to bring their pet to a clinic for an examination?';
  }

  @override
  String tvRecEmergencyConfirm(String name) {
    return 'Tell $name this needs emergency care now? They\'ll see the SOS button.';
  }

  @override
  String get tvRecSent => 'Recommendation sent';

  @override
  String get tvRecDoneVisit => 'Clinic visit recommended';

  @override
  String get tvRecDoneEmergency => 'Emergency care recommended';

  @override
  String get tvSend => 'Send';

  @override
  String get tvEnd => 'End consultation';

  @override
  String get tvEndTitle => 'End this consultation?';

  @override
  String get tvEndBody =>
      'The pet parent can no longer send messages. The chat and prescription stay in their records.';

  @override
  String get tvEndBodyNoRx =>
      'You haven\'t written a prescription. End anyway? The pet parent can no longer send messages.';

  @override
  String get tvEndedToast => 'Consultation ended';

  @override
  String get tvVetSafetyNote =>
      'Ask for a clinic visit when an examination or tests are needed. Don\'t share personal phone numbers.';

  @override
  String get rxWrite => 'Write prescription';

  @override
  String rxTitleOf(String pet) {
    return 'Prescription for $pet';
  }

  @override
  String get rxTitle => 'E-prescription';

  @override
  String rxRegNo(String number) {
    return 'Reg. no. $number';
  }

  @override
  String get rxDiagnosis => 'Diagnosis or assessment';

  @override
  String get rxDiagnosisHint => 'E.g. mild gastritis';

  @override
  String get rxMedicines => 'Medicines';

  @override
  String rxMedicineN(int n) {
    return 'Medicine $n';
  }

  @override
  String get rxMedicine => 'Medicine and strength';

  @override
  String get rxMedicineHint => 'E.g. Ondansetron 4 mg tablet';

  @override
  String get rxDoseHint => 'Dose, e.g. half a tablet';

  @override
  String get rxFreqOnce => 'Once a day';

  @override
  String get rxFreqTwice => 'Twice a day';

  @override
  String get rxFreqThrice => 'Three times a day';

  @override
  String get rxFreqNeeded => 'When needed';

  @override
  String get rxDuration => 'Duration';

  @override
  String rxDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get rxInstructions => 'Instructions';

  @override
  String get rxAfterFood => 'After food';

  @override
  String get rxBeforeFood => 'Before food';

  @override
  String get rxApplyThin => 'Apply a thin layer';

  @override
  String get rxAddMedicine => 'Add medicine';

  @override
  String get rxNeedMedicine => 'Add at least one medicine.';

  @override
  String get rxAdvice => 'Advice for the pet parent';

  @override
  String get rxAdviceHint => 'Diet, rest, what to watch for, when to come back';

  @override
  String get rxAddFollowUp => 'Add a follow-up date';

  @override
  String rxFollowUpOn(String date) {
    return 'Follow-up on $date';
  }

  @override
  String get rxFollowUp => 'Follow-up';

  @override
  String get rxNoFollowUp => 'No follow-up needed';

  @override
  String rxWhereItGoes(String pet) {
    return 'It goes to $pet\'s health records and the pet parent\'s vault, with a reminder for any follow-up.';
  }

  @override
  String get rxPreview => 'Preview';

  @override
  String get rxSignTitle => 'Sign and send?';

  @override
  String rxSignBody(String owner, String pet) {
    return 'This prescription will be signed digitally with your registration number and sent to $owner for $pet.';
  }

  @override
  String get rxSignSend => 'Sign and send';

  @override
  String rxSentToast(String owner, String pet) {
    return 'Prescription sent to $owner for $pet';
  }

  @override
  String rxSaved(String pet) {
    return 'Saved to $pet\'s health records';
  }

  @override
  String rxCardTitle(String vet) {
    return 'Prescription from $vet';
  }

  @override
  String get rxView => 'View prescription';

  @override
  String get rxSentPreview => 'Prescription';

  @override
  String get rxPatient => 'Patient';

  @override
  String get rxPetName => 'Name';

  @override
  String get rxSpeciesBreed => 'Species and breed';

  @override
  String rxSignedDigitally(String when) {
    return 'Signed digitally on $when';
  }

  @override
  String get rxFooter =>
      'PawSetu e-prescription · Demo data · Valid only with the vet\'s registration number';

  @override
  String rxDocTitle(String pet, String date) {
    return 'Prescription for $pet, $date';
  }

  @override
  String rxEventTitle(String vet) {
    return 'Tele-vet consultation with $vet';
  }

  @override
  String rxEventNotes(String medicines) {
    return 'Prescribed: $medicines';
  }

  @override
  String rxFollowUpReminder(String pet, String vet) {
    return 'Follow-up for $pet with $vet';
  }

  @override
  String ntfTeleVetRequest(String pet, String owner) {
    return 'New tele-vet request: $pet ($owner)';
  }

  @override
  String ntfVetJoined(String vet, String pet) {
    return '$vet joined your chat about $pet';
  }

  @override
  String ntfConsultEnded(String pet) {
    return 'Tele-vet consultation for $pet has ended';
  }

  @override
  String ntfPrescription(String vet, String pet) {
    return '$vet sent a prescription for $pet';
  }

  @override
  String get albumPhotos => 'Photos';

  @override
  String get albumTimeline => 'Timeline';

  @override
  String get albumAlbums => 'Albums';

  @override
  String get albumFavourites => 'Favourites';

  @override
  String get albumAdd => 'Add photos or videos';

  @override
  String albumAddTitle(String pet) {
    return 'Add to $pet\'s album';
  }

  @override
  String albumAddFirst(String pet) {
    return 'Add the first photo of $pet';
  }

  @override
  String get albumChoosePhotos => 'Choose photos';

  @override
  String get albumChooseVideo => 'Choose a video';

  @override
  String get albumRecordVideo => 'Record a video';

  @override
  String get albumCaption => 'Caption';

  @override
  String get albumCaptionHint => 'What\'s happening in this moment?';

  @override
  String get albumDateTaken => 'Date taken';

  @override
  String get albumMilestone => 'Milestone';

  @override
  String get albumNoMilestone => 'No milestone';

  @override
  String get albumAddMilestone => 'Mark as a milestone';

  @override
  String get albumMilestoneTitle => 'Milestone name';

  @override
  String get albumMilestoneTitleHint => 'E.g. First swim';

  @override
  String get albumMsGotcha => 'Gotcha day';

  @override
  String get albumMsFirstWalk => 'First walk';

  @override
  String get albumMsFirstVaccine => 'First vaccine';

  @override
  String get albumMsBirthday => 'Birthday';

  @override
  String get albumMsCustom => 'Special moment';

  @override
  String get albumNewAlbum => 'New album';

  @override
  String get albumAlbumName => 'Album name';

  @override
  String get albumUploading => 'Adding your memories…';

  @override
  String albumPhotosAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories added',
      one: '1 memory added',
    );
    return '$_temp0';
  }

  @override
  String albumSaved(String pet) {
    return 'Saved to $pet\'s album';
  }

  @override
  String albumAddedToAlbum(String album) {
    return 'Added to $album';
  }

  @override
  String get albumStorageNote =>
      'Photos and videos use your plan\'s storage. Videos up to 1 minute on Free, 3 minutes on Plus.';

  @override
  String albumVideoMaxSec(int seconds) {
    return 'Videos up to $seconds seconds';
  }

  @override
  String get albumVideoTooLongTitle => 'This video is too long';

  @override
  String albumVideoTooLong(int seconds, int limit) {
    return 'It\'s $seconds seconds; your plan allows $limit.';
  }

  @override
  String get albumVideoPlusBody =>
      'Trim it on your phone, or get 3-minute videos with PawSetu Plus.';

  @override
  String get albumEmptyTitle => 'No memories yet';

  @override
  String albumEmptyBody(String pet) {
    return 'Add $pet\'s photos and videos. They\'re grouped by month, with milestones on a timeline.';
  }

  @override
  String albumMonthCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories',
      one: '1 memory',
    );
    return '$_temp0';
  }

  @override
  String get albumOnThisDay => 'On this day';

  @override
  String get albumLatestMemory => 'Latest memory';

  @override
  String albumOfPet(String pet) {
    return 'A moment with $pet';
  }

  @override
  String get albumSeeAlbum => 'See album';

  @override
  String albumYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String albumTimelineBorn(String pet) {
    return '$pet was born';
  }

  @override
  String albumTimelineEmpty(String pet) {
    return 'Mark milestones while adding photos and $pet\'s story appears here.';
  }

  @override
  String get albumCelebrate => 'Celebrate';

  @override
  String get albumBadges => 'Milestone badges';

  @override
  String get albumBadgeLocked => 'not yet';

  @override
  String get albumNoAlbums => 'No albums yet';

  @override
  String get albumNoAlbumsBody =>
      'Group memories into albums like \"Goa trip\" or \"First year\".';

  @override
  String get albumNoFavourites => 'No favourites yet';

  @override
  String get albumNoFavouritesBody =>
      'Tap the heart on a photo to keep it here.';

  @override
  String albumChooseForAlbum(String album) {
    return 'Choose memories for $album';
  }

  @override
  String albumItemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get albumRenameAlbum => 'Rename album';

  @override
  String get albumDeleteAlbum => 'Remove album';

  @override
  String albumDeleteAlbumBody(String pet) {
    return 'The photos stay in $pet\'s album. Only this group is removed.';
  }

  @override
  String get albumRemoveFromAlbum => 'Remove from album';

  @override
  String get albumVideo => 'Video';

  @override
  String albumOfCount(int index, int total) {
    return '$index of $total';
  }

  @override
  String get albumClose => 'Close';

  @override
  String get albumPrevious => 'Previous';

  @override
  String get albumFavourite => 'Add to favourites';

  @override
  String get albumUnfavourite => 'Remove from favourites';

  @override
  String get albumEditCaption => 'Edit caption';

  @override
  String get albumAddToAlbum => 'Add to album';

  @override
  String get albumShare => 'Share';

  @override
  String get albumDelete => 'Delete';

  @override
  String get albumDeleteQ => 'Delete this memory?';

  @override
  String albumDeleteBody(String pet) {
    return 'It will be removed from $pet\'s album for everyone in the family.';
  }

  @override
  String get albumDeleted => 'Memory deleted';

  @override
  String albumAddedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get albumPlay => 'Play';

  @override
  String get albumPause => 'Pause';

  @override
  String get albumVideoFailed => 'This video can\'t be played here.';

  @override
  String get albumDemoVideo =>
      'Demo video: a sample clip stands in for the real file.';

  @override
  String get albumShareTitle => 'Share memories';

  @override
  String get albumShareBody =>
      'Send to WhatsApp or any app, or make a private link for family.';

  @override
  String get albumShareToApps => 'Share to apps';

  @override
  String get albumShareFailed => 'Couldn\'t share. Please try again.';

  @override
  String get albumWatermark => 'Add a PawSetu watermark';

  @override
  String get albumWatermarkPhotosOnly =>
      'Photos only; videos are shared as they are.';

  @override
  String get albumWatermarkText => 'Made with PawSetu';

  @override
  String get albumFamilyLink => 'Private family link';

  @override
  String albumFamilyLinkBody(String pet) {
    return 'Anyone with the link can view these memories of $pet until it expires. You can stop it any time.';
  }

  @override
  String get albumFamilyLinkWhich => 'What to share';

  @override
  String get albumWholeAlbum => 'The whole album';

  @override
  String albumFamilyLinkText(String pet, String url) {
    return 'Photos of $pet on PawSetu: $url';
  }

  @override
  String albumSharedBy(String owner, String pet) {
    return '$owner shared memories of $pet';
  }

  @override
  String get albumBirthdayScreenTitle => 'Birthday';

  @override
  String albumBirthdayToday(String pet) {
    return 'Happy birthday, $pet!';
  }

  @override
  String albumBirthdayIn(int days, String pet, int age) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$pet turns $age in $days days',
      one: '$pet turns $age tomorrow',
    );
    return '$_temp0';
  }

  @override
  String albumBirthdaySubtitle(int age, String pet) {
    return '$pet is $age today';
  }

  @override
  String albumBirthdayWishes(String pet) {
    return 'Wishing $pet lots of walks, treats and cuddles this year!';
  }

  @override
  String get albumBirthdayMemories => 'Memories from this year';

  @override
  String get albumBirthdayAddPhoto => 'Add a birthday photo';

  @override
  String albumBirthdayReminder(String pet) {
    return 'Remind me before $pet\'s birthday';
  }

  @override
  String albumBirthdayReminderTitle(String pet) {
    return '$pet\'s birthday is coming up';
  }

  @override
  String get albumBirthdayReminderOn => 'Birthday reminder on';

  @override
  String albumNoBirthday(String pet) {
    return 'Add $pet\'s birthday to celebrate it here.';
  }

  @override
  String get vaultSetupTitle => 'Protect your vault';

  @override
  String get vaultSetupBody =>
      'Choose a 4 to 6 digit PIN. You\'ll enter it each time you open the vault.';

  @override
  String get vaultSetupBodyBio =>
      'Choose a 4 to 6 digit PIN as a backup. You can then unlock with your fingerprint or face.';

  @override
  String get vaultChoosePin => 'Choose a PIN';

  @override
  String get vaultConfirmPin => 'Enter the PIN again';

  @override
  String get vaultCurrentPin => 'Current PIN';

  @override
  String get vaultSetPinButton => 'Set PIN';

  @override
  String get vaultPinMismatch => 'The PINs don\'t match. Try again.';

  @override
  String get vaultPinWeak =>
      'That PIN is easy to guess. Avoid 1234 or repeated digits.';

  @override
  String get vaultPinSet => 'Vault PIN set';

  @override
  String get vaultPinChanged => 'PIN changed';

  @override
  String get vaultChangePin => 'Change PIN';

  @override
  String vaultPinDigits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digits entered',
      one: '1 digit entered',
      zero: 'No digits entered',
    );
    return '$_temp0';
  }

  @override
  String get vaultPinBackspace => 'Delete last digit';

  @override
  String get vaultLockedTitle => 'Vault locked';

  @override
  String get vaultLockedBody =>
      'Your pet\'s documents are protected. Unlock to continue.';

  @override
  String get vaultUnlock => 'Unlock';

  @override
  String get vaultUseBiometrics => 'Use fingerprint or face';

  @override
  String get vaultBiometricReason => 'Unlock your PawSetu document vault';

  @override
  String get vaultBiometricsToggle => 'Unlock with fingerprint or face';

  @override
  String get vaultWrongPin => 'Wrong PIN.';

  @override
  String vaultTriesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tries left.',
      one: '1 try left.',
    );
    return '$_temp0';
  }

  @override
  String vaultLockedOut(int seconds) {
    return 'Too many wrong tries. Try again in $seconds seconds.';
  }

  @override
  String get vaultForgotPin => 'Forgot PIN?';

  @override
  String get vaultForgotPinTitle => 'Reset your vault PIN';

  @override
  String get vaultForgotPinBody =>
      'Sign in again to prove it\'s you, then choose a new PIN. Your documents stay safe.';

  @override
  String get vaultSignInAgain => 'Sign in again';

  @override
  String get vaultAutoLockNote =>
      'The vault locks itself after 2 minutes away.';

  @override
  String get vaultLockNow => 'Lock now';

  @override
  String get vaultLockSettings => 'Vault lock';

  @override
  String vaultOfPet(String pet) {
    return '$pet\'s documents';
  }

  @override
  String get vaultAllDocs => 'All documents';

  @override
  String vaultDocCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0';
  }

  @override
  String get vaultSearchHint => 'Search titles, tags or vets';

  @override
  String get vaultClearSearch => 'Clear search';

  @override
  String get vaultNeedsAttention => 'Needs attention';

  @override
  String get vaultNeedsReview => 'Check details';

  @override
  String vaultAddedOn(String date) {
    return 'Added $date';
  }

  @override
  String get vaultEmptyTitle => 'Your vault is empty';

  @override
  String get vaultEmptyBody =>
      'Keep vaccination certificates, prescriptions, lab reports and insurance safe in one place.';

  @override
  String get vaultAddDocument => 'Add document';

  @override
  String get vaultStorageTitle => 'Storage';

  @override
  String vaultStorageUsed(String used, String limit) {
    return '$used of $limit used';
  }

  @override
  String vaultStorageSplit(String docs, String album) {
    return 'Documents $docs · Album $album';
  }

  @override
  String get vaultStorageFullTitle => 'Storage full';

  @override
  String vaultStorageFullBody(String used, String limit) {
    return 'You\'ve used $used of $limit. Delete old files or get 25 GB with PawSetu Plus.';
  }

  @override
  String vaultStorageFullBodyPlus(String used, String limit) {
    return 'You\'ve used $used of $limit. Delete old files to make room.';
  }

  @override
  String get vaultTooBig =>
      'That file is too big. Please choose one under 20 MB.';

  @override
  String get vaultTypeVaccination => 'Vaccination certificate';

  @override
  String get vaultTypePrescription => 'Prescription';

  @override
  String get vaultTypeLab => 'Lab report';

  @override
  String get vaultTypeInsurance => 'Insurance';

  @override
  String get vaultTypeInvoice => 'Bill or invoice';

  @override
  String get vaultTypeLicence => 'Municipal licence';

  @override
  String get vaultTypeAdoption => 'Adoption or purchase papers';

  @override
  String get vaultTypeTravel => 'Travel or health certificate';

  @override
  String get vaultTypeOther => 'Other';

  @override
  String get vaultExpired => 'Expired';

  @override
  String get vaultExpiresSoon => 'Expires soon';

  @override
  String vaultExpiresOn(String date) {
    return 'Expires $date';
  }

  @override
  String vaultExpiredOn(String date) {
    return 'Expired $date';
  }

  @override
  String get vaultNoExpiry => 'No expiry date';

  @override
  String get vaultUploadTitle => 'Add a document';

  @override
  String get vaultForPet => 'For which pet?';

  @override
  String get vaultScanCamera => 'Scan with camera';

  @override
  String get vaultScanCameraHint =>
      'Edges are found for you; adjust the corners if needed';

  @override
  String get vaultFromGallery => 'Photo from gallery';

  @override
  String get vaultFromPdf => 'PDF file';

  @override
  String get vaultPdfOnly => 'Please choose a PDF file.';

  @override
  String get vaultTrySample => 'Demo: try a sample document to see auto-read';

  @override
  String get vaultSampleRabies => 'Sample rabies certificate';

  @override
  String get vaultSampleLab => 'Sample blood test report';

  @override
  String get vaultSampleInsurance => 'Sample insurance policy';

  @override
  String get vaultUploading => 'Saving securely…';

  @override
  String get vaultScanTitle => 'Adjust the scan';

  @override
  String get vaultScanHint => 'Drag the corners to the edges of the page.';

  @override
  String get vaultScanAuto => 'Page edges found. Adjust the corners if needed.';

  @override
  String get vaultScanBw => 'Black and white (sharper text)';

  @override
  String get vaultScanCorner => 'Corner handle, drag to adjust';

  @override
  String get vaultUseScan => 'Use this scan';

  @override
  String get vaultPreviewFailed => 'Couldn\'t show a preview of this file.';

  @override
  String get vaultReading => 'Reading the document…';

  @override
  String get vaultCheckDetails => 'Check the details';

  @override
  String get vaultCheckDetailsHint =>
      'We read these from the document. Please confirm or correct them.';

  @override
  String get vaultAddDetails => 'Add details';

  @override
  String get vaultFoundTitle => 'We found these details';

  @override
  String get vaultFoundBody =>
      'Check each field before saving. Nothing is saved until you confirm.';

  @override
  String get vaultNotFoundTitle => 'We couldn\'t read this one';

  @override
  String get vaultNotFoundBody =>
      'Add the details yourself, or skip and add them later.';

  @override
  String get vaultDemoReadNote =>
      'Demo auto-read: details come from the sample document, not a real scan of your file.';

  @override
  String vaultPetMismatch(String docPet, String pet) {
    return 'The document says $docPet, but you chose $pet. Check the pet before saving.';
  }

  @override
  String get vaultFieldDocType => 'Document type';

  @override
  String get vaultFieldTitle => 'Title';

  @override
  String get vaultFieldTags => 'Tags';

  @override
  String get vaultTagHint => 'E.g. rabies, 2026';

  @override
  String get vaultAddTag => 'Add tag';

  @override
  String vaultAddToHealth(String pet) {
    return 'Add to $pet\'s health records';
  }

  @override
  String get vaultAddToHealthHint =>
      'Records the vaccine, and the next dose is scheduled for you.';

  @override
  String get vaultVaccineNeeded =>
      'Add the vaccine name and the date given to save it to health records.';

  @override
  String get vaultTrackInsurance => 'Track this policy in insurance';

  @override
  String get vaultExpiryReminderNote =>
      'We\'ll remind you 30 days before it expires.';

  @override
  String get vaultSaveDetails => 'Save';

  @override
  String get vaultSkipDetails => 'Skip for now';

  @override
  String get vaultSaved => 'Saved to the vault';

  @override
  String vaultSavedVaccine(String vaccine, String pet) {
    return '$vaccine recorded for $pet';
  }

  @override
  String vaultReminderTitle(String title, String pet) {
    return '$title for $pet expires soon';
  }

  @override
  String vaultTitleVaccineCert(String vaccine) {
    return '$vaccine certificate';
  }

  @override
  String vaultTitlePolicy(String insurer) {
    return '$insurer policy';
  }

  @override
  String get vaultDocDetails => 'Document details';

  @override
  String get vaultDetailsRead => 'Details';

  @override
  String get vaultEditDetails => 'Edit details';

  @override
  String vaultConfirmedBy(String name, String date) {
    return 'Checked by $name on $date';
  }

  @override
  String get vaultFieldPetName => 'Pet\'s name';

  @override
  String get vaultFieldIssuedOn => 'Issued on';

  @override
  String get vaultFieldExpiry => 'Valid until';

  @override
  String get vaultFieldIssuer => 'Issued by';

  @override
  String get vaultFieldVetReg => 'Vet reg. no.';

  @override
  String get vaultFieldReference => 'Reference no.';

  @override
  String get vaultFieldTest => 'Test';

  @override
  String get vaultFieldAmount => 'Amount';

  @override
  String get vaultFileType => 'File type';

  @override
  String get vaultFileSize => 'Size';

  @override
  String get vaultAddedLabel => 'Added';

  @override
  String get vaultPdf => 'PDF';

  @override
  String get vaultPhoto => 'Photo';

  @override
  String get vaultSample => 'Sample';

  @override
  String get vaultTapToZoom => 'Tap to zoom';

  @override
  String get vaultSecureNote =>
      'Stored privately in your account. Only you and the people you share a link with can see it.';

  @override
  String vaultLinkedVaccine(String pet) {
    return 'Linked to $pet\'s vaccine record';
  }

  @override
  String get vaultOpenInApp => 'Open in PawSetu';

  @override
  String get vaultOpenPolicy => 'Open policy';

  @override
  String get vaultTrackPolicy => 'Track in insurance';

  @override
  String get vaultShareWithVet => 'Share with a vet';

  @override
  String get vaultDeleteDoc => 'Delete document';

  @override
  String vaultDeleteDocQ(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String vaultDeleteDocBody(String pet) {
    return 'It will be removed from $pet\'s vault, and share links to it will stop working.';
  }

  @override
  String get vaultDeleted => 'Document deleted';

  @override
  String get vaultShareTitle => 'Share with a vet';

  @override
  String get vaultShareBody =>
      'Create a link that opens only the documents you choose, for a limited time.';

  @override
  String get vaultChooseDocs => 'Documents to share';

  @override
  String get vaultSelectOneDoc => 'Choose at least one document.';

  @override
  String get vaultLinkValidFor => 'Link works for';

  @override
  String get vaultExpiry1h => '1 hour';

  @override
  String get vaultExpiry24h => '24 hours';

  @override
  String get vaultExpiry7d => '7 days';

  @override
  String get vaultExpiryNever => 'Until I stop it';

  @override
  String get vaultAddPin => 'Ask for a PIN';

  @override
  String get vaultAddPinHint =>
      'The vet enters this 4 to 6 digit PIN to open the link.';

  @override
  String get vaultPinFormat => 'The PIN must be 4 to 6 digits.';

  @override
  String get vaultCreateLink => 'Create link';

  @override
  String get vaultLinkReady => 'Link ready';

  @override
  String vaultLinkPinIs(String pin) {
    return 'PIN: $pin';
  }

  @override
  String get vaultSendTo => 'Send the link';

  @override
  String get vaultSendPhoneTo => 'Vet\'s phone number';

  @override
  String get vaultSendEmailTo => 'Vet\'s email';

  @override
  String get vaultSend => 'Send';

  @override
  String vaultSentTo(String target) {
    return 'Link sent to $target (demo: in the Demo Outbox)';
  }

  @override
  String get vaultShareCopiedInstead => 'Link copied. Paste it into any app.';

  @override
  String get vaultShareEmailSubject => 'Pet health documents from PawSetu';

  @override
  String vaultShareText(String name, String pet, String url) {
    return '$name shared $pet\'s health documents with you on PawSetu: $url';
  }

  @override
  String get vaultShareLinks => 'Share links';

  @override
  String get vaultLinksNote =>
      'Links open only the documents you chose and stop working when they expire or when you stop them.';

  @override
  String get vaultLinksOld => 'Expired and stopped';

  @override
  String get vaultNoLinks => 'No share links yet';

  @override
  String get vaultNoLinksBody =>
      'Share documents with a vet from any document in the vault.';

  @override
  String get vaultLinkActive => 'Active';

  @override
  String get vaultLinkExpired => 'Expired';

  @override
  String get vaultLinkRevoked => 'Stopped';

  @override
  String vaultLinkDocs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0';
  }

  @override
  String get vaultLinkAlbum => 'Album link';

  @override
  String vaultLinkWorksUntil(String when) {
    return 'Works until $when';
  }

  @override
  String get vaultLinkNoEnd => 'Works until you stop it';

  @override
  String vaultLinkOpened(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Opened $count times',
      one: 'Opened once',
      zero: 'Not opened yet',
    );
    return '$_temp0';
  }

  @override
  String get vaultHasPin => 'PIN';

  @override
  String vaultCreatedOn(String when) {
    return 'Created $when';
  }

  @override
  String vaultRevokedOn(String when) {
    return 'Stopped $when';
  }

  @override
  String get vaultAccessLog => 'Access log';

  @override
  String get vaultNoAccess => 'Nobody has opened this link yet.';

  @override
  String get vaultAccessOk => 'Opened';

  @override
  String get vaultAccessWrongPin => 'Wrong PIN tried';

  @override
  String get vaultRevoke => 'Stop link';

  @override
  String get vaultRevokeQ => 'Stop this link?';

  @override
  String get vaultRevokeBody =>
      'Anyone who opens it will see that it no longer works. Your documents stay in the vault.';

  @override
  String get vaultRevoked => 'Link stopped';

  @override
  String vaultSharedBy(String owner, String pet) {
    return '$owner shared $pet\'s documents';
  }

  @override
  String vaultSharedUntil(String when) {
    return 'Available until $when';
  }

  @override
  String get vaultViewOnly => 'View only';

  @override
  String get vaultNoMatches => 'No documents in this link';

  @override
  String get vaultSharedFooter =>
      'Shared securely with PawSetu. The pet parent can stop this link at any time.';

  @override
  String get vaultGetPawSetu => 'Get PawSetu';

  @override
  String get vaultEnterSharePin => 'Enter the PIN';

  @override
  String vaultEnterSharePinBody(String owner) {
    return '$owner protected these documents with a PIN. Ask them for it.';
  }

  @override
  String get vaultLinkPin => 'PIN';

  @override
  String get vaultOpenLink => 'Open';

  @override
  String get vaultShareWrongPin => 'Wrong PIN. Please try again.';

  @override
  String get vaultShareLocked =>
      'Too many wrong tries. Try again in 15 minutes.';

  @override
  String get vaultLinkStopped => 'This link isn\'t available';

  @override
  String vaultLinkExpiredBody(String when) {
    return 'It expired on $when. Ask the pet parent for a new link.';
  }

  @override
  String get vaultLinkRevokedBody =>
      'The pet parent stopped this link. Ask them for a new one.';

  @override
  String get vaultLinkNotFoundBody =>
      'Check that the link was copied completely.';

  @override
  String get vaultInsuranceTitle => 'Pet insurance';

  @override
  String get vaultInsuranceNote =>
      'PawSetu doesn\'t sell insurance. Track your policy, renewals and claims here.';

  @override
  String get vaultNoPolicies => 'No policies yet';

  @override
  String get vaultNoPoliciesBody =>
      'Add your pet\'s insurance to track cover, renewal dates and claims.';

  @override
  String get vaultAddPolicy => 'Add policy';

  @override
  String get vaultEditPolicy => 'Edit policy';

  @override
  String vaultPolicyFor(String pet) {
    return 'Policy for $pet';
  }

  @override
  String get vaultFieldInsurer => 'Insurance company';

  @override
  String get vaultPlanName => 'Plan name';

  @override
  String get vaultFieldPolicyNo => 'Policy number';

  @override
  String get vaultFieldCover => 'Sum insured (₹)';

  @override
  String get vaultFieldPremium => 'Yearly premium (₹)';

  @override
  String get vaultFieldCoverStart => 'Cover starts';

  @override
  String get vaultFieldRenewal => 'Renewal date';

  @override
  String get vaultRenewalReminderNote =>
      'We\'ll remind you 30 days before renewal.';

  @override
  String vaultInsuranceReminderTitle(String pet) {
    return '$pet\'s insurance renews soon';
  }

  @override
  String get vaultPolicyDoc => 'Policy document';

  @override
  String get vaultLinkDoc => 'Link the policy document from the vault';

  @override
  String get vaultNoDocLinked => 'No document linked';

  @override
  String get vaultAttachDoc => 'Attach from vault';

  @override
  String vaultAttached(String title) {
    return 'Attached: $title';
  }

  @override
  String get vaultDocMissing => 'This policy is no longer available.';

  @override
  String get vaultCover => 'Cover';

  @override
  String vaultCoverLeft(String amount) {
    return '$amount cover left this year';
  }

  @override
  String get vaultPremium => 'Premium';

  @override
  String vaultPremiumYear(String amount) {
    return '$amount a year';
  }

  @override
  String get vaultPolicyActive => 'Active';

  @override
  String get vaultPolicyLapsed => 'Lapsed';

  @override
  String get vaultRenewSoon => 'Renew soon';

  @override
  String get vaultDeletePolicyQ => 'Delete this policy?';

  @override
  String get vaultDeletePolicyBody =>
      'Its claims are removed too. The policy document stays in the vault.';

  @override
  String get vaultClaims => 'Claims';

  @override
  String vaultOpenClaims(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count open',
      one: '1 open',
    );
    return '$_temp0';
  }

  @override
  String get vaultNoClaims => 'No claims yet';

  @override
  String get vaultNewClaim => 'New claim';

  @override
  String get vaultClaimFor => 'What is the claim for?';

  @override
  String get vaultClaimForHint => 'E.g. Bruno\'s leg X-ray and treatment';

  @override
  String get vaultClaimAmount => 'Amount claimed';

  @override
  String get vaultClaimDate => 'Treatment date';

  @override
  String get vaultClaimChecklist => 'Documents checklist';

  @override
  String vaultChecklistProgress(int done, int total) {
    return '$done of $total ready';
  }

  @override
  String get vaultCkClaimForm => 'Filled claim form';

  @override
  String get vaultCkVetBills => 'Vet bills and receipts';

  @override
  String get vaultCkPrescription => 'Prescription';

  @override
  String get vaultCkLabReports => 'Lab or X-ray reports';

  @override
  String get vaultCkPolicyCopy => 'Policy copy';

  @override
  String get vaultCkPetPhoto => 'Recent photo of your pet';

  @override
  String get vaultCkIdProof => 'Your ID proof';

  @override
  String get vaultReadyToSubmit =>
      'Tick every document in the checklist before submitting.';

  @override
  String vaultMarkAs(String status) {
    return 'Mark as $status';
  }

  @override
  String get vaultClaimDraft => 'Draft';

  @override
  String get vaultClaimSubmitted => 'Submitted';

  @override
  String get vaultClaimInReview => 'In review';

  @override
  String get vaultClaimApproved => 'Approved';

  @override
  String get vaultClaimRejected => 'Rejected';

  @override
  String get vaultClaimPaid => 'Paid';

  @override
  String vaultClaimedAmount(String amount) {
    return 'Claimed $amount';
  }

  @override
  String vaultPaidAmount(String amount) {
    return 'Paid $amount';
  }

  @override
  String get vaultSettledAmount => 'Amount paid by insurer';

  @override
  String get vaultClaimSaved => 'Claim saved';
}
