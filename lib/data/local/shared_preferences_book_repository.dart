import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';

const _kBookshelfKey = 'flutter_reader_bookshelf';
const _kSessionKeyPrefix = 'flutter_reader_session_';

class SharedPreferencesBookRepository implements BookRepository {
  final SharedPreferences prefs;

  SharedPreferencesBookRepository(this.prefs);

  @override
  Future<List<SearchBook>> search(String query, BookSource source) {
    throw UnimplementedError('Search is not supported by the local repository.');
  }

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) {
    throw UnimplementedError('Detail fetch requires remote integration.');
  }

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) {
    throw UnimplementedError('Chapter fetch requires remote integration.');
  }

  @override
  Future<String> fetchChapterContent(BookChapter chapter, BookSource source) {
    throw UnimplementedError('Fetching chapter content is not supported here.');
  }

  @override
  Future<Book> saveBook(Book book) async {
    final bookshelf = await loadBookshelf();
    final updated = List<Book>.from(bookshelf);
    final index = updated.indexWhere((entry) => entry.bookId == book.bookId);
    if (index >= 0) {
      updated[index] = book;
    } else {
      updated.add(book);
    }
    await _writeBookshelf(updated);
    return book;
  }

  @override
  Future<void> removeBook(String bookId) async {
    final bookshelf = await loadBookshelf();
    final updated = bookshelf.where((entry) => entry.bookId != bookId).toList();
    await _writeBookshelf(updated);
  }

  @override
  Future<List<Book>> loadBookshelf() async {
    final raw = prefs.getStringList(_kBookshelfKey);
    if (raw == null) return [];
    return raw.map((entry) => Book.fromJson(jsonDecode(entry) as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) async {
    final storageKey = '$_kSessionKeyPrefix${session.bookId}';
    await prefs.setString(storageKey, jsonEncode(session.toJson()));
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async {
    final storageKey = '$_kSessionKeyPrefix$bookId';
    final raw = prefs.getString(storageKey);
    if (raw == null) return null;
    return ReaderSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _writeBookshelf(List<Book> books) async {
    final payload = books.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList(_kBookshelfKey, payload);
  }
}
