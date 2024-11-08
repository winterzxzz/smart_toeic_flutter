import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:toeic_desktop/data/models/entities/ie_meta_data.dart';
import 'package:toeic_desktop/data/models/entities/ocr_meta_data.dart';
import 'package:toeic_desktop/data/models/response/check_process_status_response.dart';
import 'package:toeic_desktop/data/models/response/document_ie_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/ocr/extract_ocr')
  @DioResponseType(ResponseType.bytes)
  @MultiPart()
  Future<List<int>> extractOcr({
    @Part(name: 'file') required File file,
    @Part(name: 'return_type') required String returnType,
    @Part(name: 'is_preprocess') int? isPreprocess,
    @Part(name: 'remove_noise') int? removeNoise,
    @Part(name: 'extract_figure') int? extractFigure,
    @Part(name: 'extract_text_in_figure') int? extractTextInFigure,
    @Part(name: 'extract_table') int? extractTable,
    @Part(name: 'is_full_line') int? isFullLine,
    @Part(name: 'extract_paragraph') int? extractParagraph,
    @Part(name: 'extract_signature') int? extractSignature,
    @Part(name: 'start_page') int? startPage,
    @Part(name: 'end_page') int? endPage,
  });

  @POST('/ocr/extract_ocr')
  @DioResponseType(ResponseType.json)
  @MultiPart()
  Future<OcrMetaData> extractOcrJson({
    @Part(name: 'file') required File file,
    @Part(name: 'return_type') required String returnType,
    @Part(name: 'is_preprocess') int? isPreprocess,
    @Part(name: 'remove_noise') int? removeNoise,
    @Part(name: 'extract_figure') int? extractFigure,
    @Part(name: 'extract_text_in_figure') int? extractTextInFigure,
    @Part(name: 'extract_table') int? extractTable,
    @Part(name: 'is_full_line') int? isFullLine,
    @Part(name: 'extract_paragraph') int? extractParagraph,
    @Part(name: 'extract_signature') int? extractSignature,
    @Part(name: 'start_page') int? startPage,
    @Part(name: 'end_page') int? endPage,
  });

  @POST('/ie/document_ie')
  @MultiPart()
  Future<DocumentIEResponse> documentIE({
    @Part(name: 'file') required File file,
    @Part(name: 'return_type') required String returnType,
  });

  @POST('/ie/document_ie')
  @DioResponseType(ResponseType.json)
  @MultiPart()
  Future<IeMetadata> documentIEJson({
    @Part(name: 'file') required File file,
    @Part(name: 'return_type') required String returnType,
    @Part(name: 'return_now') int? returnNow,
  });

  @POST('/check_process_status')
  Future<CheckProcessStatusResponse> checkProcessStatus(
    @Field('session_id') String sessionId,
    @Field('return_type') String returnType,
  );

  @POST('/check_process_status')
  @DioResponseType(ResponseType.json)
  Future<IeMetadata> checkProcessStatusJson(
    @Field('session_id') String sessionId,
    @Field('return_type') String returnType,
  );

  @POST('/check_process_status')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> checkProcessStatusFile(
    @Field('session_id') String sessionId,
    @Field('return_type') String returnType,
  );
}
