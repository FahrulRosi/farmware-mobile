class PasswordValidator {
  static bool hasUpperCase(String password) =>
      password.contains(RegExp(r'[A-Z]'));
  static bool hasLowerCase(String password) =>
      password.contains(RegExp(r'[a-z]'));
  static bool hasDigits(String password) => password.contains(RegExp(r'[0-9]'));
  static bool hasSpecialCharacters(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  static bool hasMinLength(String password, int minLength) =>
      password.length >= minLength;

  static List<String> getPasswordValidationErrors(String password) {
    List<String> errors = [];

    if (!hasMinLength(password, 8)) {
      errors.add('Password must be at least 8 characters long');
    }
    if (!hasUpperCase(password)) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!hasLowerCase(password)) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!hasDigits(password)) {
      errors.add('Password must contain at least one number');
    }
    if (!hasSpecialCharacters(password)) {
      errors.add('Password must contain at least one special character');
    }

    return errors;
  }
}
