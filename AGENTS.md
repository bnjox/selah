# AGENTS.md

## Commands
- **Build**: `flutter build apk` / `flutter build ios`
- **Test**: `flutter test` (all tests) or `flutter test test/widget_test.dart` (specific file)
- **Lint**: `flutter analyze`
- **Format**: `dart format .`
- **Run**: `flutter run`

## Architecture
- **100% Offline**: No internet, no cloud services, no APIs, no analytics
- **State**: Provider (not Riverpod) manages topics, sessions, settings
- **Database**: SQLite via sqflite for local persistence (no migrations initially)
- **Timer**: `Timer.periodic` foreground-only (no background service)
- **Structure**: `lib/pages/` (UI), future: `lib/models/`, `lib/providers/`, `lib/services/`, `lib/widgets/`

## Code Style
- **Strings**: Single quotes (`'string'`)
- **Classes**: PascalCase; **variables/functions**: camelCase
- **Imports**: dart > flutter > third-party > local (use relative imports)
- **Types**: Explicit on public APIs, inferred on locals
- **Null Safety**: Enforced (SDK ^3.6.0); use `?` and `!` carefully
- **Widgets**: Use Material 3, const constructors, keep composable
- **Errors**: try-catch with user-friendly messages; no silent failures
- **Lints**: Follow `flutter_lints/flutter.yaml` (analysis_options.yaml)