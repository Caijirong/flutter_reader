import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';
import 'package:flutter_reader/features/reader/reader_controller.dart';

void main() {
  List<BookChapter> buildChapters() {
    return [
      BookChapter(
        chapterId: 'chapter-1',
        bookId: 'book-1',
        title: 'Chapter One',
        url: 'https://example.com/chapter-1',
        order: 1,
      ),
      BookChapter(
        chapterId: 'chapter-2',
        bookId: 'book-1',
        title: 'Chapter Two',
        url: 'https://example.com/chapter-2',
        order: 2,
      ),
    ];
  }

  Book buildBook() {
    return Book(
      bookId: 'book-1',
      sourceId: 'source',
      title: 'Sample Book',
      author: 'Author',
      detailUrl: 'https://example.com/book-1',
    );
  }

  test('loads chapter content and saves session', () async {
    final chapters = buildChapters();
    final repository = _FakeReaderRepository(
      contents: {'chapter-1': 'content-1'},
    );
    final controller = ReaderController(
      repository: repository,
      book: buildBook(),
      chapters: chapters,
    );

    await controller.initialize();

    expect(controller.chapterContent, 'content-1');
    expect(controller.currentChapter.chapterId, 'chapter-1');
    expect(repository.savedSessions.last.chapterId, 'chapter-1');
  });

  test('moves between chapters updating session', () async {
    final chapters = buildChapters();
    final repository = _FakeReaderRepository(
      contents: {
        'chapter-1': 'content-1',
        'chapter-2': 'content-2',
      },
    );
    final controller = ReaderController(
      repository: repository,
      book: buildBook(),
      chapters: chapters,
    );

    await controller.initialize();
    await controller.goToNextChapter();

    expect(controller.currentChapter.chapterId, 'chapter-2');
    expect(controller.chapterContent, 'content-2');
    expect(repository.savedSessions.last.chapterId, 'chapter-2');

    await controller.goToPreviousChapter();
    expect(controller.currentChapter.chapterId, 'chapter-1');
  });

  test('restores persisted session', () async {
    final chapters = buildChapters();
    final savedSession = ReaderSession(
      bookId: 'book-1',
      chapterId: 'chapter-2',
      position: Duration.zero,
    );
    final repository = _FakeReaderRepository(
      contents: {'chapter-2': 'content-2'},
      initialSession: savedSession,
    );
    final controller = ReaderController(
      repository: repository,
      book: buildBook(),
      chapters: chapters,
    );

    await controller.initialize();

    expect(controller.currentChapter.chapterId, 'chapter-2');
    expect(controller.chapterContent, 'content-2');
    expect(repository.loadedBookId, 'book-1');
  });

  test('prevents overlapping navigation requests', () async {
    final chapters = buildChapters();
    final repository = _BlockingReaderRepository();
    final controller = ReaderController(
      repository: repository,
      book: buildBook(),
      chapters: chapters,
    );

    await controller.initialize();

    final first = controller.goToNextChapter();
    await Future.microtask(() {});
    final second = controller.goToNextChapter();

    expect(repository.chapter2FetchCount, 1);

    repository.completeChapter('content-2');
    await first;
    await second;

    expect(controller.currentChapter.chapterId, 'chapter-2');
  });

  test('surfaces session save errors', () async {
    final controller = ReaderController(
      repository: _SelectiveFailingSessionRepository(
        contents: {'chapter-1': 'content'},
        failOnAttempt: 2,
      ),
      book: buildBook(),
      chapters: buildChapters(),
    );

    await controller.initialize();
    expect(controller.errorMessage, isNull);

    await controller.toggleThemeMode();

    expect(controller.errorMessage, contains('disk failure'));
    expect(controller.themeMode, 'light');
  });
}

class _FakeReaderRepository implements ReaderRepository {
  final Map<String, String> contents;
  final ReaderSession? initialSession;

  final List<ReaderSession> savedSessions = [];
  String? loadedBookId;

  _FakeReaderRepository({required this.contents, this.initialSession});

  @override
  Future<String> fetchChapterContent(BookChapter chapter) async {
    return contents[chapter.chapterId] ?? 'content-${chapter.chapterId}';
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async {
    loadedBookId = bookId;
    if (initialSession?.bookId == bookId) {
      return initialSession;
    }
    return null;
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) async {
    savedSessions.add(session);
  }
}

class _BlockingReaderRepository implements ReaderRepository {
  final Completer<String> _chapterCompleter = Completer<String>();
  int fetchCount = 0;
  int chapter2FetchCount = 0;

  @override
  Future<String> fetchChapterContent(BookChapter chapter) async {
    fetchCount++;
    if (chapter.chapterId == 'chapter-2') {
      chapter2FetchCount++;
      return _chapterCompleter.future;
    }
    return 'content-${chapter.chapterId}';
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async => null;

  @override
  Future<void> saveReaderSession(ReaderSession session) async {}

  void completeChapter(String content) {
    if (!_chapterCompleter.isCompleted) {
      _chapterCompleter.complete(content);
    }
  }

}

class _SelectiveFailingSessionRepository implements ReaderRepository {
  final Map<String, String> contents;
  final int failOnAttempt;
  int _saveAttempts = 0;

  _SelectiveFailingSessionRepository({
    required this.contents,
    required this.failOnAttempt,
  });

  @override
  Future<String> fetchChapterContent(BookChapter chapter) async {
    return contents[chapter.chapterId] ?? '';
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async => null;

  @override
  Future<void> saveReaderSession(ReaderSession session) async {
    _saveAttempts++;
    if (_saveAttempts >= failOnAttempt) {
      throw Exception('disk failure');
    }
  }
}
