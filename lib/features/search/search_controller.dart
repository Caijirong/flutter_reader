import 'package:flutter/foundation.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';

/// Aggregated results for a single source search operation.
class SearchResult {
  final BookSource source;
  final List<SearchBook> books;
  final String? error;

  const SearchResult({
    required this.source,
    this.books = const [],
    this.error,
  });
}

class SearchController extends ChangeNotifier {
  final BookRepository repository;
  final List<BookSource> sources;
  int _searchCounter = 0;

  bool _isLoading = false;
  List<SearchResult> _results = const [];

  SearchController({required this.repository, required List<BookSource> sources})
      : sources = List.unmodifiable(sources);

  bool get isLoading => _isLoading;
  List<SearchResult> get sourceResults => List.unmodifiable(_results);

  Future<void> search(String query) async {
    _isLoading = true;
    _results = [];
    notifyListeners();

    final token = ++_searchCounter;
    final results = <SearchResult>[];
    for (final source in sources.where((s) => s.enabled)) {
      try {
        final books = await repository.search(query, source);
        results.add(SearchResult(source: source, books: books));
      } catch (error) {
        results.add(SearchResult(source: source, error: error.toString()));
      }
    }

    if (token != _searchCounter) {
      return;
    }

    _results = results;
    _isLoading = false;
    notifyListeners();
  }
}
