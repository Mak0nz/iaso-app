const enError = {
  // General errors
  'unexpected_error': 'An unexpected error occurred',
  'server_error': 'A server error occurred. Please try again later',

  // Authentication errors
  'user_not_found': 'No user found for that email',
  'wrong_password': 'Wrong password provided',
  'invalid_email': 'The email address is badly formatted',
  'user_disabled': 'This user has been disabled',
  'email_already_in_use': 'The email address is already in use',
  'operation_not_allowed': 'This operation is not allowed',
  'weak_password': 'The password provided is too weak',
  'auth_error': 'An error occurred during authentication',
  'logout_error': 'Error logging out',
  'invalid_credential': 'Wrong email address or password',

  // Validation errors
  'validation_error': 'Please check the form for errors',
  'required_field': 'This field is required',
  'email_format': 'Please enter a valid email address',
  'password_requirements': 'Password must be at least 8 characters',
  'password_confirmation': 'Passwords do not match',
  'name_max_length': 'Name cannot be longer than 255 characters',

  // API specific errors
  'network_error': 'Network error. Please check your connection',
  'api_error': 'Error communicating with the server',
  'token_expired': 'Your session has expired. Please log in again',
  'invalid_token': 'Invalid authentication token',

  // Data errors
  'error_saving': 'Error saving data',
  'data_not_found': 'Requested data not found',
  'permission_denied': 'You do not have permission for this action',
  'invalid_data': 'Invalid data provided',

  // Channel errors
  'channel_error': 'All fields are required.',
};
