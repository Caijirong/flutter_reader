import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/core/rules/source_json_parser.dart';
void main() {
  group('SourceJsonParser', () {
    late SourceJsonParser parser;

    setUp(() {
      parser = SourceJsonParser();
    });

    test('parses valid Legado-like payload into book sources', () {
      final payload = '''
      [
        {
          "id": "alpha",
          "name": "Alpha Source",
          "baseUrl": "https://alpha.example",
          "searchEndpoint": "/api/search",
          "detailEndpoint": "/api/detail",
          "chapterEndpoint": "/chapter",
          "contentEndpoint": "/content",
          "defaultHeaders": {"User-Agent": "Legado/1"},
          "description": "Test source"
        },
        {
          "id": "beta",
          "name": "Beta Source",
          "baseUrl": "https://beta.example",
          "searchEndpoint": "/search",
          "detailEndpoint": "/detail",
          "chapterEndpoint": "/chapter",
          "contentEndpoint": "/content",
          "enabled": false
        }
      ]
      ''';

      final result = parser.parse(payload);

      expect(result.sources, hasLength(2));
      expect(result.sources[0].id, 'alpha');
      expect(result.sources[0].defaultHeaders, {'User-Agent': 'Legado/1'});
      expect(result.sources[0].description, 'Test source');
      expect(result.sources[1].enabled, false);
    });

    test('reports invalid entries when required fields are missing', () {
      final payload = '''
      [
        {
          "name": "Missing Id"
        }
      ]
      ''';

      final result = parser.parse(payload);

      expect(result.invalidEntries, hasLength(1));
      expect(result.sources, isEmpty);
    });

    test('detects duplicate ids and only keeps first occurrence', () {
      final payload = '''
      [
        {
          "id": "dup",
          "name": "Original",
          "baseUrl": "https://original",
          "searchEndpoint": "/search",
          "detailEndpoint": "/detail",
          "chapterEndpoint": "/chapter",
          "contentEndpoint": "/content"
        },
        {
          "id": "dup",
          "name": "Duplicate",
          "baseUrl": "https://duplicate",
          "searchEndpoint": "/search",
          "detailEndpoint": "/detail",
          "chapterEndpoint": "/chapter",
          "contentEndpoint": "/content"
        }
      ]
      ''';

      final result = parser.parse(payload);

      expect(result.sources, hasLength(1));
      expect(result.sources[0].name, 'Original');
      expect(result.duplicateIds, contains('dup'));
    });

    test('defaults enabled to true when unspecified', () {
      final payload = '''
      [
        {
          "id": "e",
          "name": "Enabled Source",
          "baseUrl": "https://e.example",
          "searchEndpoint": "/s",
          "detailEndpoint": "/d",
          "chapterEndpoint": "/c",
          "contentEndpoint": "/p"
        }
      ]
      ''';

      final result = parser.parse(payload);

      expect(result.sources.single.enabled, isTrue);
    });
  });
}
