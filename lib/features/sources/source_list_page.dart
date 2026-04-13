import 'package:flutter/material.dart';

import 'package:flutter_reader/features/sources/source_import_controller.dart';
import 'package:flutter_reader/features/sources/source_import_page.dart';

class SourceListPage extends StatefulWidget {
  final SourceImportController controller;

  const SourceListPage({super.key, required this.controller});

  @override
  State<SourceListPage> createState() => _SourceListPageState();
}

class _SourceListPageState extends State<SourceListPage> {
  void _openImport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SourceImportPage(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Source Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openImport,
            tooltip: 'Import sources',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            if (widget.controller.importedSources.isEmpty) {
              return const Center(
                child: Text(
                  'No book sources imported yet. Tap + to import a Legado JSON.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.separated(
              itemCount: widget.controller.importedSources.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final source = widget.controller.importedSources[index];
                return ListTile(
                  title: Text(source.name),
                  subtitle: Text(source.baseUrl),
                  trailing: Icon(
                    source.enabled ? Icons.check_circle : Icons.block,
                    color: source.enabled ? Colors.green : Colors.red,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
