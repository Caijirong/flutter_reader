import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';
import 'package:flutter_reader/features/book/book_detail_controller.dart';
import 'package:flutter_reader/features/book/book_detail_page.dart';

import '../search/search_test_helpers.dart';

void main() {
  testWidgets('renders metadata and chapters after load', (tester) async {
    final source = makeTestSource('source-a');
    final candidate = makeTestBook('source-a', 'Test');
    final book = Book(
      bookId: candidate.bookId,
      sourceId: candidate.sourceId,
      title: 'Detail Title',
      author: 'Author Test',
      detailUrl: candidate.detailUrl,
      description: 'A great book.',
      latestChapter: 'Chap 2',
    );
    final chapters = [
      BookChapter(
        chapterId: 'c1',
        bookId: book.bookId,
        title: 'Chapter One',
        url: '${book.detailUrl}/1',
        order: 1,
      ),
    ];
    final repository = _FakeBookRepository(book: book, chapters: chapters);
    final controller = BookDetailController(
      repository: repository,
      source: source,
      searchBook: candidate,
    );

    await tester.pumpWidget(MaterialApp(home: BookDetailPage(controller: controller)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Detail Title'), findsOneWidget);
    expect(find.text('Author Test'), findsOneWidget);
    expect(find.text('Latest: Chap 2'), findsOneWidget);
    expect(find.text('Chapter One'), findsOneWidget);
    await tester.tap(find.text('Chapter One'));
    await tester.pump();
    expect(find.text('Selected Chapter One'), findsOneWidget);
  });

  testWidgets('shows error message when controller fails', (tester) async {
    final source = makeTestSource('source-b');
    final candidate = makeTestBook('source-b', 'Error');
    final repository = _FailingBookRepository('boom');
    final controller = BookDetailController(
      repository: repository,
      source: source,
      searchBook: candidate,
    );

    await tester.pumpWidget(MaterialApp(home: BookDetailPage(controller: controller)));
    await tester.pumpAndSettle();

    expect(find.textContaining('boom'), findsOneWidget);
  });

  testWidgets('renders empty chapter state and responds to tap', (tester) async {
    final source = makeTestSource('source-c');
    final candidate = makeTestBook('source-c', 'Empty');
    final book = Book(
      bookId: candidate.bookId,
      sourceId: candidate.sourceId,
      title: 'Empty Book',
      author: 'Author Empty',
      detailUrl: candidate.detailUrl,
    );
    final repository = _FakeBookRepository(book: book, chapters: []);
    final controller = BookDetailController(
      repository: repository,
      source: source,
      searchBook: candidate,
    );

    await tester.pumpWidget(MaterialApp(home: BookDetailPage(controller: controller)));
    await tester.pumpAndSettle();

    expect(find.text('No chapters available.'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}

class _FakeBookRepository implements BookRepository {
  final Book book;
  final List<BookChapter> chapters;

  _FakeBookRepository({required this.book, this.chapters = const []});

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) async => book;

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) async => chapters;

  @override
  Future<List<SearchBook>> search(String query, BookSource source) {
    throw UnimplementedError();
  }

  @override
  Future<String> fetchChapterContent(BookChapter chapter, BookSource source) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) {
    throw UnimplementedError();
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<Book> saveBook(Book book) => Future.value(book);

  @override
  Future<void> removeBook(String bookId) async {}

  @override
  Future<List<Book>> loadBookshelf() async => const [];
}

class _FailingBookRepository implements BookRepository {
  final String message;

  _FailingBookRepository(this.message);

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) async {
    throw Exception(message);
  }

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) async {
    throw Exception(message);
  }

  @override
  Future<List<SearchBook>> search(String query, BookSource source) {
    throw UnimplementedError();
  }

  @override
  Future<String> fetchChapterContent(BookChapter chapter, BookSource source) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) {
    throw UnimplementedError();
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) {
    throw UnimplementedError();
  }

  @override
  Future<Book> saveBook(Book book) => throw UnimplementedError();

  @override
  Future<void> removeBook(String bookId) => throw UnimplementedError();

  @override
  Future<List<Book>> loadBookshelf() => throw UnimplementedError();
}
