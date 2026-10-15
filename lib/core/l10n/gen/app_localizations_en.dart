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

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get change => 'Change';

  @override
  String get catFood => 'Food';

  @override
  String get catTreats => 'Treats';

  @override
  String get catToys => 'Toys';

  @override
  String get catGrooming => 'Grooming';

  @override
  String get catHealthHygiene => 'Health and hygiene';

  @override
  String get catBeds => 'Beds';

  @override
  String get catCollars => 'Collars and leashes';

  @override
  String get catBowls => 'Bowls and feeders';

  @override
  String get catLitter => 'Litter and cat care';

  @override
  String get catBird => 'Bird food and cages';

  @override
  String get catRabbit => 'Rabbit hay and care';

  @override
  String get catClothing => 'Clothing';

  @override
  String get catTravel => 'Travel';

  @override
  String get shopStageYoung => 'Puppy / kitten';

  @override
  String get shopStageAdult => 'Adult';

  @override
  String get shopStageSenior => 'Senior';

  @override
  String get shopStageAll => 'All ages';

  @override
  String get shopSizeSmall => 'Small breeds';

  @override
  String get shopSizeMedium => 'Medium breeds';

  @override
  String get shopSizeLarge => 'Large breeds';

  @override
  String get shopSizeGiant => 'Giant breeds';

  @override
  String get shopSizeAll => 'All sizes';

  @override
  String get sortPopular => 'Popular';

  @override
  String get sortPriceLow => 'Price: low to high';

  @override
  String get sortPriceHigh => 'Price: high to low';

  @override
  String get sortDiscount => 'Biggest discount';

  @override
  String get sortNewest => 'Newest';

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopSearchHint => 'Search food, toys, beds…';

  @override
  String get shopSearchTitle => 'Search';

  @override
  String get shopClearSearch => 'Clear search';

  @override
  String shopForPet(String pet) {
    return 'For $pet';
  }

  @override
  String shopAvoiding(String items) {
    return 'Avoiding: $items';
  }

  @override
  String get shopNoPicks => 'No picks yet. Try searching the shop.';

  @override
  String get shopBuyAgain => 'Buy again';

  @override
  String get shopReorder => 'Reorder';

  @override
  String shopReorderPrice(String price) {
    return 'Reorder · $price';
  }

  @override
  String get shopCategories => 'Categories';

  @override
  String get shopDeals => 'Deals';

  @override
  String get shopPartnerStores => 'Partner stores';

  @override
  String get shopPartnerStoresNote =>
      'You buy these on the partner\'s own website. PawSetu may earn a small commission.';

  @override
  String shopListings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String shopPlusDeliveryNote(String amount) {
    return 'Plus members get free delivery above $amount.';
  }

  @override
  String get shopPartnerStore => 'Partner store';

  @override
  String shopSoldOn(String store) {
    return 'On $store';
  }

  @override
  String shopOffPercent(int percent) {
    return '$percent% off';
  }

  @override
  String shopPriceSemantics(String price, String mrp, int percent) {
    return '$price, was $mrp, $percent% off';
  }

  @override
  String shopRatingSemantics(String rating, int count) {
    return 'Rated $rating out of 5 by $count people';
  }

  @override
  String get shopNoReviewsYet => 'No reviews yet';

  @override
  String get shopOutOfStock => 'Out of stock';

  @override
  String get shopInStock => 'In stock';

  @override
  String shopOnlyLeft(int count) {
    return 'Only $count left';
  }

  @override
  String shopResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String shopFiltersCount(int count) {
    return 'Filters ($count)';
  }

  @override
  String get shopNoResults => 'Nothing found';

  @override
  String get shopNoResultsBody => 'Try another word or clear the filters.';

  @override
  String get shopClearFilters => 'Clear filters';

  @override
  String get shopCategory => 'Category';

  @override
  String get shopPrice => 'Price';

  @override
  String get shopMinPrice => 'Min price';

  @override
  String get shopMaxPrice => 'Max price';

  @override
  String get shopBrand => 'Brand';

  @override
  String shopRatingAtLeast(String rating) {
    return '$rating★ and up';
  }

  @override
  String get shopHidePartner => 'Hide partner-store listings';

  @override
  String get shopHidePartnerHint => 'Show only products you can buy in PawSetu';

  @override
  String get shopShowResults => 'Show results';

  @override
  String get shopProduct => 'Product';

  @override
  String get shopProductGone => 'This product is no longer available';

  @override
  String shopShareText(String name, String price) {
    return '$name for $price on PawSetu';
  }

  @override
  String get shopInclTaxes => 'Inclusive of all taxes';

  @override
  String shopAffiliateNote(String store) {
    return 'You will buy this on $store. PawSetu may earn a small commission; the price is the same for you.';
  }

  @override
  String shopSoldBy(String seller, String city) {
    return 'Sold by $seller, $city';
  }

  @override
  String get shopSuitableFor => 'Suitable for';

  @override
  String get shopCheckDelivery => 'Check delivery';

  @override
  String get shopEnterPin => 'Enter a PIN code to see the delivery date';

  @override
  String shopDeliveryBetween(String from, String to) {
    return 'Delivery $from – $to';
  }

  @override
  String shopReturnable(int days) {
    return 'Easy returns within $days days of delivery';
  }

  @override
  String get shopNotReturnable =>
      'Food and treats can\'t be returned once delivered';

  @override
  String get shopAbout => 'About this product';

  @override
  String get shopPackSize => 'Pack size';

  @override
  String get shopIngredients => 'Ingredients';

  @override
  String get shopReturnPolicy => 'Return policy';

  @override
  String get shopVerifiedBuyer => 'Verified buyer';

  @override
  String shopSellerReplied(String reply) {
    return 'Seller: $reply';
  }

  @override
  String shopBuyOn(String store) {
    return 'Buy on $store';
  }

  @override
  String get shopAddToCart => 'Add to cart';

  @override
  String get shopBuyNow => 'Buy now';

  @override
  String get shopAddedToCart => 'Added to cart';

  @override
  String get shopViewCart => 'View cart';

  @override
  String shopLeavingTitle(String store) {
    return 'You will buy on $store';
  }

  @override
  String shopLeavingBody(String store) {
    return 'We will open $store in your browser. Payment, delivery and returns are handled by $store. PawSetu may earn a small commission.';
  }

  @override
  String shopContinueTo(String store) {
    return 'Go to $store';
  }

  @override
  String get shopCart => 'Cart';

  @override
  String shopCartWithCount(int count) {
    return 'Cart, $count items';
  }

  @override
  String get shopQuantity => 'Quantity';

  @override
  String shopQtySemantics(int count) {
    return 'Quantity $count';
  }

  @override
  String shopQtyShort(int count) {
    return 'Qty $count';
  }

  @override
  String shopLessOf(String item) {
    return 'One less $item';
  }

  @override
  String shopMoreOf(String item) {
    return 'One more $item';
  }

  @override
  String shopRemoveItem(String item) {
    return 'Remove $item';
  }

  @override
  String shopStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get shopReviewText => 'What did you think? (optional)';

  @override
  String get shopPostReview => 'Post review';

  @override
  String get shopThanksReview => 'Thanks for your review!';

  @override
  String get shopRate => 'Rate';

  @override
  String get shopForWhichPet => 'For which pet?';

  @override
  String get shopReorderTitle => 'Reorder';

  @override
  String shopReorderFor(String pet) {
    return 'Reorder for $pet';
  }

  @override
  String shopDeliveryOn(String date) {
    return 'Delivery on $date';
  }

  @override
  String get shopItemsTotal => 'Items total';

  @override
  String get shopDeliveryFee => 'Delivery';

  @override
  String get shopFree => 'Free';

  @override
  String get shopToPay => 'To pay';

  @override
  String shopPlaceOrderAmount(String amount) {
    return 'Place order · $amount';
  }

  @override
  String get shopOrderPlacedToast => 'Order placed!';

  @override
  String get shopOrderFailed =>
      'We couldn\'t place the order. Please try again.';

  @override
  String get addrBook => 'Addresses';

  @override
  String get addrAdd => 'Add address';

  @override
  String get addrEdit => 'Edit address';

  @override
  String get addrAddFirst => 'Add a delivery address';

  @override
  String get addrNone => 'No addresses yet';

  @override
  String get addrNoneBody => 'Add your home address for faster checkout.';

  @override
  String get addrDeleteQ => 'Delete this address?';

  @override
  String get addrChoose => 'Deliver to';

  @override
  String get addrHome => 'Home';

  @override
  String get addrWork => 'Work';

  @override
  String get addrOther => 'Other';

  @override
  String get addrName => 'Name';

  @override
  String get addrPhoneInvalid => 'Enter a 10-digit mobile number';

  @override
  String get addrLine1 => 'House / flat and street';

  @override
  String get addrLine2 => 'Landmark (optional)';

  @override
  String get addrArea => 'Area';

  @override
  String get addrCity => 'City';

  @override
  String get addrPin => 'PIN code';

  @override
  String get addrPinInvalid => 'Enter a 6-digit PIN code';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyBody =>
      'Food, toys and more for your pet are a tap away.';

  @override
  String get cartStartShopping => 'Start shopping';

  @override
  String cartSoldBy(String seller) {
    return 'Sold by $seller';
  }

  @override
  String get cartSkipped => 'These can\'t be ordered here right now';

  @override
  String get cartPartnerOnly => 'Buy this on the partner store';

  @override
  String get cartPetHint => 'Helps us track spending and food for this pet.';

  @override
  String get cartDeliverTo => 'Deliver to';

  @override
  String get cartSlot => 'Delivery slot';

  @override
  String get cartCoupon => 'Coupon';

  @override
  String get couponCode => 'Coupon code';

  @override
  String get couponApply => 'Apply';

  @override
  String get couponApplied => 'Coupon applied';

  @override
  String couponSaved(String code, String amount) {
    return '$code applied: you save $amount';
  }

  @override
  String get couponNotFound => 'That coupon code isn\'t valid';

  @override
  String get couponExpired => 'This coupon has expired';

  @override
  String couponMinOrder(int amount) {
    return 'Add items worth ₹$amount or more to use this coupon';
  }

  @override
  String get couponUsedUp => 'This coupon has been fully used';

  @override
  String get cartPayment => 'Payment';

  @override
  String get payOnlineDemo => 'Pay online (demo)';

  @override
  String get payOnDelivery => 'Pay on delivery';

  @override
  String get cartBill => 'Bill details';

  @override
  String cartMrpTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Price ($count items)',
      one: 'Price (1 item)',
    );
    return '$_temp0';
  }

  @override
  String get cartMrpDiscount => 'Discount on MRP';

  @override
  String get cartCouponDiscount => 'Coupon';

  @override
  String cartCouponDiscountCode(String code) {
    return 'Coupon $code';
  }

  @override
  String cartAddForFree(String amount) {
    return 'Add $amount more for free delivery';
  }

  @override
  String get cartPlusFreeDelivery => 'Free delivery with Plus';

  @override
  String cartSplitNote(int count) {
    return 'Items come from $count sellers, so you\'ll get $count deliveries. You pay once.';
  }

  @override
  String cartYouSave(String amount) {
    return 'You save $amount';
  }

  @override
  String cartPay(String amount) {
    return 'Pay $amount';
  }

  @override
  String get cartPlaceOrder => 'Place order';

  @override
  String cartPaymentFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PawSetu order, $count items',
      one: 'PawSetu order, 1 item',
    );
    return '$_temp0';
  }

  @override
  String get payFailedTryAgain =>
      'Payment failed. Your cart is saved; please try again.';

  @override
  String get payPaidOnline => 'Paid online';

  @override
  String get payPending => 'Payment pending';

  @override
  String get payRefunded => 'Refunded';

  @override
  String get payPendingNote =>
      'Your payment is being confirmed. If it fails, you can pay again or pay on delivery.';

  @override
  String get payNow => 'Pay now';

  @override
  String get ordMyOrders => 'My orders';

  @override
  String get ordTabOrders => 'Orders';

  @override
  String get ordNone => 'No orders yet';

  @override
  String get ordPlaced => 'Placed';

  @override
  String get ordPacked => 'Packed';

  @override
  String get ordShipped => 'Shipped';

  @override
  String get ordOutForDelivery => 'Out for delivery';

  @override
  String get ordDelivered => 'Delivered';

  @override
  String get ordCancelled => 'Cancelled';

  @override
  String get ordReturnRequested => 'Return requested';

  @override
  String get ordReturned => 'Returned';

  @override
  String get ordReturnRejected => 'Return declined';

  @override
  String ordItemsMore(String name, int count) {
    return '$name +$count more';
  }

  @override
  String ordArrivingBy(String date) {
    return 'Arriving by $date';
  }

  @override
  String ordExpected(String date) {
    return 'Expected $date';
  }

  @override
  String get ordPlacedTitle => 'Order placed';

  @override
  String get ordPlacedHeading => 'Thank you! Your order is placed.';

  @override
  String get ordPlacedBody => 'We\'ll let you know when it\'s on the way.';

  @override
  String ordPlacedSplit(int count) {
    return 'It comes in $count deliveries, one from each seller.';
  }

  @override
  String get ordTrack => 'Track order';

  @override
  String get ordContinueShopping => 'Continue shopping';

  @override
  String get ordDetail => 'Order details';

  @override
  String get ordNotFound => 'We couldn\'t find this order';

  @override
  String ordNumber(String number) {
    return 'Order $number';
  }

  @override
  String ordPlacedOn(String date) {
    return 'Placed on $date';
  }

  @override
  String get ordTracking => 'Tracking';

  @override
  String ordItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String ordSlot(String date, String window) {
    return 'Slot: $date, $window';
  }

  @override
  String ordForPet(String pet) {
    return 'For $pet';
  }

  @override
  String get ordTotal => 'Total';

  @override
  String get ordPayment => 'Payment';

  @override
  String get ordInvoice => 'Invoice (PDF)';

  @override
  String get ordCancel => 'Cancel order';

  @override
  String get ordReturn => 'Return';

  @override
  String get ordHelp => 'Get help';

  @override
  String ordReturnWindowOver(int days) {
    return 'The $days-day return window has ended.';
  }

  @override
  String get ordCancelTitle => 'Why do you want to cancel?';

  @override
  String get ordReturnTitle => 'Why are you returning it?';

  @override
  String get ordReasonChangedMind => 'I changed my mind';

  @override
  String get ordReasonWrongItem => 'Wrong item or size';

  @override
  String get ordReasonTooLate => 'Delivery is too late';

  @override
  String get ordReasonDamaged => 'It arrived damaged';

  @override
  String get ordReasonNotSuitable => 'Not suitable for my pet';

  @override
  String get ordReasonOther => 'Something else';

  @override
  String get ordCancelledToast => 'Order cancelled';

  @override
  String get ordCancelledRefund =>
      'Order cancelled. Your refund is on its way (demo).';

  @override
  String get ordReturnRequestedToast =>
      'Return requested. The seller will reply soon.';

  @override
  String ordReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get ordStepDone => 'done';

  @override
  String get invTitle => 'Tax invoice';

  @override
  String get invFooter =>
      'PawSetu marketplace · This invoice is generated by the seller through PawSetu.';

  @override
  String get invSoldBy => 'Sold by';

  @override
  String get invBillTo => 'Bill to';

  @override
  String invGstin(String gstin) {
    return 'GSTIN: $gstin';
  }

  @override
  String get invMarketplace => 'Sold through PawSetu marketplace';

  @override
  String get invOrder => 'Order';

  @override
  String invInvoiceNo(String number) {
    return 'Invoice $number';
  }

  @override
  String invPayment(String method) {
    return 'Payment: $method';
  }

  @override
  String get invItems => 'Items';

  @override
  String get invItem => 'Item';

  @override
  String get invQty => 'Qty';

  @override
  String get invPrice => 'Price';

  @override
  String get invAmount => 'Amount';

  @override
  String get invTax => 'GST';

  @override
  String get invTaxPlaceholder => 'Included';

  @override
  String get invDemoNote =>
      'Demo invoice: no money was charged and GST details are placeholders.';

  @override
  String get orderEmailSubject => 'Your PawSetu order is placed';

  @override
  String orderEmailBody(String name, String amount, String date) {
    return 'Hi $name, thank you for your order of $amount. It should reach you by $date.';
  }

  @override
  String get subsTitle => 'Auto-reorder';

  @override
  String get subsHint =>
      'Get this delivered every 2, 4 or 6 weeks. Pause or cancel anytime.';

  @override
  String get subsEvery => 'Deliver every';

  @override
  String subsWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every week',
    );
    return '$_temp0';
  }

  @override
  String subsFirstOn(String date) {
    return 'First delivery around $date, paid on delivery.';
  }

  @override
  String get subsStart => 'Start auto-reorder';

  @override
  String get subsCreated => 'Auto-reorder is on';

  @override
  String get subsTab => 'Auto-reorder';

  @override
  String get subsNone => 'No auto-reorders';

  @override
  String get subsNoneBody =>
      'Set one up from any food page so you never run out.';

  @override
  String subsNext(String date) {
    return 'Next delivery $date';
  }

  @override
  String get subsPaused => 'Paused';

  @override
  String get subsPause => 'Pause';

  @override
  String get subsResume => 'Resume';

  @override
  String get subsCancel => 'Cancel';

  @override
  String get subsCancelQ => 'Stop this auto-reorder?';

  @override
  String subsOrderedToast(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count auto-reorders were placed',
      one: 'Your auto-reorder was placed',
    );
    return '$_temp0';
  }

  @override
  String ntfNewOrder(String item, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'New order: $item and more',
      one: 'New order: $item',
    );
    return '$_temp0';
  }

  @override
  String ntfOrderCancelled(String number) {
    return 'Order $number was cancelled by the customer';
  }

  @override
  String ntfOrderCancelledBySeller(String item) {
    return 'Sorry, the seller cancelled your order for $item. Any payment is refunded.';
  }

  @override
  String ntfOrderPacked(String item) {
    return '$item is packed';
  }

  @override
  String ntfOrderShipped(String item) {
    return '$item is on the way';
  }

  @override
  String ntfOrderOutForDelivery(String item) {
    return '$item is out for delivery today';
  }

  @override
  String ntfOrderDelivered(String item) {
    return '$item was delivered';
  }

  @override
  String ntfOrderUpdated(String item) {
    return 'Your order for $item was updated';
  }

  @override
  String ntfReturnAccepted(String item) {
    return 'Return accepted for $item. Your refund is on its way.';
  }

  @override
  String ntfReturnRejected(String item) {
    return 'Return declined for $item. Tap for help.';
  }

  @override
  String ntfReturnRequested(String number) {
    return 'Return requested for order $number';
  }

  @override
  String ntfSubscriptionOrdered(String item) {
    return 'Auto-reorder placed: $item';
  }

  @override
  String foodRunsOutIn(String pet, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$pet\'s food may run out in about $_temp0. Reorder?';
  }

  @override
  String foodRanOut(String pet) {
    return '$pet\'s food may have run out. Reorder?';
  }

  @override
  String foodPortionLine(int grams, String bag) {
    return '$grams g a day · $bag bag';
  }

  @override
  String get foodEditPortion => 'Edit portion';

  @override
  String foodOnTheWay(String pet) {
    return 'New food for $pet is on the way';
  }

  @override
  String foodPlanTitle(String pet) {
    return '$pet\'s food';
  }

  @override
  String get foodDailyPortion => 'Daily portion';

  @override
  String foodSuggested(int grams) {
    return 'A starting point is $grams g a day. Follow the pack or your vet.';
  }

  @override
  String get foodBagSize => 'Bag size';

  @override
  String get foodOpenedOn => 'Bag opened on';

  @override
  String get expAdd => 'Add expense';

  @override
  String get expEdit => 'Edit expense';

  @override
  String get expThisMonth => 'This month';

  @override
  String get expLastMonth => 'Last month';

  @override
  String expPeriodTotal(int months) {
    return 'Last $months months';
  }

  @override
  String get expByMonth => 'Spending by month';

  @override
  String expMonths(int count) {
    return '$count months';
  }

  @override
  String get expByCategory => 'By category';

  @override
  String expChartSemantics(String values) {
    return 'Spending by month: $values';
  }

  @override
  String get expNone => 'No expenses yet';

  @override
  String get expNoneBody =>
      'Bookings and orders are added here automatically. You can add others too.';

  @override
  String get expVet => 'Vet';

  @override
  String get expGrooming => 'Grooming';

  @override
  String get expTraining => 'Training';

  @override
  String get expBoarding => 'Boarding';

  @override
  String get expWalking => 'Walking';

  @override
  String get expFood => 'Food';

  @override
  String get expSupplies => 'Supplies';

  @override
  String get expInsurance => 'Insurance';

  @override
  String get expOther => 'Other';

  @override
  String get expFromBooking => 'from a booking';

  @override
  String get expFromOrder => 'from an order';

  @override
  String get expFromTeleVet => 'from tele-vet';

  @override
  String get expAmount => 'Amount';

  @override
  String get expAmountInvalid => 'Enter an amount';

  @override
  String get expCategory => 'Category';

  @override
  String get expForPet => 'For';

  @override
  String get expAllPets => 'All pets';

  @override
  String get expNote => 'Note';

  @override
  String get expNoteHint => 'For example: rabies booster, new collar';

  @override
  String get expSaved => 'Expense saved';

  @override
  String get expDeleteQ => 'Delete this expense?';

  @override
  String get selToPack => 'Orders to pack';

  @override
  String get selOnTheWay => 'On the way';

  @override
  String get selLowStock => 'Low stock';

  @override
  String selReturnsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count returns are waiting for you',
      one: '1 return is waiting for you',
    );
    return '$_temp0';
  }

  @override
  String get selNewOrders => 'New orders';

  @override
  String get selNoNewOrders => 'No new orders right now';

  @override
  String selStockLeft(int count) {
    return '$count in stock';
  }

  @override
  String get selAddProduct => 'Add product';

  @override
  String get selEditProduct => 'Edit product';

  @override
  String get selCsvUpload => 'CSV bulk upload';

  @override
  String get selSearchProducts => 'Search your products';

  @override
  String selProductCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get selHidden => 'Hidden from the shop';

  @override
  String get selProductName => 'Product name';

  @override
  String get selPrice => 'Selling price';

  @override
  String get selMrp => 'MRP';

  @override
  String get selPriceInvalid => 'Enter a price';

  @override
  String get selMrpInvalid => 'MRP can\'t be lower than the price';

  @override
  String get selStock => 'Stock';

  @override
  String get selPackKg => 'Pack size in kg (food)';

  @override
  String get selDescription => 'Description';

  @override
  String get selVisible => 'Show in the shop';

  @override
  String get selVisibleHint => 'Turn off to hide it without deleting';

  @override
  String get selNoRxNote =>
      'Prescription-only medicines can\'t be sold on PawSetu.';

  @override
  String get selSaved => 'Product saved';

  @override
  String selCsvHelp(String columns) {
    return 'Columns: $columns. Species can be several, like dog|cat.';
  }

  @override
  String get selCsvChoose => 'Choose CSV file';

  @override
  String get selCsvSample => 'Try the sample';

  @override
  String get selCsvCopyTemplate => 'Copy template';

  @override
  String get selCsvCopied => 'Template copied';

  @override
  String get selCsvPaste => 'Or paste CSV here';

  @override
  String selCsvPreview(int ok, int bad) {
    return 'Preview: $ok ready, $bad to fix';
  }

  @override
  String selCsvLine(int line) {
    return 'Line $line';
  }

  @override
  String selCsvProblems(String fields) {
    return 'Check: $fields';
  }

  @override
  String selCsvImport(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count products',
      one: 'Add 1 product',
    );
    return '$_temp0';
  }

  @override
  String selCsvImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products added',
      one: '1 product added',
    );
    return '$_temp0';
  }

  @override
  String get selTabNew => 'New';

  @override
  String get selTabPacked => 'Packed';

  @override
  String get selTabShipping => 'Shipping';

  @override
  String get selTabDelivered => 'Delivered';

  @override
  String get selTabCancelled => 'Cancelled / returned';

  @override
  String get selNoOrdersHere => 'No orders here';

  @override
  String get selReturnsOpen => 'Waiting for you';

  @override
  String get selReturnsDone => 'Done';

  @override
  String get selNoReturns => 'No returns';

  @override
  String get selAcceptReturn => 'Accept return';

  @override
  String get selRejectReturn => 'Decline return';

  @override
  String get selPayoutDemo => 'Demo payouts: no real money moves.';

  @override
  String get selPayoutPending => 'Pending';

  @override
  String get selPayoutReady => 'Ready to pay';

  @override
  String get selPayoutPaid => 'Paid';

  @override
  String get selPayoutOnHold => 'In return window';

  @override
  String get selCommissionPaid => 'PawSetu commission';

  @override
  String selRunPayout(String amount) {
    return 'Pay out $amount now (demo)';
  }

  @override
  String selPayoutDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders paid out',
      one: '1 order paid out',
    );
    return '$_temp0';
  }

  @override
  String selPayoutRule(int days) {
    return 'Payouts are made weekly once the $days-day return window ends.';
  }

  @override
  String get selPayoutOrders => 'Orders';

  @override
  String selPayoutLine(String gross, String commission) {
    return 'Sales $gross · commission $commission';
  }

  @override
  String selReviewSummary(String rating, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '★ $rating from $_temp0';
  }

  @override
  String get selReplyText => 'Your reply';

  @override
  String get selSendReply => 'Send reply';

  @override
  String get selApproved => 'Approved';

  @override
  String get selKyc => 'KYC documents';

  @override
  String get selVerified => 'Verified';

  @override
  String get selCancelQ => 'Cancel this order?';

  @override
  String get selCancelBody =>
      'The customer is told and any payment is refunded.';

  @override
  String get selCancelOrder => 'Cancel order';

  @override
  String get selOutOfStockReason => 'Out of stock';

  @override
  String get selMarkPacked => 'Mark packed';

  @override
  String get selMarkShipped => 'Mark shipped';

  @override
  String get selMarkOut => 'Out for delivery';

  @override
  String get selMarkDelivered => 'Mark delivered';

  @override
  String get selCommission => 'PawSetu commission';

  @override
  String get selYourPayout => 'Your payout';

  @override
  String get selShipTo => 'Ship to';

  @override
  String get selPhoneHidden =>
      'The customer\'s phone is hidden; the courier calls through PawSetu.';

  @override
  String get faChokingTitle => 'Choking';

  @override
  String get faChokingSigns =>
      'Pawing at the mouth, gagging, coughing, blue gums or struggling to breathe.';

  @override
  String get faChokingSteps =>
      'Stay calm and keep your pet still. If they can still cough, let them try to clear it.\nOpen the mouth gently and look inside with a torch.\nIf you can see the object and reach it easily, hook it out with your fingers. Don\'t push it deeper.\nSmall dog or cat: hold them upside down by the hips and give 5 sharp taps between the shoulder blades.\nLarge dog: stand behind, put your fist just below the ribs and give 5 quick pushes inwards and upwards.\nCheck the mouth again. Go to a vet straight away, even if the object came out.';

  @override
  String get faChokingAvoid =>
      'Don\'t reach blindly down the throat.\nDon\'t give food or water.\nDon\'t pull on string or thread you see; it may be caught on something inside.';

  @override
  String get faChokingVet =>
      'Always see a vet after choking, even if your pet seems fine. Use SOS if they collapse or can\'t breathe.';

  @override
  String get faPoisoningTitle => 'Poisoning';

  @override
  String get faPoisoningSigns =>
      'Vomiting, drooling, shaking, wobbly walking, fits, sudden tiredness, or a chewed packet nearby.';

  @override
  String get faPoisoningSteps =>
      'Move your pet away from the poison and remove any left in the mouth.\nFind out what was eaten, how much and when. Keep the packet or take a photo of the plant.\nCall your vet now, or use SOS to reach the nearest clinic.\nIf the poison is on the fur or skin, rinse it off with plenty of lukewarm water.\nKeep your pet warm and quiet on the way to the clinic.';

  @override
  String get faPoisoningAvoid =>
      'Don\'t make your pet vomit unless a vet tells you to.\nDon\'t give milk, salt, oil or home remedies.\nDon\'t wait for signs; some poisons act hours later.';

  @override
  String get faPoisoningVet =>
      'Go now. With poisons, early treatment saves lives.';

  @override
  String get faHeatstrokeTitle => 'Heatstroke';

  @override
  String get faHeatstrokeSigns =>
      'Heavy panting, thick drool, bright red or pale gums, weakness, vomiting or collapse on a hot day.';

  @override
  String get faHeatstrokeSteps =>
      'Move your pet into shade or a cool room right away.\nPour cool (not ice-cold) water over the body, especially the belly, neck and paws.\nUse a fan or wet towels, and change the towels often so they don\'t trap heat.\nOffer small sips of cool water; don\'t force it.\nGo to a vet even if your pet seems better.';

  @override
  String get faHeatstrokeAvoid =>
      'Don\'t use ice or ice-cold water.\nDon\'t cover your pet with a wet towel and leave it there.\nDon\'t walk in the afternoon heat, and never leave a pet in a parked car.';

  @override
  String get faHeatstrokeVet =>
      'Heatstroke can harm organs hours later. See a vet today. Flat-faced breeds are at higher risk.';

  @override
  String get faBleedingTitle => 'Bleeding';

  @override
  String get faBleedingSigns => 'Blood from a wound, paw, ear or nose.';

  @override
  String get faBleedingSteps =>
      'Press a clean cloth or gauze firmly on the wound.\nKeep pressing for at least 5 minutes without lifting to check.\nIf blood soaks through, add more cloth on top and keep pressing.\nWrap a bandage firmly, but not too tight, to hold it in place.\nKeep your pet calm and go to a vet.';

  @override
  String get faBleedingAvoid =>
      'Don\'t tie a tight band (tourniquet) unless a vet tells you to.\nDon\'t pull out anything stuck in the wound.\nDon\'t put turmeric, powders or creams on a deep wound.';

  @override
  String get faBleedingVet =>
      'Use SOS for heavy bleeding, spurting blood or bleeding that doesn\'t slow after 10 minutes of pressure.';

  @override
  String get faFractureTitle => 'Broken bones';

  @override
  String get faFractureSigns =>
      'Not putting weight on a leg, swelling, a strange angle, crying when touched.';

  @override
  String get faFractureSteps =>
      'Keep your pet as still as possible. A frightened pet may bite, so be gentle.\nCarry small pets in a box or basket lined with a towel.\nFor a large dog, use a board or a blanket held like a stretcher.\nCover any open wound with a clean cloth.\nGo to a vet straight away.';

  @override
  String get faFractureAvoid =>
      'Don\'t try to straighten the bone.\nDon\'t give human painkillers; many are poisonous to pets.\nDon\'t let your pet walk on the leg.';

  @override
  String get faFractureVet =>
      'Every suspected broken bone needs a vet, and usually an X-ray.';

  @override
  String get faSeizureTitle => 'Fits (seizures)';

  @override
  String get faSeizureSigns =>
      'Falling over, stiff or jerking legs, paddling, drooling, not responding.';

  @override
  String get faSeizureSteps =>
      'Stay calm and note the time the fit started.\nMove furniture and sharp things away. Dim the lights and keep it quiet.\nKeep your hands away from the mouth.\nAfter the fit, keep your pet warm and let them rest; they may be confused for a while.\nCall your vet and tell them how long it lasted.';

  @override
  String get faSeizureAvoid =>
      'Don\'t hold your pet down.\nDon\'t put anything in the mouth; pets don\'t swallow their tongue.\nDon\'t give food or water until they are fully awake.';

  @override
  String get faSeizureVet =>
      'Use SOS if a fit lasts more than 5 minutes or fits come one after another. A first fit always needs a vet visit.';

  @override
  String get faBurnTitle => 'Burns';

  @override
  String get faBurnSigns =>
      'Red or raw skin, blisters, singed fur, or contact with hot liquid, fire or chemicals.';

  @override
  String get faBurnSteps =>
      'Cool the burn under cool running water for 10 minutes.\nFor a chemical burn, rinse with plenty of water for 15 minutes; wear gloves.\nCover loosely with a clean, damp, lint-free cloth.\nKeep your pet warm by wrapping the rest of the body, and go to a vet.';

  @override
  String get faBurnAvoid =>
      'Don\'t use ice, butter, oil, toothpaste or turmeric.\nDon\'t pop blisters.\nDon\'t let your pet lick the burn.';

  @override
  String get faBurnVet =>
      'Burns can be deeper than they look. See a vet the same day.';

  @override
  String get faBiteTitle => 'Snake or insect bite';

  @override
  String get faBiteSigns =>
      'Sudden swelling, pain, puncture marks, bleeding, weakness, drooling or trouble breathing.';

  @override
  String get faBiteSteps =>
      'Keep your pet calm and as still as possible; carry them if you can.\nKeep the bitten part level with or below the heart.\nTake off the collar if the neck or face is swelling.\nFor a bee sting, scrape the sting out with a card.\nGo to the nearest clinic straight away. Use SOS to find one that\'s open.\nIf it\'s safe, note the snake\'s colour and size, or take a photo from a distance.';

  @override
  String get faBiteAvoid =>
      'Don\'t cut the wound or try to suck out venom.\nDon\'t tie a tight band above the bite.\nDon\'t try to catch the snake.';

  @override
  String get faBiteVet =>
      'Every snake bite is an emergency. Go even if your pet seems fine.';

  @override
  String get faTickTitle => 'Removing a tick';

  @override
  String get faTickSigns =>
      'A small grey-brown bump stuck to the skin, often around the ears, neck, armpits or between the toes.';

  @override
  String get faTickSteps =>
      'Wear gloves if you can. Part the fur so you can see the tick clearly.\nUse fine tweezers or a tick hook to grip the tick close to the skin.\nPull straight out, slowly and steadily, without twisting or squeezing.\nClean the spot with antiseptic and wash your hands.\nDrop the tick in alcohol, or seal it in tape before throwing it away.\nWatch for fever, tiredness or pale gums over the next 3 weeks.';

  @override
  String get faTickAvoid =>
      'Don\'t burn the tick or cover it in oil, kerosene or petrol.\nDon\'t squeeze the tick\'s body.\nDon\'t crush ticks with bare fingers.';

  @override
  String get faTickVet =>
      'See a vet if your pet gets a fever, is tired or off food, or has many ticks. Ask about tick prevention.';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get closedNow => 'Closed now';

  @override
  String get copy => 'Copy';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get draftVetReview => 'Draft, to be reviewed by a vet';

  @override
  String get sosCallNearest => 'Call nearest clinic';

  @override
  String get sosGetAddress => 'Get nearest clinic address';

  @override
  String get sosFinding => 'Finding clinics near you…';

  @override
  String get sosLocating => 'Finding where you are…';

  @override
  String get sosUsingGps => 'Using your current location';

  @override
  String sosUsingLastKnown(String time) {
    return 'Using your last known location (from $time)';
  }

  @override
  String sosUsingArea(String area) {
    return 'Location is off. Showing clinics near $area.';
  }

  @override
  String sosLocatingNear(String area) {
    return 'Finding your location… Meanwhile, clinics near $area.';
  }

  @override
  String get sosLocatingLastKnown =>
      'Finding your location… Meanwhile, clinics near your last known location.';

  @override
  String get sosLocationOffHint =>
      'Wrong area? Change it so the list is right.';

  @override
  String get sosTryLocation => 'Try my location again';

  @override
  String get sosChangeArea => 'Change area';

  @override
  String sosSavedClinics(String when) {
    return 'Weak internet: showing clinics saved on $when.';
  }

  @override
  String get sosNoClinics => 'No clinics found nearby. Try another area.';

  @override
  String sosCallClinic(String name) {
    return 'Call $name';
  }

  @override
  String sosAway(String km) {
    return '$km away';
  }

  @override
  String sosDemoCall(String phone) {
    return 'Demo: this would call $phone. No real call is made in the demo.';
  }

  @override
  String get sosShowVet => 'Show this to the vet';

  @override
  String get firstAidTitle => 'First aid';

  @override
  String get firstAidOfflineHint =>
      'Step-by-step guides that work without internet';

  @override
  String get firstAidOffline => 'Works without internet';

  @override
  String get firstAidEmergencyNote =>
      'Not breathing, collapsed or bleeding heavily? Hold SOS now and go to a clinic. These guides help on the way.';

  @override
  String get firstAidSigns => 'Signs';

  @override
  String get firstAidWhatToDo => 'What to do';

  @override
  String get firstAidAvoid => 'Don\'t';

  @override
  String get firstAidWhenVet => 'When to see a vet';

  @override
  String get firstAidTalkToVet => 'Talk to a vet now';

  @override
  String get toxTitle => 'Is it safe?';

  @override
  String get toxTileHint =>
      'Check foods, plants and household things for your pet';

  @override
  String get toxSearchLabel => 'Food, plant or household item';

  @override
  String get toxSearchHint => 'For example: grapes, lily, chocolate';

  @override
  String get toxForWhichPet => 'For which pet?';

  @override
  String get toxKindAll => 'All';

  @override
  String get toxKindFood => 'Food';

  @override
  String get toxKindPlant => 'Plants';

  @override
  String get toxKindHome => 'Around the home';

  @override
  String get toxDanger => 'Dangerous';

  @override
  String get toxCaution => 'Be careful';

  @override
  String get toxSafe => 'Safe in small amounts';

  @override
  String get toxForEachPet => 'For each kind of pet';

  @override
  String get toxAteIt =>
      'Already eaten? Don\'t wait for signs. Get help now and take the packet or a photo with you.';

  @override
  String get toxPoisoningGuide => 'Open the poisoning guide';

  @override
  String get toxNoMatch => 'Not in our list yet';

  @override
  String get toxNoMatchHint =>
      'If you\'re not sure, don\'t give it, and ask a vet.';

  @override
  String get lostIntro =>
      'Every pet gets a QR tag. Anyone who scans it sees a page with your pet\'s photo and can message you or share where they are. Your phone number stays hidden.';

  @override
  String get lostSafeAtHome => 'Safe at home';

  @override
  String lostSinceShort(String when) {
    return 'Lost since $when';
  }

  @override
  String lostPetTitle(String pet) {
    return '$pet · QR tag';
  }

  @override
  String lostIfMissing(String pet) {
    return 'If $pet goes missing';
  }

  @override
  String get lostIfMissingBody =>
      'Mark them lost to share a lost page, alert PawSetu users nearby (if you choose) and make a poster in one tap.';

  @override
  String lostMarkLost(String pet) {
    return 'Mark $pet as lost';
  }

  @override
  String get lostWhereSeen => 'Where was your pet last seen?';

  @override
  String get lostUsingGps => 'Using where you are now';

  @override
  String get lostNearMe => 'Near my location';

  @override
  String get lostWhenSeen => 'When?';

  @override
  String get lostWhenNow => 'Just now';

  @override
  String get lostWhenHour => 'About an hour ago';

  @override
  String get lostWhenMorning => 'This morning';

  @override
  String get lostWhenYesterday => 'Yesterday evening';

  @override
  String get lostNoteLabel => 'Anything that helps people recognise them';

  @override
  String get lostNoteHint => 'For example: red collar, shy with strangers';

  @override
  String get lostAlertNearby => 'Alert PawSetu users within 5 km';

  @override
  String get lostAlertNearbyHint =>
      'Only people who turned on lost-pet alerts get it. They see the lost page, never your number.';

  @override
  String get lostMarkLostConfirm => 'Mark as lost';

  @override
  String lostMarked(String pet) {
    return '$pet is marked lost. Your family has been told.';
  }

  @override
  String lostDemoAlert(int count, String area) {
    return 'Demo: the alert reached $count PawSetu users within 5 km of $area who turned on lost-pet alerts. The messages are in the Demo Outbox; no real alert was sent.';
  }

  @override
  String lostBannerTitle(String pet) {
    return '$pet is marked lost';
  }

  @override
  String lostBannerBody(String when, String area) {
    return 'Since $when, near $area.';
  }

  @override
  String lostAlertsSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alert sent to $count people nearby',
      one: 'Alert sent to 1 person nearby',
      zero: 'No PawSetu users nearby were alerted',
    );
    return '$_temp0';
  }

  @override
  String get lostSightings => 'Sightings';

  @override
  String get lostNoSightings =>
      'No sightings yet. Share the lost page and the poster so more people can help.';

  @override
  String get lostSightingNoDetails => 'Location shared';

  @override
  String get lostMakePoster => 'Make a poster (PDF)';

  @override
  String get lostShareLink => 'Share the lost page';

  @override
  String lostShareText(String pet, String area, String url) {
    return 'Please help! $pet is lost near $area. If you see them, open $url';
  }

  @override
  String lostMarkFound(String pet) {
    return '$pet is found';
  }

  @override
  String lostFoundConfirmTitle(String pet) {
    return 'Is $pet home safe?';
  }

  @override
  String get lostFoundConfirmBody =>
      'We\'ll take down the lost page and tell your family.';

  @override
  String get lostFoundConfirm => 'Yes, found';

  @override
  String lostWelcomeHome(String pet) {
    return 'Welcome home, $pet!';
  }

  @override
  String lostFamilyTitle(String pet) {
    return '$pet is lost';
  }

  @override
  String lostFamilyBody(String name, String area) {
    return '$name marked them lost near $area. Open the lost page to share it.';
  }

  @override
  String lostFoundTitle(String pet) {
    return 'Good news: $pet is home safe';
  }

  @override
  String lostNearbyTitle(String pet) {
    return 'Have you seen $pet? A pet is lost near you';
  }

  @override
  String lostNearbyBody(String area) {
    return 'Last seen near $area. Tap to see the photo and tell the family.';
  }

  @override
  String qrTagHint(String pet) {
    return 'Print this for $pet\'s collar tag. Anyone who scans it can message you without seeing your number.';
  }

  @override
  String qrForPet(String pet) {
    return 'QR code for $pet\'s tag';
  }

  @override
  String get qrPrintTags => 'Print QR tags (PDF)';

  @override
  String get qrOpenPage => 'Open the page';

  @override
  String qrTagsTitle(String pet) {
    return 'QR tags for $pet';
  }

  @override
  String get qrTagsSubtitle => 'Cut out a tag and fix it to the collar';

  @override
  String get qrTagsFooter =>
      'Made with PawSetu. Scanning a tag never shows the family\'s phone number.';

  @override
  String get qrTagScanLine => 'If I\'m alone, scan me to tell my family';

  @override
  String posterTitle(String pet) {
    return 'Lost poster for $pet';
  }

  @override
  String posterHeadline(String species) {
    return 'Lost $species';
  }

  @override
  String posterLastSeen(String area, String when) {
    return 'Last seen near $area, $when';
  }

  @override
  String get posterScan => 'Seen me? Scan this';

  @override
  String get posterScanBody =>
      'Send a message or share where you saw me. My family gets it right away.';

  @override
  String get lostTagInactive => 'This tag isn\'t active';

  @override
  String get lostTagInactiveHint =>
      'The link may be old or mistyped. If you found a pet, take them to the nearest vet clinic: they can scan for a microchip.';

  @override
  String get finderDemoNote =>
      'Demo page: messages and locations go to the Demo Outbox, not to a real family.';

  @override
  String get finderDemoSuffix => '(Demo)';

  @override
  String finderLostHeadline(String pet) {
    return '$pet is lost';
  }

  @override
  String finderLastSeen(String area, String when) {
    return 'Last seen near $area · $when';
  }

  @override
  String finderHello(String pet) {
    return 'Hi, I\'m $pet!';
  }

  @override
  String finderHelloLost(String pet) {
    return 'I\'m $pet. Please help me get home!';
  }

  @override
  String get finderAsk =>
      'If I\'m alone, please tell my family. They\'ll come for me.';

  @override
  String get finderLostAsk =>
      'My family is looking for me. If you can, keep me safe and send them a message or your location.';

  @override
  String get finderContact => 'Contact my family';

  @override
  String get finderShareLocation => 'Share my location';

  @override
  String get finderPrivacy =>
      'PawSetu passes your message on. The family\'s number stays private; leave yours only if you want a call back.';

  @override
  String get finderTips =>
      'Offer water and shade, keep the pet on a lead or in a closed space, and don\'t chase a scared pet.';

  @override
  String get finderContactHint =>
      'Your message goes straight to the family in the PawSetu app.';

  @override
  String get finderMessageLabel => 'Your message';

  @override
  String finderMessageStart(String pet) {
    return 'Hi, I found $pet near ';
  }

  @override
  String get finderYourName => 'Your name (optional)';

  @override
  String get finderYourPhone => 'Your phone (optional)';

  @override
  String get finderPhoneHelper => 'Only if you\'d like the family to call you';

  @override
  String get finderSend => 'Send';

  @override
  String finderSent(String pet) {
    return 'Message sent to $pet\'s family. Thank you!';
  }

  @override
  String finderLocationSent(String pet) {
    return 'Location sent to $pet\'s family. Thank you!';
  }

  @override
  String get finderTooMany =>
      'Too many messages for this tag right now. Please try again in an hour.';

  @override
  String get finderWhereSeen => 'Where are you?';

  @override
  String get finderLocationOff =>
      'Your location is off. Choose the area and add a landmark.';

  @override
  String get finderLandmark => 'Landmark';

  @override
  String get finderLandmarkHint => 'For example: near the metro station';

  @override
  String finderMessageTitle(String pet) {
    return 'Message about $pet from someone who scanned the tag';
  }

  @override
  String finderFrom(String from) {
    return 'from $from';
  }

  @override
  String finderSightingTitle(String pet) {
    return 'Someone shared where they saw $pet';
  }

  @override
  String get devDemoNote =>
      'Demo devices: the readings are simulated so you can try everything.';

  @override
  String get devAdd => 'Add a device';

  @override
  String get devNoneTitle => 'No devices yet';

  @override
  String get devNoneBody =>
      'Pair a GPS collar, activity tracker, feeder, water fountain, camera or litter box.';

  @override
  String get devGpsCollar => 'GPS collar';

  @override
  String get devGpsCollarHint => 'Live location and a safe-zone alert';

  @override
  String get devActivityTracker => 'Activity tracker';

  @override
  String get devActivityTrackerHint => 'Steps and active minutes';

  @override
  String get devFeeder => 'Smart feeder';

  @override
  String get devFeederHint => 'Meals on time, even when you\'re out';

  @override
  String get devFountain => 'Water fountain';

  @override
  String get devFountainHint => 'Water level and filter reminders';

  @override
  String get devCamera => 'Pet camera';

  @override
  String get devCameraHint => 'See your pet while you\'re away';

  @override
  String get devLitterBox => 'Smart litter box';

  @override
  String get devLitterBoxHint => 'Visits and cleaning reminders';

  @override
  String get devPairDemo =>
      'Demo pairing: we\'ll find a demo device for you. Nothing connects over Bluetooth.';

  @override
  String get devStepType => '1. What kind of device?';

  @override
  String get devStepPet => '2. Which pet is it for?';

  @override
  String get devStepFind => '3. Find the device';

  @override
  String get devStepName => '4. Name it';

  @override
  String get devNotForAll =>
      'Some pets are greyed out because this device doesn\'t suit them.';

  @override
  String get devSearch => 'Search for the device';

  @override
  String get devSearching => 'Searching nearby…';

  @override
  String devDefaultName(String pet, String type) {
    return '$pet\'s $type';
  }

  @override
  String get devNameLabel => 'Device name';

  @override
  String devSafeZoneRadius(int metres) {
    return 'Safe zone: $metres m around home';
  }

  @override
  String get devSafeZoneHint =>
      'You\'ll get an alert as soon as the collar leaves this circle.';

  @override
  String get devPair => 'Pair device';

  @override
  String devPaired(String name) {
    return '$name is paired';
  }

  @override
  String get devLiveTitle => 'Coming in Version 2';

  @override
  String get devLiveBody =>
      'Real devices connect in the live version. For now, try the demo devices.';

  @override
  String get devConnected => 'Connected';

  @override
  String devInsideZone(int metres) {
    return 'Inside the safe zone · $metres m from home';
  }

  @override
  String devOutsideZone(int metres) {
    return 'Outside the safe zone! $metres m from home';
  }

  @override
  String devStepsToday(String steps) {
    return '$steps steps today';
  }

  @override
  String devNextMeal(String time) {
    return 'Next meal at $time';
  }

  @override
  String devWaterLevel(int pct) {
    return 'Water level: $pct%';
  }

  @override
  String get devCameraReady => 'Ready';

  @override
  String devLitterVisits(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count visits today',
      one: '1 visit today',
      zero: 'No visits today',
    );
    return '$_temp0';
  }

  @override
  String devUpdated(String time) {
    return 'Updated $time';
  }

  @override
  String get devLocate => 'Locate now';

  @override
  String get devLocated => 'Location updated';

  @override
  String get devEditZone => 'Edit safe zone';

  @override
  String get devNoZone => 'No safe zone set yet. Edit it to get alerts.';

  @override
  String get devAlertSent =>
      'Everyone looking after this pet got an alert (push and SMS).';

  @override
  String get devBackInside => 'Back inside the safe zone.';

  @override
  String get devDemoControls => 'Demo controls';

  @override
  String get devDemoControlsHint =>
      'Try the safe-zone alert without leaving home.';

  @override
  String devDemoWalkOut(String pet) {
    return 'Demo: walk $pet out of the safe zone';
  }

  @override
  String devDemoComeHome(String pet) {
    return 'Demo: bring $pet home';
  }

  @override
  String get devToday => 'Today';

  @override
  String devActiveMinutes(int active, int goal) {
    return '$active of $goal active minutes';
  }

  @override
  String get devNoSessions => 'No walks or play noticed yet today.';

  @override
  String devWalkSession(int minutes, String km) {
    return 'Walk · $minutes min · $km km';
  }

  @override
  String devPlaySession(int minutes) {
    return 'Play · $minutes min';
  }

  @override
  String get devInRoutine => 'Added to the daily routine';

  @override
  String devFlowsToRoutine(String pet) {
    return 'Walks and play from this device are added to $pet\'s daily routine automatically.';
  }

  @override
  String devSynced(int count, String pet) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '1 activity',
    );
    return '$_temp0 added to $pet\'s routine';
  }

  @override
  String devHopper(int pct) {
    return 'Food left in the feeder: $pct%';
  }

  @override
  String get devMealsToday => 'Meals today';

  @override
  String get devNoMealsYet => 'No meals served yet today.';

  @override
  String devMealGrams(int grams) {
    return '$grams g served';
  }

  @override
  String get devFeedNow => 'Feed a small portion now';

  @override
  String devFed(String pet) {
    return 'A small portion was served to $pet and added to today\'s meals.';
  }

  @override
  String devFilterDays(int days) {
    return 'Filter change in $days days';
  }

  @override
  String get devRefillSoon => 'Water is running low. Refill the fountain soon.';

  @override
  String get devCameraPlaceholder =>
      'Live video arrives with real cameras in Version 2.';

  @override
  String get devSnapshot => 'Take a snapshot';

  @override
  String get devSnapshotDemo =>
      'Demo: a real camera would send a photo of your pet here.';

  @override
  String devLastVisit(String time) {
    return 'Last visit at $time';
  }

  @override
  String get devCleanSoon => 'Clean soon';

  @override
  String get devLitterClean => 'Clean';

  @override
  String get devRemove => 'Remove device';

  @override
  String devRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get devRemoveBody =>
      'It will stop sending data. Logs already in the routine stay.';

  @override
  String zoneLeftTitle(String pet) {
    return '$pet has left the safe zone';
  }

  @override
  String zoneLeftBody(String device, int metres) {
    return '$device: now $metres m from home. Tap to see where.';
  }

  @override
  String zoneBackTitle(String pet) {
    return '$pet is back in the safe zone';
  }

  @override
  String get toxChocolateName => 'Chocolate';

  @override
  String get toxChocolateWhy =>
      'Has theobromine and caffeine, which cause vomiting, a racing heart and fits. Dark chocolate and cocoa powder are the most dangerous.';

  @override
  String get toxGrapesName => 'Grapes and raisins';

  @override
  String get toxGrapesWhy =>
      'Even a few grapes or raisins (kishmish) can cause sudden kidney failure in dogs and cats. Birds and rabbits: only a tiny piece as a rare treat.';

  @override
  String get toxOnionGarlicName => 'Onion and garlic';

  @override
  String get toxOnionGarlicWhy =>
      'Raw, cooked or powdered, and in curries and gravies too, they damage red blood cells and cause weakness days later.';

  @override
  String get toxXylitolName => 'Xylitol (sugar-free sweetener)';

  @override
  String get toxXylitolWhy =>
      'Found in sugar-free gum, mints, some peanut butters and medicines. In dogs it causes a sudden drop in blood sugar and liver damage. Keep it away from all pets.';

  @override
  String get toxAlcoholName => 'Alcohol';

  @override
  String get toxAlcoholWhy =>
      'Even small amounts cause vomiting, wobbliness, breathing problems and coma. Raw bread dough with yeast also makes alcohol in the stomach.';

  @override
  String get toxCaffeineName => 'Tea, coffee and caffeine';

  @override
  String get toxCaffeineWhy =>
      'Tea, coffee, energy drinks and caffeine tablets cause restlessness, a racing heart and fits.';

  @override
  String get toxAvocadoName => 'Avocado';

  @override
  String get toxAvocadoWhy =>
      'Very dangerous for birds and rabbits: it can damage the heart. For dogs and cats the stone can block the gut, and the skin and leaves upset the stomach.';

  @override
  String get toxCookedBonesName => 'Cooked bones';

  @override
  String get toxCookedBonesWhy =>
      'Cooked chicken or mutton bones splinter and can choke your pet or tear the gut. Never give cooked bones.';

  @override
  String get toxMilkName => 'Milk';

  @override
  String get toxMilkWhy =>
      'Most adult cats and dogs can\'t digest milk well and get loose motions. Don\'t give milk to birds or rabbits.';

  @override
  String get toxSaltySnacksName => 'Salty snacks (namkeen, chips)';

  @override
  String get toxSaltySnacksWhy =>
      'Namkeen, chips and papad cause thirst and vomiting; large amounts can cause salt poisoning. Birds are especially sensitive.';

  @override
  String get toxSpicyFoodName => 'Spicy food';

  @override
  String get toxSpicyFoodWhy =>
      'Chilli and masala upset the stomach and cause vomiting and loose motions. Curries usually contain onion and garlic too.';

  @override
  String get toxFattyFoodName => 'Fried and fatty food';

  @override
  String get toxFattyFoodWhy =>
      'Fried snacks, ghee, fat trimmings and rich leftovers can cause pancreatitis, a painful swelling of the pancreas.';

  @override
  String get toxSweetsName => 'Sweets (mithai)';

  @override
  String get toxSweetsWhy =>
      'Sugary sweets cause weight gain and tummy upsets, and many contain ghee, chocolate, raisins or sugar-free sweeteners.';

  @override
  String get toxFruitSeedsName => 'Fruit stones and seeds';

  @override
  String get toxFruitSeedsWhy =>
      'Mango stones, apple seeds and the stones of plums, peaches and cherries can choke or block the gut, and some contain cyanide.';

  @override
  String get toxTomatoName => 'Tomato';

  @override
  String get toxTomatoWhy =>
      'A little ripe tomato is usually fine. Green tomatoes, leaves and stems are harmful.';

  @override
  String get toxPeanutsName => 'Peanuts';

  @override
  String get toxPeanutsWhy =>
      'Only plain, unsalted peanuts, a few at a time. Salted or masala peanuts are not safe, and peanut butter must not contain xylitol.';

  @override
  String get toxMangoName => 'Mango';

  @override
  String get toxMangoWhy =>
      'Ripe mango flesh is fine as a small treat. Remove the skin and the stone. Too much causes loose motions.';

  @override
  String get toxAppleName => 'Apple';

  @override
  String get toxAppleWhy =>
      'Apple slices without the seeds and core are a healthy, crunchy treat.';

  @override
  String get toxBananaName => 'Banana';

  @override
  String get toxBananaWhy =>
      'A small piece is a fine treat. It is high in sugar, so keep it small.';

  @override
  String get toxWatermelonName => 'Watermelon';

  @override
  String get toxWatermelonWhy =>
      'Seedless pieces without the rind make a cooling summer treat.';

  @override
  String get toxCarrotName => 'Carrot';

  @override
  String get toxCarrotWhy =>
      'Raw or cooked carrot is a healthy treat. For rabbits, keep carrot as a small treat, because it is sugary.';

  @override
  String get toxRiceName => 'Plain cooked rice';

  @override
  String get toxRiceWhy =>
      'Plain rice with no salt, ghee, onion or masala is gentle on the stomach in small amounts. Rabbits need hay, not rice.';

  @override
  String get toxEggName => 'Cooked egg';

  @override
  String get toxEggWhy =>
      'A fully cooked egg is a good protein treat. Avoid raw egg. Rabbits eat only plants.';

  @override
  String get toxLilyName => 'Lilies';

  @override
  String get toxLilyWhy =>
      'Every part of a lily, even the pollen or the vase water, can cause kidney failure in cats. Keep lilies out of homes with cats.';

  @override
  String get toxSagoPalmName => 'Sago palm (cycas)';

  @override
  String get toxSagoPalmWhy =>
      'Every part is poisonous, the seeds most of all. It causes vomiting and liver failure.';

  @override
  String get toxOleanderName => 'Oleander (kaner)';

  @override
  String get toxOleanderWhy =>
      'Oleander affects the heart. A few leaves or flowers can be fatal.';

  @override
  String get toxCastorName => 'Castor plant (arandi)';

  @override
  String get toxCastorWhy =>
      'Castor seeds contain ricin. Chewing even one or two seeds can be fatal.';

  @override
  String get toxDaturaName => 'Datura (dhatura)';

  @override
  String get toxDaturaWhy =>
      'The seeds and flowers cause a racing heart, wide pupils, confusion and fits.';

  @override
  String get toxLantanaName => 'Lantana';

  @override
  String get toxLantanaWhy =>
      'The berries and leaves of this common hedge plant can damage the liver.';

  @override
  String get toxAloeVeraName => 'Aloe vera';

  @override
  String get toxAloeVeraWhy =>
      'The clear gel is usually fine, but the bitter yellow sap under the skin causes vomiting and loose motions.';

  @override
  String get toxMoneyPlantName => 'Money plant';

  @override
  String get toxMoneyPlantWhy =>
      'Chewing the leaves causes mouth pain, drooling and vomiting.';

  @override
  String get toxSnakePlantName => 'Snake plant';

  @override
  String get toxSnakePlantWhy =>
      'Chewing it can cause drooling, vomiting and loose motions.';

  @override
  String get toxMarigoldName => 'Marigold (genda)';

  @override
  String get toxMarigoldWhy =>
      'Chewing marigolds can cause mild mouth irritation and an upset stomach.';

  @override
  String get toxTulsiName => 'Tulsi (holy basil)';

  @override
  String get toxTulsiWhy =>
      'Tulsi is not known to be poisonous to pets. Large amounts may still upset the stomach.';

  @override
  String get toxArecaPalmName => 'Areca palm';

  @override
  String get toxArecaPalmWhy => 'A pet-friendly houseplant.';

  @override
  String get toxSpiderPlantName => 'Spider plant';

  @override
  String get toxSpiderPlantWhy =>
      'Not poisonous, though cats love to chew it and may vomit a little.';

  @override
  String get toxRatPoisonName => 'Rat poison';

  @override
  String get toxRatPoisonWhy =>
      'Causes internal bleeding or fits, sometimes days later. Take the packet to the vet.';

  @override
  String get toxHumanMedicinesName => 'Human medicines';

  @override
  String get toxHumanMedicinesWhy =>
      'Paracetamol and painkillers like ibuprofen are poisonous to pets. One paracetamol tablet can kill a cat. Give only medicines your vet prescribes.';

  @override
  String get toxMosquitoRepellentName => 'Mosquito coils and vaporisers';

  @override
  String get toxMosquitoRepellentWhy =>
      'The fumes can harm birds\' lungs. Use them away from pets and keep the room aired.';

  @override
  String get toxMothballsName => 'Naphthalene balls';

  @override
  String get toxMothballsWhy =>
      'Poisonous if chewed, and the fumes harm birds. Keep them in closed cupboards.';

  @override
  String get toxNonStickFumesName => 'Non-stick pan fumes';

  @override
  String get toxNonStickFumesWhy =>
      'An overheated non-stick pan gives off fumes that can kill a bird within minutes. Keep birds out of the kitchen.';

  @override
  String get toxPhenylName => 'Phenyl and floor cleaners';

  @override
  String get toxPhenylWhy =>
      'Phenyl and many floor cleaners contain phenols, which are especially poisonous to cats. Let floors dry before pets walk on them.';

  @override
  String reviewedBy(String name) {
    return 'Reviewed by $name';
  }

  @override
  String get featurePaused => 'This feature is switched off for now';

  @override
  String get featurePausedBody =>
      'The PawSetu team has paused it. Please check again later.';

  @override
  String get shopFeatured => 'Featured';

  @override
  String admUsers(int owners, int partners) {
    return 'Users: $owners pet parents, $partners partners';
  }

  @override
  String get admPets => 'Pets';

  @override
  String get admBookings30 => 'Bookings, last 30 days';

  @override
  String get admOrderValue30 => 'Order value, last 30 days';

  @override
  String get admCommission30 => 'Commission earned, last 30 days';

  @override
  String get admPlusMembers => 'Plus members';

  @override
  String get admSos30 => 'SOS activations, last 30 days';

  @override
  String get admByDay => 'By day';

  @override
  String get admByWeek => 'By week';

  @override
  String get admByMonth => 'By month';

  @override
  String get admCommissionReport => 'Commission report';

  @override
  String get admNoNumbers => 'No numbers yet';

  @override
  String get admChartBookingsOrders => 'Bookings and orders';

  @override
  String get admLegendBookings => 'Bookings';

  @override
  String get admLegendOrders => 'Orders';

  @override
  String get admChartMoney => 'Order value and commission';

  @override
  String get admLegendOrderValue => 'Order value';

  @override
  String get admLegendCommission => 'Commission';

  @override
  String get admChartGrowth => 'New users, pets and Plus members';

  @override
  String get admLegendUsers => 'New users';

  @override
  String get admLegendPets => 'New pets';

  @override
  String get admLegendPlus => 'New Plus';

  @override
  String get admChartSos => 'SOS activations';

  @override
  String get admLegendSos => 'SOS';

  @override
  String get admTopClinics => 'Top clinics';

  @override
  String get admTopProducts => 'Top products';

  @override
  String get admBookingsUnit => 'bookings';

  @override
  String get admSoldUnit => 'sold';

  @override
  String admChange(String change) {
    return '$change% vs before';
  }

  @override
  String get admNothingYet => 'Nothing yet';

  @override
  String get admKindClinic => 'Clinic';

  @override
  String get admStatusRejected => 'Rejected';

  @override
  String get admStatusSuspended => 'Suspended';

  @override
  String get admAllKinds => 'All';

  @override
  String admWaitingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count waiting for review',
      one: '1 waiting for review',
    );
    return '$_temp0';
  }

  @override
  String get admNoPending => 'Nothing waiting for approval';

  @override
  String get admNothingHere => 'Nothing here';

  @override
  String admRejectTitle(String name) {
    return 'Reject $name?';
  }

  @override
  String admSuspendTitle(String name) {
    return 'Suspend $name?';
  }

  @override
  String get admReasonDocs => 'Documents are unclear';

  @override
  String get admReasonRegNo => 'Registration number doesn\'t match';

  @override
  String get admReasonDetails => 'Details are missing';

  @override
  String admApprovedToast(String name) {
    return '$name approved';
  }

  @override
  String admRejectedToast(String name) {
    return '$name rejected';
  }

  @override
  String admSuspendedToast(String name) {
    return '$name suspended';
  }

  @override
  String admAppliedOn(String date) {
    return 'Applied $date';
  }

  @override
  String admRegNo(String regNo) {
    return 'Registration no.: $regNo';
  }

  @override
  String get admRegMissing => 'No registration number';

  @override
  String get admRegLooksRight => 'Format looks right';

  @override
  String get admRegCheck => 'Check this number';

  @override
  String get admRegHint =>
      'Always check it against the State Veterinary Council register.';

  @override
  String get admKycDocs => 'KYC documents';

  @override
  String get admNoDocs => 'No documents uploaded yet';

  @override
  String admReasonGiven(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get admApprove => 'Approve';

  @override
  String get admReinstate => 'Approve again';

  @override
  String get admReject => 'Reject';

  @override
  String get admSuspend => 'Suspend';

  @override
  String get admSampleStamp => 'SAMPLE';

  @override
  String get admDocDemoNote =>
      'Demo: sample documents only. Real KYC files open here in the live app.';

  @override
  String get admReasonLabel => 'Reason (the partner sees this)';

  @override
  String get admSearchUsers => 'Search by name, email, phone or city';

  @override
  String get admFilterOwners => 'Pet parents';

  @override
  String get admFilterPartners => 'Partners';

  @override
  String get admFilterAdmins => 'Admins';

  @override
  String admPeopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String get plusTrialChip => 'Plus trial';

  @override
  String get admDeletionPending => 'Deletion requested';

  @override
  String admRoleConfirm(String name, String role) {
    return 'Make $name a $role?';
  }

  @override
  String get admRoleChanged =>
      'Role changed. It applies the next time they open the app.';

  @override
  String admSuspendUserTitle(String name) {
    return 'Pause $name\'s account?';
  }

  @override
  String get admReasonAbuse => 'Abusive behaviour';

  @override
  String get admReasonFraud => 'Payment fraud';

  @override
  String get admReasonFake => 'Fake account';

  @override
  String admUserSuspended(String name) {
    return '$name\'s account is paused';
  }

  @override
  String admUserRestored(String name) {
    return '$name\'s account is active again';
  }

  @override
  String get admCity => 'City';

  @override
  String get admPlanLabel => 'Plan';

  @override
  String admPlusTill(String date) {
    return 'Plus till $date';
  }

  @override
  String admTrialTill(String date) {
    return 'Plus trial till $date';
  }

  @override
  String get admJoined => 'Joined';

  @override
  String admDeletionOn(String date) {
    return 'Account will be deleted on $date';
  }

  @override
  String get admNotYourself =>
      'You can\'t change your own role or pause yourself.';

  @override
  String get admSaveRole => 'Save role';

  @override
  String get admUnsuspend => 'Make active again';

  @override
  String get admSuspendUser => 'Pause account';

  @override
  String get admTabProducts => 'Products';

  @override
  String get admTabCategories => 'Categories';

  @override
  String get admTabPlaces => 'Clinics and services';

  @override
  String get admTabSellers => 'Sellers';

  @override
  String get admTabPartners => 'Partner shops';

  @override
  String get admTabBanners => 'Banners';

  @override
  String get admSearchProducts => 'Search products, brands or sellers';

  @override
  String get admFeatured => 'Featured';

  @override
  String get admHidden => 'Hidden';

  @override
  String get admLowStock => 'Low stock';

  @override
  String get admPartnerLinks => 'Partner links';

  @override
  String admShowingOf(int shown, int total) {
    return 'Showing $shown of $total. Search to narrow down.';
  }

  @override
  String admProductsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get admPartnerLink => 'Partner link';

  @override
  String admStock(int count) {
    return 'Stock $count';
  }

  @override
  String get admUnfeature => 'Remove from featured';

  @override
  String get admFeature => 'Feature in the Shop';

  @override
  String get admShowInShop => 'Show in the Shop';

  @override
  String admCategoryNote(String food, String other) {
    return 'Default margin: $food% on food, $other% on everything else. You can set a different margin for any category.';
  }

  @override
  String admMarginCustom(String pct) {
    return 'Margin $pct% (own rate)';
  }

  @override
  String admMarginDefault(String pct) {
    return 'Margin $pct% (default)';
  }

  @override
  String admMarginFor(String name) {
    return 'Margin for $name';
  }

  @override
  String get admEmptyDefault => 'Leave empty to use the default';

  @override
  String get admSellerNote =>
      'Sellers are approved in Approvals. Here you can give a seller its own margin.';

  @override
  String get admMarginStandard => 'Standard margin';

  @override
  String get admEditMargin => 'Change rate';

  @override
  String get admPartnersNote =>
      'Affiliate partner shops: people buy on the partner\'s own website and PawSetu earns a commission.';

  @override
  String admPartnerLine(String pct, int clicks) {
    return 'Commission $pct% · $clicks clicks';
  }

  @override
  String get admAddPartner => 'Add partner shop';

  @override
  String get admPartnerName => 'Shop name';

  @override
  String get admPartnerUrl => 'Website (https://…)';

  @override
  String get admPartnerCommission => 'Commission';

  @override
  String get admBannersNote =>
      'Banners show on Home or in the Shop. Only banners that are switched on are shown.';

  @override
  String get admPlaceShop => 'Shop';

  @override
  String get admPlaceHome => 'Home';

  @override
  String get admBannerShown => 'Show this banner';

  @override
  String get admNewBanner => 'New banner';

  @override
  String get admEditBanner => 'Edit banner';

  @override
  String get admBannerTitle => 'Title';

  @override
  String get admBannerBody => 'Short text';

  @override
  String get admBannerLink => 'Opens (app page)';

  @override
  String get admBannerLinkHelp =>
      'For example /me/plus or /shop/search?q=food. Leave empty for no link.';

  @override
  String get admToneOffer => 'Offer (orange)';

  @override
  String get admToneNews => 'News (green)';

  @override
  String get admPlacesNote =>
      'Booking commission for each clinic or provider. Empty means the rate for its type in Plans and settings.';

  @override
  String admRateCustom(String pct) {
    return 'Commission $pct% (own rate)';
  }

  @override
  String admRateStandard(String pct) {
    return 'Commission $pct% (standard)';
  }

  @override
  String admRateFor(String name) {
    return 'Commission for $name';
  }

  @override
  String get hpStatusOpen => 'Open';

  @override
  String get hpStatusInProgress => 'In progress';

  @override
  String get hpStatusResolved => 'Resolved';

  @override
  String get admNeedsReply => 'Needs a reply';

  @override
  String get admNotResolved => 'Not resolved';

  @override
  String get admEveryone => 'Everyone';

  @override
  String get admNoTickets => 'No tickets here';

  @override
  String get hpSupportTeam => 'PawSetu support';

  @override
  String get hpNewReply => 'New reply';

  @override
  String hpRefunded(String amount) {
    return 'Refunded $amount';
  }

  @override
  String get admTicketTitle => 'Ticket';

  @override
  String get admTicketMissing => 'This ticket isn\'t available';

  @override
  String get admAssignee => 'Assigned to';

  @override
  String get admUnassigned => 'Not assigned';

  @override
  String get admConversation => 'Conversation';

  @override
  String admReplyHint(String name) {
    return 'Reply to $name';
  }

  @override
  String admReplySent(String name) {
    return 'Reply sent. $name gets a notification.';
  }

  @override
  String get admResolveAfter => 'Mark as resolved after sending';

  @override
  String admLinkMissing(String type) {
    return 'The linked item can\'t be found ($type).';
  }

  @override
  String admOrderLine(int count, String seller) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0 from $seller';
  }

  @override
  String admPaid(String amount) {
    return 'Paid $amount';
  }

  @override
  String admRefundDone(String amount, String date) {
    return 'Refunded $amount on $date (demo)';
  }

  @override
  String get admRefundButton => 'Refund (demo)';

  @override
  String get admRefundAmount => 'Refund amount';

  @override
  String admRefundMax(String amount) {
    return 'Up to $amount, the amount paid';
  }

  @override
  String admRefundConfirm(String amount, String name) {
    return 'Refund $amount to $name?';
  }

  @override
  String get admRefundDemoTitle => 'Demo refund';

  @override
  String admRefundDemoBody(String amount, String name) {
    return '$name is told that $amount is refunded. This is a demo: no real money moved.';
  }

  @override
  String hpRaisedOn(String date) {
    return 'Raised $date';
  }

  @override
  String admAssignedTo(String name) {
    return 'Assigned to $name';
  }

  @override
  String get hpWriteReply => 'Write a reply';

  @override
  String get hpTopicRefund => 'Refund';

  @override
  String get hpTopicLate => 'Late or didn\'t come';

  @override
  String get hpTopicQuality => 'Quality problem';

  @override
  String get hpTopicBehaviour => 'Rude or unsafe behaviour';

  @override
  String get hpTopicApp => 'App problem';

  @override
  String get hpTopicOther => 'Something else';

  @override
  String get hpLinkBooking => 'Booking';

  @override
  String get hpLinkOrder => 'Order';

  @override
  String get hpLinkChat => 'Chat';

  @override
  String get hpLinkOther => 'General';

  @override
  String admReportsOpen(int count) {
    return 'Open ($count)';
  }

  @override
  String get admReportsClosed => 'Closed';

  @override
  String get admNoReports => 'No reports to review';

  @override
  String get admReviewHidden => 'Review hidden';

  @override
  String get admReviewRestored => 'Review shown again';

  @override
  String get admReportHandled => 'Marked as handled';

  @override
  String get admReportDismissed => 'Report dismissed';

  @override
  String get admReportReview => 'Reported review';

  @override
  String get admReportChat => 'Reported chat';

  @override
  String get admReportContent => 'Reported content';

  @override
  String admReporterSays(String text) {
    return 'Reporter says: $text';
  }

  @override
  String admReportedBy(String name) {
    return 'Reported by $name';
  }

  @override
  String admClosedOn(String date) {
    return 'closed $date';
  }

  @override
  String get admHideReview => 'Hide review';

  @override
  String get admMarkHandled => 'Mark as handled';

  @override
  String get admDismiss => 'Dismiss';

  @override
  String get admRestoreReview => 'Show review again';

  @override
  String get admSearchOutbox => 'Search by phone, email or text';

  @override
  String admAllCount(int count) {
    return 'All ($count)';
  }

  @override
  String get admChannelSms => 'SMS';

  @override
  String get admChannelWhatsapp => 'WhatsApp';

  @override
  String get admChannelEmail => 'Email';

  @override
  String get admChannelPush => 'Push';

  @override
  String get admAuditNote =>
      'Every change made in the admin panel, newest first.';

  @override
  String get admSearchAudit => 'Search by person, action or item';

  @override
  String get admActApprove => 'Approved a partner';

  @override
  String get admActReject => 'Rejected a partner';

  @override
  String get admActSuspendPartner => 'Suspended a partner';

  @override
  String get admActSuspendUser => 'Paused an account';

  @override
  String get admActUnsuspendUser => 'Made an account active again';

  @override
  String get admActRole => 'Changed a role';

  @override
  String get admActTicketReply => 'Replied to a ticket';

  @override
  String get admActTicketStatus => 'Changed a ticket\'s status';

  @override
  String get admActTicketAssign => 'Assigned a ticket';

  @override
  String get admActRefund => 'Gave a demo refund';

  @override
  String get admActHide => 'Hid a review';

  @override
  String get admActRestore => 'Showed a review again';

  @override
  String get admActDismiss => 'Dismissed a report';

  @override
  String get admActHandled => 'Handled a report';

  @override
  String get admActCouponNew => 'Created a coupon';

  @override
  String get admActCouponEdit => 'Changed a coupon';

  @override
  String get admActProduct => 'Changed a product';

  @override
  String get admActBannerNew => 'Created a banner';

  @override
  String get admActBannerEdit => 'Changed a banner';

  @override
  String get admActSeller => 'Changed a seller';

  @override
  String get admActPartnerStore => 'Changed a partner shop';

  @override
  String get admActPlace => 'Changed a clinic or provider';

  @override
  String get admActSettings => 'Changed settings';

  @override
  String get admSettingsNote =>
      'Changes reach the app straight away, no update needed.';

  @override
  String admLastChanged(String when) {
    return 'Last changed $when.';
  }

  @override
  String get admPlanPrices => 'Plan prices';

  @override
  String get admPlusMonthly => 'Plus, monthly';

  @override
  String get admPlusYearly => 'Plus, yearly';

  @override
  String get admTrialDays => 'Free trial';

  @override
  String get admDaysUnit => 'days';

  @override
  String get admPlanLimits => 'Plan limits';

  @override
  String get admBookingCommission => 'Booking commission';

  @override
  String get admDefaultRate => 'Default rate';

  @override
  String get admRateClinic => 'Vet clinics';

  @override
  String get admRateGroomer => 'Groomers';

  @override
  String get admRateTrainer => 'Trainers';

  @override
  String get admRateBoarder => 'Boarding and sitting';

  @override
  String get admRateWalker => 'Dog walkers';

  @override
  String get admProviderRateNote =>
      'A clinic or provider can also have its own rate: Catalogue → Clinics and services.';

  @override
  String get admShopMoney => 'Shop margins and delivery';

  @override
  String get admFoodMargin => 'Margin on food';

  @override
  String get admOtherMargin => 'Margin on other items';

  @override
  String get admVideoDiscount => 'Plus discount on video vet fees';

  @override
  String get admDeliveryFee => 'Delivery fee';

  @override
  String get admFreeDeliveryFree => 'Free delivery above (Free plan)';

  @override
  String get admFreeDeliveryPlus => 'Free delivery above (Plus)';

  @override
  String get admFeatureFlags => 'Feature switches';

  @override
  String get admReferrals => 'Referrals';

  @override
  String get admReferralReward => 'Reward for each friend';

  @override
  String get admCoupons => 'Coupons';

  @override
  String get admNewCoupon => 'New coupon';

  @override
  String get admVaccineSchedules => 'Vaccine schedules';

  @override
  String get admVaccineNote =>
      'Indicative timings. Change a timing after a vet has reviewed it; every pet\'s schedule updates.';

  @override
  String get admContentReview => 'Vet review of content';

  @override
  String get admContentReviewNote =>
      'Until a vet reviews it, this content shows \"Draft, to be reviewed by a vet\".';

  @override
  String get admUsesDefault => 'Default';

  @override
  String get admSavedLive => 'Saved. The app uses the new value now.';

  @override
  String get admLimit => 'Limit';

  @override
  String get admLimitPets => 'Pets';

  @override
  String get admLimitFamily => 'Family members';

  @override
  String get admLimitTeleVet => 'Tele-vet chats a month';

  @override
  String get admLimitMessages => 'Messages per tele-vet chat';

  @override
  String get admLimitWords => 'Words per message';

  @override
  String get admLimitHours => 'Tele-vet chat open for';

  @override
  String get admLimitAi => 'Ask PawSetu questions a month';

  @override
  String get admLimitStorage => 'Storage';

  @override
  String get admLimitVideo => 'Video length';

  @override
  String get admHoursUnit => 'hours';

  @override
  String get admSecondsUnit => 'seconds';

  @override
  String get admUnlimited => 'Unlimited';

  @override
  String get admUnlimitedNote => '999 or more means unlimited.';

  @override
  String get admFlagAi => 'Ask PawSetu';

  @override
  String get admFlagAiHint => 'The AI pet assistant';

  @override
  String get admFlagDevices => 'Connected devices';

  @override
  String get admFlagDevicesHint => 'Collars, feeders and other smart devices';

  @override
  String get admFlagLost => 'Lost pet alerts nearby';

  @override
  String get admFlagLostHint => 'Alerts to app users within 5 km';

  @override
  String get admFlagReferrals => 'Refer a friend';

  @override
  String get admFlagReferralsHint => 'Referral codes and rewards';

  @override
  String admCouponPercent(int pct, String max) {
    return '$pct% off up to $max';
  }

  @override
  String admCouponFlat(String amount) {
    return '$amount off';
  }

  @override
  String admCouponMin(String amount) {
    return 'min. order $amount';
  }

  @override
  String admCouponTill(String date) {
    return 'till $date';
  }

  @override
  String admCouponUses(int used, int max) {
    return 'used $used of $max';
  }

  @override
  String get admCouponActive => 'Coupon on';

  @override
  String admPersonalCoupons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personal referral coupons are not shown.',
      one: '1 personal referral coupon is not shown.',
    );
    return '$_temp0';
  }

  @override
  String get admCouponCodeHelp =>
      '4 to 16 letters or digits, for example DIWALI20';

  @override
  String get admCouponDescription => 'Description people see';

  @override
  String get admCouponTypePercent => 'Percent off';

  @override
  String get admCouponTypeFlat => 'Amount off';

  @override
  String get admCouponPercentOff => 'Percent off';

  @override
  String get admCouponAmountOff => 'Amount off';

  @override
  String get admCouponMaxDiscount => 'Maximum discount';

  @override
  String get admCouponMinOrder => 'Minimum order';

  @override
  String get admCouponMaxUses => 'How many times it can be used';

  @override
  String get admCouponValidTill => 'Valid till';

  @override
  String get admDogSchedule => 'Dogs';

  @override
  String get admCatSchedule => 'Cats';

  @override
  String get admAskVetTiming => 'Optional, timing as the vet advises';

  @override
  String admEveryYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every year',
    );
    return '$_temp0';
  }

  @override
  String admWeeksRange(int from, int to) {
    return 'Age $from to $to weeks';
  }

  @override
  String admBoosterEvery(String name) {
    return '$name booster: every how many years?';
  }

  @override
  String get admYearsUnit => 'years';

  @override
  String admFromWeek(String name) {
    return '$name: from which week of age?';
  }

  @override
  String admToWeek(String name) {
    return '$name: up to which week of age?';
  }

  @override
  String get admWeeksUnit => 'weeks';

  @override
  String get admAreaFirstAid => 'First-aid guides';

  @override
  String get admAreaToxic => 'Toxic food and plant checker';

  @override
  String get admAreaVaccines => 'Vaccine schedules';

  @override
  String get admDraft => 'Draft';

  @override
  String get admReviewed => 'Reviewed';

  @override
  String get admReviewSheetNote =>
      'Enter the name and registration number of the vet who checked this content.';

  @override
  String get admReviewerName => 'Vet\'s name and registration no.';

  @override
  String get admMarkReviewed => 'Mark as reviewed';

  @override
  String get admBackToDraft => 'Back to draft';

  @override
  String get admKindShop => 'Shop';

  @override
  String get admKindBooking => 'Bookings';

  @override
  String get admDownloadCsv => 'Download CSV';

  @override
  String get admColPartner => 'Partner';

  @override
  String get admColType => 'Type';

  @override
  String get admColCount => 'Count';

  @override
  String get admColGross => 'Gross';

  @override
  String get admColCommission => 'Commission';

  @override
  String get admColPayout => 'Payout';

  @override
  String get admBookingCommissionShort => 'Booking commission';

  @override
  String get admShopMargin => 'Shop margin';

  @override
  String get admPlusRevenue => 'Plus payments';

  @override
  String get admRefunds => 'Refunds';

  @override
  String get admPlatformTotal => 'PawSetu earned';

  @override
  String get admReportDemoNote =>
      'Demo money: all payments in Version 1 are simulated. Tax fields are placeholders.';

  @override
  String get admByPartner => 'By partner';

  @override
  String admLineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sales',
      one: '1 sale',
    );
    return '$_temp0';
  }

  @override
  String admNoteApproved(String name) {
    return '$name is approved and now visible to pet parents';
  }

  @override
  String admNoteRejected(String name) {
    return '$name was not approved';
  }

  @override
  String admNoteSuspended(String name) {
    return '$name is paused';
  }

  @override
  String hpReplyTitle(String subject) {
    return 'Support replied: $subject';
  }

  @override
  String hpResolvedTitle(String subject) {
    return 'Resolved: $subject';
  }

  @override
  String hpRefundTitle(int amount) {
    return 'Refund of ₹$amount is on its way';
  }

  @override
  String get hpRefundBody => 'Demo refund: no real money moved.';

  @override
  String hpNewForSupport(String name) {
    return 'New message from $name';
  }

  @override
  String get hpIntroTitle => 'We\'re here to help';

  @override
  String get hpIntroBody =>
      'Raise a complaint or question about a booking, order or chat. We usually reply within a day.';

  @override
  String get hpIntroPlus =>
      'Plus members get priority support: we usually reply within 4 hours.';

  @override
  String get hpRaise => 'Raise a complaint';

  @override
  String get hpYourTickets => 'Your tickets';

  @override
  String get hpNoTickets =>
      'No tickets yet. If something goes wrong, tell us here.';

  @override
  String get hpQuickAnswers => 'Quick answers';

  @override
  String get hpFaqRefundQ => 'How do refunds work?';

  @override
  String get hpFaqRefundA =>
      'If you paid online and cancel in time, the money goes back to the same payment method in 5 to 7 working days. For other problems, raise a complaint and we\'ll check.';

  @override
  String get hpFaqCancelQ => 'How do I cancel a booking?';

  @override
  String get hpFaqCancelA =>
      'Open Book, then My bookings. Choose the booking and tap Cancel booking. The clinic\'s cancellation time is shown there.';

  @override
  String get hpFaqUrgentQ => 'My pet needs help right now';

  @override
  String get hpFaqUrgentA =>
      'Use the red SOS button on Home: hold it for 2 seconds to reach the nearest clinic. Don\'t wait for a reply here.';

  @override
  String get hpFaqDataQ => 'How do I get or delete my data?';

  @override
  String get hpFaqDataA =>
      'Go to Me, then Privacy centre, to download your data or delete your account.';

  @override
  String get hpAbout => 'What is it about?';

  @override
  String get hpPickItem => 'Choose a booking or order';

  @override
  String get hpSomethingElse => 'Something else';

  @override
  String get hpTopic => 'Topic';

  @override
  String get hpSubject => 'Subject (optional)';

  @override
  String get hpDetails => 'What happened?';

  @override
  String get hpDetailsHelp =>
      'At least 10 characters. Add dates, names and amounts if you can.';

  @override
  String get hpSend => 'Send to support';

  @override
  String get hpSent => 'Sent to PawSetu support';

  @override
  String get hpReplyTime => 'We usually reply within a day.';

  @override
  String get hpReplyTimePlus =>
      'Plus priority support: we usually reply within 4 hours.';

  @override
  String get hpTicketTitle => 'Your ticket';

  @override
  String get hpResolvedNote =>
      'Marked as resolved. Reply below if you still need help.';

  @override
  String get hpReopenHint => 'Still need help? Write here to reopen';

  @override
  String get hpGetHelpBooking => 'Get help with this booking';

  @override
  String get plusTrialStartedTitle => 'Your free trial has started';

  @override
  String plusTrialStartedBody(int days, String date) {
    return 'You have every Plus feature for $days days, till $date. Demo: nothing is charged.';
  }

  @override
  String get plusTrialUsed => 'You\'ve already used your free trial.';

  @override
  String get plusPayYearly => 'PawSetu Plus, 1 year';

  @override
  String get plusPayMonthly => 'PawSetu Plus, 1 month';

  @override
  String get plusWelcomeTitle => 'Welcome to PawSetu Plus!';

  @override
  String plusWelcomeBody(String date) {
    return 'Plus is on. It renews on $date. This was a demo payment: no money moved.';
  }

  @override
  String get plusKeepAfterTrial => 'Keep Plus after your trial';

  @override
  String get plusChoosePlan => 'Choose your plan';

  @override
  String plusBuy(String amount) {
    return 'Get Plus for $amount';
  }

  @override
  String plusStartsAfterTrial(String date) {
    return 'Your paid plan starts when the trial ends on $date.';
  }

  @override
  String plusStartTrial(int days) {
    return 'Start $days-day free trial';
  }

  @override
  String plusTrialNote(int days) {
    return 'Free for $days days. No card needed in the demo.';
  }

  @override
  String get plusAutoRenew => 'Renew automatically';

  @override
  String plusAutoRenewOn(String date) {
    return 'Renews on $date';
  }

  @override
  String plusAutoRenewOff(String date) {
    return 'Plus stays till $date, then you move to Free';
  }

  @override
  String get plusDemoNote =>
      'Demo: no money is charged and nothing renews for real.';

  @override
  String plusOnTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Plus trial: $days days left',
      one: 'Plus trial: 1 day left',
      zero: 'Plus trial ends today',
    );
    return '$_temp0';
  }

  @override
  String plusTrialEnds(String date) {
    return 'Your trial ends on $date.';
  }

  @override
  String get plusYouHavePlus => 'You have PawSetu Plus';

  @override
  String plusRenewsOn(String date) {
    return 'Renews on $date';
  }

  @override
  String plusEndsOn(String date) {
    return 'Ends on $date';
  }

  @override
  String get plusYouAreFree => 'You\'re on the Free plan';

  @override
  String get plusFreeBody =>
      'Upgrade for video vet calls, unlimited pets and more.';

  @override
  String plusMinutes(int count) {
    return '$count min';
  }

  @override
  String plusSeconds(int count) {
    return '$count sec';
  }

  @override
  String get plusRowPets => 'Pets';

  @override
  String get plusRowFamily => 'Family members';

  @override
  String get plusRowVideo => 'Video vet calls';

  @override
  String get plusRowTeleVet => 'Tele-vet chats';

  @override
  String get plusRowMessages => 'Chat length';

  @override
  String get plusRowAi => 'Ask PawSetu';

  @override
  String get plusRowStorage => 'Photo and document storage';

  @override
  String get plusRowVideoLength => 'Video length in album';

  @override
  String get plusRowVideoDiscount => 'Off vet video fees';

  @override
  String get plusRowDelivery => 'Free delivery';

  @override
  String get plusRowSupport => 'Support';

  @override
  String get plusYes => 'Yes';

  @override
  String plusPerMonth(String value) {
    return '$value a month';
  }

  @override
  String plusMessagesWords(String messages, String words) {
    return '$messages messages, $words words each';
  }

  @override
  String plusAbove(String amount) {
    return 'above $amount';
  }

  @override
  String get plusStandard => 'Standard';

  @override
  String get plusPriority => 'Priority';

  @override
  String get plusYearly => 'Yearly';

  @override
  String get plusMonthly => 'Monthly';

  @override
  String get plusPerYear => 'a year';

  @override
  String get plusPerMonthPrice => 'a month';

  @override
  String plusSave(int pct) {
    return 'Save $pct%';
  }

  @override
  String plusTrialEndingSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Your Plus trial ends in $days days. Choose a plan to keep Plus.',
      one: 'Your Plus trial ends tomorrow. Choose a plan to keep Plus.',
      zero: 'Your Plus trial ends today. Choose a plan to keep Plus.',
    );
    return '$_temp0';
  }

  @override
  String get referTitle => 'Refer a friend';

  @override
  String get referInvalid =>
      'That code isn\'t valid, or you\'ve already used a code.';

  @override
  String get referDoneTitle => 'Code applied!';

  @override
  String referDoneBody(String amount, String code) {
    return 'You and your friend each get $amount off. Your coupon: $code. Use it in the Shop at checkout.';
  }

  @override
  String get referPaused => 'Refer a friend is paused right now.';

  @override
  String referHeadline(String amount) {
    return 'Give $amount, get $amount';
  }

  @override
  String referBody(String amount) {
    return 'When a friend joins PawSetu with your code, you both get a $amount Shop coupon.';
  }

  @override
  String get referYourCode => 'Your code';

  @override
  String referShareText(String code, String amount) {
    return 'Join me on PawSetu, the app for pet parents! Use my code $code and we both get $amount off in the PawSetu Shop.';
  }

  @override
  String referFriendsJoined(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count friends joined with your code',
      one: '1 friend joined with your code',
      zero: 'No friends have joined with your code yet',
    );
    return '$_temp0';
  }

  @override
  String get referHaveCode => 'Got a friend\'s code?';

  @override
  String get referEnterCode => 'Friend\'s code';

  @override
  String get referApply => 'Apply code';

  @override
  String get referYourRewards => 'Your reward coupons';

  @override
  String referCouponLine(String amount, String min, String date) {
    return '$amount off orders above $min, till $date';
  }

  @override
  String get referUsed => 'Used';

  @override
  String get referDemoNote =>
      'Demo: coupons work in the demo Shop. No real money.';

  @override
  String prvExportReady(int parts, int kb) {
    return 'Your file is ready: $parts sections, $kb KB.';
  }

  @override
  String get prvExportSubject => 'My PawSetu data';

  @override
  String get prvDeleteConfirmTitle => 'Delete your account?';

  @override
  String prvDeleteConfirmBody(String date, int days) {
    return 'Your account, pets and records will be deleted on $date. Sign in within $days days and cancel if you change your mind.';
  }

  @override
  String get prvDeleteButton => 'Delete my account';

  @override
  String get prvDeleteRequestedTitle => 'Deletion scheduled';

  @override
  String prvDeleteRequestedBody(String date) {
    return 'Your account will be deleted on $date. Demo: nothing is deleted for real.';
  }

  @override
  String get prvConsentLost => 'Lost pet alerts near me';

  @override
  String get prvConsentLostHint =>
      'Get an alert when a pet is lost within 5 km';

  @override
  String get prvConsentAnalytics => 'Help improve PawSetu';

  @override
  String get prvConsentAnalyticsHint =>
      'Share anonymous app usage (no names or photos)';

  @override
  String get prvConsentMarketing => 'Offers and news';

  @override
  String get prvConsentMarketingHint =>
      'Occasional offers by SMS, WhatsApp or email';

  @override
  String get prvConsentPartners => 'Share health summary with clinics I book';

  @override
  String get prvConsentPartnersHint =>
      'Helps the vet prepare before your visit';

  @override
  String prvDeletionPending(String date) {
    return 'Your account will be deleted on $date. Tap to keep it.';
  }

  @override
  String get prvCancelDeletion => 'Keep my account';

  @override
  String get prvDeletionCancelled => 'Deletion cancelled. Your account stays.';

  @override
  String get prvIntro =>
      'You control your data. Choose what you share, download a copy of everything, or delete your account.';

  @override
  String get prvConsents => 'What you share';

  @override
  String get prvDownloadTitle => 'Download my data';

  @override
  String get prvDownloadBody =>
      'Get a file with your profile, pets, health records, bookings, orders, chats and more.';

  @override
  String get prvDownloadButton => 'Download my data';

  @override
  String get prvDeleteTitle => 'Delete my account';

  @override
  String prvDeleteBody(int days) {
    return 'Your account is deleted $days days after you ask. Until then you can sign in and cancel.';
  }

  @override
  String get prvDemoNote =>
      'Demo: the file is made on your device. In the live app we also email you a download link.';

  @override
  String get suspTitle => 'Your account is paused';

  @override
  String get suspBody =>
      'Our team paused this account. If you think this is a mistake, contact PawSetu support.';

  @override
  String get suspContact => 'Contact support';

  @override
  String get suspContactBody =>
      'Demo: write to support@example.com. In the live app this opens your email.';
}
