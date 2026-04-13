import 'package:flutter/foundation.dart';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';

class ReaderController extends ChangeNotifier {
  final ReaderRepository repository;
  final Book book;
  final List<BookChapter> chapters;

  int _currentIndex = 0;
  bool _isLoading = false;
  bool _navigationInProgress = false;
  String? _chapterContent;
  ReaderSession? _session;
  String? _errorMessage;

  ReaderController({
    required this.repository,
    required this.book,
    required this.chapters,
  }) {
    assert(chapters.isNotEmpty, 'Reader requires at least one chapter');
    if (chapters.isNotEmpty) {
      _currentIndex = 0;
    }
  }

  bool get isLoading => _isLoading;
  String? get chapterContent => _chapterContent;
  String? get errorMessage => _errorMessage;
  double get fontSize => _session?.fontSize ?? 16;
  double get lineHeight => _session?.lineHeight ?? 1.4;
  String get themeMode => _session?.themeMode ?? 'light';

  BookChapter get currentChapter => chapters[_currentIndex];
  ReaderSession? get session => _session;

  Future<void> initialize() async {
    await _withLoading(() async {
      _session = await repository.loadReaderSession(book.bookId);
      if (_session != null) {
        final restoredIndex = chapters.indexWhere(
          (chapter) => chapter.chapterId == _session!.chapterId,
        );
        if (restoredIndex != -1) {
          _currentIndex = restoredIndex;
        }
      }
      await _loadChapterContent();
    });
  }

  Future<void> goToNextChapter() async {
    if (_navigationInProgress || _currentIndex + 1 >= chapters.length) return;
    try {
      _navigationInProgress = true;
      await _withLoading(() async {
        _currentIndex++;
        await _loadChapterContent();
      });
    } finally {
      _navigationInProgress = false;
    }
  }

  Future<void> goToPreviousChapter() async {
    if (_navigationInProgress || _currentIndex - 1 < 0) return;
    try {
      _navigationInProgress = true;
      await _withLoading(() async {
        _currentIndex--;
        await _loadChapterContent();
      });
    } finally {
      _navigationInProgress = false;
    }
  }

  Future<void> updateFontSize(double value) async {
    await _updateSession(fontSize: value);
  }

  Future<void> updateLineHeight(double value) async {
    await _updateSession(lineHeight: value);
  }

  Future<void> toggleThemeMode() async {
    final nextTheme = themeMode == 'dark' ? 'light' : 'dark';
    await _updateSession(themeMode: nextTheme);
  }

  Future<void> _updateSession({
    double? fontSize,
    double? lineHeight,
    String? themeMode,
  }) async {
    final chapterId = currentChapter.chapterId;
    final previousSession = _session;
    final newSession = ReaderSession(
      bookId: book.bookId,
      chapterId: chapterId,
      position: previousSession?.position ?? Duration.zero,
      fontSize: fontSize ?? previousSession?.fontSize ?? 16,
      lineHeight: lineHeight ?? previousSession?.lineHeight ?? 1.4,
      themeMode: themeMode ?? previousSession?.themeMode ?? 'light',
    );
    try {
      await repository.saveReaderSession(newSession);
      _session = newSession;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
      _session = previousSession;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadChapterContent() async {
    _chapterContent = await repository.fetchChapterContent(currentChapter);
    _session = ReaderSession(
      bookId: book.bookId,
      chapterId: currentChapter.chapterId,
      position: _session?.position ?? Duration.zero,
      fontSize: _session?.fontSize ?? 16,
      lineHeight: _session?.lineHeight ?? 1.4,
      themeMode: _session?.themeMode ?? 'light',
    );
    await repository.saveReaderSession(_session!);
  }

  Future<void> _withLoading(Future<void> Function() work) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await work();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
