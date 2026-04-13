import 'package:flutter/material.dart';

import 'package:flutter_reader/features/reader/reader_controller.dart';

class ReaderSettings extends StatelessWidget {
  const ReaderSettings({super.key, required this.controller});

  final ReaderController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font size: ${controller.fontSize.toStringAsFixed(0)}'),
        Text('Line height: ${controller.lineHeight.toStringAsFixed(1)}'),
        Row(
          children: [
            Text('Theme: ${controller.themeMode}'),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              tooltip: 'Toggle theme',
              onPressed: controller.toggleThemeMode,
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.text_decrease),
              tooltip: 'Decrease font',
              onPressed: () => controller.updateFontSize(controller.fontSize - 1),
            ),
            IconButton(
              icon: const Icon(Icons.text_increase),
              tooltip: 'Increase font',
              onPressed: () => controller.updateFontSize(controller.fontSize + 1),
            ),
          ],
        ),
      ],
    );
  }
}
