# Flutter Template

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter)](https://flutter.dev)

An open-source Flutter starter by [Roki AI](https://github.com/rokiai): **MVVM + Riverpod**, ready for production-style feature development.

Repository: <https://github.com/rokiai/flutter_template>

**Languages:** English · [中文](README.zh-CN.md)

## Overview

This template focuses on a **small, clear architecture** instead of stuffing every third-party SDK into one app. It ships three teaching demos:

1. Local state with Riverpod
2. Theme + localization
3. Remote API with Dio → Repository → ViewModel → UI

Use it to bootstrap your next Flutter app, then rename the package and grow features using the same MVVM layout.

## Features

| Area | What you get |
|------|----------------|
| **Counter demo** | Local `Notifier` state: increment / decrement / reset. Shows the simplest Riverpod path without a repository. |
| **API example** | Full vertical slice against JSONPlaceholder `GET /posts`: Freezed model → Repository (Dio) → Freezed state → ViewModel → Screen (loading / data / error). |
| **Appearance** | Light / Dark / System. Persisted with `shared_preferences`. |
| **Language** | English (`en`) and Vietnamese (`vi`) via Flutter `gen_l10n` (ARB). Persisted locally. |
| **Main shell** | Bottom floating tabs + `IndexedStack`: Counter · API · Settings. |
| **Splash** | Short splash then navigates to the main shell. |
| **Networking** | Shared `dioProvider`, Talker Dio logger, typed API exceptions. |
| **Flavors** | `dev` / `staging` / `prod` via `--dart-define=FLAVOR` (+ Android product flavors / iOS schemes). |
| **Environment** | `envied` reads `.env` → compile-time `Env.apiBaseUrl`, `Env.sentryDsn`. |
| **Monitoring** | Talker (overlay on non-prod) + optional Sentry (skipped when DSN is empty). |
| **Offline UX** | `connectivity_plus` banner via `OfflineContainer`. |
| **Common UI kit** | Buttons, text fields, dialogs, snackbars, empty/error/loading widgets, slide transitions. |
| **Analytics port** | `AnalyticsPort` + `NoopAnalytics` so you can plug a real SDK later without rewriting call sites. |
| **Multi-platform** | Android, iOS, macOS, Web, Linux, Windows project folders included. |

## Architecture

The project uses **feature-first folders** and **MVVM inside each feature**.

```
┌─────────────┐     watch/read      ┌──────────────┐
│     UI      │ ──────────────────► │  ViewModel   │
│  (Screen)   │ ◄────────────────── │  (Notifier)  │
└─────────────┘      State          └──────┬───────┘
                                           │ calls
                                           ▼
                                    ┌──────────────┐
                                    │ Repository   │
                                    └──────┬───────┘
                                           │ Dio / local
                                           ▼
                                    ┌──────────────┐
                                    │ Model / API  │
                                    └──────────────┘
```

| Layer | Responsibility |
|-------|----------------|
| **UI** | Widgets only: render state, dispatch intents (`ref.read` / `ref.watch`). |
| **State** | Immutable UI state (Freezed where useful, or a simple type like `int`). |
| **ViewModel** | Riverpod `Notifier` / `@Riverpod`: orchestrates loading, errors, repository calls. |
| **Repository** | Data access (HTTP today). Injected via Riverpod providers. |
| **Model** | Domain / DTO models (`freezed` + `json_serializable`). |
| **common** | Cross-cutting Dio, theme/locale providers, monitoring, shared widgets. |

**Canonical feature layout** (follow `api_example`):

```
lib/features/<feature_name>/
├── model/
├── repository/
└── ui/
    ├── *_screen.dart
    ├── state/
    ├── view_model/
    └── widgets/
```

**App bootstrap**

1. `main()` → optional `initSentry`
2. `ProviderScope` + `AppObserver` (Talker-friendly provider logs)
3. `MaterialApp.router` with theme mode, locale, GoRouter
4. Global shell: Talker overlay (non-prod) + offline container

**Routing** (`go_router` + `go_router_builder`, type-safe routes):

| Path | Screen |
|------|--------|
| `/` | Splash → Main |
| `/main` | Counter / API / Settings shell |
| `/appearances` | Appearance settings |
| `/languages` | Language settings |

## Walkthrough: Counter (MVVM in the smallest form)

The **Counter** tab is the teaching demo for MVVM with **local state only** — no Repository, no HTTP. It shows the same separation of concerns you will later scale up in `api_example`.

```
lib/features/counter/
└── ui/
    ├── counter_screen.dart          # View
    └── view_model/
        └── counter_provider.dart    # ViewModel + State (int)
```

**How the layers map**

| MVVM role | In this demo | Responsibility |
|-----------|--------------|----------------|
| **Model / State** | `int` held by the Notifier | The single piece of data the UI displays (`0`, `1`, `2`…). |
| **ViewModel** | `Counter extends Notifier<int>` + `counterProvider` | Owns the state; exposes intents (`increment` / `decrement` / `reset`). UI never mutates `count` directly. |
| **View** | `CounterScreen` (`ConsumerWidget`) | `ref.watch` to rebuild when state changes; `ref.read(...notifier)` to send user actions. No business rules in the widget tree. |
| **Repository** | _(none)_ | Counter is in-memory. When you need remote/local persistence, add a Repository and call it **from the ViewModel** — same pattern as `api_example`. |

**ViewModel** — owns state and intents:

```dart
// lib/features/counter/ui/view_model/counter_provider.dart
class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

final counterProvider = NotifierProvider<Counter, int>(Counter.new);
```

**View** — bind UI to ViewModel only:

```dart
// lib/features/counter/ui/counter_screen.dart (excerpt)
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider); // observe State

    return Column(
      children: [
        Text('$count'),
        PrimaryButton(
          text: context.l10n.counterIncrement,
          // send Intent → ViewModel; do not do state++ here
          onPressed: () => ref.read(counterProvider.notifier).increment(),
        ),
        // decrement / reset similarly...
      ],
    );
  }
}
```

**Why this is MVVM (even without a Repository)**

1. **View is passive** — it does not decide what the next count is; it only renders and forwards events.
2. **ViewModel is the single writer of state** — all rules live in `Counter` (`increment` / `decrement` / `reset`).
3. **Testable** — you can unit-test `Counter` without pumping widgets.
4. **Same shape as networked features** — later, `PostsViewModel` keeps the same View ↔ ViewModel contract and simply delegates IO to `PostsRepository`.

```
User tap ──► View (CounterScreen)
                │  ref.read(counterProvider.notifier).increment()
                ▼
           ViewModel (Counter)
                │  state++
                ▼
             State (int)
                │  ref.watch rebuilds
                ▼
               View
```

## Tech stack

| Category | Libraries |
|----------|-----------|
| State / DI | `flutter_riverpod` 3 + `riverpod_annotation` / codegen |
| Routing | `go_router` + `go_router_builder` |
| Networking | `dio` + `talker_dio_logger` |
| Models | `freezed` + `json_serializable` |
| Environment | `envied` + Flavor (`FLAVOR`) |
| Persistence | `shared_preferences` |
| i18n | Flutter `gen_l10n` (ARB) |
| Monitoring | Talker, optional Sentry |
| Connectivity | `connectivity_plus` |
| UI | Material 3, Nunito (`google_fonts`), Hugeicons, Lottie, SVG |
| Tooling | `build_runner`, `flutter_lints`, `change_app_package_name` |

**Code generation** (outputs are gitignored — run after clone):

```bash
dart run build_runner build   # freezed / json / riverpod / go_router / envied
flutter gen-l10n              # AppLocalizations from ARB
```

## Project structure

```
lib/
├── main.dart
├── constants/          # Keys, asset path helpers
├── environment/        # Envied Env + Flavor
├── extensions/         # BuildContext, l10n, string, datetime…
├── features/
│   ├── common/         # Dio, providers, monitoring, shared widgets
│   ├── counter/        # Local-state demo
│   ├── api_example/    # Full MVVM network demo
│   ├── profile/        # Appearance + language
│   ├── main/           # Tab shell
│   └── onboarding/     # Splash
├── l10n/               # ARB + generated localizations
├── routing/            # GoRouter + transitions
├── theme/              # AppTheme / AppColors
└── utils/              # Talker, loading helper, provider observer
```

## Getting started

```bash
git clone git@github.com:rokiai/flutter_template.git
cd flutter_template

flutter pub get
cp .env.example .env          # or: ./tool/use_env.sh dev
dart run build_runner build
flutter gen-l10n

# Prefer matching Android/iOS product flavor:
flutter run --flavor dev --dart-define=FLAVOR=dev
```

Default `API_BASE_URL`: `https://jsonplaceholder.typicode.com`

| Flavor | Talker overlay | Android applicationId suffix |
|--------|----------------|------------------------------|
| `dev` | Yes | `.dev` |
| `staging` | Yes | `.staging` |
| `prod` | No | _(none)_ |

VS Code / Cursor launch configs for all three flavors live in `.vscode/launch.json`.

## Package identifiers

| Target | Value |
|--------|-------|
| Dart (`pubspec.yaml`) | `flutter_template` |
| Android `applicationId` | `com.rokiai.flutter_template` |
| iOS / macOS Bundle ID | `com.rokiai.flutter_template` |

When starting a real product from this scaffold, rename the application id with [`change_app_package_name`](https://pub.dev/packages/change_app_package_name).

## Adding a new feature

1. Copy the shape of `api_example` (or `counter` for local-only state).
2. Implement `model` → `repository` → `ui/state` + `view_model` → screen.
3. Register routes in `lib/routing/app_router.dart` and wire navigation from `main` / settings as needed.
4. Add ARB strings and regenerate localizations.
5. Run `dart run build_runner build` after Freezed / Riverpod / router / Env changes.

## Conventions (short)

- Use `AppTheme.*` text styles; colors via `BuildContext` extensions.
- Spacing / padding in multiples of **8**.
- Prefer small, focused widgets and `const` constructors.
- Keep feature boundaries clean — put shared code in `features/common`.

## License

[MIT](LICENSE) © 2026 Roki AI
