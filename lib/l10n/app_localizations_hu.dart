// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get language => 'Nyelv';

  @override
  String get email => 'email';

  @override
  String get password => 'jelszó';

  @override
  String get forgot_password => 'Elfelejtette a jelszavát?';

  @override
  String get forgot_password_description =>
      'Adja meg email címét, és küldünk egy jelszó visszaállítási linket.';

  @override
  String get reset_password => 'Jelszó visszaállítása';

  @override
  String get reset_password_success =>
      'Jelszó visszaállítási link elküldve! Ellenőrizze az emailjét.';

  @override
  String get change_password_success => 'Jelszó sikeresen módosítva';

  @override
  String get change_password => 'Jelszó módosítása';

  @override
  String get old_password => 'Régi jelszó';

  @override
  String get new_password => 'Új jelszó';

  @override
  String get login => 'Bejelentkezés';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String get noaccount => 'Nincs fiókod?';

  @override
  String get register => 'Regisztrálj';

  @override
  String get username => 'felhasználónév';

  @override
  String get privacy_policy => 'Adatvédelem és biztonság';

  @override
  String get read_privacy_policy =>
      'Elolvastam és elfogadtam az adatvédelmi szabályzatot';

  @override
  String get accept_privacy_policy_error =>
      'Kérjük, fogadja el az adatvédelmi szabályzatot a folytatáshoz';

  @override
  String get sign_up => 'Feliratkozás';

  @override
  String get have_account => 'Már van fiókod?';

  @override
  String get success => 'Siker';

  @override
  String get error => 'Hiba történt';

  @override
  String get login_success => 'Sikeres bejelentkezés';

  @override
  String get login_failed => 'Sikertelen bejelentkezés';

  @override
  String get unexpected_error => 'Váratlan hiba történt';

  @override
  String get user_not_found =>
      'Nem található felhasználó ezzel az e-mail címmel';

  @override
  String get wrong_password => 'Helytelen jelszó';

  @override
  String get invalid_email => 'Érvénytelen e-mail cím formátum';

  @override
  String get user_disabled => 'Ez a felhasználói fiók le van tiltva';

  @override
  String get email_already_in_use => 'Ez az e-mail cím már használatban van';

  @override
  String get operation_not_allowed => 'Ez a művelet nem engedélyezett';

  @override
  String get weak_password => 'A megadott jelszó túl gyenge';

  @override
  String get auth_error => 'Hiba történt a hitelesítés során';

  @override
  String get signup_success => 'Sikeres regisztráció';

  @override
  String get logout_success => 'Sikeres kijelentkezés';

  @override
  String get logout_error => 'Hiba történt a kijelentkezés során';

  @override
  String get channel_error => 'Minden mező szükséges.';

  @override
  String get invalid_credential => 'Rossz email cím vagy jelszó.';

  @override
  String get home => 'Főoldal';

  @override
  String get stats => 'Napi mérések';

  @override
  String get meds => 'Gyógyszerek';

  @override
  String get settings => 'Beállítások';

  @override
  String get notifications => 'Értesítések';

  @override
  String get welcome_to_iaso => 'Üdvözöljük';

  @override
  String get app_description =>
      'Állítsuk be fiókját, és szabjuk személyre a felhasználói élményt, hogy hatékonyan kezelhesse gyógyszereit.';

  @override
  String get customize_stats_view => 'A napi mérések nézet testreszabása';

  @override
  String get skip => 'Kihagyás';

  @override
  String get skip_onboarding => 'Kihagyás?';

  @override
  String get skip_onboarding_message =>
      'Biztos vagy benne, hogy kihagyod a bevezető folyamatot? Ezeket a beállításokat később bármikor elérheted.';

  @override
  String get enable_notifications => 'Értesítések engedélyezése';

  @override
  String get med_notification_description =>
      'Értesítsen, ha a gyógyszerek hamarosan kifogynak.';

  @override
  String get finish => 'Befejezés';

  @override
  String get enable => 'Engedélyezés';

  @override
  String get enabled => 'Engedélyezve';

  @override
  String get hello => 'Helló';

  @override
  String get account => 'Fiók';

  @override
  String get other_settings => 'Egyéb beállitások';

  @override
  String get change_username => 'Felhasználónév módosítása:';

  @override
  String get change_language => 'Nyelv módosítása';

  @override
  String get change_theme => 'Téma módosítása';

  @override
  String get system_theme => 'Rendszer';

  @override
  String get light_theme => 'Világos';

  @override
  String get dark_theme => 'Sötét';

  @override
  String get save => 'Mentés';

  @override
  String get saved => 'Elmentve';

  @override
  String get delete_account => 'Fiók Törlése';

  @override
  String get confirm_account_delete_heading =>
      'Biztosan törölni szeretné fiókját?';

  @override
  String get non_cancellable => 'Ez a művelet NEM visszavonható.';

  @override
  String get delete_account_description =>
      'Ezzel véglegesen törli fiókját és annak adatait, beleértve a napi statisztikákat és a gyógyszertárat.';

  @override
  String get cancel => 'Mégsem';

  @override
  String get delete => 'Törlés';

  @override
  String get success_delete => 'Sikeresen törölve';

  @override
  String get no_data_text => 'Nincs adat a jelen napra';

  @override
  String get weight => 'Súly';

  @override
  String get temperature => 'Hőmérséklet';

  @override
  String get night_temperature => 'Esti Hőmérséklet';

  @override
  String get morning_blood_pressure => 'Reggeli vérnyomás';

  @override
  String get night_blood_pressure => 'Esti vérnyomás';

  @override
  String get blood_sugar => 'Vércukor';

  @override
  String get urine => 'Vizelet';

  @override
  String get pulse => 'Pulzus';

  @override
  String get error_saving => 'Hiba mentésnél';

  @override
  String get create_med => 'Új gyógyszer';

  @override
  String get no_medications_added => 'Még nincs hozzáadott gyógyszer';

  @override
  String get add_medication_guide =>
      'Az első gyógyszer hozzáadásához érintse meg az alábbi gombot';

  @override
  String get add_medication => 'Új gyógyszer hozzáadása';

  @override
  String get edit_med => 'Gyógyszer editálása';

  @override
  String total_doses(Object doses) {
    return '$doses napnyi van.';
  }

  @override
  String get meds_running_out => 'Fogyóban lévő Gyógyszerek';

  @override
  String get meds_not_running_out => 'Jelenleg nincs fogyóban levő gyógyszer';

  @override
  String get med_name => 'Gyógyszer Neve';

  @override
  String get med_replacement_name => 'Helyettesítő gyógyszer neve';

  @override
  String get active_agent => 'Hatóanyag';

  @override
  String get use_case => 'Hatás';

  @override
  String get side_effect => 'Mellékhatás';

  @override
  String get daily_quantity => 'Napi mennyiség';

  @override
  String get intake_which_days => 'Mely napokon kell bevenni';

  @override
  String get take_every_day => 'Minden nap szedendő';

  @override
  String get take_alternating_days => 'Bevétel kétnaponta';

  @override
  String next_take_day(Object day) {
    return 'Következő bevétel napja: $day';
  }

  @override
  String get next_take_day_label => 'Válassza ki a következő bevétel napját';

  @override
  String get monday => 'Hétfő';

  @override
  String get tuesday => 'Kedd';

  @override
  String get wednesday => 'Szerda';

  @override
  String get thursday => 'Csütörtök';

  @override
  String get friday => 'Péntek';

  @override
  String get saturday => 'Szombat';

  @override
  String get sunday => 'Vasárnap';

  @override
  String get current_quantity => 'Hány darab van';

  @override
  String get ordered_by => 'Kivel kell feliratni';

  @override
  String get is_in_cloud => 'Van-e a felhőben';

  @override
  String get create => 'Létrehozás';

  @override
  String get update => 'Fríssítés';

  @override
  String get delete_med => 'Gyógyszer Törlése';

  @override
  String get delete_med_description => 'Biztosan törli ezt a gyógyszert?';

  @override
  String get january => 'Január';

  @override
  String get february => 'Február';

  @override
  String get march => 'Március';

  @override
  String get april => 'Április';

  @override
  String get may => 'Május';

  @override
  String get june => 'Június';

  @override
  String get july => 'Július';

  @override
  String get august => 'Augusztus';

  @override
  String get september => 'Szeptember';

  @override
  String get october => 'Október';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get stats_view => 'Mérések nézet';

  @override
  String get stats_view_description =>
      'Szabja személyre, hogy mely statisztikák jelenjenek meg a napi mérésekben.';

  @override
  String get sort_name_az => 'Név: A-tól Z-ig';

  @override
  String get sort_name_za => 'Név: Z-től A-ig';

  @override
  String get sort_doses_low_high => 'Adagok alacsonyról magasra';

  @override
  String get sort_doses_high_low => 'Adagok magasról alacsonyra';

  @override
  String get show_zero_doses => 'Mutassa a nulla adagú gyógyszereket';

  @override
  String get battery_optimization_title => 'Az alkalmazás működésének javítása';

  @override
  String get battery_optimization_disabled =>
      'Az akkumulátor-optimalizálás ki van kapcsolva.';

  @override
  String get battery_optimization_description =>
      'Annak érdekében, hogy az Iaso megfelelően működjön, kérjük, kapcsolja ki az akkumulátor-optimalizálást.';

  @override
  String get optimization_disabled => 'Optimalizálás kikapcsolva';

  @override
  String get disable_optimization => 'Akkumulátor-optimalizálás kikapcsolása';
}
