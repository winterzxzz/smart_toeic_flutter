// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_quizz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardQuizz _$FlashCardQuizzFromJson(Map<String, dynamic> json) =>
    FlashCardQuizz(
      flashcardId: json['flashcardId'] as String,
      quiz: Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
      word: json['word'] as String,
    );

Map<String, dynamic> _$FlashCardQuizzToJson(FlashCardQuizz instance) =>
    <String, dynamic>{
      'flashcardId': instance.flashcardId,
      'quiz': instance.quiz,
      'word': instance.word,
    };

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      correctAnswer: json['correctAnswer'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      question: json['question'] as String,
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'correctAnswer': instance.correctAnswer,
      'options': instance.options,
      'question': instance.question,
    };
