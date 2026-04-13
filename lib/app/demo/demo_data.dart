import 'dart:convert';

import 'package:flutter_reader/data/models/book.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/book_source.dart';
import 'package:flutter_reader/data/models/search_book.dart';

/// Static demo data used by the Task 9 navigation shell.
class DemoData {
  static final bookSource = BookSource(
    id: 'demo-source',
    name: 'Demo Source',
    baseUrl: 'https://demo.example',
    searchEndpoint: '/search',
    detailEndpoint: '/detail',
    chapterEndpoint: '/chapters',
    contentEndpoint: '/content',
    description: 'Lightweight demo book source',
  );

  static final sources = [bookSource];

  static final searchBook = SearchBook(
    bookId: 'demo-demo',
    sourceId: bookSource.id,
    title: 'Demo Novel',
    author: 'Author Demo',
    detailUrl: 'https://demo.example/book/demo-demo',
    summary: 'A deterministic demo novel used for navigation tests.',
    isCompleted: false,
    metadata: {'genre': 'demo'},
  );

  static final chapters = [
    BookChapter(
      chapterId: 'chapter-1',
      bookId: searchBook.bookId,
      title: 'Chapter One',
      url: '${searchBook.detailUrl}/1',
      order: 1,
    ),
    BookChapter(
      chapterId: 'chapter-2',
      bookId: searchBook.bookId,
      title: 'Chapter Two',
      url: '${searchBook.detailUrl}/2',
      order: 2,
    ),
  ];

  static final book = Book(
    bookId: searchBook.bookId,
    sourceId: searchBook.sourceId,
    title: searchBook.title,
    author: searchBook.author,
    detailUrl: searchBook.detailUrl,
    description: searchBook.summary,
    latestChapter: 'Chapter Two',
    chapters: chapters,
  );

  static final chapterContents = {
    'chapter-1': 'This is demo content for chapter one.',
    'chapter-2': 'Second chapter content demonstrates navigation depth.',
  };

  static String get sourcesJson => jsonEncode(
        sources.map((source) => source.toJson()).toList(),
      );
}
