// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ApiClient implements ApiClient {
  _ApiClient(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  });

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<int>> extractOcr({
    required File file,
    required String returnType,
    int? isPreprocess,
    int? removeNoise,
    int? extractFigure,
    int? extractTextInFigure,
    int? extractTable,
    int? isFullLine,
    int? extractParagraph,
    int? extractSignature,
    int? startPage,
    int? endPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'return_type',
      returnType,
    ));
    if (isPreprocess != null) {
      _data.fields.add(MapEntry(
        'is_preprocess',
        isPreprocess.toString(),
      ));
    }
    if (removeNoise != null) {
      _data.fields.add(MapEntry(
        'remove_noise',
        removeNoise.toString(),
      ));
    }
    if (extractFigure != null) {
      _data.fields.add(MapEntry(
        'extract_figure',
        extractFigure.toString(),
      ));
    }
    if (extractTextInFigure != null) {
      _data.fields.add(MapEntry(
        'extract_text_in_figure',
        extractTextInFigure.toString(),
      ));
    }
    if (extractTable != null) {
      _data.fields.add(MapEntry(
        'extract_table',
        extractTable.toString(),
      ));
    }
    if (isFullLine != null) {
      _data.fields.add(MapEntry(
        'is_full_line',
        isFullLine.toString(),
      ));
    }
    if (extractParagraph != null) {
      _data.fields.add(MapEntry(
        'extract_paragraph',
        extractParagraph.toString(),
      ));
    }
    if (extractSignature != null) {
      _data.fields.add(MapEntry(
        'extract_signature',
        extractSignature.toString(),
      ));
    }
    if (startPage != null) {
      _data.fields.add(MapEntry(
        'start_page',
        startPage.toString(),
      ));
    }
    if (endPage != null) {
      _data.fields.add(MapEntry(
        'end_page',
        endPage.toString(),
      ));
    }
    final _options = _setStreamType<List<int>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
      responseType: ResponseType.bytes,
    )
        .compose(
          _dio.options,
          '/ocr/extract_ocr',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<OcrMetaData> extractOcrJson({
    required File file,
    required String returnType,
    int? isPreprocess,
    int? removeNoise,
    int? extractFigure,
    int? extractTextInFigure,
    int? extractTable,
    int? isFullLine,
    int? extractParagraph,
    int? extractSignature,
    int? startPage,
    int? endPage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'return_type',
      returnType,
    ));
    if (isPreprocess != null) {
      _data.fields.add(MapEntry(
        'is_preprocess',
        isPreprocess.toString(),
      ));
    }
    if (removeNoise != null) {
      _data.fields.add(MapEntry(
        'remove_noise',
        removeNoise.toString(),
      ));
    }
    if (extractFigure != null) {
      _data.fields.add(MapEntry(
        'extract_figure',
        extractFigure.toString(),
      ));
    }
    if (extractTextInFigure != null) {
      _data.fields.add(MapEntry(
        'extract_text_in_figure',
        extractTextInFigure.toString(),
      ));
    }
    if (extractTable != null) {
      _data.fields.add(MapEntry(
        'extract_table',
        extractTable.toString(),
      ));
    }
    if (isFullLine != null) {
      _data.fields.add(MapEntry(
        'is_full_line',
        isFullLine.toString(),
      ));
    }
    if (extractParagraph != null) {
      _data.fields.add(MapEntry(
        'extract_paragraph',
        extractParagraph.toString(),
      ));
    }
    if (extractSignature != null) {
      _data.fields.add(MapEntry(
        'extract_signature',
        extractSignature.toString(),
      ));
    }
    if (startPage != null) {
      _data.fields.add(MapEntry(
        'start_page',
        startPage.toString(),
      ));
    }
    if (endPage != null) {
      _data.fields.add(MapEntry(
        'end_page',
        endPage.toString(),
      ));
    }
    final _options = _setStreamType<OcrMetaData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
      responseType: ResponseType.json,
    )
        .compose(
          _dio.options,
          '/ocr/extract_ocr',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late OcrMetaData _value;
    try {
      _value = OcrMetaData.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DocumentIEResponse> documentIE({
    required File file,
    required String returnType,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'return_type',
      returnType,
    ));
    final _options = _setStreamType<DocumentIEResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/ie/document_ie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DocumentIEResponse _value;
    try {
      _value = DocumentIEResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<IeMetadata> documentIEJson({
    required File file,
    required String returnType,
    int? returnNow,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
      'file',
      MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    ));
    _data.fields.add(MapEntry(
      'return_type',
      returnType,
    ));
    if (returnNow != null) {
      _data.fields.add(MapEntry(
        'return_now',
        returnNow.toString(),
      ));
    }
    final _options = _setStreamType<IeMetadata>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
      responseType: ResponseType.json,
    )
        .compose(
          _dio.options,
          '/ie/document_ie',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late IeMetadata _value;
    try {
      _value = IeMetadata.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<CheckProcessStatusResponse> checkProcessStatus(
    String sessionId,
    String returnType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session_id': sessionId,
      'return_type': returnType,
    };
    final _options = _setStreamType<CheckProcessStatusResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/check_process_status',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late CheckProcessStatusResponse _value;
    try {
      _value = CheckProcessStatusResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<IeMetadata> checkProcessStatusJson(
    String sessionId,
    String returnType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session_id': sessionId,
      'return_type': returnType,
    };
    final _options = _setStreamType<IeMetadata>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      responseType: ResponseType.json,
    )
        .compose(
          _dio.options,
          '/check_process_status',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late IeMetadata _value;
    try {
      _value = IeMetadata.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<int>> checkProcessStatusFile(
    String sessionId,
    String returnType,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session_id': sessionId,
      'return_type': returnType,
    };
    final _options = _setStreamType<List<int>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      responseType: ResponseType.bytes,
    )
        .compose(
          _dio.options,
          '/check_process_status',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
