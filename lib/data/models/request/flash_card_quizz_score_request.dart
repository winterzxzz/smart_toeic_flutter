// To parse this JSON data, do
//
//     final flashCardQuizzScoreRequest = flashCardQuizzScoreRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card_quizz_score_request.g.dart';

List<FlashCardQuizzScoreRequest> flashCardQuizzScoreRequestFromJson(
        String str) =>
    List<FlashCardQuizzScoreRequest>.from(
        json.decode(str).map((x) => FlashCardQuizzScoreRequest.fromJson(x)));

String flashCardQuizzScoreRequestToJson(
        List<FlashCardQuizzScoreRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCardQuizzScoreRequest {
  @JsonKey(name: "num_of_correct")
  final int? numOfCorrect;
  @JsonKey(name: "accuracy")
  final double? accuracy;
  @JsonKey(name: "difficult_rate")
  final double? difficultRate;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "num_of_quiz")
  final int? numOfQuiz;
  @JsonKey(name: "timeMinutes")
  final double? timeMinutes;
  @JsonKey(name: "word")
  final String? word;
  @JsonKey(name: "isChangeDifficulty")
  final bool? isChangeDifficulty;

  FlashCardQuizzScoreRequest({
    this.numOfCorrect,
    this.accuracy,
    this.difficultRate,
    this.id,
    this.numOfQuiz,
    this.timeMinutes,
    this.word,
    this.isChangeDifficulty,
  });

  FlashCardQuizzScoreRequest copyWith({
    int? numOfCorrect,
    double? accuracy,
    double? difficultRate,
    String? id,
    int? numOfQuiz,
    double? timeMinutes,
    String? word,
    bool? isChangeDifficulty,
  }) =>
      FlashCardQuizzScoreRequest(
        numOfCorrect: numOfCorrect ?? this.numOfCorrect,
        accuracy: accuracy ?? this.accuracy,
        difficultRate: difficultRate ?? this.difficultRate,
        id: id ?? this.id,
        numOfQuiz: numOfQuiz ?? this.numOfQuiz,
        timeMinutes: timeMinutes ?? this.timeMinutes,
        word: word ?? this.word,
        isChangeDifficulty: isChangeDifficulty ?? this.isChangeDifficulty,
      );

  factory FlashCardQuizzScoreRequest.fromJson(Map<String, dynamic> json) =>
      _$FlashCardQuizzScoreRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FlashCardQuizzScoreRequestToJson(this);
}
