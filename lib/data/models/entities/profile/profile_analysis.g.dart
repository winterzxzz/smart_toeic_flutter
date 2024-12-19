// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileAnalysis _$ProfileAnalysisFromJson(Map<String, dynamic> json) =>
    ProfileAnalysis(
      accuracyByPart: (json['accuracyByPart'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      averageTimeByPart:
          (json['averageTimeByPart'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      categoryAccuracy:
          (json['categoryAccuracy'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, CategoryAccuracy.fromJson(e as Map<String, dynamic>)),
      ),
      listenScore: (json['listenScore'] as num?)?.toInt(),
      readScore: (json['readScore'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
      timeSecondRecommend:
          (json['timeSecondRecommend'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$ProfileAnalysisToJson(ProfileAnalysis instance) =>
    <String, dynamic>{
      'accuracyByPart': instance.accuracyByPart,
      'averageTimeByPart': instance.averageTimeByPart,
      'categoryAccuracy': instance.categoryAccuracy,
      'listenScore': instance.listenScore,
      'readScore': instance.readScore,
      'score': instance.score,
      'timeSecondRecommend': instance.timeSecondRecommend,
    };

CategoryAccuracy _$CategoryAccuracyFromJson(Map<String, dynamic> json) =>
    CategoryAccuracy(
      categoryAccuracyPart: (json['part'] as num?)?.toInt(),
      title: json['title'] as String?,
      accuracy: json['accuracy'] as String?,
    );

Map<String, dynamic> _$CategoryAccuracyToJson(CategoryAccuracy instance) =>
    <String, dynamic>{
      'part': instance.categoryAccuracyPart,
      'title': instance.title,
      'accuracy': instance.accuracy,
    };
