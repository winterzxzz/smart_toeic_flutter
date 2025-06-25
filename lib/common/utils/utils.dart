import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';

class Utils {
  /// Checks if string is email.
  static bool isEmail(String input) {
    // Regular expression pattern to match email addresses
    // This pattern allows for most common email address formats
    const String emailRegex =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    // Create a regular expression object
    final RegExp regex = RegExp(emailRegex);
    // Check if the input matches the email pattern
    return regex.hasMatch(input);
  }

  /// Checks if string is password.
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   (?=.*?[0-9])      // should contain at least one digit
  ///   (?=.*?[!@#\$&*~]) // should contain at least one Special character
  ///   .{8,}             // Must be at least 8 characters in length
  /// $
  static bool isPassword(String input) {
    // Define a regular expression pattern for password validation.
    // This regex requires at least 8 characters, one uppercase letter, one lowercase letter,
    // one digit, and one special character.
    const passwordRegex =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    return RegExp(passwordRegex).hasMatch(input);
  }

  /// Checks if string is phone number.
  static bool isPhoneNumber(String input) {
    // Regular expression pattern to match phone numbers
    // This pattern allows for common phone number formats
    const String phoneRegex =
        r'^\+?(\d{1,4})?[-.\s]?(\d{1,3})[-.\s]?(\d{1,3})[-.\s]?(\d{1,9})$';
    // Create a regular expression object
    final RegExp regex = RegExp(phoneRegex);
    // Check if the input matches the phone number pattern
    return regex.hasMatch(input);
  }

  /// Checks if string is URL.
  static bool isURL(String input) {
    // Regular expression pattern to match URLs
    const String urlRegex = r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$';
    // Create a regular expression object
    final RegExp regex = RegExp(urlRegex, caseSensitive: false);
    // Check if the input matches the URL pattern
    return regex.hasMatch(input);
  }

  ///Color
  static Color? getColorFromHex(String? hexColor) {
    hexColor = (hexColor ?? '').replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  static String? getHexFromColor(Color color) {
    String colorString = color.toString(); // Color(0x12345678)
    String valueString = colorString.split('(0x')[1].split(')')[0];
    return valueString;
  }

  static String getTimeHHMm(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // compare two string ignore case
  static bool compareStringIgnoreCase(String a, String b) {
    // remove all whitespace, dot and comma
    a = a.replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '');
    b = b.replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '');
    return a.toLowerCase() == b.toLowerCase();
  }

  static void showModalBottomSheetForm({
    required BuildContext context,
    String? title,
    required Widget child,
    bool isClose = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Scaffold(
              appBar: AppBar(
                title: Text(title ?? ''),
                leading: LeadingBackButton(isClose: isClose),
              ),
              body: child,
            );
          },
        );
      },
    );
  }
}
