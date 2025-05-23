// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckResult _$CheckResultFromJson(Map<String, dynamic> json) => CheckResult(
      word: json['word'] as String,
      status: $enumDecode(_$CheckResultStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CheckResultToJson(CheckResult instance) =>
    <String, dynamic>{
      'word': instance.word,
      'status': _$CheckResultStatusEnumMap[instance.status]!,
    };

const _$CheckResultStatusEnumMap = {
  CheckResultStatus.correct: 'correct',
  CheckResultStatus.incorrect: 'incorrect',
  CheckResultStatus.next: 'next',
};
