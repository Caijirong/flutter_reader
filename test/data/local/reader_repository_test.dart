import 'package:flutter_reader/data/local/shared_preferences_reader_repository.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('reader session survives load/save', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = SharedPreferencesReaderRepository(prefs);
    final chapter = BookChapter(
      chapterId: 'c1',
      bookId: 'book-1',
      title: 'Chapter One',
      url: 'https://example.com/c1',
      order: 1,
    );
    final session = ReaderSession(
      bookId: 'book-1',
      chapterId: chapter.chapterId,
      position: Duration(seconds: 45),
    );

    await repository.saveReaderSession(session);
    final restored = await repository.loadReaderSession('book-1');

    expect(restored, session);
  });
}
