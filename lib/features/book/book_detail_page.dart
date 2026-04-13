import 'package:flutter/material.dart';
import 'package:flutter_reader/features/book/book_detail_controller.dart';
import 'package:flutter_reader/features/book/chapter_list_view.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.controller});

  final BookDetailController controller;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Detail')),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final controller = widget.controller;
          final book = controller.book;
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }
          if (book == null) {
            return const Center(child: Text('No book loaded.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(book.author, style: Theme.of(context).textTheme.bodyLarge),
                if (book.latestChapter != null) ...[
                  const SizedBox(height: 4),
                  Text('Latest: ${book.latestChapter!}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
                const Divider(height: 24),
                const Text('Chapters', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ChapterListView(
                    chapters: controller.chapters,
                    onChapterTap: (chapter) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected ${chapter.title}')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
