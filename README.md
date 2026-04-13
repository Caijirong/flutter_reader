# Flutter Reader

Flutter Reader is an iOS/Android-first attempt to build a multi-platform reader inspired by [Legado](https://github.com/gedoor/legado). The current goal is to validate the core mobile reading flow in Flutter while keeping the parsing and rule engine in pure Dart.

## Current Scope

The MVP currently focuses on:

- Legado-style source JSON import and validation
- Source rule parsing helpers and a first-pass extraction engine
- Multi-source search orchestration
- Book detail and chapter list loading
- Reader page, chapter navigation, and reader session hooks

The implementation plan and design notes live in:

- `docs/plans/2026-04-13-legado-flutter-design.md`
- `docs/plans/2026-04-13-legado-flutter-mvp-plan.md`

## Project Structure

- `lib/app/`: app shell and route metadata
- `lib/core/`: HTTP, decoding, HTML parsing, and rule execution helpers
- `lib/data/`: domain models and repository contracts
- `lib/features/sources/`: source import flow
- `lib/features/search/`: multi-source search UI and controller
- `lib/features/book/`: book detail and chapter list flow
- `lib/features/reader/`: reader page, settings, and session handling
- `test/`: unit and widget coverage for each feature area

## Getting Started

```bash
flutter pub get
flutter run
```

Useful checks:

```bash
flutter analyze
flutter test
```

## Current Status

Completed in the active MVP branch:

- App shell replacing the default Flutter starter
- Reader domain models and repository contracts
- Source import controller and parser tests
- Rule execution core built on `http` and `html`
- Search, book detail, and reader feature skeletons with tests

Still in progress:

- Local persistence for sources, bookshelf, and reader sessions
- Wiring the feature flows into the main app shell
- Compatibility documentation and final README cleanup

## Notes

- This repository is under active development and not production-ready.
- The current branch may contain MVP work ahead of `main`.
