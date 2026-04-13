import 'package:flutter/material.dart';
import 'package:flutter_reader/data/models/book_chapter.dart';

class ChapterListView extends StatelessWidget {
  final List<BookChapter> chapters;
  final void Function(BookChapter)? onChapterTap;

  const ChapterListView({
    super.key,
    required this.chapters,
    this.onChapterTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const Center(child: Text('No chapters available.'));
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: chapters.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return ListTile(
          title: Text(chapter.title),
          subtitle: Text('Chapter ${chapter.order}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onChapterTap?.call(chapter),
        );
      },
    );
  }
}
