// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'],
      number: (json['number'] as num?)?.toInt(),
      image: json['image'] as String?,
      audio: json['audio'] as String?,
      paragraph: json['paragraph'] as String?,
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      option4: json['option4'],
      correctanswer: json['correctanswer'] as String?,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'correctanswer': instance.correctanswer,
      'options': instance.options,
      'question': instance.question,
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      id: json['id'] as String?,
      content: json['content'],
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
    };
