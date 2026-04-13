import 'package:flutter_reader/data/models/book_chapter.dart';
import 'package:flutter_reader/data/models/reader_session.dart';

abstract class ReaderRepository {
  Future<String> fetchChapterContent(BookChapter chapter);

  Future<void> saveReaderSession(ReaderSession session);

  Future<ReaderSession?> loadReaderSession(String bookId);
}
