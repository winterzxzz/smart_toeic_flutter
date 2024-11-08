// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_ie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentIEResponse _$DocumentIEResponseFromJson(Map<String, dynamic> json) =>
    DocumentIEResponse(
      status: json['status'] as String?,
      sessionId: json['session_id'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DocumentIEResponseToJson(DocumentIEResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'session_id': instance.sessionId,
    };
