// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "dont_have_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "email_hint": MessageLookupByLibrary.simpleMessage("Enter your email"),
        "email_label": MessageLookupByLibrary.simpleMessage("Email"),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "login_button": MessageLookupByLibrary.simpleMessage("Login"),
        "login_description": MessageLookupByLibrary.simpleMessage(
            "Login to access our comprehensive TOEIC preparation resources"),
        "login_title":
            MessageLookupByLibrary.simpleMessage("Welcome to Smart TOEIC Prep"),
        "onboarding_description": MessageLookupByLibrary.simpleMessage(
            "The best app for TOEIC test-takers"),
        "onboarding_title": MessageLookupByLibrary.simpleMessage(
            "Thank You For Trusting TOEIC Test Pro"),
        "password_hint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "password_label": MessageLookupByLibrary.simpleMessage("Password"),
        "register_button": MessageLookupByLibrary.simpleMessage("Register")
      };
}
