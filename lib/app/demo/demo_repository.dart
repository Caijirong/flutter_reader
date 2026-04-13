import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';

import 'package:flutter_reader/app/demo/demo_data.dart';

/// In-memory repository to keep Task 9 navigation deterministic.
class DemoBookRepository implements BookRepository {
  final List<BookSource> sources;

  DemoBookRepository({required this.sources});

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) async {
    return DemoData.book;
  }

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) async {
    return DemoData.chapters;
  }

  @override
  Future<String> fetchChapterContent(BookChapter chapter, BookSource source) async {
    return DemoData.chapterContents[chapter.chapterId] ?? '';
  }

  @override
  Future<Book> saveBook(Book book) async => book;

  @override
  Future<void> removeBook(String bookId) async {}

  @override
  Future<List<Book>> loadBookshelf() async => [DemoData.book];

  @override
  Future<List<SearchBook>> search(String query, BookSource source) async {
    return [DemoData.searchBook];
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) async {}

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async => null;
}

class DemoReaderRepository implements ReaderRepository {
  @override
  Future<String> fetchChapterContent(BookChapter chapter) async {
    return DemoData.chapterContents[chapter.chapterId] ?? '';
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async => null;

  @override
  Future<void> saveReaderSession(ReaderSession session) async {}
}
