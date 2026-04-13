import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/core/parser/html_extractor.dart';
import 'package:flutter_reader/core/rules/rule_context.dart';
import 'package:flutter_reader/core/rules/rule_engine.dart';
import 'package:flutter_reader/core/errors/rule_exception.dart';

void main() {
  const html = '''
<html>
  <body>
    <div class="result">
      <a href="/book/42" data-id="42">The Answer</a>
    </div>
    <div class="result">
      <a href="https://external.example/book/hello" data-id="84">Hello World</a>
    </div>
  </body>
</html>
''';

  final context = RuleContext(baseUri: Uri.parse('https://reader.example'));
  final extractor = HtmlExtractor.parse(html, baseUri: context.baseUri);
  final engine = RuleEngine();

  test('extracts text nodes by selector', () {
    final value = engine.extract(
      extractor,
      context,
      {'selector': '.result a'},
    );
    expect(value, 'The Answer');
  });

  test('applies regex and transforms', () {
    final values = engine.extractAll(
      extractor,
      context,
      {
        'selector': '.result a',
        'attribute': 'data-id',
        'regex': r'(\d+)',
        'transform': [
          {'type': 'prefix', 'value': 'id-' },
          {'type': 'suffix', 'value': '-ok'},
        ],
      },
    );
    expect(values, ['id-42-ok', 'id-84-ok']);
  });

  test('joins relative URLs when requested', () {
    final values = engine.extractAll(
      extractor,
      context,
      {
        'selector': '.result a',
        'attribute': 'href',
        'join': true,
      },
    );
    expect(values[0], 'https://reader.example/book/42');
    expect(values[1], 'https://external.example/book/hello');
  });

  test('throws when selector is missing', () {
    expect(
      () => engine.extract(extractor, context, {}),
      throwsA(isA<RuleException>()),
    );
  });
}
