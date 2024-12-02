// To parse this JSON data, do
//
//     final flashCardQuizRequest = flashCardQuizRequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:toeic_desktop/data/models/entities/flash_card.dart';

part 'flash_card_quiz_request.g.dart';

FlashCardQuizRequest flashCardQuizRequestFromJson(String str) => FlashCardQuizRequest.fromJson(json.decode(str));

String flashCardQuizRequestToJson(FlashCardQuizRequest data) => json.encode(data.toJson());

@JsonSerializable()
class FlashCardQuizRequest {
    @JsonKey(name: "prompt")
    List<FlashCard> prompt;

    FlashCardQuizRequest({
        required this.prompt,
    });

    factory FlashCardQuizRequest.fromJson(Map<String, dynamic> json) => _$FlashCardQuizRequestFromJson(json);

    Map<String, dynamic> toJson() => _$FlashCardQuizRequestToJson(this);
}
