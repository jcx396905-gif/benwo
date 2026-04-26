# BenWo (本我) - AI-Powered Self-Discovery & Goal Achievement App

English | [中文](./BENWO_README.md)

---

## Project Overview

**BenWo (本我)** is an AI-powered self-discovery and goal achievement application. Through a 4-step guided Onboarding process, it helps users complete self-awareness, set big goals, and intelligently break them down into daily To-Dos.

### Core Philosophy

- **Explore the Self**: Help users deeply understand themselves through structured guided processes
- **Goal-Driven**: Break grand goals into actionable small tasks
- **AI-Empowered**: Use AI to break down goals, generate tasks, and motivate users
- **Small Steps Fast**: Complete one task at a time, commit after testing, ensure clean mergeable code

---

## Features

### Core Features

| Feature | Description |
|---------|-------------|
| Email Login/Register | Simple email + password auth with SHA256 encryption |
| 4-Step Onboarding | AI-guided self-exploration (Who am I → My现状 → What I want → AI confirmation) |
| User Profile | Multi-dimensional: MBTI, communication preferences, work hours, stress responses |
| Big Goal Creation | Set goal title, category, target date, optional color |
| AI Goal Splitting | AI breaks big goals into daily To-Dos (template-based by category) |
| Today's To-Do | AI-generated + user-created, AI tasks require confirmation (3 reflection questions) |
| Calendar View | Day/Week/Month views, drag-to-change-date, long-press drag |
| Goal Completion Animation | Auto-detect all To-Dos done → mark goal complete + celebration animation |
| Local Push Notifications | flutter_local_notifications ready, AI smart scheduling |
| Settings Page | Push toggle, frequency settings, profile view, logout |

### Not Included (MVP)

- ❌ AI chat feature (MinMax API reserved)
- ❌ Dark mode
- ❌ Cloud sync
- ❌ Community features

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x + Dart |
| State Management | flutter_riverpod + riverpod_annotation |
| Routing | go_router |
| Network | dio |
| Local Storage | isar + shared_preferences |
| DI | Riverpod Provider + InjectionContainer |
| Push Notifications | flutter_local_notifications |
| AI Service | MinMax API (reserved, Mock implemented) |
| Internationalization | flutter_localizations + intl |
| Icons | tabler_icons + cupertino_icons |
| Form Validation | crypto (SHA256) |

---

## Architecture Design

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│     Pages (Screens) / Widgets / Riverpod Notifiers      │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                         │
│         Entities / Repository Interfaces                │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                        Data Layer                         │
│   Repository Impls / Isar DB / MinMax API Client        │
└─────────────────────────────────────────────────────────┘
```

### Project Directory Structure

```
hello-flutter/
├── lib/
│   ├── main.dart                     # App entry, Isar + Riverpod init
│   ├── app.dart                      # Root widget, MaterialApp.router
│   │
│   ├── core/                         # Core layer
│   │   ├── constants/                # Constants
│   │   │   ├── app_constants.dart    # MBTI types, challenges, timeframes
│   │   │   └── api_constants.dart    # MinMax API config
│   │   ├── di/                       # Dependency injection
│   │   │   └── injection.dart         # InjectionContainer
│   │   ├── error/                    # Error handling
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── theme/                    # Theme config
│   │   │   ├── app_colors.dart       # Morandi colors (#7FA99B + #E8A87C)
│   │   │   └── app_theme.dart         # Material 3 theme
│   │   └── utils/                    # Utilities
│   │       └── auth_utils.dart        # SHA256 password hashing
│   │
│   ├── data/                         # Data layer
│   │   ├── datasources/
│   │   │   └── local/
│   │   │       └── isar_database.dart # Isar DB + 5 Repository impls
│   │   ├── models/                   # Isar Collections
│   │   │   ├── user_model.dart
│   │   │   ├── user_profile_model.dart
│   │   │   ├── big_goal_model.dart
│   │   │   ├── todo_item_model.dart
│   │   │   └── user_settings_model.dart
│   │   └── repositories/             # Repository interfaces
│   │
│   ├── application/                  # Application layer (Riverpod Notifiers)
│   │   ├── auth/
│   │   │   └── auth_notifier.dart    # Auth state management
│   │   ├── goal/
│   │   │   ├── goal_completion_notifier.dart
│   │   │   └── goal_split_notifier.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_controller.dart
│   │   └── profile/
│   │       └── profile_notifier.dart
│   │
│   ├── presentation/                # Presentation layer
│   │   ├── pages/
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── onboarding/
│   │   │   │   └── onboarding_page.dart (4 steps)
│   │   │   ├── home/
│   │   │   │   └── home_page.dart
│   │   │   ├── goals/
│   │   │   │   ├── goals_list_page.dart
│   │   │   │   ├── goal_detail_page.dart
│   │   │   │   └── create_goal_page.dart
│   │   │   ├── calendar/
│   │   │   │   ├── calendar_page.dart (day/week/month views)
│   │   │   │   └── _completed_history_sheet.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_page.dart
│   │   │   ├── settings/
│   │   │   │   └── settings_page.dart
│   │   │   ├── error_page.dart
│   │   │   └── not_found_page.dart
│   │   └── widgets/                 # Common widgets
│   │       ├── gradient_background.dart
│   │       ├── loading_indicator.dart
│   │       └── skeleton_loader.dart
│   │
│   ├── shared/                      # Shared widgets
│   │   └── widgets/
│   │
│   ├── routes/                      # Route config
│   │   ├── app_router.dart          # GoRouter config
│   │   └── auth_guard.dart           # Route guard
│   │
│   └── l10n/                        # Localization
│       ├── app_localizations.dart
│       ├── app_en.arb
│       └── app_zh.arb
│
├── test/                           # Test directory
├── pubspec.yaml
├── analysis_options.yaml
└── android/                        # Android config
```

---

## AI Auto-Coding Agent Development Workflow

This project was developed using an **AI Auto-Coding Agent** pattern, achieving full automation throughout the development process:

### Development Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI Development Loop                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   task.json (30 tasks)                                          │
│         │                                                        │
│         ▼                                                        │
│   ┌─────────────────┐                                           │
│   │  Read Task      │ ◄─────────────────────┐                   │
│   └────────┬────────┘                      │                    │
│            │                               │                    │
│            ▼                               │                    │
│   ┌─────────────────┐     No              │                    │
│   │  Init Env       │────Next Step──────┘                    │
│   │  (init.sh)      │                                         │
│   └────────┬────────┘                                         │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐                                          │
│   │  Write Code     │                                          │
│   │  (AI Agent)     │                                          │
│   └────────┬────────┘                                          │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐                                          │
│   │  Test & Verify  │                                          │
│   │  flutter analyze│                                         │
│   │  flutter build  │                                          │
│   └────────┬────────┘                                          │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐     Yes           ┌─────────────────┐   │
│   │  All Tests Pass? │─────── ✓ ────────→ │  Update Progress │   │
│   └────────┬────────┘                  └────────┬────────┘   │
│            │ No                                │              │
│            ▼                                   ▼              │
│   ┌─────────────────┐                 ┌─────────────────┐     │
│   │  Fix Issues     │                 │  git commit     │     │
│   └────────┬────────┘                 └────────┬────────┘     │
│            │                               │                    │
│            └───────────────────────────────┘                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### task.json Task Structure

```json
{
  "id": 1,                    // Task ID
  "title": "Project Basic Setup", // Task title
  "category": "infrastructure", // Category: infrastructure/ui/business
  "description": "...",      // Task description
  "steps": ["Step 1", "Step 2"], // Implementation steps
  "passes": true              // Completion status
}
```

### 30 Tasks by Phase

| Phase | Task IDs | Description |
|-------|----------|-------------|
| Infrastructure | 1-5 | Project config, routing, DI, data models, database |
| Auth | 6-8 | Login, register, state management |
| Onboarding | 9-12 | 4-step guided interface |
| Home/To-Do | 13-15 | Today's tasks, add, edit |
| Big Goals | 16-19 | Create, list, detail, AI split, completion animation |
| Calendar | 20-23 | Day/week/month views, drag, history |
| Profile/Push | 24-26 | Multi-dim profile, notifications, settings |
| Final | 27-30 | API reserved, error handling, loading states, testing |

---

## AI Development Process Analysis

### 1. Advantages of AI Agent-Driven Development

| Advantage | Description |
|-----------|-------------|
| **Clear Task Decomposition** | task.json splits large projects into 30 small tasks, each independently completable |
| **Trackable Progress** | progress.txt records each task's completion, easy for review |
| **Standardized Workflow** | Unified process: read task → implement → test → commit |
| **Reduced Cognitive Load** | Agent only needs to focus on one task at a time |
| **Automated Logging** | Each task auto-recorded, easy for auditing and handoff |

### 2. Small Steps Fast Strategy

```
Large project completed at once:
  ┌────────────────────────────────────────────┐
  │  Single commit with all code              │
  └────────────────────────────────────────────┘
          vs
  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
  │ Task 1  │→ │ Task 2  │→ │ Task 3  │→ │ Task N  │
  │ commit  │  │ commit  │  │ commit  │  │ commit  │
  └─────────┘  └─────────┘  └─────────┘  └─────────┘

Each commit contains: code + progress.txt + task.json update
```

- **High Code Quality**: Each task tested before commit
- **Low Rollback Risk**: Issues traceable to specific tasks
- **Friendly for Parallel Dev**: Multiple agents can work on different tasks (with coordination)
- **Easy Code Review**: Each commit has moderate change size

### 3. Feasibility Validation

| Metric | Result |
|--------|--------|
| Task Completion Rate | 30/30 (100%) |
| Code Standards | flutter analyze no errors |
| Build Verification | flutter build apk success |
| Architecture Integrity | Clean Architecture 4-layer clear |
| Feature Completeness | MVP all features implemented |

### 4. Potential Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Multi-Agent Coordination | Use task.json dependencies, execute in order |
| Context Loss | progress.txt records detailed context for each task |
| Test Coverage | Each task must pass flutter analyze + build verification |
| Environment Consistency | init.sh script ensures standardized environment |
| Code Style Consistency | architecture.md defines unified design patterns |

### 5. Applicable Scenarios

This development pattern is **MOST SUITABLE** for:
- ✅ Small-to-medium mobile app development (Flutter/React Native)
- ✅ Projects with clear task lists
- ✅ Scenarios needing rapid prototype validation
- ✅ Independent developers or small teams

This development pattern is **LESS SUITABLE** for:
- ❌ Super large projects (too many tasks, high coordination cost)
- ❌ Systems requiring complex integration tests
- ❌ Highly customized enterprise applications

---

## Quick Start

### Prerequisites

- Flutter SDK 3.x
- Android SDK
- Git

### Development Flow

```bash
# 1. Enter project directory
cd auto-coding-agent-flutter

# 2. Initialize environment (set Flutter SDK, Android SDK paths)
./init.sh

# 3. Install dependencies
cd hello-flutter
flutter pub get

# 4. Run code generation (Isar models)
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

### Build APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# Output location: build/app/outputs/flutter-apk/
```

---

## MinMax API Configuration

API is reserved with Mock implementation ready. Real integration steps:

1. Get MinMax API Key
2. Edit `lib/core/constants/api_constants.dart`:
   ```dart
   const kMinimaxApiKey = 'YOUR_API_KEY_HERE';
   ```
3. Implement real API calls in `lib/data/datasources/remote/minimax_api_client.dart`
4. Replace Mock returns with real API calls

---

## Project Files

| File/Directory | Description |
|----------------|-------------|
| `CLAUDE.md` | AI Agent working instructions (most important) |
| `task.json` | 30 development task definitions |
| `progress.txt` | Task progress log |
| `architecture.md` | Architecture design document |
| `init.sh` | Environment initialization script |
| `run-automation.sh` | Automation loop script |
| `hello-flutter/` | Flutter app main directory |

---

## Design Highlights

### 1. Morandi Color System
- Blue-green #7FA99B + Warm orange #E8A87C
- Warm, friendly visual style
- 8 goal colors for user selection

### 2. AI Task Confirmation Mechanism
- AI-generated tasks require user to answer reflection questions
- Three questions confirmed in sequence, reinforcing goal awareness
- User-created tasks complete directly without confirmation

### 3. Goal Completion Celebration Animation
- Triggers automatically when all related To-Dos are done
- Scale animation + green checkmark + congratulations message
- Enhances user sense of achievement

### 4. Drag to Change Date
- Day view: Long-press drag, bottom DropTarget
- Week view: Drag to week header for direct update
- Month view: Drag to date cell for direct update

---

## AI Development Process Characteristics Summary

### 1. Workflow Automation
- **Task-driven**: Every action based on task.json
- **Self-documenting**: progress.txt auto-generated
- **Quality gates**: Must pass analyze + build before commit

### 2. Scalability
- Tasks can be parallelized (limited by dependencies)
- Easy to add new tasks (append to task.json)
- Clear progress tracking

### 3. Maintainability
- Small commits = easy to trace issues
- Well-documented architecture
- Clear file structure

### 4. Reproducibility
- init.sh ensures consistent environment
- Same task always produces same result
- Easy to onboard new agents

### 5. Cost Efficiency
- Reduces manual coding time
- Fewer bugs due to standardized process
- Faster iteration cycles

---

## License

MIT License

---

*BenWo - Explore the Self, Achieve Goals*