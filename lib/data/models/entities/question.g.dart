// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: (json['id'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      image: json['image'] as String?,
      audio: json['audio'] as String?,
      paragraph: json['paragraph'] as String?,
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      correctanswer: $enumDecode(_$CorrectanswerEnumMap, json['correctanswer']),
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
      question: json['question'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'image': instance.image,
      'audio': instance.audio,
      'paragraph': instance.paragraph,
      'option1': instance.option1,
      'option2': instance.option2,
      'option3': instance.option3,
      'option4': instance.option4,
      'correctanswer': _$CorrectanswerEnumMap[instance.correctanswer]!,
      'options': instance.options,
      'question': instance.question,
    };

const _$CorrectanswerEnumMap = {
  Correctanswer.A: 'A',
  Correctanswer.B: 'B',
  Correctanswer.C: 'C',
  Correctanswer.D: 'D',
};

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: $enumDecode(_$CorrectanswerEnumMap, json['id']),
      content: json['content'],
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': _$CorrectanswerEnumMap[instance.id]!,
      'content': instance.content,
    };
