import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reader/core/parser/html_extractor.dart';

void main() {
  const html = '''
<html>
  <body>
    <div class="item" data-value="first">First</div>
    <div class="item" data-value="second">Second</div>
    <a href="/relative">Link</a>
  </body>
</html>
''';

  test('selects elements by CSS selector', () {
    final extractor = HtmlExtractor.parse(html);
    final items = extractor.select('.item');
    expect(items.length, 2);
    expect(extractor.text(items.first), 'First');
    expect(extractor.attribute(items.last, 'data-value'), 'second');
  });

  test('resolves URLs when baseUri is provided', () {
    final extractor = HtmlExtractor.parse(html, baseUri: Uri.parse('https://example.com'));
    final link = extractor.select('a').first;
    final resolved = extractor.resolve(extractor.attribute(link, 'href')!);
    expect(resolved?.toString(), 'https://example.com/relative');
  });
}
