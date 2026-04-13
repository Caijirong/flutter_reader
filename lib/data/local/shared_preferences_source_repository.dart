import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/repositories/source_repository.dart';

const _kSourcesKey = 'flutter_reader_sources';

class SharedPreferencesSourceRepository implements SourceRepository {
  final SharedPreferences prefs;

  SharedPreferencesSourceRepository(this.prefs);

  @override
  Future<BookSource> importFromJson(Map<String, dynamic> json) async {
    final source = BookSource.fromJson(json);
    return saveSource(source);
  }

  @override
  Future<void> deleteSource(String id) async {
    final sources = await loadSources();
    final updated = sources.where((source) => source.id != id).toList();
    await _write(updated);
  }

  @override
  Future<List<BookSource>> loadSources() async {
    final raw = prefs.getStringList(_kSourcesKey);
    if (raw == null) return [];
    return raw
        .map((item) => BookSource.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<BookSource> saveSource(BookSource source) async {
    final sources = await loadSources();
    final updated = List<BookSource>.from(sources);
    final index = updated.indexWhere((entry) => entry.id == source.id);
    if (index >= 0) {
      updated[index] = source;
    } else {
      updated.add(source);
    }
    await _write(updated);
    return source;
  }

  @override
  Future<void> setEnabled(String id, bool enabled) async {
    final sources = await loadSources();
    final updated = sources.map((entry) {
      if (entry.id != id) return entry;
      return entry.copyWith(enabled: enabled);
    }).toList();
    await _write(updated);
  }

  @override
  Future<BookSource> getSource(String id) async {
    final sources = await loadSources();
    return sources.firstWhere((entry) => entry.id == id);
  }

  Future<void> _write(List<BookSource> sources) async {
    final payload = sources.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList(_kSourcesKey, payload);
  }
}
