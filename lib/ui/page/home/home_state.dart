import 'package:equatable/equatable.dart';
import 'package:toeic_desktop/data/models/entities/blog/blog.dart';
import 'package:toeic_desktop/data/models/entities/test/result_test.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';

class HomeState extends Equatable {
  final LoadStatus loadStatus;
  final String message;
  final List<Test> tests;
  final List<ResultTest> resultTests;
  final List<Blog> blogs;

  const HomeState({
    required this.loadStatus,
    required this.message,
    required this.tests,
    required this.resultTests,
    required this.blogs,
  });

  // initstate
  factory HomeState.initial() => const HomeState(
        loadStatus: LoadStatus.initial,
        message: '',
        tests: [],
        resultTests: [],
        blogs: [],
      );

  // copyWith
  HomeState copyWith({
    LoadStatus? loadStatus,
    String? message,
    List<Test>? tests,
    List<ResultTest>? resultTests,
    List<Blog>? blogs,
  }) {
    return HomeState(
      loadStatus: loadStatus ?? this.loadStatus,
      message: message ?? this.message,
      tests: tests ?? this.tests,
      resultTests: resultTests ?? this.resultTests,
      blogs: blogs ?? this.blogs,
    );
  }

  @override
  List<Object> get props => [loadStatus, message, tests, resultTests, blogs];
}
