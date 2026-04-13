import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';

/// Contracts that power search, detail, and reading flows.
abstract class BookRepository {
  Future<List<SearchBook>> search(String query, BookSource source);

  Future<Book> fetchDetail(SearchBook candidate, BookSource source);

  Future<List<BookChapter>> fetchChapters(Book book, BookSource source);

  Future<String> fetchChapterContent(BookChapter chapter, BookSource source);

  Future<Book> saveBook(Book book);

  Future<void> removeBook(String bookId);

  Future<List<Book>> loadBookshelf();

  Future<void> saveReaderSession(ReaderSession session);

  Future<ReaderSession?> loadReaderSession(String bookId);
}
