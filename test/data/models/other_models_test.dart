import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';

void main() {
  group('SearchBook', () {
    final sample = SearchBook(
      bookId: 'book-1',
      sourceId: 'source-a',
      title: 'Search Title',
      author: 'Author',
      detailUrl: '/book/1',
      coverUrl: 'https://example.com/cover.png',
      summary: 'A summary',
      updatedAt: DateTime.utc(2024, 1, 1),
      metadata: {'genre': 'fantasy'},
    );

    test('serializes/equality', () {
      final json = sample.toJson();
      final restored = SearchBook.fromJson(json);
      expect(restored, equals(sample));
    });

    test('copyWith updates title and completion flag', () {
      final next = sample.copyWith(title: 'Search Title 2', isCompleted: true);
      expect(next.title, 'Search Title 2');
      expect(next.isCompleted, isTrue);
      expect(next.bookId, sample.bookId);
    });
  });

  group('BookChapter', () {
    final chapter = BookChapter(
      chapterId: 'chapter-1',
      bookId: 'book-1',
      title: 'Chapter One',
      url: '/chapters/1',
      order: 1,
      isVip: true,
      updatedAt: DateTime.utc(2024, 1, 2),
    );

    test('serializes/equality', () {
      final json = chapter.toJson();
      final restored = BookChapter.fromJson(json);
      expect(restored, equals(chapter));
    });
  });

  group('Book', () {
    final chapter = BookChapter(
      chapterId: 'c-1',
      bookId: 'book-1',
      title: 'Intro',
      url: '/c/1',
      order: 1,
    );

    final book = Book(
      bookId: 'book-1',
      sourceId: 'source-a',
      title: 'Book Title',
      author: 'Author',
      detailUrl: '/book/1',
      coverUrl: 'https://example.com/cover.png',
      description: 'description',
      updatedAt: DateTime.utc(2024, 1, 2),
      latestChapter: 'Intro',
      isCompleted: false,
      chapters: [chapter],
      metadata: {'language': 'en'},
    );

    test('serializes/equality with chapters', () {
      final json = book.toJson();
      final restored = Book.fromJson(json);
      expect(restored, equals(book));
    });

    test('copyWith updates completion and latest chapter', () {
      final updated = book.copyWith(
        latestChapter: 'Chapter 2',
        isCompleted: true,
        chapters: [chapter],
      );
      expect(updated.latestChapter, 'Chapter 2');
      expect(updated.isCompleted, isTrue);
      expect(updated.metadata, book.metadata);
    });
  });

  group('ReaderSession', () {
    test('defaults updatedAt and supports copy/toJson', () {
      final baseline = ReaderSession(
        bookId: 'book-1',
        chapterId: 'chapter-1',
        position: const Duration(seconds: 5),
      );
      final json = baseline.toJson();
      final restored = ReaderSession.fromJson(json);
      expect(restored, equals(baseline));

      final modified = baseline.copyWith(
        position: const Duration(seconds: 10),
        themeMode: 'dark',
      );
      expect(modified.position, const Duration(seconds: 10));
      expect(modified.themeMode, 'dark');
      expect(modified.updatedAt, baseline.updatedAt);
    });

    test('allows overriding updatedAt for determinism', () {
      final custom = ReaderSession(
        bookId: 'book-1',
        chapterId: 'chapter-1',
        position: Duration.zero,
        updatedAt: DateTime.utc(2025, 1, 1),
      );
      final json = custom.toJson();
      final restored = ReaderSession.fromJson(json);
      expect(restored.updatedAt, DateTime.utc(2025, 1, 1));
      expect(restored, equals(custom));
    });
  });
}
