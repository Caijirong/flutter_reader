import 'package:flutter_reader/data/local/shared_preferences_source_repository.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

BookSource _makeSource(String id, {bool enabled = true}) {
  return BookSource(
    id: id,
    name: 'Source $id',
    baseUrl: 'https://example.com/$id',
    searchEndpoint: '/search',
    detailEndpoint: '/detail',
    chapterEndpoint: '/chapters',
    contentEndpoint: '/content',
    enabled: enabled,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saveSource stores and loadSources reloads it', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesSourceRepository(prefs);
    final source = _makeSource('alpha');

    await repository.saveSource(source);
    final saved = await repository.loadSources();

    expect(saved, contains(source));
  });

  test('setEnabled updates persisted flag', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesSourceRepository(prefs);
    final source = _makeSource('beta');

    await repository.saveSource(source);
    await repository.setEnabled(source.id, false);

    final saved = await repository.loadSources();
    expect(saved.single.enabled, isFalse);
  });

  test('deleteSource removes entry', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesSourceRepository(prefs);
    final source = _makeSource('gamma');

    await repository.saveSource(source);
    await repository.deleteSource(source.id);

    final saved = await repository.loadSources();
    expect(saved, isEmpty);
  });

  test('importFromJson adds source and returns it', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesSourceRepository(prefs);
    final json = {
      'id': 'delta',
      'name': 'Delta',
      'baseUrl': 'https://example.com/delta',
      'searchEndpoint': '/search',
      'detailEndpoint': '/detail',
      'chapterEndpoint': '/chapters',
      'contentEndpoint': '/content',
      'enabled': true,
    };

    final imported = await repository.importFromJson(json);

    expect(imported.id, 'delta');
    expect(await repository.loadSources(), contains(imported));
  });
}
