// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_card_quizz_score_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlashCardQuizzScoreRequest _$FlashCardQuizzScoreRequestFromJson(
        Map<String, dynamic> json) =>
    FlashCardQuizzScoreRequest(
      numOfCorrect: (json['num_of_correct'] as num?)?.toInt(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      difficultRate: (json['difficult_rate'] as num?)?.toDouble(),
      id: json['id'] as String?,
      numOfQuiz: (json['num_of_quiz'] as num?)?.toInt(),
      timeMinutes: (json['timeMinutes'] as num?)?.toDouble(),
      word: json['word'] as String?,
      isChangeDifficulty: json['isChangeDifficulty'] as bool?,
    );

Map<String, dynamic> _$FlashCardQuizzScoreRequestToJson(
        FlashCardQuizzScoreRequest instance) =>
    <String, dynamic>{
      'num_of_correct': instance.numOfCorrect,
      'accuracy': instance.accuracy,
      'difficult_rate': instance.difficultRate,
      'id': instance.id,
      'num_of_quiz': instance.numOfQuiz,
      'timeMinutes': instance.timeMinutes,
      'word': instance.word,
      'isChangeDifficulty': instance.isChangeDifficulty,
    };
