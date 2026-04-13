import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';

const _kSessionKeyPrefix = 'flutter_reader_session_';

class SharedPreferencesReaderRepository implements ReaderRepository {
  final SharedPreferences prefs;

  SharedPreferencesReaderRepository(this.prefs);

  @override
  Future<String> fetchChapterContent(BookChapter chapter) {
    throw UnimplementedError('Chapter content requires network access.');
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) async {
    final key = '$_kSessionKeyPrefix${session.bookId}';
    await prefs.setString(key, jsonEncode(session.toJson()));
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async {
    final key = '$_kSessionKeyPrefix$bookId';
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return ReaderSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
