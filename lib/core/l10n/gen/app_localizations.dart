import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PawSetu'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this. Check your internet and try again.'**
  String get errorBody;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill this in'**
  String get fieldRequired;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @comingInPhase.
  ///
  /// In en, this message translates to:
  /// **'This part of PawSetu arrives in Phase {phase}. Everything else you see already works.'**
  String comingInPhase(int phase);

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'We can\'t find that page'**
  String get notFoundTitle;

  /// No description provided for @notFoundBody.
  ///
  /// In en, this message translates to:
  /// **'The link may be old. Let\'s take you home.'**
  String get notFoundBody;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goHome;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepOf(int step, int total);

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get tabHealth;

  /// No description provided for @tabBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get tabBook;

  /// No description provided for @tabShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get tabShop;

  /// No description provided for @tabMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabMe;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @switchPet.
  ///
  /// In en, this message translates to:
  /// **'Switch pet'**
  String get switchPet;

  /// No description provided for @allPets.
  ///
  /// In en, this message translates to:
  /// **'All pets'**
  String get allPets;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'Add pet'**
  String get addPet;

  /// No description provided for @petProfile.
  ///
  /// In en, this message translates to:
  /// **'Pet profile'**
  String get petProfile;

  /// No description provided for @openPetProfile.
  ///
  /// In en, this message translates to:
  /// **'Open {name}\'s profile'**
  String openPetProfile(String name);

  /// No description provided for @petParent.
  ///
  /// In en, this message translates to:
  /// **'Pet parent'**
  String get petParent;

  /// No description provided for @sosTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency help'**
  String get sosTitle;

  /// No description provided for @sosSemantic.
  ///
  /// In en, this message translates to:
  /// **'SOS emergency button'**
  String get sosSemantic;

  /// No description provided for @sosHoldHint.
  ///
  /// In en, this message translates to:
  /// **'Hold for 2 seconds to activate'**
  String get sosHoldHint;

  /// No description provided for @sosConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Need emergency help?'**
  String get sosConfirmTitle;

  /// No description provided for @sosConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show the nearest open clinics so you can call or go there.'**
  String get sosConfirmBody;

  /// No description provided for @sosGetHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help now'**
  String get sosGetHelp;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @noPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add your first pet'**
  String get noPetsTitle;

  /// No description provided for @noPetsBody.
  ///
  /// In en, this message translates to:
  /// **'Only a name and species are needed. You can add more later.'**
  String get noPetsBody;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @qaBookVet.
  ///
  /// In en, this message translates to:
  /// **'Book vet'**
  String get qaBookVet;

  /// No description provided for @qaLogWalk.
  ///
  /// In en, this message translates to:
  /// **'Log walk'**
  String get qaLogWalk;

  /// No description provided for @qaAskVet.
  ///
  /// In en, this message translates to:
  /// **'Ask a vet'**
  String get qaAskVet;

  /// No description provided for @qaAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get qaAddPhoto;

  /// No description provided for @weightValue.
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String weightValue(String value);

  /// No description provided for @speciesDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get speciesDog;

  /// No description provided for @speciesCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get speciesCat;

  /// No description provided for @speciesBird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get speciesBird;

  /// No description provided for @speciesRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get speciesRabbit;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @petName.
  ///
  /// In en, this message translates to:
  /// **'Pet\'s name'**
  String get petName;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 yr} other{{years} yrs}}'**
  String ageYears(int years);

  /// No description provided for @ageMonths.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =1{1 mo} other{{months} mo}}'**
  String ageMonths(int months);

  /// No description provided for @ageYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} yrs {months} mo'**
  String ageYearsMonths(int years, int months);

  /// No description provided for @stagePuppy.
  ///
  /// In en, this message translates to:
  /// **'Puppy'**
  String get stagePuppy;

  /// No description provided for @stageKitten.
  ///
  /// In en, this message translates to:
  /// **'Kitten'**
  String get stageKitten;

  /// No description provided for @stageYoung.
  ///
  /// In en, this message translates to:
  /// **'Young'**
  String get stageYoung;

  /// No description provided for @stageAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get stageAdult;

  /// No description provided for @stageSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get stageSenior;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get genderUnknown;

  /// No description provided for @birdLegalNote.
  ///
  /// In en, this message translates to:
  /// **'Native Indian birds such as the rose-ringed (Indian ringneck), Alexandrine and plum-headed parakeets, munias and mynas are protected wildlife under the Wild Life (Protection) Act, 1972 and can\'t legally be kept as pets, so they aren\'t listed.'**
  String get birdLegalNote;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleCoowner.
  ///
  /// In en, this message translates to:
  /// **'Co-owner'**
  String get roleCoowner;

  /// No description provided for @roleCarer.
  ///
  /// In en, this message translates to:
  /// **'Carer'**
  String get roleCarer;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @rolePetParent.
  ///
  /// In en, this message translates to:
  /// **'Pet parent'**
  String get rolePetParent;

  /// No description provided for @roleVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get roleVet;

  /// No description provided for @roleClinicAdmin.
  ///
  /// In en, this message translates to:
  /// **'Clinic admin'**
  String get roleClinicAdmin;

  /// No description provided for @roleGroomer.
  ///
  /// In en, this message translates to:
  /// **'Groomer'**
  String get roleGroomer;

  /// No description provided for @roleTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainer'**
  String get roleTrainer;

  /// No description provided for @roleBoarder.
  ///
  /// In en, this message translates to:
  /// **'Boarding and sitting'**
  String get roleBoarder;

  /// No description provided for @roleWalker.
  ///
  /// In en, this message translates to:
  /// **'Dog walker'**
  String get roleWalker;

  /// No description provided for @roleSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get roleSeller;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin'**
  String get roleAdmin;

  /// No description provided for @welcome1Title.
  ///
  /// In en, this message translates to:
  /// **'Every care your pet needs, in one place'**
  String get welcome1Title;

  /// No description provided for @welcome1Body.
  ///
  /// In en, this message translates to:
  /// **'Track walks, meals and moods for every pet in your home.'**
  String get welcome1Body;

  /// No description provided for @welcome2Title.
  ///
  /// In en, this message translates to:
  /// **'Never miss a vaccine or medicine'**
  String get welcome2Title;

  /// No description provided for @welcome2Body.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminders, health records and a report you can share with your vet.'**
  String get welcome2Body;

  /// No description provided for @welcome3Title.
  ///
  /// In en, this message translates to:
  /// **'Vets, groomers and shops, all connected'**
  String get welcome3Title;

  /// No description provided for @welcome3Body.
  ///
  /// In en, this message translates to:
  /// **'Book in a few taps, chat with a vet, and get help fast in an emergency.'**
  String get welcome3Body;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PawSetu'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to look after your pets'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordHelper;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of PawSetu?'**
  String get signOutConfirm;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone number'**
  String get continueWithPhone;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New to PawSetu?'**
  String get newHere;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @exploreDemo.
  ///
  /// In en, this message translates to:
  /// **'Explore as demo user'**
  String get exploreDemo;

  /// No description provided for @exploreDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Try every role with one tap. No sign-up needed.'**
  String get exploreDemoHint;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'It takes less than a minute'**
  String get signUpSubtitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @termsNote.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you agree to the terms and privacy policy.'**
  String get termsNote;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll email you a link to choose a new one.'**
  String get resetSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @resetSent.
  ///
  /// In en, this message translates to:
  /// **'If {email} has an account, a reset link is on its way.'**
  String resetSent(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a 6-digit code by SMS.'**
  String get phoneSubtitle;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number'**
  String get phoneInvalid;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @enterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get enterCodeTitle;

  /// No description provided for @enterCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}'**
  String enterCodeSubtitle(String phone);

  /// No description provided for @sixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get sixDigitCode;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get verifyAndContinue;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get changeNumber;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verifyTitle;

  /// No description provided for @verifySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a link to {email}. Tap it to confirm it\'s you.'**
  String verifySubtitle(String email);

  /// No description provided for @verifyDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: the email went to the Demo Outbox. Tap below to open it.'**
  String get verifyDemoNote;

  /// No description provided for @openDemoEmail.
  ///
  /// In en, this message translates to:
  /// **'Open demo email and verify'**
  String get openDemoEmail;

  /// No description provided for @iveVerified.
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified my email'**
  String get iveVerified;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send the email again'**
  String get resendEmail;

  /// No description provided for @emailResent.
  ///
  /// In en, this message translates to:
  /// **'Sent again. Check your inbox and spam folder.'**
  String get emailResent;

  /// No description provided for @authErrNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account with that email. Check the spelling or create an account.'**
  String get authErrNoAccount;

  /// No description provided for @authErrWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'That email and password don\'t match. Try again or reset your password.'**
  String get authErrWrongPassword;

  /// No description provided for @authErrEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account. Sign in instead.'**
  String get authErrEmailInUse;

  /// No description provided for @authErrWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get authErrWeakPassword;

  /// No description provided for @authErrInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like an email address'**
  String get authErrInvalidEmail;

  /// No description provided for @authErrInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Check the SMS and try again.'**
  String get authErrInvalidCode;

  /// No description provided for @authErrNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check it and try again.'**
  String get authErrNetwork;

  /// No description provided for @authErrCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get authErrCancelled;

  /// No description provided for @demoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demoTitle;

  /// No description provided for @demoBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demoBadge;

  /// No description provided for @demoSocialBody.
  ///
  /// In en, this message translates to:
  /// **'Demo: in the live app this opens {provider} sign-in. Here you\'ll continue as a demo account.'**
  String demoSocialBody(String provider);

  /// No description provided for @demoOtpBody.
  ///
  /// In en, this message translates to:
  /// **'Demo: no SMS is sent. Use the code {code}.'**
  String demoOtpBody(String code);

  /// No description provided for @demoOutboxNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: nothing was really sent. The message is in the Demo Outbox in the admin panel.'**
  String get demoOutboxNote;

  /// No description provided for @demoLoginNote.
  ///
  /// In en, this message translates to:
  /// **'These are demo accounts with made-up people, clinics and data. Nothing here is real, no money is charged and no messages are sent.'**
  String get demoLoginNote;

  /// No description provided for @demoGroupOwners.
  ///
  /// In en, this message translates to:
  /// **'Pet parents'**
  String get demoGroupOwners;

  /// No description provided for @demoGroupFamily.
  ///
  /// In en, this message translates to:
  /// **'Family and pet sitter'**
  String get demoGroupFamily;

  /// No description provided for @demoGroupPartners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get demoGroupPartners;

  /// No description provided for @demoGroupPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get demoGroupPlatform;

  /// No description provided for @demoPriya.
  ///
  /// In en, this message translates to:
  /// **'Bengaluru · Plus · Bruno the Labrador and Misty the Persian cat'**
  String get demoPriya;

  /// No description provided for @demoRavi.
  ///
  /// In en, this message translates to:
  /// **'Hyderabad · Free · Telugu · Simba the Indie puppy and Kiwi the cockatiel'**
  String get demoRavi;

  /// No description provided for @demoAnjali.
  ///
  /// In en, this message translates to:
  /// **'Delhi NCR · Free · Hindi · Easy mode · Coco the rabbit and Tiger the senior cat'**
  String get demoAnjali;

  /// No description provided for @demoArjun.
  ///
  /// In en, this message translates to:
  /// **'Mumbai · Plus · Max the German Shepherd and Luna the Beagle puppy'**
  String get demoArjun;

  /// No description provided for @demoRohan.
  ///
  /// In en, this message translates to:
  /// **'Priya\'s husband · Carer for Bruno and Misty'**
  String get demoRohan;

  /// No description provided for @demoMeera.
  ///
  /// In en, this message translates to:
  /// **'Pet sitter for Arjun · access ends in 3 days'**
  String get demoMeera;

  /// No description provided for @demoClinicAdmin.
  ///
  /// In en, this message translates to:
  /// **'Clinic admin · Golconda Gate Pet Clinic, Hyderabad'**
  String get demoClinicAdmin;

  /// No description provided for @demoVet.
  ///
  /// In en, this message translates to:
  /// **'Vet · bookings, tele-vet queue and prescriptions'**
  String get demoVet;

  /// No description provided for @demoGroomer.
  ///
  /// In en, this message translates to:
  /// **'Groomer · accepts booking requests'**
  String get demoGroomer;

  /// No description provided for @demoTrainer.
  ///
  /// In en, this message translates to:
  /// **'Dog trainer'**
  String get demoTrainer;

  /// No description provided for @demoBoarder.
  ///
  /// In en, this message translates to:
  /// **'Home boarding and pet sitting'**
  String get demoBoarder;

  /// No description provided for @demoWalker.
  ///
  /// In en, this message translates to:
  /// **'Dog walker · live walk route'**
  String get demoWalker;

  /// No description provided for @demoSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller · products, orders and payouts'**
  String get demoSeller;

  /// No description provided for @demoAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin · approvals, complaints, Demo Outbox'**
  String get demoAdmin;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Signing in by hand? Every demo account uses the password {password}. Demo phone code: {otp}.'**
  String demoCredentials(String password, String otp);

  /// No description provided for @setupHello.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, let\'s set things up'**
  String setupHello(String name);

  /// No description provided for @setupHelloNoName.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set things up'**
  String get setupHelloNoName;

  /// No description provided for @setupPrefsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how PawSetu looks and reads. You can change this any time in Settings.'**
  String get setupPrefsSubtitle;

  /// No description provided for @setupPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Who are we caring for?'**
  String get setupPetTitle;

  /// No description provided for @setupPetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a name and species for now.'**
  String get setupPetSubtitle;

  /// No description provided for @setupNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders keep your pet healthy'**
  String get setupNotifTitle;

  /// No description provided for @setupNotifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications so we can remind you about:'**
  String get setupNotifSubtitle;

  /// No description provided for @notifReasonVaccines.
  ///
  /// In en, this message translates to:
  /// **'Vaccines and deworming that are due'**
  String get notifReasonVaccines;

  /// No description provided for @notifReasonMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicine times, with one-tap Given'**
  String get notifReasonMedicines;

  /// No description provided for @notifReasonBookings.
  ///
  /// In en, this message translates to:
  /// **'Vet and grooming appointments'**
  String get notifReasonBookings;

  /// No description provided for @notifReasonMessages.
  ///
  /// In en, this message translates to:
  /// **'Replies from vets and providers'**
  String get notifReasonMessages;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allowNotifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @easyMode.
  ///
  /// In en, this message translates to:
  /// **'Easy mode'**
  String get easyMode;

  /// No description provided for @easyModeHint.
  ///
  /// In en, this message translates to:
  /// **'Bigger text and buttons, a simpler Home and plain words.'**
  String get easyModeHint;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @highContrastHint.
  ///
  /// In en, this message translates to:
  /// **'Darker text and stronger outlines.'**
  String get highContrastHint;

  /// No description provided for @notificationChannels.
  ///
  /// In en, this message translates to:
  /// **'Reminders and channels'**
  String get notificationChannels;

  /// No description provided for @notificationChannelsHint.
  ///
  /// In en, this message translates to:
  /// **'Push, email, SMS or WhatsApp, and quiet hours'**
  String get notificationChannelsHint;

  /// No description provided for @demoData.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoData;

  /// No description provided for @demoModeOn.
  ///
  /// In en, this message translates to:
  /// **'Demo mode is on'**
  String get demoModeOn;

  /// No description provided for @demoStandaloneHint.
  ///
  /// In en, this message translates to:
  /// **'Everything runs on this device. No real money, messages or calls.'**
  String get demoStandaloneHint;

  /// No description provided for @demoEmulatorHint.
  ///
  /// In en, this message translates to:
  /// **'Connected to the Firebase emulators on your computer.'**
  String get demoEmulatorHint;

  /// No description provided for @resetDemoData.
  ///
  /// In en, this message translates to:
  /// **'Reset demo data'**
  String get resetDemoData;

  /// No description provided for @resetDemoDataHint.
  ///
  /// In en, this message translates to:
  /// **'Undo your changes and start fresh'**
  String get resetDemoDataHint;

  /// No description provided for @resetDemoDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This removes everything you added in the demo and signs you out.'**
  String get resetDemoDataConfirm;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @mapCredit.
  ///
  /// In en, this message translates to:
  /// **'Maps © OpenStreetMap contributors'**
  String get mapCredit;

  /// No description provided for @designGallery.
  ///
  /// In en, this message translates to:
  /// **'Design gallery'**
  String get designGallery;

  /// No description provided for @myPets.
  ///
  /// In en, this message translates to:
  /// **'My pets'**
  String get myPets;

  /// No description provided for @familySharing.
  ///
  /// In en, this message translates to:
  /// **'Family and sharing'**
  String get familySharing;

  /// No description provided for @documentVault.
  ///
  /// In en, this message translates to:
  /// **'Document vault'**
  String get documentVault;

  /// No description provided for @memoryAlbum.
  ///
  /// In en, this message translates to:
  /// **'Memory album'**
  String get memoryAlbum;

  /// No description provided for @connectedDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected devices'**
  String get connectedDevices;

  /// No description provided for @lostPetMode.
  ///
  /// In en, this message translates to:
  /// **'Lost pet mode and QR tag'**
  String get lostPetMode;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @pawsetuPlus.
  ///
  /// In en, this message translates to:
  /// **'PawSetu Plus'**
  String get pawsetuPlus;

  /// No description provided for @helpAndComplaints.
  ///
  /// In en, this message translates to:
  /// **'Help and complaints'**
  String get helpAndComplaints;

  /// No description provided for @privacyCentre.
  ///
  /// In en, this message translates to:
  /// **'Privacy centre'**
  String get privacyCentre;

  /// No description provided for @planFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFree;

  /// No description provided for @planPlus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get planPlus;

  /// No description provided for @partnerPortalFor.
  ///
  /// In en, this message translates to:
  /// **'Partner portal · {role}'**
  String partnerPortalFor(String role);

  /// No description provided for @pDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get pDashboard;

  /// No description provided for @pCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar and slots'**
  String get pCalendar;

  /// No description provided for @pRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking requests'**
  String get pRequests;

  /// No description provided for @pTeleVetQueue.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet queue'**
  String get pTeleVetQueue;

  /// No description provided for @pServices.
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get pServices;

  /// No description provided for @pStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff and vets'**
  String get pStaff;

  /// No description provided for @pChat.
  ///
  /// In en, this message translates to:
  /// **'Chat inbox'**
  String get pChat;

  /// No description provided for @pReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get pReviews;

  /// No description provided for @pPayouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get pPayouts;

  /// No description provided for @pProfileKyc.
  ///
  /// In en, this message translates to:
  /// **'Profile and KYC'**
  String get pProfileKyc;

  /// No description provided for @pEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency settings'**
  String get pEmergency;

  /// No description provided for @pProducts.
  ///
  /// In en, this message translates to:
  /// **'Products and stock'**
  String get pProducts;

  /// No description provided for @pOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get pOrders;

  /// No description provided for @pReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns'**
  String get pReturns;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin panel'**
  String get adminPanel;

  /// No description provided for @aDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get aDashboard;

  /// No description provided for @aApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get aApprovals;

  /// No description provided for @aUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get aUsers;

  /// No description provided for @aCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get aCatalogue;

  /// No description provided for @aComplaints.
  ///
  /// In en, this message translates to:
  /// **'Complaints and tickets'**
  String get aComplaints;

  /// No description provided for @aModeration.
  ///
  /// In en, this message translates to:
  /// **'Moderation'**
  String get aModeration;

  /// No description provided for @aSettings.
  ///
  /// In en, this message translates to:
  /// **'Plans and settings'**
  String get aSettings;

  /// No description provided for @aOutbox.
  ///
  /// In en, this message translates to:
  /// **'Demo Outbox'**
  String get aOutbox;

  /// No description provided for @aAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get aAudit;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get you;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @notAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added yet'**
  String get notAdded;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @addPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhotoTitle;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @cropPhoto.
  ///
  /// In en, this message translates to:
  /// **'Move and zoom'**
  String get cropPhoto;

  /// No description provided for @cropHint.
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom, drag to move'**
  String get cropHint;

  /// No description provided for @editPet.
  ///
  /// In en, this message translates to:
  /// **'Edit pet'**
  String get editPet;

  /// No description provided for @petBasicsTitle.
  ///
  /// In en, this message translates to:
  /// **'The basics'**
  String get petBasicsTitle;

  /// No description provided for @petAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About {name}'**
  String petAboutTitle(String name);

  /// No description provided for @petAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All optional. Add what you know now.'**
  String get petAboutSubtitle;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @chooseBreed.
  ///
  /// In en, this message translates to:
  /// **'Choose breed'**
  String get chooseBreed;

  /// No description provided for @searchBreeds.
  ///
  /// In en, this message translates to:
  /// **'Search breeds'**
  String get searchBreeds;

  /// No description provided for @breedMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed / Indie'**
  String get breedMixed;

  /// No description provided for @breedOther.
  ///
  /// In en, this message translates to:
  /// **'Other (type it)'**
  String get breedOther;

  /// No description provided for @typeBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed name'**
  String get typeBreed;

  /// No description provided for @noBreedMatch.
  ///
  /// In en, this message translates to:
  /// **'No match. Try \'Other (type it)\'.'**
  String get noBreedMatch;

  /// No description provided for @colourTag.
  ///
  /// In en, this message translates to:
  /// **'Colour tag'**
  String get colourTag;

  /// No description provided for @colourTagHint.
  ///
  /// In en, this message translates to:
  /// **'Helps you tell pets apart at a glance'**
  String get colourTagHint;

  /// No description provided for @colourAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get colourAmber;

  /// No description provided for @colourLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get colourLavender;

  /// No description provided for @colourSky.
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get colourSky;

  /// No description provided for @colourRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get colourRose;

  /// No description provided for @colourMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get colourMint;

  /// No description provided for @colourSand.
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get colourSand;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @exactDate.
  ///
  /// In en, this message translates to:
  /// **'Exact date'**
  String get exactDate;

  /// No description provided for @approxAge.
  ///
  /// In en, this message translates to:
  /// **'Approximate age'**
  String get approxAge;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @weightGrams.
  ///
  /// In en, this message translates to:
  /// **'Weight (grams)'**
  String get weightGrams;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @moreDetails.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get moreDetails;

  /// No description provided for @moreDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Markings, microchip, allergies, diet, clinic'**
  String get moreDetailsHint;

  /// No description provided for @markings.
  ///
  /// In en, this message translates to:
  /// **'Colour and markings'**
  String get markings;

  /// No description provided for @microchip.
  ///
  /// In en, this message translates to:
  /// **'Microchip ID'**
  String get microchip;

  /// No description provided for @neutered.
  ///
  /// In en, this message translates to:
  /// **'Neutered / spayed'**
  String get neutered;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @allergiesHint.
  ///
  /// In en, this message translates to:
  /// **'Separate with commas, e.g. Chicken, Wheat'**
  String get allergiesHint;

  /// No description provided for @dietType.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get dietType;

  /// No description provided for @regularClinic.
  ///
  /// In en, this message translates to:
  /// **'Regular clinic'**
  String get regularClinic;

  /// No description provided for @temperament.
  ///
  /// In en, this message translates to:
  /// **'Temperament notes'**
  String get temperament;

  /// No description provided for @insuranceInVault.
  ///
  /// In en, this message translates to:
  /// **'Insurance policies are kept in the Document vault.'**
  String get insuranceInVault;

  /// No description provided for @petAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String petAdded(String name);

  /// No description provided for @petLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'The free plan has room for {limit} pets'**
  String petLimitTitle(int limit);

  /// No description provided for @petLimitBody.
  ///
  /// In en, this message translates to:
  /// **'PawSetu Plus gives you unlimited pets, plus video vet calls and more.'**
  String get petLimitBody;

  /// No description provided for @petsUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} pets on the free plan'**
  String petsUsed(int used, int limit);

  /// No description provided for @petNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this pet'**
  String get petNotFound;

  /// No description provided for @petCare.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get petCare;

  /// No description provided for @routine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get routine;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @petSectionHealth.
  ///
  /// In en, this message translates to:
  /// **'Vaccines, medicines, vet visits'**
  String get petSectionHealth;

  /// No description provided for @petSectionRoutine.
  ///
  /// In en, this message translates to:
  /// **'Walks, meals, play, mood'**
  String get petSectionRoutine;

  /// No description provided for @petSectionDocs.
  ///
  /// In en, this message translates to:
  /// **'Certificates, insurance, reports'**
  String get petSectionDocs;

  /// No description provided for @petSectionMemories.
  ///
  /// In en, this message translates to:
  /// **'Photos, videos, milestones'**
  String get petSectionMemories;

  /// No description provided for @flatFacedChip.
  ///
  /// In en, this message translates to:
  /// **'Feels the heat'**
  String get flatFacedChip;

  /// No description provided for @qrTag.
  ///
  /// In en, this message translates to:
  /// **'QR tag'**
  String get qrTag;

  /// No description provided for @archivePet.
  ///
  /// In en, this message translates to:
  /// **'Archive pet'**
  String get archivePet;

  /// No description provided for @restorePet.
  ///
  /// In en, this message translates to:
  /// **'Bring back to active pets'**
  String get restorePet;

  /// No description provided for @archiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive {name}'**
  String archiveTitle(String name);

  /// No description provided for @archiveBody.
  ///
  /// In en, this message translates to:
  /// **'Their records and memories stay safe. Reminders stop.'**
  String get archiveBody;

  /// No description provided for @passedAway.
  ///
  /// In en, this message translates to:
  /// **'Passed away'**
  String get passedAway;

  /// No description provided for @passedAwayHint.
  ///
  /// In en, this message translates to:
  /// **'Kept under \"In loving memory\"'**
  String get passedAwayHint;

  /// No description provided for @rehomed.
  ///
  /// In en, this message translates to:
  /// **'Rehomed'**
  String get rehomed;

  /// No description provided for @rehomedHint.
  ///
  /// In en, this message translates to:
  /// **'Found a new family'**
  String get rehomedHint;

  /// No description provided for @memorialNote.
  ///
  /// In en, this message translates to:
  /// **'A few words (optional)'**
  String get memorialNote;

  /// No description provided for @memorialNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Forever in our hearts'**
  String get memorialNoteHint;

  /// No description provided for @inLovingMemory.
  ///
  /// In en, this message translates to:
  /// **'In loving memory'**
  String get inLovingMemory;

  /// No description provided for @archivedMemorial.
  ///
  /// In en, this message translates to:
  /// **'{name} is in loving memory. Their memories are kept safe.'**
  String archivedMemorial(String name);

  /// No description provided for @archivedRehomed.
  ///
  /// In en, this message translates to:
  /// **'{name} has been archived'**
  String archivedRehomed(String name);

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @invitesForYou.
  ///
  /// In en, this message translates to:
  /// **'Invites for you'**
  String get invitesForYou;

  /// No description provided for @familyRolesHelp.
  ///
  /// In en, this message translates to:
  /// **'Viewer: sees everything and can log routine. Carer: also gives medicines and books services. Co-owner: everything except deleting the pet.'**
  String get familyRolesHelp;

  /// No description provided for @roleViewerHint.
  ///
  /// In en, this message translates to:
  /// **'Sees everything, can log walks and meals'**
  String get roleViewerHint;

  /// No description provided for @roleCarerHint.
  ///
  /// In en, this message translates to:
  /// **'Also gives medicines and books services'**
  String get roleCarerHint;

  /// No description provided for @roleCoownerHint.
  ///
  /// In en, this message translates to:
  /// **'Everything except deleting the pet or removing you'**
  String get roleCoownerHint;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite someone to care for {pet}'**
  String inviteTitle(String pet);

  /// No description provided for @temporaryAccess.
  ///
  /// In en, this message translates to:
  /// **'Pet sitter (access ends on a date)'**
  String get temporaryAccess;

  /// No description provided for @temporaryAccessHint.
  ///
  /// In en, this message translates to:
  /// **'Access stops automatically'**
  String get temporaryAccessHint;

  /// No description provided for @accessUntil.
  ///
  /// In en, this message translates to:
  /// **'Access until {date}'**
  String accessUntil(String date);

  /// No description provided for @accessEnded.
  ///
  /// In en, this message translates to:
  /// **'Access has ended'**
  String get accessEnded;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get sendInvite;

  /// No description provided for @createLink.
  ///
  /// In en, this message translates to:
  /// **'Create invite link'**
  String get createLink;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent to {contact}'**
  String inviteSent(String contact);

  /// No description provided for @inviteLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Your invite link is ready'**
  String get inviteLinkReady;

  /// No description provided for @inviteShareText.
  ///
  /// In en, this message translates to:
  /// **'Help me look after {pet} on PawSetu: {link}'**
  String inviteShareText(String pet, String link);

  /// No description provided for @inviteLink.
  ///
  /// In en, this message translates to:
  /// **'Invite link'**
  String get inviteLink;

  /// No description provided for @invitePending.
  ///
  /// In en, this message translates to:
  /// **'Waiting to accept · {role}'**
  String invitePending(String role);

  /// No description provided for @cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'Cancel invite'**
  String get cancelInvite;

  /// No description provided for @inviteReceived.
  ///
  /// In en, this message translates to:
  /// **'{from} invited you to care for {pet} as {role}'**
  String inviteReceived(String from, String pet, String role);

  /// No description provided for @inviteAccepted.
  ///
  /// In en, this message translates to:
  /// **'You can now help care for {pet}'**
  String inviteAccepted(String pet);

  /// No description provided for @inviteInvalid.
  ///
  /// In en, this message translates to:
  /// **'This invite has expired or was already used'**
  String get inviteInvalid;

  /// No description provided for @signInToAccept.
  ///
  /// In en, this message translates to:
  /// **'Sign in to accept'**
  String get signInToAccept;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get changeRole;

  /// No description provided for @removeAccess.
  ///
  /// In en, this message translates to:
  /// **'Remove access'**
  String get removeAccess;

  /// No description provided for @removeAccessConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}\'s access to {pet}?'**
  String removeAccessConfirm(String name, String pet);

  /// No description provided for @familyLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'The free plan shares with up to {limit} people'**
  String familyLimitTitle(int limit);

  /// No description provided for @familyLimitBody.
  ///
  /// In en, this message translates to:
  /// **'PawSetu Plus lets up to 8 family members help.'**
  String get familyLimitBody;

  /// No description provided for @sharedWithYou.
  ///
  /// In en, this message translates to:
  /// **'Shared with you · {role}'**
  String sharedWithYou(String role);

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityTitle;

  /// No description provided for @noActivityBody.
  ///
  /// In en, this message translates to:
  /// **'When family members log walks or give medicines, it shows here.'**
  String get noActivityBody;

  /// No description provided for @actMedicineGiven.
  ///
  /// In en, this message translates to:
  /// **'{who} gave {pet} {detail}'**
  String actMedicineGiven(String who, String pet, String detail);

  /// No description provided for @actWalk.
  ///
  /// In en, this message translates to:
  /// **'{who} walked {pet} ({detail})'**
  String actWalk(String who, String pet, String detail);

  /// No description provided for @actMeal.
  ///
  /// In en, this message translates to:
  /// **'{who} fed {pet}'**
  String actMeal(String who, String pet);

  /// No description provided for @actMemberJoined.
  ///
  /// In en, this message translates to:
  /// **'{who} joined {pet}\'s family'**
  String actMemberJoined(String who, String pet);

  /// No description provided for @actMemberRemoved.
  ///
  /// In en, this message translates to:
  /// **'{who} removed {name} from {pet}\'s family'**
  String actMemberRemoved(String who, String name, String pet);

  /// No description provided for @actRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'{who} changed a role for {pet}'**
  String actRoleChanged(String who, String pet);

  /// No description provided for @actGeneric.
  ///
  /// In en, this message translates to:
  /// **'{who} updated {pet}'**
  String actGeneric(String who, String pet);

  /// No description provided for @plusPerkPets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited pets and up to 8 family members'**
  String get plusPerkPets;

  /// No description provided for @plusPerkVideo.
  ///
  /// In en, this message translates to:
  /// **'Video vet calls, longer chats, 10% off video fees'**
  String get plusPerkVideo;

  /// No description provided for @plusPerkAi.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Ask PawSetu questions'**
  String get plusPerkAi;

  /// No description provided for @plusPerkStorage.
  ///
  /// In en, this message translates to:
  /// **'25 GB for photos and documents'**
  String get plusPerkStorage;

  /// No description provided for @seePlus.
  ///
  /// In en, this message translates to:
  /// **'See PawSetu Plus'**
  String get seePlus;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @increase.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrease;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @logWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get logWalk;

  /// No description provided for @logPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get logPlay;

  /// No description provided for @logMeal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get logMeal;

  /// No description provided for @logWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get logWater;

  /// No description provided for @logPotty.
  ///
  /// In en, this message translates to:
  /// **'Potty'**
  String get logPotty;

  /// No description provided for @logSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep / nap'**
  String get logSleep;

  /// No description provided for @logGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get logGrooming;

  /// No description provided for @logTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get logTraining;

  /// No description provided for @logMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get logMood;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get logWeight;

  /// No description provided for @logBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Behaviour'**
  String get logBehaviour;

  /// No description provided for @logFor.
  ///
  /// In en, this message translates to:
  /// **'Log for {name}'**
  String logFor(String name);

  /// No description provided for @logSomething.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logSomething;

  /// No description provided for @logNow.
  ///
  /// In en, this message translates to:
  /// **'Log {type} now'**
  String logNow(String type);

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'{type} logged for {name}'**
  String logged(String type, String name);

  /// No description provided for @addDetails.
  ///
  /// In en, this message translates to:
  /// **'Add details'**
  String get addDetails;

  /// No description provided for @amountGrams.
  ///
  /// In en, this message translates to:
  /// **'Amount (grams)'**
  String get amountGrams;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get distanceKm;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter the weight'**
  String get enterWeight;

  /// No description provided for @chooseOneTag.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one behaviour'**
  String get chooseOneTag;

  /// No description provided for @howIsPet.
  ///
  /// In en, this message translates to:
  /// **'How is {name} today?'**
  String howIsPet(String name);

  /// No description provided for @behaviourPrompt.
  ///
  /// In en, this message translates to:
  /// **'What did you notice?'**
  String get behaviourPrompt;

  /// No description provided for @behaviourHint.
  ///
  /// In en, this message translates to:
  /// **'Tap again to change: mild, moderate, strong'**
  String get behaviourHint;

  /// No description provided for @intensityMild.
  ///
  /// In en, this message translates to:
  /// **'mild'**
  String get intensityMild;

  /// No description provided for @intensityModerate.
  ///
  /// In en, this message translates to:
  /// **'moderate'**
  String get intensityModerate;

  /// No description provided for @intensityStrong.
  ///
  /// In en, this message translates to:
  /// **'strong'**
  String get intensityStrong;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodPlayful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get moodPlayful;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @moodAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get moodAnxious;

  /// No description provided for @moodUnwell.
  ///
  /// In en, this message translates to:
  /// **'Unwell'**
  String get moodUnwell;

  /// No description provided for @tagPlayful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get tagPlayful;

  /// No description provided for @tagCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get tagCalm;

  /// No description provided for @tagAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get tagAnxious;

  /// No description provided for @tagLeashPulling.
  ///
  /// In en, this message translates to:
  /// **'Leash pulling'**
  String get tagLeashPulling;

  /// No description provided for @tagBarking.
  ///
  /// In en, this message translates to:
  /// **'Barking'**
  String get tagBarking;

  /// No description provided for @tagAggressionDogs.
  ///
  /// In en, this message translates to:
  /// **'Aggression with dogs'**
  String get tagAggressionDogs;

  /// No description provided for @tagSeparationAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Separation anxiety'**
  String get tagSeparationAnxiety;

  /// No description provided for @tagScratching.
  ///
  /// In en, this message translates to:
  /// **'Scratching furniture'**
  String get tagScratching;

  /// No description provided for @tagChewing.
  ///
  /// In en, this message translates to:
  /// **'Chewing things'**
  String get tagChewing;

  /// No description provided for @tagJumping.
  ///
  /// In en, this message translates to:
  /// **'Jumping on people'**
  String get tagJumping;

  /// No description provided for @tagHiding.
  ///
  /// In en, this message translates to:
  /// **'Hiding'**
  String get tagHiding;

  /// No description provided for @tagNotEating.
  ///
  /// In en, this message translates to:
  /// **'Not eating well'**
  String get tagNotEating;

  /// No description provided for @todayFor.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s day'**
  String todayFor(String name);

  /// No description provided for @todayAllPets.
  ///
  /// In en, this message translates to:
  /// **'Today for all pets'**
  String get todayAllPets;

  /// No description provided for @allDoneToday.
  ///
  /// In en, this message translates to:
  /// **'All done for today. Good job with {name}!'**
  String allDoneToday(String name);

  /// No description provided for @tasksLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing left today} other{{count} things left today}}'**
  String tasksLeft(int count);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String streakDays(int count);

  /// No description provided for @playProgress.
  ///
  /// In en, this message translates to:
  /// **'Play · {done} / {goal} min'**
  String playProgress(int done, int goal);

  /// No description provided for @routineOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s routine'**
  String routineOf(String name);

  /// No description provided for @tabLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get tabLog;

  /// No description provided for @tabCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get tabCharts;

  /// No description provided for @tabBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Behaviour'**
  String get tabBehaviour;

  /// No description provided for @tabPlan.
  ///
  /// In en, this message translates to:
  /// **'Daily plan'**
  String get tabPlan;

  /// No description provided for @noLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged for {name} yet'**
  String noLogsTitle(String name);

  /// No description provided for @noLogsBody.
  ///
  /// In en, this message translates to:
  /// **'Tap Log to add a meal, walk or play time.'**
  String get noLogsBody;

  /// No description provided for @deleteLogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get deleteLogConfirm;

  /// No description provided for @totalWalked.
  ///
  /// In en, this message translates to:
  /// **'Walked'**
  String get totalWalked;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @mealsLogged.
  ///
  /// In en, this message translates to:
  /// **'Meals logged'**
  String get mealsLogged;

  /// No description provided for @chartWalkKm.
  ///
  /// In en, this message translates to:
  /// **'Walking (km per day)'**
  String get chartWalkKm;

  /// No description provided for @chartPlayMinutes.
  ///
  /// In en, this message translates to:
  /// **'Play (minutes per day)'**
  String get chartPlayMinutes;

  /// No description provided for @chartMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals per day'**
  String get chartMeals;

  /// No description provided for @chartMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get chartMood;

  /// No description provided for @noMoodLogs.
  ///
  /// In en, this message translates to:
  /// **'No mood logged in this period.'**
  String get noMoodLogs;

  /// No description provided for @noBehaviourTitle.
  ///
  /// In en, this message translates to:
  /// **'No behaviour notes yet'**
  String get noBehaviourTitle;

  /// No description provided for @noBehaviourBody.
  ///
  /// In en, this message translates to:
  /// **'Note things like leash pulling or barking to see how {name} changes over time.'**
  String noBehaviourBody(String name);

  /// No description provided for @trendUp.
  ///
  /// In en, this message translates to:
  /// **'increasing'**
  String get trendUp;

  /// No description provided for @trendDown.
  ///
  /// In en, this message translates to:
  /// **'improving'**
  String get trendDown;

  /// No description provided for @trendSteady.
  ///
  /// In en, this message translates to:
  /// **'steady'**
  String get trendSteady;

  /// No description provided for @trendNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get trendNew;

  /// No description provided for @shareWithTrainerVet.
  ///
  /// In en, this message translates to:
  /// **'Share with trainer or vet'**
  String get shareWithTrainerVet;

  /// No description provided for @behaviourSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s behaviour (PawSetu)'**
  String behaviourSummaryTitle(String name);

  /// No description provided for @dailyPlanFor.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s daily plan'**
  String dailyPlanFor(String name);

  /// No description provided for @dailyPlanHint.
  ///
  /// In en, this message translates to:
  /// **'This drives the Today checklist on Home.'**
  String get dailyPlanHint;

  /// No description provided for @walksPerDay.
  ///
  /// In en, this message translates to:
  /// **'Walks per day'**
  String get walksPerDay;

  /// No description provided for @mealsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Meals per day'**
  String get mealsPerDay;

  /// No description provided for @playMinutesPerDay.
  ///
  /// In en, this message translates to:
  /// **'Play minutes per day'**
  String get playMinutesPerDay;

  /// No description provided for @suggestedGoalsText.
  ///
  /// In en, this message translates to:
  /// **'Suggested for this pet: {walks}{meals} meals and {play} minutes of play a day. Indicative, always confirm with your vet.'**
  String suggestedGoalsText(String walks, int meals, int play);

  /// No description provided for @suggestedWalks.
  ///
  /// In en, this message translates to:
  /// **'{count} walks ({minutes} min in all), '**
  String suggestedWalks(int count, int minutes);

  /// No description provided for @useSuggested.
  ///
  /// In en, this message translates to:
  /// **'Use suggested goals'**
  String get useSuggested;

  /// No description provided for @savePlan.
  ///
  /// In en, this message translates to:
  /// **'Save plan'**
  String get savePlan;

  /// No description provided for @planSaved.
  ///
  /// In en, this message translates to:
  /// **'Daily plan saved'**
  String get planSaved;

  /// No description provided for @planReminderNote.
  ///
  /// In en, this message translates to:
  /// **'Reminders for the plan are set in Settings → Reminders and channels.'**
  String get planReminderNote;

  /// No description provided for @walkWith.
  ///
  /// In en, this message translates to:
  /// **'Walk with {name}'**
  String walkWith(String name);

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get duration;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @paceValue.
  ///
  /// In en, this message translates to:
  /// **'{value} min/km'**
  String paceValue(String value);

  /// No description provided for @startWalk.
  ///
  /// In en, this message translates to:
  /// **'Start walk'**
  String get startWalk;

  /// No description provided for @startDemoWalk.
  ///
  /// In en, this message translates to:
  /// **'Try a demo walk'**
  String get startDemoWalk;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @saveWalk.
  ///
  /// In en, this message translates to:
  /// **'Save walk'**
  String get saveWalk;

  /// No description provided for @discardWalk.
  ///
  /// In en, this message translates to:
  /// **'Discard walk'**
  String get discardWalk;

  /// No description provided for @walkSaved.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s walk saved: {distance}'**
  String walkSaved(String name, String distance);

  /// No description provided for @walkLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop this walk?'**
  String get walkLeaveTitle;

  /// No description provided for @walkLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'The route so far will not be saved.'**
  String get walkLeaveBody;

  /// No description provided for @walkNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'PawSetu is tracking your walk'**
  String get walkNotificationTitle;

  /// No description provided for @walkNotificationText.
  ///
  /// In en, this message translates to:
  /// **'Tap to open. Stop the walk in the app when you\'re home.'**
  String get walkNotificationText;

  /// No description provided for @walkWebNote.
  ///
  /// In en, this message translates to:
  /// **'Live GPS walks work in the Android and iPhone apps. On the website you can add a walk by hand.'**
  String get walkWebNote;

  /// No description provided for @enterWalkManually.
  ///
  /// In en, this message translates to:
  /// **'Add a walk by hand'**
  String get enterWalkManually;

  /// No description provided for @demoWalkBanner.
  ///
  /// In en, this message translates to:
  /// **'Demo walk: the route is simulated near your home area.'**
  String get demoWalkBanner;

  /// No description provided for @locationWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Use your location?'**
  String get locationWhyTitle;

  /// No description provided for @locationWhyWalk.
  ///
  /// In en, this message translates to:
  /// **'We use it only while you walk, to draw the route and measure the distance.'**
  String get locationWhyWalk;

  /// No description provided for @locationOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Location is off'**
  String get locationOffTitle;

  /// No description provided for @locationOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to track a real walk, or try a demo walk now.'**
  String get locationOffBody;

  /// No description provided for @useDemoWalk.
  ///
  /// In en, this message translates to:
  /// **'Use demo walk'**
  String get useDemoWalk;

  /// No description provided for @walkWeather.
  ///
  /// In en, this message translates to:
  /// **'Walk weather'**
  String get walkWeather;

  /// No description provided for @heatOk.
  ///
  /// In en, this message translates to:
  /// **'Good weather for {name}\'s walk'**
  String heatOk(String name);

  /// No description provided for @heatWarm.
  ///
  /// In en, this message translates to:
  /// **'It\'s warm. Keep walks short and shaded.'**
  String get heatWarm;

  /// No description provided for @heatHot.
  ///
  /// In en, this message translates to:
  /// **'Too hot for a long walk with {name}'**
  String heatHot(String name);

  /// No description provided for @heatDanger.
  ///
  /// In en, this message translates to:
  /// **'Dangerous heat. Skip the walk for {name} now'**
  String heatDanger(String name);

  /// No description provided for @heatTipTime.
  ///
  /// In en, this message translates to:
  /// **'Walk early morning (before 8 am) or after sunset.'**
  String get heatTipTime;

  /// No description provided for @heatTipWater.
  ///
  /// In en, this message translates to:
  /// **'Carry water and avoid hot roads; they burn paws.'**
  String get heatTipWater;

  /// No description provided for @heatTipFlatFaced.
  ///
  /// In en, this message translates to:
  /// **'{name} has a short nose and overheats faster than most pets.'**
  String heatTipFlatFaced(String name);

  /// No description provided for @demoTemperature.
  ///
  /// In en, this message translates to:
  /// **'Demo temperature'**
  String get demoTemperature;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// No description provided for @indicativeNote.
  ///
  /// In en, this message translates to:
  /// **'Indicative, always confirm with your vet.'**
  String get indicativeNote;

  /// No description provided for @healthOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s health'**
  String healthOf(String name);

  /// No description provided for @choosePetForHealth.
  ///
  /// In en, this message translates to:
  /// **'Choose a pet'**
  String get choosePetForHealth;

  /// No description provided for @itemsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} need attention'**
  String itemsNeedAttention(int count);

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextUp;

  /// No description provided for @nothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due for {name} right now.'**
  String nothingDue(String name);

  /// No description provided for @nothingDueAll.
  ///
  /// In en, this message translates to:
  /// **'All caught up. Nothing due this week.'**
  String get nothingDueAll;

  /// No description provided for @healthReport.
  ///
  /// In en, this message translates to:
  /// **'Health report'**
  String get healthReport;

  /// No description provided for @healthReportOf.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s health report'**
  String healthReportOf(String name);

  /// No description provided for @medicalCard.
  ///
  /// In en, this message translates to:
  /// **'Medical card'**
  String get medicalCard;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get statusDueSoon;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusAskVet.
  ///
  /// In en, this message translates to:
  /// **'Ask your vet'**
  String get statusAskVet;

  /// No description provided for @askYourVet.
  ///
  /// In en, this message translates to:
  /// **'Ask your vet'**
  String get askYourVet;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @doseN.
  ///
  /// In en, this message translates to:
  /// **'Dose {n}'**
  String doseN(int n);

  /// No description provided for @booster.
  ///
  /// In en, this message translates to:
  /// **'Booster'**
  String get booster;

  /// No description provided for @optionalVaccine.
  ///
  /// In en, this message translates to:
  /// **'Optional (vet advises)'**
  String get optionalVaccine;

  /// No description provided for @vaccinations.
  ///
  /// In en, this message translates to:
  /// **'Vaccinations'**
  String get vaccinations;

  /// No description provided for @vaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get vaccine;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine name'**
  String get vaccineName;

  /// No description provided for @otherVaccine.
  ///
  /// In en, this message translates to:
  /// **'Other vaccine'**
  String get otherVaccine;

  /// No description provided for @recordVaccineFor.
  ///
  /// In en, this message translates to:
  /// **'Record a vaccine for {name}'**
  String recordVaccineFor(String name);

  /// No description provided for @dateGiven.
  ///
  /// In en, this message translates to:
  /// **'Date given'**
  String get dateGiven;

  /// No description provided for @vaccineBrand.
  ///
  /// In en, this message translates to:
  /// **'Vaccine brand'**
  String get vaccineBrand;

  /// No description provided for @batchNumber.
  ///
  /// In en, this message translates to:
  /// **'Batch number'**
  String get batchNumber;

  /// No description provided for @vetName.
  ///
  /// In en, this message translates to:
  /// **'Vet\'s name'**
  String get vetName;

  /// No description provided for @clinicName.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinicName;

  /// No description provided for @attachCertificate.
  ///
  /// In en, this message translates to:
  /// **'Attach certificate photo'**
  String get attachCertificate;

  /// No description provided for @certificateAttached.
  ///
  /// In en, this message translates to:
  /// **'Certificate attached (saved to the vault)'**
  String get certificateAttached;

  /// No description provided for @vaccineRecorded.
  ///
  /// In en, this message translates to:
  /// **'{vaccine} recorded for {name}'**
  String vaccineRecorded(String vaccine, String name);

  /// No description provided for @givenOn.
  ///
  /// In en, this message translates to:
  /// **'Given {date}'**
  String givenOn(String date);

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOn(String date);

  /// No description provided for @nextDueShort.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get nextDueShort;

  /// No description provided for @catchUpNote.
  ///
  /// In en, this message translates to:
  /// **'No vaccine history yet. Ask your vet for a catch-up plan, and add past vaccines with Record.'**
  String get catchUpNote;

  /// No description provided for @rabbitVaccineNote.
  ///
  /// In en, this message translates to:
  /// **'There is no standard routine vaccine schedule for rabbits in India. Check with an exotic-animal vet; a health check every 6–12 months is a good idea.'**
  String get rabbitVaccineNote;

  /// No description provided for @birdVaccineNote.
  ///
  /// In en, this message translates to:
  /// **'Common pet birds don\'t need routine vaccines. Plan a yearly avian vet check, and keep an eye on nails and beak.'**
  String get birdVaccineNote;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicineName;

  /// No description provided for @addMedicineFor.
  ///
  /// In en, this message translates to:
  /// **'Add a medicine for {name}'**
  String addMedicineFor(String name);

  /// No description provided for @editMedicine.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get editMedicine;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @unitTablet.
  ///
  /// In en, this message translates to:
  /// **'tablet'**
  String get unitTablet;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitDrops.
  ///
  /// In en, this message translates to:
  /// **'drops'**
  String get unitDrops;

  /// No description provided for @unitMg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get unitMg;

  /// No description provided for @unitCapsule.
  ///
  /// In en, this message translates to:
  /// **'capsule'**
  String get unitCapsule;

  /// No description provided for @unitSachet.
  ///
  /// In en, this message translates to:
  /// **'sachet'**
  String get unitSachet;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'How often'**
  String get frequency;

  /// No description provided for @freqOnce.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get freqOnce;

  /// No description provided for @freqTwice.
  ///
  /// In en, this message translates to:
  /// **'Twice a day'**
  String get freqTwice;

  /// No description provided for @freqEveryHours.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} hours'**
  String freqEveryHours(int hours);

  /// No description provided for @freqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Once a week'**
  String get freqWeekly;

  /// No description provided for @freqCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom times'**
  String get freqCustom;

  /// No description provided for @doseTimes.
  ///
  /// In en, this message translates to:
  /// **'Dose times'**
  String get doseTimes;

  /// No description provided for @firstDoseAt.
  ///
  /// In en, this message translates to:
  /// **'First dose at'**
  String get firstDoseAt;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @withFood.
  ///
  /// In en, this message translates to:
  /// **'With food'**
  String get withFood;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// No description provided for @endsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String endsOn(String date);

  /// No description provided for @setEndDate.
  ///
  /// In en, this message translates to:
  /// **'Set end date'**
  String get setEndDate;

  /// No description provided for @stockCount.
  ///
  /// In en, this message translates to:
  /// **'Doses in stock (optional)'**
  String get stockCount;

  /// No description provided for @stockHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you to refill when 5 are left'**
  String get stockHint;

  /// No description provided for @medicineSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} saved'**
  String medicineSaved(String name);

  /// No description provided for @noMedicines.
  ///
  /// In en, this message translates to:
  /// **'{name} isn\'t on any medicine.'**
  String noMedicines(String name);

  /// No description provided for @nextDoseAt.
  ///
  /// In en, this message translates to:
  /// **'Next: {time}'**
  String nextDoseAt(String time);

  /// No description provided for @stockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String stockLeft(int count);

  /// No description provided for @refill.
  ///
  /// In en, this message translates to:
  /// **'Refill'**
  String get refill;

  /// No description provided for @refillNeeded.
  ///
  /// In en, this message translates to:
  /// **'Refill {name}'**
  String refillNeeded(String name);

  /// No description provided for @given.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get given;

  /// No description provided for @snooze15.
  ///
  /// In en, this message translates to:
  /// **'Snooze 15 min'**
  String get snooze15;

  /// No description provided for @doseGiven.
  ///
  /// In en, this message translates to:
  /// **'{name} marked as given'**
  String doseGiven(String name);

  /// No description provided for @doseSkipped.
  ///
  /// In en, this message translates to:
  /// **'Dose skipped'**
  String get doseSkipped;

  /// No description provided for @doseSnoozed.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you in 15 minutes'**
  String get doseSnoozed;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String todayAt(String time);

  /// No description provided for @overdueBy.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day overdue} other{{days} days overdue}}'**
  String overdueBy(int days);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Due tomorrow} other{Due in {days} days}}'**
  String dueInDays(int days);

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Deworming and flea/tick'**
  String get prevention;

  /// No description provided for @deworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get deworming;

  /// No description provided for @fleaTick.
  ///
  /// In en, this message translates to:
  /// **'Flea and tick prevention'**
  String get fleaTick;

  /// No description provided for @lastDone.
  ///
  /// In en, this message translates to:
  /// **'Last {date}'**
  String lastDone(String date);

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next {date}'**
  String nextDue(String date);

  /// No description provided for @tickFeverNote.
  ///
  /// In en, this message translates to:
  /// **'Tick fever is common in India. Keep flea and tick prevention up to date.'**
  String get tickFeverNote;

  /// No description provided for @productUsed.
  ///
  /// In en, this message translates to:
  /// **'Product used'**
  String get productUsed;

  /// No description provided for @weightNeedsTwo.
  ///
  /// In en, this message translates to:
  /// **'Add two or more weights to see the chart.'**
  String get weightNeedsTwo;

  /// No description provided for @weightRangeNote.
  ///
  /// In en, this message translates to:
  /// **'Green band: indicative healthy range {range}. Always confirm with your vet.'**
  String weightRangeNote(String range);

  /// No description provided for @weightGrowingNote.
  ///
  /// In en, this message translates to:
  /// **'Still growing. Your vet will tell you the right weight.'**
  String get weightGrowingNote;

  /// No description provided for @vetVisit.
  ///
  /// In en, this message translates to:
  /// **'Vet visit'**
  String get vetVisit;

  /// No description provided for @vetVisits.
  ///
  /// In en, this message translates to:
  /// **'Vet visits'**
  String get vetVisits;

  /// No description provided for @reasonForVisit.
  ///
  /// In en, this message translates to:
  /// **'Reason for visit'**
  String get reasonForVisit;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis or advice'**
  String get diagnosis;

  /// No description provided for @noVisits.
  ///
  /// In en, this message translates to:
  /// **'No vet visits recorded yet.'**
  String get noVisits;

  /// No description provided for @symptom.
  ///
  /// In en, this message translates to:
  /// **'Symptom'**
  String get symptom;

  /// No description provided for @symptomDiary.
  ///
  /// In en, this message translates to:
  /// **'Symptom diary'**
  String get symptomDiary;

  /// No description provided for @noSymptoms.
  ///
  /// In en, this message translates to:
  /// **'No symptoms noted. That\'s good news.'**
  String get noSymptoms;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'How bad is it?'**
  String get severity;

  /// No description provided for @severeSymptomNote.
  ///
  /// In en, this message translates to:
  /// **'If your pet has trouble breathing, collapses, has a seizure or may have eaten poison, use SOS now.'**
  String get severeSymptomNote;

  /// No description provided for @shareWithVet.
  ///
  /// In en, this message translates to:
  /// **'Share with vet'**
  String get shareWithVet;

  /// No description provided for @symptomShareTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s symptom diary (PawSetu)'**
  String symptomShareTitle(String name);

  /// No description provided for @symVomiting.
  ///
  /// In en, this message translates to:
  /// **'Vomiting'**
  String get symVomiting;

  /// No description provided for @symDiarrhoea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhoea'**
  String get symDiarrhoea;

  /// No description provided for @symNotEating.
  ///
  /// In en, this message translates to:
  /// **'Not eating'**
  String get symNotEating;

  /// No description provided for @symLimping.
  ///
  /// In en, this message translates to:
  /// **'Limping'**
  String get symLimping;

  /// No description provided for @symItching.
  ///
  /// In en, this message translates to:
  /// **'Itching'**
  String get symItching;

  /// No description provided for @symCoughing.
  ///
  /// In en, this message translates to:
  /// **'Coughing'**
  String get symCoughing;

  /// No description provided for @symLethargy.
  ///
  /// In en, this message translates to:
  /// **'Very tired'**
  String get symLethargy;

  /// No description provided for @symSneezing.
  ///
  /// In en, this message translates to:
  /// **'Sneezing'**
  String get symSneezing;

  /// No description provided for @symOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get symOther;

  /// No description provided for @savedFor.
  ///
  /// In en, this message translates to:
  /// **'{what} saved for {name}'**
  String savedFor(String what, String name);

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @noReminders.
  ///
  /// In en, this message translates to:
  /// **'No custom reminders.'**
  String get noReminders;

  /// No description provided for @newReminderFor.
  ///
  /// In en, this message translates to:
  /// **'New reminder for {name}'**
  String newReminderFor(String name);

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we remind you about?'**
  String get reminderTitle;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'Don\'t repeat'**
  String get repeatNone;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get repeatYearly;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Reminder set'**
  String get reminderSet;

  /// No description provided for @remTypeLicence.
  ///
  /// In en, this message translates to:
  /// **'Licence renewal'**
  String get remTypeLicence;

  /// No description provided for @remTypeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance renewal'**
  String get remTypeInsurance;

  /// No description provided for @remTypeGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming due'**
  String get remTypeGrooming;

  /// No description provided for @remTypeNailTrim.
  ///
  /// In en, this message translates to:
  /// **'Nail trim'**
  String get remTypeNailTrim;

  /// No description provided for @remTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get remTypeBirthday;

  /// No description provided for @remTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get remTypeCustom;

  /// No description provided for @remVaccineDue.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s {vaccine} is due soon'**
  String remVaccineDue(String name, String vaccine);

  /// No description provided for @remVaccineOverdue.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s {vaccine} is overdue'**
  String remVaccineOverdue(String name, String vaccine);

  /// No description provided for @remMedicine.
  ///
  /// In en, this message translates to:
  /// **'Time for {name}\'s {medicine}'**
  String remMedicine(String name, String medicine);

  /// No description provided for @remRefill.
  ///
  /// In en, this message translates to:
  /// **'{medicine} for {name} is running low'**
  String remRefill(String medicine, String name);

  /// No description provided for @remDeworming.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s deworming is due'**
  String remDeworming(String name);

  /// No description provided for @remFleaTick.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s flea and tick prevention is due'**
  String remFleaTick(String name);

  /// No description provided for @remTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open PawSetu'**
  String get remTapToOpen;

  /// No description provided for @remSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed for 15 minutes'**
  String get remSnoozed;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get filterUnread;

  /// No description provided for @filterBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get filterBookings;

  /// No description provided for @filterOrdersMessages.
  ///
  /// In en, this message translates to:
  /// **'Orders and messages'**
  String get filterOrdersMessages;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders and updates will appear here.'**
  String get noNotificationsBody;

  /// No description provided for @ntVaccines.
  ///
  /// In en, this message translates to:
  /// **'Vaccines'**
  String get ntVaccines;

  /// No description provided for @ntMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get ntMedicines;

  /// No description provided for @ntDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming and flea/tick'**
  String get ntDeworming;

  /// No description provided for @ntBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get ntBookings;

  /// No description provided for @ntRoutine.
  ///
  /// In en, this message translates to:
  /// **'Daily routine'**
  String get ntRoutine;

  /// No description provided for @ntCustom.
  ///
  /// In en, this message translates to:
  /// **'My reminders'**
  String get ntCustom;

  /// No description provided for @chPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get chPush;

  /// No description provided for @chEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get chEmail;

  /// No description provided for @chSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get chSms;

  /// No description provided for @chWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get chWhatsApp;

  /// No description provided for @channelsDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: push reminders are real on your phone. Email, SMS and WhatsApp go to the Demo Outbox instead of being sent.'**
  String get channelsDemoNote;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get quietHours;

  /// No description provided for @quietHoursOn.
  ///
  /// In en, this message translates to:
  /// **'Don\'t disturb at night'**
  String get quietHoursOn;

  /// No description provided for @quietHoursHint.
  ///
  /// In en, this message translates to:
  /// **'Reminders wait until morning. Medicine reminders always ring on time.'**
  String get quietHoursHint;

  /// No description provided for @notificationsOn.
  ///
  /// In en, this message translates to:
  /// **'Notifications are on'**
  String get notificationsOn;

  /// No description provided for @notificationsOffHint.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. You can turn them on in your phone\'s settings.'**
  String get notificationsOffHint;

  /// No description provided for @preparingDocument.
  ///
  /// In en, this message translates to:
  /// **'Preparing your document…'**
  String get preparingDocument;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share or save PDF'**
  String get sharePdf;

  /// No description provided for @generatedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated {date}'**
  String generatedOn(String date);

  /// No description provided for @reportFooter.
  ///
  /// In en, this message translates to:
  /// **'Made with PawSetu · Demo data · Indicative, always confirm with your vet'**
  String get reportFooter;

  /// No description provided for @ownerAndClinic.
  ///
  /// In en, this message translates to:
  /// **'Owner and clinic'**
  String get ownerAndClinic;

  /// No description provided for @noKnownAllergies.
  ///
  /// In en, this message translates to:
  /// **'No known allergies'**
  String get noKnownAllergies;

  /// No description provided for @currentMedicines.
  ///
  /// In en, this message translates to:
  /// **'Current medicines'**
  String get currentMedicines;

  /// No description provided for @rabiesVaccine.
  ///
  /// In en, this message translates to:
  /// **'Rabies vaccine'**
  String get rabiesVaccine;

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get notRecorded;

  /// No description provided for @medicalCardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String medicalCardUpdated(String date);

  /// No description provided for @medicalCardOffline.
  ///
  /// In en, this message translates to:
  /// **'This card works without internet. Show it to a vet, a boarding centre or at the airport.'**
  String get medicalCardOffline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
