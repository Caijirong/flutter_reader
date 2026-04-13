import 'package:html/dom.dart';
import 'package:html/parser.dart';

class HtmlExtractor {
  final Document document;
  final Uri? baseUri;

  HtmlExtractor.parse(String html, {this.baseUri}) : document = parse(html);

  List<Element> select(String selector) => document.querySelectorAll(selector);

  String? attribute(Element element, String name) => element.attributes[name];

  String text(Element element) => element.text.trim();

  Uri? resolve(String value) {
    if (baseUri == null) {
      return null;
    }
    return baseUri!.resolve(value);
  }
}
