# Legado Flutter MVP Design

## Goal
Build a Flutter-based mobile reader for iOS and Android that targets high compatibility with Legado book source rules. The first milestone is a usable end-to-end flow: import source JSON, search books, open details, browse chapter list, fetch chapter content, and read with basic progress persistence.

## Scope
Included in phase 1:
- Source JSON import from file, clipboard, and pasted text
- Local source management: validate, deduplicate, enable, disable
- Rule execution for common Legado search, detail, toc, and content patterns
- Search results, book details, chapter list, reader page
- Local bookshelf, reading history, reading progress

Explicitly excluded:
- Web, desktop, and sync
- TTS, plugins, and advanced animation
- Full parity with every Legado edge case on day one

## Current Repository Status
The current app is still a Flutter starter prototype. `lib/main.dart` holds app state for random word pairs, `lib/pages/home.dart` and `lib/pages/favorite.dart` implement tutorial-style sample pages, and `lib/pages/setting.dart` only experiments with raw HTTP fetches. No reader domain model, storage layer, test suite, or rule engine exists yet.

## Architecture
Use a layered structure so the Legado-compatible rule engine stays independent from Flutter UI:

- `lib/core/`
  - HTTP client, cookies, charset decoding, HTML parsing, selector helpers, rule evaluation, error types
- `lib/data/`
  - DTOs, repositories, local database adapters, import/export helpers
- `lib/features/sources/`
  - Source import, source list, validation, enable/disable
- `lib/features/search/`
  - Search form, multi-source search orchestration, result rendering
- `lib/features/book/`
  - Book detail, toc loading, chapter selection
- `lib/features/reader/`
  - Chapter rendering, reader settings, progress saving

Keep parsing and network code in pure Dart where possible so it can be tested without widget harnesses.

## Data Model
Phase 1 needs these core entities:
- `BookSource`: source metadata, request config, rule definitions, enabled state
- `SearchBook`: title, author, cover, intro, detail URL, source ID
- `Book`: normalized detail model used by bookshelf and details page
- `BookChapter`: chapter title, chapter URL, index, flags for volume or VIP when available
- `ReaderSession`: current book, chapter index, scroll/page progress, theme and font settings

## Technical Decisions
- State management: continue with `provider` initially to limit churn
- Networking: use `http`, wrapped behind a repository-friendly client
- Parsing: use `html` for DOM parsing; add selector/rule helpers around it
- Persistence: add a local database package later in implementation, but keep repository interfaces stable now
- Compatibility strategy: optimize for the most common Legado JSON structure first, then expand unsupported operators incrementally behind tests

## Risks
- Legado rule compatibility is the hardest part; unsupported operators will surface quickly
- Character encoding and anti-scraping behavior differ per source
- Some rules may rely on parsing behavior that is Android-centric and needs adaptation in Dart

## Definition of Done for MVP
- Importing a real Legado source JSON succeeds
- At least one realistic source can complete search -> detail -> toc -> content in the app
- Reader progress survives app restart
- Core rule parsing and extraction paths have automated tests
