import 'package:flutter/material.dart';

import 'package:flutter_reader/features/reader/reader_controller.dart';
import 'package:flutter_reader/features/reader/reader_settings.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.controller});

  final ReaderController controller;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.controller.book.title)),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final controller = widget.controller;
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }
          final content = controller.chapterContent ?? '';
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.currentChapter.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: controller.fontSize,
                        height: controller.lineHeight,
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ReaderSettings(controller: controller),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: controller.goToPreviousChapter,
                      child: const Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: controller.goToNextChapter,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
