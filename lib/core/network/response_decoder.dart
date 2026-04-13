import 'dart:convert';

class ResponseDecoder {
  String decode(List<int> bytes, Map<String, String> headers) {
    final charset = _extractCharset(headers);
    final encoding = Encoding.getByName(charset?.toLowerCase() ?? '') ?? utf8;

    try {
      return encoding.decode(bytes);
    } catch (_) {
      return utf8.decode(bytes);
    }
  }

  String? _extractCharset(Map<String, String> headers) {
    final typeHeader = headers.entries.firstWhere(
      (entry) => entry.key.toLowerCase() == 'content-type',
      orElse: () => const MapEntry('', ''),
    );

    final contentType = typeHeader.value;
    if (contentType.isEmpty) {
      return null;
    }

    final parts = contentType.split(';');
    for (var part in parts) {
      final trimmed = part.trim();
      if (trimmed.toLowerCase().startsWith('charset=')) {
        return trimmed.split('=')[1];
      }
    }

    return null;
  }
}
