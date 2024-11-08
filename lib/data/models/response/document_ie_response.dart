
import 'package:json_annotation/json_annotation.dart';
part 'document_ie_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, fieldRename: FieldRename.snake)
class DocumentIEResponse {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'session_id')
  final String? sessionId;

  DocumentIEResponse({this.status, this.sessionId, this.message});

  factory DocumentIEResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentIEResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentIEResponseToJson(this);
}

