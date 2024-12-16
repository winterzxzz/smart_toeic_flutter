import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';

class HomeDataByUser {
  final List<Test> tests;
  final List<ResultTest> results;

  HomeDataByUser({required this.tests, required this.results});
}
