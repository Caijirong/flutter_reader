import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/core/network/response_decoder.dart';

void main() {
  const payload = 'Simple – payload';
  const latinPayload = 'Simple - payload with ä';

  test('decodes utf8 when charset is missing', () {
    final decoder = ResponseDecoder();
    final bytes = utf8.encode(payload);
    final result = decoder.decode(bytes, {});
    expect(result, payload);
  });

  test('respects charset from content-type header', () {
    final decoder = ResponseDecoder();
    final bytes = latin1.encode(latinPayload);
    final headers = {'content-type': 'text/html; charset=iso-8859-1'};
    final result = decoder.decode(bytes, headers);
    expect(result, latinPayload);
  });

  test('falls back to utf8 for unsupported charset', () {
    final decoder = ResponseDecoder();
    final bytes = utf8.encode(payload);
    expect(
      decoder.decode(bytes, {'content-type': 'text/plain; charset=bogus'}),
      payload,
    );
  });
}
