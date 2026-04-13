import 'dart:async';

import 'package:http/http.dart' as http;

import 'response_decoder.dart';

class ReaderHttpResponse {
  final Uri url;
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  const ReaderHttpResponse({
    required this.url,
    required this.statusCode,
    required this.headers,
    required this.body,
  });
}

class ReaderHttpClient {
  final http.Client _inner;
  final ResponseDecoder _decoder;

  ReaderHttpClient({http.Client? inner, ResponseDecoder? decoder})
      : _inner = inner ?? http.Client(),
        _decoder = decoder ?? ResponseDecoder();

  Future<ReaderHttpResponse> get(Uri uri, {Map<String, String>? headers}) async {
    final response = await _inner.get(uri, headers: headers);
    final body = _decoder.decode(response.bodyBytes, response.headers);
    return ReaderHttpResponse(
      url: uri,
      statusCode: response.statusCode,
      headers: response.headers,
      body: body,
    );
  }

  void close() {
    _inner.close();
  }
}
