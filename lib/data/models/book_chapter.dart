import 'package:flutter/foundation.dart';

@immutable
class BookChapter {
  final String chapterId;
  final String bookId;
  final String title;
  final String url;
  final int order;
  final bool isVip;
  final DateTime? updatedAt;

  const BookChapter({
    required this.chapterId,
    required this.bookId,
    required this.title,
    required this.url,
    required this.order,
    this.isVip = false,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'bookId': bookId,
      'title': title,
      'url': url,
      'order': order,
      'isVip': isVip,
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  factory BookChapter.fromJson(Map<String, dynamic> json) {
    return BookChapter(
      chapterId: json['chapterId'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      order: json['order'] as int,
      isVip: json['isVip'] as bool? ?? false,
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookChapter &&
        other.chapterId == chapterId &&
        other.bookId == bookId &&
        other.title == title &&
        other.url == url &&
        other.order == order &&
        other.isVip == isVip &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      chapterId,
      bookId,
      title,
      url,
      order,
      isVip,
      updatedAt,
    );
  }
}
