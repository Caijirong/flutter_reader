import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/features/search/search_controller.dart';
import 'dart:async';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';

import 'search_test_helpers.dart';

void main() {
  group('SearchController', () {
    test('aggregates results across enabled sources', () async {
      final repository = FakeBookRepository(responses: {
        'source-a': [makeTestBook('source-a', 'One')],
        'source-b': [makeTestBook('source-b', 'Two')],
      });
      final controller = SearchController(
        repository: repository,
        sources: [makeTestSource('source-a'), makeTestSource('source-b'), makeTestSource('disabled', enabled: false)],
      );

      await controller.search('keyword');

      expect(controller.isLoading, isFalse);
      expect(controller.sourceResults.map((result) => result.source.id), containsAll(['source-a', 'source-b']));
      expect(controller.sourceResults.firstWhere((result) => result.source.id == 'source-a').books, hasLength(1));
    });

    test('records per-source failures while keeping other results', () async {
      final repository = FakeBookRepository(
        responses: {'source-a': [makeTestBook('source-a', 'One')]},
        failingSources: {'source-b'},
      );
      final controller = SearchController(
        repository: repository,
        sources: [makeTestSource('source-a'), makeTestSource('source-b')],
      );

      await controller.search('keyword');

      final errorResult = controller.sourceResults.firstWhere((result) => result.source.id == 'source-b');
      expect(errorResult.error, contains('source-b'));
      final successResult = controller.sourceResults.firstWhere((result) => result.source.id == 'source-a');
      expect(successResult.books, hasLength(1));
    });

    test('stale search results are ignored when newer search runs', () async {
      final completer = Completer<List<SearchBook>>();
      final repository = _CallbackBookRepository(
        searchCallback: (query, source) {
          if (query == 'first') {
            return completer.future;
          }
          return Future.value([makeTestBook('source-a', 'Second')]);
        },
      );
      final controller = SearchController(
        repository: repository,
        sources: [makeTestSource('source-a')],
      );

      final firstFuture = controller.search('first');
      expect(controller.isLoading, isTrue);
      final secondFuture = controller.search('second');

      completer.complete([makeTestBook('source-a', 'First')]);
      await secondFuture;
      await firstFuture;

      expect(controller.sourceResults.single.books.first.title, 'Title Second');
      expect(controller.isLoading, isFalse);
    });
  });
}

class _CallbackBookRepository implements BookRepository {
  final Future<List<SearchBook>> Function(String query, BookSource source) searchCallback;
  final List<Book> saved = [];

  _CallbackBookRepository({required this.searchCallback});

  @override
  Future<List<SearchBook>> search(String query, BookSource source) => searchCallback(query, source);

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) {
    throw UnimplementedError();
  }

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) {
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
  Future<Book> saveBook(Book book) async {
    saved.removeWhere((entry) => entry.bookId == book.bookId);
    saved.add(book);
    return book;
  }

  @override
  Future<void> removeBook(String bookId) async {
    saved.removeWhere((entry) => entry.bookId == bookId);
  }

  @override
  Future<List<Book>> loadBookshelf() async => List.unmodifiable(saved);
}
