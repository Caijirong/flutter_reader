# Repository Guidelines

## Project Structure & Module Organization
This repository is a small Flutter app. Application code lives in `lib/`, with the entry point in `lib/main.dart` and page widgets in `lib/pages/` (`home.dart`, `favorite.dart`, `setting.dart`). Platform runners are in `android/`, `ios/`, `linux/`, `macos/`, `web/`, and `windows/`. Shared Flutter dependencies are declared in `pubspec.yaml`; static assets should also be registered there under `flutter:` when added. There is no top-level `test/` directory yet, so new unit and widget tests should be created under `test/`.

## Build, Test, and Development Commands
- `flutter pub get`: install Dart and Flutter dependencies from `pubspec.yaml`.
- `flutter run`: launch the app on the default device or simulator.
- `flutter run -d chrome`: run the app in a browser for quick UI checks.
- `flutter analyze`: apply the `flutter_lints` rules configured by `analysis_options.yaml`.
- `flutter test`: run all tests in `test/`.
- `flutter build apk` or `flutter build web`: produce release artifacts for Android or Web.

## Coding Style & Naming Conventions
Follow standard Dart style: 2-space indentation, trailing commas where they improve formatting, and one widget per responsibility. Use `PascalCase` for classes and widgets, `lowerCamelCase` for variables and methods, and `snake_case.dart` for file names. Keep state changes centralized in `MyAppState` or a dedicated provider instead of scattering mutable logic across pages. Run `dart format lib test` and `flutter analyze` before opening a PR.

## Testing Guidelines
Use `flutter_test` for unit and widget coverage. Name test files `*_test.dart` and mirror the feature structure, for example `test/pages/home_page_test.dart`. Prefer widget tests for UI behavior and provider-driven state transitions. For any behavior change, add or update at least one test; for bug fixes, include a regression test when practical.

## Commit & Pull Request Guidelines
Git history currently contains only a minimal `first commit`, so use clear imperative subjects going forward, such as `Add favorite list empty state`. Keep commits focused and easy to review. PRs should include a short description, testing notes (`flutter analyze`, `flutter test`), linked issues when applicable, and screenshots or recordings for visible UI changes.
