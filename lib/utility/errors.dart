// ignore_for_file: constant_identifier_names

// Error Messages
const String GenericError = 'The operation failed unexpectedly.';
const String InvalidEmailError = 'Please enter a valid email address.';
const String UserNotFoundError = 'The user does not exist.';
const String WrongPasswordError = 'The password is incorrect.';
const String UserExistsError = 'The email address was already in use.';
const String WeakPasswordError = 'The password is too weak.';

// Error Codes
const String USER_NOT_FOUND_CODE = 'user-not-found';
const String WRONG_PASSWORD_CODE = 'wrong-password';
const String WEAK_PASSWORD_CODE = 'weak-password';
const String EMAIL_IN_USE_CODE = 'email-already-in-use';

/// Returns a [String] that formats the error
/// message for required fields.
String getRequiredError(message) {
  return 'Please enter $message.';
}
