// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcrMetaData _$OcrMetaDataFromJson(Map<String, dynamic> json) => OcrMetaData(
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => Page.fromJson(e as Map<String, dynamic>))
          .toList(),
      sessionUploadFolder: json['session_upload_folder'] as String?,
      imgId:
          (json['img_id'] as List<dynamic>?)?.map((e) => e as String).toList(),
      rawFilename: json['raw_filename'] as String?,
      imageData: (json['image_data'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OcrMetaDataToJson(OcrMetaData instance) =>
    <String, dynamic>{
      'pages': instance.pages,
      'session_upload_folder': instance.sessionUploadFolder,
      'img_id': instance.imgId,
      'raw_filename': instance.rawFilename,
      'image_data': instance.imageData,
    };

Page _$PageFromJson(Map<String, dynamic> json) => Page(
      elements: (json['elements'] as List<dynamic>?)
          ?.map((e) => Element.fromJson(e as Map<String, dynamic>))
          .toList(),
      tables: json['tables'] as List<dynamic>?,
      font: json['font'] as String?,
      rows: (json['rows'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      lines: (json['lines'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      docSegmentConfidence:
          (json['doc_segment_confidence'] as num?)?.toDouble(),
      docSegmentFilePath: json['doc_segment_file_path'] as String?,
      imageSize: json['image_size'] == null
          ? null
          : ImageSize.fromJson(json['image_size'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : Stats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'elements': instance.elements,
      'tables': instance.tables,
      'font': instance.font,
      'rows': instance.rows,
      'lines': instance.lines,
      'doc_segment_confidence': instance.docSegmentConfidence,
      'doc_segment_file_path': instance.docSegmentFilePath,
      'image_size': instance.imageSize,
      'stats': instance.stats,
    };

Element _$ElementFromJson(Map<String, dynamic> json) => Element(
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      text: json['text'],
      type: json['type'] as String?,
      styles:
          (json['styles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      fontSize: (json['font_size'] as num?)?.toInt(),
      wordConfidences: (json['word_confidences'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      lineConfidence: (json['line_confidence'] as num?)?.toDouble(),
      wordLocations: (json['word_locations'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      figurePath: json['figure_path'] as String?,
      isFloatingImage: json['is_floating_image'] as bool?,
    );

Map<String, dynamic> _$ElementToJson(Element instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'text': instance.text,
      'type': instance.type,
      'styles': instance.styles,
      'font_size': instance.fontSize,
      'word_confidences': instance.wordConfidences,
      'line_confidence': instance.lineConfidence,
      'word_locations': instance.wordLocations,
      'figure_path': instance.figurePath,
      'is_floating_image': instance.isFloatingImage,
    };

ImageSize _$ImageSizeFromJson(Map<String, dynamic> json) => ImageSize(
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ImageSizeToJson(ImageSize instance) => <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
    };

Line _$LineFromJson(Map<String, dynamic> json) => Line(
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      w: (json['w'] as num?)?.toInt(),
      h: (json['h'] as num?)?.toInt(),
      text: json['text'] as String?,
      type: json['type'] as String?,
      styles:
          (json['styles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      fontSize: (json['font_size'] as num?)?.toInt(),
      wordConfidences: (json['word_confidences'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      lineConfidence: (json['line_confidence'] as num?)?.toDouble(),
      wordLocations: (json['word_locations'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
    );

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
      'text': instance.text,
      'type': instance.type,
      'styles': instance.styles,
      'font_size': instance.fontSize,
      'word_confidences': instance.wordConfidences,
      'line_confidence': instance.lineConfidence,
      'word_locations': instance.wordLocations,
    };

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
      textBlock: (json['text_block'] as num?)?.toInt(),
      character: (json['character'] as num?)?.toInt(),
      paragraph: (json['paragraph'] as num?)?.toInt(),
      figure: (json['figure'] as num?)?.toInt(),
      table: (json['table'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'text_block': instance.textBlock,
      'character': instance.character,
      'paragraph': instance.paragraph,
      'figure': instance.figure,
      'table': instance.table,
    };
