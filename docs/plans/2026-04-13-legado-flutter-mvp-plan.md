# Legado Flutter MVP Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first iOS/Android Flutter milestone for a Legado-compatible reader: source import, search, detail, table of contents, chapter content, and basic reading persistence.

**Architecture:** Replace the current tutorial-style sample app with a feature-based structure. Keep Legado rule parsing, HTTP access, and extraction logic in pure Dart services under `lib/core/` and `lib/data/`, then build thin Flutter feature screens on top of repositories and providers.

**Tech Stack:** Flutter, Dart, provider, http, html, flutter_test, flutter_lints

---

### Task 1: Replace the starter app shell with a feature-ready mobile shell

**Files:**
- Create: `lib/app/app.dart`
- Create: `lib/app/routes.dart`
- Modify: `lib/main.dart`
- Remove or stop referencing: `lib/pages/home.dart`, `lib/pages/favorite.dart`, `lib/pages/setting.dart`
- Test: `test/app/app_smoke_test.dart`

**Step 1: Write the failing test**

Create `test/app/app_smoke_test.dart` with a widget test that pumps the app and expects source list and search entry points instead of the random-word sample UI.

**Step 2: Run test to verify it fails**

Run: `flutter test test/app/app_smoke_test.dart`
Expected: FAIL because the new app shell and routes do not exist yet.

**Step 3: Write minimal implementation**

Create `lib/app/app.dart` and `lib/app/routes.dart`. Move `MaterialApp` setup out of `lib/main.dart`. Replace the bottom navigation sample with a minimal navigation shell that points to source management, search, bookshelf, and settings placeholders.

**Step 4: Run test to verify it passes**

Run: `flutter test test/app/app_smoke_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/main.dart lib/app/app.dart lib/app/routes.dart test/app/app_smoke_test.dart
git commit -m "feat: replace starter shell with reader app shell"
```

### Task 2: Define the reader domain models and repository contracts

**Files:**
- Create: `lib/data/models/book_source.dart`
- Create: `lib/data/models/search_book.dart`
- Create: `lib/data/models/book.dart`
- Create: `lib/data/models/book_chapter.dart`
- Create: `lib/data/models/reader_session.dart`
- Create: `lib/data/repositories/source_repository.dart`
- Create: `lib/data/repositories/book_repository.dart`
- Test: `test/data/models/book_source_test.dart`

**Step 1: Write the failing test**

Add tests that construct `BookSource` and verify required fields, JSON serialization, equality, and enabled-state defaults.

**Step 2: Run test to verify it fails**

Run: `flutter test test/data/models/book_source_test.dart`
Expected: FAIL because the models and repository contracts do not exist.

**Step 3: Write minimal implementation**

Add immutable Dart models and repository interfaces. Keep model fields focused on the MVP flow and leave extension points for unsupported Legado fields.

**Step 4: Run test to verify it passes**

Run: `flutter test test/data/models/book_source_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/data test/data
git commit -m "feat: add reader domain models and repository contracts"
```

### Task 3: Build the Legado source import and validation pipeline

**Files:**
- Create: `lib/core/rules/source_json_parser.dart`
- Create: `lib/features/sources/source_import_controller.dart`
- Create: `lib/features/sources/source_list_page.dart`
- Create: `lib/features/sources/source_import_page.dart`
- Test: `test/core/rules/source_json_parser_test.dart`
- Test: `test/features/sources/source_import_controller_test.dart`

**Step 1: Write the failing test**

Add parser tests using representative Legado source JSON fixtures. Cover valid import, missing required fields, duplicate detection, and enable/disable defaults.

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/rules/source_json_parser_test.dart test/features/sources/source_import_controller_test.dart`
Expected: FAIL because the parser and controller do not exist.

**Step 3: Write minimal implementation**

Implement JSON decoding into `BookSource`. Create a controller that accepts text input, clipboard input, and file payloads, validates records, deduplicates by stable source identity, and exposes import results to the UI.

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/rules/source_json_parser_test.dart test/features/sources/source_import_controller_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/core/rules lib/features/sources test/core test/features
git commit -m "feat: add source import and validation flow"
```

### Task 4: Implement the HTTP, HTML, and extraction core for common Legado rules

**Files:**
- Create: `lib/core/network/reader_http_client.dart`
- Create: `lib/core/network/response_decoder.dart`
- Create: `lib/core/parser/html_extractor.dart`
- Create: `lib/core/rules/rule_engine.dart`
- Create: `lib/core/rules/rule_context.dart`
- Create: `lib/core/errors/rule_exception.dart`
- Test: `test/core/network/response_decoder_test.dart`
- Test: `test/core/parser/html_extractor_test.dart`
- Test: `test/core/rules/rule_engine_test.dart`

**Step 1: Write the failing test**

Use fixtures to verify charset decoding, selector-based extraction, regex extraction, URL joining, and common rule transformations required by search/detail/toc/content.

**Step 2: Run test to verify it fails**

Run: `flutter test test/core/network/response_decoder_test.dart test/core/parser/html_extractor_test.dart test/core/rules/rule_engine_test.dart`
Expected: FAIL because the core execution layer does not exist.

**Step 3: Write minimal implementation**

Wrap `http` in a reader client. Add response decoding and HTML parsing helpers. Implement a first-pass rule engine that supports the common Legado operators required by the chosen fixtures.

**Step 4: Run test to verify it passes**

Run: `flutter test test/core/network/response_decoder_test.dart test/core/parser/html_extractor_test.dart test/core/rules/rule_engine_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/core test/core
git commit -m "feat: add legado-compatible rule execution core"
```

### Task 5: Build the multi-source search feature

**Files:**
- Create: `lib/features/search/search_page.dart`
- Create: `lib/features/search/search_controller.dart`
- Create: `lib/features/search/search_result_tile.dart`
- Modify: `lib/data/repositories/book_repository.dart`
- Test: `test/features/search/search_controller_test.dart`
- Test: `test/features/search/search_page_test.dart`

**Step 1: Write the failing test**

Add controller tests for successful multi-source search and partial source failure. Add a widget test for entering a keyword and rendering results or source errors.

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/search/search_controller_test.dart test/features/search/search_page_test.dart`
Expected: FAIL because search orchestration and UI do not exist.

**Step 3: Write minimal implementation**

Implement a search controller that fans out across enabled sources, aggregates results, surfaces per-source failures, and renders a simple result list.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/search/search_controller_test.dart test/features/search/search_page_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/search lib/data/repositories test/features/search
git commit -m "feat: add search across enabled book sources"
```

### Task 6: Build book details and chapter list retrieval

**Files:**
- Create: `lib/features/book/book_detail_page.dart`
- Create: `lib/features/book/book_detail_controller.dart`
- Create: `lib/features/book/chapter_list_view.dart`
- Test: `test/features/book/book_detail_controller_test.dart`
- Test: `test/features/book/book_detail_page_test.dart`

**Step 1: Write the failing test**

Add tests for fetching book detail data and TOC entries from a mocked source repository. Add a widget test for rendering chapter entries and loading states.

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/book/book_detail_controller_test.dart test/features/book/book_detail_page_test.dart`
Expected: FAIL because the detail feature does not exist.

**Step 3: Write minimal implementation**

Implement detail and TOC loading using the rule engine and repository layer. Show normalized metadata and a tappable chapter list.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/book/book_detail_controller_test.dart test/features/book/book_detail_page_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/book test/features/book
git commit -m "feat: add book detail and chapter list flow"
```

### Task 7: Build the reader page and progress persistence

**Files:**
- Create: `lib/features/reader/reader_page.dart`
- Create: `lib/features/reader/reader_controller.dart`
- Create: `lib/features/reader/reader_settings.dart`
- Create: `lib/data/repositories/reader_repository.dart`
- Test: `test/features/reader/reader_controller_test.dart`
- Test: `test/features/reader/reader_page_test.dart`

**Step 1: Write the failing test**

Add controller tests for chapter loading, next/previous chapter navigation, and progress restoration. Add a widget test for reader settings and content rendering.

**Step 2: Run test to verify it fails**

Run: `flutter test test/features/reader/reader_controller_test.dart test/features/reader/reader_page_test.dart`
Expected: FAIL because the reader feature does not exist.

**Step 3: Write minimal implementation**

Implement chapter rendering, chapter navigation, reader settings, and persistence hooks for the current reading session.

**Step 4: Run test to verify it passes**

Run: `flutter test test/features/reader/reader_controller_test.dart test/features/reader/reader_page_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/features/reader lib/data/repositories test/features/reader
git commit -m "feat: add reader page and progress persistence"
```

### Task 8: Add local storage for sources, bookshelf, and sessions

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/data/local/`
- Modify: `lib/data/repositories/source_repository.dart`
- Modify: `lib/data/repositories/book_repository.dart`
- Modify: `lib/data/repositories/reader_repository.dart`
- Test: `test/data/local/`

**Step 1: Write the failing test**

Add repository tests that verify source persistence, bookshelf save/remove, and reader session restoration with a concrete local storage backend.

**Step 2: Run test to verify it fails**

Run: `flutter test test/data/local`
Expected: FAIL because no persistence backend exists yet.

**Step 3: Write minimal implementation**

Choose and add a mobile-friendly local storage package. Implement adapters behind the repository interfaces so sources, bookshelf items, and reader sessions survive app restart.

**Step 4: Run test to verify it passes**

Run: `flutter test test/data/local`
Expected: PASS.

**Step 5: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/data/local lib/data/repositories test/data/local
git commit -m "feat: persist sources bookshelf and reader sessions"
```

### Task 9: Wire the navigation flow and remove obsolete sample code

**Files:**
- Modify: `lib/app/routes.dart`
- Modify: `lib/app/app.dart`
- Delete or archive: `lib/pages/home.dart`
- Delete or archive: `lib/pages/favorite.dart`
- Delete or archive: `lib/pages/setting.dart`
- Test: `test/app/navigation_test.dart`

**Step 1: Write the failing test**

Add a widget test that covers navigation from source management to search, then to detail and reader placeholders.

**Step 2: Run test to verify it fails**

Run: `flutter test test/app/navigation_test.dart`
Expected: FAIL until all routes and navigation targets are wired.

**Step 3: Write minimal implementation**

Connect the feature pages through the app shell and remove the tutorial sample pages from active use.

**Step 4: Run test to verify it passes**

Run: `flutter test test/app/navigation_test.dart`
Expected: PASS.

**Step 5: Commit**

```bash
git add lib/app test/app
git commit -m "refactor: wire reader navigation and remove tutorial pages"
```

### Task 10: Run project-wide verification and document unsupported rules

**Files:**
- Create: `docs/compatibility/legado-rule-support.md`
- Modify: `README.md`

**Step 1: Run full verification**

Run: `flutter analyze`
Expected: PASS with no analyzer errors.

**Step 2: Run full test suite**

Run: `flutter test`
Expected: PASS for the new unit and widget tests.

**Step 3: Document compatibility status**

List supported Legado rule operators, known gaps, and at least one tested source profile in `docs/compatibility/legado-rule-support.md`. Update `README.md` to describe the actual product direction and current mobile scope.

**Step 4: Commit**

```bash
git add README.md docs/compatibility
git commit -m "docs: document legado compatibility and mvp status"
```
