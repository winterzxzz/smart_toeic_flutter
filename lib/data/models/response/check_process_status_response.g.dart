// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_process_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckProcessStatusResponse _$CheckProcessStatusResponseFromJson(
        Map<String, dynamic> json) =>
    CheckProcessStatusResponse(
      json['status'] as String?,
      (json['percentage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CheckProcessStatusResponseToJson(
        CheckProcessStatusResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'percentage': instance.percentage,
    };
