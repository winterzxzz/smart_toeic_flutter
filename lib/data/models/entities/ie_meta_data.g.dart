// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ie_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IeMetadata _$IeMetadataFromJson(Map<String, dynamic> json) => IeMetadata(
      ocr: (json['ocr'] as List<dynamic>?)
          ?.map((e) => Ocr.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IeMetadataToJson(IeMetadata instance) =>
    <String, dynamic>{
      'ocr': instance.ocr,
    };

Ocr _$OcrFromJson(Map<String, dynamic> json) => Ocr(
      content: json['content'] as String?,
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      wordLocation: (json['word_location'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OcrToJson(Ocr instance) => <String, dynamic>{
      'content': instance.content,
      'location': instance.location,
      'word_location': instance.wordLocation,
      'page': instance.page,
    };
