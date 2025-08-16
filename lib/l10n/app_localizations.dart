import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('hu')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'e-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a password reset link.'**
  String get forgot_password_description;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password;

  /// No description provided for @reset_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent! Check your email.'**
  String get reset_password_success;

  /// No description provided for @change_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password modified successfully'**
  String get change_password_success;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get old_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get logout;

  /// No description provided for @noaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noaccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @read_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'I have read and accepted the data protection policy'**
  String get read_privacy_policy;

  /// No description provided for @accept_privacy_policy_error.
  ///
  /// In en, this message translates to:
  /// **'Please accept the privacy policy to continue'**
  String get accept_privacy_policy_error;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get have_account;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get login_success;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpected_error;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email'**
  String get user_not_found;

  /// No description provided for @wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided'**
  String get wrong_password;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address is badly formatted'**
  String get invalid_email;

  /// No description provided for @user_disabled.
  ///
  /// In en, this message translates to:
  /// **'This user has been disabled'**
  String get user_disabled;

  /// No description provided for @email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use'**
  String get email_already_in_use;

  /// No description provided for @operation_not_allowed.
  ///
  /// In en, this message translates to:
  /// **'This operation is not allowed'**
  String get operation_not_allowed;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak'**
  String get weak_password;

  /// No description provided for @auth_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during authentication'**
  String get auth_error;

  /// No description provided for @signup_success.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful'**
  String get signup_success;

  /// No description provided for @logout_success.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logout_success;

  /// No description provided for @logout_error.
  ///
  /// In en, this message translates to:
  /// **'Error logging out'**
  String get logout_error;

  /// No description provided for @channel_error.
  ///
  /// In en, this message translates to:
  /// **'All fields are required.'**
  String get channel_error;

  /// No description provided for @invalid_credential.
  ///
  /// In en, this message translates to:
  /// **'Wrong email address or password.'**
  String get invalid_credential;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Daily statistics'**
  String get stats;

  /// No description provided for @meds.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get meds;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @welcome_to_iaso.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Iaso'**
  String get welcome_to_iaso;

  /// No description provided for @app_description.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your account and customize your experience to help you manage your medications effectively.'**
  String get app_description;

  /// No description provided for @customize_stats_view.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Stats View'**
  String get customize_stats_view;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skip_onboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip Onboarding?'**
  String get skip_onboarding;

  /// No description provided for @skip_onboarding_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to skip the onboarding process? You can always access these settings later.'**
  String get skip_onboarding_message;

  /// No description provided for @enable_notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enable_notifications;

  /// No description provided for @med_notification_description.
  ///
  /// In en, this message translates to:
  /// **'Notify me when meds are about to run out.'**
  String get med_notification_description;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @other_settings.
  ///
  /// In en, this message translates to:
  /// **'Other settings'**
  String get other_settings;

  /// No description provided for @change_username.
  ///
  /// In en, this message translates to:
  /// **'Change username:'**
  String get change_username;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @change_theme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get change_theme;

  /// No description provided for @system_theme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system_theme;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark_theme;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @confirm_account_delete_heading.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get confirm_account_delete_heading;

  /// No description provided for @non_cancellable.
  ///
  /// In en, this message translates to:
  /// **'This task can NOT be undone.'**
  String get non_cancellable;

  /// No description provided for @delete_account_description.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and its data, including daily statistics and medications.'**
  String get delete_account_description;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @success_delete.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted'**
  String get success_delete;

  /// No description provided for @no_data_text.
  ///
  /// In en, this message translates to:
  /// **'No data for this date'**
  String get no_data_text;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @night_temperature.
  ///
  /// In en, this message translates to:
  /// **'Evening Temperature'**
  String get night_temperature;

  /// No description provided for @morning_blood_pressure.
  ///
  /// In en, this message translates to:
  /// **'Morning blood pressure'**
  String get morning_blood_pressure;

  /// No description provided for @night_blood_pressure.
  ///
  /// In en, this message translates to:
  /// **'Evening blood pressure'**
  String get night_blood_pressure;

  /// No description provided for @blood_sugar.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar'**
  String get blood_sugar;

  /// No description provided for @urine.
  ///
  /// In en, this message translates to:
  /// **'Urine'**
  String get urine;

  /// No description provided for @pulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulse;

  /// No description provided for @error_saving.
  ///
  /// In en, this message translates to:
  /// **'Error Saving'**
  String get error_saving;

  /// No description provided for @create_med.
  ///
  /// In en, this message translates to:
  /// **'Create medication'**
  String get create_med;

  /// No description provided for @no_medications_added.
  ///
  /// In en, this message translates to:
  /// **'No medications added yet'**
  String get no_medications_added;

  /// No description provided for @add_medication_guide.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first medication'**
  String get add_medication_guide;

  /// No description provided for @add_medication.
  ///
  /// In en, this message translates to:
  /// **'Add new medication'**
  String get add_medication;

  /// No description provided for @edit_med.
  ///
  /// In en, this message translates to:
  /// **'Edit medication'**
  String get edit_med;

  /// No description provided for @total_doses.
  ///
  /// In en, this message translates to:
  /// **'{doses} days remaining.'**
  String total_doses(Object doses);

  /// No description provided for @meds_running_out.
  ///
  /// In en, this message translates to:
  /// **'Medications running low'**
  String get meds_running_out;

  /// No description provided for @meds_not_running_out.
  ///
  /// In en, this message translates to:
  /// **'Currently no meds are running low'**
  String get meds_not_running_out;

  /// No description provided for @med_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get med_name;

  /// No description provided for @med_replacement_name.
  ///
  /// In en, this message translates to:
  /// **'Replacement name'**
  String get med_replacement_name;

  /// No description provided for @active_agent.
  ///
  /// In en, this message translates to:
  /// **'Active Agent'**
  String get active_agent;

  /// No description provided for @use_case.
  ///
  /// In en, this message translates to:
  /// **'Use Case'**
  String get use_case;

  /// No description provided for @side_effect.
  ///
  /// In en, this message translates to:
  /// **'Side Effects'**
  String get side_effect;

  /// No description provided for @daily_quantity.
  ///
  /// In en, this message translates to:
  /// **'Daily Quantity'**
  String get daily_quantity;

  /// No description provided for @intake_which_days.
  ///
  /// In en, this message translates to:
  /// **'What days should it be taken?'**
  String get intake_which_days;

  /// No description provided for @take_every_day.
  ///
  /// In en, this message translates to:
  /// **'Take every day'**
  String get take_every_day;

  /// No description provided for @take_alternating_days.
  ///
  /// In en, this message translates to:
  /// **'Take Every Second Day'**
  String get take_alternating_days;

  /// No description provided for @next_take_day.
  ///
  /// In en, this message translates to:
  /// **'Next take day: {day}'**
  String next_take_day(Object day);

  /// No description provided for @next_take_day_label.
  ///
  /// In en, this message translates to:
  /// **'Select next take day'**
  String get next_take_day_label;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @current_quantity.
  ///
  /// In en, this message translates to:
  /// **'Current Quantity'**
  String get current_quantity;

  /// No description provided for @ordered_by.
  ///
  /// In en, this message translates to:
  /// **'Ordered By'**
  String get ordered_by;

  /// No description provided for @is_in_cloud.
  ///
  /// In en, this message translates to:
  /// **'Is In Cloud'**
  String get is_in_cloud;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete_med.
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get delete_med;

  /// No description provided for @delete_med_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication?'**
  String get delete_med_description;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @stats_view.
  ///
  /// In en, this message translates to:
  /// **'Statistics view'**
  String get stats_view;

  /// No description provided for @stats_view_description.
  ///
  /// In en, this message translates to:
  /// **'Customize which statistics are displayed. Toggle options to show or hide specific measurements.'**
  String get stats_view_description;

  /// No description provided for @sort_name_az.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get sort_name_az;

  /// No description provided for @sort_name_za.
  ///
  /// In en, this message translates to:
  /// **'Name: Z to A'**
  String get sort_name_za;

  /// No description provided for @sort_doses_low_high.
  ///
  /// In en, this message translates to:
  /// **'Doses: Low to High'**
  String get sort_doses_low_high;

  /// No description provided for @sort_doses_high_low.
  ///
  /// In en, this message translates to:
  /// **'Doses: High to Low'**
  String get sort_doses_high_low;

  /// No description provided for @show_zero_doses.
  ///
  /// In en, this message translates to:
  /// **'Show medications with zero doses'**
  String get show_zero_doses;

  /// No description provided for @battery_optimization_title.
  ///
  /// In en, this message translates to:
  /// **'Improve App Reliability'**
  String get battery_optimization_title;

  /// No description provided for @battery_optimization_disabled.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization is disabled for this app. Your medication tracking and notifications should work reliably.'**
  String get battery_optimization_disabled;

  /// No description provided for @battery_optimization_description.
  ///
  /// In en, this message translates to:
  /// **'To ensure Iaso works correctly, please disable battery optimization for the app.'**
  String get battery_optimization_description;

  /// No description provided for @optimization_disabled.
  ///
  /// In en, this message translates to:
  /// **'Optimization Disabled'**
  String get optimization_disabled;

  /// No description provided for @disable_optimization.
  ///
  /// In en, this message translates to:
  /// **'Disable Battery Optimization'**
  String get disable_optimization;
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
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
