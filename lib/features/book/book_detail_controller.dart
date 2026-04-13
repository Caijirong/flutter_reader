import 'package:flutter/foundation.dart';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';

class BookDetailController extends ChangeNotifier {
  final BookRepository repository;
  final BookSource source;
  final SearchBook searchBook;

  Book? _book;
  List<BookChapter> _chapters = [];
  bool _isLoading = false;
  String? _errorMessage;

  BookDetailController({
    required this.repository,
    required this.source,
    required this.searchBook,
  });

  bool get isLoading => _isLoading;
  Book? get book => _book;
  List<BookChapter> get chapters => List.unmodifiable(_chapters);
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final detail = await repository.fetchDetail(searchBook, source);
      final fetchedChapters = await repository.fetchChapters(detail, source);
      _book = detail.copyWith(chapters: fetchedChapters);
      _chapters = fetchedChapters;
    } catch (error) {
      _errorMessage = error.toString();
      _book = null;
      _chapters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
