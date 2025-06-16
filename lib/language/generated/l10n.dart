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

  /// `Choose the plan that's right for you`
  String get choose_the_plan_that_s_right_for_you {
    return Intl.message(
      'Choose the plan that\'s right for you',
      name: 'choose_the_plan_that_s_right_for_you',
      desc: '',
      args: [],
    );
  }

  /// `Enhance your TOEIC skills with unique features`
  String get enhance_your_toeic_skills_with_unique_features {
    return Intl.message(
      'Enhance your TOEIC skills with unique features',
      name: 'enhance_your_toeic_skills_with_unique_features',
      desc: '',
      args: [],
    );
  }

  /// `Premium Account`
  String get premium_account {
    return Intl.message(
      'Premium Account',
      name: 'premium_account',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date`
  String get expiration_date {
    return Intl.message(
      'Expiration date',
      name: 'expiration_date',
      desc: '',
      args: [],
    );
  }

  /// `Renew`
  String get renew {
    return Intl.message(
      'Renew',
      name: 'renew',
      desc: '',
      args: [],
    );
  }

  /// `Free Plan`
  String get free_plan {
    return Intl.message(
      'Free Plan',
      name: 'free_plan',
      desc: '',
      args: [],
    );
  }

  /// `Take TOEIC tests`
  String get take_toeic_tests {
    return Intl.message(
      'Take TOEIC tests',
      name: 'take_toeic_tests',
      desc: '',
      args: [],
    );
  }

  /// `Score and save results`
  String get score_and_save_results {
    return Intl.message(
      'Score and save results',
      name: 'score_and_save_results',
      desc: '',
      args: [],
    );
  }

  /// `Create flashcard sets`
  String get create_flashcard_sets {
    return Intl.message(
      'Create flashcard sets',
      name: 'create_flashcard_sets',
      desc: '',
      args: [],
    );
  }

  /// `Access existing flashcards`
  String get access_existing_flashcards {
    return Intl.message(
      'Access existing flashcards',
      name: 'access_existing_flashcards',
      desc: '',
      args: [],
    );
  }

  /// `Access blog`
  String get access_blog {
    return Intl.message(
      'Access blog',
      name: 'access_blog',
      desc: '',
      args: [],
    );
  }

  /// `AI auto-fill`
  String get ai_auto_fill {
    return Intl.message(
      'AI auto-fill',
      name: 'ai_auto_fill',
      desc: '',
      args: [],
    );
  }

  /// `AI question explanations`
  String get ai_question_explanations {
    return Intl.message(
      'AI question explanations',
      name: 'ai_question_explanations',
      desc: '',
      args: [],
    );
  }

  /// `Personal analytics`
  String get personal_analytics {
    return Intl.message(
      'Personal analytics',
      name: 'personal_analytics',
      desc: '',
      args: [],
    );
  }

  /// `Quizzes and reminders`
  String get quizzes_and_reminders {
    return Intl.message(
      'Quizzes and reminders',
      name: 'quizzes_and_reminders',
      desc: '',
      args: [],
    );
  }

  /// `Premium Plan`
  String get premium_plan {
    return Intl.message(
      'Premium Plan',
      name: 'premium_plan',
      desc: '',
      args: [],
    );
  }

  /// `Unlock all features and enhance your TOEIC preparation experience.`
  String get premium_plan_description {
    return Intl.message(
      'Unlock all features and enhance your TOEIC preparation experience.',
      name: 'premium_plan_description',
      desc: '',
      args: [],
    );
  }

  /// `Still have questions?`
  String get still_have_questions {
    return Intl.message(
      'Still have questions?',
      name: 'still_have_questions',
      desc: '',
      args: [],
    );
  }

  /// `Contact us for support`
  String get contact_us_for_support {
    return Intl.message(
      'Contact us for support',
      name: 'contact_us_for_support',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get contact_support {
    return Intl.message(
      'Contact Support',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get upgrade {
    return Intl.message(
      'Upgrade',
      name: 'upgrade',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get recommend {
    return Intl.message(
      'Recommend',
      name: 'recommend',
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

  /// `Attempt Count`
  String get attempt_count {
    return Intl.message(
      'Attempt Count',
      name: 'attempt_count',
      desc: '',
      args: [],
    );
  }

  /// `attempts`
  String get attempts {
    return Intl.message(
      'attempts',
      name: 'attempts',
      desc: '',
      args: [],
    );
  }

  /// `level`
  String get level {
    return Intl.message(
      'level',
      name: 'level',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min {
    return Intl.message(
      'min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `Last time taken`
  String get last_time_taken {
    return Intl.message(
      'Last time taken',
      name: 'last_time_taken',
      desc: '',
      args: [],
    );
  }

  /// `Full`
  String get full {
    return Intl.message(
      'Full',
      name: 'full',
      desc: '',
      args: [],
    );
  }

  /// `Select Part to Practice`
  String get select_part_to_practice {
    return Intl.message(
      'Select Part to Practice',
      name: 'select_part_to_practice',
      desc: '',
      args: [],
    );
  }

  /// `Tip: The form of partial practice and choosing the appropriate time will help you focus on solving the correct questions instead of being under pressure to complete the test.`
  String get practive_part_tips {
    return Intl.message(
      'Tip: The form of partial practice and choosing the appropriate time will help you focus on solving the correct questions instead of being under pressure to complete the test.',
      name: 'practive_part_tips',
      desc: '',
      args: [],
    );
  }

  /// `Limit Time`
  String get limit_time {
    return Intl.message(
      'Limit Time',
      name: 'limit_time',
      desc: '',
      args: [],
    );
  }

  /// `Leave blank to do the test without time limit`
  String get limit_time_hint {
    return Intl.message(
      'Leave blank to do the test without time limit',
      name: 'limit_time_hint',
      desc: '',
      args: [],
    );
  }

  /// `Practice`
  String get practice_button {
    return Intl.message(
      'Practice',
      name: 'practice_button',
      desc: '',
      args: [],
    );
  }

  /// `Tip: The form of partial practice and choosing the appropriate time will help you focus on solving the correct questions instead of being under pressure to complete the test.`
  String get full_mode_tips {
    return Intl.message(
      'Tip: The form of partial practice and choosing the appropriate time will help you focus on solving the correct questions instead of being under pressure to complete the test.',
      name: 'full_mode_tips',
      desc: '',
      args: [],
    );
  }

  /// `Start Test`
  String get start_test {
    return Intl.message(
      'Start Test',
      name: 'start_test',
      desc: '',
      args: [],
    );
  }

  /// `Checking Payment Status...`
  String get checking_payment_status {
    return Intl.message(
      'Checking Payment Status...',
      name: 'checking_payment_status',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been successfully upgraded.`
  String get your_account_has_been_successfully_upgraded {
    return Intl.message(
      'Your account has been successfully upgraded.',
      name: 'your_account_has_been_successfully_upgraded',
      desc: '',
      args: [],
    );
  }

  /// `Return to Home`
  String get return_to_home {
    return Intl.message(
      'Return to Home',
      name: 'return_to_home',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while checking payment status.`
  String get an_error_occured_while_checking_payment_status {
    return Intl.message(
      'An error occurred while checking payment status.',
      name: 'an_error_occured_while_checking_payment_status',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open URL`
  String get cannot_open_url {
    return Intl.message(
      'Cannot open URL',
      name: 'cannot_open_url',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit?`
  String get are_you_sure_exit {
    return Intl.message(
      'Are you sure you want to exit?',
      name: 'are_you_sure_exit',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Great!`
  String get great {
    return Intl.message(
      'Great!',
      name: 'great',
      desc: '',
      args: [],
    );
  }

  /// `Try Harder!`
  String get try_harder {
    return Intl.message(
      'Try Harder!',
      name: 'try_harder',
      desc: '',
      args: [],
    );
  }

  /// `You answered correctly!`
  String get you_answered_correctly {
    return Intl.message(
      'You answered correctly!',
      name: 'you_answered_correctly',
      desc: '',
      args: [],
    );
  }

  /// `You answered incorrectly!`
  String get you_answered_incorrectly {
    return Intl.message(
      'You answered incorrectly!',
      name: 'you_answered_incorrectly',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Next Question`
  String get next_question {
    return Intl.message(
      'Next Question',
      name: 'next_question',
      desc: '',
      args: [],
    );
  }

  /// `Hard to Remember`
  String get hard_to_remember {
    return Intl.message(
      'Hard to Remember',
      name: 'hard_to_remember',
      desc: '',
      args: [],
    );
  }

  /// `Relatively Hard`
  String get relatively_hard {
    return Intl.message(
      'Relatively Hard',
      name: 'relatively_hard',
      desc: '',
      args: [],
    );
  }

  /// `Easy to Remember`
  String get easy_to_remember {
    return Intl.message(
      'Easy to Remember',
      name: 'easy_to_remember',
      desc: '',
      args: [],
    );
  }

  /// `Very Easy to Remember`
  String get very_easy_to_remember {
    return Intl.message(
      'Very Easy to Remember',
      name: 'very_easy_to_remember',
      desc: '',
      args: [],
    );
  }

  /// `What is your confidence level?`
  String get what_is_your_confidence_level {
    return Intl.message(
      'What is your confidence level?',
      name: 'what_is_your_confidence_level',
      desc: '',
      args: [],
    );
  }

  /// `Matching Word`
  String get matching_word {
    return Intl.message(
      'Matching Word',
      name: 'matching_word',
      desc: '',
      args: [],
    );
  }

  /// `You matched correct all words!, Continue with other forms!`
  String get you_matched_correct_all_words {
    return Intl.message(
      'You matched correct all words!, Continue with other forms!',
      name: 'you_matched_correct_all_words',
      desc: '',
      args: [],
    );
  }

  /// `Enter English Word`
  String get enter_english_word {
    return Intl.message(
      'Enter English Word',
      name: 'enter_english_word',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get check {
    return Intl.message(
      'Check',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Order Word to Correct`
  String get order_word_to_correct {
    return Intl.message(
      'Order Word to Correct',
      name: 'order_word_to_correct',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Select Description`
  String get select_description {
    return Intl.message(
      'Select Description',
      name: 'select_description',
      desc: '',
      args: [],
    );
  }

  /// `Select Meaning`
  String get select_meaning {
    return Intl.message(
      'Select Meaning',
      name: 'select_meaning',
      desc: '',
      args: [],
    );
  }

  /// `Enter Vietnamese Word`
  String get enter_vietnamese_word {
    return Intl.message(
      'Enter Vietnamese Word',
      name: 'enter_vietnamese_word',
      desc: '',
      args: [],
    );
  }

  /// `words`
  String get words {
    return Intl.message(
      'words',
      name: 'words',
      desc: '',
      args: [],
    );
  }

  /// `Practive Flashcard`
  String get practive_flashcard {
    return Intl.message(
      'Practive Flashcard',
      name: 'practive_flashcard',
      desc: '',
      args: [],
    );
  }

  /// `Status Explanation`
  String get status_explanation {
    return Intl.message(
      'Status Explanation',
      name: 'status_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Decay Score`
  String get decay_score {
    return Intl.message(
      'Decay Score',
      name: 'decay_score',
      desc: '',
      args: [],
    );
  }

  /// `Practice Pronunciation`
  String get practice_pronoun {
    return Intl.message(
      'Practice Pronunciation',
      name: 'practice_pronoun',
      desc: '',
      args: [],
    );
  }

  /// `Type what you hear...`
  String get type_what_you_hear {
    return Intl.message(
      'Type what you hear...',
      name: 'type_what_you_hear',
      desc: '',
      args: [],
    );
  }

  /// `Transcript Test`
  String get transcript_test {
    return Intl.message(
      'Transcript Test',
      name: 'transcript_test',
      desc: '',
      args: [],
    );
  }

  /// `Question List`
  String get question_list {
    return Intl.message(
      'Question List',
      name: 'question_list',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Correct!`
  String get correct {
    return Intl.message(
      'Correct!',
      name: 'correct',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get result {
    return Intl.message(
      'Result',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Test Listening`
  String get test_listening {
    return Intl.message(
      'Test Listening',
      name: 'test_listening',
      desc: '',
      args: [],
    );
  }

  /// `Click to start test`
  String get click_to_start_test {
    return Intl.message(
      'Click to start test',
      name: 'click_to_start_test',
      desc: '',
      args: [],
    );
  }

  /// `Update Error`
  String get update_error {
    return Intl.message(
      'Update Error',
      name: 'update_error',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save_button {
    return Intl.message(
      'Save',
      name: 'save_button',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Add new word`
  String get add_new_word {
    return Intl.message(
      'Add new word',
      name: 'add_new_word',
      desc: '',
      args: [],
    );
  }

  /// `Practice flashcards`
  String get practice_flashcards {
    return Intl.message(
      'Practice flashcards',
      name: 'practice_flashcards',
      desc: '',
      args: [],
    );
  }

  /// `View randomly`
  String get view_randomly {
    return Intl.message(
      'View randomly',
      name: 'view_randomly',
      desc: '',
      args: [],
    );
  }

  /// `No words in this flashcard set`
  String get no_words_in_flash_card {
    return Intl.message(
      'No words in this flashcard set',
      name: 'no_words_in_flash_card',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this flashcard?`
  String get are_you_sure_delete_flashcard {
    return Intl.message(
      'Are you sure you want to delete this flashcard?',
      name: 'are_you_sure_delete_flashcard',
      desc: '',
      args: [],
    );
  }

  /// `Translate`
  String get translate {
    return Intl.message(
      'Translate',
      name: 'translate',
      desc: '',
      args: [],
    );
  }

  /// `Definition`
  String get definition {
    return Intl.message(
      'Definition',
      name: 'definition',
      desc: '',
      args: [],
    );
  }

  /// `Example Sentences`
  String get example_sentences {
    return Intl.message(
      'Example Sentences',
      name: 'example_sentences',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Word`
  String get word {
    return Intl.message(
      'Word',
      name: 'word',
      desc: '',
      args: [],
    );
  }

  /// `Meaning`
  String get meaning {
    return Intl.message(
      'Meaning',
      name: 'meaning',
      desc: '',
      args: [],
    );
  }

  /// `Example`
  String get example {
    return Intl.message(
      'Example',
      name: 'example',
      desc: '',
      args: [],
    );
  }

  /// `Pronunciation`
  String get pronunciation {
    return Intl.message(
      'Pronunciation',
      name: 'pronunciation',
      desc: '',
      args: [],
    );
  }

  /// `Part of speech`
  String get part_of_speech {
    return Intl.message(
      'Part of speech',
      name: 'part_of_speech',
      desc: '',
      args: [],
    );
  }

  /// `AI is filling...`
  String get ai_filling {
    return Intl.message(
      'AI is filling...',
      name: 'ai_filling',
      desc: '',
      args: [],
    );
  }

  /// `Fill by AI`
  String get fill_by_ai {
    return Intl.message(
      'Fill by AI',
      name: 'fill_by_ai',
      desc: '',
      args: [],
    );
  }

  /// `Hide Answer`
  String get hide_answer {
    return Intl.message(
      'Hide Answer',
      name: 'hide_answer',
      desc: '',
      args: [],
    );
  }

  /// `Show Answer`
  String get show_answer {
    return Intl.message(
      'Show Answer',
      name: 'show_answer',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Click to reveal definition`
  String get click_to_reveal {
    return Intl.message(
      'Click to reveal definition',
      name: 'click_to_reveal',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Score`
  String get analysis_score {
    return Intl.message(
      'Analysis Score',
      name: 'analysis_score',
      desc: '',
      args: [],
    );
  }

  /// `Overall Score`
  String get overall_score {
    return Intl.message(
      'Overall Score',
      name: 'overall_score',
      desc: '',
      args: [],
    );
  }

  /// `Reading`
  String get reading {
    return Intl.message(
      'Reading',
      name: 'reading',
      desc: '',
      args: [],
    );
  }

  /// `Listening Score`
  String get listening_score {
    return Intl.message(
      'Listening Score',
      name: 'listening_score',
      desc: '',
      args: [],
    );
  }

  /// `Reading Score`
  String get reading_score {
    return Intl.message(
      'Reading Score',
      name: 'reading_score',
      desc: '',
      args: [],
    );
  }

  /// `Listening Score Explanation`
  String get listening_score_explanation {
    return Intl.message(
      'Listening Score Explanation',
      name: 'listening_score_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Reading Score Explanation`
  String get reading_score_explanation {
    return Intl.message(
      'Reading Score Explanation',
      name: 'reading_score_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Listening Score Explanation Content`
  String get listening_score_explanation_content {
    return Intl.message(
      'Listening Score Explanation Content',
      name: 'listening_score_explanation_content',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy by Part`
  String get accuracy_by_part {
    return Intl.message(
      'Accuracy by Part',
      name: 'accuracy_by_part',
      desc: '',
      args: [],
    );
  }

  /// `Analysis Time`
  String get analysis_time {
    return Intl.message(
      'Analysis Time',
      name: 'analysis_time',
      desc: '',
      args: [],
    );
  }

  /// `S/Question`
  String get time_per_question {
    return Intl.message(
      'S/Question',
      name: 'time_per_question',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `All Parts`
  String get all_parts {
    return Intl.message(
      'All Parts',
      name: 'all_parts',
      desc: '',
      args: [],
    );
  }

  /// `Category Accuracy Chart`
  String get category_accuracy_chart {
    return Intl.message(
      'Category Accuracy Chart',
      name: 'category_accuracy_chart',
      desc: '',
      args: [],
    );
  }

  /// `Question Types`
  String get question_types {
    return Intl.message(
      'Question Types',
      name: 'question_types',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get count {
    return Intl.message(
      'Count',
      name: 'count',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to submit the test?`
  String get are_you_sure_submit_test {
    return Intl.message(
      'Are you sure you want to submit the test?',
      name: 'are_you_sure_submit_test',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get please_wait {
    return Intl.message(
      'Please wait...',
      name: 'please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Submitting...`
  String get submitting {
    return Intl.message(
      'Submitting...',
      name: 'submitting',
      desc: '',
      args: [],
    );
  }

  /// `View Answer`
  String get view_answer {
    return Intl.message(
      'View Answer',
      name: 'view_answer',
      desc: '',
      args: [],
    );
  }

  /// `Back to test page`
  String get back_to_test_page {
    return Intl.message(
      'Back to test page',
      name: 'back_to_test_page',
      desc: '',
      args: [],
    );
  }

  /// `Correct answer`
  String get correct_answer {
    return Intl.message(
      'Correct answer',
      name: 'correct_answer',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to use AI`
  String get upgrade_to_use_ai {
    return Intl.message(
      'Upgrade to use AI',
      name: 'upgrade_to_use_ai',
      desc: '',
      args: [],
    );
  }

  /// `Create answer by AI`
  String get create_answer_by_ai {
    return Intl.message(
      'Create answer by AI',
      name: 'create_answer_by_ai',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Analysis your score successfully`
  String get analysis_your_score_success {
    return Intl.message(
      'Analysis your score successfully',
      name: 'analysis_your_score_success',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Tiếng Việt`
  String get vietnamese {
    return Intl.message(
      'Tiếng Việt',
      name: 'vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Test Practice`
  String get test_practice {
    return Intl.message(
      'Test Practice',
      name: 'test_practice',
      desc: '',
      args: [],
    );
  }

  /// `Blog`
  String get blog {
    return Intl.message(
      'Blog',
      name: 'blog',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
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
      Locale.fromSubtags(languageCode: 'vi'),
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
