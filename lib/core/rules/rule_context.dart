import 'dart:core';

class RuleContext {
  final Uri baseUri;
  final Uri? currentUri;

  const RuleContext({required this.baseUri, this.currentUri});

  Uri resolve(String value) {
    return baseUri.resolve(value);
  }
}
