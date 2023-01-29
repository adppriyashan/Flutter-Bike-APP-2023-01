import 'package:email_validator/email_validator.dart';

class FormValidation {
  static String? emailValidation(String value, String errorMessage) {
    if (_basicValidation(value) && EmailValidator.validate(value)) {
      return null;
    }

    return errorMessage;
  }

  static String? notEmptyValidation(String value, String errorMessage) {
    if (_basicValidation(value)) {
      return null;
    }
    return errorMessage;
  }

  static String? passwordValidation(String value) {
    if (_basicValidation(value) && value.length >= 6) {
      return null;
    }

    return "Invalid Password";
  }

  static String? retypePasswordValidation(String value1, String value2) {
    if (_basicValidation(value1) && value1 == value2) {
      return null;
    }

    return "Passwords not matched";
  }

  static bool _basicValidation(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static String? isInteger(value, String errorMessage) {
    try {
      int.parse(value);
      return null;
    } catch (e) {
      return errorMessage;
    }
  }
}
