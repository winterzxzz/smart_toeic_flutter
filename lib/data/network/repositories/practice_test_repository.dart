import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';

abstract class PracticeTestRepository {
  Future<void> getPracticeTest();
  Future<List<Question>> getPracticeTestDetail();
  Future<void> getPracticeTestResult();
  Future<void> getPracticeTestHistory();
  Future<void> getPracticeTestQuestion();
}

class PracticeTestRepositoryImpl extends PracticeTestRepository {
  final ApiClient _apiClient;

  PracticeTestRepositoryImpl(this._apiClient);

  @override
  Future<void> getPracticeTest() async {}

  @override
  Future<List<Question>> getPracticeTestDetail() async {
    final String response =
        await rootBundle.loadString('assets/jsons/test.json');
    final List<dynamic> jsonData = jsonDecode(response);

    return jsonData.map((json) => Question.fromJson(json)).toList();
  }

  @override
  Future<void> getPracticeTestHistory() {
    throw UnimplementedError();
  }

  @override
  Future<void> getPracticeTestQuestion() {
    throw UnimplementedError();
  }

  @override
  Future<void> getPracticeTestResult() {
    throw UnimplementedError();
  }
}
