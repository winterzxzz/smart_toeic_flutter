// To parse this JSON data, do
//
//     final profileAnalysis = profileAnalysisFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'profile_analysis.g.dart';

ProfileAnalysis profileAnalysisFromJson(String str) =>
    ProfileAnalysis.fromJson(json.decode(str));

String profileAnalysisToJson(ProfileAnalysis data) =>
    json.encode(data.toJson());

@JsonSerializable()
class ProfileAnalysis {
  @JsonKey(name: "accuracyByPart")
  Map<String, String> accuracyByPart;
  @JsonKey(name: "averageTimeByPart")
  Map<String, String> averageTimeByPart;
  @JsonKey(name: "categoryAccuracy")
  Map<String, CategoryAccuracy> categoryAccuracy;
  @JsonKey(name: "listenScore")
  int listenScore;
  @JsonKey(name: "readScore")
  int readScore;
  @JsonKey(name: "score")
  int score;
  @JsonKey(name: "timeSecondRecommend")
  Map<String, int> timeSecondRecommend;

  ProfileAnalysis({
    required this.accuracyByPart,
    required this.averageTimeByPart,
    required this.categoryAccuracy,
    required this.listenScore,
    required this.readScore,
    required this.score,
    required this.timeSecondRecommend,
  });

  // initial state
  factory ProfileAnalysis.initial() => ProfileAnalysis(
        accuracyByPart: {},
        averageTimeByPart: {},
        categoryAccuracy: {},
        listenScore: 0,
        readScore: 0,
        score: 0,
        timeSecondRecommend: {},
      );

  factory ProfileAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ProfileAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileAnalysisToJson(this);
}

@JsonSerializable()
class CategoryAccuracy {
  @JsonKey(name: "part")
  int categoryAccuracyPart;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "accuracy")
  String accuracy;

  CategoryAccuracy({
    required this.categoryAccuracyPart,
    required this.title,
    required this.accuracy,
  });

  factory CategoryAccuracy.fromJson(Map<String, dynamic> json) =>
      _$CategoryAccuracyFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryAccuracyToJson(this);
}
