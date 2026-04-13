import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';
import 'package:flutter_reader/features/book/book_detail_controller.dart';

import '../search/search_test_helpers.dart';

void main() {
  group('BookDetailController', () {
    late BookSource source;
    late SearchBook candidate;

    setUp(() {
      source = makeTestSource('source-a');
      candidate = makeTestBook('source-a', 'A');
    });

    test('loads detail and chapters', () async {
      final book = Book(
        bookId: candidate.bookId,
        sourceId: candidate.sourceId,
        title: 'Detailed Title',
        author: 'Author A',
        detailUrl: candidate.detailUrl,
      );
      final chapters = [
        BookChapter(
          chapterId: '1',
          bookId: book.bookId,
          title: 'Chapter One',
          url: '${candidate.detailUrl}/1',
          order: 1,
        ),
      ];
      final repository = _FakeBookRepository(book: book, chapters: chapters);
      final controller = BookDetailController(
        repository: repository,
        source: source,
        searchBook: candidate,
      );

      await controller.load();

      expect(controller.errorMessage, isNull);
      expect(controller.isLoading, isFalse);
      expect(controller.book, book.copyWith(chapters: chapters));
      expect(controller.chapters, chapters);
    });

    test('records error when repository fails', () async {
      final repository = _FakeBookRepository(
        book: Book(
          bookId: 'id',
          sourceId: source.id,
          title: 'Title',
          author: 'Author',
          detailUrl: 'https://example.com',
        ),
        chapters: const [],
        failDetail: true,
      );
      final controller = BookDetailController(
        repository: repository,
        source: source,
        searchBook: candidate,
      );

      await controller.load();

      expect(controller.errorMessage, contains('detail failure'));
      expect(controller.isLoading, isFalse);
      expect(controller.book, isNull);
      expect(controller.chapters, isEmpty);
    });
  });
}

class _FakeBookRepository implements BookRepository {
  final Book book;
  final List<BookChapter> chapters;
  final bool failDetail;

  _FakeBookRepository({
    required this.book,
    this.chapters = const [],
    this.failDetail = false,
  });

  @override
  Future<List<BookChapter>> fetchChapters(Book book, BookSource source) async => chapters;

  @override
  Future<Book> fetchDetail(SearchBook candidate, BookSource source) async {
    if (failDetail) {
      throw Exception('detail failure');
    }
    return book;
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
}
