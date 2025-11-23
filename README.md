# Selah

**A 100% offline prayer timer app for structured, faith-based productivity.**

## Overview

Selah is a personal Flutter mobile app for structured prayer sessions using Pomodoro-style timing. Create prayer sessions with customizable intervals for different prayer topics. Everything stays local on your device—no internet required, no cloud services, no tracking.

- ✅ **100% Offline** - No internet needed, ever
- ✅ **No Cloud** - No Firebase, AWS, or external services
- ✅ **No Tracking** - No analytics, no telemetry, no ads
- ✅ **No Monetization** - Personal app, yours alone
- ✅ **Local SQLite** - All data stays on your device
- ✅ **Private** - Complete user control

## Core Features

### Phase 1: Timer Foundation
- **Sessions Management**: Create prayer sessions with custom topics and time intervals
- **Prayer Topics**: Default pre-seeded topics + ability to add custom ones
- **Settings Page**: Basic app configuration (streak toggle, UI preferences)
- **Timer**: Simple foreground-only timer that cycles through prayer topics

### Phase 2: Session Management
- Prayer Session page with active timer, progress tracking, pause/resume/skip controls
- Session history and statistics (local database)
- Session templates for quick setup

### Phase 3: Polish & Features
- Prayer Topics management (CRUD operations)
- Audio cues for topic transitions (device speaker only)
- Visual feedback and animations
- UI refinements

### Phase 4+: Psalms & Advanced
- Psalms/Quotes tab (hardcoded or JSON assets, no API)
- Additional features as desired

## Technical Stack

- **Framework**: Flutter 3.6+
- **State Management**: Provider (no external sync)
- **Database**: SQLite via sqflite (local only)
- **UI**: Material Design 3
- **Timer**: Flutter's `Timer.periodic` (foreground only)

### Strict Offline Constraints
- ❌ NO internet permissions
- ❌ NO cloud services (Firebase, AWS, Supabase)
- ❌ NO APIs or HTTP calls
- ❌ NO analytics or tracking
- ❌ NO external fonts or resources
- ❌ NO background services
- ✅ SQLite for all persistence
- ✅ Device-local files only
- ✅ All data stays on device, always

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models (PrayerTopic, Session, etc.)
├── providers/             # Provider state management
├── services/              # DatabaseService, TimerService
├── widgets/               # Reusable components
└── pages/                 # Main screens (Sessions, Topics, Settings)
```

## Getting Started

### Prerequisites
- Flutter SDK 3.6+
- Dart SDK 3.6+

### Setup
```bash
git clone https://github.com/bnjox/selah.git
cd selah
flutter pub get
flutter run
```

### Build
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

### Development
```bash
# Format code
dart format .

# Lint
flutter analyze

# Test
flutter test
```

## Development Notes

- All data is stored locally in SQLite; **no cloud sync**
- Timer is **foreground-only**; app must be in focus during sessions
- **No external dependencies** beyond Flutter, Provider, and sqflite
- See `app_plan.md` for detailed roadmap and phases

## Privacy & Security

- **100% local storage** - All data stays on your device
- **No tracking** - No analytics, telemetry, or monitoring
- **No external sharing** - Your data is never sent anywhere
- **No permissions required** - App doesn't need internet, location, or contacts

## License

[See LICENSE file](./LICENSE)

---

**Selah** - *pause, reflect, pray*
