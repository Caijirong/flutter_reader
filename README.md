# Flutter Reader

Flutter Reader is an iOS/Android-first rewrite of the Legado reading experience using Flutter. The goal is to reproduce Legado’s multi-source book catalog, parsing rules, and reader UX inside a single code base so that the reading flow can ship on both mobile platforms without relying on native-only implementations.

## Product Direction
We are building a Legado-compatible reader where every mobile screen—from source import through reader settings—applies the same rule execution stack and persistence guarantees you expect from the original Android app. The current codebase proves the Legado core in Dart, wires it into reusable feature controllers, and layers a single navigation shell that can later be extended to additional platforms.

## Mobile Scope Today
- Import Legado-style source JSON through the current text-driven source flow, with controller hooks and placeholder entry points ready for clipboard/file payload wiring.
- Run the lightweight rule engine that supports selectors, attribute extraction, regex parsing, URL joining, and basic transforms.
- Search across enabled sources, show book detail + chapter lists, then load text into the reader with next/previous navigation, reader settings, and saved sessions.
- Persist configured sources, bookshelf bookmarks, and reader sessions via `SharedPreferences` so state survives app restarts.
- Keep the UI focused on mobile navigation (sources/search/bookshelf/reader) and the shared Dart rule/core stack.

## Feature Status
- App shell, navigation metadata, and smoke tests for placeholder flows are in place.
- Rule execution core, HTTP helpers, and HTML extraction logic live under `lib/core/` with unit coverage.
- Source import, search, book detail, and reader sections are implemented under `lib/features/` with controllers, widgets, and tests.
- Shared persistence adapters now store sources, bookshelf entries, and reader sessions in local storage.

## Getting Started
```bash
flutter pub get
flutter run
```

## Testing
```bash
flutter analyze
flutter test
```

## Compatibility
Supported Legado rule operators and known gaps are documented in `docs/compatibility/legado-rule-support.md`, including a tested source profile and the set of transform helpers the engine currently understands.

## Notes
- This project is not yet production ready; the focus remains on verifying the Legado reading pipeline before adding platform-specific polish.
- The repository tracks work on `feat/legado-flutter-mvp`. Use `git status` or `git log` there to see the latest verified checkpoints.
