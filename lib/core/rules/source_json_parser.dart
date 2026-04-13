import 'dart:convert';

import 'package:flutter_reader/data/models/book_source.dart';

class SourceParseResult {
  final List<BookSource> sources;
  final List<String> duplicateIds;
  final List<Map<String, dynamic>> invalidEntries;

  const SourceParseResult({
    required this.sources,
    required this.duplicateIds,
    required this.invalidEntries,
  });
}

class SourceJsonParser {
  SourceParseResult parse(String jsonPayload) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonPayload);
    } catch (error) {
      throw FormatException('Failed to decode JSON: $error');
    }

    if (decoded is! List) {
      throw FormatException('Expected top-level array of sources');
    }

    final seen = <String, BookSource>{};
    final duplicates = <String>[];
    final invalidEntries = <Map<String, dynamic>>[];

    for (final rawEntry in decoded) {
      if (rawEntry is! Map<String, dynamic>) {
        throw FormatException('Each source entry must be a map');
      }

      final entry = rawEntry.cast<String, dynamic>();
      final id = entry['id'] as String?;
      final name = entry['name'] as String?;
      final baseUrl = entry['baseUrl'] as String?;
      final searchEndpoint = entry['searchEndpoint'] as String?;
      final detailEndpoint = entry['detailEndpoint'] as String?;
      final chapterEndpoint = entry['chapterEndpoint'] as String?;
      final contentEndpoint = entry['contentEndpoint'] as String?;

      if (id == null ||
          name == null ||
          baseUrl == null ||
          searchEndpoint == null ||
          detailEndpoint == null ||
          chapterEndpoint == null ||
          contentEndpoint == null) {
        invalidEntries.add(entry);
        continue;
      }

      if (seen.containsKey(id)) {
        duplicates.add(id);
        continue;
      }

      final headers = entry['defaultHeaders'];
      final parsedHeaders = headers == null
          ? null
          : Map<String, String>.from(headers as Map);

      final enabled = entry['enabled'] as bool? ?? true;
      final description = entry['description'] as String?;

      seen[id] = BookSource(
        id: id,
        name: name,
        baseUrl: baseUrl,
        searchEndpoint: searchEndpoint,
        detailEndpoint: detailEndpoint,
        chapterEndpoint: chapterEndpoint,
        contentEndpoint: contentEndpoint,
        enabled: enabled,
        defaultHeaders: parsedHeaders,
        description: description,
      );
    }

    return SourceParseResult(
      sources: seen.values.toList(),
      duplicateIds: duplicates,
      invalidEntries: invalidEntries,
    );
  }
}
