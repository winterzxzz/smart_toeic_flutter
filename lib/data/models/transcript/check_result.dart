import 'package:json_annotation/json_annotation.dart';

part 'check_result.g.dart';

enum CheckResultStatus { correct, incorrect, next }

@JsonSerializable()
class CheckResult {
  final String word;
  final CheckResultStatus status;

  const CheckResult({required this.word, required this.status});

  factory CheckResult.fromJson(Map<String, dynamic> json) =>
      _$CheckResultFromJson(json);
  Map<String, dynamic> toJson() => _$CheckResultToJson(this);
}
