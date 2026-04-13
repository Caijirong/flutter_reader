import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';
import 'package:flutter_reader/data/repositories/reader_repository.dart';
import 'package:flutter_reader/features/reader/reader_controller.dart';
import 'package:flutter_reader/features/reader/reader_page.dart';

void main() {
  List<BookChapter> makeChapters() {
    return [
      BookChapter(
        chapterId: 'chapter-1',
        bookId: 'book-1',
        title: 'Chapter One',
        url: 'https://example.com/chapter-1',
        order: 1,
      ),
    ];
  }

  Book makeBook() {
    return Book(
      bookId: 'book-1',
      sourceId: 'source',
      title: 'Sample',
      author: 'Author',
      detailUrl: 'https://example.com/book',
    );
  }

  testWidgets('shows chapter content and allows theme toggle', (tester) async {
    final repository = _FakeReaderRepository(contents: {'chapter-1': 'content-1'});
    final controller = ReaderController(
      repository: repository,
      book: makeBook(),
      chapters: makeChapters(),
    );

    await tester.pumpWidget(MaterialApp(home: ReaderPage(controller: controller)));
    await tester.pumpAndSettle();

    expect(find.text('Chapter One'), findsOneWidget);
    expect(find.text('content-1'), findsOneWidget);
    expect(find.textContaining('Font size:'), findsOneWidget);
    expect(find.text('Theme: light'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();

    expect(find.text('Theme: dark'), findsOneWidget);
  });
}

class _FakeReaderRepository implements ReaderRepository {
  final Map<String, String> contents;

  _FakeReaderRepository({required this.contents});

  @override
  Future<String> fetchChapterContent(BookChapter chapter) async {
    return contents[chapter.chapterId] ?? '';
  }

  @override
  Future<ReaderSession?> loadReaderSession(String bookId) async {
    return null;
  }

  @override
  Future<void> saveReaderSession(ReaderSession session) async {}
}
