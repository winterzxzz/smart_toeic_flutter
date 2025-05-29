// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Smart TOEIC Prep`
  String get app_name {
    return Intl.message(
      'Smart TOEIC Prep',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Thank You For Trusting TOEIC Test Pro`
  String get onboarding_title {
    return Intl.message(
      'Thank You For Trusting TOEIC Test Pro',
      name: 'onboarding_title',
      desc: '',
      args: [],
    );
  }

  /// `The best app for TOEIC test-takers`
  String get onboarding_description {
    return Intl.message(
      'The best app for TOEIC test-takers',
      name: 'onboarding_description',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Smart TOEIC Prep`
  String get login_title {
    return Intl.message(
      'Welcome to Smart TOEIC Prep',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `Reset your password`
  String get reset_password_title {
    return Intl.message(
      'Reset your password',
      name: 'reset_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Login to access our comprehensive TOEIC preparation resources`
  String get login_description {
    return Intl.message(
      'Login to access our comprehensive TOEIC preparation resources',
      name: 'login_description',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send_button {
    return Intl.message(
      'Send',
      name: 'send_button',
      desc: '',
      args: [],
    );
  }

  /// `Back to login`
  String get back_to_login {
    return Intl.message(
      'Back to login',
      name: 'back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and we will send you a link to reset your password`
  String get reset_password_description {
    return Intl.message(
      'Enter your email and we will send you a link to reset your password',
      name: 'reset_password_description',
      desc: '',
      args: [],
    );
  }

  /// `Create an account to access our comprehensive TOEIC preparation resources`
  String get register_description {
    return Intl.message(
      'Create an account to access our comprehensive TOEIC preparation resources',
      name: 'register_description',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email_label {
    return Intl.message(
      'Email',
      name: 'email_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get email_hint {
    return Intl.message(
      'Enter your email',
      name: 'email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password_label {
    return Intl.message(
      'Password',
      name: 'password_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password_hint {
    return Intl.message(
      'Enter your password',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name_label {
    return Intl.message(
      'Name',
      name: 'name_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get name_hint {
    return Intl.message(
      'Enter your name',
      name: 'name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_button {
    return Intl.message(
      'Login',
      name: 'login_button',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register_button {
    return Intl.message(
      'Register',
      name: 'register_button',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Please input Email`
  String get empty_email_error {
    return Intl.message(
      'Please input Email',
      name: 'empty_email_error',
      desc: '',
      args: [],
    );
  }

  /// `Please input password`
  String get empty_password_error {
    return Intl.message(
      'Please input password',
      name: 'empty_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Please input confirm password`
  String get empty_confirm_password_error {
    return Intl.message(
      'Please input confirm password',
      name: 'empty_confirm_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Email format is incorrect`
  String get invalid_email_error {
    return Intl.message(
      'Email format is incorrect',
      name: 'invalid_email_error',
      desc: '',
      args: [],
    );
  }

  /// `Email does not exist`
  String get email_exist_error {
    return Intl.message(
      'Email does not exist',
      name: 'email_exist_error',
      desc: '',
      args: [],
    );
  }

  /// `Email has already taken`
  String get email_taken_error {
    return Intl.message(
      'Email has already taken',
      name: 'email_taken_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must have 6-30 characters`
  String get password_length_error {
    return Intl.message(
      'Password must have 6-30 characters',
      name: 'password_length_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must have 6-30 characters`
  String get confirm_password_length_error {
    return Intl.message(
      'Confirm password must have 6-30 characters',
      name: 'confirm_password_length_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must have text, number and special character`
  String get invalid_password_error {
    return Intl.message(
      'Password must have text, number and special character',
      name: 'invalid_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must have text, number and special character`
  String get invalid_confirm_password_error {
    return Intl.message(
      'Confirm password must have text, number and special character',
      name: 'invalid_confirm_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password and password do not match`
  String get confirm_password_match_error {
    return Intl.message(
      'Confirm password and password do not match',
      name: 'confirm_password_match_error',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `AI Render`
  String get ai_render {
    return Intl.message(
      'AI Render',
      name: 'ai_render',
      desc: '',
      args: [],
    );
  }

  /// `Advanced AI-powered tools to enhance your TOEIC preparation experience.`
  String get ai_render_description {
    return Intl.message(
      'Advanced AI-powered tools to enhance your TOEIC preparation experience.',
      name: 'ai_render_description',
      desc: '',
      args: [],
    );
  }

  /// `Flashcards`
  String get flashcards {
    return Intl.message(
      'Flashcards',
      name: 'flashcards',
      desc: '',
      args: [],
    );
  }

  /// `Interactive flashcards to boost your vocabulary and language skills efficiently.`
  String get flashcards_description {
    return Intl.message(
      'Interactive flashcards to boost your vocabulary and language skills efficiently.',
      name: 'flashcards_description',
      desc: '',
      args: [],
    );
  }

  /// `Practice Exams`
  String get practice_exams {
    return Intl.message(
      'Practice Exams',
      name: 'practice_exams',
      desc: '',
      args: [],
    );
  }

  /// `Realistic TOEIC practice exams to assess and improve your test-taking abilities.`
  String get practice_exams_description {
    return Intl.message(
      'Realistic TOEIC practice exams to assess and improve your test-taking abilities.',
      name: 'practice_exams_description',
      desc: '',
      args: [],
    );
  }

  /// `Result Analysis`
  String get result_analysis {
    return Intl.message(
      'Result Analysis',
      name: 'result_analysis',
      desc: '',
      args: [],
    );
  }

  /// `Detailed analysis of your exam performance to identify strengths and areas for improvement.`
  String get result_analysis_description {
    return Intl.message(
      'Detailed analysis of your exam performance to identify strengths and areas for improvement.',
      name: 'result_analysis_description',
      desc: '',
      args: [],
    );
  }

  /// `Practice`
  String get practice {
    return Intl.message(
      'Practice',
      name: 'practice',
      desc: '',
      args: [],
    );
  }

  /// `Exam Preparation`
  String get exam_preparation {
    return Intl.message(
      'Exam Preparation',
      name: 'exam_preparation',
      desc: '',
      args: [],
    );
  }

  /// `Listening`
  String get listening {
    return Intl.message(
      'Listening',
      name: 'listening',
      desc: '',
      args: [],
    );
  }

  /// `Test`
  String get test {
    return Intl.message(
      'Test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// `Set Flashcard`
  String get set_flashcard {
    return Intl.message(
      'Set Flashcard',
      name: 'set_flashcard',
      desc: '',
      args: [],
    );
  }

  /// `Test Online`
  String get test_online {
    return Intl.message(
      'Test Online',
      name: 'test_online',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message(
      'Blogs',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message(
      'Premium',
      name: 'premium',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Account`
  String get upgrade_account {
    return Intl.message(
      'Upgrade Account',
      name: 'upgrade_account',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `No limit`
  String get no_limit {
    return Intl.message(
      'No limit',
      name: 'no_limit',
      desc: '',
      args: [],
    );
  }

  /// `Tests`
  String get tests {
    return Intl.message(
      'Tests',
      name: 'tests',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Exam`
  String get exam {
    return Intl.message(
      'Exam',
      name: 'exam',
      desc: '',
      args: [],
    );
  }

  /// `Mini-Exam`
  String get mini_exam {
    return Intl.message(
      'Mini-Exam',
      name: 'mini_exam',
      desc: '',
      args: [],
    );
  }

  /// `Set Flashcard`
  String get set_flashcard_title {
    return Intl.message(
      'Set Flashcard',
      name: 'set_flashcard_title',
      desc: '',
      args: [],
    );
  }

  /// `My List`
  String get my_list {
    return Intl.message(
      'My List',
      name: 'my_list',
      desc: '',
      args: [],
    );
  }

  /// `Studying`
  String get studying {
    return Intl.message(
      'Studying',
      name: 'studying',
      desc: '',
      args: [],
    );
  }

  /// `Create New Flashcard Set`
  String get create_new_flashcard_set {
    return Intl.message(
      'Create New Flashcard Set',
      name: 'create_new_flashcard_set',
      desc: '',
      args: [],
    );
  }

  /// `Create New Flashcard`
  String get create_new_flashcard {
    return Intl.message(
      'Create New Flashcard',
      name: 'create_new_flashcard',
      desc: '',
      args: [],
    );
  }

  /// `Word Learned`
  String get word_learned {
    return Intl.message(
      'Word Learned',
      name: 'word_learned',
      desc: '',
      args: [],
    );
  }

  /// `Last Studied`
  String get last_studied {
    return Intl.message(
      'Last Studied',
      name: 'last_studied',
      desc: '',
      args: [],
    );
  }

  /// `to reviews`
  String get to_reviews {
    return Intl.message(
      'to reviews',
      name: 'to_reviews',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs_title {
    return Intl.message(
      'Blogs',
      name: 'blogs_title',
      desc: '',
      args: [],
    );
  }

  /// `Search Blogs...`
  String get search_blogs {
    return Intl.message(
      'Search Blogs...',
      name: 'search_blogs',
      desc: '',
      args: [],
    );
  }

  /// `No blogs found`
  String get no_blogs {
    return Intl.message(
      'No blogs found',
      name: 'no_blogs',
      desc: '',
      args: [],
    );
  }

  /// `Read More`
  String get read_more {
    return Intl.message(
      'Read More',
      name: 'read_more',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Target Score`
  String get target_score {
    return Intl.message(
      'Target Score',
      name: 'target_score',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Analysis`
  String get analysis {
    return Intl.message(
      'Analysis',
      name: 'analysis',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get are_you_sure {
    return Intl.message(
      'Are you sure?',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio_label {
    return Intl.message(
      'Bio',
      name: 'bio_label',
      desc: '',
      args: [],
    );
  }

  /// `Enter your bio`
  String get bio_hint {
    return Intl.message(
      'Enter your bio',
      name: 'bio_hint',
      desc: '',
      args: [],
    );
  }

  /// `Reading Target`
  String get reading_target {
    return Intl.message(
      'Reading Target',
      name: 'reading_target',
      desc: '',
      args: [],
    );
  }

  /// `Reading Current`
  String get reading_current {
    return Intl.message(
      'Reading Current',
      name: 'reading_current',
      desc: '',
      args: [],
    );
  }

  /// `Listening Target`
  String get listening_target {
    return Intl.message(
      'Listening Target',
      name: 'listening_target',
      desc: '',
      args: [],
    );
  }

  /// `Listening Current`
  String get listening_current {
    return Intl.message(
      'Listening Current',
      name: 'listening_current',
      desc: '',
      args: [],
    );
  }

  /// `Update Profile`
  String get update_profile {
    return Intl.message(
      'Update Profile',
      name: 'update_profile',
      desc: '',
      args: [],
    );
  }

  /// `Update Target Score`
  String get update_target_score {
    return Intl.message(
      'Update Target Score',
      name: 'update_target_score',
      desc: '',
      args: [],
    );
  }

  /// `Reading Target Score`
  String get reading_target_score {
    return Intl.message(
      'Reading Target Score',
      name: 'reading_target_score',
      desc: '',
      args: [],
    );
  }

  /// `Listening Target Score`
  String get listening_target_score {
    return Intl.message(
      'Listening Target Score',
      name: 'listening_target_score',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Display Theme`
  String get display_theme {
    return Intl.message(
      'Display Theme',
      name: 'display_theme',
      desc: '',
      args: [],
    );
  }

  /// `Follow System`
  String get follow_system {
    return Intl.message(
      'Follow System',
      name: 'follow_system',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get light_mode {
    return Intl.message(
      'Light Mode',
      name: 'light_mode',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `System Mode`
  String get system_mode {
    return Intl.message(
      'System Mode',
      name: 'system_mode',
      desc: '',
      args: [],
    );
  }

  /// `Theme Color`
  String get theme_color {
    return Intl.message(
      'Theme Color',
      name: 'theme_color',
      desc: '',
      args: [],
    );
  }

  /// `Dynamic Color`
  String get dynamic_color {
    return Intl.message(
      'Dynamic Color',
      name: 'dynamic_color',
      desc: '',
      args: [],
    );
  }

  /// `History Test`
  String get history_test {
    return Intl.message(
      'History Test',
      name: 'history_test',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get no_data_found {
    return Intl.message(
      'No data found',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `TOEIC Performance Dashboard`
  String get toeic_performance_dashboard {
    return Intl.message(
      'TOEIC Performance Dashboard',
      name: 'toeic_performance_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Your Score`
  String get analysis_your_score {
    return Intl.message(
      'Analysis Your Score',
      name: 'analysis_your_score',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
