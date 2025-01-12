const huError = {
  // General errors
  'unexpected_error': 'Váratlan hiba történt',
  'server_error': 'Szerverhiba történt. Kérjük, próbálja újra később',

  // Authentication errors
  'user_not_found': 'Nem található felhasználó ezzel az e-mail címmel',
  'wrong_password': 'Helytelen jelszó',
  'invalid_email': 'Érvénytelen e-mail cím formátum',
  'user_disabled': 'Ez a felhasználói fiók le van tiltva',
  'email_already_in_use': 'Ez az e-mail cím már használatban van',
  'operation_not_allowed': 'Ez a művelet nem engedélyezett',
  'weak_password': 'A megadott jelszó túl gyenge',
  'auth_error': 'Hiba történt a hitelesítés során',
  'logout_error': 'Hiba történt a kijelentkezés során',
  'invalid_credential': 'Rossz email cím vagy jelszó',

  // Validation errors
  'validation_error': 'Kérjük, ellenőrizze az űrlapot',
  'required_field': 'Ez a mező kötelező',
  'email_format': 'Kérjük, adjon meg egy érvényes email címet',
  'password_requirements':
      'A jelszónak legalább 8 karakter hosszúnak kell lennie',
  'password_confirmation': 'A jelszavak nem egyeznek',
  'name_max_length': 'A név nem lehet hosszabb 255 karakternél',

  // API specific errors
  'network_error': 'Hálózati hiba. Kérjük, ellenőrizze az internetkapcsolatot',
  'api_error': 'Hiba történt a szerverrel való kommunikáció során',
  'token_expired': 'A munkamenet lejárt. Kérjük, jelentkezzen be újra',
  'invalid_token': 'Érvénytelen hitelesítési token',

  // Data errors
  'error_saving': 'Hiba mentésnél',
  'data_not_found': 'A kért adat nem található',
  'permission_denied': 'Nincs jogosultsága ehhez a művelethez',
  'invalid_data': 'Érvénytelen adatok',

  // Channel errors
  'channel_error': 'Minden mező szükséges.',

  // Stats errors
  'stats_not_found': 'Nincs adat a jelen napra',
  'stats_saved': 'Sikeresen mentve',
  'stats_deleted': 'Sikeresen törölve',
};
