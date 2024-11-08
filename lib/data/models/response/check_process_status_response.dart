
import 'package:json_annotation/json_annotation.dart';
part 'check_process_status_response.g.dart';
@JsonSerializable()
class CheckProcessStatusResponse {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'percentage')
  final int? percentage;

  CheckProcessStatusResponse(this.status, this.percentage);

  factory CheckProcessStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckProcessStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckProcessStatusResponseToJson(this);
}
