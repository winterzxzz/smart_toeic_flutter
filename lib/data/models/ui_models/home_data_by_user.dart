import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';

class HomeDataByUser {
  final List<Test> tests;
  final List<ResultTest> results;
  final List<Blog> blogs;

  HomeDataByUser({
    required this.tests,
    required this.results,
    required this.blogs,
  });
}

class HomeDataPublic {
  final List<Test> tests;
  final List<Blog> blogs;

  HomeDataPublic({required this.tests, required this.blogs});
}
