import 'package:flutter_reader/core/errors/rule_exception.dart';
import 'package:flutter_reader/core/parser/html_extractor.dart';

import 'rule_context.dart';

class RuleEngine {
  List<String> extractAll(
    HtmlExtractor extractor,
    RuleContext context,
    Map<String, dynamic> rule,
  ) {
    final selector = rule['selector'] as String?;
    if (selector == null || selector.isEmpty) {
      throw RuleException('selector is required');
    }

    final elements = extractor.select(selector);
    if (elements.isEmpty) {
      return const [];
    }

    final attribute = rule['attribute'] as String? ?? 'text';
    final joinUrl = rule['join'] == true;
    final regexPattern = rule['regex'] as String?;
    final regexGroup = rule['regexGroup'] as int? ?? 0;
    final transforms = (rule['transform'] as List?)
            ?.cast<Map<String, dynamic>>()
            .toList() ??
        [];

    final items = <String>[];
    for (final element in elements) {
      var value = attribute == 'text'
          ? extractor.text(element)
          : extractor.attribute(element, attribute) ?? '';
      if (value.isEmpty) {
        continue;
      }

      if (regexPattern != null) {
        final match = RegExp(regexPattern).firstMatch(value);
        if (match == null) {
          continue;
        }
        value = match.group(regexGroup) ?? match.group(0) ?? '';
      }

      if (joinUrl) {
        value = context.resolve(value).toString();
      }

      for (final transform in transforms) {
        value = _applyTransform(value, transform);
      }

      if (value.isNotEmpty) {
        items.add(value);
      }
    }

    return items;
  }

  String? extract(
    HtmlExtractor extractor,
    RuleContext context,
    Map<String, dynamic> rule,
  ) {
    final results = extractAll(extractor, context, rule);
    return results.isEmpty ? null : results.first;
  }

  String _applyTransform(String value, Map<String, dynamic> transform) {
    final type = transform['type'] as String?;
    if (type == null) {
      return value;
    }

    switch (type) {
      case 'trim':
        return value.trim();
      case 'lowercase':
        return value.toLowerCase();
      case 'uppercase':
        return value.toUpperCase();
      case 'prefix':
        final prefix = transform['value'] as String? ?? '';
        return '$prefix$value';
      case 'suffix':
        final suffix = transform['value'] as String? ?? '';
        return '$value$suffix';
      case 'replace':
        final pattern = transform['pattern'] as String?;
        final replacement = transform['replacement'] as String? ?? '';
        if (pattern == null) {
          return value;
        }
        return value.replaceAll(RegExp(pattern), replacement);
      default:
        return value;
    }
  }
}
