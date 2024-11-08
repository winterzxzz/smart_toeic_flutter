import 'package:json_annotation/json_annotation.dart';

part 'ocr_meta_data.g.dart';

@JsonSerializable()
class OcrMetaData {
  @JsonKey(name: "pages")
  final List<Page>? pages;
  @JsonKey(name: "session_upload_folder")
  final String? sessionUploadFolder;
  @JsonKey(name: "img_id")
  final List<String>? imgId;
  @JsonKey(name: "raw_filename")
  final String? rawFilename;
  @JsonKey(name: "image_data")
  final List<String>? imageData;

  OcrMetaData({
    this.pages,
    this.sessionUploadFolder,
    this.imgId,
    this.rawFilename,
    this.imageData,
  });

  factory OcrMetaData.fromJson(Map<String, dynamic> json) =>
      _$OcrMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$OcrMetaDataToJson(this);
}

@JsonSerializable()
class Page {
  @JsonKey(name: "elements")
  final List<Element>? elements;
  @JsonKey(name: "tables")
  final List<dynamic>? tables;
  @JsonKey(name: "font")
  final String? font;
  @JsonKey(name: "rows")
  final List<List<int>>? rows;
  @JsonKey(name: "lines")
  final List<Line>? lines;
  @JsonKey(name: "doc_segment_confidence")
  final double? docSegmentConfidence;
  @JsonKey(name: "doc_segment_file_path")
  final String? docSegmentFilePath;
  @JsonKey(name: "image_size")
  final ImageSize? imageSize;
  @JsonKey(name: "stats")
  final Stats? stats;

  Page({
    this.elements,
    this.tables,
    this.font,
    this.rows,
    this.lines,
    this.docSegmentConfidence,
    this.docSegmentFilePath,
    this.imageSize,
    this.stats,
  });

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);

  Map<String, dynamic> toJson() => _$PageToJson(this);
}

@JsonSerializable()
class Element {
  @JsonKey(name: "x")
  final int? x;
  @JsonKey(name: "y")
  final int? y;
  @JsonKey(name: "w")
  final int? w;
  @JsonKey(name: "h")
  final int? h;
  @JsonKey(name: "text")
  final dynamic text;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "styles")
  final List<String>? styles;
  @JsonKey(name: "font_size")
  final int? fontSize;
  @JsonKey(name: "word_confidences")
  final List<double>? wordConfidences;
  @JsonKey(name: "line_confidence")
  final double? lineConfidence;
  @JsonKey(name: "word_locations")
  final List<List<int>>? wordLocations;
  @JsonKey(name: "figure_path")
  final String? figurePath;
  @JsonKey(name: "is_floating_image")
  final bool? isFloatingImage;

  Element({
    this.x,
    this.y,
    this.w,
    this.h,
    this.text,
    this.type,
    this.styles,
    this.fontSize,
    this.wordConfidences,
    this.lineConfidence,
    this.wordLocations,
    this.figurePath,
    this.isFloatingImage,
  });

  factory Element.fromJson(Map<String, dynamic> json) =>
      _$ElementFromJson(json);

  Map<String, dynamic> toJson() => _$ElementToJson(this);
}

@JsonSerializable()
class ImageSize {
  @JsonKey(name: "height")
  final int? height;
  @JsonKey(name: "width")
  final int? width;

  ImageSize({
    this.height,
    this.width,
  });

  factory ImageSize.fromJson(Map<String, dynamic> json) =>
      _$ImageSizeFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSizeToJson(this);
}

@JsonSerializable()
class Line {
  @JsonKey(name: "x")
  final int? x;
  @JsonKey(name: "y")
  final int? y;
  @JsonKey(name: "w")
  final int? w;
  @JsonKey(name: "h")
  final int? h;
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "type")
  final String? type;
  @JsonKey(name: "styles")
  final List<String>? styles;
  @JsonKey(name: "font_size")
  final int? fontSize;
  @JsonKey(name: "word_confidences")
  final List<double>? wordConfidences;
  @JsonKey(name: "line_confidence")
  final double? lineConfidence;
  @JsonKey(name: "word_locations")
  final List<List<int>>? wordLocations;

  Line({
    this.x,
    this.y,
    this.w,
    this.h,
    this.text,
    this.type,
    this.styles,
    this.fontSize,
    this.wordConfidences,
    this.lineConfidence,
    this.wordLocations,
  });

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Map<String, dynamic> toJson() => _$LineToJson(this);
}

@JsonSerializable()
class Stats {
  @JsonKey(name: "text_block")
  final int? textBlock;
  @JsonKey(name: "character")
  final int? character;
  @JsonKey(name: "paragraph")
  final int? paragraph;
  @JsonKey(name: "figure")
  final int? figure;
  @JsonKey(name: "table")
  final int? table;

  Stats({
    this.textBlock,
    this.character,
    this.paragraph,
    this.figure,
    this.table,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
