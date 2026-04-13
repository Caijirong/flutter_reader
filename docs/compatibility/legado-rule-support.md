# Legado Rule Support

This page records what the Dart rule engine currently admits, the known gaps we are actively tracking, and a concrete source profile that is exercised by the existing tests.

## Supported Operators
- `selector` is mandatory. Every rule must provide a CSS selector (no XPath yet) and the extractor will render only the matched nodes’ text or attribute values.
- `attribute` allows extracting attributes such as `href`, `data-id`, or `src`; omitting this key defaults to the element’s text content.
- `join` resolves relative URLs using the configured base URI so pages can follow Legado-style `detailHref` + `chapterHref` chains.
- `regex` + `regexGroup` apply a Dart regular expression to the extracted string before transforms run.
- `transform` is a list of helpers. The engine currently understands `trim`, `lowercase`, `uppercase`, `prefix`, `suffix`, and a `replace` entry that accepts a regex `pattern` plus a `replacement` string.

Every supported operator is both implemented in `lib/core/rules/rule_engine.dart` and covered by `test/core/rules/rule_engine_test.dart`, including the `Alpha/Beta` sample HTML used there.

## Known Gaps
- XPath selectors or advanced query languages are not supported yet; only CSS selectors via `HtmlExtractor` are in play.
- The shared `RuleContext` exposes `currentUri` but no code reads it, so `join` always resolves against the declared `baseUri`. Relative URLs from paginated responses will need future plumbing once we integrate the actual HTTP response data.
- There is no `pluck`, `regexReplace`, `split`, or `concat` operator beyond the simple transform set listed above, so complex Legado rules that strip characters or recombine segments must be expressed via chained `replace`/`prefix`/`suffix` calls for now.
- The rule engine ignores pagination/state hints (no built-in `nextPage` or `pagination` helpers) and dissallows parameterized headers beyond static defaults, so any dynamic token or cookie dance must be handled manually by new helpers.
- The parser and persistence layers assume valid JSON; corrupt payloads throw at decode time without graceful migration.

## Tested Source Profile
The `SourceJsonParser` tests exercise a representative Legado profile. The “Alpha Source” payload in `test/core/rules/source_json_parser_test.dart` defines two enabled endpoints for books, chapters, and content:

```json
{
  "id": "alpha",
  "name": "Alpha Source",
  "baseUrl": "https://alpha.example",
  "searchEndpoint": "/api/search",
  "detailEndpoint": "/api/detail",
  "chapterEndpoint": "/chapter",
  "contentEndpoint": "/content",
  "defaultHeaders": {"User-Agent": "Legado/1"}
}
```

This payload is parsed, stored, and re-used to validate deduplication, required fields, and enabled defaults, so it acts as our canonical “tested” source rule. Any change to the rule engine or parser that breaks parsing of this profile will be caught by `test/core/rules/source_json_parser_test.dart` and `test/features/sources/source_import_controller_test.dart`.
