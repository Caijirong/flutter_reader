import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_reader/data/models/book_source.dart';

void main() {
  group('BookSource', () {
    test('requires identity fields, defaults enabled, and supports JSON', () {
      final source = BookSource(
        id: 'sample-source',
        name: 'Sample Source',
        baseUrl: 'https://example.com',
        searchEndpoint: '/api/search',
        detailEndpoint: '/api/book',
        chapterEndpoint: '/api/toc',
        contentEndpoint: '/api/chapter',
      );

      expect(source.id, 'sample-source');
      expect(source.name, 'Sample Source');
      expect(source.enabled, isTrue);

      final json = source.toJson();
      expect(json['id'], 'sample-source');
      expect(json['name'], 'Sample Source');
      expect(json['enabled'], isTrue);

      final recreated = BookSource.fromJson(json);
      expect(recreated, source);
    });
  });
}
