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
}
