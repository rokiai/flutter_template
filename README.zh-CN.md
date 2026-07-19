# Flutter Template

基于 **MVVM + Riverpod** 的 Flutter 脚手架，便于按生产项目方式扩展业务功能。

**语言：** [English](README.md) · 中文

## 概述

本模板强调 **可维护的 MVVM + Riverpod 结构**，而不是堆叠大量无关 SDK。内置三个示范能力：

1. Riverpod 本地状态
2. 主题 + 多语言
3. Dio 网络请求的完整分层（Repository → ViewModel → UI）

适合作为新产品起点：先改包名，再按同一 Feature / MVVM 约定扩展业务。

## 功能一览

| 能力 | 说明 |
|------|------|
| **计数 Demo** | 本地 `Notifier`：加 / 减 / 重置，展示无 Repository 的最小闭环。 |
| **接口示例** | 请求 JSONPlaceholder `GET /posts` 的完整竖切：Freezed Model → Repository（Dio）→ Freezed State → ViewModel → Screen（加载 / 数据 / 错误）。 |
| **外观设置** | 浅色 / 深色 / 跟随系统，经 `shared_preferences` 持久化。 |
| **多语言** | `en` / `vi`，Flutter `gen_l10n`（ARB），本地持久化。 |
| **主框架** | 底部浮动 Tab + `IndexedStack`：计数 · 接口 · 设置。 |
| **启动页** | 短 Splash 后进入主 Tab。 |
| **网络层** | 共享 `dioProvider`、Talker Dio 日志、统一 API 异常类型。 |
| **多环境** | `dev` / `staging` / `prod`（`--dart-define=FLAVOR`，配合 Android productFlavors / iOS Scheme）。 |
| **环境变量** | `envied` 读取 `.env`，编译期注入 `Env.apiBaseUrl`、`Env.sentryDsn`。 |
| **监控** | Talker（非生产展示浮层）+ 可选 Sentry（DSN 为空则跳过）。 |
| **离线提示** | `connectivity_plus` + `OfflineContainer` 顶栏提示。 |
| **通用组件** | 按钮、输入框、对话框、Snackbar、空态/错误/加载、页面滑入转场等。 |
| **埋点接口** | `AnalyticsPort` + `NoopAnalytics`，后续可替换真实 SDK 且无需改调用方。 |
| **多端工程** | 含 Android / iOS / macOS / Web / Linux / Windows 目录。 |

## 架构说明

采用 **按 Feature 垂直拆分 + Feature 内 MVVM**：

```
┌─────────────┐     watch/read      ┌──────────────┐
│     UI      │ ──────────────────► │  ViewModel   │
│  (Screen)   │ ◄────────────────── │  (Notifier)  │
└─────────────┘      State          └──────┬───────┘
                                           │ 调用
                                           ▼
                                    ┌──────────────┐
                                    │ Repository   │
                                    └──────┬───────┘
                                           │ Dio / 本地
                                           ▼
                                    ┌──────────────┐
                                    │ Model / API  │
                                    └──────────────┘
```

| 层级 | 职责 |
|------|------|
| **UI** | 只负责展示与交互：`ref.watch` / `ref.read`。 |
| **State** | 不可变界面状态（常用 Freezed，或简单类型如 `int`）。 |
| **ViewModel** | Riverpod `Notifier` / `@Riverpod`：编排加载态、错误与仓储调用。 |
| **Repository** | 数据访问（当前为 HTTP），通过 Riverpod 注入。 |
| **Model** | 领域 / DTO 模型（`freezed` + `json_serializable`）。 |
| **common** | 跨 Feature 的 Dio、主题/语言、监控、通用组件。 |

**标准 Feature 目录**（以 `api_example` 为范本）：

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

**启动流程**

1. `main()` → 可选 `initSentry`
2. `ProviderScope` + `AppObserver`
3. `MaterialApp.router`（主题模式、语言、GoRouter）
4. 全局壳：Talker 浮层（非生产）+ 离线容器

**路由**（`go_router` + `go_router_builder`，类型安全）：

| Path | 页面 |
|------|------|
| `/` | Splash → Main |
| `/main` | 计数 / 接口 / 设置 |
| `/appearances` | 外观设置 |
| `/languages` | 语言设置 |

## 实战解析：Counter（最小可运行的 MVVM）

**Counter（计数）** 页是本地状态的教学示例：**没有 Repository、没有网络**，专门突出 View / ViewModel / State 的边界。需要远程数据时，按同一套契约扩展即可（见 `api_example`）。

```
lib/features/counter/
└── ui/
    ├── counter_screen.dart          # View（视图）
    └── view_model/
        └── counter_provider.dart    # ViewModel + State（这里用 int）
```

**角色对照**

| MVVM 角色 | 本 Demo 中的落地 | 职责 |
|-----------|------------------|------|
| **Model / State** | `Notifier` 持有的 `int` | UI 唯一展示的数据（`0`、`1`、`2`…）。 |
| **ViewModel** | `Counter extends Notifier<int>` + `counterProvider` | 独占状态；对外只暴露意图方法（`increment` / `decrement` / `reset`）。UI **禁止** 直接改 `count`。 |
| **View** | `CounterScreen`（`ConsumerWidget`） | `ref.watch` 订阅状态；`ref.read(...notifier)` 转发用户操作。Widget 树里不写业务规则。 |
| **Repository** | _(无)_ | 计数只在内存。若要持久化或请求接口，应新增 Repository，并由 **ViewModel 调用**——与 `api_example` 一致。 |

**ViewModel** — 持有状态与意图：

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

**View** — 只绑定 ViewModel：

```dart
// lib/features/counter/ui/counter_screen.dart（摘录）
class CounterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider); // 观察 State

    return Column(
      children: [
        Text('$count'),
        PrimaryButton(
          text: context.l10n.counterIncrement,
          // 发 Intent → ViewModel；不要在这里写 state++
          onPressed: () => ref.read(counterProvider.notifier).increment(),
        ),
        // decrement / reset 同理…
      ],
    );
  }
}
```

**为什么这仍是 MVVM（即便没有 Repository）**

1. **View 是被动的** — 不决定下一个计数值，只负责展示与转发事件。
2. **ViewModel 是状态的唯一写入方** — 加/减/重置规则全在 `Counter` 里。
3. **易测** — 可对 `Counter` 做单元测试，无需 `pumpWidget`。
4. **与网络 Feature 同构** — `PostsViewModel` 保持相同的 View ↔ ViewModel 契约，只是把 IO 委托给 `PostsRepository`。

```
用户点击 ──► View（CounterScreen）
                │  ref.read(counterProvider.notifier).increment()
                ▼
           ViewModel（Counter）
                │  state++
                ▼
             State（int）
                │  ref.watch 触发重建
                ▼
               View
```

## 技术栈

| 类别 | 库 |
|------|-----|
| 状态 / DI | `flutter_riverpod` 3 + codegen |
| 路由 | `go_router` + `go_router_builder` |
| 网络 | `dio` + `talker_dio_logger` |
| 模型 | `freezed` + `json_serializable` |
| 环境 | `envied` + Flavor（`FLAVOR`） |
| 持久化 | `shared_preferences` |
| 国际化 | Flutter `gen_l10n`（ARB） |
| 监控 | Talker；Sentry 可选 |
| 连通性 | `connectivity_plus` |
| UI | Material 3、Nunito、Hugeicons、Lottie、SVG |
| 工具 | `build_runner`、`flutter_lints`、`change_app_package_name` |

**代码生成**（生成文件已忽略，克隆后需本地执行）：

```bash
dart run build_runner build   # freezed / json / riverpod / go_router / envied
flutter gen-l10n              # ARB → AppLocalizations
```

## 目录结构

```
lib/
├── main.dart
├── constants/          # 常量、资源路径
├── environment/        # Envied Env + Flavor
├── extensions/         # BuildContext、l10n、字符串等扩展
├── features/
│   ├── common/         # Dio、Provider、监控、通用组件
│   ├── counter/        # 本地状态 Demo
│   ├── api_example/    # 完整 MVVM 网络 Demo
│   ├── profile/        # 外观 + 语言
│   ├── main/           # Tab 主壳
│   └── onboarding/     # Splash
├── l10n/               # ARB 与本地化生成物
├── routing/            # GoRouter 与转场
├── theme/              # AppTheme / AppColors
└── utils/              # Talker、Loading、Provider Observer
```

## 快速开始

```bash
git clone git@github.com:rokiai/flutter_template.git
cd flutter_template

flutter pub get
cp .env.example .env          # 或: ./tool/use_env.sh dev
dart run build_runner build
flutter gen-l10n

# Android / iOS 建议同时带上对应 flavor：
flutter run --flavor dev --dart-define=FLAVOR=dev
```

`API_BASE_URL` 默认：`https://jsonplaceholder.typicode.com`

| Flavor | Talker 浮层 | Android applicationId 后缀 |
|--------|-------------|----------------------------|
| `dev` | 有 | `.dev` |
| `staging` | 有 | `.staging` |
| `prod` | 无 | 无 |

三环境启动配置见 `.vscode/launch.json`。

## 包名

| 用途 | 值 |
|------|-----|
| Dart（`pubspec.yaml`） | `flutter_template` |
| Android `applicationId` | `com.rokiai.flutter_template` |
| iOS / macOS Bundle ID | `com.rokiai.flutter_template` |

基于脚手架创建正式产品时，建议用 [`change_app_package_name`](https://pub.dev/packages/change_app_package_name) 改成自己的包名。

## 新增业务 Feature

1. 参考 `api_example`（纯本地状态可参考 `counter`）。
2. 按 `model` → `repository` → `ui/state` + `view_model` → `screen` 实现。
3. 在 `lib/routing/app_router.dart` 注册路由，并挂到 `main` / 设置入口。
4. 补充 ARB 文案并重新生成本地化。
5. 改动 Freezed / Riverpod / 路由 / Env 后执行 `dart run build_runner build`。

## 约定（摘要）

- 文本样式用 `AppTheme.*`；颜色优先走 `BuildContext` 扩展。
- Padding / 间距使用 **8 的倍数**。
- Widget 保持小而专注，尽量 `const`。
- 跨 Feature 能力放进 `features/common`，避免互相直接耦合。

## 许可

[MIT](LICENSE) © 2026 Roki AI
