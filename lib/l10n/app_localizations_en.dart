// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get email => 'e-mail';

  @override
  String get password => 'password';

  @override
  String get forgot_password => 'Forgot password?';

  @override
  String get forgot_password_description =>
      'Enter your email address and we\'ll send you a password reset link.';

  @override
  String get reset_password => 'Reset password';

  @override
  String get reset_password_success =>
      'Password reset link sent! Check your email.';

  @override
  String get change_password_success => 'Password modified successfully';

  @override
  String get change_password => 'Change password';

  @override
  String get old_password => 'Old password';

  @override
  String get new_password => 'New password';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Sign Out';

  @override
  String get noaccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get username => 'username';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get read_privacy_policy =>
      'I have read and accepted the data protection policy';

  @override
  String get accept_privacy_policy_error =>
      'Please accept the privacy policy to continue';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get have_account => 'Already have an account?';

  @override
  String get success => 'Success';

  @override
  String get error => 'An error occurred';

  @override
  String get login_success => 'Login successful';

  @override
  String get login_failed => 'Login failed';

  @override
  String get unexpected_error => 'An unexpected error occurred';

  @override
  String get user_not_found => 'No user found for that email';

  @override
  String get wrong_password => 'Wrong password provided';

  @override
  String get invalid_email => 'The email address is badly formatted';

  @override
  String get user_disabled => 'This user has been disabled';

  @override
  String get email_already_in_use => 'The email address is already in use';

  @override
  String get operation_not_allowed => 'This operation is not allowed';

  @override
  String get weak_password => 'The password provided is too weak';

  @override
  String get auth_error => 'An error occurred during authentication';

  @override
  String get signup_success => 'Sign up successful';

  @override
  String get logout_success => 'Logged out successfully';

  @override
  String get logout_error => 'Error logging out';

  @override
  String get channel_error => 'All fields are required.';

  @override
  String get invalid_credential => 'Wrong email address or password.';

  @override
  String get home => 'Home';

  @override
  String get stats => 'Daily statistics';

  @override
  String get meds => 'Medications';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get welcome_to_iaso => 'Welcome to Iaso';

  @override
  String get app_description =>
      'Let\'s set up your account and customize your experience to help you manage your medications effectively.';

  @override
  String get customize_stats_view => 'Customize Your Stats View';

  @override
  String get skip => 'Skip';

  @override
  String get skip_onboarding => 'Skip Onboarding?';

  @override
  String get skip_onboarding_message =>
      'Are you sure you want to skip the onboarding process? You can always access these settings later.';

  @override
  String get enable_notifications => 'Enable notifications';

  @override
  String get med_notification_description =>
      'Notify me when meds are about to run out.';

  @override
  String get finish => 'Finish';

  @override
  String get enable => 'Enable';

  @override
  String get enabled => 'Enabled';

  @override
  String get hello => 'Hello';

  @override
  String get account => 'Account';

  @override
  String get other_settings => 'Other settings';

  @override
  String get change_username => 'Change username:';

  @override
  String get change_language => 'Change language';

  @override
  String get change_theme => 'Change theme';

  @override
  String get system_theme => 'System';

  @override
  String get light_theme => 'Light';

  @override
  String get dark_theme => 'Dark';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get confirm_account_delete_heading =>
      'Are you sure you want to delete your account?';

  @override
  String get non_cancellable => 'This task can NOT be undone.';

  @override
  String get delete_account_description =>
      'This will permanently delete your account and its data, including daily statistics and medications.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get success_delete => 'Successfully deleted';

  @override
  String get no_data_text => 'No data for this date';

  @override
  String get weight => 'Weight';

  @override
  String get temperature => 'Temperature';

  @override
  String get night_temperature => 'Evening Temperature';

  @override
  String get morning_blood_pressure => 'Morning blood pressure';

  @override
  String get night_blood_pressure => 'Evening blood pressure';

  @override
  String get blood_sugar => 'Blood sugar';

  @override
  String get urine => 'Urine';

  @override
  String get pulse => 'Pulse';

  @override
  String get error_saving => 'Error Saving';

  @override
  String get create_med => 'Create medication';

  @override
  String get no_medications_added => 'No medications added yet';

  @override
  String get add_medication_guide =>
      'Tap the button below to add your first medication';

  @override
  String get add_medication => 'Add new medication';

  @override
  String get edit_med => 'Edit medication';

  @override
  String total_doses(Object doses) {
    return '$doses days remaining.';
  }

  @override
  String get meds_running_out => 'Medications running low';

  @override
  String get meds_not_running_out => 'Currently no meds are running low';

  @override
  String get med_name => 'Name';

  @override
  String get med_replacement_name => 'Replacement name';

  @override
  String get active_agent => 'Active Agent';

  @override
  String get use_case => 'Use Case';

  @override
  String get side_effect => 'Side Effects';

  @override
  String get daily_quantity => 'Daily Quantity';

  @override
  String get intake_which_days => 'What days should it be taken?';

  @override
  String get take_every_day => 'Take every day';

  @override
  String get take_alternating_days => 'Take Every Second Day';

  @override
  String next_take_day(Object day) {
    return 'Next take day: $day';
  }

  @override
  String get next_take_day_label => 'Select next take day';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get current_quantity => 'Current Quantity';

  @override
  String get ordered_by => 'Ordered By';

  @override
  String get is_in_cloud => 'Is In Cloud';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get delete_med => 'Delete Medication';

  @override
  String get delete_med_description =>
      'Are you sure you want to delete this medication?';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get stats_view => 'Statistics view';

  @override
  String get stats_view_description =>
      'Customize which statistics are displayed. Toggle options to show or hide specific measurements.';

  @override
  String get sort_name_az => 'Name: A to Z';

  @override
  String get sort_name_za => 'Name: Z to A';

  @override
  String get sort_doses_low_high => 'Doses: Low to High';

  @override
  String get sort_doses_high_low => 'Doses: High to Low';

  @override
  String get show_zero_doses => 'Show medications with zero doses';

  @override
  String get battery_optimization_title => 'Improve App Reliability';

  @override
  String get battery_optimization_disabled =>
      'Battery optimization is disabled for this app. Your medication tracking and notifications should work reliably.';

  @override
  String get battery_optimization_description =>
      'To ensure Iaso works correctly, please disable battery optimization for the app.';

  @override
  String get optimization_disabled => 'Optimization Disabled';

  @override
  String get disable_optimization => 'Disable Battery Optimization';
}
