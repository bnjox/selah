# Prayer Pomodoro App Plan

## App Overview
**100% OFFLINE LOCAL APP** - No internet required, no cloud services, no external APIs, no analytics, no tracking.

This is a personal Flutter mobile app focused on structured prayer sessions with Pomodoro-style timing. It allows users to create prayer sessions with customizable intervals for different prayer topics. The app focuses on faith-based productivity for personal use, starting with timer functionality first, then adding psalms later. All data is stored locally in SQLite. Zero external dependencies.

## Core Features (Phase 1: Timer Focus)

### 1. Main Page (Session Creator) ☐
- Central hub resembling a timer interface.
- Button to "Create New Prayer Session".
- Upon creation, select prayer topics for the session and set time per topic (e.g., 2 minutes each).
- Customizable intervals are a core feature.

### 2. Prayer Session Page ☐
- Starts after session creation.
- Timer cycles through selected prayer topics.
- Displays current topic, remaining time, and progress.
- Transitions automatically to next topic when time expires.
- Option to pause/resume or skip topics.

### 3. Prayer Topics Management Page ☐
- Add/edit/delete prayer topics.
- Each topic includes:
  - Title
  - Description (can include Bible passages/references)
  - Category/tag
- Default pre-seeded topics (non-deletable):
  - Family
  - Ministry
  - Souls
  - Holy Spirit
  - God use me
  - Health
- Users can add custom topics later.

### 4. Settings Page ☐
- Prayer streak tracking (optional, can be turned off).
- Basic notification preferences.
- App-wide configurations.

## Future Features (Phase 2: Psalms Addition)

### 5. Psalms/Quotes Page ☐
- Dedicated page for displaying psalms or standout quotes.
- List view of psalms with search/filter by category.
- No randomness; static list for easy navigation.
- Tapping a psalm opens full text view.

## Navigation
- Bottom navigation bar for easy access:
  - Sessions (main page)
  - Topics
  - Settings
- (Psalms/Quotes tab added in Phase 2)

## Technical Stack (100% Offline)

### Dependencies
- **State Management**: Provider (no Riverpod, no external state sync)
- **Timer**: Flutter's `Timer.periodic` (foreground only)
- **Database**: sqflite (local SQLite only)
- **UI**: Material Design 3 (no web integration, no remote fonts)
- **Assets**: Hardcoded psalms/quotes (no API calls, no remote loading)

### Strict Offline Constraints (DO NOT VIOLATE)
- ❌ NO internet permissions (remove `uses-permission android:name="android.permission.INTERNET"`)
- ❌ NO cloud services (Firebase, AWS, Supabase, etc.)
- ❌ NO APIs or HTTP calls (no REST, no GraphQL, no WebSockets)
- ❌ NO analytics (no Google Analytics, Mixpanel, Sentry, Crashlytics)
- ❌ NO tracking (no ads, no user tracking, no telemetry)
- ❌ NO external fonts (use system fonts only)
- ❌ NO remote asset loading
- ❌ NO background services that require internet
- ✅ SQLite for all persistence
- ✅ Device-local files only
- ✅ All data stays on device, period

### UI/UX
- Follow Material Design 3
- Ensure accessibility with proper contrast and font sizes
- Add progress indicators for timers
- Hardcoded psalms/quotes (no dynamic loading)

### Features
- Prayer history tracking (local database only)
- Session templates (pre-configured topic sets)
- Audio cues for topic transitions (Phase 3, optional, device speaker only)

### Testing
- Unit tests for timer logic and integration tests for session flow
- NO network tests, NO API mocking (not applicable)

### Security/Privacy
- 100% local storage on device
- No external data sharing
- No analytics, no monitoring, no tracking
- User has complete control over all data
- No telemetry of any kind

## Missing Features to Add
- Session templates for quick setup (e.g., "Morning Prayer", "Evening Reflection").
- Audio notifications/sounds for topic transitions.
- Visual feedback for completed sessions (celebration animations).
- Session statistics (total prayer time, most-used topics).

- Widget support for home screen quick access.
- Multi-language support for broader accessibility.

## Implementation Phases

### Phase 0: Foundation & Setup (Week 1) ☐ **CRITICAL - DO THIS FIRST**
- [ ] Add dependencies: `provider`, `sqflite`, `path`, `intl`
- [ ] Create folder structure: `lib/models/`, `lib/providers/`, `lib/services/`, `lib/widgets/`, `lib/pages/`
- [ ] Define data models:
  - [ ] `PrayerTopic` (id, title, description, category, isDefault)
  - [ ] `Session` (id, topics, timePerTopic, createdAt, completedAt, totalTime)
  - [ ] `AppSettings` (streakEnabled, notificationsEnabled, theme)
- [ ] Create `DatabaseService` with sqflite initialization and seed data
- [ ] Set up Provider state management for: `topicsProvider`, `sessionsProvider`, `settingsProvider`
- [ ] Fix app title typo: "Paslms Collection" → "Selah"
- [ ] Build main scaffold with BottomNavigationBar (3 tabs)
- [ ] Implement basic routing/navigation between tabs

### Phase 1: Timer Foundation (Week 2-3) ☐
- [ ] Build Settings page UI with streak toggle and notification toggle
- [ ] Implement basic styling with Material 3 color scheme
- [ ] Create reusable AppBar and card widgets
- [ ] Add theme constants (colors, spacing, typography)
- [ ] Seed database with default prayer topics
- [ ] Basic settings persistence to database

### Phase 2: Session Management (Week 4-5) ☐
- [ ] Develop Session Creator page with topic selection and time settings
- [ ] Implement Prayer Session page with timer functionality
- [ ] Add pause/resume/skip controls
- [ ] Integrate background timer support
- [ ] Basic session history tracking

### Phase 3: Topics Management (Week 6-7) ☐
- [ ] Build Prayer Topics Management page (CRUD operations)
- [ ] Add category/tag filtering
- [ ] Implement session templates feature
- [ ] Add audio cues and visual feedback for transitions

### Phase 4: Polish & Testing (Week 8-9) ☐
- [ ] Create session statistics dashboard
- [ ] Comprehensive testing (unit, integration, UI)
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Bug fixes and UI polish

### Phase 5: Psalms Addition (Future) ☐
- [ ] Add Psalms/Quotes tab to navigation
- [ ] Create psalms list view with search and filtering
- [ ] Implement full psalm display page
- [ ] Pre-populate with sample psalms/quotes
- [ ] Integration with timer sessions (optional psalms during breaks)

## Development Notes
- Adapt existing `homepage.dart` to session creator.
- Expand `psalm_page.dart` for full psalm display.
- Create new pages: `session_page.dart`, `topics_page.dart`, `settings_page.dart`.
- Fix app title typo: "Psalms Collection" → "Selah".
- Ensure timer reliability across app states (foreground/background).

## Critical Architectural Decisions

### State Management Strategy
- Use `Provider` (not Riverpod) as specified in plan
- Create three main state classes:
  - `TopicsNotifier`: CRUD for prayer topics
  - `SessionsNotifier`: Active session state + history
  - `SettingsNotifier`: User preferences
- All state persists to SQLite; no state is lost on app restart

### Timer Architecture (Foreground Only)
- Central `TimerService` singleton handles all timing logic
- Separate `Timer.periodic` state from UI; UI listens via Provider
- Plan for lifecycle: pause app → timer pauses → resume app → timer resumes
- Use `AppLifecycleListener` to hook app state changes
- **NO background service**: Timer is foreground-only; users keep app in focus during sessions
- **NO background persistence**: When app is killed, timer stops (acceptable for personal prayer use)

### Database Schema
```sql
-- prayer_topics
CREATE TABLE prayer_topics (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  isDefault INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL
);

-- sessions
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  totalDurationSeconds INTEGER,
  completedAt INTEGER,
  createdAt INTEGER NOT NULL
);

-- session_topics (junction table)
CREATE TABLE session_topics (
  sessionId INTEGER,
  topicId INTEGER,
  orderIndex INTEGER,
  durationSeconds INTEGER,
  FOREIGN KEY(sessionId) REFERENCES sessions(id),
  FOREIGN KEY(topicId) REFERENCES prayer_topics(id)
);

-- app_settings
CREATE TABLE app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

### Explicitly Deprioritized / NOT DOING (Offline-First)
- ❌ **Cloud Sync** - Not applicable; pure local SQLite only
- ❌ **Firebase, AWS, Supabase** - NO external services
- ❌ **Analytics (Google Analytics, Mixpanel, Sentry, Crashlytics)** - NO tracking, NO external monitoring
- ❌ **API Integration** - No HTTP calls, no network requests
- ❌ **Notifications** - Would require cloud infrastructure; skip entirely
- ❌ **Background Timer Service** - Foreground-only is acceptable for personal app
- ❌ **Widget Support** - Not needed for local-only app
- ❌ **Multi-language** - Personal English-only app
- ❌ **Share Features** - No external sharing; data stays local
- ✅ **Audio Cues** - Local device speaker only; Phase 3 if desired
- ✅ **Prayer Streak** - Local database tracking; Phase 2 if desired

### Testing Strategy
- Unit tests for `TimerService` and all notifiers (state changes, edge cases)
- Widget tests for core screens (Session Creator, Timer UI, Topics List)
- Integration test for full session flow (create → start → transition topics → complete)
- Test timer edge cases: fast time skips, system interruptions, manual pause/resume

### Known Complexity Areas
1. **Timer Lifecycle** - Hardest part; test extensively across cold start, app backgrounding, phone lock/unlock
2. **SQLite Migrations** - Plan upgrade path before v1.0 release; breaking changes require user data migration
3. **Material 3 Theming** - Use `ColorScheme.fromSeed` but also allow manual override in Settings
4. **Psalm/Quotes Data** - Phase 2; decide now if data comes from JSON assets, hardcoded, or API

### Error Handling Approach (Local SQLite Only)
- All database operations wrapped in try-catch; log errors, show user-friendly toast messages
- Timer failures: graceful fallback, resume from last checkpoint
- Missing data: seed defaults, never crash on corrupted database
- No external error reporting needed; basic console logging via `print()` or `debugPrint()`
- Test edge cases: database corruption, disk full, rapid app backgrounding

## Quick Win Checklist for First Week
- [ ] Rename app to "Selah" (pubspec.yaml + main.dart)
- [ ] Add `provider` + `sqflite` to pubspec.yaml
- [ ] Create all three model files (PrayerTopic, Session, AppSettings)
- [ ] Create DatabaseService with seed data
- [ ] Replace HomePage with BottomNavigationBar scaffold
- [ ] Verify app builds and runs without crashes

This plan keeps the app focused, personal, and spiritually enriching while incorporating productivity elements.