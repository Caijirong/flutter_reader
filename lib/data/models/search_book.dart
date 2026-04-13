import 'package:flutter/foundation.dart';

@immutable
class SearchBook {
  final String bookId;
  final String sourceId;
  final String title;
  final String author;
  final String detailUrl;
  final String? coverUrl;
  final String? summary;
  final DateTime? updatedAt;
  final bool isCompleted;
  final Map<String, String>? metadata;

  const SearchBook({
    required this.bookId,
    required this.sourceId,
    required this.title,
    required this.author,
    required this.detailUrl,
    this.coverUrl,
    this.summary,
    this.updatedAt,
    this.isCompleted = false,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'sourceId': sourceId,
      'title': title,
      'author': author,
      'detailUrl': detailUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (summary != null) 'summary': summary,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'isCompleted': isCompleted,
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory SearchBook.fromJson(Map<String, dynamic> json) {
    return SearchBook(
      bookId: json['bookId'] as String,
      sourceId: json['sourceId'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      detailUrl: json['detailUrl'] as String,
      coverUrl: json['coverUrl'] as String?,
      summary: json['summary'] as String?,
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      metadata: json['metadata'] == null
          ? null
          : Map<String, String>.from(json['metadata'] as Map),
    );
  }

  SearchBook copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return SearchBook(
      bookId: bookId,
      sourceId: sourceId,
      title: title ?? this.title,
      author: author,
      detailUrl: detailUrl,
      coverUrl: coverUrl,
      summary: summary,
      updatedAt: updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      metadata: metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchBook &&
        other.bookId == bookId &&
        other.sourceId == sourceId &&
        other.title == title &&
        other.author == author &&
        other.detailUrl == detailUrl &&
        other.coverUrl == coverUrl &&
        other.summary == summary &&
        other.updatedAt == updatedAt &&
        other.isCompleted == isCompleted &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return Object.hash(
      bookId,
      sourceId,
      title,
      author,
      detailUrl,
      coverUrl,
      summary,
      updatedAt,
      isCompleted,
      _mapHash(metadata),
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
