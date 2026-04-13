import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/models/search_book.dart';
import 'package:flutter_reader/data/repositories/book_repository.dart';

BookSource makeTestSource(String id, {bool enabled = true}) {
  return BookSource(
    id: id,
    name: 'Source $id',
    baseUrl: 'https://$id.example',
    searchEndpoint: '/search',
    detailEndpoint: '/detail',
    chapterEndpoint: '/chapter',
    contentEndpoint: '/content',
    enabled: enabled,
  );
}

SearchBook makeTestBook(String sourceId, String suffix) {
  return SearchBook(
    bookId: '$sourceId-$suffix',
    sourceId: sourceId,
    title: 'Title $suffix',
    author: 'Author $suffix',
    detailUrl: 'https://example.com/$sourceId/$suffix',
  );
}

class FakeBookRepository implements BookRepository {
  final Map<String, List<SearchBook>> responses;
  final Set<String> failingSources;
  final List<Book> saved = [];

  FakeBookRepository({required this.responses, this.failingSources = const {}});

  @override
  Future<List<SearchBook>> search(String query, BookSource source) async {
    if (failingSources.contains(source.id)) {
      throw Exception('source-${source.id} failed');
    }
    return responses[source.id] ?? [];
  }

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
