import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/features/sources/source_import_controller.dart';
void main() {
  group('SourceImportController', () {
    late SourceImportController controller;

    setUp(() {
      controller = SourceImportController();
    });

    test('imports from text payload and reports results', () async {
      final text = '''
      [
        {
          "id": "t1",
          "name": "Text Source",
          "baseUrl": "https://text.example",
          "searchEndpoint": "/search",
          "detailEndpoint": "/detail",
          "chapterEndpoint": "/chapter",
          "contentEndpoint": "/content"
        }
      ]
      ''';

      final result = await controller.importFromText(text);

      expect(result.validSources, hasLength(1));
      expect(result.invalidSources, isEmpty);
      expect(result.duplicates, isEmpty);
    });

    test('reports invalid entries and duplicates', () async {
      final payload = '''
      [
        {
          "id": "dup",
          "name": "Valid",
          "baseUrl": "https://example",
          "searchEndpoint": "/s",
          "detailEndpoint": "/d",
          "chapterEndpoint": "/c",
          "contentEndpoint": "/p"
        },
        {
          "name": "Missing id"
        },
        {
          "id": "dup",
          "name": "Dup",
          "baseUrl": "https://example",
          "searchEndpoint": "/s",
          "detailEndpoint": "/d",
          "chapterEndpoint": "/c",
          "contentEndpoint": "/p"
        }
      ]
      ''';

      final result = await controller.importFromText(payload);

      expect(result.validSources, hasLength(1));
      expect(result.invalidSources, hasLength(1));
      expect(result.duplicates, contains('dup'));
    });

    test('importFromClipboard proxies to text import', () async {
      final clipboardValue = '[]';
      final result = await controller.importFromClipboard(clipboardValue);
      expect(result.validSources, isEmpty);
    });
  });
}
