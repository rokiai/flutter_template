# Flutter Template

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.29%2B-02569B?logo=flutter)](https://flutter.dev)

由 [Roki AI](https://github.com/rokiai) 维护的开源 Flutter 脚手架：**MVVM + Riverpod**，开箱即用、便于二次开发。

仓库地址：<https://github.com/rokiai/flutter_template>

## 包含内容

1. **计数 Demo** — Riverpod 本地状态
2. **主题色 / 多语言** — Appearance（浅/深/跟随系统）+ Language（en / vi）
3. **接口请求示例** — Dio + Repository + ViewModel，请求 JSONPlaceholder `/posts`

## 技术栈

| 类别 | 库 |
|------|-----|
| 状态 | `flutter_riverpod` 3 + codegen |
| 路由 | `go_router` + `go_router_builder` |
| 网络 | `dio` + `talker_dio_logger` |
| 主题 / 本地 | `shared_preferences` |
| i18n | gen_l10n（ARB） |
| 环境 | `envied` + Flavor |
| 监控 | Talker；Sentry 可选（DSN 空则跳过） |

## 结构

```
lib/features/
├── counter/        # 计数 demo
├── api_example/    # Dio 请求示例
├── profile/        # 设置：外观 + 语言
├── main/           # 底部 Tab
├── onboarding/     # Splash → Main
└── common/         # Dio、主题/语言 Provider、通用组件
```

## 开始

```bash
git clone git@github.com:rokiai/flutter_template.git
cd flutter_template

flutter pub get
cp .env.example .env   # 或按 tool/use_env.sh 维护各 flavor
dart run build_runner build
flutter gen-l10n
flutter run --dart-define=FLAVOR=dev
```

`API_BASE_URL` 默认：`https://jsonplaceholder.typicode.com`

### 包名

| 用途 | 值 |
|------|-----|
| Dart (`pubspec.yaml`) | `flutter_template` |
| Android `applicationId` | `com.rokiai.flutter_template` |
| iOS / macOS Bundle ID | `com.rokiai.flutter_template` |

从脚手架新建业务时，建议用 [`change_app_package_name`](https://pub.dev/packages/change_app_package_name) 改成你自己的包名。

## 新增业务 Feature

参考 `api_example`：`model` → `repository` → `ui/state` + `view_model` → `screen`，再挂到 `main` / `routing`。

## License

[MIT](LICENSE) © 2026 Roki AI
