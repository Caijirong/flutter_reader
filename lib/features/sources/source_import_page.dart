import 'package:flutter/material.dart';

import 'package:flutter_reader/features/sources/source_import_controller.dart';

class SourceImportPage extends StatefulWidget {
  final SourceImportController controller;

  const SourceImportPage({super.key, required this.controller});

  @override
  State<SourceImportPage> createState() => _SourceImportPageState();
}

class _SourceImportPageState extends State<SourceImportPage> {
  final TextEditingController _payload = TextEditingController();
  SourceImportResult? _lastResult;
  String? _errorMessage;

  Future<void> _submitImport() async {
    final payload = _payload.text;
    if (payload.isEmpty) {
      setState(() {
        _errorMessage = 'Paste or type a Legado JSON payload first.';
      });
      return;
    }

    try {
      final result = await widget.controller.importFromText(payload);
      setState(() {
        _lastResult = result;
        _errorMessage = null;
      });
    } on FormatException catch (error) {
      setState(() {
        _errorMessage = error.message;
        _lastResult = null;
      });
    }
  }

  Future<void> _importFromClipboard() async {
    final result = await widget.controller.importFromClipboard(_payload.text);
    setState(() {
      _lastResult = result;
      _errorMessage = null;
    });
  }

  Future<void> _importFromFile() async {
    final result = await widget.controller.importFromFile(_payload.text);
    setState(() {
      _lastResult = result;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _payload.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Sources'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _payload,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Legado JSON',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitImport,
                    child: const Text('Import text'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _importFromClipboard,
                    child: const Text('Clipboard'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _importFromFile,
              child: const Text('Import from file payload'),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_lastResult != null) ...[
              Text('Imported: ${_lastResult!.validSources.length}'),
              Text('Invalid entries: ${_lastResult!.invalidSources.length}'),
              Text('Duplicates: ${_lastResult!.duplicates.length}'),
            ],
          ],
        ),
      ),
    );
  }
}
