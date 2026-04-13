class RuleException implements Exception {
  final String message;

  RuleException(this.message);

  @override
  String toString() => 'RuleException: $message';
}
