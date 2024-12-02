// To parse this JSON data, do
//
//     final flashCardQuizz = flashCardQuizzFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'flash_card_quizz.g.dart';

List<FlashCardQuizz> flashCardQuizzFromJson(String str) => List<FlashCardQuizz>.from(json.decode(str).map((x) => FlashCardQuizz.fromJson(x)));

String flashCardQuizzToJson(List<FlashCardQuizz> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FlashCardQuizz {
    @JsonKey(name: "flashcardId")
    String flashcardId;
    @JsonKey(name: "quiz")
    Quiz quiz;
    @JsonKey(name: "word")
    String word;

    FlashCardQuizz({
        required this.flashcardId,
        required this.quiz,
        required this.word,
    });

    factory FlashCardQuizz.fromJson(Map<String, dynamic> json) => _$FlashCardQuizzFromJson(json);

    Map<String, dynamic> toJson() => _$FlashCardQuizzToJson(this);
}

@JsonSerializable()
class Quiz {
    @JsonKey(name: "correctAnswer")
    String correctAnswer;
    @JsonKey(name: "options")
    List<String> options;
    @JsonKey(name: "question")
    String question;

    Quiz({
        required this.correctAnswer,
        required this.options,
        required this.question,
    });

    factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

    Map<String, dynamic> toJson() => _$QuizToJson(this);
}
