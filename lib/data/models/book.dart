import 'package:flutter/foundation.dart';

import 'package:flutter_reader/data/models/book_chapter.dart';

@immutable
class Book {
  final String bookId;
  final String sourceId;
  final String title;
  final String author;
  final String detailUrl;
  final String? coverUrl;
  final String? description;
  final DateTime? updatedAt;
  final String? latestChapter;
  final bool isCompleted;
  final List<BookChapter>? chapters;
  final Map<String, String>? metadata;

  const Book({
    required this.bookId,
    required this.sourceId,
    required this.title,
    required this.author,
    required this.detailUrl,
    this.coverUrl,
    this.description,
    this.updatedAt,
    this.latestChapter,
    this.isCompleted = false,
    this.chapters,
    this.metadata,
  });

  Book copyWith({
    String? latestChapter,
    bool? isCompleted,
    List<BookChapter>? chapters,
  }) {
    return Book(
      bookId: bookId,
      sourceId: sourceId,
      title: title,
      author: author,
      detailUrl: detailUrl,
      coverUrl: coverUrl,
      description: description,
      updatedAt: updatedAt,
      latestChapter: latestChapter ?? this.latestChapter,
      isCompleted: isCompleted ?? this.isCompleted,
      chapters: chapters ?? this.chapters,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'sourceId': sourceId,
      'title': title,
      'author': author,
      'detailUrl': detailUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      if (description != null) 'description': description,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (latestChapter != null) 'latestChapter': latestChapter,
      'isCompleted': isCompleted,
      if (chapters != null) 'chapters': chapters!.map((c) => c.toJson()).toList(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final chapterJson = json['chapters'] as List<dynamic>?;
    return Book(
      bookId: json['bookId'] as String,
      sourceId: json['sourceId'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      detailUrl: json['detailUrl'] as String,
      coverUrl: json['coverUrl'] as String?,
      description: json['description'] as String?,
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      latestChapter: json['latestChapter'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      chapters: chapterJson
          ?.map((entry) => BookChapter.fromJson(entry as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] == null
          ? null
          : Map<String, String>.from(json['metadata'] as Map),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book &&
        other.bookId == bookId &&
        other.sourceId == sourceId &&
        other.title == title &&
        other.author == author &&
        other.detailUrl == detailUrl &&
        other.coverUrl == coverUrl &&
        other.description == description &&
        other.updatedAt == updatedAt &&
        other.latestChapter == latestChapter &&
        other.isCompleted == isCompleted &&
        listEquals(other.chapters, chapters) &&
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
      description,
      updatedAt,
      latestChapter,
      isCompleted,
      _hashChapters(chapters),
      _mapHash(metadata),
    );
  }
}

int _hashChapters(List<BookChapter>? chapters) {
  if (chapters == null || chapters.isEmpty) {
    return 0;
  }
  return Object.hashAll(chapters);
}

int _mapHash(Map<String, String>? map) {
  if (map == null || map.isEmpty) {
    return 0;
  }
  return map.entries.fold(0, (previous, entry) {
    return previous ^ Object.hash(entry.key, entry.value);
  });
}
