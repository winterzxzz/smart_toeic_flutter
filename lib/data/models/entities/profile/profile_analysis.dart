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
  final Map<String, String>? accuracyByPart;
  @JsonKey(name: "averageTimeByPart")
  final Map<String, String>? averageTimeByPart;
  @JsonKey(name: "categoryAccuracy")
  final Map<String, CategoryAccuracy>? categoryAccuracy;
  @JsonKey(name: "listenScore")
  final int? listenScore;
  @JsonKey(name: "readScore")
  final int? readScore;
  @JsonKey(name: "score")
  final int? score;
  @JsonKey(name: "timeSecondRecommend")
  final Map<String, int>? timeSecondRecommend;

  ProfileAnalysis({
    this.accuracyByPart,
    this.averageTimeByPart,
    this.categoryAccuracy,
    this.listenScore,
    this.readScore,
    this.score,
    this.timeSecondRecommend,
  });

  // initial state
  factory ProfileAnalysis.initial() => ProfileAnalysis(
        accuracyByPart: null,
        averageTimeByPart: null,
        categoryAccuracy: null,
        listenScore: 0,
        readScore: 0,
        score: 0,
        timeSecondRecommend: null,
      );

  factory ProfileAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ProfileAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileAnalysisToJson(this);
}

@JsonSerializable()
class CategoryAccuracy {
  @JsonKey(name: "part")
  final int? categoryAccuracyPart;
  @JsonKey(name: "title")
  final String? title;
  @JsonKey(name: "accuracy")
  final String? accuracy;

  CategoryAccuracy({
    this.categoryAccuracyPart,
    this.title,
    this.accuracy,
  });

  factory CategoryAccuracy.fromJson(Map<String, dynamic> json) =>
      _$CategoryAccuracyFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryAccuracyToJson(this);
}
