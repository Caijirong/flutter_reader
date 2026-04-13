import 'package:flutter_reader/data/local/shared_preferences_book_repository.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Book _buildBook(String id) {
  return Book(
    bookId: id,
    sourceId: 'source',
    title: 'Title $id',
    author: 'Author',
    detailUrl: 'https://example.com/$id',
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('bookshelf persists entries and removes them', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesBookRepository(prefs);
    final book = _buildBook('book1');

    await repository.saveBook(book);
    expect(await repository.loadBookshelf(), contains(book));

    await repository.removeBook(book.bookId);
    expect(await repository.loadBookshelf(), isEmpty);
  });

  test('saveReaderSession keeps latest session', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesBookRepository(prefs);
    final session = ReaderSession(
      bookId: 'book1',
      chapterId: 'chapter-1',
      position: Duration(seconds: 30),
    );

    await repository.saveReaderSession(session);
    final restored = await repository.loadReaderSession('book1');

    expect(restored, session);
  });
}
