// To parse this JSON data, do
//
//     final flashCardUpdateScoreRequest = flashCardUpdateScoreRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card_update_score_request.g.dart';

List<FlashCardUpdateScoreRequest> flashCardUpdateScoreRequestFromJson(String str) => List<FlashCardUpdateScoreRequest>.from(json.decode(str).map((x) => FlashCardUpdateScoreRequest.fromJson(x)));

String flashCardUpdateScoreRequestToJson(List<FlashCardUpdateScoreRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCardUpdateScoreRequest {
    @JsonKey(name: "accuracy")
    final double accuracy;
    @JsonKey(name: "difficult_rate")
    final double difficultRate;
    @JsonKey(name: "id")
    final String id;
    @JsonKey(name: "num_of_quiz")
    final int numOfQuiz;
    @JsonKey(name: "timeMinutes")
    final double timeMinutes;
    @JsonKey(name: "word")
    final String word;
    @JsonKey(name: "isChangeDifficulty")
    final bool? isChangeDifficulty;

    FlashCardUpdateScoreRequest({
        required this.accuracy,
        required this.difficultRate,
        required this.id,
        required this.numOfQuiz,
        required this.timeMinutes,
        required this.word,
        this.isChangeDifficulty,
    });

    factory FlashCardUpdateScoreRequest.fromJson(Map<String, dynamic> json) => _$FlashCardUpdateScoreRequestFromJson(json);

    Map<String, dynamic> toJson() => _$FlashCardUpdateScoreRequestToJson(this);
}
