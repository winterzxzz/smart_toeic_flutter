import 'package:json_annotation/json_annotation.dart';

part 'ie_meta_data.g.dart';

@JsonSerializable()
class IeMetadata {
  @JsonKey(name: "ocr")
  final List<Ocr>? ocr;

  IeMetadata({
    this.ocr,
  });

  factory IeMetadata.fromJson(Map<String, dynamic> json) =>
      _$IeMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$IeMetadataToJson(this);
}

@JsonSerializable()
class Ocr {
  @JsonKey(name: "content")
  final String? content;
  @JsonKey(name: "location")
  final List<int>? location;
  @JsonKey(name: "word_location")
  final List<List<int>>? wordLocation;
  @JsonKey(name: "page")
  final int? page;

  Ocr({
    this.content,
    this.location,
    this.wordLocation,
    this.page,
  });

  factory Ocr.fromJson(Map<String, dynamic> json) => _$OcrFromJson(json);

  Map<String, dynamic> toJson() => _$OcrToJson(this);
}
