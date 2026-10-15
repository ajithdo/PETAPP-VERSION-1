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

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book care'**
  String get bookTitle;

  /// No description provided for @findAVet.
  ///
  /// In en, this message translates to:
  /// **'Find a vet near you'**
  String get findAVet;

  /// No description provided for @kindVet.
  ///
  /// In en, this message translates to:
  /// **'Vet clinic'**
  String get kindVet;

  /// No description provided for @kindGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get kindGrooming;

  /// No description provided for @kindTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get kindTraining;

  /// No description provided for @kindBoarding.
  ///
  /// In en, this message translates to:
  /// **'Boarding'**
  String get kindBoarding;

  /// No description provided for @kindWalking.
  ///
  /// In en, this message translates to:
  /// **'Dog walking'**
  String get kindWalking;

  /// No description provided for @teleVet.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet'**
  String get teleVet;

  /// No description provided for @clinicFinderMap.
  ///
  /// In en, this message translates to:
  /// **'Clinics on the map'**
  String get clinicFinderMap;

  /// No description provided for @clinicFinderHint.
  ///
  /// In en, this message translates to:
  /// **'See open clinics and 24x7 emergency care around you.'**
  String get clinicFinderHint;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get myBookings;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings.'**
  String get noUpcomingBookings;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests waiting.'**
  String get noRequests;

  /// No description provided for @noPastBookings.
  ///
  /// In en, this message translates to:
  /// **'No past bookings yet.'**
  String get noPastBookings;

  /// No description provided for @bookSomething.
  ///
  /// In en, this message translates to:
  /// **'Book something'**
  String get bookSomething;

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// No description provided for @backToBook.
  ///
  /// In en, this message translates to:
  /// **'Back to Book'**
  String get backToBook;

  /// No description provided for @searchByNameOrArea.
  ///
  /// In en, this message translates to:
  /// **'Search by name or area'**
  String get searchByNameOrArea;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @nearYou.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get nearYou;

  /// No description provided for @chooseArea.
  ///
  /// In en, this message translates to:
  /// **'Choose your area'**
  String get chooseArea;

  /// No description provided for @locationWhyClinics.
  ///
  /// In en, this message translates to:
  /// **'PawSetu uses your location only to sort clinics and services by distance. It is not saved.'**
  String get locationWhyClinics;

  /// No description provided for @locationFallback.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Showing your chosen area instead.'**
  String get locationFallback;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get showResults;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get sortNearest;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortRating;

  /// No description provided for @sortSlot.
  ///
  /// In en, this message translates to:
  /// **'Earliest slot'**
  String get sortSlot;

  /// No description provided for @sortFee.
  ///
  /// In en, this message translates to:
  /// **'Lowest fee'**
  String get sortFee;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNow;

  /// No description provided for @openNowChip.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNowChip;

  /// No description provided for @closedChip.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closedChip;

  /// No description provided for @open24x7.
  ///
  /// In en, this message translates to:
  /// **'24x7'**
  String get open24x7;

  /// No description provided for @open24x7Long.
  ///
  /// In en, this message translates to:
  /// **'Open 24 hours, all 7 days'**
  String get open24x7Long;

  /// No description provided for @teleVetAvailable.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet available'**
  String get teleVetAvailable;

  /// No description provided for @homeVisit.
  ///
  /// In en, this message translates to:
  /// **'Home visit'**
  String get homeVisit;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @rating4plus.
  ///
  /// In en, this message translates to:
  /// **'4★ and above'**
  String get rating4plus;

  /// No description provided for @speciesTreated.
  ///
  /// In en, this message translates to:
  /// **'Animals treated'**
  String get speciesTreated;

  /// No description provided for @languagesSpoken.
  ///
  /// In en, this message translates to:
  /// **'Languages spoken'**
  String get languagesSpoken;

  /// No description provided for @consultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation fee'**
  String get consultationFee;

  /// No description provided for @upTo.
  ///
  /// In en, this message translates to:
  /// **'Up to {amount}'**
  String upTo(String amount);

  /// No description provided for @feeFrom.
  ///
  /// In en, this message translates to:
  /// **'From {amount}'**
  String feeFrom(String amount);

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String resultsCount(int count);

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapView;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another area or clear some filters.'**
  String get noResultsBody;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String reviewsCount(int count);

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get bookNow;

  /// No description provided for @demoCallBody.
  ///
  /// In en, this message translates to:
  /// **'Demo mode doesn\'t place real calls. In the live app this would call {phone}.'**
  String demoCallBody(String phone);

  /// No description provided for @hoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hoursTitle;

  /// No description provided for @closedToday.
  ///
  /// In en, this message translates to:
  /// **'Closed today'**
  String get closedToday;

  /// No description provided for @todayHours.
  ///
  /// In en, this message translates to:
  /// **'Today {open} – {close}'**
  String todayHours(String open, String close);

  /// No description provided for @emergencyLine.
  ///
  /// In en, this message translates to:
  /// **'Emergency line: {phone}'**
  String emergencyLine(String phone);

  /// No description provided for @servicesAndPrices.
  ///
  /// In en, this message translates to:
  /// **'Services and prices'**
  String get servicesAndPrices;

  /// No description provided for @instantBooking.
  ///
  /// In en, this message translates to:
  /// **'Instant booking'**
  String get instantBooking;

  /// No description provided for @requestBooking.
  ///
  /// In en, this message translates to:
  /// **'Request to book'**
  String get requestBooking;

  /// No description provided for @payOnline.
  ///
  /// In en, this message translates to:
  /// **'Pay online'**
  String get payOnline;

  /// No description provided for @payAtCentre.
  ///
  /// In en, this message translates to:
  /// **'Pay at the centre'**
  String get payAtCentre;

  /// No description provided for @payAtClinic.
  ///
  /// In en, this message translates to:
  /// **'Pay at the clinic'**
  String get payAtClinic;

  /// No description provided for @homeVisitAvailable.
  ///
  /// In en, this message translates to:
  /// **'Home visits within {km} km'**
  String homeVisitAvailable(int km);

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @vetsHere.
  ///
  /// In en, this message translates to:
  /// **'Vets here'**
  String get vetsHere;

  /// No description provided for @yearsExperience.
  ///
  /// In en, this message translates to:
  /// **'{years, plural, =1{1 year experience} other{{years} years experience}}'**
  String yearsExperience(int years);

  /// No description provided for @regNo.
  ///
  /// In en, this message translates to:
  /// **'Reg. no. {no}'**
  String regNo(String no);

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @verifiedBooking.
  ///
  /// In en, this message translates to:
  /// **'Verified booking'**
  String get verifiedBooking;

  /// No description provided for @replyFrom.
  ///
  /// In en, this message translates to:
  /// **'Reply from {name}'**
  String replyFrom(String name);

  /// No description provided for @inClinic.
  ///
  /// In en, this message translates to:
  /// **'In clinic'**
  String get inClinic;

  /// No description provided for @svcConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get svcConsultation;

  /// No description provided for @svcVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get svcVaccination;

  /// No description provided for @svcSurgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery consult'**
  String get svcSurgery;

  /// No description provided for @svcDental.
  ///
  /// In en, this message translates to:
  /// **'Dental cleaning'**
  String get svcDental;

  /// No description provided for @svcLabTests.
  ///
  /// In en, this message translates to:
  /// **'Lab tests'**
  String get svcLabTests;

  /// No description provided for @svcXray.
  ///
  /// In en, this message translates to:
  /// **'X-ray'**
  String get svcXray;

  /// No description provided for @svcHomeVisit.
  ///
  /// In en, this message translates to:
  /// **'Home visit'**
  String get svcHomeVisit;

  /// No description provided for @svcGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get svcGrooming;

  /// No description provided for @svcBathBrush.
  ///
  /// In en, this message translates to:
  /// **'Bath and brush'**
  String get svcBathBrush;

  /// No description provided for @svcFullGroom.
  ///
  /// In en, this message translates to:
  /// **'Full groom'**
  String get svcFullGroom;

  /// No description provided for @svcNailTrim.
  ///
  /// In en, this message translates to:
  /// **'Nail trim'**
  String get svcNailTrim;

  /// No description provided for @svcTickTreatment.
  ///
  /// In en, this message translates to:
  /// **'Tick treatment'**
  String get svcTickTreatment;

  /// No description provided for @svcObedience.
  ///
  /// In en, this message translates to:
  /// **'Obedience training'**
  String get svcObedience;

  /// No description provided for @svcPuppyBasics.
  ///
  /// In en, this message translates to:
  /// **'Puppy basics'**
  String get svcPuppyBasics;

  /// No description provided for @svcBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Behaviour session'**
  String get svcBehaviour;

  /// No description provided for @svcBoarding.
  ///
  /// In en, this message translates to:
  /// **'Boarding'**
  String get svcBoarding;

  /// No description provided for @svcBoardingNight.
  ///
  /// In en, this message translates to:
  /// **'Boarding (per night)'**
  String get svcBoardingNight;

  /// No description provided for @svcDayCare.
  ///
  /// In en, this message translates to:
  /// **'Day care'**
  String get svcDayCare;

  /// No description provided for @svcHomeSitting.
  ///
  /// In en, this message translates to:
  /// **'Home sitting'**
  String get svcHomeSitting;

  /// No description provided for @svcWalk30.
  ///
  /// In en, this message translates to:
  /// **'30-minute walk'**
  String get svcWalk30;

  /// No description provided for @svcWalk60.
  ///
  /// In en, this message translates to:
  /// **'60-minute walk'**
  String get svcWalk60;

  /// No description provided for @stepWhoWhat.
  ///
  /// In en, this message translates to:
  /// **'Pet and service'**
  String get stepWhoWhat;

  /// No description provided for @stepWhen.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get stepWhen;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @stepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get stepConfirm;

  /// No description provided for @whichPet.
  ///
  /// In en, this message translates to:
  /// **'Which pet?'**
  String get whichPet;

  /// No description provided for @whichService.
  ///
  /// In en, this message translates to:
  /// **'Which service?'**
  String get whichService;

  /// No description provided for @chooseVet.
  ///
  /// In en, this message translates to:
  /// **'Choose a vet'**
  String get chooseVet;

  /// No description provided for @anyVet.
  ///
  /// In en, this message translates to:
  /// **'Any available vet'**
  String get anyVet;

  /// No description provided for @noPetForPlace.
  ///
  /// In en, this message translates to:
  /// **'None of your pets can be booked here. Add a pet first.'**
  String get noPetForPlace;

  /// No description provided for @homeVisitHint.
  ///
  /// In en, this message translates to:
  /// **'Within {km} km, travel fee {fee}'**
  String homeVisitHint(int km, String fee);

  /// No description provided for @openSlots.
  ///
  /// In en, this message translates to:
  /// **'Open slots'**
  String get openSlots;

  /// No description provided for @noSlotsThatDay.
  ///
  /// In en, this message translates to:
  /// **'No open slots that day. Try another day.'**
  String get noSlotsThatDay;

  /// No description provided for @requestExplainer.
  ///
  /// In en, this message translates to:
  /// **'Pick up to 3 times that suit you. The provider replies within {hours} hours.'**
  String requestExplainer(int hours);

  /// No description provided for @yourPreferredTimes.
  ///
  /// In en, this message translates to:
  /// **'Your preferred times'**
  String get yourPreferredTimes;

  /// No description provided for @preferredTimes.
  ///
  /// In en, this message translates to:
  /// **'Preferred times'**
  String get preferredTimes;

  /// No description provided for @symptomsNotes.
  ///
  /// In en, this message translates to:
  /// **'Symptoms or notes for the vet'**
  String get symptomsNotes;

  /// No description provided for @symptomsHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. not eating since yesterday, vomited twice'**
  String get symptomsHint;

  /// No description provided for @notesForProvider.
  ///
  /// In en, this message translates to:
  /// **'Notes for the provider'**
  String get notesForProvider;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @howToPay.
  ///
  /// In en, this message translates to:
  /// **'How would you like to pay?'**
  String get howToPay;

  /// No description provided for @payOnlineHint.
  ///
  /// In en, this message translates to:
  /// **'UPI or card now. Instant confirmation.'**
  String get payOnlineHint;

  /// No description provided for @payLaterHint.
  ///
  /// In en, this message translates to:
  /// **'Pay when you visit.'**
  String get payLaterHint;

  /// No description provided for @when.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get when;

  /// No description provided for @where.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get where;

  /// No description provided for @pet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get pet;

  /// No description provided for @vet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get vet;

  /// No description provided for @travelFee.
  ///
  /// In en, this message translates to:
  /// **'Travel fee'**
  String get travelFee;

  /// No description provided for @platformFee.
  ///
  /// In en, this message translates to:
  /// **'Platform fee'**
  String get platformFee;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @totalToPay.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalToPay;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation up to {hours} hours before. After that, 50% refund.'**
  String cancellationPolicy(int hours);

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get confirmBooking;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// No description provided for @demoBookingNote.
  ///
  /// In en, this message translates to:
  /// **'Demo booking. No real money is charged.'**
  String get demoBookingNote;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'{pet} is booked at {place} on {when}.'**
  String bookingConfirmedBody(String pet, String place, String when);

  /// No description provided for @requestSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSentTitle;

  /// No description provided for @requestSentBody.
  ///
  /// In en, this message translates to:
  /// **'{place} will reply soon. We\'ll notify you.'**
  String requestSentBody(String place);

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed. Nothing was charged. Try again.'**
  String get paymentFailed;

  /// No description provided for @paymentPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Payment pending. We\'ll confirm once it clears.'**
  String get paymentPendingNote;

  /// No description provided for @demoPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo payment'**
  String get demoPaymentTitle;

  /// No description provided for @demoPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'This is a demo. No money will move.'**
  String get demoPaymentNote;

  /// No description provided for @demoPaymentChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose what happens:'**
  String get demoPaymentChoose;

  /// No description provided for @payUpiDemo.
  ///
  /// In en, this message translates to:
  /// **'Pay with UPI (demo)'**
  String get payUpiDemo;

  /// No description provided for @simulateFailure.
  ///
  /// In en, this message translates to:
  /// **'Simulate a failure'**
  String get simulateFailure;

  /// No description provided for @simulatePending.
  ///
  /// In en, this message translates to:
  /// **'Simulate pending'**
  String get simulatePending;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingDetails;

  /// No description provided for @replyBy.
  ///
  /// In en, this message translates to:
  /// **'Reply by'**
  String get replyBy;

  /// No description provided for @replyBefore.
  ///
  /// In en, this message translates to:
  /// **'Reply before {time}'**
  String replyBefore(String time);

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paidOnline.
  ///
  /// In en, this message translates to:
  /// **'Paid online'**
  String get paidOnline;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get paymentPending;

  /// No description provided for @payAtVisit.
  ///
  /// In en, this message translates to:
  /// **'Pay at visit'**
  String get payAtVisit;

  /// No description provided for @platformCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform commission'**
  String get platformCommission;

  /// No description provided for @yourPayout.
  ///
  /// In en, this message translates to:
  /// **'Your payout'**
  String get yourPayout;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @refundDemo.
  ///
  /// In en, this message translates to:
  /// **'{amount} (demo, no real money)'**
  String refundDemo(String amount);

  /// No description provided for @providerSuggested.
  ///
  /// In en, this message translates to:
  /// **'{place} suggested a new time: {when}'**
  String providerSuggested(String place, String when);

  /// No description provided for @liveWalk.
  ///
  /// In en, this message translates to:
  /// **'Live walk'**
  String get liveWalk;

  /// No description provided for @liveWalkDemo.
  ///
  /// In en, this message translates to:
  /// **'Simulated live walk for the demo.'**
  String get liveWalkDemo;

  /// No description provided for @walkSoFar.
  ///
  /// In en, this message translates to:
  /// **'{km} so far'**
  String walkSoFar(String km);

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @dailyUpdates.
  ///
  /// In en, this message translates to:
  /// **'Daily updates'**
  String get dailyUpdates;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get addToCalendar;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @rescheduledTo.
  ///
  /// In en, this message translates to:
  /// **'Moved to {when}'**
  String rescheduledTo(String when);

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingQ.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelBookingQ;

  /// No description provided for @cancelRefundInfo.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get {amount} back (demo).'**
  String cancelRefundInfo(String amount);

  /// No description provided for @cancelledWithRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancelled. {amount} refunded (demo).'**
  String cancelledWithRefund(String amount);

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get writeReview;

  /// No description provided for @rateProvider.
  ///
  /// In en, this message translates to:
  /// **'How was {name}?'**
  String rateProvider(String name);

  /// No description provided for @starsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String starsLabel(int count);

  /// No description provided for @reviewText.
  ///
  /// In en, this message translates to:
  /// **'Tell other pet parents what went well'**
  String get reviewText;

  /// No description provided for @postReview.
  ///
  /// In en, this message translates to:
  /// **'Post review'**
  String get postReview;

  /// No description provided for @thanksForReview.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your review!'**
  String get thanksForReview;

  /// No description provided for @bsPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for reply'**
  String get bsPending;

  /// No description provided for @bsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bsConfirmed;

  /// No description provided for @bsSuggested.
  ///
  /// In en, this message translates to:
  /// **'New time suggested'**
  String get bsSuggested;

  /// No description provided for @bsInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get bsInProgress;

  /// No description provided for @bsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bsCompleted;

  /// No description provided for @bsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bsCancelled;

  /// No description provided for @bsDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get bsDeclined;

  /// No description provided for @bsExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get bsExpired;

  /// No description provided for @ntfNewBooking.
  ///
  /// In en, this message translates to:
  /// **'New booking: {pet} on {when}'**
  String ntfNewBooking(String pet, String when);

  /// No description provided for @ntfNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New booking request for {pet}'**
  String ntfNewRequest(String pet);

  /// No description provided for @ntfAccepted.
  ///
  /// In en, this message translates to:
  /// **'{place} confirmed your booking for {when}'**
  String ntfAccepted(String place, String when);

  /// No description provided for @ntfDeclined.
  ///
  /// In en, this message translates to:
  /// **'{place} couldn\'t take your request'**
  String ntfDeclined(String place);

  /// No description provided for @ntfSuggested.
  ///
  /// In en, this message translates to:
  /// **'{place} suggested {when} instead'**
  String ntfSuggested(String place, String when);

  /// No description provided for @ntfCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking for {pet} on {when} was cancelled'**
  String ntfCancelled(String pet, String when);

  /// No description provided for @ntfRescheduled.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s booking moved to {when}'**
  String ntfRescheduled(String pet, String when);

  /// No description provided for @ntfCompleted.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s visit at {place} is done. Rate your experience?'**
  String ntfCompleted(String pet, String place);

  /// No description provided for @ntfUpdate.
  ///
  /// In en, this message translates to:
  /// **'{place} sent an update about {pet}'**
  String ntfUpdate(String place, String pet);

  /// No description provided for @ntfExpired.
  ///
  /// In en, this message translates to:
  /// **'{place} didn\'t reply in time. Your request expired.'**
  String ntfExpired(String place);

  /// No description provided for @helloPartner.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloPartner(String name);

  /// No description provided for @noBusinessLinked.
  ///
  /// In en, this message translates to:
  /// **'No business is linked to this account yet.'**
  String get noBusinessLinked;

  /// No description provided for @waitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval. PawSetu checks new partners within 2 working days. You can set up your services meanwhile.'**
  String get waitingApproval;

  /// No description provided for @todaysBookings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s bookings'**
  String get todaysBookings;

  /// No description provided for @requestsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Requests waiting'**
  String get requestsWaiting;

  /// No description provided for @earningsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Earnings this month'**
  String get earningsThisMonth;

  /// No description provided for @completedBookings.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedBookings;

  /// No description provided for @noBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'No bookings today.'**
  String get noBookingsToday;

  /// No description provided for @bookingsOn.
  ///
  /// In en, this message translates to:
  /// **'Bookings on {date}'**
  String bookingsOn(String date);

  /// No description provided for @noBookingsThisDay.
  ///
  /// In en, this message translates to:
  /// **'No bookings this day.'**
  String get noBookingsThisDay;

  /// No description provided for @holidayNoBookings.
  ///
  /// In en, this message translates to:
  /// **'Marked as a holiday. No bookings.'**
  String get holidayNoBookings;

  /// No description provided for @markHoliday.
  ///
  /// In en, this message translates to:
  /// **'Mark holiday'**
  String get markHoliday;

  /// No description provided for @removeHoliday.
  ///
  /// In en, this message translates to:
  /// **'Remove holiday'**
  String get removeHoliday;

  /// No description provided for @blockTime.
  ///
  /// In en, this message translates to:
  /// **'Block time'**
  String get blockTime;

  /// No description provided for @timeBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked from {time}'**
  String timeBlocked(String time);

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHours;

  /// No description provided for @opens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get opens;

  /// No description provided for @closes.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get closes;

  /// No description provided for @hoursAppliesMonSat.
  ///
  /// In en, this message translates to:
  /// **'These hours apply Monday to Saturday. Sunday stays as it is.'**
  String get hoursAppliesMonSat;

  /// No description provided for @slotSettings.
  ///
  /// In en, this message translates to:
  /// **'{slot}-min slots · {buffer}-min buffer · {capacity} per slot'**
  String slotSettings(int slot, int buffer, int capacity);

  /// No description provided for @slotLength.
  ///
  /// In en, this message translates to:
  /// **'Slot length (minutes)'**
  String get slotLength;

  /// No description provided for @bufferTime.
  ///
  /// In en, this message translates to:
  /// **'Buffer between slots (minutes)'**
  String get bufferTime;

  /// No description provided for @capacityPerSlot.
  ///
  /// In en, this message translates to:
  /// **'Pets per slot'**
  String get capacityPerSlot;

  /// No description provided for @noRequestsPartner.
  ///
  /// In en, this message translates to:
  /// **'No booking requests right now.'**
  String get noRequestsPartner;

  /// No description provided for @waitingForOwner.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the owner'**
  String get waitingForOwner;

  /// No description provided for @chooseTimeToAccept.
  ///
  /// In en, this message translates to:
  /// **'Pick a time to accept'**
  String get chooseTimeToAccept;

  /// No description provided for @suggestTime.
  ///
  /// In en, this message translates to:
  /// **'Suggest another time'**
  String get suggestTime;

  /// No description provided for @suggestionSent.
  ///
  /// In en, this message translates to:
  /// **'New time sent to the owner'**
  String get suggestionSent;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Booking for {pet} confirmed'**
  String requestAccepted(String pet);

  /// No description provided for @declineRequestQ.
  ///
  /// In en, this message translates to:
  /// **'Decline the request for {pet}?'**
  String declineRequestQ(String pet);

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @servicesHelp.
  ///
  /// In en, this message translates to:
  /// **'Set your prices, duration and how owners can book. Changes show in the app right away.'**
  String get servicesHelp;

  /// No description provided for @priceRupees.
  ///
  /// In en, this message translates to:
  /// **'Price (₹)'**
  String get priceRupees;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @bookingMode.
  ///
  /// In en, this message translates to:
  /// **'Booking mode'**
  String get bookingMode;

  /// No description provided for @paymentOptions.
  ///
  /// In en, this message translates to:
  /// **'Payment options'**
  String get paymentOptions;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @addVet.
  ///
  /// In en, this message translates to:
  /// **'Add a vet'**
  String get addVet;

  /// No description provided for @vcRegNumber.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Council reg. number'**
  String get vcRegNumber;

  /// No description provided for @vcRegHelp.
  ///
  /// In en, this message translates to:
  /// **'PawSetu verifies this before the vet can take bookings.'**
  String get vcRegHelp;

  /// No description provided for @vetAddedPending.
  ///
  /// In en, this message translates to:
  /// **'Vet added. Waiting for verification.'**
  String get vetAddedPending;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @yourReply.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get yourReply;

  /// No description provided for @postReply.
  ///
  /// In en, this message translates to:
  /// **'Post reply'**
  String get postReply;

  /// No description provided for @totalPayouts.
  ///
  /// In en, this message translates to:
  /// **'Total payouts'**
  String get totalPayouts;

  /// No description provided for @payoutPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get payoutPending;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @payoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Payout history'**
  String get payoutHistory;

  /// No description provided for @noPayoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No payouts yet.'**
  String get noPayoutsYet;

  /// No description provided for @commissionLine.
  ///
  /// In en, this message translates to:
  /// **'Commission {amount}'**
  String commissionLine(String amount);

  /// No description provided for @demoPayoutsNote.
  ///
  /// In en, this message translates to:
  /// **'Demo payouts. No real money moves.'**
  String get demoPayoutsNote;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get statusPendingApproval;

  /// No description provided for @kycDocuments.
  ///
  /// In en, this message translates to:
  /// **'KYC documents'**
  String get kycDocuments;

  /// No description provided for @uploadKyc.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadKyc;

  /// No description provided for @kycUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded for review'**
  String get kycUploaded;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency phone'**
  String get emergencyPhone;

  /// No description provided for @emergencySettingsHelp.
  ///
  /// In en, this message translates to:
  /// **'24x7 clinics appear first in SOS. Keep your emergency number up to date.'**
  String get emergencySettingsHelp;

  /// No description provided for @allowEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Take emergency calls now'**
  String get allowEnquiries;

  /// No description provided for @allowEnquiriesHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off if you\'re full. Owners will see the next clinic.'**
  String get allowEnquiriesHint;

  /// No description provided for @startService.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startService;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get markCompleted;

  /// No description provided for @sendPhotoUpdate.
  ///
  /// In en, this message translates to:
  /// **'Send photo update'**
  String get sendPhotoUpdate;

  /// No description provided for @defaultUpdateText.
  ///
  /// In en, this message translates to:
  /// **'{pet} is doing great!'**
  String defaultUpdateText(String pet);

  /// No description provided for @updateSent.
  ///
  /// In en, this message translates to:
  /// **'Update sent to {name}'**
  String updateSent(String name);

  /// No description provided for @partnerCancelNote.
  ///
  /// In en, this message translates to:
  /// **'The owner gets a full refund and a notification.'**
  String get partnerCancelNote;

  /// No description provided for @messageOwner.
  ///
  /// In en, this message translates to:
  /// **'Message the owner'**
  String get messageOwner;

  /// No description provided for @partnerSignupLink.
  ///
  /// In en, this message translates to:
  /// **'Run a pet business? Join as a partner'**
  String get partnerSignupLink;

  /// No description provided for @partnerSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Join PawSetu as a partner'**
  String get partnerSignupTitle;

  /// No description provided for @partnerSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For clinics, groomers, trainers, boarding, walkers and pet shops. Free to join.'**
  String get partnerSignupSubtitle;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'What kind of business?'**
  String get businessType;

  /// No description provided for @kindSeller.
  ///
  /// In en, this message translates to:
  /// **'Pet shop'**
  String get kindSeller;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessName;

  /// No description provided for @areaCity.
  ///
  /// In en, this message translates to:
  /// **'Area and city'**
  String get areaCity;

  /// No description provided for @businessPhone.
  ///
  /// In en, this message translates to:
  /// **'Business phone'**
  String get businessPhone;

  /// No description provided for @businessAddress.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get businessAddress;

  /// No description provided for @kycHelp.
  ///
  /// In en, this message translates to:
  /// **'Add an ID proof and your business registration. PawSetu checks them before your listing goes live.'**
  String get kycHelp;

  /// No description provided for @useSampleDoc.
  ///
  /// In en, this message translates to:
  /// **'Use a sample document (demo)'**
  String get useSampleDoc;

  /// No description provided for @sampleIdProof.
  ///
  /// In en, this message translates to:
  /// **'ID proof (sample)'**
  String get sampleIdProof;

  /// No description provided for @kycNeeded.
  ///
  /// In en, this message translates to:
  /// **'Add at least one document.'**
  String get kycNeeded;

  /// No description provided for @yourAccount.
  ///
  /// In en, this message translates to:
  /// **'Your account'**
  String get yourAccount;

  /// No description provided for @submitApplication.
  ///
  /// In en, this message translates to:
  /// **'Submit application'**
  String get submitApplication;

  /// No description provided for @partnerApprovalNote.
  ///
  /// In en, this message translates to:
  /// **'After you submit, your listing waits for approval. You can set up services and prices meanwhile.'**
  String get partnerApprovalNote;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @aiTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask PawSetu'**
  String get aiTitle;

  /// No description provided for @aiIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to everyday pet questions'**
  String get aiIntroTitle;

  /// No description provided for @aiIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Ask about food, baths, vaccines, ticks and more. For anything serious, talk to a vet.'**
  String get aiIntroBody;

  /// No description provided for @aiHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question'**
  String get aiHint;

  /// No description provided for @aiAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get aiAsk;

  /// No description provided for @aiPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular questions'**
  String get aiPopular;

  /// No description provided for @aiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'General guidance only, not a diagnosis. Your vet knows your pet best.'**
  String get aiDisclaimer;

  /// No description provided for @aiNotDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Not a diagnosis. If your pet seems unwell, talk to a vet.'**
  String get aiNotDiagnosis;

  /// No description provided for @aiUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have an answer for that yet. Try one of the popular questions, or ask a vet in tele-vet.'**
  String get aiUnknown;

  /// No description provided for @aiTalkToVet.
  ///
  /// In en, this message translates to:
  /// **'Ask a vet'**
  String get aiTalkToVet;

  /// No description provided for @aiTalkToVetNow.
  ///
  /// In en, this message translates to:
  /// **'Talk to a vet now'**
  String get aiTalkToVetNow;

  /// No description provided for @aiUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited with Plus'**
  String get aiUnlimited;

  /// No description provided for @aiLeft.
  ///
  /// In en, this message translates to:
  /// **'{left} of {limit} questions left this month'**
  String aiLeft(int left, int limit);

  /// No description provided for @aiLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used your {limit} questions this month'**
  String aiLimitTitle(int limit);

  /// No description provided for @aiLimitBody.
  ///
  /// In en, this message translates to:
  /// **'More questions on {date}, or get unlimited questions with PawSetu Plus. Emergencies are always answered.'**
  String aiLimitBody(String date);

  /// No description provided for @aiRedFlagTitle.
  ///
  /// In en, this message translates to:
  /// **'This could be an emergency'**
  String get aiRedFlagTitle;

  /// No description provided for @aiRedFlagBody.
  ///
  /// In en, this message translates to:
  /// **'{sign} needs a vet right away. Use SOS to reach the nearest open clinic, or talk to a vet now.'**
  String aiRedFlagBody(String sign);

  /// No description provided for @aiRedFlagShort.
  ///
  /// In en, this message translates to:
  /// **'Possible emergency: {sign}'**
  String aiRedFlagShort(String sign);

  /// No description provided for @aiTileHint.
  ///
  /// In en, this message translates to:
  /// **'Everyday questions answered instantly. {left} left this month.'**
  String aiTileHint(int left);

  /// No description provided for @aiTileHintPlus.
  ///
  /// In en, this message translates to:
  /// **'Everyday questions answered instantly. Unlimited with Plus.'**
  String get aiTileHintPlus;

  /// No description provided for @rfBreathing.
  ///
  /// In en, this message translates to:
  /// **'Trouble breathing'**
  String get rfBreathing;

  /// No description provided for @rfCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse or fainting'**
  String get rfCollapse;

  /// No description provided for @rfSeizure.
  ///
  /// In en, this message translates to:
  /// **'A seizure (fits)'**
  String get rfSeizure;

  /// No description provided for @rfPoisoning.
  ///
  /// In en, this message translates to:
  /// **'Possible poisoning'**
  String get rfPoisoning;

  /// No description provided for @rfBleeding.
  ///
  /// In en, this message translates to:
  /// **'Heavy bleeding'**
  String get rfBleeding;

  /// No description provided for @rfBloat.
  ///
  /// In en, this message translates to:
  /// **'A swollen, hard belly'**
  String get rfBloat;

  /// No description provided for @rfHeatstroke.
  ///
  /// In en, this message translates to:
  /// **'Heatstroke'**
  String get rfHeatstroke;

  /// No description provided for @rfUrine.
  ///
  /// In en, this message translates to:
  /// **'Not passing urine'**
  String get rfUrine;

  /// No description provided for @rfInjury.
  ///
  /// In en, this message translates to:
  /// **'A serious injury'**
  String get rfInjury;

  /// No description provided for @aiQBath.
  ///
  /// In en, this message translates to:
  /// **'How often should I bathe my dog?'**
  String get aiQBath;

  /// No description provided for @aiQFeeding.
  ///
  /// In en, this message translates to:
  /// **'How much should I feed my pet?'**
  String get aiQFeeding;

  /// No description provided for @aiQToxicFood.
  ///
  /// In en, this message translates to:
  /// **'Which human foods are unsafe for pets?'**
  String get aiQToxicFood;

  /// No description provided for @aiQVaccines.
  ///
  /// In en, this message translates to:
  /// **'Which vaccines does my pet need?'**
  String get aiQVaccines;

  /// No description provided for @aiQDeworming.
  ///
  /// In en, this message translates to:
  /// **'How often should I deworm?'**
  String get aiQDeworming;

  /// No description provided for @aiQTicks.
  ///
  /// In en, this message translates to:
  /// **'How do I prevent ticks and fleas?'**
  String get aiQTicks;

  /// No description provided for @aiQHeat.
  ///
  /// In en, this message translates to:
  /// **'How do I keep my pet cool in summer?'**
  String get aiQHeat;

  /// No description provided for @aiQVomiting.
  ///
  /// In en, this message translates to:
  /// **'My pet vomited. What should I do?'**
  String get aiQVomiting;

  /// No description provided for @aiQDiarrhoea.
  ///
  /// In en, this message translates to:
  /// **'My pet has loose motions. What should I do?'**
  String get aiQDiarrhoea;

  /// No description provided for @aiQNotEating.
  ///
  /// In en, this message translates to:
  /// **'My pet is not eating. Should I worry?'**
  String get aiQNotEating;

  /// No description provided for @aiQItching.
  ///
  /// In en, this message translates to:
  /// **'Why does my dog keep scratching?'**
  String get aiQItching;

  /// No description provided for @aiQLimping.
  ///
  /// In en, this message translates to:
  /// **'My dog is limping. What should I do?'**
  String get aiQLimping;

  /// No description provided for @aiQLitter.
  ///
  /// In en, this message translates to:
  /// **'My cat isn\'t using the litter box. Why?'**
  String get aiQLitter;

  /// No description provided for @aiQChewing.
  ///
  /// In en, this message translates to:
  /// **'How do I stop my puppy chewing and biting?'**
  String get aiQChewing;

  /// No description provided for @aiQNails.
  ///
  /// In en, this message translates to:
  /// **'How do I trim my pet\'s nails?'**
  String get aiQNails;

  /// No description provided for @aiQTeeth.
  ///
  /// In en, this message translates to:
  /// **'How do I look after my pet\'s teeth?'**
  String get aiQTeeth;

  /// No description provided for @aiQBirdDiet.
  ///
  /// In en, this message translates to:
  /// **'What should I feed my bird?'**
  String get aiQBirdDiet;

  /// No description provided for @aiQRabbitDiet.
  ///
  /// In en, this message translates to:
  /// **'What should I feed my rabbit?'**
  String get aiQRabbitDiet;

  /// No description provided for @aiQWeight.
  ///
  /// In en, this message translates to:
  /// **'Is my pet overweight?'**
  String get aiQWeight;

  /// No description provided for @aiQAnxiety.
  ///
  /// In en, this message translates to:
  /// **'My pet is scared of crackers and thunder. How can I help?'**
  String get aiQAnxiety;

  /// No description provided for @aiABath.
  ///
  /// In en, this message translates to:
  /// **'Most dogs need a bath every 3 to 4 weeks; more often only if they get dirty or smelly. Use a dog shampoo (human shampoo can dry the skin), lukewarm water, and rinse well. Dry the ears and the coat fully, especially in the monsoon, to avoid fungal infections. Brushing a few times a week keeps the coat clean between baths. Cats rarely need baths.'**
  String get aiABath;

  /// No description provided for @aiAFeeding.
  ///
  /// In en, this message translates to:
  /// **'It depends on your pet\'s weight, age and activity. Start with the amount on the food pack for your pet\'s ideal weight, split into 2 meals for adult dogs and cats (3 to 4 for puppies and kittens). Check the waist and ribs every few weeks: you should feel the ribs easily. Treats should be under a tenth of daily food. Keep fresh water out all the time. Your vet can suggest an exact amount.'**
  String get aiAFeeding;

  /// No description provided for @aiAToxicFood.
  ///
  /// In en, this message translates to:
  /// **'Never give chocolate, grapes or raisins, onion, garlic, xylitol (in some sugar-free gum and sweets), alcohol, caffeine, cooked bones, or very salty and spicy food. Many festival sweets contain chocolate, raisins or xylitol, so keep them out of reach. Cats are also harmed by lilies. If your pet has eaten any of these, use SOS or call a vet now, even if they seem fine.'**
  String get aiAToxicFood;

  /// No description provided for @aiAVaccines.
  ///
  /// In en, this message translates to:
  /// **'Dogs need DHPPi with Leptospirosis (3 puppy doses from 6 to 8 weeks), anti-rabies at about 3 months, and yearly boosters. Cats need the tricat vaccine and anti-rabies, also with yearly boosters. Rabbits and birds usually don\'t need routine vaccines in India. Your pet\'s Health tab shows the full schedule, what\'s due and what\'s overdue. Your vet decides the final plan.'**
  String get aiAVaccines;

  /// No description provided for @aiADeworming.
  ///
  /// In en, this message translates to:
  /// **'Puppies and kittens: every 2 weeks until 3 months old, then monthly until 6 months. Adults: every 3 months. Weigh your pet before each dose, because the dose depends on weight. PawSetu reminds you when the next dose is due. Ask your vet which dewormer suits your pet.'**
  String get aiADeworming;

  /// No description provided for @aiATicks.
  ///
  /// In en, this message translates to:
  /// **'Use a vet-recommended tick and flea preventive all year: a spot-on, a chewable tablet or a collar. Ticks are common in India, especially in the monsoon. Check ears, between the toes and under the collar after walks. Keep bedding clean and dry. Never use dog products on cats. If your pet is weak, has pale gums or a fever after tick bites, see a vet quickly.'**
  String get aiATicks;

  /// No description provided for @aiAHeat.
  ///
  /// In en, this message translates to:
  /// **'Walk early in the morning or after sunset, and test the road with your hand: if it\'s too hot for 5 seconds, it\'s too hot for paws. Keep cool water and shade available all day. Never leave a pet in a parked car. Flat-faced breeds like pugs and Persian cats overheat fastest. Heavy panting, drooling, wobbling or bright red gums are signs of heatstroke: use SOS.'**
  String get aiAHeat;

  /// No description provided for @aiAVomiting.
  ///
  /// In en, this message translates to:
  /// **'One vomit with a normal, playful pet often settles: remove food for a few hours (not water), then give small, bland meals like boiled rice with boiled chicken. See a vet the same day if vomiting repeats, there is blood, your pet is a puppy or kitten, seems weak, has a swollen belly, or may have eaten something toxic or a toy.'**
  String get aiAVomiting;

  /// No description provided for @aiADiarrhoea.
  ///
  /// In en, this message translates to:
  /// **'Keep fresh water available so your pet doesn\'t get dehydrated, and give small bland meals (boiled rice with boiled chicken or curd rice for dogs) for a day or two. Avoid milk and treats. See a vet if it lasts more than a day, there is blood or black stool, your pet is vomiting too, seems weak, or is a puppy or kitten.'**
  String get aiADiarrhoea;

  /// No description provided for @aiANotEating.
  ///
  /// In en, this message translates to:
  /// **'Skipping one meal can happen with heat, stress or a change in food. Offer fresh food and water and watch for other signs. See a vet if a dog doesn\'t eat for more than a day, a cat for more than 24 hours, a rabbit for even a few hours (rabbits get sick quickly), or if there is vomiting, weakness, pain or a fever.'**
  String get aiANotEating;

  /// No description provided for @aiAItching.
  ///
  /// In en, this message translates to:
  /// **'Common causes are fleas and ticks, skin infections (often in the monsoon), food or dust allergies, and dry skin from frequent baths. Check the skin for ticks, redness, bald patches or a smell. Keep up tick and flea prevention and dry your dog well after baths and rain. If scratching goes on for more than a few days or the skin is broken, see a vet.'**
  String get aiAItching;

  /// No description provided for @aiALimping.
  ///
  /// In en, this message translates to:
  /// **'Check the paw for thorns, glass, cuts, a broken nail or a tick between the toes, and look for swelling. Rest your dog: short toilet walks only, no running or jumping, for a day. Never give human painkillers; many are poisonous to pets. See a vet if the limp lasts more than a day, your dog can\'t put weight on the leg, cries in pain, or after a fall or accident.'**
  String get aiALimping;

  /// No description provided for @aiALitter.
  ///
  /// In en, this message translates to:
  /// **'Keep the box clean (scoop daily), in a quiet spot away from food, with one box per cat plus one extra. Some cats dislike scented litter or covered boxes. Stress, like a new pet or a move, can also cause it. A cat straining in the box with little or no urine is an emergency, especially a male cat: use SOS.'**
  String get aiALitter;

  /// No description provided for @aiAChewing.
  ///
  /// In en, this message translates to:
  /// **'Puppies explore with their mouths and chew more while teething (3 to 6 months). Give safe chew toys and swap them in when your puppy grabs something else. If they nip, stop play for a few seconds, then continue gently. Praise calm play. Keep wires, shoes and medicines out of reach. Plenty of walks and play reduce chewing. A trainer can help if it continues after 6 months.'**
  String get aiAChewing;

  /// No description provided for @aiANails.
  ///
  /// In en, this message translates to:
  /// **'Trim every 3 to 4 weeks, or when you hear nails clicking on the floor. Use pet nail clippers and cut only the tip, below the pink quick (on dark nails, take tiny slices). Keep styptic powder or plain cornflour ready in case of bleeding. Reward with a treat after each paw. If your pet hates it, a groomer or vet can do it in minutes. Birds and rabbits need nail trims too.'**
  String get aiANails;

  /// No description provided for @aiATeeth.
  ///
  /// In en, this message translates to:
  /// **'Brush your dog\'s or cat\'s teeth 2 to 3 times a week with a pet toothbrush and pet toothpaste (human toothpaste is not safe to swallow). Start slowly with a finger brush and lots of praise. Dental chews help a little. Bad breath, red gums, a broken tooth or dropping food can mean dental disease: book a dental check with your vet.'**
  String get aiATeeth;

  /// No description provided for @aiABirdDiet.
  ///
  /// In en, this message translates to:
  /// **'Seeds alone are not enough. Cockatiels and budgies do best on good-quality pellets with fresh vegetables daily (spinach, carrot, beans, peas) and small amounts of fruit, plus a little seed as a treat. Give fresh water every day. Never give avocado, chocolate, caffeine, salt or onion. Many parrot species are protected in India; only keep legally allowed birds.'**
  String get aiABirdDiet;

  /// No description provided for @aiARabbitDiet.
  ///
  /// In en, this message translates to:
  /// **'Hay should be about 80% of a rabbit\'s diet, available all day: it keeps teeth and gut healthy. Add a handful of leafy greens (coriander, mint, lettuce, carrot tops) daily, a small amount of rabbit pellets, and fruit only as a rare treat. Always keep fresh water. A rabbit that stops eating or pooping for even a few hours needs a vet urgently.'**
  String get aiARabbitDiet;

  /// No description provided for @aiAWeight.
  ///
  /// In en, this message translates to:
  /// **'Feel the ribs: you should feel them easily under a thin layer, and see a waist from above. If you can\'t, your pet may be overweight. Weigh your pet monthly in PawSetu to see the trend against the healthy range for the breed. Cut treats and table scraps, measure food, and add a little more walking or play. Ask your vet before a big diet change.'**
  String get aiAWeight;

  /// No description provided for @aiAAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Before Diwali or a storm, make a quiet den: a covered crate or a corner with their bed, curtains closed, a fan or soft music on. Walk your dog early in the day and keep them indoors with ID tags on when crackers start. Stay calm and close, but don\'t force cuddles. Don\'t scold fear. For severe fear, ask your vet well in advance about calming options.'**
  String get aiAAnxiety;

  /// No description provided for @msgEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get msgEmptyTitle;

  /// No description provided for @msgEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Chats with your vet, clinic, groomer or walker show up here after you book or ask a question.'**
  String get msgEmptyBody;

  /// No description provided for @msgEmptyPartnerBody.
  ///
  /// In en, this message translates to:
  /// **'Chats with pet parents show up here when they book or send an enquiry.'**
  String get msgEmptyPartnerBody;

  /// No description provided for @msgEmptyFilter.
  ///
  /// In en, this message translates to:
  /// **'No chats in this list'**
  String get msgEmptyFilter;

  /// No description provided for @msgNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for \"{query}\"'**
  String msgNoResults(String query);

  /// No description provided for @msgSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search chats and messages'**
  String get msgSearchHint;

  /// No description provided for @msgClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get msgClearSearch;

  /// No description provided for @msgFoundInMessages.
  ///
  /// In en, this message translates to:
  /// **'Found in messages'**
  String get msgFoundInMessages;

  /// No description provided for @msgEnquiries.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get msgEnquiries;

  /// No description provided for @msgEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Enquiry'**
  String get msgEnquiry;

  /// No description provided for @msgMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get msgMuted;

  /// No description provided for @msgNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get msgNoMessagesYet;

  /// No description provided for @msgUnreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread message} other{{count} unread messages}}'**
  String msgUnreadCount(int count);

  /// No description provided for @msgYouPrefix.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get msgYouPrefix;

  /// No description provided for @msgYou.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String msgYou(String name);

  /// No description provided for @msgOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening the chat…'**
  String get msgOpening;

  /// No description provided for @msgPickChat.
  ///
  /// In en, this message translates to:
  /// **'Pick a chat'**
  String get msgPickChat;

  /// No description provided for @msgPickChatHint.
  ///
  /// In en, this message translates to:
  /// **'Your conversations with vets, clinics and service providers open here.'**
  String get msgPickChatHint;

  /// No description provided for @msgPickChatHintPartner.
  ///
  /// In en, this message translates to:
  /// **'Your conversations with pet parents open here.'**
  String get msgPickChatHintPartner;

  /// No description provided for @msgNotFound.
  ///
  /// In en, this message translates to:
  /// **'This chat is no longer available.'**
  String get msgNotFound;

  /// No description provided for @msgPreviewPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get msgPreviewPhoto;

  /// No description provided for @msgPreviewPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get msgPreviewPdf;

  /// No description provided for @msgPreviewVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get msgPreviewVoice;

  /// No description provided for @msgClose.
  ///
  /// In en, this message translates to:
  /// **'Close chat'**
  String get msgClose;

  /// No description provided for @msgChatInfo.
  ///
  /// In en, this message translates to:
  /// **'Chat details'**
  String get msgChatInfo;

  /// No description provided for @msgCallMasked.
  ///
  /// In en, this message translates to:
  /// **'Call (number stays hidden)'**
  String get msgCallMasked;

  /// No description provided for @msgMaskedCallDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo mode doesn\'t place real calls. In the live app this calls {name} through a masked number ({number}), so neither of you sees the other\'s real number.'**
  String msgMaskedCallDemo(String name, String number);

  /// No description provided for @msgMaskedCallLive.
  ///
  /// In en, this message translates to:
  /// **'Calls go through a masked number, so neither side sees the other\'s real number.'**
  String get msgMaskedCallLive;

  /// No description provided for @msgMaskedInfo.
  ///
  /// In en, this message translates to:
  /// **'Phone numbers are hidden in PawSetu chats and calls. Pay only inside the app.'**
  String get msgMaskedInfo;

  /// No description provided for @msgMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get msgMore;

  /// No description provided for @msgSearchInChat.
  ///
  /// In en, this message translates to:
  /// **'Search in chat'**
  String get msgSearchInChat;

  /// No description provided for @msgMatches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No matches} =1{1 match} other{{count} matches}}'**
  String msgMatches(int count);

  /// No description provided for @msgMute.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get msgMute;

  /// No description provided for @msgUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute notifications'**
  String get msgUnmute;

  /// No description provided for @msgMutedToast.
  ///
  /// In en, this message translates to:
  /// **'Chat muted'**
  String get msgMutedToast;

  /// No description provided for @msgUnmutedToast.
  ///
  /// In en, this message translates to:
  /// **'Notifications on for this chat'**
  String get msgUnmutedToast;

  /// No description provided for @msgBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get msgBlock;

  /// No description provided for @msgUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get msgUnblock;

  /// No description provided for @msgBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Block {name}?'**
  String msgBlockTitle(String name);

  /// No description provided for @msgBlockBody.
  ///
  /// In en, this message translates to:
  /// **'Neither of you can send messages in this chat until you unblock. Your bookings are not affected.'**
  String get msgBlockBody;

  /// No description provided for @msgBlockedToast.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get msgBlockedToast;

  /// No description provided for @msgUnblockedToast.
  ///
  /// In en, this message translates to:
  /// **'Unblocked'**
  String get msgUnblockedToast;

  /// No description provided for @msgYouBlocked.
  ///
  /// In en, this message translates to:
  /// **'You blocked this chat. Unblock it from the menu to send messages.'**
  String get msgYouBlocked;

  /// No description provided for @msgBlockedByOther.
  ///
  /// In en, this message translates to:
  /// **'This chat is closed. You can\'t send messages here.'**
  String get msgBlockedByOther;

  /// No description provided for @msgReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get msgReport;

  /// No description provided for @msgReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report this chat'**
  String get msgReportTitle;

  /// No description provided for @msgReportHint.
  ///
  /// In en, this message translates to:
  /// **'PawSetu\'s team reviews every report, usually within a day.'**
  String get msgReportHint;

  /// No description provided for @msgReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or advertising'**
  String get msgReasonSpam;

  /// No description provided for @msgReasonAbuse.
  ///
  /// In en, this message translates to:
  /// **'Rude or abusive'**
  String get msgReasonAbuse;

  /// No description provided for @msgReasonPayment.
  ///
  /// In en, this message translates to:
  /// **'Asked to pay outside PawSetu'**
  String get msgReasonPayment;

  /// No description provided for @msgReasonFake.
  ///
  /// In en, this message translates to:
  /// **'Fake profile or scam'**
  String get msgReasonFake;

  /// No description provided for @msgReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get msgReasonOther;

  /// No description provided for @msgReportDetails.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get msgReportDetails;

  /// No description provided for @msgReportSend.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get msgReportSend;

  /// No description provided for @msgReportedToast.
  ///
  /// In en, this message translates to:
  /// **'Thanks. We\'ll look into it.'**
  String get msgReportedToast;

  /// No description provided for @msgGetHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get msgGetHelp;

  /// No description provided for @msgTypingShort.
  ///
  /// In en, this message translates to:
  /// **'typing…'**
  String get msgTypingShort;

  /// No description provided for @msgTyping.
  ///
  /// In en, this message translates to:
  /// **'{name} is typing…'**
  String msgTyping(String name);

  /// No description provided for @msgTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get msgTypeHint;

  /// No description provided for @msgSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get msgSend;

  /// No description provided for @msgAttach.
  ///
  /// In en, this message translates to:
  /// **'Attach a photo or PDF'**
  String get msgAttach;

  /// No description provided for @msgAttachTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a file'**
  String get msgAttachTitle;

  /// No description provided for @msgAttachPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF document'**
  String get msgAttachPdf;

  /// No description provided for @msgAttachPdfHint.
  ///
  /// In en, this message translates to:
  /// **'Reports, prescriptions, certificates (up to 10 MB)'**
  String get msgAttachPdfHint;

  /// No description provided for @msgPdfTooBig.
  ///
  /// In en, this message translates to:
  /// **'That file is over 10 MB. Please send a smaller PDF.'**
  String get msgPdfTooBig;

  /// No description provided for @msgSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send. Check your connection and try again.'**
  String get msgSendFailed;

  /// No description provided for @msgNumberHiddenToast.
  ///
  /// In en, this message translates to:
  /// **'Phone numbers are hidden in chats to keep everyone safe.'**
  String get msgNumberHiddenToast;

  /// No description provided for @msgNumberHidden.
  ///
  /// In en, this message translates to:
  /// **'Number hidden'**
  String get msgNumberHidden;

  /// No description provided for @msgPaymentWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay only inside PawSetu'**
  String get msgPaymentWarnTitle;

  /// No description provided for @msgPaymentWarnBody.
  ///
  /// In en, this message translates to:
  /// **'Your message looks like it has payment details (UPI ID, card number, OTP or PIN). Never share an OTP or PIN. Payments made outside PawSetu are not protected.'**
  String get msgPaymentWarnBody;

  /// No description provided for @msgSendAnyway.
  ///
  /// In en, this message translates to:
  /// **'Send anyway'**
  String get msgSendAnyway;

  /// No description provided for @msgSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'Numbers are hidden and payments stay inside PawSetu. Never share an OTP or PIN.'**
  String get msgSafetyNote;

  /// No description provided for @msgRecordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get msgRecordVoice;

  /// No description provided for @msgRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording {elapsed} / {max}'**
  String msgRecording(String elapsed, String max);

  /// No description provided for @msgRecordingDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo recording {elapsed}'**
  String msgRecordingDemo(String elapsed);

  /// No description provided for @msgCancelRecording.
  ///
  /// In en, this message translates to:
  /// **'Cancel recording'**
  String get msgCancelRecording;

  /// No description provided for @msgSendVoice.
  ///
  /// In en, this message translates to:
  /// **'Send voice note'**
  String get msgSendVoice;

  /// No description provided for @msgPlayVoice.
  ///
  /// In en, this message translates to:
  /// **'Play voice note'**
  String get msgPlayVoice;

  /// No description provided for @msgPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get msgPause;

  /// No description provided for @msgVoiceCantPlay.
  ///
  /// In en, this message translates to:
  /// **'This voice note can\'t be played on this device.'**
  String get msgVoiceCantPlay;

  /// No description provided for @msgMicUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone not available'**
  String get msgMicUnavailableTitle;

  /// No description provided for @msgMicUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access in your phone\'s settings to send voice notes.'**
  String get msgMicUnavailable;

  /// No description provided for @msgMicDemoBody.
  ///
  /// In en, this message translates to:
  /// **'The microphone isn\'t available here. Send a short demo voice note instead?'**
  String get msgMicDemoBody;

  /// No description provided for @msgRecordDemo.
  ///
  /// In en, this message translates to:
  /// **'Send demo voice note'**
  String get msgRecordDemo;

  /// No description provided for @msgSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get msgSent;

  /// No description provided for @msgRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get msgRead;

  /// No description provided for @msgYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get msgYesterday;

  /// No description provided for @msgDemoReply.
  ///
  /// In en, this message translates to:
  /// **'Demo reply'**
  String get msgDemoReply;

  /// No description provided for @msgPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get msgPdf;

  /// No description provided for @msgTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open'**
  String get msgTapToOpen;

  /// No description provided for @msgFileCantOpen.
  ///
  /// In en, this message translates to:
  /// **'This file can\'t be opened here.'**
  String get msgFileCantOpen;

  /// No description provided for @msgSampleStamp.
  ///
  /// In en, this message translates to:
  /// **'Sample document · Demo'**
  String get msgSampleStamp;

  /// No description provided for @msgSampleDocBody.
  ///
  /// In en, this message translates to:
  /// **'This is a sample document shared in a demo chat.'**
  String get msgSampleDocBody;

  /// No description provided for @msgSysBookingChat.
  ///
  /// In en, this message translates to:
  /// **'Chat for {pet}\'s booking on {when}'**
  String msgSysBookingChat(String pet, String when);

  /// No description provided for @msgSysTvStarted.
  ///
  /// In en, this message translates to:
  /// **'Chat consultation requested'**
  String get msgSysTvStarted;

  /// No description provided for @msgSysTvStartedVideo.
  ///
  /// In en, this message translates to:
  /// **'Video consultation requested'**
  String get msgSysTvStartedVideo;

  /// No description provided for @msgSysTvScheduled.
  ///
  /// In en, this message translates to:
  /// **'Consultation booked for {when}'**
  String msgSysTvScheduled(String when);

  /// No description provided for @msgSysVetJoined.
  ///
  /// In en, this message translates to:
  /// **'{name} joined. The chat stays open until {until}.'**
  String msgSysVetJoined(String name, String until);

  /// No description provided for @msgSysTvEnded.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended'**
  String get msgSysTvEnded;

  /// No description provided for @msgSysCallEnded.
  ///
  /// In en, this message translates to:
  /// **'Video call ended · {duration}'**
  String msgSysCallEnded(String duration);

  /// No description provided for @msgYourPet.
  ///
  /// In en, this message translates to:
  /// **'your pet'**
  String get msgYourPet;

  /// No description provided for @demoReplyClinic.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your message. The clinic team will check {pet}\'s details and get back to you shortly.'**
  String demoReplyClinic(String pet);

  /// No description provided for @demoReplyVet.
  ///
  /// In en, this message translates to:
  /// **'Thanks, noted. How is {pet} eating and drinking today?'**
  String demoReplyVet(String pet);

  /// No description provided for @demoReplyGroomer.
  ///
  /// In en, this message translates to:
  /// **'Sure! We\'ll take good care of {pet}. Please bring any shampoo {pet} is used to.'**
  String demoReplyGroomer(String pet);

  /// No description provided for @demoReplyWalker.
  ///
  /// In en, this message translates to:
  /// **'Got it! I\'ll keep {pet} on the shady side of the road and send you a photo.'**
  String demoReplyWalker(String pet);

  /// No description provided for @demoReplyTrainer.
  ///
  /// In en, this message translates to:
  /// **'Great question. Let\'s practise this with {pet} in our next session.'**
  String demoReplyTrainer(String pet);

  /// No description provided for @demoReplyBoarder.
  ///
  /// In en, this message translates to:
  /// **'{pet} is doing well and settling in nicely. I\'ll send a photo this evening.'**
  String demoReplyBoarder(String pet);

  /// No description provided for @demoReplyOwner.
  ///
  /// In en, this message translates to:
  /// **'Thank you! That helps a lot. – {name}'**
  String demoReplyOwner(String name);

  /// No description provided for @demoReplyOwnerVet.
  ///
  /// In en, this message translates to:
  /// **'Thank you, Dr. {name}! I\'ll follow that.'**
  String demoReplyOwnerVet(String name);

  /// No description provided for @demoVetGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {owner}, I\'m here. I\'ve read what you wrote about {pet}. A few questions to start: since when, and is {pet} eating and drinking normally?'**
  String demoVetGreeting(String owner, String pet);

  /// No description provided for @ntfNewMessage.
  ///
  /// In en, this message translates to:
  /// **'New message from {name}'**
  String ntfNewMessage(String name);

  /// No description provided for @ntfTeleVetMessage.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet: new message from {name}'**
  String ntfTeleVetMessage(String name);

  /// No description provided for @tvHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to a vet'**
  String get tvHomeTitle;

  /// No description provided for @tvHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Chat or video with a registered vet, usually within minutes.'**
  String get tvHomeBody;

  /// No description provided for @tvStart.
  ///
  /// In en, this message translates to:
  /// **'Start a consultation'**
  String get tvStart;

  /// No description provided for @tvEmergencyNote.
  ///
  /// In en, this message translates to:
  /// **'Emergency? Don\'t wait for a chat. Use SOS to reach the nearest open clinic.'**
  String get tvEmergencyNote;

  /// No description provided for @tvOpenConsults.
  ///
  /// In en, this message translates to:
  /// **'Open consultations'**
  String get tvOpenConsults;

  /// No description provided for @tvPastConsults.
  ///
  /// In en, this message translates to:
  /// **'Past consultations'**
  String get tvPastConsults;

  /// No description provided for @tvPartnerHere.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet requests are in your portal'**
  String get tvPartnerHere;

  /// No description provided for @tvPlanFree.
  ///
  /// In en, this message translates to:
  /// **'Your Free plan'**
  String get tvPlanFree;

  /// No description provided for @tvPlanPlus.
  ///
  /// In en, this message translates to:
  /// **'Your Plus plan'**
  String get tvPlanPlus;

  /// No description provided for @tvFreeChip.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get tvFreeChip;

  /// No description provided for @tvLinePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{limit, plural, =1{1 consultation a month} other{{limit} consultations a month}} · {used} used'**
  String tvLinePerMonth(int limit, int used);

  /// No description provided for @tvLineUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited consultations'**
  String get tvLineUnlimited;

  /// No description provided for @tvLineMessages.
  ///
  /// In en, this message translates to:
  /// **'Up to {messages} messages, {words} words each'**
  String tvLineMessages(int messages, int words);

  /// No description provided for @tvLineHours.
  ///
  /// In en, this message translates to:
  /// **'Chat stays open {hours} hours after the vet joins'**
  String tvLineHours(int hours);

  /// No description provided for @tvLineVideo.
  ///
  /// In en, this message translates to:
  /// **'Video calls included, with 10% off'**
  String get tvLineVideo;

  /// No description provided for @tvLineNoVideo.
  ///
  /// In en, this message translates to:
  /// **'Video calls need Plus'**
  String get tvLineNoVideo;

  /// No description provided for @tvMonthlyUsedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used this month\'s free consultation'**
  String get tvMonthlyUsedTitle;

  /// No description provided for @tvMonthlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Your next free consultation opens on {date}. With Plus you get unlimited chats and video calls.'**
  String tvMonthlyUsed(String date);

  /// No description provided for @tvPlusPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'More time with vets'**
  String get tvPlusPromptTitle;

  /// No description provided for @tvPlusHint.
  ///
  /// In en, this message translates to:
  /// **'Plus gives you up to 100 messages of 300 words, 72 hours of chat and video calls.'**
  String get tvPlusHint;

  /// No description provided for @tvVideoPlusTitle.
  ///
  /// In en, this message translates to:
  /// **'Video calls are part of Plus'**
  String get tvVideoPlusTitle;

  /// No description provided for @tvStatusQueuedShort.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get tvStatusQueuedShort;

  /// No description provided for @tvStatusActiveShort.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tvStatusActiveShort;

  /// No description provided for @tvStatusEndedShort.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get tvStatusEndedShort;

  /// No description provided for @tvConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get tvConsentTitle;

  /// No description provided for @tvConsentIntro.
  ///
  /// In en, this message translates to:
  /// **'Online consultations follow the Veterinary Council of India\'s guidelines. Please read and agree:'**
  String get tvConsentIntro;

  /// No description provided for @tvConsent1.
  ///
  /// In en, this message translates to:
  /// **'A vet gives advice from what you describe and show. It is not a full physical examination.'**
  String get tvConsent1;

  /// No description provided for @tvConsent2.
  ///
  /// In en, this message translates to:
  /// **'Every vet on PawSetu is registered with a State Veterinary Council. You\'ll see their registration number.'**
  String get tvConsent2;

  /// No description provided for @tvConsent3.
  ///
  /// In en, this message translates to:
  /// **'The vet may ask you to visit a clinic if your pet needs an examination or tests.'**
  String get tvConsent3;

  /// No description provided for @tvConsent4.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet is not for emergencies. For trouble breathing, collapse, seizures, poisoning or heavy bleeding, use SOS.'**
  String get tvConsent4;

  /// No description provided for @tvConsent5.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions are issued only when the vet thinks it is safe, and some medicines need a clinic visit.'**
  String get tvConsent5;

  /// No description provided for @tvConsent6.
  ///
  /// In en, this message translates to:
  /// **'Your chat, photos and your pet\'s records are shared only with the vet treating your pet.'**
  String get tvConsent6;

  /// No description provided for @tvConsentAgree.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree'**
  String get tvConsentAgree;

  /// No description provided for @tvConsentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tvConsentContinue;

  /// No description provided for @tvStepPet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get tvStepPet;

  /// No description provided for @tvStepProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get tvStepProblem;

  /// No description provided for @tvStepHow.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get tvStepHow;

  /// No description provided for @tvWhichPet.
  ///
  /// In en, this message translates to:
  /// **'Which pet is this about?'**
  String get tvWhichPet;

  /// No description provided for @tvNoPet.
  ///
  /// In en, this message translates to:
  /// **'Add a pet first to talk to a vet.'**
  String get tvNoPet;

  /// No description provided for @tvDescribe.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening with {pet}?'**
  String tvDescribe(String pet);

  /// No description provided for @tvDescribeHint.
  ///
  /// In en, this message translates to:
  /// **'When did it start, what you noticed, eating and drinking, anything they may have eaten'**
  String get tvDescribeHint;

  /// No description provided for @tvAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get tvAddPhotos;

  /// No description provided for @tvPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Clear photos of the problem (a wound, rash, stool or vomit) help the vet a lot.'**
  String get tvPhotosHint;

  /// No description provided for @tvContinueToVet.
  ///
  /// In en, this message translates to:
  /// **'Choose how to talk'**
  String get tvContinueToVet;

  /// No description provided for @tvChatNow.
  ///
  /// In en, this message translates to:
  /// **'Chat now'**
  String get tvChatNow;

  /// No description provided for @tvChatNowHint.
  ///
  /// In en, this message translates to:
  /// **'The next available vet joins, usually within minutes'**
  String get tvChatNowHint;

  /// No description provided for @tvVideoNow.
  ///
  /// In en, this message translates to:
  /// **'Video call now'**
  String get tvVideoNow;

  /// No description provided for @tvVideoNowHint.
  ///
  /// In en, this message translates to:
  /// **'Show the vet your pet on a video call'**
  String get tvVideoNowHint;

  /// No description provided for @tvVideoPlusOnly.
  ///
  /// In en, this message translates to:
  /// **'Available with PawSetu Plus'**
  String get tvVideoPlusOnly;

  /// No description provided for @tvChooseVet.
  ///
  /// In en, this message translates to:
  /// **'Choose a vet'**
  String get tvChooseVet;

  /// No description provided for @tvChooseVetHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a vet by language and experience, now or later today'**
  String get tvChooseVetHint;

  /// No description provided for @tvModeChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tvModeChat;

  /// No description provided for @tvModeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get tvModeVideo;

  /// No description provided for @tvVideoFee.
  ///
  /// In en, this message translates to:
  /// **'Video {amount}'**
  String tvVideoFee(String amount);

  /// No description provided for @tvWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get tvWhen;

  /// No description provided for @tvNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get tvNow;

  /// No description provided for @tvTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tvTomorrow;

  /// No description provided for @tvSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get tvSummary;

  /// No description provided for @tvSummaryPet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get tvSummaryPet;

  /// No description provided for @tvSummaryType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tvSummaryType;

  /// No description provided for @tvSummaryVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get tvSummaryVet;

  /// No description provided for @tvNextAvailable.
  ///
  /// In en, this message translates to:
  /// **'Next available vet'**
  String get tvNextAvailable;

  /// No description provided for @tvFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get tvFee;

  /// No description provided for @tvIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included in your plan'**
  String get tvIncluded;

  /// No description provided for @tvVideoFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Video consultation'**
  String get tvVideoFeeLabel;

  /// No description provided for @tvPlusDiscount.
  ///
  /// In en, this message translates to:
  /// **'Plus discount ({percent}%)'**
  String tvPlusDiscount(int percent);

  /// No description provided for @tvChatRules.
  ///
  /// In en, this message translates to:
  /// **'Up to {messages} messages of {words} words. The chat stays open {hours} hours after the vet joins.'**
  String tvChatRules(int messages, int words, int hours);

  /// No description provided for @tvStartChat.
  ///
  /// In en, this message translates to:
  /// **'Start chat'**
  String get tvStartChat;

  /// No description provided for @tvStartVideo.
  ///
  /// In en, this message translates to:
  /// **'Start video call'**
  String get tvStartVideo;

  /// No description provided for @tvPayAndStart.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} and start'**
  String tvPayAndStart(String amount);

  /// No description provided for @tvPayDescription.
  ///
  /// In en, this message translates to:
  /// **'Video consultation for {pet}'**
  String tvPayDescription(String pet);

  /// No description provided for @tvFindingVet.
  ///
  /// In en, this message translates to:
  /// **'Finding a vet for {pet}…'**
  String tvFindingVet(String pet);

  /// No description provided for @tvFindingVetHint.
  ///
  /// In en, this message translates to:
  /// **'Most chats are picked up within a few minutes. We\'ll notify you.'**
  String get tvFindingVetHint;

  /// No description provided for @tvFindingVetShort.
  ///
  /// In en, this message translates to:
  /// **'Finding a vet…'**
  String get tvFindingVetShort;

  /// No description provided for @tvScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation at {when}'**
  String tvScheduledTitle(String when);

  /// No description provided for @tvScheduledHint.
  ///
  /// In en, this message translates to:
  /// **'The vet will join at this time. You can add details before then.'**
  String get tvScheduledHint;

  /// No description provided for @tvStatusQueued.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a vet'**
  String get tvStatusQueued;

  /// No description provided for @tvStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Consultation open'**
  String get tvStatusActive;

  /// No description provided for @tvStatusEnded.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended'**
  String get tvStatusEnded;

  /// No description provided for @tvOpenUntil.
  ///
  /// In en, this message translates to:
  /// **'Open until {time}'**
  String tvOpenUntil(String time);

  /// No description provided for @tvMessagesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No messages left} =1{1 message left} other{{count} messages left}}'**
  String tvMessagesLeft(int count);

  /// No description provided for @tvPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority (Plus)'**
  String get tvPriority;

  /// No description provided for @tvVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get tvVideoCall;

  /// No description provided for @tvClosedShort.
  ///
  /// In en, this message translates to:
  /// **'Chat closed'**
  String get tvClosedShort;

  /// No description provided for @tvEndedWith.
  ///
  /// In en, this message translates to:
  /// **'Ended · {vet}'**
  String tvEndedWith(String vet);

  /// No description provided for @tvVetBarTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} · {owner}'**
  String tvVetBarTitle(String pet, String owner);

  /// No description provided for @tvRate.
  ///
  /// In en, this message translates to:
  /// **'Rate this consultation'**
  String get tvRate;

  /// No description provided for @tvRateTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your chat with {vet}?'**
  String tvRateTitle(String vet);

  /// No description provided for @tvRateComment.
  ///
  /// In en, this message translates to:
  /// **'Anything to add? (optional)'**
  String get tvRateComment;

  /// No description provided for @tvRateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get tvRateSubmit;

  /// No description provided for @tvRateThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for rating!'**
  String get tvRateThanks;

  /// No description provided for @tvStars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String tvStars(int count);

  /// No description provided for @tvAllowanceLine.
  ///
  /// In en, this message translates to:
  /// **'{words}/{max} words · {left} messages left'**
  String tvAllowanceLine(int words, int max, int left);

  /// No description provided for @tvWordsOver.
  ///
  /// In en, this message translates to:
  /// **'{words}/{max} words. Please shorten your message.'**
  String tvWordsOver(int words, int max);

  /// No description provided for @tvWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages can have up to {max} words'**
  String tvWordsTitle(int max);

  /// No description provided for @tvWordsBody.
  ///
  /// In en, this message translates to:
  /// **'Your message has {words} words, the limit is {max}. Split it into shorter messages or keep just the key points; the vet can ask for more.'**
  String tvWordsBody(int words, int max);

  /// No description provided for @tvEditMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get tvEditMessage;

  /// No description provided for @tvNoMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all {count} messages'**
  String tvNoMessagesTitle(int count);

  /// No description provided for @tvNoMessagesBody.
  ///
  /// In en, this message translates to:
  /// **'The vet can still reply and send a prescription. For more questions, start a new consultation.'**
  String get tvNoMessagesBody;

  /// No description provided for @tvClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'This chat has closed'**
  String get tvClosedTitle;

  /// No description provided for @tvClosedBanner.
  ///
  /// In en, this message translates to:
  /// **'Chats stay open for {hours} hours after the vet joins. Start a new consultation if you need more help.'**
  String tvClosedBanner(int hours);

  /// No description provided for @tvEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended'**
  String get tvEndedTitle;

  /// No description provided for @tvEndedBanner.
  ///
  /// In en, this message translates to:
  /// **'The vet ended this consultation. Your chat and any prescription stay in your pet\'s records.'**
  String get tvEndedBanner;

  /// No description provided for @tvProblemLabel.
  ///
  /// In en, this message translates to:
  /// **'Problem described'**
  String get tvProblemLabel;

  /// No description provided for @tvBookVisit.
  ///
  /// In en, this message translates to:
  /// **'Book a clinic visit'**
  String get tvBookVisit;

  /// No description provided for @tvRecVisitMsg.
  ///
  /// In en, this message translates to:
  /// **'{name} recommends a clinic visit for an examination.'**
  String tvRecVisitMsg(String name);

  /// No description provided for @tvRecEmergencyMsg.
  ///
  /// In en, this message translates to:
  /// **'{name} says this needs emergency care now. Use SOS to reach the nearest open clinic.'**
  String tvRecEmergencyMsg(String name);

  /// No description provided for @tvConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get tvConnecting;

  /// No description provided for @tvWaitingVetJoin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the vet to join…'**
  String get tvWaitingVetJoin;

  /// No description provided for @tvDemoCall.
  ///
  /// In en, this message translates to:
  /// **'DEMO CALL'**
  String get tvDemoCall;

  /// No description provided for @tvGoodNetwork.
  ///
  /// In en, this message translates to:
  /// **'Good connection'**
  String get tvGoodNetwork;

  /// No description provided for @tvWeakNetwork.
  ///
  /// In en, this message translates to:
  /// **'Weak connection'**
  String get tvWeakNetwork;

  /// No description provided for @tvRemoteVideo.
  ///
  /// In en, this message translates to:
  /// **'Video of {name}'**
  String tvRemoteVideo(String name);

  /// No description provided for @tvSelfView.
  ///
  /// In en, this message translates to:
  /// **'Your camera'**
  String get tvSelfView;

  /// No description provided for @tvCameraOff.
  ///
  /// In en, this message translates to:
  /// **'Camera is off'**
  String get tvCameraOff;

  /// No description provided for @tvCameraOffAction.
  ///
  /// In en, this message translates to:
  /// **'Turn camera off'**
  String get tvCameraOffAction;

  /// No description provided for @tvCameraOnAction.
  ///
  /// In en, this message translates to:
  /// **'Turn camera on'**
  String get tvCameraOnAction;

  /// No description provided for @tvMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get tvMute;

  /// No description provided for @tvUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get tvUnmute;

  /// No description provided for @tvSpeakerOn.
  ///
  /// In en, this message translates to:
  /// **'Speaker on'**
  String get tvSpeakerOn;

  /// No description provided for @tvSpeakerOff.
  ///
  /// In en, this message translates to:
  /// **'Speaker off'**
  String get tvSpeakerOff;

  /// No description provided for @tvSwitchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get tvSwitchCamera;

  /// No description provided for @tvFrontCamera.
  ///
  /// In en, this message translates to:
  /// **'Front camera'**
  String get tvFrontCamera;

  /// No description provided for @tvBackCamera.
  ///
  /// In en, this message translates to:
  /// **'Back camera'**
  String get tvBackCamera;

  /// No description provided for @tvEndCall.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get tvEndCall;

  /// No description provided for @tvCallEndedToast.
  ///
  /// In en, this message translates to:
  /// **'Call ended · {duration}'**
  String tvCallEndedToast(String duration);

  /// No description provided for @tvCallFailed.
  ///
  /// In en, this message translates to:
  /// **'The call couldn\'t connect.'**
  String get tvCallFailed;

  /// No description provided for @tvCallLiveLater.
  ///
  /// In en, this message translates to:
  /// **'Real video calls arrive with the live version of PawSetu. Keep chatting with the vet meanwhile.'**
  String get tvCallLiveLater;

  /// No description provided for @tvQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet queue'**
  String get tvQueueTitle;

  /// No description provided for @tvQueueHint.
  ///
  /// In en, this message translates to:
  /// **'Plus members and urgent cases come first. Accept a request to start the chat.'**
  String get tvQueueHint;

  /// No description provided for @tvQueueEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one is waiting right now.'**
  String get tvQueueEmpty;

  /// No description provided for @tvWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get tvWaiting;

  /// No description provided for @tvInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tvInProgress;

  /// No description provided for @tvDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get tvDoneToday;

  /// No description provided for @tvPrescriptionsWritten.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get tvPrescriptionsWritten;

  /// No description provided for @tvNoActive.
  ///
  /// In en, this message translates to:
  /// **'No open consultations.'**
  String get tvNoActive;

  /// No description provided for @tvRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get tvRecent;

  /// No description provided for @tvUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get tvUrgent;

  /// No description provided for @tvAskedForYou.
  ///
  /// In en, this message translates to:
  /// **'Asked for you'**
  String get tvAskedForYou;

  /// No description provided for @tvWaitingFor.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =0{Just now} =1{Waiting 1 min} other{Waiting {minutes} min}}'**
  String tvWaitingFor(int minutes);

  /// No description provided for @tvScheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Booked for {when}'**
  String tvScheduledFor(String when);

  /// No description provided for @tvAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get tvAccept;

  /// No description provided for @tvView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get tvView;

  /// No description provided for @tvAcceptHint.
  ///
  /// In en, this message translates to:
  /// **'Accept to start chatting about {pet}. The pet parent is notified.'**
  String tvAcceptHint(String pet);

  /// No description provided for @tvTabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tvTabChat;

  /// No description provided for @tvTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tvTabHistory;

  /// No description provided for @tvTabTools.
  ///
  /// In en, this message translates to:
  /// **'Notes and tools'**
  String get tvTabTools;

  /// No description provided for @tvOpenVetTools.
  ///
  /// In en, this message translates to:
  /// **'Open vet tools'**
  String get tvOpenVetTools;

  /// No description provided for @tvUrgentSign.
  ///
  /// In en, this message translates to:
  /// **'Urgent sign: {sign}'**
  String tvUrgentSign(String sign);

  /// No description provided for @tvFreeContext.
  ///
  /// In en, this message translates to:
  /// **'Free plan: you see the basic profile. Plus members share their full health history.'**
  String get tvFreeContext;

  /// No description provided for @tvTemperament.
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get tvTemperament;

  /// No description provided for @tvRecentHealth.
  ///
  /// In en, this message translates to:
  /// **'Recent health records'**
  String get tvRecentHealth;

  /// No description provided for @tvNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get tvNone;

  /// No description provided for @tvPrivateNotes.
  ///
  /// In en, this message translates to:
  /// **'Private notes'**
  String get tvPrivateNotes;

  /// No description provided for @tvPrivateNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Only you can see these notes.'**
  String get tvPrivateNotesHint;

  /// No description provided for @tvNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Findings, differentials, plan…'**
  String get tvNotesPlaceholder;

  /// No description provided for @tvRecommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get tvRecommend;

  /// No description provided for @tvRecVisit.
  ///
  /// In en, this message translates to:
  /// **'Clinic visit'**
  String get tvRecVisit;

  /// No description provided for @tvRecEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency care'**
  String get tvRecEmergency;

  /// No description provided for @tvRecVisitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Tell {name} to bring their pet to a clinic for an examination?'**
  String tvRecVisitConfirm(String name);

  /// No description provided for @tvRecEmergencyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Tell {name} this needs emergency care now? They\'ll see the SOS button.'**
  String tvRecEmergencyConfirm(String name);

  /// No description provided for @tvRecSent.
  ///
  /// In en, this message translates to:
  /// **'Recommendation sent'**
  String get tvRecSent;

  /// No description provided for @tvRecDoneVisit.
  ///
  /// In en, this message translates to:
  /// **'Clinic visit recommended'**
  String get tvRecDoneVisit;

  /// No description provided for @tvRecDoneEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency care recommended'**
  String get tvRecDoneEmergency;

  /// No description provided for @tvSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get tvSend;

  /// No description provided for @tvEnd.
  ///
  /// In en, this message translates to:
  /// **'End consultation'**
  String get tvEnd;

  /// No description provided for @tvEndTitle.
  ///
  /// In en, this message translates to:
  /// **'End this consultation?'**
  String get tvEndTitle;

  /// No description provided for @tvEndBody.
  ///
  /// In en, this message translates to:
  /// **'The pet parent can no longer send messages. The chat and prescription stay in their records.'**
  String get tvEndBody;

  /// No description provided for @tvEndBodyNoRx.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t written a prescription. End anyway? The pet parent can no longer send messages.'**
  String get tvEndBodyNoRx;

  /// No description provided for @tvEndedToast.
  ///
  /// In en, this message translates to:
  /// **'Consultation ended'**
  String get tvEndedToast;

  /// No description provided for @tvVetSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'Ask for a clinic visit when an examination or tests are needed. Don\'t share personal phone numbers.'**
  String get tvVetSafetyNote;

  /// No description provided for @rxWrite.
  ///
  /// In en, this message translates to:
  /// **'Write prescription'**
  String get rxWrite;

  /// No description provided for @rxTitleOf.
  ///
  /// In en, this message translates to:
  /// **'Prescription for {pet}'**
  String rxTitleOf(String pet);

  /// No description provided for @rxTitle.
  ///
  /// In en, this message translates to:
  /// **'E-prescription'**
  String get rxTitle;

  /// No description provided for @rxRegNo.
  ///
  /// In en, this message translates to:
  /// **'Reg. no. {number}'**
  String rxRegNo(String number);

  /// No description provided for @rxDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis or assessment'**
  String get rxDiagnosis;

  /// No description provided for @rxDiagnosisHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. mild gastritis'**
  String get rxDiagnosisHint;

  /// No description provided for @rxMedicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get rxMedicines;

  /// No description provided for @rxMedicineN.
  ///
  /// In en, this message translates to:
  /// **'Medicine {n}'**
  String rxMedicineN(int n);

  /// No description provided for @rxMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine and strength'**
  String get rxMedicine;

  /// No description provided for @rxMedicineHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Ondansetron 4 mg tablet'**
  String get rxMedicineHint;

  /// No description provided for @rxDoseHint.
  ///
  /// In en, this message translates to:
  /// **'Dose, e.g. half a tablet'**
  String get rxDoseHint;

  /// No description provided for @rxFreqOnce.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get rxFreqOnce;

  /// No description provided for @rxFreqTwice.
  ///
  /// In en, this message translates to:
  /// **'Twice a day'**
  String get rxFreqTwice;

  /// No description provided for @rxFreqThrice.
  ///
  /// In en, this message translates to:
  /// **'Three times a day'**
  String get rxFreqThrice;

  /// No description provided for @rxFreqNeeded.
  ///
  /// In en, this message translates to:
  /// **'When needed'**
  String get rxFreqNeeded;

  /// No description provided for @rxDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get rxDuration;

  /// No description provided for @rxDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String rxDays(int count);

  /// No description provided for @rxInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get rxInstructions;

  /// No description provided for @rxAfterFood.
  ///
  /// In en, this message translates to:
  /// **'After food'**
  String get rxAfterFood;

  /// No description provided for @rxBeforeFood.
  ///
  /// In en, this message translates to:
  /// **'Before food'**
  String get rxBeforeFood;

  /// No description provided for @rxApplyThin.
  ///
  /// In en, this message translates to:
  /// **'Apply a thin layer'**
  String get rxApplyThin;

  /// No description provided for @rxAddMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get rxAddMedicine;

  /// No description provided for @rxNeedMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add at least one medicine.'**
  String get rxNeedMedicine;

  /// No description provided for @rxAdvice.
  ///
  /// In en, this message translates to:
  /// **'Advice for the pet parent'**
  String get rxAdvice;

  /// No description provided for @rxAdviceHint.
  ///
  /// In en, this message translates to:
  /// **'Diet, rest, what to watch for, when to come back'**
  String get rxAdviceHint;

  /// No description provided for @rxAddFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Add a follow-up date'**
  String get rxAddFollowUp;

  /// No description provided for @rxFollowUpOn.
  ///
  /// In en, this message translates to:
  /// **'Follow-up on {date}'**
  String rxFollowUpOn(String date);

  /// No description provided for @rxFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get rxFollowUp;

  /// No description provided for @rxNoFollowUp.
  ///
  /// In en, this message translates to:
  /// **'No follow-up needed'**
  String get rxNoFollowUp;

  /// No description provided for @rxWhereItGoes.
  ///
  /// In en, this message translates to:
  /// **'It goes to {pet}\'s health records and the pet parent\'s vault, with a reminder for any follow-up.'**
  String rxWhereItGoes(String pet);

  /// No description provided for @rxPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get rxPreview;

  /// No description provided for @rxSignTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign and send?'**
  String get rxSignTitle;

  /// No description provided for @rxSignBody.
  ///
  /// In en, this message translates to:
  /// **'This prescription will be signed digitally with your registration number and sent to {owner} for {pet}.'**
  String rxSignBody(String owner, String pet);

  /// No description provided for @rxSignSend.
  ///
  /// In en, this message translates to:
  /// **'Sign and send'**
  String get rxSignSend;

  /// No description provided for @rxSentToast.
  ///
  /// In en, this message translates to:
  /// **'Prescription sent to {owner} for {pet}'**
  String rxSentToast(String owner, String pet);

  /// No description provided for @rxSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to {pet}\'s health records'**
  String rxSaved(String pet);

  /// No description provided for @rxCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescription from {vet}'**
  String rxCardTitle(String vet);

  /// No description provided for @rxView.
  ///
  /// In en, this message translates to:
  /// **'View prescription'**
  String get rxView;

  /// No description provided for @rxSentPreview.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get rxSentPreview;

  /// No description provided for @rxPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get rxPatient;

  /// No description provided for @rxPetName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get rxPetName;

  /// No description provided for @rxSpeciesBreed.
  ///
  /// In en, this message translates to:
  /// **'Species and breed'**
  String get rxSpeciesBreed;

  /// No description provided for @rxSignedDigitally.
  ///
  /// In en, this message translates to:
  /// **'Signed digitally on {when}'**
  String rxSignedDigitally(String when);

  /// No description provided for @rxFooter.
  ///
  /// In en, this message translates to:
  /// **'PawSetu e-prescription · Demo data · Valid only with the vet\'s registration number'**
  String get rxFooter;

  /// No description provided for @rxDocTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescription for {pet}, {date}'**
  String rxDocTitle(String pet, String date);

  /// No description provided for @rxEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet consultation with {vet}'**
  String rxEventTitle(String vet);

  /// No description provided for @rxEventNotes.
  ///
  /// In en, this message translates to:
  /// **'Prescribed: {medicines}'**
  String rxEventNotes(String medicines);

  /// No description provided for @rxFollowUpReminder.
  ///
  /// In en, this message translates to:
  /// **'Follow-up for {pet} with {vet}'**
  String rxFollowUpReminder(String pet, String vet);

  /// No description provided for @ntfTeleVetRequest.
  ///
  /// In en, this message translates to:
  /// **'New tele-vet request: {pet} ({owner})'**
  String ntfTeleVetRequest(String pet, String owner);

  /// No description provided for @ntfVetJoined.
  ///
  /// In en, this message translates to:
  /// **'{vet} joined your chat about {pet}'**
  String ntfVetJoined(String vet, String pet);

  /// No description provided for @ntfConsultEnded.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet consultation for {pet} has ended'**
  String ntfConsultEnded(String pet);

  /// No description provided for @ntfPrescription.
  ///
  /// In en, this message translates to:
  /// **'{vet} sent a prescription for {pet}'**
  String ntfPrescription(String vet, String pet);

  /// No description provided for @albumPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get albumPhotos;

  /// No description provided for @albumTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get albumTimeline;

  /// No description provided for @albumAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albumAlbums;

  /// No description provided for @albumFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get albumFavourites;

  /// No description provided for @albumAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photos or videos'**
  String get albumAdd;

  /// No description provided for @albumAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to {pet}\'s album'**
  String albumAddTitle(String pet);

  /// No description provided for @albumAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add the first photo of {pet}'**
  String albumAddFirst(String pet);

  /// No description provided for @albumChoosePhotos.
  ///
  /// In en, this message translates to:
  /// **'Choose photos'**
  String get albumChoosePhotos;

  /// No description provided for @albumChooseVideo.
  ///
  /// In en, this message translates to:
  /// **'Choose a video'**
  String get albumChooseVideo;

  /// No description provided for @albumRecordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record a video'**
  String get albumRecordVideo;

  /// No description provided for @albumCaption.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get albumCaption;

  /// No description provided for @albumCaptionHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening in this moment?'**
  String get albumCaptionHint;

  /// No description provided for @albumDateTaken.
  ///
  /// In en, this message translates to:
  /// **'Date taken'**
  String get albumDateTaken;

  /// No description provided for @albumMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get albumMilestone;

  /// No description provided for @albumNoMilestone.
  ///
  /// In en, this message translates to:
  /// **'No milestone'**
  String get albumNoMilestone;

  /// No description provided for @albumAddMilestone.
  ///
  /// In en, this message translates to:
  /// **'Mark as a milestone'**
  String get albumAddMilestone;

  /// No description provided for @albumMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone name'**
  String get albumMilestoneTitle;

  /// No description provided for @albumMilestoneTitleHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. First swim'**
  String get albumMilestoneTitleHint;

  /// No description provided for @albumMsGotcha.
  ///
  /// In en, this message translates to:
  /// **'Gotcha day'**
  String get albumMsGotcha;

  /// No description provided for @albumMsFirstWalk.
  ///
  /// In en, this message translates to:
  /// **'First walk'**
  String get albumMsFirstWalk;

  /// No description provided for @albumMsFirstVaccine.
  ///
  /// In en, this message translates to:
  /// **'First vaccine'**
  String get albumMsFirstVaccine;

  /// No description provided for @albumMsBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get albumMsBirthday;

  /// No description provided for @albumMsCustom.
  ///
  /// In en, this message translates to:
  /// **'Special moment'**
  String get albumMsCustom;

  /// No description provided for @albumNewAlbum.
  ///
  /// In en, this message translates to:
  /// **'New album'**
  String get albumNewAlbum;

  /// No description provided for @albumAlbumName.
  ///
  /// In en, this message translates to:
  /// **'Album name'**
  String get albumAlbumName;

  /// No description provided for @albumUploading.
  ///
  /// In en, this message translates to:
  /// **'Adding your memories…'**
  String get albumUploading;

  /// No description provided for @albumPhotosAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory added} other{{count} memories added}}'**
  String albumPhotosAdded(int count);

  /// No description provided for @albumSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to {pet}\'s album'**
  String albumSaved(String pet);

  /// No description provided for @albumAddedToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Added to {album}'**
  String albumAddedToAlbum(String album);

  /// No description provided for @albumStorageNote.
  ///
  /// In en, this message translates to:
  /// **'Photos and videos use your plan\'s storage. Videos up to 1 minute on Free, 3 minutes on Plus.'**
  String get albumStorageNote;

  /// No description provided for @albumVideoMaxSec.
  ///
  /// In en, this message translates to:
  /// **'Videos up to {seconds} seconds'**
  String albumVideoMaxSec(int seconds);

  /// No description provided for @albumVideoTooLongTitle.
  ///
  /// In en, this message translates to:
  /// **'This video is too long'**
  String get albumVideoTooLongTitle;

  /// No description provided for @albumVideoTooLong.
  ///
  /// In en, this message translates to:
  /// **'It\'s {seconds} seconds; your plan allows {limit}.'**
  String albumVideoTooLong(int seconds, int limit);

  /// No description provided for @albumVideoPlusBody.
  ///
  /// In en, this message translates to:
  /// **'Trim it on your phone, or get 3-minute videos with PawSetu Plus.'**
  String get albumVideoPlusBody;

  /// No description provided for @albumEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memories yet'**
  String get albumEmptyTitle;

  /// No description provided for @albumEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add {pet}\'s photos and videos. They\'re grouped by month, with milestones on a timeline.'**
  String albumEmptyBody(String pet);

  /// No description provided for @albumMonthCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 memory} other{{count} memories}}'**
  String albumMonthCount(int count);

  /// No description provided for @albumOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'On this day'**
  String get albumOnThisDay;

  /// No description provided for @albumLatestMemory.
  ///
  /// In en, this message translates to:
  /// **'Latest memory'**
  String get albumLatestMemory;

  /// No description provided for @albumOfPet.
  ///
  /// In en, this message translates to:
  /// **'A moment with {pet}'**
  String albumOfPet(String pet);

  /// No description provided for @albumSeeAlbum.
  ///
  /// In en, this message translates to:
  /// **'See album'**
  String get albumSeeAlbum;

  /// No description provided for @albumYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String albumYearsAgo(int count);

  /// No description provided for @albumTimelineBorn.
  ///
  /// In en, this message translates to:
  /// **'{pet} was born'**
  String albumTimelineBorn(String pet);

  /// No description provided for @albumTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mark milestones while adding photos and {pet}\'s story appears here.'**
  String albumTimelineEmpty(String pet);

  /// No description provided for @albumCelebrate.
  ///
  /// In en, this message translates to:
  /// **'Celebrate'**
  String get albumCelebrate;

  /// No description provided for @albumBadges.
  ///
  /// In en, this message translates to:
  /// **'Milestone badges'**
  String get albumBadges;

  /// No description provided for @albumBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'not yet'**
  String get albumBadgeLocked;

  /// No description provided for @albumNoAlbums.
  ///
  /// In en, this message translates to:
  /// **'No albums yet'**
  String get albumNoAlbums;

  /// No description provided for @albumNoAlbumsBody.
  ///
  /// In en, this message translates to:
  /// **'Group memories into albums like \"Goa trip\" or \"First year\".'**
  String get albumNoAlbumsBody;

  /// No description provided for @albumNoFavourites.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get albumNoFavourites;

  /// No description provided for @albumNoFavouritesBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a photo to keep it here.'**
  String get albumNoFavouritesBody;

  /// No description provided for @albumChooseForAlbum.
  ///
  /// In en, this message translates to:
  /// **'Choose memories for {album}'**
  String albumChooseForAlbum(String album);

  /// No description provided for @albumItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String albumItemsSelected(int count);

  /// No description provided for @albumRenameAlbum.
  ///
  /// In en, this message translates to:
  /// **'Rename album'**
  String get albumRenameAlbum;

  /// No description provided for @albumDeleteAlbum.
  ///
  /// In en, this message translates to:
  /// **'Remove album'**
  String get albumDeleteAlbum;

  /// No description provided for @albumDeleteAlbumBody.
  ///
  /// In en, this message translates to:
  /// **'The photos stay in {pet}\'s album. Only this group is removed.'**
  String albumDeleteAlbumBody(String pet);

  /// No description provided for @albumRemoveFromAlbum.
  ///
  /// In en, this message translates to:
  /// **'Remove from album'**
  String get albumRemoveFromAlbum;

  /// No description provided for @albumVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get albumVideo;

  /// No description provided for @albumOfCount.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String albumOfCount(int index, int total);

  /// No description provided for @albumClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get albumClose;

  /// No description provided for @albumPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get albumPrevious;

  /// No description provided for @albumFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get albumFavourite;

  /// No description provided for @albumUnfavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get albumUnfavourite;

  /// No description provided for @albumEditCaption.
  ///
  /// In en, this message translates to:
  /// **'Edit caption'**
  String get albumEditCaption;

  /// No description provided for @albumAddToAlbum.
  ///
  /// In en, this message translates to:
  /// **'Add to album'**
  String get albumAddToAlbum;

  /// No description provided for @albumShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get albumShare;

  /// No description provided for @albumDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get albumDelete;

  /// No description provided for @albumDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get albumDeleteQ;

  /// No description provided for @albumDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from {pet}\'s album for everyone in the family.'**
  String albumDeleteBody(String pet);

  /// No description provided for @albumDeleted.
  ///
  /// In en, this message translates to:
  /// **'Memory deleted'**
  String get albumDeleted;

  /// No description provided for @albumAddedBy.
  ///
  /// In en, this message translates to:
  /// **'Added by {name}'**
  String albumAddedBy(String name);

  /// No description provided for @albumPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get albumPlay;

  /// No description provided for @albumPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get albumPause;

  /// No description provided for @albumVideoFailed.
  ///
  /// In en, this message translates to:
  /// **'This video can\'t be played here.'**
  String get albumVideoFailed;

  /// No description provided for @albumDemoVideo.
  ///
  /// In en, this message translates to:
  /// **'Demo video: a sample clip stands in for the real file.'**
  String get albumDemoVideo;

  /// No description provided for @albumShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share memories'**
  String get albumShareTitle;

  /// No description provided for @albumShareBody.
  ///
  /// In en, this message translates to:
  /// **'Send to WhatsApp or any app, or make a private link for family.'**
  String get albumShareBody;

  /// No description provided for @albumShareToApps.
  ///
  /// In en, this message translates to:
  /// **'Share to apps'**
  String get albumShareToApps;

  /// No description provided for @albumShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t share. Please try again.'**
  String get albumShareFailed;

  /// No description provided for @albumWatermark.
  ///
  /// In en, this message translates to:
  /// **'Add a PawSetu watermark'**
  String get albumWatermark;

  /// No description provided for @albumWatermarkPhotosOnly.
  ///
  /// In en, this message translates to:
  /// **'Photos only; videos are shared as they are.'**
  String get albumWatermarkPhotosOnly;

  /// No description provided for @albumWatermarkText.
  ///
  /// In en, this message translates to:
  /// **'Made with PawSetu'**
  String get albumWatermarkText;

  /// No description provided for @albumFamilyLink.
  ///
  /// In en, this message translates to:
  /// **'Private family link'**
  String get albumFamilyLink;

  /// No description provided for @albumFamilyLinkBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the link can view these memories of {pet} until it expires. You can stop it any time.'**
  String albumFamilyLinkBody(String pet);

  /// No description provided for @albumFamilyLinkWhich.
  ///
  /// In en, this message translates to:
  /// **'What to share'**
  String get albumFamilyLinkWhich;

  /// No description provided for @albumWholeAlbum.
  ///
  /// In en, this message translates to:
  /// **'The whole album'**
  String get albumWholeAlbum;

  /// No description provided for @albumFamilyLinkText.
  ///
  /// In en, this message translates to:
  /// **'Photos of {pet} on PawSetu: {url}'**
  String albumFamilyLinkText(String pet, String url);

  /// No description provided for @albumSharedBy.
  ///
  /// In en, this message translates to:
  /// **'{owner} shared memories of {pet}'**
  String albumSharedBy(String owner, String pet);

  /// No description provided for @albumBirthdayScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get albumBirthdayScreenTitle;

  /// No description provided for @albumBirthdayToday.
  ///
  /// In en, this message translates to:
  /// **'Happy birthday, {pet}!'**
  String albumBirthdayToday(String pet);

  /// No description provided for @albumBirthdayIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{{pet} turns {age} tomorrow} other{{pet} turns {age} in {days} days}}'**
  String albumBirthdayIn(int days, String pet, int age);

  /// No description provided for @albumBirthdaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} is {age} today'**
  String albumBirthdaySubtitle(int age, String pet);

  /// No description provided for @albumBirthdayWishes.
  ///
  /// In en, this message translates to:
  /// **'Wishing {pet} lots of walks, treats and cuddles this year!'**
  String albumBirthdayWishes(String pet);

  /// No description provided for @albumBirthdayMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories from this year'**
  String get albumBirthdayMemories;

  /// No description provided for @albumBirthdayAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a birthday photo'**
  String get albumBirthdayAddPhoto;

  /// No description provided for @albumBirthdayReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me before {pet}\'s birthday'**
  String albumBirthdayReminder(String pet);

  /// No description provided for @albumBirthdayReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s birthday is coming up'**
  String albumBirthdayReminderTitle(String pet);

  /// No description provided for @albumBirthdayReminderOn.
  ///
  /// In en, this message translates to:
  /// **'Birthday reminder on'**
  String get albumBirthdayReminderOn;

  /// No description provided for @albumNoBirthday.
  ///
  /// In en, this message translates to:
  /// **'Add {pet}\'s birthday to celebrate it here.'**
  String albumNoBirthday(String pet);

  /// No description provided for @vaultSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your vault'**
  String get vaultSetupTitle;

  /// No description provided for @vaultSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4 to 6 digit PIN. You\'ll enter it each time you open the vault.'**
  String get vaultSetupBody;

  /// No description provided for @vaultSetupBodyBio.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4 to 6 digit PIN as a backup. You can then unlock with your fingerprint or face.'**
  String get vaultSetupBodyBio;

  /// No description provided for @vaultChoosePin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get vaultChoosePin;

  /// No description provided for @vaultConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get vaultConfirmPin;

  /// No description provided for @vaultCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get vaultCurrentPin;

  /// No description provided for @vaultSetPinButton.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get vaultSetPinButton;

  /// No description provided for @vaultPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs don\'t match. Try again.'**
  String get vaultPinMismatch;

  /// No description provided for @vaultPinWeak.
  ///
  /// In en, this message translates to:
  /// **'That PIN is easy to guess. Avoid 1234 or repeated digits.'**
  String get vaultPinWeak;

  /// No description provided for @vaultPinSet.
  ///
  /// In en, this message translates to:
  /// **'Vault PIN set'**
  String get vaultPinSet;

  /// No description provided for @vaultPinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get vaultPinChanged;

  /// No description provided for @vaultChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get vaultChangePin;

  /// No description provided for @vaultPinDigits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No digits entered} =1{1 digit entered} other{{count} digits entered}}'**
  String vaultPinDigits(int count);

  /// No description provided for @vaultPinBackspace.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get vaultPinBackspace;

  /// No description provided for @vaultLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault locked'**
  String get vaultLockedTitle;

  /// No description provided for @vaultLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Your pet\'s documents are protected. Unlock to continue.'**
  String get vaultLockedBody;

  /// No description provided for @vaultUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get vaultUnlock;

  /// No description provided for @vaultUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face'**
  String get vaultUseBiometrics;

  /// No description provided for @vaultBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock your PawSetu document vault'**
  String get vaultBiometricReason;

  /// No description provided for @vaultBiometricsToggle.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get vaultBiometricsToggle;

  /// No description provided for @vaultWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN.'**
  String get vaultWrongPin;

  /// No description provided for @vaultTriesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 try left.} other{{count} tries left.}}'**
  String vaultTriesLeft(int count);

  /// No description provided for @vaultLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Try again in {seconds} seconds.'**
  String vaultLockedOut(int seconds);

  /// No description provided for @vaultForgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get vaultForgotPin;

  /// No description provided for @vaultForgotPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your vault PIN'**
  String get vaultForgotPinTitle;

  /// No description provided for @vaultForgotPinBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in again to prove it\'s you, then choose a new PIN. Your documents stay safe.'**
  String get vaultForgotPinBody;

  /// No description provided for @vaultSignInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get vaultSignInAgain;

  /// No description provided for @vaultAutoLockNote.
  ///
  /// In en, this message translates to:
  /// **'The vault locks itself after 2 minutes away.'**
  String get vaultAutoLockNote;

  /// No description provided for @vaultLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock now'**
  String get vaultLockNow;

  /// No description provided for @vaultLockSettings.
  ///
  /// In en, this message translates to:
  /// **'Vault lock'**
  String get vaultLockSettings;

  /// No description provided for @vaultOfPet.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s documents'**
  String vaultOfPet(String pet);

  /// No description provided for @vaultAllDocs.
  ///
  /// In en, this message translates to:
  /// **'All documents'**
  String get vaultAllDocs;

  /// No description provided for @vaultDocCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 document} other{{count} documents}}'**
  String vaultDocCount(int count);

  /// No description provided for @vaultSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search titles, tags or vets'**
  String get vaultSearchHint;

  /// No description provided for @vaultClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get vaultClearSearch;

  /// No description provided for @vaultNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get vaultNeedsAttention;

  /// No description provided for @vaultNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Check details'**
  String get vaultNeedsReview;

  /// No description provided for @vaultAddedOn.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String vaultAddedOn(String date);

  /// No description provided for @vaultEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your vault is empty'**
  String get vaultEmptyTitle;

  /// No description provided for @vaultEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Keep vaccination certificates, prescriptions, lab reports and insurance safe in one place.'**
  String get vaultEmptyBody;

  /// No description provided for @vaultAddDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get vaultAddDocument;

  /// No description provided for @vaultStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get vaultStorageTitle;

  /// No description provided for @vaultStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} used'**
  String vaultStorageUsed(String used, String limit);

  /// No description provided for @vaultStorageSplit.
  ///
  /// In en, this message translates to:
  /// **'Documents {docs} · Album {album}'**
  String vaultStorageSplit(String docs, String album);

  /// No description provided for @vaultStorageFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage full'**
  String get vaultStorageFullTitle;

  /// No description provided for @vaultStorageFullBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used {used} of {limit}. Delete old files or get 25 GB with PawSetu Plus.'**
  String vaultStorageFullBody(String used, String limit);

  /// No description provided for @vaultStorageFullBodyPlus.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used {used} of {limit}. Delete old files to make room.'**
  String vaultStorageFullBodyPlus(String used, String limit);

  /// No description provided for @vaultTooBig.
  ///
  /// In en, this message translates to:
  /// **'That file is too big. Please choose one under 20 MB.'**
  String get vaultTooBig;

  /// No description provided for @vaultTypeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination certificate'**
  String get vaultTypeVaccination;

  /// No description provided for @vaultTypePrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get vaultTypePrescription;

  /// No description provided for @vaultTypeLab.
  ///
  /// In en, this message translates to:
  /// **'Lab report'**
  String get vaultTypeLab;

  /// No description provided for @vaultTypeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get vaultTypeInsurance;

  /// No description provided for @vaultTypeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Bill or invoice'**
  String get vaultTypeInvoice;

  /// No description provided for @vaultTypeLicence.
  ///
  /// In en, this message translates to:
  /// **'Municipal licence'**
  String get vaultTypeLicence;

  /// No description provided for @vaultTypeAdoption.
  ///
  /// In en, this message translates to:
  /// **'Adoption or purchase papers'**
  String get vaultTypeAdoption;

  /// No description provided for @vaultTypeTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel or health certificate'**
  String get vaultTypeTravel;

  /// No description provided for @vaultTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vaultTypeOther;

  /// No description provided for @vaultExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get vaultExpired;

  /// No description provided for @vaultExpiresSoon.
  ///
  /// In en, this message translates to:
  /// **'Expires soon'**
  String get vaultExpiresSoon;

  /// No description provided for @vaultExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String vaultExpiresOn(String date);

  /// No description provided for @vaultExpiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired {date}'**
  String vaultExpiredOn(String date);

  /// No description provided for @vaultNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry date'**
  String get vaultNoExpiry;

  /// No description provided for @vaultUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a document'**
  String get vaultUploadTitle;

  /// No description provided for @vaultForPet.
  ///
  /// In en, this message translates to:
  /// **'For which pet?'**
  String get vaultForPet;

  /// No description provided for @vaultScanCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get vaultScanCamera;

  /// No description provided for @vaultScanCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Edges are found for you; adjust the corners if needed'**
  String get vaultScanCameraHint;

  /// No description provided for @vaultFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo from gallery'**
  String get vaultFromGallery;

  /// No description provided for @vaultFromPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF file'**
  String get vaultFromPdf;

  /// No description provided for @vaultPdfOnly.
  ///
  /// In en, this message translates to:
  /// **'Please choose a PDF file.'**
  String get vaultPdfOnly;

  /// No description provided for @vaultTrySample.
  ///
  /// In en, this message translates to:
  /// **'Demo: try a sample document to see auto-read'**
  String get vaultTrySample;

  /// No description provided for @vaultSampleRabies.
  ///
  /// In en, this message translates to:
  /// **'Sample rabies certificate'**
  String get vaultSampleRabies;

  /// No description provided for @vaultSampleLab.
  ///
  /// In en, this message translates to:
  /// **'Sample blood test report'**
  String get vaultSampleLab;

  /// No description provided for @vaultSampleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Sample insurance policy'**
  String get vaultSampleInsurance;

  /// No description provided for @vaultUploading.
  ///
  /// In en, this message translates to:
  /// **'Saving securely…'**
  String get vaultUploading;

  /// No description provided for @vaultScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust the scan'**
  String get vaultScanTitle;

  /// No description provided for @vaultScanHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the corners to the edges of the page.'**
  String get vaultScanHint;

  /// No description provided for @vaultScanAuto.
  ///
  /// In en, this message translates to:
  /// **'Page edges found. Adjust the corners if needed.'**
  String get vaultScanAuto;

  /// No description provided for @vaultScanBw.
  ///
  /// In en, this message translates to:
  /// **'Black and white (sharper text)'**
  String get vaultScanBw;

  /// No description provided for @vaultScanCorner.
  ///
  /// In en, this message translates to:
  /// **'Corner handle, drag to adjust'**
  String get vaultScanCorner;

  /// No description provided for @vaultUseScan.
  ///
  /// In en, this message translates to:
  /// **'Use this scan'**
  String get vaultUseScan;

  /// No description provided for @vaultPreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t show a preview of this file.'**
  String get vaultPreviewFailed;

  /// No description provided for @vaultReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the document…'**
  String get vaultReading;

  /// No description provided for @vaultCheckDetails.
  ///
  /// In en, this message translates to:
  /// **'Check the details'**
  String get vaultCheckDetails;

  /// No description provided for @vaultCheckDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'We read these from the document. Please confirm or correct them.'**
  String get vaultCheckDetailsHint;

  /// No description provided for @vaultAddDetails.
  ///
  /// In en, this message translates to:
  /// **'Add details'**
  String get vaultAddDetails;

  /// No description provided for @vaultFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'We found these details'**
  String get vaultFoundTitle;

  /// No description provided for @vaultFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check each field before saving. Nothing is saved until you confirm.'**
  String get vaultFoundBody;

  /// No description provided for @vaultNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read this one'**
  String get vaultNotFoundTitle;

  /// No description provided for @vaultNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Add the details yourself, or skip and add them later.'**
  String get vaultNotFoundBody;

  /// No description provided for @vaultDemoReadNote.
  ///
  /// In en, this message translates to:
  /// **'Demo auto-read: details come from the sample document, not a real scan of your file.'**
  String get vaultDemoReadNote;

  /// No description provided for @vaultPetMismatch.
  ///
  /// In en, this message translates to:
  /// **'The document says {docPet}, but you chose {pet}. Check the pet before saving.'**
  String vaultPetMismatch(String docPet, String pet);

  /// No description provided for @vaultFieldDocType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get vaultFieldDocType;

  /// No description provided for @vaultFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get vaultFieldTitle;

  /// No description provided for @vaultFieldTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get vaultFieldTags;

  /// No description provided for @vaultTagHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. rabies, 2026'**
  String get vaultTagHint;

  /// No description provided for @vaultAddTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get vaultAddTag;

  /// No description provided for @vaultAddToHealth.
  ///
  /// In en, this message translates to:
  /// **'Add to {pet}\'s health records'**
  String vaultAddToHealth(String pet);

  /// No description provided for @vaultAddToHealthHint.
  ///
  /// In en, this message translates to:
  /// **'Records the vaccine, and the next dose is scheduled for you.'**
  String get vaultAddToHealthHint;

  /// No description provided for @vaultVaccineNeeded.
  ///
  /// In en, this message translates to:
  /// **'Add the vaccine name and the date given to save it to health records.'**
  String get vaultVaccineNeeded;

  /// No description provided for @vaultTrackInsurance.
  ///
  /// In en, this message translates to:
  /// **'Track this policy in insurance'**
  String get vaultTrackInsurance;

  /// No description provided for @vaultExpiryReminderNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you 30 days before it expires.'**
  String get vaultExpiryReminderNote;

  /// No description provided for @vaultSaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vaultSaveDetails;

  /// No description provided for @vaultSkipDetails.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get vaultSkipDetails;

  /// No description provided for @vaultSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to the vault'**
  String get vaultSaved;

  /// No description provided for @vaultSavedVaccine.
  ///
  /// In en, this message translates to:
  /// **'{vaccine} recorded for {pet}'**
  String vaultSavedVaccine(String vaccine, String pet);

  /// No description provided for @vaultReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} for {pet} expires soon'**
  String vaultReminderTitle(String title, String pet);

  /// No description provided for @vaultTitleVaccineCert.
  ///
  /// In en, this message translates to:
  /// **'{vaccine} certificate'**
  String vaultTitleVaccineCert(String vaccine);

  /// No description provided for @vaultTitlePolicy.
  ///
  /// In en, this message translates to:
  /// **'{insurer} policy'**
  String vaultTitlePolicy(String insurer);

  /// No description provided for @vaultDocDetails.
  ///
  /// In en, this message translates to:
  /// **'Document details'**
  String get vaultDocDetails;

  /// No description provided for @vaultDetailsRead.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get vaultDetailsRead;

  /// No description provided for @vaultEditDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get vaultEditDetails;

  /// No description provided for @vaultConfirmedBy.
  ///
  /// In en, this message translates to:
  /// **'Checked by {name} on {date}'**
  String vaultConfirmedBy(String name, String date);

  /// No description provided for @vaultFieldPetName.
  ///
  /// In en, this message translates to:
  /// **'Pet\'s name'**
  String get vaultFieldPetName;

  /// No description provided for @vaultFieldIssuedOn.
  ///
  /// In en, this message translates to:
  /// **'Issued on'**
  String get vaultFieldIssuedOn;

  /// No description provided for @vaultFieldExpiry.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get vaultFieldExpiry;

  /// No description provided for @vaultFieldIssuer.
  ///
  /// In en, this message translates to:
  /// **'Issued by'**
  String get vaultFieldIssuer;

  /// No description provided for @vaultFieldVetReg.
  ///
  /// In en, this message translates to:
  /// **'Vet reg. no.'**
  String get vaultFieldVetReg;

  /// No description provided for @vaultFieldReference.
  ///
  /// In en, this message translates to:
  /// **'Reference no.'**
  String get vaultFieldReference;

  /// No description provided for @vaultFieldTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get vaultFieldTest;

  /// No description provided for @vaultFieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get vaultFieldAmount;

  /// No description provided for @vaultFileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get vaultFileType;

  /// No description provided for @vaultFileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get vaultFileSize;

  /// No description provided for @vaultAddedLabel.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get vaultAddedLabel;

  /// No description provided for @vaultPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get vaultPdf;

  /// No description provided for @vaultPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get vaultPhoto;

  /// No description provided for @vaultSample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get vaultSample;

  /// No description provided for @vaultTapToZoom.
  ///
  /// In en, this message translates to:
  /// **'Tap to zoom'**
  String get vaultTapToZoom;

  /// No description provided for @vaultSecureNote.
  ///
  /// In en, this message translates to:
  /// **'Stored privately in your account. Only you and the people you share a link with can see it.'**
  String get vaultSecureNote;

  /// No description provided for @vaultLinkedVaccine.
  ///
  /// In en, this message translates to:
  /// **'Linked to {pet}\'s vaccine record'**
  String vaultLinkedVaccine(String pet);

  /// No description provided for @vaultOpenInApp.
  ///
  /// In en, this message translates to:
  /// **'Open in PawSetu'**
  String get vaultOpenInApp;

  /// No description provided for @vaultOpenPolicy.
  ///
  /// In en, this message translates to:
  /// **'Open policy'**
  String get vaultOpenPolicy;

  /// No description provided for @vaultTrackPolicy.
  ///
  /// In en, this message translates to:
  /// **'Track in insurance'**
  String get vaultTrackPolicy;

  /// No description provided for @vaultShareWithVet.
  ///
  /// In en, this message translates to:
  /// **'Share with a vet'**
  String get vaultShareWithVet;

  /// No description provided for @vaultDeleteDoc.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get vaultDeleteDoc;

  /// No description provided for @vaultDeleteDocQ.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String vaultDeleteDocQ(String title);

  /// No description provided for @vaultDeleteDocBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from {pet}\'s vault, and share links to it will stop working.'**
  String vaultDeleteDocBody(String pet);

  /// No description provided for @vaultDeleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get vaultDeleted;

  /// No description provided for @vaultShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with a vet'**
  String get vaultShareTitle;

  /// No description provided for @vaultShareBody.
  ///
  /// In en, this message translates to:
  /// **'Create a link that opens only the documents you choose, for a limited time.'**
  String get vaultShareBody;

  /// No description provided for @vaultChooseDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents to share'**
  String get vaultChooseDocs;

  /// No description provided for @vaultSelectOneDoc.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one document.'**
  String get vaultSelectOneDoc;

  /// No description provided for @vaultLinkValidFor.
  ///
  /// In en, this message translates to:
  /// **'Link works for'**
  String get vaultLinkValidFor;

  /// No description provided for @vaultExpiry1h.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get vaultExpiry1h;

  /// No description provided for @vaultExpiry24h.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get vaultExpiry24h;

  /// No description provided for @vaultExpiry7d.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get vaultExpiry7d;

  /// No description provided for @vaultExpiryNever.
  ///
  /// In en, this message translates to:
  /// **'Until I stop it'**
  String get vaultExpiryNever;

  /// No description provided for @vaultAddPin.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN'**
  String get vaultAddPin;

  /// No description provided for @vaultAddPinHint.
  ///
  /// In en, this message translates to:
  /// **'The vet enters this 4 to 6 digit PIN to open the link.'**
  String get vaultAddPinHint;

  /// No description provided for @vaultPinFormat.
  ///
  /// In en, this message translates to:
  /// **'The PIN must be 4 to 6 digits.'**
  String get vaultPinFormat;

  /// No description provided for @vaultCreateLink.
  ///
  /// In en, this message translates to:
  /// **'Create link'**
  String get vaultCreateLink;

  /// No description provided for @vaultLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Link ready'**
  String get vaultLinkReady;

  /// No description provided for @vaultLinkPinIs.
  ///
  /// In en, this message translates to:
  /// **'PIN: {pin}'**
  String vaultLinkPinIs(String pin);

  /// No description provided for @vaultSendTo.
  ///
  /// In en, this message translates to:
  /// **'Send the link'**
  String get vaultSendTo;

  /// No description provided for @vaultSendPhoneTo.
  ///
  /// In en, this message translates to:
  /// **'Vet\'s phone number'**
  String get vaultSendPhoneTo;

  /// No description provided for @vaultSendEmailTo.
  ///
  /// In en, this message translates to:
  /// **'Vet\'s email'**
  String get vaultSendEmailTo;

  /// No description provided for @vaultSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get vaultSend;

  /// No description provided for @vaultSentTo.
  ///
  /// In en, this message translates to:
  /// **'Link sent to {target} (demo: in the Demo Outbox)'**
  String vaultSentTo(String target);

  /// No description provided for @vaultShareCopiedInstead.
  ///
  /// In en, this message translates to:
  /// **'Link copied. Paste it into any app.'**
  String get vaultShareCopiedInstead;

  /// No description provided for @vaultShareEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Pet health documents from PawSetu'**
  String get vaultShareEmailSubject;

  /// No description provided for @vaultShareText.
  ///
  /// In en, this message translates to:
  /// **'{name} shared {pet}\'s health documents with you on PawSetu: {url}'**
  String vaultShareText(String name, String pet, String url);

  /// No description provided for @vaultShareLinks.
  ///
  /// In en, this message translates to:
  /// **'Share links'**
  String get vaultShareLinks;

  /// No description provided for @vaultLinksNote.
  ///
  /// In en, this message translates to:
  /// **'Links open only the documents you chose and stop working when they expire or when you stop them.'**
  String get vaultLinksNote;

  /// No description provided for @vaultLinksOld.
  ///
  /// In en, this message translates to:
  /// **'Expired and stopped'**
  String get vaultLinksOld;

  /// No description provided for @vaultNoLinks.
  ///
  /// In en, this message translates to:
  /// **'No share links yet'**
  String get vaultNoLinks;

  /// No description provided for @vaultNoLinksBody.
  ///
  /// In en, this message translates to:
  /// **'Share documents with a vet from any document in the vault.'**
  String get vaultNoLinksBody;

  /// No description provided for @vaultLinkActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vaultLinkActive;

  /// No description provided for @vaultLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get vaultLinkExpired;

  /// No description provided for @vaultLinkRevoked.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get vaultLinkRevoked;

  /// No description provided for @vaultLinkDocs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 document} other{{count} documents}}'**
  String vaultLinkDocs(int count);

  /// No description provided for @vaultLinkAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album link'**
  String get vaultLinkAlbum;

  /// No description provided for @vaultLinkWorksUntil.
  ///
  /// In en, this message translates to:
  /// **'Works until {when}'**
  String vaultLinkWorksUntil(String when);

  /// No description provided for @vaultLinkNoEnd.
  ///
  /// In en, this message translates to:
  /// **'Works until you stop it'**
  String get vaultLinkNoEnd;

  /// No description provided for @vaultLinkOpened.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not opened yet} =1{Opened once} other{Opened {count} times}}'**
  String vaultLinkOpened(int count);

  /// No description provided for @vaultHasPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get vaultHasPin;

  /// No description provided for @vaultCreatedOn.
  ///
  /// In en, this message translates to:
  /// **'Created {when}'**
  String vaultCreatedOn(String when);

  /// No description provided for @vaultRevokedOn.
  ///
  /// In en, this message translates to:
  /// **'Stopped {when}'**
  String vaultRevokedOn(String when);

  /// No description provided for @vaultAccessLog.
  ///
  /// In en, this message translates to:
  /// **'Access log'**
  String get vaultAccessLog;

  /// No description provided for @vaultNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Nobody has opened this link yet.'**
  String get vaultNoAccess;

  /// No description provided for @vaultAccessOk.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get vaultAccessOk;

  /// No description provided for @vaultAccessWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN tried'**
  String get vaultAccessWrongPin;

  /// No description provided for @vaultRevoke.
  ///
  /// In en, this message translates to:
  /// **'Stop link'**
  String get vaultRevoke;

  /// No description provided for @vaultRevokeQ.
  ///
  /// In en, this message translates to:
  /// **'Stop this link?'**
  String get vaultRevokeQ;

  /// No description provided for @vaultRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone who opens it will see that it no longer works. Your documents stay in the vault.'**
  String get vaultRevokeBody;

  /// No description provided for @vaultRevoked.
  ///
  /// In en, this message translates to:
  /// **'Link stopped'**
  String get vaultRevoked;

  /// No description provided for @vaultSharedBy.
  ///
  /// In en, this message translates to:
  /// **'{owner} shared {pet}\'s documents'**
  String vaultSharedBy(String owner, String pet);

  /// No description provided for @vaultSharedUntil.
  ///
  /// In en, this message translates to:
  /// **'Available until {when}'**
  String vaultSharedUntil(String when);

  /// No description provided for @vaultViewOnly.
  ///
  /// In en, this message translates to:
  /// **'View only'**
  String get vaultViewOnly;

  /// No description provided for @vaultNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No documents in this link'**
  String get vaultNoMatches;

  /// No description provided for @vaultSharedFooter.
  ///
  /// In en, this message translates to:
  /// **'Shared securely with PawSetu. The pet parent can stop this link at any time.'**
  String get vaultSharedFooter;

  /// No description provided for @vaultGetPawSetu.
  ///
  /// In en, this message translates to:
  /// **'Get PawSetu'**
  String get vaultGetPawSetu;

  /// No description provided for @vaultEnterSharePin.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN'**
  String get vaultEnterSharePin;

  /// No description provided for @vaultEnterSharePinBody.
  ///
  /// In en, this message translates to:
  /// **'{owner} protected these documents with a PIN. Ask them for it.'**
  String vaultEnterSharePinBody(String owner);

  /// No description provided for @vaultLinkPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get vaultLinkPin;

  /// No description provided for @vaultOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get vaultOpenLink;

  /// No description provided for @vaultShareWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Please try again.'**
  String get vaultShareWrongPin;

  /// No description provided for @vaultShareLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong tries. Try again in 15 minutes.'**
  String get vaultShareLocked;

  /// No description provided for @vaultLinkStopped.
  ///
  /// In en, this message translates to:
  /// **'This link isn\'t available'**
  String get vaultLinkStopped;

  /// No description provided for @vaultLinkExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'It expired on {when}. Ask the pet parent for a new link.'**
  String vaultLinkExpiredBody(String when);

  /// No description provided for @vaultLinkRevokedBody.
  ///
  /// In en, this message translates to:
  /// **'The pet parent stopped this link. Ask them for a new one.'**
  String get vaultLinkRevokedBody;

  /// No description provided for @vaultLinkNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check that the link was copied completely.'**
  String get vaultLinkNotFoundBody;

  /// No description provided for @vaultInsuranceTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet insurance'**
  String get vaultInsuranceTitle;

  /// No description provided for @vaultInsuranceNote.
  ///
  /// In en, this message translates to:
  /// **'PawSetu doesn\'t sell insurance. Track your policy, renewals and claims here.'**
  String get vaultInsuranceNote;

  /// No description provided for @vaultNoPolicies.
  ///
  /// In en, this message translates to:
  /// **'No policies yet'**
  String get vaultNoPolicies;

  /// No description provided for @vaultNoPoliciesBody.
  ///
  /// In en, this message translates to:
  /// **'Add your pet\'s insurance to track cover, renewal dates and claims.'**
  String get vaultNoPoliciesBody;

  /// No description provided for @vaultAddPolicy.
  ///
  /// In en, this message translates to:
  /// **'Add policy'**
  String get vaultAddPolicy;

  /// No description provided for @vaultEditPolicy.
  ///
  /// In en, this message translates to:
  /// **'Edit policy'**
  String get vaultEditPolicy;

  /// No description provided for @vaultPolicyFor.
  ///
  /// In en, this message translates to:
  /// **'Policy for {pet}'**
  String vaultPolicyFor(String pet);

  /// No description provided for @vaultFieldInsurer.
  ///
  /// In en, this message translates to:
  /// **'Insurance company'**
  String get vaultFieldInsurer;

  /// No description provided for @vaultPlanName.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get vaultPlanName;

  /// No description provided for @vaultFieldPolicyNo.
  ///
  /// In en, this message translates to:
  /// **'Policy number'**
  String get vaultFieldPolicyNo;

  /// No description provided for @vaultFieldCover.
  ///
  /// In en, this message translates to:
  /// **'Sum insured (₹)'**
  String get vaultFieldCover;

  /// No description provided for @vaultFieldPremium.
  ///
  /// In en, this message translates to:
  /// **'Yearly premium (₹)'**
  String get vaultFieldPremium;

  /// No description provided for @vaultFieldCoverStart.
  ///
  /// In en, this message translates to:
  /// **'Cover starts'**
  String get vaultFieldCoverStart;

  /// No description provided for @vaultFieldRenewal.
  ///
  /// In en, this message translates to:
  /// **'Renewal date'**
  String get vaultFieldRenewal;

  /// No description provided for @vaultRenewalReminderNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you 30 days before renewal.'**
  String get vaultRenewalReminderNote;

  /// No description provided for @vaultInsuranceReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s insurance renews soon'**
  String vaultInsuranceReminderTitle(String pet);

  /// No description provided for @vaultPolicyDoc.
  ///
  /// In en, this message translates to:
  /// **'Policy document'**
  String get vaultPolicyDoc;

  /// No description provided for @vaultLinkDoc.
  ///
  /// In en, this message translates to:
  /// **'Link the policy document from the vault'**
  String get vaultLinkDoc;

  /// No description provided for @vaultNoDocLinked.
  ///
  /// In en, this message translates to:
  /// **'No document linked'**
  String get vaultNoDocLinked;

  /// No description provided for @vaultAttachDoc.
  ///
  /// In en, this message translates to:
  /// **'Attach from vault'**
  String get vaultAttachDoc;

  /// No description provided for @vaultAttached.
  ///
  /// In en, this message translates to:
  /// **'Attached: {title}'**
  String vaultAttached(String title);

  /// No description provided for @vaultDocMissing.
  ///
  /// In en, this message translates to:
  /// **'This policy is no longer available.'**
  String get vaultDocMissing;

  /// No description provided for @vaultCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get vaultCover;

  /// No description provided for @vaultCoverLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} cover left this year'**
  String vaultCoverLeft(String amount);

  /// No description provided for @vaultPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get vaultPremium;

  /// No description provided for @vaultPremiumYear.
  ///
  /// In en, this message translates to:
  /// **'{amount} a year'**
  String vaultPremiumYear(String amount);

  /// No description provided for @vaultPolicyActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vaultPolicyActive;

  /// No description provided for @vaultPolicyLapsed.
  ///
  /// In en, this message translates to:
  /// **'Lapsed'**
  String get vaultPolicyLapsed;

  /// No description provided for @vaultRenewSoon.
  ///
  /// In en, this message translates to:
  /// **'Renew soon'**
  String get vaultRenewSoon;

  /// No description provided for @vaultDeletePolicyQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this policy?'**
  String get vaultDeletePolicyQ;

  /// No description provided for @vaultDeletePolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Its claims are removed too. The policy document stays in the vault.'**
  String get vaultDeletePolicyBody;

  /// No description provided for @vaultClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get vaultClaims;

  /// No description provided for @vaultOpenClaims.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 open} other{{count} open}}'**
  String vaultOpenClaims(int count);

  /// No description provided for @vaultNoClaims.
  ///
  /// In en, this message translates to:
  /// **'No claims yet'**
  String get vaultNoClaims;

  /// No description provided for @vaultNewClaim.
  ///
  /// In en, this message translates to:
  /// **'New claim'**
  String get vaultNewClaim;

  /// No description provided for @vaultClaimFor.
  ///
  /// In en, this message translates to:
  /// **'What is the claim for?'**
  String get vaultClaimFor;

  /// No description provided for @vaultClaimForHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Bruno\'s leg X-ray and treatment'**
  String get vaultClaimForHint;

  /// No description provided for @vaultClaimAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount claimed'**
  String get vaultClaimAmount;

  /// No description provided for @vaultClaimDate.
  ///
  /// In en, this message translates to:
  /// **'Treatment date'**
  String get vaultClaimDate;

  /// No description provided for @vaultClaimChecklist.
  ///
  /// In en, this message translates to:
  /// **'Documents checklist'**
  String get vaultClaimChecklist;

  /// No description provided for @vaultChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} ready'**
  String vaultChecklistProgress(int done, int total);

  /// No description provided for @vaultCkClaimForm.
  ///
  /// In en, this message translates to:
  /// **'Filled claim form'**
  String get vaultCkClaimForm;

  /// No description provided for @vaultCkVetBills.
  ///
  /// In en, this message translates to:
  /// **'Vet bills and receipts'**
  String get vaultCkVetBills;

  /// No description provided for @vaultCkPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get vaultCkPrescription;

  /// No description provided for @vaultCkLabReports.
  ///
  /// In en, this message translates to:
  /// **'Lab or X-ray reports'**
  String get vaultCkLabReports;

  /// No description provided for @vaultCkPolicyCopy.
  ///
  /// In en, this message translates to:
  /// **'Policy copy'**
  String get vaultCkPolicyCopy;

  /// No description provided for @vaultCkPetPhoto.
  ///
  /// In en, this message translates to:
  /// **'Recent photo of your pet'**
  String get vaultCkPetPhoto;

  /// No description provided for @vaultCkIdProof.
  ///
  /// In en, this message translates to:
  /// **'Your ID proof'**
  String get vaultCkIdProof;

  /// No description provided for @vaultReadyToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Tick every document in the checklist before submitting.'**
  String get vaultReadyToSubmit;

  /// No description provided for @vaultMarkAs.
  ///
  /// In en, this message translates to:
  /// **'Mark as {status}'**
  String vaultMarkAs(String status);

  /// No description provided for @vaultClaimDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get vaultClaimDraft;

  /// No description provided for @vaultClaimSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get vaultClaimSubmitted;

  /// No description provided for @vaultClaimInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get vaultClaimInReview;

  /// No description provided for @vaultClaimApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get vaultClaimApproved;

  /// No description provided for @vaultClaimRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get vaultClaimRejected;

  /// No description provided for @vaultClaimPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get vaultClaimPaid;

  /// No description provided for @vaultClaimedAmount.
  ///
  /// In en, this message translates to:
  /// **'Claimed {amount}'**
  String vaultClaimedAmount(String amount);

  /// No description provided for @vaultPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid {amount}'**
  String vaultPaidAmount(String amount);

  /// No description provided for @vaultSettledAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid by insurer'**
  String get vaultSettledAmount;

  /// No description provided for @vaultClaimSaved.
  ///
  /// In en, this message translates to:
  /// **'Claim saved'**
  String get vaultClaimSaved;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTreats.
  ///
  /// In en, this message translates to:
  /// **'Treats'**
  String get catTreats;

  /// No description provided for @catToys.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get catToys;

  /// No description provided for @catGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get catGrooming;

  /// No description provided for @catHealthHygiene.
  ///
  /// In en, this message translates to:
  /// **'Health and hygiene'**
  String get catHealthHygiene;

  /// No description provided for @catBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get catBeds;

  /// No description provided for @catCollars.
  ///
  /// In en, this message translates to:
  /// **'Collars and leashes'**
  String get catCollars;

  /// No description provided for @catBowls.
  ///
  /// In en, this message translates to:
  /// **'Bowls and feeders'**
  String get catBowls;

  /// No description provided for @catLitter.
  ///
  /// In en, this message translates to:
  /// **'Litter and cat care'**
  String get catLitter;

  /// No description provided for @catBird.
  ///
  /// In en, this message translates to:
  /// **'Bird food and cages'**
  String get catBird;

  /// No description provided for @catRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit hay and care'**
  String get catRabbit;

  /// No description provided for @catClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get catClothing;

  /// No description provided for @catTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get catTravel;

  /// No description provided for @shopStageYoung.
  ///
  /// In en, this message translates to:
  /// **'Puppy / kitten'**
  String get shopStageYoung;

  /// No description provided for @shopStageAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get shopStageAdult;

  /// No description provided for @shopStageSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get shopStageSenior;

  /// No description provided for @shopStageAll.
  ///
  /// In en, this message translates to:
  /// **'All ages'**
  String get shopStageAll;

  /// No description provided for @shopSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small breeds'**
  String get shopSizeSmall;

  /// No description provided for @shopSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium breeds'**
  String get shopSizeMedium;

  /// No description provided for @shopSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large breeds'**
  String get shopSizeLarge;

  /// No description provided for @shopSizeGiant.
  ///
  /// In en, this message translates to:
  /// **'Giant breeds'**
  String get shopSizeGiant;

  /// No description provided for @shopSizeAll.
  ///
  /// In en, this message translates to:
  /// **'All sizes'**
  String get shopSizeAll;

  /// No description provided for @sortPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get sortPopular;

  /// No description provided for @sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceHigh;

  /// No description provided for @sortDiscount.
  ///
  /// In en, this message translates to:
  /// **'Biggest discount'**
  String get sortDiscount;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @shopSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search food, toys, beds…'**
  String get shopSearchHint;

  /// No description provided for @shopSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get shopSearchTitle;

  /// No description provided for @shopClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get shopClearSearch;

  /// No description provided for @shopForPet.
  ///
  /// In en, this message translates to:
  /// **'For {pet}'**
  String shopForPet(String pet);

  /// No description provided for @shopAvoiding.
  ///
  /// In en, this message translates to:
  /// **'Avoiding: {items}'**
  String shopAvoiding(String items);

  /// No description provided for @shopNoPicks.
  ///
  /// In en, this message translates to:
  /// **'No picks yet. Try searching the shop.'**
  String get shopNoPicks;

  /// No description provided for @shopBuyAgain.
  ///
  /// In en, this message translates to:
  /// **'Buy again'**
  String get shopBuyAgain;

  /// No description provided for @shopReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get shopReorder;

  /// No description provided for @shopReorderPrice.
  ///
  /// In en, this message translates to:
  /// **'Reorder · {price}'**
  String shopReorderPrice(String price);

  /// No description provided for @shopCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get shopCategories;

  /// No description provided for @shopDeals.
  ///
  /// In en, this message translates to:
  /// **'Deals'**
  String get shopDeals;

  /// No description provided for @shopPartnerStores.
  ///
  /// In en, this message translates to:
  /// **'Partner stores'**
  String get shopPartnerStores;

  /// No description provided for @shopPartnerStoresNote.
  ///
  /// In en, this message translates to:
  /// **'You buy these on the partner\'s own website. PawSetu may earn a small commission.'**
  String get shopPartnerStoresNote;

  /// No description provided for @shopListings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String shopListings(int count);

  /// No description provided for @shopPlusDeliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Plus members get free delivery above {amount}.'**
  String shopPlusDeliveryNote(String amount);

  /// No description provided for @shopPartnerStore.
  ///
  /// In en, this message translates to:
  /// **'Partner store'**
  String get shopPartnerStore;

  /// No description provided for @shopSoldOn.
  ///
  /// In en, this message translates to:
  /// **'On {store}'**
  String shopSoldOn(String store);

  /// No description provided for @shopOffPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String shopOffPercent(int percent);

  /// No description provided for @shopPriceSemantics.
  ///
  /// In en, this message translates to:
  /// **'{price}, was {mrp}, {percent}% off'**
  String shopPriceSemantics(String price, String mrp, int percent);

  /// No description provided for @shopRatingSemantics.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 5 by {count} people'**
  String shopRatingSemantics(String rating, int count);

  /// No description provided for @shopNoReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get shopNoReviewsYet;

  /// No description provided for @shopOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get shopOutOfStock;

  /// No description provided for @shopInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get shopInStock;

  /// No description provided for @shopOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left'**
  String shopOnlyLeft(int count);

  /// No description provided for @shopResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No products} =1{1 product} other{{count} products}}'**
  String shopResults(int count);

  /// No description provided for @shopFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String shopFiltersCount(int count);

  /// No description provided for @shopNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get shopNoResults;

  /// No description provided for @shopNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try another word or clear the filters.'**
  String get shopNoResultsBody;

  /// No description provided for @shopClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get shopClearFilters;

  /// No description provided for @shopCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get shopCategory;

  /// No description provided for @shopPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get shopPrice;

  /// No description provided for @shopMinPrice.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get shopMinPrice;

  /// No description provided for @shopMaxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get shopMaxPrice;

  /// No description provided for @shopBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get shopBrand;

  /// No description provided for @shopRatingAtLeast.
  ///
  /// In en, this message translates to:
  /// **'{rating}★ and up'**
  String shopRatingAtLeast(String rating);

  /// No description provided for @shopHidePartner.
  ///
  /// In en, this message translates to:
  /// **'Hide partner-store listings'**
  String get shopHidePartner;

  /// No description provided for @shopHidePartnerHint.
  ///
  /// In en, this message translates to:
  /// **'Show only products you can buy in PawSetu'**
  String get shopHidePartnerHint;

  /// No description provided for @shopShowResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get shopShowResults;

  /// No description provided for @shopProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get shopProduct;

  /// No description provided for @shopProductGone.
  ///
  /// In en, this message translates to:
  /// **'This product is no longer available'**
  String get shopProductGone;

  /// No description provided for @shopShareText.
  ///
  /// In en, this message translates to:
  /// **'{name} for {price} on PawSetu'**
  String shopShareText(String name, String price);

  /// No description provided for @shopInclTaxes.
  ///
  /// In en, this message translates to:
  /// **'Inclusive of all taxes'**
  String get shopInclTaxes;

  /// No description provided for @shopAffiliateNote.
  ///
  /// In en, this message translates to:
  /// **'You will buy this on {store}. PawSetu may earn a small commission; the price is the same for you.'**
  String shopAffiliateNote(String store);

  /// No description provided for @shopSoldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by {seller}, {city}'**
  String shopSoldBy(String seller, String city);

  /// No description provided for @shopSuitableFor.
  ///
  /// In en, this message translates to:
  /// **'Suitable for'**
  String get shopSuitableFor;

  /// No description provided for @shopCheckDelivery.
  ///
  /// In en, this message translates to:
  /// **'Check delivery'**
  String get shopCheckDelivery;

  /// No description provided for @shopEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter a PIN code to see the delivery date'**
  String get shopEnterPin;

  /// No description provided for @shopDeliveryBetween.
  ///
  /// In en, this message translates to:
  /// **'Delivery {from} – {to}'**
  String shopDeliveryBetween(String from, String to);

  /// No description provided for @shopReturnable.
  ///
  /// In en, this message translates to:
  /// **'Easy returns within {days} days of delivery'**
  String shopReturnable(int days);

  /// No description provided for @shopNotReturnable.
  ///
  /// In en, this message translates to:
  /// **'Food and treats can\'t be returned once delivered'**
  String get shopNotReturnable;

  /// No description provided for @shopAbout.
  ///
  /// In en, this message translates to:
  /// **'About this product'**
  String get shopAbout;

  /// No description provided for @shopPackSize.
  ///
  /// In en, this message translates to:
  /// **'Pack size'**
  String get shopPackSize;

  /// No description provided for @shopIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get shopIngredients;

  /// No description provided for @shopReturnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return policy'**
  String get shopReturnPolicy;

  /// No description provided for @shopVerifiedBuyer.
  ///
  /// In en, this message translates to:
  /// **'Verified buyer'**
  String get shopVerifiedBuyer;

  /// No description provided for @shopSellerReplied.
  ///
  /// In en, this message translates to:
  /// **'Seller: {reply}'**
  String shopSellerReplied(String reply);

  /// No description provided for @shopBuyOn.
  ///
  /// In en, this message translates to:
  /// **'Buy on {store}'**
  String shopBuyOn(String store);

  /// No description provided for @shopAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get shopAddToCart;

  /// No description provided for @shopBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get shopBuyNow;

  /// No description provided for @shopAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get shopAddedToCart;

  /// No description provided for @shopViewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get shopViewCart;

  /// No description provided for @shopLeavingTitle.
  ///
  /// In en, this message translates to:
  /// **'You will buy on {store}'**
  String shopLeavingTitle(String store);

  /// No description provided for @shopLeavingBody.
  ///
  /// In en, this message translates to:
  /// **'We will open {store} in your browser. Payment, delivery and returns are handled by {store}. PawSetu may earn a small commission.'**
  String shopLeavingBody(String store);

  /// No description provided for @shopContinueTo.
  ///
  /// In en, this message translates to:
  /// **'Go to {store}'**
  String shopContinueTo(String store);

  /// No description provided for @shopCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get shopCart;

  /// No description provided for @shopCartWithCount.
  ///
  /// In en, this message translates to:
  /// **'Cart, {count} items'**
  String shopCartWithCount(int count);

  /// No description provided for @shopQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get shopQuantity;

  /// No description provided for @shopQtySemantics.
  ///
  /// In en, this message translates to:
  /// **'Quantity {count}'**
  String shopQtySemantics(int count);

  /// No description provided for @shopQtyShort.
  ///
  /// In en, this message translates to:
  /// **'Qty {count}'**
  String shopQtyShort(int count);

  /// No description provided for @shopLessOf.
  ///
  /// In en, this message translates to:
  /// **'One less {item}'**
  String shopLessOf(String item);

  /// No description provided for @shopMoreOf.
  ///
  /// In en, this message translates to:
  /// **'One more {item}'**
  String shopMoreOf(String item);

  /// No description provided for @shopRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove {item}'**
  String shopRemoveItem(String item);

  /// No description provided for @shopStars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String shopStars(int count);

  /// No description provided for @shopReviewText.
  ///
  /// In en, this message translates to:
  /// **'What did you think? (optional)'**
  String get shopReviewText;

  /// No description provided for @shopPostReview.
  ///
  /// In en, this message translates to:
  /// **'Post review'**
  String get shopPostReview;

  /// No description provided for @shopThanksReview.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your review!'**
  String get shopThanksReview;

  /// No description provided for @shopRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get shopRate;

  /// No description provided for @shopForWhichPet.
  ///
  /// In en, this message translates to:
  /// **'For which pet?'**
  String get shopForWhichPet;

  /// No description provided for @shopReorderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get shopReorderTitle;

  /// No description provided for @shopReorderFor.
  ///
  /// In en, this message translates to:
  /// **'Reorder for {pet}'**
  String shopReorderFor(String pet);

  /// No description provided for @shopDeliveryOn.
  ///
  /// In en, this message translates to:
  /// **'Delivery on {date}'**
  String shopDeliveryOn(String date);

  /// No description provided for @shopItemsTotal.
  ///
  /// In en, this message translates to:
  /// **'Items total'**
  String get shopItemsTotal;

  /// No description provided for @shopDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get shopDeliveryFee;

  /// No description provided for @shopFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get shopFree;

  /// No description provided for @shopToPay.
  ///
  /// In en, this message translates to:
  /// **'To pay'**
  String get shopToPay;

  /// No description provided for @shopPlaceOrderAmount.
  ///
  /// In en, this message translates to:
  /// **'Place order · {amount}'**
  String shopPlaceOrderAmount(String amount);

  /// No description provided for @shopOrderPlacedToast.
  ///
  /// In en, this message translates to:
  /// **'Order placed!'**
  String get shopOrderPlacedToast;

  /// No description provided for @shopOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t place the order. Please try again.'**
  String get shopOrderFailed;

  /// No description provided for @addrBook.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addrBook;

  /// No description provided for @addrAdd.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addrAdd;

  /// No description provided for @addrEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get addrEdit;

  /// No description provided for @addrAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a delivery address'**
  String get addrAddFirst;

  /// No description provided for @addrNone.
  ///
  /// In en, this message translates to:
  /// **'No addresses yet'**
  String get addrNone;

  /// No description provided for @addrNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Add your home address for faster checkout.'**
  String get addrNoneBody;

  /// No description provided for @addrDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this address?'**
  String get addrDeleteQ;

  /// No description provided for @addrChoose.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get addrChoose;

  /// No description provided for @addrHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get addrHome;

  /// No description provided for @addrWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get addrWork;

  /// No description provided for @addrOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get addrOther;

  /// No description provided for @addrName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get addrName;

  /// No description provided for @addrPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 10-digit mobile number'**
  String get addrPhoneInvalid;

  /// No description provided for @addrLine1.
  ///
  /// In en, this message translates to:
  /// **'House / flat and street'**
  String get addrLine1;

  /// No description provided for @addrLine2.
  ///
  /// In en, this message translates to:
  /// **'Landmark (optional)'**
  String get addrLine2;

  /// No description provided for @addrArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get addrArea;

  /// No description provided for @addrCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addrCity;

  /// No description provided for @addrPin.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get addrPin;

  /// No description provided for @addrPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit PIN code'**
  String get addrPinInvalid;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Food, toys and more for your pet are a tap away.'**
  String get cartEmptyBody;

  /// No description provided for @cartStartShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get cartStartShopping;

  /// No description provided for @cartSoldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by {seller}'**
  String cartSoldBy(String seller);

  /// No description provided for @cartSkipped.
  ///
  /// In en, this message translates to:
  /// **'These can\'t be ordered here right now'**
  String get cartSkipped;

  /// No description provided for @cartPartnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Buy this on the partner store'**
  String get cartPartnerOnly;

  /// No description provided for @cartPetHint.
  ///
  /// In en, this message translates to:
  /// **'Helps us track spending and food for this pet.'**
  String get cartPetHint;

  /// No description provided for @cartDeliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get cartDeliverTo;

  /// No description provided for @cartSlot.
  ///
  /// In en, this message translates to:
  /// **'Delivery slot'**
  String get cartSlot;

  /// No description provided for @cartCoupon.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get cartCoupon;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon code'**
  String get couponCode;

  /// No description provided for @couponApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get couponApply;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied'**
  String get couponApplied;

  /// No description provided for @couponSaved.
  ///
  /// In en, this message translates to:
  /// **'{code} applied: you save {amount}'**
  String couponSaved(String code, String amount);

  /// No description provided for @couponNotFound.
  ///
  /// In en, this message translates to:
  /// **'That coupon code isn\'t valid'**
  String get couponNotFound;

  /// No description provided for @couponExpired.
  ///
  /// In en, this message translates to:
  /// **'This coupon has expired'**
  String get couponExpired;

  /// No description provided for @couponMinOrder.
  ///
  /// In en, this message translates to:
  /// **'Add items worth ₹{amount} or more to use this coupon'**
  String couponMinOrder(int amount);

  /// No description provided for @couponUsedUp.
  ///
  /// In en, this message translates to:
  /// **'This coupon has been fully used'**
  String get couponUsedUp;

  /// No description provided for @cartPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get cartPayment;

  /// No description provided for @payOnlineDemo.
  ///
  /// In en, this message translates to:
  /// **'Pay online (demo)'**
  String get payOnlineDemo;

  /// No description provided for @payOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Pay on delivery'**
  String get payOnDelivery;

  /// No description provided for @cartBill.
  ///
  /// In en, this message translates to:
  /// **'Bill details'**
  String get cartBill;

  /// No description provided for @cartMrpTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Price (1 item)} other{Price ({count} items)}}'**
  String cartMrpTotal(int count);

  /// No description provided for @cartMrpDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount on MRP'**
  String get cartMrpDiscount;

  /// No description provided for @cartCouponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Coupon'**
  String get cartCouponDiscount;

  /// No description provided for @cartCouponDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon {code}'**
  String cartCouponDiscountCode(String code);

  /// No description provided for @cartAddForFree.
  ///
  /// In en, this message translates to:
  /// **'Add {amount} more for free delivery'**
  String cartAddForFree(String amount);

  /// No description provided for @cartPlusFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery with Plus'**
  String get cartPlusFreeDelivery;

  /// No description provided for @cartSplitNote.
  ///
  /// In en, this message translates to:
  /// **'Items come from {count} sellers, so you\'ll get {count} deliveries. You pay once.'**
  String cartSplitNote(int count);

  /// No description provided for @cartYouSave.
  ///
  /// In en, this message translates to:
  /// **'You save {amount}'**
  String cartYouSave(String amount);

  /// No description provided for @cartPay.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String cartPay(String amount);

  /// No description provided for @cartPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get cartPlaceOrder;

  /// No description provided for @cartPaymentFor.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{PawSetu order, 1 item} other{PawSetu order, {count} items}}'**
  String cartPaymentFor(int count);

  /// No description provided for @payFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Payment failed. Your cart is saved; please try again.'**
  String get payFailedTryAgain;

  /// No description provided for @payPaidOnline.
  ///
  /// In en, this message translates to:
  /// **'Paid online'**
  String get payPaidOnline;

  /// No description provided for @payPending.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get payPending;

  /// No description provided for @payRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get payRefunded;

  /// No description provided for @payPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Your payment is being confirmed. If it fails, you can pay again or pay on delivery.'**
  String get payPendingNote;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get payNow;

  /// No description provided for @ordMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get ordMyOrders;

  /// No description provided for @ordTabOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordTabOrders;

  /// No description provided for @ordNone.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordNone;

  /// No description provided for @ordPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get ordPlaced;

  /// No description provided for @ordPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get ordPacked;

  /// No description provided for @ordShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get ordShipped;

  /// No description provided for @ordOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get ordOutForDelivery;

  /// No description provided for @ordDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get ordDelivered;

  /// No description provided for @ordCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ordCancelled;

  /// No description provided for @ordReturnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return requested'**
  String get ordReturnRequested;

  /// No description provided for @ordReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get ordReturned;

  /// No description provided for @ordReturnRejected.
  ///
  /// In en, this message translates to:
  /// **'Return declined'**
  String get ordReturnRejected;

  /// No description provided for @ordItemsMore.
  ///
  /// In en, this message translates to:
  /// **'{name} +{count} more'**
  String ordItemsMore(String name, int count);

  /// No description provided for @ordArrivingBy.
  ///
  /// In en, this message translates to:
  /// **'Arriving by {date}'**
  String ordArrivingBy(String date);

  /// No description provided for @ordExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected {date}'**
  String ordExpected(String date);

  /// No description provided for @ordPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get ordPlacedTitle;

  /// No description provided for @ordPlacedHeading.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your order is placed.'**
  String get ordPlacedHeading;

  /// No description provided for @ordPlacedBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when it\'s on the way.'**
  String get ordPlacedBody;

  /// No description provided for @ordPlacedSplit.
  ///
  /// In en, this message translates to:
  /// **'It comes in {count} deliveries, one from each seller.'**
  String ordPlacedSplit(int count);

  /// No description provided for @ordTrack.
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get ordTrack;

  /// No description provided for @ordContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get ordContinueShopping;

  /// No description provided for @ordDetail.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get ordDetail;

  /// No description provided for @ordNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this order'**
  String get ordNotFound;

  /// No description provided for @ordNumber.
  ///
  /// In en, this message translates to:
  /// **'Order {number}'**
  String ordNumber(String number);

  /// No description provided for @ordPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String ordPlacedOn(String date);

  /// No description provided for @ordTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get ordTracking;

  /// No description provided for @ordItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String ordItems(int count);

  /// No description provided for @ordSlot.
  ///
  /// In en, this message translates to:
  /// **'Slot: {date}, {window}'**
  String ordSlot(String date, String window);

  /// No description provided for @ordForPet.
  ///
  /// In en, this message translates to:
  /// **'For {pet}'**
  String ordForPet(String pet);

  /// No description provided for @ordTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ordTotal;

  /// No description provided for @ordPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get ordPayment;

  /// No description provided for @ordInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice (PDF)'**
  String get ordInvoice;

  /// No description provided for @ordCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get ordCancel;

  /// No description provided for @ordReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get ordReturn;

  /// No description provided for @ordHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get ordHelp;

  /// No description provided for @ordReturnWindowOver.
  ///
  /// In en, this message translates to:
  /// **'The {days}-day return window has ended.'**
  String ordReturnWindowOver(int days);

  /// No description provided for @ordCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to cancel?'**
  String get ordCancelTitle;

  /// No description provided for @ordReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you returning it?'**
  String get ordReturnTitle;

  /// No description provided for @ordReasonChangedMind.
  ///
  /// In en, this message translates to:
  /// **'I changed my mind'**
  String get ordReasonChangedMind;

  /// No description provided for @ordReasonWrongItem.
  ///
  /// In en, this message translates to:
  /// **'Wrong item or size'**
  String get ordReasonWrongItem;

  /// No description provided for @ordReasonTooLate.
  ///
  /// In en, this message translates to:
  /// **'Delivery is too late'**
  String get ordReasonTooLate;

  /// No description provided for @ordReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'It arrived damaged'**
  String get ordReasonDamaged;

  /// No description provided for @ordReasonNotSuitable.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for my pet'**
  String get ordReasonNotSuitable;

  /// No description provided for @ordReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get ordReasonOther;

  /// No description provided for @ordCancelledToast.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get ordCancelledToast;

  /// No description provided for @ordCancelledRefund.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled. Your refund is on its way (demo).'**
  String get ordCancelledRefund;

  /// No description provided for @ordReturnRequestedToast.
  ///
  /// In en, this message translates to:
  /// **'Return requested. The seller will reply soon.'**
  String get ordReturnRequestedToast;

  /// No description provided for @ordReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String ordReason(String reason);

  /// No description provided for @ordStepDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get ordStepDone;

  /// No description provided for @invTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax invoice'**
  String get invTitle;

  /// No description provided for @invFooter.
  ///
  /// In en, this message translates to:
  /// **'PawSetu marketplace · This invoice is generated by the seller through PawSetu.'**
  String get invFooter;

  /// No description provided for @invSoldBy.
  ///
  /// In en, this message translates to:
  /// **'Sold by'**
  String get invSoldBy;

  /// No description provided for @invBillTo.
  ///
  /// In en, this message translates to:
  /// **'Bill to'**
  String get invBillTo;

  /// No description provided for @invGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN: {gstin}'**
  String invGstin(String gstin);

  /// No description provided for @invMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Sold through PawSetu marketplace'**
  String get invMarketplace;

  /// No description provided for @invOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get invOrder;

  /// No description provided for @invInvoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number}'**
  String invInvoiceNo(String number);

  /// No description provided for @invPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment: {method}'**
  String invPayment(String method);

  /// No description provided for @invItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get invItems;

  /// No description provided for @invItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get invItem;

  /// No description provided for @invQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get invQty;

  /// No description provided for @invPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get invPrice;

  /// No description provided for @invAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get invAmount;

  /// No description provided for @invTax.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get invTax;

  /// No description provided for @invTaxPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get invTaxPlaceholder;

  /// No description provided for @invDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo invoice: no money was charged and GST details are placeholders.'**
  String get invDemoNote;

  /// No description provided for @orderEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Your PawSetu order is placed'**
  String get orderEmailSubject;

  /// No description provided for @orderEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}, thank you for your order of {amount}. It should reach you by {date}.'**
  String orderEmailBody(String name, String amount, String date);

  /// No description provided for @subsTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-reorder'**
  String get subsTitle;

  /// No description provided for @subsHint.
  ///
  /// In en, this message translates to:
  /// **'Get this delivered every 2, 4 or 6 weeks. Pause or cancel anytime.'**
  String get subsHint;

  /// No description provided for @subsEvery.
  ///
  /// In en, this message translates to:
  /// **'Deliver every'**
  String get subsEvery;

  /// No description provided for @subsWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every week} other{Every {count} weeks}}'**
  String subsWeeks(int count);

  /// No description provided for @subsFirstOn.
  ///
  /// In en, this message translates to:
  /// **'First delivery around {date}, paid on delivery.'**
  String subsFirstOn(String date);

  /// No description provided for @subsStart.
  ///
  /// In en, this message translates to:
  /// **'Start auto-reorder'**
  String get subsStart;

  /// No description provided for @subsCreated.
  ///
  /// In en, this message translates to:
  /// **'Auto-reorder is on'**
  String get subsCreated;

  /// No description provided for @subsTab.
  ///
  /// In en, this message translates to:
  /// **'Auto-reorder'**
  String get subsTab;

  /// No description provided for @subsNone.
  ///
  /// In en, this message translates to:
  /// **'No auto-reorders'**
  String get subsNone;

  /// No description provided for @subsNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Set one up from any food page so you never run out.'**
  String get subsNoneBody;

  /// No description provided for @subsNext.
  ///
  /// In en, this message translates to:
  /// **'Next delivery {date}'**
  String subsNext(String date);

  /// No description provided for @subsPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get subsPaused;

  /// No description provided for @subsPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get subsPause;

  /// No description provided for @subsResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get subsResume;

  /// No description provided for @subsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get subsCancel;

  /// No description provided for @subsCancelQ.
  ///
  /// In en, this message translates to:
  /// **'Stop this auto-reorder?'**
  String get subsCancelQ;

  /// No description provided for @subsOrderedToast.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your auto-reorder was placed} other{{count} auto-reorders were placed}}'**
  String subsOrderedToast(int count);

  /// No description provided for @ntfNewOrder.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{New order: {item}} other{New order: {item} and more}}'**
  String ntfNewOrder(String item, int count);

  /// No description provided for @ntfOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order {number} was cancelled by the customer'**
  String ntfOrderCancelled(String number);

  /// No description provided for @ntfOrderCancelledBySeller.
  ///
  /// In en, this message translates to:
  /// **'Sorry, the seller cancelled your order for {item}. Any payment is refunded.'**
  String ntfOrderCancelledBySeller(String item);

  /// No description provided for @ntfOrderPacked.
  ///
  /// In en, this message translates to:
  /// **'{item} is packed'**
  String ntfOrderPacked(String item);

  /// No description provided for @ntfOrderShipped.
  ///
  /// In en, this message translates to:
  /// **'{item} is on the way'**
  String ntfOrderShipped(String item);

  /// No description provided for @ntfOrderOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'{item} is out for delivery today'**
  String ntfOrderOutForDelivery(String item);

  /// No description provided for @ntfOrderDelivered.
  ///
  /// In en, this message translates to:
  /// **'{item} was delivered'**
  String ntfOrderDelivered(String item);

  /// No description provided for @ntfOrderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your order for {item} was updated'**
  String ntfOrderUpdated(String item);

  /// No description provided for @ntfReturnAccepted.
  ///
  /// In en, this message translates to:
  /// **'Return accepted for {item}. Your refund is on its way.'**
  String ntfReturnAccepted(String item);

  /// No description provided for @ntfReturnRejected.
  ///
  /// In en, this message translates to:
  /// **'Return declined for {item}. Tap for help.'**
  String ntfReturnRejected(String item);

  /// No description provided for @ntfReturnRequested.
  ///
  /// In en, this message translates to:
  /// **'Return requested for order {number}'**
  String ntfReturnRequested(String number);

  /// No description provided for @ntfSubscriptionOrdered.
  ///
  /// In en, this message translates to:
  /// **'Auto-reorder placed: {item}'**
  String ntfSubscriptionOrdered(String item);

  /// No description provided for @foodRunsOutIn.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s food may run out in about {days, plural, =1{1 day} other{{days} days}}. Reorder?'**
  String foodRunsOutIn(String pet, int days);

  /// No description provided for @foodRanOut.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s food may have run out. Reorder?'**
  String foodRanOut(String pet);

  /// No description provided for @foodPortionLine.
  ///
  /// In en, this message translates to:
  /// **'{grams} g a day · {bag} bag'**
  String foodPortionLine(int grams, String bag);

  /// No description provided for @foodEditPortion.
  ///
  /// In en, this message translates to:
  /// **'Edit portion'**
  String get foodEditPortion;

  /// No description provided for @foodOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'New food for {pet} is on the way'**
  String foodOnTheWay(String pet);

  /// No description provided for @foodPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s food'**
  String foodPlanTitle(String pet);

  /// No description provided for @foodDailyPortion.
  ///
  /// In en, this message translates to:
  /// **'Daily portion'**
  String get foodDailyPortion;

  /// No description provided for @foodSuggested.
  ///
  /// In en, this message translates to:
  /// **'A starting point is {grams} g a day. Follow the pack or your vet.'**
  String foodSuggested(int grams);

  /// No description provided for @foodBagSize.
  ///
  /// In en, this message translates to:
  /// **'Bag size'**
  String get foodBagSize;

  /// No description provided for @foodOpenedOn.
  ///
  /// In en, this message translates to:
  /// **'Bag opened on'**
  String get foodOpenedOn;

  /// No description provided for @expAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expAdd;

  /// No description provided for @expEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get expEdit;

  /// No description provided for @expThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get expThisMonth;

  /// No description provided for @expLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get expLastMonth;

  /// No description provided for @expPeriodTotal.
  ///
  /// In en, this message translates to:
  /// **'Last {months} months'**
  String expPeriodTotal(int months);

  /// No description provided for @expByMonth.
  ///
  /// In en, this message translates to:
  /// **'Spending by month'**
  String get expByMonth;

  /// No description provided for @expMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String expMonths(int count);

  /// No description provided for @expByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get expByCategory;

  /// No description provided for @expChartSemantics.
  ///
  /// In en, this message translates to:
  /// **'Spending by month: {values}'**
  String expChartSemantics(String values);

  /// No description provided for @expNone.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get expNone;

  /// No description provided for @expNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Bookings and orders are added here automatically. You can add others too.'**
  String get expNoneBody;

  /// No description provided for @expVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get expVet;

  /// No description provided for @expGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get expGrooming;

  /// No description provided for @expTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get expTraining;

  /// No description provided for @expBoarding.
  ///
  /// In en, this message translates to:
  /// **'Boarding'**
  String get expBoarding;

  /// No description provided for @expWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get expWalking;

  /// No description provided for @expFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expFood;

  /// No description provided for @expSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get expSupplies;

  /// No description provided for @expInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get expInsurance;

  /// No description provided for @expOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expOther;

  /// No description provided for @expFromBooking.
  ///
  /// In en, this message translates to:
  /// **'from a booking'**
  String get expFromBooking;

  /// No description provided for @expFromOrder.
  ///
  /// In en, this message translates to:
  /// **'from an order'**
  String get expFromOrder;

  /// No description provided for @expFromTeleVet.
  ///
  /// In en, this message translates to:
  /// **'from tele-vet'**
  String get expFromTeleVet;

  /// No description provided for @expAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expAmount;

  /// No description provided for @expAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get expAmountInvalid;

  /// No description provided for @expCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expCategory;

  /// No description provided for @expForPet.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get expForPet;

  /// No description provided for @expAllPets.
  ///
  /// In en, this message translates to:
  /// **'All pets'**
  String get expAllPets;

  /// No description provided for @expNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get expNote;

  /// No description provided for @expNoteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: rabies booster, new collar'**
  String get expNoteHint;

  /// No description provided for @expSaved.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get expSaved;

  /// No description provided for @expDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this expense?'**
  String get expDeleteQ;

  /// No description provided for @selToPack.
  ///
  /// In en, this message translates to:
  /// **'Orders to pack'**
  String get selToPack;

  /// No description provided for @selOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get selOnTheWay;

  /// No description provided for @selLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get selLowStock;

  /// No description provided for @selReturnsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 return is waiting for you} other{{count} returns are waiting for you}}'**
  String selReturnsWaiting(int count);

  /// No description provided for @selNewOrders.
  ///
  /// In en, this message translates to:
  /// **'New orders'**
  String get selNewOrders;

  /// No description provided for @selNoNewOrders.
  ///
  /// In en, this message translates to:
  /// **'No new orders right now'**
  String get selNoNewOrders;

  /// No description provided for @selStockLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} in stock'**
  String selStockLeft(int count);

  /// No description provided for @selAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get selAddProduct;

  /// No description provided for @selEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get selEditProduct;

  /// No description provided for @selCsvUpload.
  ///
  /// In en, this message translates to:
  /// **'CSV bulk upload'**
  String get selCsvUpload;

  /// No description provided for @selSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search your products'**
  String get selSearchProducts;

  /// No description provided for @selProductCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String selProductCount(int count);

  /// No description provided for @selHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden from the shop'**
  String get selHidden;

  /// No description provided for @selProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get selProductName;

  /// No description provided for @selPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price'**
  String get selPrice;

  /// No description provided for @selMrp.
  ///
  /// In en, this message translates to:
  /// **'MRP'**
  String get selMrp;

  /// No description provided for @selPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a price'**
  String get selPriceInvalid;

  /// No description provided for @selMrpInvalid.
  ///
  /// In en, this message translates to:
  /// **'MRP can\'t be lower than the price'**
  String get selMrpInvalid;

  /// No description provided for @selStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get selStock;

  /// No description provided for @selPackKg.
  ///
  /// In en, this message translates to:
  /// **'Pack size in kg (food)'**
  String get selPackKg;

  /// No description provided for @selDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get selDescription;

  /// No description provided for @selVisible.
  ///
  /// In en, this message translates to:
  /// **'Show in the shop'**
  String get selVisible;

  /// No description provided for @selVisibleHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off to hide it without deleting'**
  String get selVisibleHint;

  /// No description provided for @selNoRxNote.
  ///
  /// In en, this message translates to:
  /// **'Prescription-only medicines can\'t be sold on PawSetu.'**
  String get selNoRxNote;

  /// No description provided for @selSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get selSaved;

  /// No description provided for @selCsvHelp.
  ///
  /// In en, this message translates to:
  /// **'Columns: {columns}. Species can be several, like dog|cat.'**
  String selCsvHelp(String columns);

  /// No description provided for @selCsvChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose CSV file'**
  String get selCsvChoose;

  /// No description provided for @selCsvSample.
  ///
  /// In en, this message translates to:
  /// **'Try the sample'**
  String get selCsvSample;

  /// No description provided for @selCsvCopyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Copy template'**
  String get selCsvCopyTemplate;

  /// No description provided for @selCsvCopied.
  ///
  /// In en, this message translates to:
  /// **'Template copied'**
  String get selCsvCopied;

  /// No description provided for @selCsvPaste.
  ///
  /// In en, this message translates to:
  /// **'Or paste CSV here'**
  String get selCsvPaste;

  /// No description provided for @selCsvPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview: {ok} ready, {bad} to fix'**
  String selCsvPreview(int ok, int bad);

  /// No description provided for @selCsvLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}'**
  String selCsvLine(int line);

  /// No description provided for @selCsvProblems.
  ///
  /// In en, this message translates to:
  /// **'Check: {fields}'**
  String selCsvProblems(String fields);

  /// No description provided for @selCsvImport.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 product} other{Add {count} products}}'**
  String selCsvImport(int count);

  /// No description provided for @selCsvImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product added} other{{count} products added}}'**
  String selCsvImported(int count);

  /// No description provided for @selTabNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get selTabNew;

  /// No description provided for @selTabPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get selTabPacked;

  /// No description provided for @selTabShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get selTabShipping;

  /// No description provided for @selTabDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get selTabDelivered;

  /// No description provided for @selTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled / returned'**
  String get selTabCancelled;

  /// No description provided for @selNoOrdersHere.
  ///
  /// In en, this message translates to:
  /// **'No orders here'**
  String get selNoOrdersHere;

  /// No description provided for @selReturnsOpen.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get selReturnsOpen;

  /// No description provided for @selReturnsDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get selReturnsDone;

  /// No description provided for @selNoReturns.
  ///
  /// In en, this message translates to:
  /// **'No returns'**
  String get selNoReturns;

  /// No description provided for @selAcceptReturn.
  ///
  /// In en, this message translates to:
  /// **'Accept return'**
  String get selAcceptReturn;

  /// No description provided for @selRejectReturn.
  ///
  /// In en, this message translates to:
  /// **'Decline return'**
  String get selRejectReturn;

  /// No description provided for @selPayoutDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo payouts: no real money moves.'**
  String get selPayoutDemo;

  /// No description provided for @selPayoutPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get selPayoutPending;

  /// No description provided for @selPayoutReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to pay'**
  String get selPayoutReady;

  /// No description provided for @selPayoutPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get selPayoutPaid;

  /// No description provided for @selPayoutOnHold.
  ///
  /// In en, this message translates to:
  /// **'In return window'**
  String get selPayoutOnHold;

  /// No description provided for @selCommissionPaid.
  ///
  /// In en, this message translates to:
  /// **'PawSetu commission'**
  String get selCommissionPaid;

  /// No description provided for @selRunPayout.
  ///
  /// In en, this message translates to:
  /// **'Pay out {amount} now (demo)'**
  String selRunPayout(String amount);

  /// No description provided for @selPayoutDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order paid out} other{{count} orders paid out}}'**
  String selPayoutDone(int count);

  /// No description provided for @selPayoutRule.
  ///
  /// In en, this message translates to:
  /// **'Payouts are made weekly once the {days}-day return window ends.'**
  String selPayoutRule(int days);

  /// No description provided for @selPayoutOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get selPayoutOrders;

  /// No description provided for @selPayoutLine.
  ///
  /// In en, this message translates to:
  /// **'Sales {gross} · commission {commission}'**
  String selPayoutLine(String gross, String commission);

  /// No description provided for @selReviewSummary.
  ///
  /// In en, this message translates to:
  /// **'★ {rating} from {count, plural, =1{1 review} other{{count} reviews}}'**
  String selReviewSummary(String rating, int count);

  /// No description provided for @selReplyText.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get selReplyText;

  /// No description provided for @selSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get selSendReply;

  /// No description provided for @selApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get selApproved;

  /// No description provided for @selKyc.
  ///
  /// In en, this message translates to:
  /// **'KYC documents'**
  String get selKyc;

  /// No description provided for @selVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get selVerified;

  /// No description provided for @selCancelQ.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get selCancelQ;

  /// No description provided for @selCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The customer is told and any payment is refunded.'**
  String get selCancelBody;

  /// No description provided for @selCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get selCancelOrder;

  /// No description provided for @selOutOfStockReason.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get selOutOfStockReason;

  /// No description provided for @selMarkPacked.
  ///
  /// In en, this message translates to:
  /// **'Mark packed'**
  String get selMarkPacked;

  /// No description provided for @selMarkShipped.
  ///
  /// In en, this message translates to:
  /// **'Mark shipped'**
  String get selMarkShipped;

  /// No description provided for @selMarkOut.
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get selMarkOut;

  /// No description provided for @selMarkDelivered.
  ///
  /// In en, this message translates to:
  /// **'Mark delivered'**
  String get selMarkDelivered;

  /// No description provided for @selCommission.
  ///
  /// In en, this message translates to:
  /// **'PawSetu commission'**
  String get selCommission;

  /// No description provided for @selYourPayout.
  ///
  /// In en, this message translates to:
  /// **'Your payout'**
  String get selYourPayout;

  /// No description provided for @selShipTo.
  ///
  /// In en, this message translates to:
  /// **'Ship to'**
  String get selShipTo;

  /// No description provided for @selPhoneHidden.
  ///
  /// In en, this message translates to:
  /// **'The customer\'s phone is hidden; the courier calls through PawSetu.'**
  String get selPhoneHidden;

  /// No description provided for @faChokingTitle.
  ///
  /// In en, this message translates to:
  /// **'Choking'**
  String get faChokingTitle;

  /// No description provided for @faChokingSigns.
  ///
  /// In en, this message translates to:
  /// **'Pawing at the mouth, gagging, coughing, blue gums or struggling to breathe.'**
  String get faChokingSigns;

  /// No description provided for @faChokingSteps.
  ///
  /// In en, this message translates to:
  /// **'Stay calm and keep your pet still. If they can still cough, let them try to clear it.\nOpen the mouth gently and look inside with a torch.\nIf you can see the object and reach it easily, hook it out with your fingers. Don\'t push it deeper.\nSmall dog or cat: hold them upside down by the hips and give 5 sharp taps between the shoulder blades.\nLarge dog: stand behind, put your fist just below the ribs and give 5 quick pushes inwards and upwards.\nCheck the mouth again. Go to a vet straight away, even if the object came out.'**
  String get faChokingSteps;

  /// No description provided for @faChokingAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t reach blindly down the throat.\nDon\'t give food or water.\nDon\'t pull on string or thread you see; it may be caught on something inside.'**
  String get faChokingAvoid;

  /// No description provided for @faChokingVet.
  ///
  /// In en, this message translates to:
  /// **'Always see a vet after choking, even if your pet seems fine. Use SOS if they collapse or can\'t breathe.'**
  String get faChokingVet;

  /// No description provided for @faPoisoningTitle.
  ///
  /// In en, this message translates to:
  /// **'Poisoning'**
  String get faPoisoningTitle;

  /// No description provided for @faPoisoningSigns.
  ///
  /// In en, this message translates to:
  /// **'Vomiting, drooling, shaking, wobbly walking, fits, sudden tiredness, or a chewed packet nearby.'**
  String get faPoisoningSigns;

  /// No description provided for @faPoisoningSteps.
  ///
  /// In en, this message translates to:
  /// **'Move your pet away from the poison and remove any left in the mouth.\nFind out what was eaten, how much and when. Keep the packet or take a photo of the plant.\nCall your vet now, or use SOS to reach the nearest clinic.\nIf the poison is on the fur or skin, rinse it off with plenty of lukewarm water.\nKeep your pet warm and quiet on the way to the clinic.'**
  String get faPoisoningSteps;

  /// No description provided for @faPoisoningAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t make your pet vomit unless a vet tells you to.\nDon\'t give milk, salt, oil or home remedies.\nDon\'t wait for signs; some poisons act hours later.'**
  String get faPoisoningAvoid;

  /// No description provided for @faPoisoningVet.
  ///
  /// In en, this message translates to:
  /// **'Go now. With poisons, early treatment saves lives.'**
  String get faPoisoningVet;

  /// No description provided for @faHeatstrokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Heatstroke'**
  String get faHeatstrokeTitle;

  /// No description provided for @faHeatstrokeSigns.
  ///
  /// In en, this message translates to:
  /// **'Heavy panting, thick drool, bright red or pale gums, weakness, vomiting or collapse on a hot day.'**
  String get faHeatstrokeSigns;

  /// No description provided for @faHeatstrokeSteps.
  ///
  /// In en, this message translates to:
  /// **'Move your pet into shade or a cool room right away.\nPour cool (not ice-cold) water over the body, especially the belly, neck and paws.\nUse a fan or wet towels, and change the towels often so they don\'t trap heat.\nOffer small sips of cool water; don\'t force it.\nGo to a vet even if your pet seems better.'**
  String get faHeatstrokeSteps;

  /// No description provided for @faHeatstrokeAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use ice or ice-cold water.\nDon\'t cover your pet with a wet towel and leave it there.\nDon\'t walk in the afternoon heat, and never leave a pet in a parked car.'**
  String get faHeatstrokeAvoid;

  /// No description provided for @faHeatstrokeVet.
  ///
  /// In en, this message translates to:
  /// **'Heatstroke can harm organs hours later. See a vet today. Flat-faced breeds are at higher risk.'**
  String get faHeatstrokeVet;

  /// No description provided for @faBleedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Bleeding'**
  String get faBleedingTitle;

  /// No description provided for @faBleedingSigns.
  ///
  /// In en, this message translates to:
  /// **'Blood from a wound, paw, ear or nose.'**
  String get faBleedingSigns;

  /// No description provided for @faBleedingSteps.
  ///
  /// In en, this message translates to:
  /// **'Press a clean cloth or gauze firmly on the wound.\nKeep pressing for at least 5 minutes without lifting to check.\nIf blood soaks through, add more cloth on top and keep pressing.\nWrap a bandage firmly, but not too tight, to hold it in place.\nKeep your pet calm and go to a vet.'**
  String get faBleedingSteps;

  /// No description provided for @faBleedingAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t tie a tight band (tourniquet) unless a vet tells you to.\nDon\'t pull out anything stuck in the wound.\nDon\'t put turmeric, powders or creams on a deep wound.'**
  String get faBleedingAvoid;

  /// No description provided for @faBleedingVet.
  ///
  /// In en, this message translates to:
  /// **'Use SOS for heavy bleeding, spurting blood or bleeding that doesn\'t slow after 10 minutes of pressure.'**
  String get faBleedingVet;

  /// No description provided for @faFractureTitle.
  ///
  /// In en, this message translates to:
  /// **'Broken bones'**
  String get faFractureTitle;

  /// No description provided for @faFractureSigns.
  ///
  /// In en, this message translates to:
  /// **'Not putting weight on a leg, swelling, a strange angle, crying when touched.'**
  String get faFractureSigns;

  /// No description provided for @faFractureSteps.
  ///
  /// In en, this message translates to:
  /// **'Keep your pet as still as possible. A frightened pet may bite, so be gentle.\nCarry small pets in a box or basket lined with a towel.\nFor a large dog, use a board or a blanket held like a stretcher.\nCover any open wound with a clean cloth.\nGo to a vet straight away.'**
  String get faFractureSteps;

  /// No description provided for @faFractureAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t try to straighten the bone.\nDon\'t give human painkillers; many are poisonous to pets.\nDon\'t let your pet walk on the leg.'**
  String get faFractureAvoid;

  /// No description provided for @faFractureVet.
  ///
  /// In en, this message translates to:
  /// **'Every suspected broken bone needs a vet, and usually an X-ray.'**
  String get faFractureVet;

  /// No description provided for @faSeizureTitle.
  ///
  /// In en, this message translates to:
  /// **'Fits (seizures)'**
  String get faSeizureTitle;

  /// No description provided for @faSeizureSigns.
  ///
  /// In en, this message translates to:
  /// **'Falling over, stiff or jerking legs, paddling, drooling, not responding.'**
  String get faSeizureSigns;

  /// No description provided for @faSeizureSteps.
  ///
  /// In en, this message translates to:
  /// **'Stay calm and note the time the fit started.\nMove furniture and sharp things away. Dim the lights and keep it quiet.\nKeep your hands away from the mouth.\nAfter the fit, keep your pet warm and let them rest; they may be confused for a while.\nCall your vet and tell them how long it lasted.'**
  String get faSeizureSteps;

  /// No description provided for @faSeizureAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hold your pet down.\nDon\'t put anything in the mouth; pets don\'t swallow their tongue.\nDon\'t give food or water until they are fully awake.'**
  String get faSeizureAvoid;

  /// No description provided for @faSeizureVet.
  ///
  /// In en, this message translates to:
  /// **'Use SOS if a fit lasts more than 5 minutes or fits come one after another. A first fit always needs a vet visit.'**
  String get faSeizureVet;

  /// No description provided for @faBurnTitle.
  ///
  /// In en, this message translates to:
  /// **'Burns'**
  String get faBurnTitle;

  /// No description provided for @faBurnSigns.
  ///
  /// In en, this message translates to:
  /// **'Red or raw skin, blisters, singed fur, or contact with hot liquid, fire or chemicals.'**
  String get faBurnSigns;

  /// No description provided for @faBurnSteps.
  ///
  /// In en, this message translates to:
  /// **'Cool the burn under cool running water for 10 minutes.\nFor a chemical burn, rinse with plenty of water for 15 minutes; wear gloves.\nCover loosely with a clean, damp, lint-free cloth.\nKeep your pet warm by wrapping the rest of the body, and go to a vet.'**
  String get faBurnSteps;

  /// No description provided for @faBurnAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use ice, butter, oil, toothpaste or turmeric.\nDon\'t pop blisters.\nDon\'t let your pet lick the burn.'**
  String get faBurnAvoid;

  /// No description provided for @faBurnVet.
  ///
  /// In en, this message translates to:
  /// **'Burns can be deeper than they look. See a vet the same day.'**
  String get faBurnVet;

  /// No description provided for @faBiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Snake or insect bite'**
  String get faBiteTitle;

  /// No description provided for @faBiteSigns.
  ///
  /// In en, this message translates to:
  /// **'Sudden swelling, pain, puncture marks, bleeding, weakness, drooling or trouble breathing.'**
  String get faBiteSigns;

  /// No description provided for @faBiteSteps.
  ///
  /// In en, this message translates to:
  /// **'Keep your pet calm and as still as possible; carry them if you can.\nKeep the bitten part level with or below the heart.\nTake off the collar if the neck or face is swelling.\nFor a bee sting, scrape the sting out with a card.\nGo to the nearest clinic straight away. Use SOS to find one that\'s open.\nIf it\'s safe, note the snake\'s colour and size, or take a photo from a distance.'**
  String get faBiteSteps;

  /// No description provided for @faBiteAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t cut the wound or try to suck out venom.\nDon\'t tie a tight band above the bite.\nDon\'t try to catch the snake.'**
  String get faBiteAvoid;

  /// No description provided for @faBiteVet.
  ///
  /// In en, this message translates to:
  /// **'Every snake bite is an emergency. Go even if your pet seems fine.'**
  String get faBiteVet;

  /// No description provided for @faTickTitle.
  ///
  /// In en, this message translates to:
  /// **'Removing a tick'**
  String get faTickTitle;

  /// No description provided for @faTickSigns.
  ///
  /// In en, this message translates to:
  /// **'A small grey-brown bump stuck to the skin, often around the ears, neck, armpits or between the toes.'**
  String get faTickSigns;

  /// No description provided for @faTickSteps.
  ///
  /// In en, this message translates to:
  /// **'Wear gloves if you can. Part the fur so you can see the tick clearly.\nUse fine tweezers or a tick hook to grip the tick close to the skin.\nPull straight out, slowly and steadily, without twisting or squeezing.\nClean the spot with antiseptic and wash your hands.\nDrop the tick in alcohol, or seal it in tape before throwing it away.\nWatch for fever, tiredness or pale gums over the next 3 weeks.'**
  String get faTickSteps;

  /// No description provided for @faTickAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t burn the tick or cover it in oil, kerosene or petrol.\nDon\'t squeeze the tick\'s body.\nDon\'t crush ticks with bare fingers.'**
  String get faTickAvoid;

  /// No description provided for @faTickVet.
  ///
  /// In en, this message translates to:
  /// **'See a vet if your pet gets a fever, is tired or off food, or has many ticks. Ask about tick prevention.'**
  String get faTickVet;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @closedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed now'**
  String get closedNow;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @draftVetReview.
  ///
  /// In en, this message translates to:
  /// **'Draft, to be reviewed by a vet'**
  String get draftVetReview;

  /// No description provided for @sosCallNearest.
  ///
  /// In en, this message translates to:
  /// **'Call nearest clinic'**
  String get sosCallNearest;

  /// No description provided for @sosGetAddress.
  ///
  /// In en, this message translates to:
  /// **'Get nearest clinic address'**
  String get sosGetAddress;

  /// No description provided for @sosFinding.
  ///
  /// In en, this message translates to:
  /// **'Finding clinics near you…'**
  String get sosFinding;

  /// No description provided for @sosLocating.
  ///
  /// In en, this message translates to:
  /// **'Finding where you are…'**
  String get sosLocating;

  /// No description provided for @sosUsingGps.
  ///
  /// In en, this message translates to:
  /// **'Using your current location'**
  String get sosUsingGps;

  /// No description provided for @sosUsingLastKnown.
  ///
  /// In en, this message translates to:
  /// **'Using your last known location (from {time})'**
  String sosUsingLastKnown(String time);

  /// No description provided for @sosUsingArea.
  ///
  /// In en, this message translates to:
  /// **'Location is off. Showing clinics near {area}.'**
  String sosUsingArea(String area);

  /// No description provided for @sosLocatingNear.
  ///
  /// In en, this message translates to:
  /// **'Finding your location… Meanwhile, clinics near {area}.'**
  String sosLocatingNear(String area);

  /// No description provided for @sosLocatingLastKnown.
  ///
  /// In en, this message translates to:
  /// **'Finding your location… Meanwhile, clinics near your last known location.'**
  String get sosLocatingLastKnown;

  /// No description provided for @sosLocationOffHint.
  ///
  /// In en, this message translates to:
  /// **'Wrong area? Change it so the list is right.'**
  String get sosLocationOffHint;

  /// No description provided for @sosTryLocation.
  ///
  /// In en, this message translates to:
  /// **'Try my location again'**
  String get sosTryLocation;

  /// No description provided for @sosChangeArea.
  ///
  /// In en, this message translates to:
  /// **'Change area'**
  String get sosChangeArea;

  /// No description provided for @sosSavedClinics.
  ///
  /// In en, this message translates to:
  /// **'Weak internet: showing clinics saved on {when}.'**
  String sosSavedClinics(String when);

  /// No description provided for @sosNoClinics.
  ///
  /// In en, this message translates to:
  /// **'No clinics found nearby. Try another area.'**
  String get sosNoClinics;

  /// No description provided for @sosCallClinic.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String sosCallClinic(String name);

  /// No description provided for @sosAway.
  ///
  /// In en, this message translates to:
  /// **'{km} away'**
  String sosAway(String km);

  /// No description provided for @sosDemoCall.
  ///
  /// In en, this message translates to:
  /// **'Demo: this would call {phone}. No real call is made in the demo.'**
  String sosDemoCall(String phone);

  /// No description provided for @sosShowVet.
  ///
  /// In en, this message translates to:
  /// **'Show this to the vet'**
  String get sosShowVet;

  /// No description provided for @firstAidTitle.
  ///
  /// In en, this message translates to:
  /// **'First aid'**
  String get firstAidTitle;

  /// No description provided for @firstAidOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step guides that work without internet'**
  String get firstAidOfflineHint;

  /// No description provided for @firstAidOffline.
  ///
  /// In en, this message translates to:
  /// **'Works without internet'**
  String get firstAidOffline;

  /// No description provided for @firstAidEmergencyNote.
  ///
  /// In en, this message translates to:
  /// **'Not breathing, collapsed or bleeding heavily? Hold SOS now and go to a clinic. These guides help on the way.'**
  String get firstAidEmergencyNote;

  /// No description provided for @firstAidSigns.
  ///
  /// In en, this message translates to:
  /// **'Signs'**
  String get firstAidSigns;

  /// No description provided for @firstAidWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get firstAidWhatToDo;

  /// No description provided for @firstAidAvoid.
  ///
  /// In en, this message translates to:
  /// **'Don\'t'**
  String get firstAidAvoid;

  /// No description provided for @firstAidWhenVet.
  ///
  /// In en, this message translates to:
  /// **'When to see a vet'**
  String get firstAidWhenVet;

  /// No description provided for @firstAidTalkToVet.
  ///
  /// In en, this message translates to:
  /// **'Talk to a vet now'**
  String get firstAidTalkToVet;

  /// No description provided for @toxTitle.
  ///
  /// In en, this message translates to:
  /// **'Is it safe?'**
  String get toxTitle;

  /// No description provided for @toxTileHint.
  ///
  /// In en, this message translates to:
  /// **'Check foods, plants and household things for your pet'**
  String get toxTileHint;

  /// No description provided for @toxSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Food, plant or household item'**
  String get toxSearchLabel;

  /// No description provided for @toxSearchHint.
  ///
  /// In en, this message translates to:
  /// **'For example: grapes, lily, chocolate'**
  String get toxSearchHint;

  /// No description provided for @toxForWhichPet.
  ///
  /// In en, this message translates to:
  /// **'For which pet?'**
  String get toxForWhichPet;

  /// No description provided for @toxKindAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get toxKindAll;

  /// No description provided for @toxKindFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get toxKindFood;

  /// No description provided for @toxKindPlant.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get toxKindPlant;

  /// No description provided for @toxKindHome.
  ///
  /// In en, this message translates to:
  /// **'Around the home'**
  String get toxKindHome;

  /// No description provided for @toxDanger.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get toxDanger;

  /// No description provided for @toxCaution.
  ///
  /// In en, this message translates to:
  /// **'Be careful'**
  String get toxCaution;

  /// No description provided for @toxSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe in small amounts'**
  String get toxSafe;

  /// No description provided for @toxForEachPet.
  ///
  /// In en, this message translates to:
  /// **'For each kind of pet'**
  String get toxForEachPet;

  /// No description provided for @toxAteIt.
  ///
  /// In en, this message translates to:
  /// **'Already eaten? Don\'t wait for signs. Get help now and take the packet or a photo with you.'**
  String get toxAteIt;

  /// No description provided for @toxPoisoningGuide.
  ///
  /// In en, this message translates to:
  /// **'Open the poisoning guide'**
  String get toxPoisoningGuide;

  /// No description provided for @toxNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Not in our list yet'**
  String get toxNoMatch;

  /// No description provided for @toxNoMatchHint.
  ///
  /// In en, this message translates to:
  /// **'If you\'re not sure, don\'t give it, and ask a vet.'**
  String get toxNoMatchHint;

  /// No description provided for @lostIntro.
  ///
  /// In en, this message translates to:
  /// **'Every pet gets a QR tag. Anyone who scans it sees a page with your pet\'s photo and can message you or share where they are. Your phone number stays hidden.'**
  String get lostIntro;

  /// No description provided for @lostSafeAtHome.
  ///
  /// In en, this message translates to:
  /// **'Safe at home'**
  String get lostSafeAtHome;

  /// No description provided for @lostSinceShort.
  ///
  /// In en, this message translates to:
  /// **'Lost since {when}'**
  String lostSinceShort(String when);

  /// No description provided for @lostPetTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} · QR tag'**
  String lostPetTitle(String pet);

  /// No description provided for @lostIfMissing.
  ///
  /// In en, this message translates to:
  /// **'If {pet} goes missing'**
  String lostIfMissing(String pet);

  /// No description provided for @lostIfMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Mark them lost to share a lost page, alert PawSetu users nearby (if you choose) and make a poster in one tap.'**
  String get lostIfMissingBody;

  /// No description provided for @lostMarkLost.
  ///
  /// In en, this message translates to:
  /// **'Mark {pet} as lost'**
  String lostMarkLost(String pet);

  /// No description provided for @lostWhereSeen.
  ///
  /// In en, this message translates to:
  /// **'Where was your pet last seen?'**
  String get lostWhereSeen;

  /// No description provided for @lostUsingGps.
  ///
  /// In en, this message translates to:
  /// **'Using where you are now'**
  String get lostUsingGps;

  /// No description provided for @lostNearMe.
  ///
  /// In en, this message translates to:
  /// **'Near my location'**
  String get lostNearMe;

  /// No description provided for @lostWhenSeen.
  ///
  /// In en, this message translates to:
  /// **'When?'**
  String get lostWhenSeen;

  /// No description provided for @lostWhenNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get lostWhenNow;

  /// No description provided for @lostWhenHour.
  ///
  /// In en, this message translates to:
  /// **'About an hour ago'**
  String get lostWhenHour;

  /// No description provided for @lostWhenMorning.
  ///
  /// In en, this message translates to:
  /// **'This morning'**
  String get lostWhenMorning;

  /// No description provided for @lostWhenYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday evening'**
  String get lostWhenYesterday;

  /// No description provided for @lostNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything that helps people recognise them'**
  String get lostNoteLabel;

  /// No description provided for @lostNoteHint.
  ///
  /// In en, this message translates to:
  /// **'For example: red collar, shy with strangers'**
  String get lostNoteHint;

  /// No description provided for @lostAlertNearby.
  ///
  /// In en, this message translates to:
  /// **'Alert PawSetu users within 5 km'**
  String get lostAlertNearby;

  /// No description provided for @lostAlertNearbyHint.
  ///
  /// In en, this message translates to:
  /// **'Only people who turned on lost-pet alerts get it. They see the lost page, never your number.'**
  String get lostAlertNearbyHint;

  /// No description provided for @lostMarkLostConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark as lost'**
  String get lostMarkLostConfirm;

  /// No description provided for @lostMarked.
  ///
  /// In en, this message translates to:
  /// **'{pet} is marked lost. Your family has been told.'**
  String lostMarked(String pet);

  /// No description provided for @lostDemoAlert.
  ///
  /// In en, this message translates to:
  /// **'Demo: the alert reached {count} PawSetu users within 5 km of {area} who turned on lost-pet alerts. The messages are in the Demo Outbox; no real alert was sent.'**
  String lostDemoAlert(int count, String area);

  /// No description provided for @lostBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} is marked lost'**
  String lostBannerTitle(String pet);

  /// No description provided for @lostBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Since {when}, near {area}.'**
  String lostBannerBody(String when, String area);

  /// No description provided for @lostAlertsSent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No PawSetu users nearby were alerted} =1{Alert sent to 1 person nearby} other{Alert sent to {count} people nearby}}'**
  String lostAlertsSent(int count);

  /// No description provided for @lostSightings.
  ///
  /// In en, this message translates to:
  /// **'Sightings'**
  String get lostSightings;

  /// No description provided for @lostNoSightings.
  ///
  /// In en, this message translates to:
  /// **'No sightings yet. Share the lost page and the poster so more people can help.'**
  String get lostNoSightings;

  /// No description provided for @lostSightingNoDetails.
  ///
  /// In en, this message translates to:
  /// **'Location shared'**
  String get lostSightingNoDetails;

  /// No description provided for @lostMakePoster.
  ///
  /// In en, this message translates to:
  /// **'Make a poster (PDF)'**
  String get lostMakePoster;

  /// No description provided for @lostShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share the lost page'**
  String get lostShareLink;

  /// No description provided for @lostShareText.
  ///
  /// In en, this message translates to:
  /// **'Please help! {pet} is lost near {area}. If you see them, open {url}'**
  String lostShareText(String pet, String area, String url);

  /// No description provided for @lostMarkFound.
  ///
  /// In en, this message translates to:
  /// **'{pet} is found'**
  String lostMarkFound(String pet);

  /// No description provided for @lostFoundConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Is {pet} home safe?'**
  String lostFoundConfirmTitle(String pet);

  /// No description provided for @lostFoundConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll take down the lost page and tell your family.'**
  String get lostFoundConfirmBody;

  /// No description provided for @lostFoundConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, found'**
  String get lostFoundConfirm;

  /// No description provided for @lostWelcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome home, {pet}!'**
  String lostWelcomeHome(String pet);

  /// No description provided for @lostFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} is lost'**
  String lostFamilyTitle(String pet);

  /// No description provided for @lostFamilyBody.
  ///
  /// In en, this message translates to:
  /// **'{name} marked them lost near {area}. Open the lost page to share it.'**
  String lostFamilyBody(String name, String area);

  /// No description provided for @lostFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Good news: {pet} is home safe'**
  String lostFoundTitle(String pet);

  /// No description provided for @lostNearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Have you seen {pet}? A pet is lost near you'**
  String lostNearbyTitle(String pet);

  /// No description provided for @lostNearbyBody.
  ///
  /// In en, this message translates to:
  /// **'Last seen near {area}. Tap to see the photo and tell the family.'**
  String lostNearbyBody(String area);

  /// No description provided for @qrTagHint.
  ///
  /// In en, this message translates to:
  /// **'Print this for {pet}\'s collar tag. Anyone who scans it can message you without seeing your number.'**
  String qrTagHint(String pet);

  /// No description provided for @qrForPet.
  ///
  /// In en, this message translates to:
  /// **'QR code for {pet}\'s tag'**
  String qrForPet(String pet);

  /// No description provided for @qrPrintTags.
  ///
  /// In en, this message translates to:
  /// **'Print QR tags (PDF)'**
  String get qrPrintTags;

  /// No description provided for @qrOpenPage.
  ///
  /// In en, this message translates to:
  /// **'Open the page'**
  String get qrOpenPage;

  /// No description provided for @qrTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'QR tags for {pet}'**
  String qrTagsTitle(String pet);

  /// No description provided for @qrTagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cut out a tag and fix it to the collar'**
  String get qrTagsSubtitle;

  /// No description provided for @qrTagsFooter.
  ///
  /// In en, this message translates to:
  /// **'Made with PawSetu. Scanning a tag never shows the family\'s phone number.'**
  String get qrTagsFooter;

  /// No description provided for @qrTagScanLine.
  ///
  /// In en, this message translates to:
  /// **'If I\'m alone, scan me to tell my family'**
  String get qrTagScanLine;

  /// No description provided for @posterTitle.
  ///
  /// In en, this message translates to:
  /// **'Lost poster for {pet}'**
  String posterTitle(String pet);

  /// No description provided for @posterHeadline.
  ///
  /// In en, this message translates to:
  /// **'Lost {species}'**
  String posterHeadline(String species);

  /// No description provided for @posterLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen near {area}, {when}'**
  String posterLastSeen(String area, String when);

  /// No description provided for @posterScan.
  ///
  /// In en, this message translates to:
  /// **'Seen me? Scan this'**
  String get posterScan;

  /// No description provided for @posterScanBody.
  ///
  /// In en, this message translates to:
  /// **'Send a message or share where you saw me. My family gets it right away.'**
  String get posterScanBody;

  /// No description provided for @lostTagInactive.
  ///
  /// In en, this message translates to:
  /// **'This tag isn\'t active'**
  String get lostTagInactive;

  /// No description provided for @lostTagInactiveHint.
  ///
  /// In en, this message translates to:
  /// **'The link may be old or mistyped. If you found a pet, take them to the nearest vet clinic: they can scan for a microchip.'**
  String get lostTagInactiveHint;

  /// No description provided for @finderDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo page: messages and locations go to the Demo Outbox, not to a real family.'**
  String get finderDemoNote;

  /// No description provided for @finderDemoSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Demo)'**
  String get finderDemoSuffix;

  /// No description provided for @finderLostHeadline.
  ///
  /// In en, this message translates to:
  /// **'{pet} is lost'**
  String finderLostHeadline(String pet);

  /// No description provided for @finderLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen near {area} · {when}'**
  String finderLastSeen(String area, String when);

  /// No description provided for @finderHello.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m {pet}!'**
  String finderHello(String pet);

  /// No description provided for @finderHelloLost.
  ///
  /// In en, this message translates to:
  /// **'I\'m {pet}. Please help me get home!'**
  String finderHelloLost(String pet);

  /// No description provided for @finderAsk.
  ///
  /// In en, this message translates to:
  /// **'If I\'m alone, please tell my family. They\'ll come for me.'**
  String get finderAsk;

  /// No description provided for @finderLostAsk.
  ///
  /// In en, this message translates to:
  /// **'My family is looking for me. If you can, keep me safe and send them a message or your location.'**
  String get finderLostAsk;

  /// No description provided for @finderContact.
  ///
  /// In en, this message translates to:
  /// **'Contact my family'**
  String get finderContact;

  /// No description provided for @finderShareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share my location'**
  String get finderShareLocation;

  /// No description provided for @finderPrivacy.
  ///
  /// In en, this message translates to:
  /// **'PawSetu passes your message on. The family\'s number stays private; leave yours only if you want a call back.'**
  String get finderPrivacy;

  /// No description provided for @finderTips.
  ///
  /// In en, this message translates to:
  /// **'Offer water and shade, keep the pet on a lead or in a closed space, and don\'t chase a scared pet.'**
  String get finderTips;

  /// No description provided for @finderContactHint.
  ///
  /// In en, this message translates to:
  /// **'Your message goes straight to the family in the PawSetu app.'**
  String get finderContactHint;

  /// No description provided for @finderMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get finderMessageLabel;

  /// No description provided for @finderMessageStart.
  ///
  /// In en, this message translates to:
  /// **'Hi, I found {pet} near '**
  String finderMessageStart(String pet);

  /// No description provided for @finderYourName.
  ///
  /// In en, this message translates to:
  /// **'Your name (optional)'**
  String get finderYourName;

  /// No description provided for @finderYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone (optional)'**
  String get finderYourPhone;

  /// No description provided for @finderPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Only if you\'d like the family to call you'**
  String get finderPhoneHelper;

  /// No description provided for @finderSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get finderSend;

  /// No description provided for @finderSent.
  ///
  /// In en, this message translates to:
  /// **'Message sent to {pet}\'s family. Thank you!'**
  String finderSent(String pet);

  /// No description provided for @finderLocationSent.
  ///
  /// In en, this message translates to:
  /// **'Location sent to {pet}\'s family. Thank you!'**
  String finderLocationSent(String pet);

  /// No description provided for @finderTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many messages for this tag right now. Please try again in an hour.'**
  String get finderTooMany;

  /// No description provided for @finderWhereSeen.
  ///
  /// In en, this message translates to:
  /// **'Where are you?'**
  String get finderWhereSeen;

  /// No description provided for @finderLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Your location is off. Choose the area and add a landmark.'**
  String get finderLocationOff;

  /// No description provided for @finderLandmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get finderLandmark;

  /// No description provided for @finderLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'For example: near the metro station'**
  String get finderLandmarkHint;

  /// No description provided for @finderMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message about {pet} from someone who scanned the tag'**
  String finderMessageTitle(String pet);

  /// No description provided for @finderFrom.
  ///
  /// In en, this message translates to:
  /// **'from {from}'**
  String finderFrom(String from);

  /// No description provided for @finderSightingTitle.
  ///
  /// In en, this message translates to:
  /// **'Someone shared where they saw {pet}'**
  String finderSightingTitle(String pet);

  /// No description provided for @devDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo devices: the readings are simulated so you can try everything.'**
  String get devDemoNote;

  /// No description provided for @devAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a device'**
  String get devAdd;

  /// No description provided for @devNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No devices yet'**
  String get devNoneTitle;

  /// No description provided for @devNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Pair a GPS collar, activity tracker, feeder, water fountain, camera or litter box.'**
  String get devNoneBody;

  /// No description provided for @devGpsCollar.
  ///
  /// In en, this message translates to:
  /// **'GPS collar'**
  String get devGpsCollar;

  /// No description provided for @devGpsCollarHint.
  ///
  /// In en, this message translates to:
  /// **'Live location and a safe-zone alert'**
  String get devGpsCollarHint;

  /// No description provided for @devActivityTracker.
  ///
  /// In en, this message translates to:
  /// **'Activity tracker'**
  String get devActivityTracker;

  /// No description provided for @devActivityTrackerHint.
  ///
  /// In en, this message translates to:
  /// **'Steps and active minutes'**
  String get devActivityTrackerHint;

  /// No description provided for @devFeeder.
  ///
  /// In en, this message translates to:
  /// **'Smart feeder'**
  String get devFeeder;

  /// No description provided for @devFeederHint.
  ///
  /// In en, this message translates to:
  /// **'Meals on time, even when you\'re out'**
  String get devFeederHint;

  /// No description provided for @devFountain.
  ///
  /// In en, this message translates to:
  /// **'Water fountain'**
  String get devFountain;

  /// No description provided for @devFountainHint.
  ///
  /// In en, this message translates to:
  /// **'Water level and filter reminders'**
  String get devFountainHint;

  /// No description provided for @devCamera.
  ///
  /// In en, this message translates to:
  /// **'Pet camera'**
  String get devCamera;

  /// No description provided for @devCameraHint.
  ///
  /// In en, this message translates to:
  /// **'See your pet while you\'re away'**
  String get devCameraHint;

  /// No description provided for @devLitterBox.
  ///
  /// In en, this message translates to:
  /// **'Smart litter box'**
  String get devLitterBox;

  /// No description provided for @devLitterBoxHint.
  ///
  /// In en, this message translates to:
  /// **'Visits and cleaning reminders'**
  String get devLitterBoxHint;

  /// No description provided for @devPairDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo pairing: we\'ll find a demo device for you. Nothing connects over Bluetooth.'**
  String get devPairDemo;

  /// No description provided for @devStepType.
  ///
  /// In en, this message translates to:
  /// **'1. What kind of device?'**
  String get devStepType;

  /// No description provided for @devStepPet.
  ///
  /// In en, this message translates to:
  /// **'2. Which pet is it for?'**
  String get devStepPet;

  /// No description provided for @devStepFind.
  ///
  /// In en, this message translates to:
  /// **'3. Find the device'**
  String get devStepFind;

  /// No description provided for @devStepName.
  ///
  /// In en, this message translates to:
  /// **'4. Name it'**
  String get devStepName;

  /// No description provided for @devNotForAll.
  ///
  /// In en, this message translates to:
  /// **'Some pets are greyed out because this device doesn\'t suit them.'**
  String get devNotForAll;

  /// No description provided for @devSearch.
  ///
  /// In en, this message translates to:
  /// **'Search for the device'**
  String get devSearch;

  /// No description provided for @devSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching nearby…'**
  String get devSearching;

  /// No description provided for @devDefaultName.
  ///
  /// In en, this message translates to:
  /// **'{pet}\'s {type}'**
  String devDefaultName(String pet, String type);

  /// No description provided for @devNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get devNameLabel;

  /// No description provided for @devSafeZoneRadius.
  ///
  /// In en, this message translates to:
  /// **'Safe zone: {metres} m around home'**
  String devSafeZoneRadius(int metres);

  /// No description provided for @devSafeZoneHint.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get an alert as soon as the collar leaves this circle.'**
  String get devSafeZoneHint;

  /// No description provided for @devPair.
  ///
  /// In en, this message translates to:
  /// **'Pair device'**
  String get devPair;

  /// No description provided for @devPaired.
  ///
  /// In en, this message translates to:
  /// **'{name} is paired'**
  String devPaired(String name);

  /// No description provided for @devLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming in Version 2'**
  String get devLiveTitle;

  /// No description provided for @devLiveBody.
  ///
  /// In en, this message translates to:
  /// **'Real devices connect in the live version. For now, try the demo devices.'**
  String get devLiveBody;

  /// No description provided for @devConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get devConnected;

  /// No description provided for @devInsideZone.
  ///
  /// In en, this message translates to:
  /// **'Inside the safe zone · {metres} m from home'**
  String devInsideZone(int metres);

  /// No description provided for @devOutsideZone.
  ///
  /// In en, this message translates to:
  /// **'Outside the safe zone! {metres} m from home'**
  String devOutsideZone(int metres);

  /// No description provided for @devStepsToday.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps today'**
  String devStepsToday(String steps);

  /// No description provided for @devNextMeal.
  ///
  /// In en, this message translates to:
  /// **'Next meal at {time}'**
  String devNextMeal(String time);

  /// No description provided for @devWaterLevel.
  ///
  /// In en, this message translates to:
  /// **'Water level: {pct}%'**
  String devWaterLevel(int pct);

  /// No description provided for @devCameraReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get devCameraReady;

  /// No description provided for @devLitterVisits.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No visits today} =1{1 visit today} other{{count} visits today}}'**
  String devLitterVisits(int count);

  /// No description provided for @devUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String devUpdated(String time);

  /// No description provided for @devLocate.
  ///
  /// In en, this message translates to:
  /// **'Locate now'**
  String get devLocate;

  /// No description provided for @devLocated.
  ///
  /// In en, this message translates to:
  /// **'Location updated'**
  String get devLocated;

  /// No description provided for @devEditZone.
  ///
  /// In en, this message translates to:
  /// **'Edit safe zone'**
  String get devEditZone;

  /// No description provided for @devNoZone.
  ///
  /// In en, this message translates to:
  /// **'No safe zone set yet. Edit it to get alerts.'**
  String get devNoZone;

  /// No description provided for @devAlertSent.
  ///
  /// In en, this message translates to:
  /// **'Everyone looking after this pet got an alert (push and SMS).'**
  String get devAlertSent;

  /// No description provided for @devBackInside.
  ///
  /// In en, this message translates to:
  /// **'Back inside the safe zone.'**
  String get devBackInside;

  /// No description provided for @devDemoControls.
  ///
  /// In en, this message translates to:
  /// **'Demo controls'**
  String get devDemoControls;

  /// No description provided for @devDemoControlsHint.
  ///
  /// In en, this message translates to:
  /// **'Try the safe-zone alert without leaving home.'**
  String get devDemoControlsHint;

  /// No description provided for @devDemoWalkOut.
  ///
  /// In en, this message translates to:
  /// **'Demo: walk {pet} out of the safe zone'**
  String devDemoWalkOut(String pet);

  /// No description provided for @devDemoComeHome.
  ///
  /// In en, this message translates to:
  /// **'Demo: bring {pet} home'**
  String devDemoComeHome(String pet);

  /// No description provided for @devToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get devToday;

  /// No description provided for @devActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'{active} of {goal} active minutes'**
  String devActiveMinutes(int active, int goal);

  /// No description provided for @devNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No walks or play noticed yet today.'**
  String get devNoSessions;

  /// No description provided for @devWalkSession.
  ///
  /// In en, this message translates to:
  /// **'Walk · {minutes} min · {km} km'**
  String devWalkSession(int minutes, String km);

  /// No description provided for @devPlaySession.
  ///
  /// In en, this message translates to:
  /// **'Play · {minutes} min'**
  String devPlaySession(int minutes);

  /// No description provided for @devInRoutine.
  ///
  /// In en, this message translates to:
  /// **'Added to the daily routine'**
  String get devInRoutine;

  /// No description provided for @devFlowsToRoutine.
  ///
  /// In en, this message translates to:
  /// **'Walks and play from this device are added to {pet}\'s daily routine automatically.'**
  String devFlowsToRoutine(String pet);

  /// No description provided for @devSynced.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 activity} other{{count} activities}} added to {pet}\'s routine'**
  String devSynced(int count, String pet);

  /// No description provided for @devHopper.
  ///
  /// In en, this message translates to:
  /// **'Food left in the feeder: {pct}%'**
  String devHopper(int pct);

  /// No description provided for @devMealsToday.
  ///
  /// In en, this message translates to:
  /// **'Meals today'**
  String get devMealsToday;

  /// No description provided for @devNoMealsYet.
  ///
  /// In en, this message translates to:
  /// **'No meals served yet today.'**
  String get devNoMealsYet;

  /// No description provided for @devMealGrams.
  ///
  /// In en, this message translates to:
  /// **'{grams} g served'**
  String devMealGrams(int grams);

  /// No description provided for @devFeedNow.
  ///
  /// In en, this message translates to:
  /// **'Feed a small portion now'**
  String get devFeedNow;

  /// No description provided for @devFed.
  ///
  /// In en, this message translates to:
  /// **'A small portion was served to {pet} and added to today\'s meals.'**
  String devFed(String pet);

  /// No description provided for @devFilterDays.
  ///
  /// In en, this message translates to:
  /// **'Filter change in {days} days'**
  String devFilterDays(int days);

  /// No description provided for @devRefillSoon.
  ///
  /// In en, this message translates to:
  /// **'Water is running low. Refill the fountain soon.'**
  String get devRefillSoon;

  /// No description provided for @devCameraPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Live video arrives with real cameras in Version 2.'**
  String get devCameraPlaceholder;

  /// No description provided for @devSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Take a snapshot'**
  String get devSnapshot;

  /// No description provided for @devSnapshotDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo: a real camera would send a photo of your pet here.'**
  String get devSnapshotDemo;

  /// No description provided for @devLastVisit.
  ///
  /// In en, this message translates to:
  /// **'Last visit at {time}'**
  String devLastVisit(String time);

  /// No description provided for @devCleanSoon.
  ///
  /// In en, this message translates to:
  /// **'Clean soon'**
  String get devCleanSoon;

  /// No description provided for @devLitterClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get devLitterClean;

  /// No description provided for @devRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove device'**
  String get devRemove;

  /// No description provided for @devRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String devRemoveTitle(String name);

  /// No description provided for @devRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'It will stop sending data. Logs already in the routine stay.'**
  String get devRemoveBody;

  /// No description provided for @zoneLeftTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} has left the safe zone'**
  String zoneLeftTitle(String pet);

  /// No description provided for @zoneLeftBody.
  ///
  /// In en, this message translates to:
  /// **'{device}: now {metres} m from home. Tap to see where.'**
  String zoneLeftBody(String device, int metres);

  /// No description provided for @zoneBackTitle.
  ///
  /// In en, this message translates to:
  /// **'{pet} is back in the safe zone'**
  String zoneBackTitle(String pet);

  /// No description provided for @toxChocolateName.
  ///
  /// In en, this message translates to:
  /// **'Chocolate'**
  String get toxChocolateName;

  /// No description provided for @toxChocolateWhy.
  ///
  /// In en, this message translates to:
  /// **'Has theobromine and caffeine, which cause vomiting, a racing heart and fits. Dark chocolate and cocoa powder are the most dangerous.'**
  String get toxChocolateWhy;

  /// No description provided for @toxGrapesName.
  ///
  /// In en, this message translates to:
  /// **'Grapes and raisins'**
  String get toxGrapesName;

  /// No description provided for @toxGrapesWhy.
  ///
  /// In en, this message translates to:
  /// **'Even a few grapes or raisins (kishmish) can cause sudden kidney failure in dogs and cats. Birds and rabbits: only a tiny piece as a rare treat.'**
  String get toxGrapesWhy;

  /// No description provided for @toxOnionGarlicName.
  ///
  /// In en, this message translates to:
  /// **'Onion and garlic'**
  String get toxOnionGarlicName;

  /// No description provided for @toxOnionGarlicWhy.
  ///
  /// In en, this message translates to:
  /// **'Raw, cooked or powdered, and in curries and gravies too, they damage red blood cells and cause weakness days later.'**
  String get toxOnionGarlicWhy;

  /// No description provided for @toxXylitolName.
  ///
  /// In en, this message translates to:
  /// **'Xylitol (sugar-free sweetener)'**
  String get toxXylitolName;

  /// No description provided for @toxXylitolWhy.
  ///
  /// In en, this message translates to:
  /// **'Found in sugar-free gum, mints, some peanut butters and medicines. In dogs it causes a sudden drop in blood sugar and liver damage. Keep it away from all pets.'**
  String get toxXylitolWhy;

  /// No description provided for @toxAlcoholName.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get toxAlcoholName;

  /// No description provided for @toxAlcoholWhy.
  ///
  /// In en, this message translates to:
  /// **'Even small amounts cause vomiting, wobbliness, breathing problems and coma. Raw bread dough with yeast also makes alcohol in the stomach.'**
  String get toxAlcoholWhy;

  /// No description provided for @toxCaffeineName.
  ///
  /// In en, this message translates to:
  /// **'Tea, coffee and caffeine'**
  String get toxCaffeineName;

  /// No description provided for @toxCaffeineWhy.
  ///
  /// In en, this message translates to:
  /// **'Tea, coffee, energy drinks and caffeine tablets cause restlessness, a racing heart and fits.'**
  String get toxCaffeineWhy;

  /// No description provided for @toxAvocadoName.
  ///
  /// In en, this message translates to:
  /// **'Avocado'**
  String get toxAvocadoName;

  /// No description provided for @toxAvocadoWhy.
  ///
  /// In en, this message translates to:
  /// **'Very dangerous for birds and rabbits: it can damage the heart. For dogs and cats the stone can block the gut, and the skin and leaves upset the stomach.'**
  String get toxAvocadoWhy;

  /// No description provided for @toxCookedBonesName.
  ///
  /// In en, this message translates to:
  /// **'Cooked bones'**
  String get toxCookedBonesName;

  /// No description provided for @toxCookedBonesWhy.
  ///
  /// In en, this message translates to:
  /// **'Cooked chicken or mutton bones splinter and can choke your pet or tear the gut. Never give cooked bones.'**
  String get toxCookedBonesWhy;

  /// No description provided for @toxMilkName.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get toxMilkName;

  /// No description provided for @toxMilkWhy.
  ///
  /// In en, this message translates to:
  /// **'Most adult cats and dogs can\'t digest milk well and get loose motions. Don\'t give milk to birds or rabbits.'**
  String get toxMilkWhy;

  /// No description provided for @toxSaltySnacksName.
  ///
  /// In en, this message translates to:
  /// **'Salty snacks (namkeen, chips)'**
  String get toxSaltySnacksName;

  /// No description provided for @toxSaltySnacksWhy.
  ///
  /// In en, this message translates to:
  /// **'Namkeen, chips and papad cause thirst and vomiting; large amounts can cause salt poisoning. Birds are especially sensitive.'**
  String get toxSaltySnacksWhy;

  /// No description provided for @toxSpicyFoodName.
  ///
  /// In en, this message translates to:
  /// **'Spicy food'**
  String get toxSpicyFoodName;

  /// No description provided for @toxSpicyFoodWhy.
  ///
  /// In en, this message translates to:
  /// **'Chilli and masala upset the stomach and cause vomiting and loose motions. Curries usually contain onion and garlic too.'**
  String get toxSpicyFoodWhy;

  /// No description provided for @toxFattyFoodName.
  ///
  /// In en, this message translates to:
  /// **'Fried and fatty food'**
  String get toxFattyFoodName;

  /// No description provided for @toxFattyFoodWhy.
  ///
  /// In en, this message translates to:
  /// **'Fried snacks, ghee, fat trimmings and rich leftovers can cause pancreatitis, a painful swelling of the pancreas.'**
  String get toxFattyFoodWhy;

  /// No description provided for @toxSweetsName.
  ///
  /// In en, this message translates to:
  /// **'Sweets (mithai)'**
  String get toxSweetsName;

  /// No description provided for @toxSweetsWhy.
  ///
  /// In en, this message translates to:
  /// **'Sugary sweets cause weight gain and tummy upsets, and many contain ghee, chocolate, raisins or sugar-free sweeteners.'**
  String get toxSweetsWhy;

  /// No description provided for @toxFruitSeedsName.
  ///
  /// In en, this message translates to:
  /// **'Fruit stones and seeds'**
  String get toxFruitSeedsName;

  /// No description provided for @toxFruitSeedsWhy.
  ///
  /// In en, this message translates to:
  /// **'Mango stones, apple seeds and the stones of plums, peaches and cherries can choke or block the gut, and some contain cyanide.'**
  String get toxFruitSeedsWhy;

  /// No description provided for @toxTomatoName.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get toxTomatoName;

  /// No description provided for @toxTomatoWhy.
  ///
  /// In en, this message translates to:
  /// **'A little ripe tomato is usually fine. Green tomatoes, leaves and stems are harmful.'**
  String get toxTomatoWhy;

  /// No description provided for @toxPeanutsName.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get toxPeanutsName;

  /// No description provided for @toxPeanutsWhy.
  ///
  /// In en, this message translates to:
  /// **'Only plain, unsalted peanuts, a few at a time. Salted or masala peanuts are not safe, and peanut butter must not contain xylitol.'**
  String get toxPeanutsWhy;

  /// No description provided for @toxMangoName.
  ///
  /// In en, this message translates to:
  /// **'Mango'**
  String get toxMangoName;

  /// No description provided for @toxMangoWhy.
  ///
  /// In en, this message translates to:
  /// **'Ripe mango flesh is fine as a small treat. Remove the skin and the stone. Too much causes loose motions.'**
  String get toxMangoWhy;

  /// No description provided for @toxAppleName.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get toxAppleName;

  /// No description provided for @toxAppleWhy.
  ///
  /// In en, this message translates to:
  /// **'Apple slices without the seeds and core are a healthy, crunchy treat.'**
  String get toxAppleWhy;

  /// No description provided for @toxBananaName.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get toxBananaName;

  /// No description provided for @toxBananaWhy.
  ///
  /// In en, this message translates to:
  /// **'A small piece is a fine treat. It is high in sugar, so keep it small.'**
  String get toxBananaWhy;

  /// No description provided for @toxWatermelonName.
  ///
  /// In en, this message translates to:
  /// **'Watermelon'**
  String get toxWatermelonName;

  /// No description provided for @toxWatermelonWhy.
  ///
  /// In en, this message translates to:
  /// **'Seedless pieces without the rind make a cooling summer treat.'**
  String get toxWatermelonWhy;

  /// No description provided for @toxCarrotName.
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get toxCarrotName;

  /// No description provided for @toxCarrotWhy.
  ///
  /// In en, this message translates to:
  /// **'Raw or cooked carrot is a healthy treat. For rabbits, keep carrot as a small treat, because it is sugary.'**
  String get toxCarrotWhy;

  /// No description provided for @toxRiceName.
  ///
  /// In en, this message translates to:
  /// **'Plain cooked rice'**
  String get toxRiceName;

  /// No description provided for @toxRiceWhy.
  ///
  /// In en, this message translates to:
  /// **'Plain rice with no salt, ghee, onion or masala is gentle on the stomach in small amounts. Rabbits need hay, not rice.'**
  String get toxRiceWhy;

  /// No description provided for @toxEggName.
  ///
  /// In en, this message translates to:
  /// **'Cooked egg'**
  String get toxEggName;

  /// No description provided for @toxEggWhy.
  ///
  /// In en, this message translates to:
  /// **'A fully cooked egg is a good protein treat. Avoid raw egg. Rabbits eat only plants.'**
  String get toxEggWhy;

  /// No description provided for @toxLilyName.
  ///
  /// In en, this message translates to:
  /// **'Lilies'**
  String get toxLilyName;

  /// No description provided for @toxLilyWhy.
  ///
  /// In en, this message translates to:
  /// **'Every part of a lily, even the pollen or the vase water, can cause kidney failure in cats. Keep lilies out of homes with cats.'**
  String get toxLilyWhy;

  /// No description provided for @toxSagoPalmName.
  ///
  /// In en, this message translates to:
  /// **'Sago palm (cycas)'**
  String get toxSagoPalmName;

  /// No description provided for @toxSagoPalmWhy.
  ///
  /// In en, this message translates to:
  /// **'Every part is poisonous, the seeds most of all. It causes vomiting and liver failure.'**
  String get toxSagoPalmWhy;

  /// No description provided for @toxOleanderName.
  ///
  /// In en, this message translates to:
  /// **'Oleander (kaner)'**
  String get toxOleanderName;

  /// No description provided for @toxOleanderWhy.
  ///
  /// In en, this message translates to:
  /// **'Oleander affects the heart. A few leaves or flowers can be fatal.'**
  String get toxOleanderWhy;

  /// No description provided for @toxCastorName.
  ///
  /// In en, this message translates to:
  /// **'Castor plant (arandi)'**
  String get toxCastorName;

  /// No description provided for @toxCastorWhy.
  ///
  /// In en, this message translates to:
  /// **'Castor seeds contain ricin. Chewing even one or two seeds can be fatal.'**
  String get toxCastorWhy;

  /// No description provided for @toxDaturaName.
  ///
  /// In en, this message translates to:
  /// **'Datura (dhatura)'**
  String get toxDaturaName;

  /// No description provided for @toxDaturaWhy.
  ///
  /// In en, this message translates to:
  /// **'The seeds and flowers cause a racing heart, wide pupils, confusion and fits.'**
  String get toxDaturaWhy;

  /// No description provided for @toxLantanaName.
  ///
  /// In en, this message translates to:
  /// **'Lantana'**
  String get toxLantanaName;

  /// No description provided for @toxLantanaWhy.
  ///
  /// In en, this message translates to:
  /// **'The berries and leaves of this common hedge plant can damage the liver.'**
  String get toxLantanaWhy;

  /// No description provided for @toxAloeVeraName.
  ///
  /// In en, this message translates to:
  /// **'Aloe vera'**
  String get toxAloeVeraName;

  /// No description provided for @toxAloeVeraWhy.
  ///
  /// In en, this message translates to:
  /// **'The clear gel is usually fine, but the bitter yellow sap under the skin causes vomiting and loose motions.'**
  String get toxAloeVeraWhy;

  /// No description provided for @toxMoneyPlantName.
  ///
  /// In en, this message translates to:
  /// **'Money plant'**
  String get toxMoneyPlantName;

  /// No description provided for @toxMoneyPlantWhy.
  ///
  /// In en, this message translates to:
  /// **'Chewing the leaves causes mouth pain, drooling and vomiting.'**
  String get toxMoneyPlantWhy;

  /// No description provided for @toxSnakePlantName.
  ///
  /// In en, this message translates to:
  /// **'Snake plant'**
  String get toxSnakePlantName;

  /// No description provided for @toxSnakePlantWhy.
  ///
  /// In en, this message translates to:
  /// **'Chewing it can cause drooling, vomiting and loose motions.'**
  String get toxSnakePlantWhy;

  /// No description provided for @toxMarigoldName.
  ///
  /// In en, this message translates to:
  /// **'Marigold (genda)'**
  String get toxMarigoldName;

  /// No description provided for @toxMarigoldWhy.
  ///
  /// In en, this message translates to:
  /// **'Chewing marigolds can cause mild mouth irritation and an upset stomach.'**
  String get toxMarigoldWhy;

  /// No description provided for @toxTulsiName.
  ///
  /// In en, this message translates to:
  /// **'Tulsi (holy basil)'**
  String get toxTulsiName;

  /// No description provided for @toxTulsiWhy.
  ///
  /// In en, this message translates to:
  /// **'Tulsi is not known to be poisonous to pets. Large amounts may still upset the stomach.'**
  String get toxTulsiWhy;

  /// No description provided for @toxArecaPalmName.
  ///
  /// In en, this message translates to:
  /// **'Areca palm'**
  String get toxArecaPalmName;

  /// No description provided for @toxArecaPalmWhy.
  ///
  /// In en, this message translates to:
  /// **'A pet-friendly houseplant.'**
  String get toxArecaPalmWhy;

  /// No description provided for @toxSpiderPlantName.
  ///
  /// In en, this message translates to:
  /// **'Spider plant'**
  String get toxSpiderPlantName;

  /// No description provided for @toxSpiderPlantWhy.
  ///
  /// In en, this message translates to:
  /// **'Not poisonous, though cats love to chew it and may vomit a little.'**
  String get toxSpiderPlantWhy;

  /// No description provided for @toxRatPoisonName.
  ///
  /// In en, this message translates to:
  /// **'Rat poison'**
  String get toxRatPoisonName;

  /// No description provided for @toxRatPoisonWhy.
  ///
  /// In en, this message translates to:
  /// **'Causes internal bleeding or fits, sometimes days later. Take the packet to the vet.'**
  String get toxRatPoisonWhy;

  /// No description provided for @toxHumanMedicinesName.
  ///
  /// In en, this message translates to:
  /// **'Human medicines'**
  String get toxHumanMedicinesName;

  /// No description provided for @toxHumanMedicinesWhy.
  ///
  /// In en, this message translates to:
  /// **'Paracetamol and painkillers like ibuprofen are poisonous to pets. One paracetamol tablet can kill a cat. Give only medicines your vet prescribes.'**
  String get toxHumanMedicinesWhy;

  /// No description provided for @toxMosquitoRepellentName.
  ///
  /// In en, this message translates to:
  /// **'Mosquito coils and vaporisers'**
  String get toxMosquitoRepellentName;

  /// No description provided for @toxMosquitoRepellentWhy.
  ///
  /// In en, this message translates to:
  /// **'The fumes can harm birds\' lungs. Use them away from pets and keep the room aired.'**
  String get toxMosquitoRepellentWhy;

  /// No description provided for @toxMothballsName.
  ///
  /// In en, this message translates to:
  /// **'Naphthalene balls'**
  String get toxMothballsName;

  /// No description provided for @toxMothballsWhy.
  ///
  /// In en, this message translates to:
  /// **'Poisonous if chewed, and the fumes harm birds. Keep them in closed cupboards.'**
  String get toxMothballsWhy;

  /// No description provided for @toxNonStickFumesName.
  ///
  /// In en, this message translates to:
  /// **'Non-stick pan fumes'**
  String get toxNonStickFumesName;

  /// No description provided for @toxNonStickFumesWhy.
  ///
  /// In en, this message translates to:
  /// **'An overheated non-stick pan gives off fumes that can kill a bird within minutes. Keep birds out of the kitchen.'**
  String get toxNonStickFumesWhy;

  /// No description provided for @toxPhenylName.
  ///
  /// In en, this message translates to:
  /// **'Phenyl and floor cleaners'**
  String get toxPhenylName;

  /// No description provided for @toxPhenylWhy.
  ///
  /// In en, this message translates to:
  /// **'Phenyl and many floor cleaners contain phenols, which are especially poisonous to cats. Let floors dry before pets walk on them.'**
  String get toxPhenylWhy;

  /// No description provided for @reviewedBy.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by {name}'**
  String reviewedBy(String name);

  /// No description provided for @featurePaused.
  ///
  /// In en, this message translates to:
  /// **'This feature is switched off for now'**
  String get featurePaused;

  /// No description provided for @featurePausedBody.
  ///
  /// In en, this message translates to:
  /// **'The PawSetu team has paused it. Please check again later.'**
  String get featurePausedBody;

  /// No description provided for @shopFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get shopFeatured;

  /// No description provided for @admUsers.
  ///
  /// In en, this message translates to:
  /// **'Users: {owners} pet parents, {partners} partners'**
  String admUsers(int owners, int partners);

  /// No description provided for @admPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get admPets;

  /// No description provided for @admBookings30.
  ///
  /// In en, this message translates to:
  /// **'Bookings, last 30 days'**
  String get admBookings30;

  /// No description provided for @admOrderValue30.
  ///
  /// In en, this message translates to:
  /// **'Order value, last 30 days'**
  String get admOrderValue30;

  /// No description provided for @admCommission30.
  ///
  /// In en, this message translates to:
  /// **'Commission earned, last 30 days'**
  String get admCommission30;

  /// No description provided for @admPlusMembers.
  ///
  /// In en, this message translates to:
  /// **'Plus members'**
  String get admPlusMembers;

  /// No description provided for @admSos30.
  ///
  /// In en, this message translates to:
  /// **'SOS activations, last 30 days'**
  String get admSos30;

  /// No description provided for @admByDay.
  ///
  /// In en, this message translates to:
  /// **'By day'**
  String get admByDay;

  /// No description provided for @admByWeek.
  ///
  /// In en, this message translates to:
  /// **'By week'**
  String get admByWeek;

  /// No description provided for @admByMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get admByMonth;

  /// No description provided for @admCommissionReport.
  ///
  /// In en, this message translates to:
  /// **'Commission report'**
  String get admCommissionReport;

  /// No description provided for @admNoNumbers.
  ///
  /// In en, this message translates to:
  /// **'No numbers yet'**
  String get admNoNumbers;

  /// No description provided for @admChartBookingsOrders.
  ///
  /// In en, this message translates to:
  /// **'Bookings and orders'**
  String get admChartBookingsOrders;

  /// No description provided for @admLegendBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get admLegendBookings;

  /// No description provided for @admLegendOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get admLegendOrders;

  /// No description provided for @admChartMoney.
  ///
  /// In en, this message translates to:
  /// **'Order value and commission'**
  String get admChartMoney;

  /// No description provided for @admLegendOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Order value'**
  String get admLegendOrderValue;

  /// No description provided for @admLegendCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get admLegendCommission;

  /// No description provided for @admChartGrowth.
  ///
  /// In en, this message translates to:
  /// **'New users, pets and Plus members'**
  String get admChartGrowth;

  /// No description provided for @admLegendUsers.
  ///
  /// In en, this message translates to:
  /// **'New users'**
  String get admLegendUsers;

  /// No description provided for @admLegendPets.
  ///
  /// In en, this message translates to:
  /// **'New pets'**
  String get admLegendPets;

  /// No description provided for @admLegendPlus.
  ///
  /// In en, this message translates to:
  /// **'New Plus'**
  String get admLegendPlus;

  /// No description provided for @admChartSos.
  ///
  /// In en, this message translates to:
  /// **'SOS activations'**
  String get admChartSos;

  /// No description provided for @admLegendSos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get admLegendSos;

  /// No description provided for @admTopClinics.
  ///
  /// In en, this message translates to:
  /// **'Top clinics'**
  String get admTopClinics;

  /// No description provided for @admTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top products'**
  String get admTopProducts;

  /// No description provided for @admBookingsUnit.
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get admBookingsUnit;

  /// No description provided for @admSoldUnit.
  ///
  /// In en, this message translates to:
  /// **'sold'**
  String get admSoldUnit;

  /// No description provided for @admChange.
  ///
  /// In en, this message translates to:
  /// **'{change}% vs before'**
  String admChange(String change);

  /// No description provided for @admNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get admNothingYet;

  /// No description provided for @admKindClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get admKindClinic;

  /// No description provided for @admStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get admStatusRejected;

  /// No description provided for @admStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get admStatusSuspended;

  /// No description provided for @admAllKinds.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admAllKinds;

  /// No description provided for @admWaitingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 waiting for review} other{{count} waiting for review}}'**
  String admWaitingCount(int count);

  /// No description provided for @admNoPending.
  ///
  /// In en, this message translates to:
  /// **'Nothing waiting for approval'**
  String get admNoPending;

  /// No description provided for @admNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get admNothingHere;

  /// No description provided for @admRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject {name}?'**
  String admRejectTitle(String name);

  /// No description provided for @admSuspendTitle.
  ///
  /// In en, this message translates to:
  /// **'Suspend {name}?'**
  String admSuspendTitle(String name);

  /// No description provided for @admReasonDocs.
  ///
  /// In en, this message translates to:
  /// **'Documents are unclear'**
  String get admReasonDocs;

  /// No description provided for @admReasonRegNo.
  ///
  /// In en, this message translates to:
  /// **'Registration number doesn\'t match'**
  String get admReasonRegNo;

  /// No description provided for @admReasonDetails.
  ///
  /// In en, this message translates to:
  /// **'Details are missing'**
  String get admReasonDetails;

  /// No description provided for @admApprovedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} approved'**
  String admApprovedToast(String name);

  /// No description provided for @admRejectedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} rejected'**
  String admRejectedToast(String name);

  /// No description provided for @admSuspendedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} suspended'**
  String admSuspendedToast(String name);

  /// No description provided for @admAppliedOn.
  ///
  /// In en, this message translates to:
  /// **'Applied {date}'**
  String admAppliedOn(String date);

  /// No description provided for @admRegNo.
  ///
  /// In en, this message translates to:
  /// **'Registration no.: {regNo}'**
  String admRegNo(String regNo);

  /// No description provided for @admRegMissing.
  ///
  /// In en, this message translates to:
  /// **'No registration number'**
  String get admRegMissing;

  /// No description provided for @admRegLooksRight.
  ///
  /// In en, this message translates to:
  /// **'Format looks right'**
  String get admRegLooksRight;

  /// No description provided for @admRegCheck.
  ///
  /// In en, this message translates to:
  /// **'Check this number'**
  String get admRegCheck;

  /// No description provided for @admRegHint.
  ///
  /// In en, this message translates to:
  /// **'Always check it against the State Veterinary Council register.'**
  String get admRegHint;

  /// No description provided for @admKycDocs.
  ///
  /// In en, this message translates to:
  /// **'KYC documents'**
  String get admKycDocs;

  /// No description provided for @admNoDocs.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded yet'**
  String get admNoDocs;

  /// No description provided for @admReasonGiven.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String admReasonGiven(String reason);

  /// No description provided for @admApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get admApprove;

  /// No description provided for @admReinstate.
  ///
  /// In en, this message translates to:
  /// **'Approve again'**
  String get admReinstate;

  /// No description provided for @admReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admReject;

  /// No description provided for @admSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get admSuspend;

  /// No description provided for @admSampleStamp.
  ///
  /// In en, this message translates to:
  /// **'SAMPLE'**
  String get admSampleStamp;

  /// No description provided for @admDocDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: sample documents only. Real KYC files open here in the live app.'**
  String get admDocDemoNote;

  /// No description provided for @admReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason (the partner sees this)'**
  String get admReasonLabel;

  /// No description provided for @admSearchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email, phone or city'**
  String get admSearchUsers;

  /// No description provided for @admFilterOwners.
  ///
  /// In en, this message translates to:
  /// **'Pet parents'**
  String get admFilterOwners;

  /// No description provided for @admFilterPartners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get admFilterPartners;

  /// No description provided for @admFilterAdmins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get admFilterAdmins;

  /// No description provided for @admPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String admPeopleCount(int count);

  /// No description provided for @plusTrialChip.
  ///
  /// In en, this message translates to:
  /// **'Plus trial'**
  String get plusTrialChip;

  /// No description provided for @admDeletionPending.
  ///
  /// In en, this message translates to:
  /// **'Deletion requested'**
  String get admDeletionPending;

  /// No description provided for @admRoleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Make {name} a {role}?'**
  String admRoleConfirm(String name, String role);

  /// No description provided for @admRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'Role changed. It applies the next time they open the app.'**
  String get admRoleChanged;

  /// No description provided for @admSuspendUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause {name}\'s account?'**
  String admSuspendUserTitle(String name);

  /// No description provided for @admReasonAbuse.
  ///
  /// In en, this message translates to:
  /// **'Abusive behaviour'**
  String get admReasonAbuse;

  /// No description provided for @admReasonFraud.
  ///
  /// In en, this message translates to:
  /// **'Payment fraud'**
  String get admReasonFraud;

  /// No description provided for @admReasonFake.
  ///
  /// In en, this message translates to:
  /// **'Fake account'**
  String get admReasonFake;

  /// No description provided for @admUserSuspended.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s account is paused'**
  String admUserSuspended(String name);

  /// No description provided for @admUserRestored.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s account is active again'**
  String admUserRestored(String name);

  /// No description provided for @admCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get admCity;

  /// No description provided for @admPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get admPlanLabel;

  /// No description provided for @admPlusTill.
  ///
  /// In en, this message translates to:
  /// **'Plus till {date}'**
  String admPlusTill(String date);

  /// No description provided for @admTrialTill.
  ///
  /// In en, this message translates to:
  /// **'Plus trial till {date}'**
  String admTrialTill(String date);

  /// No description provided for @admJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get admJoined;

  /// No description provided for @admDeletionOn.
  ///
  /// In en, this message translates to:
  /// **'Account will be deleted on {date}'**
  String admDeletionOn(String date);

  /// No description provided for @admNotYourself.
  ///
  /// In en, this message translates to:
  /// **'You can\'t change your own role or pause yourself.'**
  String get admNotYourself;

  /// No description provided for @admSaveRole.
  ///
  /// In en, this message translates to:
  /// **'Save role'**
  String get admSaveRole;

  /// No description provided for @admUnsuspend.
  ///
  /// In en, this message translates to:
  /// **'Make active again'**
  String get admUnsuspend;

  /// No description provided for @admSuspendUser.
  ///
  /// In en, this message translates to:
  /// **'Pause account'**
  String get admSuspendUser;

  /// No description provided for @admTabProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get admTabProducts;

  /// No description provided for @admTabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get admTabCategories;

  /// No description provided for @admTabPlaces.
  ///
  /// In en, this message translates to:
  /// **'Clinics and services'**
  String get admTabPlaces;

  /// No description provided for @admTabSellers.
  ///
  /// In en, this message translates to:
  /// **'Sellers'**
  String get admTabSellers;

  /// No description provided for @admTabPartners.
  ///
  /// In en, this message translates to:
  /// **'Partner shops'**
  String get admTabPartners;

  /// No description provided for @admTabBanners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get admTabBanners;

  /// No description provided for @admSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products, brands or sellers'**
  String get admSearchProducts;

  /// No description provided for @admFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get admFeatured;

  /// No description provided for @admHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get admHidden;

  /// No description provided for @admLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get admLowStock;

  /// No description provided for @admPartnerLinks.
  ///
  /// In en, this message translates to:
  /// **'Partner links'**
  String get admPartnerLinks;

  /// No description provided for @admShowingOf.
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total}. Search to narrow down.'**
  String admShowingOf(int shown, int total);

  /// No description provided for @admProductsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String admProductsCount(int count);

  /// No description provided for @admPartnerLink.
  ///
  /// In en, this message translates to:
  /// **'Partner link'**
  String get admPartnerLink;

  /// No description provided for @admStock.
  ///
  /// In en, this message translates to:
  /// **'Stock {count}'**
  String admStock(int count);

  /// No description provided for @admUnfeature.
  ///
  /// In en, this message translates to:
  /// **'Remove from featured'**
  String get admUnfeature;

  /// No description provided for @admFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature in the Shop'**
  String get admFeature;

  /// No description provided for @admShowInShop.
  ///
  /// In en, this message translates to:
  /// **'Show in the Shop'**
  String get admShowInShop;

  /// No description provided for @admCategoryNote.
  ///
  /// In en, this message translates to:
  /// **'Default margin: {food}% on food, {other}% on everything else. You can set a different margin for any category.'**
  String admCategoryNote(String food, String other);

  /// No description provided for @admMarginCustom.
  ///
  /// In en, this message translates to:
  /// **'Margin {pct}% (own rate)'**
  String admMarginCustom(String pct);

  /// No description provided for @admMarginDefault.
  ///
  /// In en, this message translates to:
  /// **'Margin {pct}% (default)'**
  String admMarginDefault(String pct);

  /// No description provided for @admMarginFor.
  ///
  /// In en, this message translates to:
  /// **'Margin for {name}'**
  String admMarginFor(String name);

  /// No description provided for @admEmptyDefault.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the default'**
  String get admEmptyDefault;

  /// No description provided for @admSellerNote.
  ///
  /// In en, this message translates to:
  /// **'Sellers are approved in Approvals. Here you can give a seller its own margin.'**
  String get admSellerNote;

  /// No description provided for @admMarginStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard margin'**
  String get admMarginStandard;

  /// No description provided for @admEditMargin.
  ///
  /// In en, this message translates to:
  /// **'Change rate'**
  String get admEditMargin;

  /// No description provided for @admPartnersNote.
  ///
  /// In en, this message translates to:
  /// **'Affiliate partner shops: people buy on the partner\'s own website and PawSetu earns a commission.'**
  String get admPartnersNote;

  /// No description provided for @admPartnerLine.
  ///
  /// In en, this message translates to:
  /// **'Commission {pct}% · {clicks} clicks'**
  String admPartnerLine(String pct, int clicks);

  /// No description provided for @admAddPartner.
  ///
  /// In en, this message translates to:
  /// **'Add partner shop'**
  String get admAddPartner;

  /// No description provided for @admPartnerName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get admPartnerName;

  /// No description provided for @admPartnerUrl.
  ///
  /// In en, this message translates to:
  /// **'Website (https://…)'**
  String get admPartnerUrl;

  /// No description provided for @admPartnerCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get admPartnerCommission;

  /// No description provided for @admBannersNote.
  ///
  /// In en, this message translates to:
  /// **'Banners show on Home or in the Shop. Only banners that are switched on are shown.'**
  String get admBannersNote;

  /// No description provided for @admPlaceShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get admPlaceShop;

  /// No description provided for @admPlaceHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get admPlaceHome;

  /// No description provided for @admBannerShown.
  ///
  /// In en, this message translates to:
  /// **'Show this banner'**
  String get admBannerShown;

  /// No description provided for @admNewBanner.
  ///
  /// In en, this message translates to:
  /// **'New banner'**
  String get admNewBanner;

  /// No description provided for @admEditBanner.
  ///
  /// In en, this message translates to:
  /// **'Edit banner'**
  String get admEditBanner;

  /// No description provided for @admBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get admBannerTitle;

  /// No description provided for @admBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Short text'**
  String get admBannerBody;

  /// No description provided for @admBannerLink.
  ///
  /// In en, this message translates to:
  /// **'Opens (app page)'**
  String get admBannerLink;

  /// No description provided for @admBannerLinkHelp.
  ///
  /// In en, this message translates to:
  /// **'For example /me/plus or /shop/search?q=food. Leave empty for no link.'**
  String get admBannerLinkHelp;

  /// No description provided for @admToneOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer (orange)'**
  String get admToneOffer;

  /// No description provided for @admToneNews.
  ///
  /// In en, this message translates to:
  /// **'News (green)'**
  String get admToneNews;

  /// No description provided for @admBannerAudience.
  ///
  /// In en, this message translates to:
  /// **'Who sees it'**
  String get admBannerAudience;

  /// No description provided for @admAudienceFree.
  ///
  /// In en, this message translates to:
  /// **'Free plan only'**
  String get admAudienceFree;

  /// No description provided for @admAudiencePlus.
  ///
  /// In en, this message translates to:
  /// **'Plus members only'**
  String get admAudiencePlus;

  /// No description provided for @admPlacesNote.
  ///
  /// In en, this message translates to:
  /// **'Booking commission for each clinic or provider. Empty means the rate for its type in Plans and settings.'**
  String get admPlacesNote;

  /// No description provided for @admRateCustom.
  ///
  /// In en, this message translates to:
  /// **'Commission {pct}% (own rate)'**
  String admRateCustom(String pct);

  /// No description provided for @admRateStandard.
  ///
  /// In en, this message translates to:
  /// **'Commission {pct}% (standard)'**
  String admRateStandard(String pct);

  /// No description provided for @admRateFor.
  ///
  /// In en, this message translates to:
  /// **'Commission for {name}'**
  String admRateFor(String name);

  /// No description provided for @hpStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get hpStatusOpen;

  /// No description provided for @hpStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get hpStatusInProgress;

  /// No description provided for @hpStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get hpStatusResolved;

  /// No description provided for @admNeedsReply.
  ///
  /// In en, this message translates to:
  /// **'Needs a reply'**
  String get admNeedsReply;

  /// No description provided for @admNotResolved.
  ///
  /// In en, this message translates to:
  /// **'Not resolved'**
  String get admNotResolved;

  /// No description provided for @admEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get admEveryone;

  /// No description provided for @admNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets here'**
  String get admNoTickets;

  /// No description provided for @hpSupportTeam.
  ///
  /// In en, this message translates to:
  /// **'PawSetu support'**
  String get hpSupportTeam;

  /// No description provided for @hpNewReply.
  ///
  /// In en, this message translates to:
  /// **'New reply'**
  String get hpNewReply;

  /// No description provided for @hpRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded {amount}'**
  String hpRefunded(String amount);

  /// No description provided for @admTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get admTicketTitle;

  /// No description provided for @admTicketMissing.
  ///
  /// In en, this message translates to:
  /// **'This ticket isn\'t available'**
  String get admTicketMissing;

  /// No description provided for @admAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get admAssignee;

  /// No description provided for @admUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get admUnassigned;

  /// No description provided for @admConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get admConversation;

  /// No description provided for @admReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Reply to {name}'**
  String admReplyHint(String name);

  /// No description provided for @admReplySent.
  ///
  /// In en, this message translates to:
  /// **'Reply sent. {name} gets a notification.'**
  String admReplySent(String name);

  /// No description provided for @admResolveAfter.
  ///
  /// In en, this message translates to:
  /// **'Mark as resolved after sending'**
  String get admResolveAfter;

  /// No description provided for @admLinkMissing.
  ///
  /// In en, this message translates to:
  /// **'The linked item can\'t be found ({type}).'**
  String admLinkMissing(String type);

  /// No description provided for @admOrderLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}} from {seller}'**
  String admOrderLine(int count, String seller);

  /// No description provided for @admTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {amount}'**
  String admTotal(String amount);

  /// No description provided for @admRefundDone.
  ///
  /// In en, this message translates to:
  /// **'Refunded {amount} on {date} (demo)'**
  String admRefundDone(String amount, String date);

  /// No description provided for @admRefundButton.
  ///
  /// In en, this message translates to:
  /// **'Refund (demo)'**
  String get admRefundButton;

  /// No description provided for @admRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund amount'**
  String get admRefundAmount;

  /// No description provided for @admRefundMax.
  ///
  /// In en, this message translates to:
  /// **'Up to {amount}, the amount paid'**
  String admRefundMax(String amount);

  /// No description provided for @admRefundConfirm.
  ///
  /// In en, this message translates to:
  /// **'Refund {amount} to {name}?'**
  String admRefundConfirm(String amount, String name);

  /// No description provided for @admRefundDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo refund'**
  String get admRefundDemoTitle;

  /// No description provided for @admRefundDemoBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is told that {amount} is refunded. This is a demo: no real money moved.'**
  String admRefundDemoBody(String amount, String name);

  /// No description provided for @hpRaisedOn.
  ///
  /// In en, this message translates to:
  /// **'Raised {date}'**
  String hpRaisedOn(String date);

  /// No description provided for @admAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String admAssignedTo(String name);

  /// No description provided for @hpWriteReply.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get hpWriteReply;

  /// No description provided for @hpTopicRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get hpTopicRefund;

  /// No description provided for @hpTopicLate.
  ///
  /// In en, this message translates to:
  /// **'Late or didn\'t come'**
  String get hpTopicLate;

  /// No description provided for @hpTopicQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality problem'**
  String get hpTopicQuality;

  /// No description provided for @hpTopicBehaviour.
  ///
  /// In en, this message translates to:
  /// **'Rude or unsafe behaviour'**
  String get hpTopicBehaviour;

  /// No description provided for @hpTopicApp.
  ///
  /// In en, this message translates to:
  /// **'App problem'**
  String get hpTopicApp;

  /// No description provided for @hpTopicOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get hpTopicOther;

  /// No description provided for @hpLinkBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get hpLinkBooking;

  /// No description provided for @hpLinkOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get hpLinkOrder;

  /// No description provided for @hpLinkChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get hpLinkChat;

  /// No description provided for @hpLinkOther.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get hpLinkOther;

  /// No description provided for @admReportsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open ({count})'**
  String admReportsOpen(int count);

  /// No description provided for @admReportsClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get admReportsClosed;

  /// No description provided for @admNoReports.
  ///
  /// In en, this message translates to:
  /// **'No reports to review'**
  String get admNoReports;

  /// No description provided for @admReviewHidden.
  ///
  /// In en, this message translates to:
  /// **'Review hidden'**
  String get admReviewHidden;

  /// No description provided for @admReviewRestored.
  ///
  /// In en, this message translates to:
  /// **'Review shown again'**
  String get admReviewRestored;

  /// No description provided for @admReportHandled.
  ///
  /// In en, this message translates to:
  /// **'Marked as handled'**
  String get admReportHandled;

  /// No description provided for @admReportDismissed.
  ///
  /// In en, this message translates to:
  /// **'Report dismissed'**
  String get admReportDismissed;

  /// No description provided for @admReportReview.
  ///
  /// In en, this message translates to:
  /// **'Reported review'**
  String get admReportReview;

  /// No description provided for @admReportChat.
  ///
  /// In en, this message translates to:
  /// **'Reported chat'**
  String get admReportChat;

  /// No description provided for @admReportContent.
  ///
  /// In en, this message translates to:
  /// **'Reported content'**
  String get admReportContent;

  /// No description provided for @admReporterSays.
  ///
  /// In en, this message translates to:
  /// **'Reporter says: {text}'**
  String admReporterSays(String text);

  /// No description provided for @admReportedBy.
  ///
  /// In en, this message translates to:
  /// **'Reported by {name}'**
  String admReportedBy(String name);

  /// No description provided for @admClosedOn.
  ///
  /// In en, this message translates to:
  /// **'closed {date}'**
  String admClosedOn(String date);

  /// No description provided for @admHideReview.
  ///
  /// In en, this message translates to:
  /// **'Hide review'**
  String get admHideReview;

  /// No description provided for @admMarkHandled.
  ///
  /// In en, this message translates to:
  /// **'Mark as handled'**
  String get admMarkHandled;

  /// No description provided for @admDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get admDismiss;

  /// No description provided for @admRestoreReview.
  ///
  /// In en, this message translates to:
  /// **'Show review again'**
  String get admRestoreReview;

  /// No description provided for @admSearchOutbox.
  ///
  /// In en, this message translates to:
  /// **'Search by phone, email or text'**
  String get admSearchOutbox;

  /// No description provided for @admAllCount.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String admAllCount(int count);

  /// No description provided for @admChannelSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get admChannelSms;

  /// No description provided for @admChannelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get admChannelWhatsapp;

  /// No description provided for @admChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admChannelEmail;

  /// No description provided for @admChannelPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get admChannelPush;

  /// No description provided for @admAuditNote.
  ///
  /// In en, this message translates to:
  /// **'Every change made in the admin panel, newest first.'**
  String get admAuditNote;

  /// No description provided for @admSearchAudit.
  ///
  /// In en, this message translates to:
  /// **'Search by person, action or item'**
  String get admSearchAudit;

  /// No description provided for @admActApprove.
  ///
  /// In en, this message translates to:
  /// **'Approved a partner'**
  String get admActApprove;

  /// No description provided for @admActReject.
  ///
  /// In en, this message translates to:
  /// **'Rejected a partner'**
  String get admActReject;

  /// No description provided for @admActSuspendPartner.
  ///
  /// In en, this message translates to:
  /// **'Suspended a partner'**
  String get admActSuspendPartner;

  /// No description provided for @admActSuspendUser.
  ///
  /// In en, this message translates to:
  /// **'Paused an account'**
  String get admActSuspendUser;

  /// No description provided for @admActUnsuspendUser.
  ///
  /// In en, this message translates to:
  /// **'Made an account active again'**
  String get admActUnsuspendUser;

  /// No description provided for @admActRole.
  ///
  /// In en, this message translates to:
  /// **'Changed a role'**
  String get admActRole;

  /// No description provided for @admActTicketReply.
  ///
  /// In en, this message translates to:
  /// **'Replied to a ticket'**
  String get admActTicketReply;

  /// No description provided for @admActTicketStatus.
  ///
  /// In en, this message translates to:
  /// **'Changed a ticket\'s status'**
  String get admActTicketStatus;

  /// No description provided for @admActTicketAssign.
  ///
  /// In en, this message translates to:
  /// **'Assigned a ticket'**
  String get admActTicketAssign;

  /// No description provided for @admActRefund.
  ///
  /// In en, this message translates to:
  /// **'Gave a demo refund'**
  String get admActRefund;

  /// No description provided for @admActHide.
  ///
  /// In en, this message translates to:
  /// **'Hid a review'**
  String get admActHide;

  /// No description provided for @admActRestore.
  ///
  /// In en, this message translates to:
  /// **'Showed a review again'**
  String get admActRestore;

  /// No description provided for @admActDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismissed a report'**
  String get admActDismiss;

  /// No description provided for @admActHandled.
  ///
  /// In en, this message translates to:
  /// **'Handled a report'**
  String get admActHandled;

  /// No description provided for @admActCouponNew.
  ///
  /// In en, this message translates to:
  /// **'Created a coupon'**
  String get admActCouponNew;

  /// No description provided for @admActCouponEdit.
  ///
  /// In en, this message translates to:
  /// **'Changed a coupon'**
  String get admActCouponEdit;

  /// No description provided for @admActProduct.
  ///
  /// In en, this message translates to:
  /// **'Changed a product'**
  String get admActProduct;

  /// No description provided for @admActBannerNew.
  ///
  /// In en, this message translates to:
  /// **'Created a banner'**
  String get admActBannerNew;

  /// No description provided for @admActBannerEdit.
  ///
  /// In en, this message translates to:
  /// **'Changed a banner'**
  String get admActBannerEdit;

  /// No description provided for @admActSeller.
  ///
  /// In en, this message translates to:
  /// **'Changed a seller'**
  String get admActSeller;

  /// No description provided for @admActPartnerStore.
  ///
  /// In en, this message translates to:
  /// **'Changed a partner shop'**
  String get admActPartnerStore;

  /// No description provided for @admActPlace.
  ///
  /// In en, this message translates to:
  /// **'Changed a clinic or provider'**
  String get admActPlace;

  /// No description provided for @admActSettings.
  ///
  /// In en, this message translates to:
  /// **'Changed settings'**
  String get admActSettings;

  /// No description provided for @admSettingsNote.
  ///
  /// In en, this message translates to:
  /// **'Changes reach the app straight away, no update needed.'**
  String get admSettingsNote;

  /// No description provided for @admLastChanged.
  ///
  /// In en, this message translates to:
  /// **'Last changed {when}.'**
  String admLastChanged(String when);

  /// No description provided for @admPlanPrices.
  ///
  /// In en, this message translates to:
  /// **'Plan prices'**
  String get admPlanPrices;

  /// No description provided for @admPlusMonthly.
  ///
  /// In en, this message translates to:
  /// **'Plus, monthly'**
  String get admPlusMonthly;

  /// No description provided for @admPlusYearly.
  ///
  /// In en, this message translates to:
  /// **'Plus, yearly'**
  String get admPlusYearly;

  /// No description provided for @admTrialDays.
  ///
  /// In en, this message translates to:
  /// **'Free trial'**
  String get admTrialDays;

  /// No description provided for @admDaysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get admDaysUnit;

  /// No description provided for @admPlanLimits.
  ///
  /// In en, this message translates to:
  /// **'Plan limits'**
  String get admPlanLimits;

  /// No description provided for @admBookingCommission.
  ///
  /// In en, this message translates to:
  /// **'Booking commission'**
  String get admBookingCommission;

  /// No description provided for @admDefaultRate.
  ///
  /// In en, this message translates to:
  /// **'Default rate'**
  String get admDefaultRate;

  /// No description provided for @admRateClinic.
  ///
  /// In en, this message translates to:
  /// **'Vet clinics'**
  String get admRateClinic;

  /// No description provided for @admRateGroomer.
  ///
  /// In en, this message translates to:
  /// **'Groomers'**
  String get admRateGroomer;

  /// No description provided for @admRateTrainer.
  ///
  /// In en, this message translates to:
  /// **'Trainers'**
  String get admRateTrainer;

  /// No description provided for @admRateBoarder.
  ///
  /// In en, this message translates to:
  /// **'Boarding and sitting'**
  String get admRateBoarder;

  /// No description provided for @admRateWalker.
  ///
  /// In en, this message translates to:
  /// **'Dog walkers'**
  String get admRateWalker;

  /// No description provided for @admProviderRateNote.
  ///
  /// In en, this message translates to:
  /// **'A clinic or provider can also have its own rate: Catalogue → Clinics and services.'**
  String get admProviderRateNote;

  /// No description provided for @admShopMoney.
  ///
  /// In en, this message translates to:
  /// **'Shop margins and delivery'**
  String get admShopMoney;

  /// No description provided for @admFoodMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin on food'**
  String get admFoodMargin;

  /// No description provided for @admOtherMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin on other items'**
  String get admOtherMargin;

  /// No description provided for @admVideoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Plus discount on video vet fees'**
  String get admVideoDiscount;

  /// No description provided for @admDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get admDeliveryFee;

  /// No description provided for @admFreeDeliveryFree.
  ///
  /// In en, this message translates to:
  /// **'Free delivery above (Free plan)'**
  String get admFreeDeliveryFree;

  /// No description provided for @admFreeDeliveryPlus.
  ///
  /// In en, this message translates to:
  /// **'Free delivery above (Plus)'**
  String get admFreeDeliveryPlus;

  /// No description provided for @admFeatureFlags.
  ///
  /// In en, this message translates to:
  /// **'Feature switches'**
  String get admFeatureFlags;

  /// No description provided for @admReferrals.
  ///
  /// In en, this message translates to:
  /// **'Referrals'**
  String get admReferrals;

  /// No description provided for @admReferralReward.
  ///
  /// In en, this message translates to:
  /// **'Reward for each friend'**
  String get admReferralReward;

  /// No description provided for @admCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get admCoupons;

  /// No description provided for @admNewCoupon.
  ///
  /// In en, this message translates to:
  /// **'New coupon'**
  String get admNewCoupon;

  /// No description provided for @admVaccineSchedules.
  ///
  /// In en, this message translates to:
  /// **'Vaccine schedules'**
  String get admVaccineSchedules;

  /// No description provided for @admVaccineNote.
  ///
  /// In en, this message translates to:
  /// **'Indicative timings. Change a timing after a vet has reviewed it; every pet\'s schedule updates.'**
  String get admVaccineNote;

  /// No description provided for @admContentReview.
  ///
  /// In en, this message translates to:
  /// **'Vet review of content'**
  String get admContentReview;

  /// No description provided for @admContentReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Until a vet reviews it, this content shows \"Draft, to be reviewed by a vet\".'**
  String get admContentReviewNote;

  /// No description provided for @admUsesDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get admUsesDefault;

  /// No description provided for @admSavedLive.
  ///
  /// In en, this message translates to:
  /// **'Saved. The app uses the new value now.'**
  String get admSavedLive;

  /// No description provided for @admLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get admLimit;

  /// No description provided for @admLimitPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get admLimitPets;

  /// No description provided for @admLimitFamily.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get admLimitFamily;

  /// No description provided for @admLimitTeleVet.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet chats a month'**
  String get admLimitTeleVet;

  /// No description provided for @admLimitMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages per tele-vet chat'**
  String get admLimitMessages;

  /// No description provided for @admLimitWords.
  ///
  /// In en, this message translates to:
  /// **'Words per message'**
  String get admLimitWords;

  /// No description provided for @admLimitHours.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet chat open for'**
  String get admLimitHours;

  /// No description provided for @admLimitAi.
  ///
  /// In en, this message translates to:
  /// **'Ask PawSetu questions a month'**
  String get admLimitAi;

  /// No description provided for @admLimitStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get admLimitStorage;

  /// No description provided for @admLimitVideo.
  ///
  /// In en, this message translates to:
  /// **'Video length'**
  String get admLimitVideo;

  /// No description provided for @admHoursUnit.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get admHoursUnit;

  /// No description provided for @admSecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get admSecondsUnit;

  /// No description provided for @admUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get admUnlimited;

  /// No description provided for @admUnlimitedNote.
  ///
  /// In en, this message translates to:
  /// **'999 or more means unlimited.'**
  String get admUnlimitedNote;

  /// No description provided for @admFlagAi.
  ///
  /// In en, this message translates to:
  /// **'Ask PawSetu'**
  String get admFlagAi;

  /// No description provided for @admFlagAiHint.
  ///
  /// In en, this message translates to:
  /// **'The AI pet assistant'**
  String get admFlagAiHint;

  /// No description provided for @admFlagDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected devices'**
  String get admFlagDevices;

  /// No description provided for @admFlagDevicesHint.
  ///
  /// In en, this message translates to:
  /// **'Collars, feeders and other smart devices'**
  String get admFlagDevicesHint;

  /// No description provided for @admFlagLost.
  ///
  /// In en, this message translates to:
  /// **'Lost pet alerts nearby'**
  String get admFlagLost;

  /// No description provided for @admFlagLostHint.
  ///
  /// In en, this message translates to:
  /// **'Alerts to app users within 5 km'**
  String get admFlagLostHint;

  /// No description provided for @admFlagReferrals.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend'**
  String get admFlagReferrals;

  /// No description provided for @admFlagReferralsHint.
  ///
  /// In en, this message translates to:
  /// **'Referral codes and rewards'**
  String get admFlagReferralsHint;

  /// No description provided for @admCouponPercent.
  ///
  /// In en, this message translates to:
  /// **'{pct}% off up to {max}'**
  String admCouponPercent(int pct, String max);

  /// No description provided for @admCouponFlat.
  ///
  /// In en, this message translates to:
  /// **'{amount} off'**
  String admCouponFlat(String amount);

  /// No description provided for @admCouponMin.
  ///
  /// In en, this message translates to:
  /// **'min. order {amount}'**
  String admCouponMin(String amount);

  /// No description provided for @admCouponTill.
  ///
  /// In en, this message translates to:
  /// **'till {date}'**
  String admCouponTill(String date);

  /// No description provided for @admCouponUses.
  ///
  /// In en, this message translates to:
  /// **'used {used} of {max}'**
  String admCouponUses(int used, int max);

  /// No description provided for @admCouponActive.
  ///
  /// In en, this message translates to:
  /// **'Coupon on'**
  String get admCouponActive;

  /// No description provided for @admPersonalCoupons.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 personal referral coupon is not shown.} other{{count} personal referral coupons are not shown.}}'**
  String admPersonalCoupons(int count);

  /// No description provided for @admCouponCodeHelp.
  ///
  /// In en, this message translates to:
  /// **'4 to 16 letters or digits, for example DIWALI20'**
  String get admCouponCodeHelp;

  /// No description provided for @admCouponDescription.
  ///
  /// In en, this message translates to:
  /// **'Description people see'**
  String get admCouponDescription;

  /// No description provided for @admCouponTypePercent.
  ///
  /// In en, this message translates to:
  /// **'Percent off'**
  String get admCouponTypePercent;

  /// No description provided for @admCouponTypeFlat.
  ///
  /// In en, this message translates to:
  /// **'Amount off'**
  String get admCouponTypeFlat;

  /// No description provided for @admCouponPercentOff.
  ///
  /// In en, this message translates to:
  /// **'Percent off'**
  String get admCouponPercentOff;

  /// No description provided for @admCouponAmountOff.
  ///
  /// In en, this message translates to:
  /// **'Amount off'**
  String get admCouponAmountOff;

  /// No description provided for @admCouponMaxDiscount.
  ///
  /// In en, this message translates to:
  /// **'Maximum discount'**
  String get admCouponMaxDiscount;

  /// No description provided for @admCouponMinOrder.
  ///
  /// In en, this message translates to:
  /// **'Minimum order'**
  String get admCouponMinOrder;

  /// No description provided for @admCouponMaxUses.
  ///
  /// In en, this message translates to:
  /// **'How many times it can be used'**
  String get admCouponMaxUses;

  /// No description provided for @admCouponValidTill.
  ///
  /// In en, this message translates to:
  /// **'Valid till'**
  String get admCouponValidTill;

  /// No description provided for @admDogSchedule.
  ///
  /// In en, this message translates to:
  /// **'Dogs'**
  String get admDogSchedule;

  /// No description provided for @admCatSchedule.
  ///
  /// In en, this message translates to:
  /// **'Cats'**
  String get admCatSchedule;

  /// No description provided for @admAskVetTiming.
  ///
  /// In en, this message translates to:
  /// **'Optional, timing as the vet advises'**
  String get admAskVetTiming;

  /// No description provided for @admEveryYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every year} other{Every {count} years}}'**
  String admEveryYears(int count);

  /// No description provided for @admWeeksRange.
  ///
  /// In en, this message translates to:
  /// **'Age {from} to {to} weeks'**
  String admWeeksRange(int from, int to);

  /// No description provided for @admBoosterEvery.
  ///
  /// In en, this message translates to:
  /// **'{name} booster: every how many years?'**
  String admBoosterEvery(String name);

  /// No description provided for @admYearsUnit.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get admYearsUnit;

  /// No description provided for @admFromWeek.
  ///
  /// In en, this message translates to:
  /// **'{name}: from which week of age?'**
  String admFromWeek(String name);

  /// No description provided for @admToWeek.
  ///
  /// In en, this message translates to:
  /// **'{name}: up to which week of age?'**
  String admToWeek(String name);

  /// No description provided for @admWeeksUnit.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get admWeeksUnit;

  /// No description provided for @admAreaFirstAid.
  ///
  /// In en, this message translates to:
  /// **'First-aid guides'**
  String get admAreaFirstAid;

  /// No description provided for @admAreaToxic.
  ///
  /// In en, this message translates to:
  /// **'Toxic food and plant checker'**
  String get admAreaToxic;

  /// No description provided for @admAreaVaccines.
  ///
  /// In en, this message translates to:
  /// **'Vaccine schedules'**
  String get admAreaVaccines;

  /// No description provided for @admDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get admDraft;

  /// No description provided for @admReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get admReviewed;

  /// No description provided for @admReviewSheetNote.
  ///
  /// In en, this message translates to:
  /// **'Enter the name and registration number of the vet who checked this content.'**
  String get admReviewSheetNote;

  /// No description provided for @admReviewerName.
  ///
  /// In en, this message translates to:
  /// **'Vet\'s name and registration no.'**
  String get admReviewerName;

  /// No description provided for @admMarkReviewed.
  ///
  /// In en, this message translates to:
  /// **'Mark as reviewed'**
  String get admMarkReviewed;

  /// No description provided for @admBackToDraft.
  ///
  /// In en, this message translates to:
  /// **'Back to draft'**
  String get admBackToDraft;

  /// No description provided for @admKindShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get admKindShop;

  /// No description provided for @admKindBooking.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get admKindBooking;

  /// No description provided for @admDownloadCsv.
  ///
  /// In en, this message translates to:
  /// **'Download CSV'**
  String get admDownloadCsv;

  /// No description provided for @admColPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get admColPartner;

  /// No description provided for @admColType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get admColType;

  /// No description provided for @admColCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get admColCount;

  /// No description provided for @admColGross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get admColGross;

  /// No description provided for @admColCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get admColCommission;

  /// No description provided for @admColPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get admColPayout;

  /// No description provided for @admBookingCommissionShort.
  ///
  /// In en, this message translates to:
  /// **'Booking commission'**
  String get admBookingCommissionShort;

  /// No description provided for @admShopMargin.
  ///
  /// In en, this message translates to:
  /// **'Shop margin'**
  String get admShopMargin;

  /// No description provided for @admPlusRevenue.
  ///
  /// In en, this message translates to:
  /// **'Plus payments'**
  String get admPlusRevenue;

  /// No description provided for @admRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get admRefunds;

  /// No description provided for @admPlatformTotal.
  ///
  /// In en, this message translates to:
  /// **'PawSetu earned'**
  String get admPlatformTotal;

  /// No description provided for @admReportDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo money: all payments in Version 1 are simulated. Tax fields are placeholders.'**
  String get admReportDemoNote;

  /// No description provided for @admByPartner.
  ///
  /// In en, this message translates to:
  /// **'By partner'**
  String get admByPartner;

  /// No description provided for @admLineCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sale} other{{count} sales}}'**
  String admLineCount(int count);

  /// No description provided for @admNoteApproved.
  ///
  /// In en, this message translates to:
  /// **'{name} is approved and now visible to pet parents'**
  String admNoteApproved(String name);

  /// No description provided for @admNoteRejected.
  ///
  /// In en, this message translates to:
  /// **'{name} was not approved'**
  String admNoteRejected(String name);

  /// No description provided for @admNoteSuspended.
  ///
  /// In en, this message translates to:
  /// **'{name} is paused'**
  String admNoteSuspended(String name);

  /// No description provided for @hpReplyTitle.
  ///
  /// In en, this message translates to:
  /// **'Support replied: {subject}'**
  String hpReplyTitle(String subject);

  /// No description provided for @hpResolvedTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolved: {subject}'**
  String hpResolvedTitle(String subject);

  /// No description provided for @hpRefundTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund of ₹{amount} is on its way'**
  String hpRefundTitle(int amount);

  /// No description provided for @hpRefundBody.
  ///
  /// In en, this message translates to:
  /// **'Demo refund: no real money moved.'**
  String get hpRefundBody;

  /// No description provided for @hpNewForSupport.
  ///
  /// In en, this message translates to:
  /// **'New message from {name}'**
  String hpNewForSupport(String name);

  /// No description provided for @hpIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help'**
  String get hpIntroTitle;

  /// No description provided for @hpIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Raise a complaint or question about a booking, order or chat. We usually reply within a day.'**
  String get hpIntroBody;

  /// No description provided for @hpIntroPlus.
  ///
  /// In en, this message translates to:
  /// **'Plus members get priority support: we usually reply within 4 hours.'**
  String get hpIntroPlus;

  /// No description provided for @hpRaise.
  ///
  /// In en, this message translates to:
  /// **'Raise a complaint'**
  String get hpRaise;

  /// No description provided for @hpYourTickets.
  ///
  /// In en, this message translates to:
  /// **'Your tickets'**
  String get hpYourTickets;

  /// No description provided for @hpNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet. If something goes wrong, tell us here.'**
  String get hpNoTickets;

  /// No description provided for @hpQuickAnswers.
  ///
  /// In en, this message translates to:
  /// **'Quick answers'**
  String get hpQuickAnswers;

  /// No description provided for @hpFaqRefundQ.
  ///
  /// In en, this message translates to:
  /// **'How do refunds work?'**
  String get hpFaqRefundQ;

  /// No description provided for @hpFaqRefundA.
  ///
  /// In en, this message translates to:
  /// **'If you paid online and cancel in time, the money goes back to the same payment method in 5 to 7 working days. For other problems, raise a complaint and we\'ll check.'**
  String get hpFaqRefundA;

  /// No description provided for @hpFaqCancelQ.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel a booking?'**
  String get hpFaqCancelQ;

  /// No description provided for @hpFaqCancelA.
  ///
  /// In en, this message translates to:
  /// **'Open Book, then My bookings. Choose the booking and tap Cancel booking. The clinic\'s cancellation time is shown there.'**
  String get hpFaqCancelA;

  /// No description provided for @hpFaqUrgentQ.
  ///
  /// In en, this message translates to:
  /// **'My pet needs help right now'**
  String get hpFaqUrgentQ;

  /// No description provided for @hpFaqUrgentA.
  ///
  /// In en, this message translates to:
  /// **'Use the red SOS button on Home: hold it for 2 seconds to reach the nearest clinic. Don\'t wait for a reply here.'**
  String get hpFaqUrgentA;

  /// No description provided for @hpFaqDataQ.
  ///
  /// In en, this message translates to:
  /// **'How do I get or delete my data?'**
  String get hpFaqDataQ;

  /// No description provided for @hpFaqDataA.
  ///
  /// In en, this message translates to:
  /// **'Go to Me, then Privacy centre, to download your data or delete your account.'**
  String get hpFaqDataA;

  /// No description provided for @hpAbout.
  ///
  /// In en, this message translates to:
  /// **'What is it about?'**
  String get hpAbout;

  /// No description provided for @hpPickItem.
  ///
  /// In en, this message translates to:
  /// **'Choose a booking or order'**
  String get hpPickItem;

  /// No description provided for @hpSomethingElse.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get hpSomethingElse;

  /// No description provided for @hpTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get hpTopic;

  /// No description provided for @hpSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get hpSubject;

  /// No description provided for @hpDetails.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get hpDetails;

  /// No description provided for @hpDetailsHelp.
  ///
  /// In en, this message translates to:
  /// **'At least 10 characters. Add dates, names and amounts if you can.'**
  String get hpDetailsHelp;

  /// No description provided for @hpSend.
  ///
  /// In en, this message translates to:
  /// **'Send to support'**
  String get hpSend;

  /// No description provided for @hpSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to PawSetu support'**
  String get hpSent;

  /// No description provided for @hpReplyTime.
  ///
  /// In en, this message translates to:
  /// **'We usually reply within a day.'**
  String get hpReplyTime;

  /// No description provided for @hpReplyTimePlus.
  ///
  /// In en, this message translates to:
  /// **'Plus priority support: we usually reply within 4 hours.'**
  String get hpReplyTimePlus;

  /// No description provided for @hpTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ticket'**
  String get hpTicketTitle;

  /// No description provided for @hpResolvedNote.
  ///
  /// In en, this message translates to:
  /// **'Marked as resolved. Reply below if you still need help.'**
  String get hpResolvedNote;

  /// No description provided for @hpReopenHint.
  ///
  /// In en, this message translates to:
  /// **'Still need help? Write here to reopen'**
  String get hpReopenHint;

  /// No description provided for @hpGetHelpBooking.
  ///
  /// In en, this message translates to:
  /// **'Get help with this booking'**
  String get hpGetHelpBooking;

  /// No description provided for @plusTrialStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your free trial has started'**
  String get plusTrialStartedTitle;

  /// No description provided for @plusTrialStartedBody.
  ///
  /// In en, this message translates to:
  /// **'You have every Plus feature for {days} days, till {date}. Demo: nothing is charged.'**
  String plusTrialStartedBody(int days, String date);

  /// No description provided for @plusTrialUsed.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already used your free trial.'**
  String get plusTrialUsed;

  /// No description provided for @plusPayYearly.
  ///
  /// In en, this message translates to:
  /// **'PawSetu Plus, 1 year'**
  String get plusPayYearly;

  /// No description provided for @plusPayMonthly.
  ///
  /// In en, this message translates to:
  /// **'PawSetu Plus, 1 month'**
  String get plusPayMonthly;

  /// No description provided for @plusWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PawSetu Plus!'**
  String get plusWelcomeTitle;

  /// No description provided for @plusWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Plus is on. It renews on {date}. This was a demo payment: no money moved.'**
  String plusWelcomeBody(String date);

  /// No description provided for @plusKeepAfterTrial.
  ///
  /// In en, this message translates to:
  /// **'Keep Plus after your trial'**
  String get plusKeepAfterTrial;

  /// No description provided for @plusChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get plusChoosePlan;

  /// No description provided for @plusBuy.
  ///
  /// In en, this message translates to:
  /// **'Get Plus for {amount}'**
  String plusBuy(String amount);

  /// No description provided for @plusStartsAfterTrial.
  ///
  /// In en, this message translates to:
  /// **'Your paid plan starts when the trial ends on {date}.'**
  String plusStartsAfterTrial(String date);

  /// No description provided for @plusStartTrial.
  ///
  /// In en, this message translates to:
  /// **'Start {days}-day free trial'**
  String plusStartTrial(int days);

  /// No description provided for @plusTrialNote.
  ///
  /// In en, this message translates to:
  /// **'Free for {days} days. No card needed in the demo.'**
  String plusTrialNote(int days);

  /// No description provided for @plusAutoRenew.
  ///
  /// In en, this message translates to:
  /// **'Renew automatically'**
  String get plusAutoRenew;

  /// No description provided for @plusAutoRenewOn.
  ///
  /// In en, this message translates to:
  /// **'Renews on {date}'**
  String plusAutoRenewOn(String date);

  /// No description provided for @plusAutoRenewOff.
  ///
  /// In en, this message translates to:
  /// **'Plus stays till {date}, then you move to Free'**
  String plusAutoRenewOff(String date);

  /// No description provided for @plusDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: no money is charged and nothing renews for real.'**
  String get plusDemoNote;

  /// No description provided for @plusOnTrial.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Plus trial ends today} =1{Plus trial: 1 day left} other{Plus trial: {days} days left}}'**
  String plusOnTrial(int days);

  /// No description provided for @plusTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Your trial ends on {date}.'**
  String plusTrialEnds(String date);

  /// No description provided for @plusYouHavePlus.
  ///
  /// In en, this message translates to:
  /// **'You have PawSetu Plus'**
  String get plusYouHavePlus;

  /// No description provided for @plusRenewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews on {date}'**
  String plusRenewsOn(String date);

  /// No description provided for @plusEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends on {date}'**
  String plusEndsOn(String date);

  /// No description provided for @plusYouAreFree.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the Free plan'**
  String get plusYouAreFree;

  /// No description provided for @plusFreeBody.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for video vet calls, unlimited pets and more.'**
  String get plusFreeBody;

  /// No description provided for @plusMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String plusMinutes(int count);

  /// No description provided for @plusSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} sec'**
  String plusSeconds(int count);

  /// No description provided for @plusRowPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get plusRowPets;

  /// No description provided for @plusRowFamily.
  ///
  /// In en, this message translates to:
  /// **'Family members'**
  String get plusRowFamily;

  /// No description provided for @plusRowVideo.
  ///
  /// In en, this message translates to:
  /// **'Video vet calls'**
  String get plusRowVideo;

  /// No description provided for @plusRowTeleVet.
  ///
  /// In en, this message translates to:
  /// **'Tele-vet chats'**
  String get plusRowTeleVet;

  /// No description provided for @plusRowMessages.
  ///
  /// In en, this message translates to:
  /// **'Chat length'**
  String get plusRowMessages;

  /// No description provided for @plusRowAi.
  ///
  /// In en, this message translates to:
  /// **'Ask PawSetu'**
  String get plusRowAi;

  /// No description provided for @plusRowStorage.
  ///
  /// In en, this message translates to:
  /// **'Photo and document storage'**
  String get plusRowStorage;

  /// No description provided for @plusRowVideoLength.
  ///
  /// In en, this message translates to:
  /// **'Video length in album'**
  String get plusRowVideoLength;

  /// No description provided for @plusRowVideoDiscount.
  ///
  /// In en, this message translates to:
  /// **'Off vet video fees'**
  String get plusRowVideoDiscount;

  /// No description provided for @plusRowDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free delivery'**
  String get plusRowDelivery;

  /// No description provided for @plusRowSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get plusRowSupport;

  /// No description provided for @plusYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get plusYes;

  /// No description provided for @plusPerMonth.
  ///
  /// In en, this message translates to:
  /// **'{value} a month'**
  String plusPerMonth(String value);

  /// No description provided for @plusMessagesWords.
  ///
  /// In en, this message translates to:
  /// **'{messages} messages, {words} words each'**
  String plusMessagesWords(String messages, String words);

  /// No description provided for @plusAbove.
  ///
  /// In en, this message translates to:
  /// **'above {amount}'**
  String plusAbove(String amount);

  /// No description provided for @plusStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get plusStandard;

  /// No description provided for @plusPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get plusPriority;

  /// No description provided for @plusYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get plusYearly;

  /// No description provided for @plusMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get plusMonthly;

  /// No description provided for @plusPerYear.
  ///
  /// In en, this message translates to:
  /// **'a year'**
  String get plusPerYear;

  /// No description provided for @plusPerMonthPrice.
  ///
  /// In en, this message translates to:
  /// **'a month'**
  String get plusPerMonthPrice;

  /// No description provided for @plusSave.
  ///
  /// In en, this message translates to:
  /// **'Save {pct}%'**
  String plusSave(int pct);

  /// No description provided for @plusTrialEndingSoon.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Your Plus trial ends today. Choose a plan to keep Plus.} =1{Your Plus trial ends tomorrow. Choose a plan to keep Plus.} other{Your Plus trial ends in {days} days. Choose a plan to keep Plus.}}'**
  String plusTrialEndingSoon(int days);

  /// No description provided for @referTitle.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend'**
  String get referTitle;

  /// No description provided for @referInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t valid, or you\'ve already used a code.'**
  String get referInvalid;

  /// No description provided for @referDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Code applied!'**
  String get referDoneTitle;

  /// No description provided for @referDoneBody.
  ///
  /// In en, this message translates to:
  /// **'You and your friend each get {amount} off. Your coupon: {code}. Use it in the Shop at checkout.'**
  String referDoneBody(String amount, String code);

  /// No description provided for @referPaused.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend is paused right now.'**
  String get referPaused;

  /// No description provided for @referHeadline.
  ///
  /// In en, this message translates to:
  /// **'Give {amount}, get {amount}'**
  String referHeadline(String amount);

  /// No description provided for @referBody.
  ///
  /// In en, this message translates to:
  /// **'When a friend joins PawSetu with your code, you both get a {amount} Shop coupon.'**
  String referBody(String amount);

  /// No description provided for @referYourCode.
  ///
  /// In en, this message translates to:
  /// **'Your code'**
  String get referYourCode;

  /// No description provided for @referShareText.
  ///
  /// In en, this message translates to:
  /// **'Join me on PawSetu, the app for pet parents! Use my code {code} and we both get {amount} off in the PawSetu Shop.'**
  String referShareText(String code, String amount);

  /// No description provided for @referFriendsJoined.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No friends have joined with your code yet} =1{1 friend joined with your code} other{{count} friends joined with your code}}'**
  String referFriendsJoined(int count);

  /// No description provided for @referHaveCode.
  ///
  /// In en, this message translates to:
  /// **'Got a friend\'s code?'**
  String get referHaveCode;

  /// No description provided for @referEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s code'**
  String get referEnterCode;

  /// No description provided for @referApply.
  ///
  /// In en, this message translates to:
  /// **'Apply code'**
  String get referApply;

  /// No description provided for @referYourRewards.
  ///
  /// In en, this message translates to:
  /// **'Your reward coupons'**
  String get referYourRewards;

  /// No description provided for @referCouponLine.
  ///
  /// In en, this message translates to:
  /// **'{amount} off orders above {min}, till {date}'**
  String referCouponLine(String amount, String min, String date);

  /// No description provided for @referUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get referUsed;

  /// No description provided for @referDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: coupons work in the demo Shop. No real money.'**
  String get referDemoNote;

  /// No description provided for @prvExportReady.
  ///
  /// In en, this message translates to:
  /// **'Your file is ready: {parts} sections, {kb} KB.'**
  String prvExportReady(int parts, int kb);

  /// No description provided for @prvExportSubject.
  ///
  /// In en, this message translates to:
  /// **'My PawSetu data'**
  String get prvExportSubject;

  /// No description provided for @prvDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get prvDeleteConfirmTitle;

  /// No description provided for @prvDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your account, pets and records will be deleted on {date}. Sign in within {days} days and cancel if you change your mind.'**
  String prvDeleteConfirmBody(String date, int days);

  /// No description provided for @prvDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get prvDeleteButton;

  /// No description provided for @prvDeleteRequestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Deletion scheduled'**
  String get prvDeleteRequestedTitle;

  /// No description provided for @prvDeleteRequestedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted on {date}. Demo: nothing is deleted for real.'**
  String prvDeleteRequestedBody(String date);

  /// No description provided for @prvConsentLost.
  ///
  /// In en, this message translates to:
  /// **'Lost pet alerts near me'**
  String get prvConsentLost;

  /// No description provided for @prvConsentLostHint.
  ///
  /// In en, this message translates to:
  /// **'Get an alert when a pet is lost within 5 km'**
  String get prvConsentLostHint;

  /// No description provided for @prvConsentAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Help improve PawSetu'**
  String get prvConsentAnalytics;

  /// No description provided for @prvConsentAnalyticsHint.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous app usage (no names or photos)'**
  String get prvConsentAnalyticsHint;

  /// No description provided for @prvConsentMarketing.
  ///
  /// In en, this message translates to:
  /// **'Offers and news'**
  String get prvConsentMarketing;

  /// No description provided for @prvConsentMarketingHint.
  ///
  /// In en, this message translates to:
  /// **'Occasional offers by SMS, WhatsApp or email'**
  String get prvConsentMarketingHint;

  /// No description provided for @prvConsentPartners.
  ///
  /// In en, this message translates to:
  /// **'Share health summary with clinics I book'**
  String get prvConsentPartners;

  /// No description provided for @prvConsentPartnersHint.
  ///
  /// In en, this message translates to:
  /// **'Helps the vet prepare before your visit'**
  String get prvConsentPartnersHint;

  /// No description provided for @prvDeletionPending.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted on {date}. Tap to keep it.'**
  String prvDeletionPending(String date);

  /// No description provided for @prvCancelDeletion.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get prvCancelDeletion;

  /// No description provided for @prvDeletionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Deletion cancelled. Your account stays.'**
  String get prvDeletionCancelled;

  /// No description provided for @prvIntro.
  ///
  /// In en, this message translates to:
  /// **'You control your data. Choose what you share, download a copy of everything, or delete your account.'**
  String get prvIntro;

  /// No description provided for @prvConsents.
  ///
  /// In en, this message translates to:
  /// **'What you share'**
  String get prvConsents;

  /// No description provided for @prvDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get prvDownloadTitle;

  /// No description provided for @prvDownloadBody.
  ///
  /// In en, this message translates to:
  /// **'Get a file with your profile, pets, health records, bookings, orders, chats and more.'**
  String get prvDownloadBody;

  /// No description provided for @prvDownloadButton.
  ///
  /// In en, this message translates to:
  /// **'Download my data'**
  String get prvDownloadButton;

  /// No description provided for @prvDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get prvDeleteTitle;

  /// No description provided for @prvDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Your account is deleted {days} days after you ask. Until then you can sign in and cancel.'**
  String prvDeleteBody(int days);

  /// No description provided for @prvDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo: the file is made on your device. In the live app we also email you a download link.'**
  String get prvDemoNote;

  /// No description provided for @suspTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is paused'**
  String get suspTitle;

  /// No description provided for @suspBody.
  ///
  /// In en, this message translates to:
  /// **'Our team paused this account. If you think this is a mistake, contact PawSetu support.'**
  String get suspBody;

  /// No description provided for @suspContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get suspContact;

  /// No description provided for @suspContactBody.
  ///
  /// In en, this message translates to:
  /// **'Demo: write to support@example.com. In the live app this opens your email.'**
  String get suspContactBody;
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
