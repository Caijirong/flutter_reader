import 'package:flutter/foundation.dart';

@immutable
class ReaderSession {
  final String bookId;
  final String chapterId;
  final Duration position;
  final double fontSize;
  final double lineHeight;
  final String themeMode;
  final DateTime updatedAt;

  static final DateTime _defaultUpdatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  ReaderSession({
    required this.bookId,
    required this.chapterId,
    required this.position,
    this.fontSize = 16,
    this.lineHeight = 1.4,
    this.themeMode = 'light',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? _defaultUpdatedAt;

  ReaderSession copyWith({
    Duration? position,
    double? fontSize,
    double? lineHeight,
    String? themeMode,
    DateTime? updatedAt,
  }) {
    return ReaderSession(
      bookId: bookId,
      chapterId: chapterId,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      themeMode: themeMode ?? this.themeMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'chapterId': chapterId,
      'position': position.inMilliseconds,
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'themeMode': themeMode,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReaderSession.fromJson(Map<String, dynamic> json) {
    return ReaderSession(
      bookId: json['bookId'] as String,
      chapterId: json['chapterId'] as String,
      position: Duration(milliseconds: json['position'] as int),
      fontSize: (json['fontSize'] as num).toDouble(),
      lineHeight: (json['lineHeight'] as num).toDouble(),
      themeMode: json['themeMode'] as String? ?? 'light',
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReaderSession &&
        other.bookId == bookId &&
        other.chapterId == chapterId &&
        other.position == position &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.themeMode == themeMode &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      bookId,
      chapterId,
      position,
      fontSize,
      lineHeight,
      themeMode,
      updatedAt,
    );
  }
}
