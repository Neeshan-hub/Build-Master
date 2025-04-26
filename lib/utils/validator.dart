import 'package:bot_toast/bot_toast.dart';
import 'package:construction/utils/app_colors.dart';

class Validator {
  static String? getPasswordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Password shall be provided";
    }
    return null;
  }

  static String? getEmailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Email shall be provided";
    }
    if (!email.contains("@") || !email.contains(".com")) {
      return "Email address is not valid";
    }
    return null;
  }

  static String? getPhoneValidator(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Phone shall be provided";
    }
    if (phone.length != 10) {
      return "Phone number is not valid";
    }
    return null;
  }

  static String? getBlankFieldValidator(String? name, String value) {
    if (name == null || name.isEmpty) {
      return "$value is required";
    }
    return null;
  }

  static String? getNumberValidator(String? number, String value) {
    if (number == null || number.isEmpty) {
      return "$value shall be provided";
    }
    return null;
  }
}
