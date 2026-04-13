import 'package:flutter_reader/data/models/book_source.dart';

/// Abstractions for storing and mutating book sources.
abstract class SourceRepository {
  Future<List<BookSource>> loadSources();

  Future<BookSource> getSource(String id);

  Future<BookSource> saveSource(BookSource source);

  Future<void> deleteSource(String id);

  Future<void> setEnabled(String id, bool enabled);

  Future<BookSource> importFromJson(Map<String, dynamic> json);
}
