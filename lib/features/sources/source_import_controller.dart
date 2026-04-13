import 'package:flutter/foundation.dart';

import 'package:flutter_reader/core/rules/source_json_parser.dart';
import 'package:flutter_reader/data/models/book_source.dart';

class SourceImportResult {
  final List<BookSource> validSources;
  final List<Map<String, dynamic>> invalidSources;
  final List<String> duplicates;

  const SourceImportResult({
    required this.validSources,
    required this.invalidSources,
    required this.duplicates,
  });
}

class SourceImportController extends ChangeNotifier {
  final SourceJsonParser _parser;
  final List<BookSource> importedSources = [];
  final Set<String> _importedIds = {};

  SourceImportController({SourceJsonParser? parser, List<BookSource>? initialSources})
      : _parser = parser ?? SourceJsonParser() {
    if (initialSources != null) {
      importedSources.addAll(initialSources);
      _importedIds.addAll(initialSources.map((source) => source.id));
    }
  }

  Future<SourceImportResult> importFromText(String payload) async {
    final parseResult = _parser.parse(payload);
    final accepted = <BookSource>[];
    final detectedDuplicates = <String>[];

    for (final source in parseResult.sources) {
      if (_importedIds.contains(source.id)) {
        detectedDuplicates.add(source.id);
        continue;
      }
      _importedIds.add(source.id);
      importedSources.add(source);
      accepted.add(source);
    }

    if (accepted.isNotEmpty || detectedDuplicates.isNotEmpty || parseResult.invalidEntries.isNotEmpty) {
      notifyListeners();
    }

    return SourceImportResult(
      validSources: accepted,
      invalidSources: parseResult.invalidEntries,
      duplicates: [
        ...parseResult.duplicateIds,
        ...detectedDuplicates,
      ],
    );
  }

  Future<SourceImportResult> importFromClipboard(String payload) async {
    return importFromText(payload);
  }

  Future<SourceImportResult> importFromFile(String payload) async {
    return importFromText(payload);
  }
}
