import 'package:flutter/foundation.dart';

@immutable
class BookSource {
  final String id;
  final String name;
  final String baseUrl;
  final String searchEndpoint;
  final String detailEndpoint;
  final String chapterEndpoint;
  final String contentEndpoint;
  final bool enabled;
  final Map<String, String>? defaultHeaders;
  final String? description;

  const BookSource({
    required this.id,
    required this.name,
    required this.baseUrl,
    required this.searchEndpoint,
    required this.detailEndpoint,
    required this.chapterEndpoint,
    required this.contentEndpoint,
    this.enabled = true,
    this.defaultHeaders,
    this.description,
  });

  BookSource copyWith({
    bool? enabled,
    Map<String, String>? defaultHeaders,
    String? description,
  }) {
    return BookSource(
      id: id,
      name: name,
      baseUrl: baseUrl,
      searchEndpoint: searchEndpoint,
      detailEndpoint: detailEndpoint,
      chapterEndpoint: chapterEndpoint,
      contentEndpoint: contentEndpoint,
      enabled: enabled ?? this.enabled,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'baseUrl': baseUrl,
      'searchEndpoint': searchEndpoint,
      'detailEndpoint': detailEndpoint,
      'chapterEndpoint': chapterEndpoint,
      'contentEndpoint': contentEndpoint,
      'enabled': enabled,
      if (defaultHeaders != null) 'defaultHeaders': defaultHeaders,
      if (description != null) 'description': description,
    };
  }

  factory BookSource.fromJson(Map<String, dynamic> json) {
    return BookSource(
      id: json['id'] as String,
      name: json['name'] as String,
      baseUrl: json['baseUrl'] as String,
      searchEndpoint: json['searchEndpoint'] as String,
      detailEndpoint: json['detailEndpoint'] as String,
      chapterEndpoint: json['chapterEndpoint'] as String,
      contentEndpoint: json['contentEndpoint'] as String,
      enabled: json['enabled'] as bool? ?? true,
      defaultHeaders: json['defaultHeaders'] == null
          ? null
          : Map<String, String>.from(json['defaultHeaders'] as Map),
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BookSource &&
        other.id == id &&
        other.name == name &&
        other.baseUrl == baseUrl &&
        other.searchEndpoint == searchEndpoint &&
        other.detailEndpoint == detailEndpoint &&
        other.chapterEndpoint == chapterEndpoint &&
        other.contentEndpoint == contentEndpoint &&
        other.enabled == enabled &&
        mapEquals(other.defaultHeaders, defaultHeaders) &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      baseUrl,
      searchEndpoint,
      detailEndpoint,
      chapterEndpoint,
      contentEndpoint,
      enabled,
      _mapHash(defaultHeaders),
      description,
    );
  }
}

int _mapHash(Map<String, String>? map) {
  if (map == null || map.isEmpty) {
    return 0;
  }
  return map.entries.fold(0, (previous, entry) {
    return previous ^ Object.hash(entry.key, entry.value);
  });
}
