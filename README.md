# BenWo（本我）

本地优先的 AI 目标、任务与番茄专注应用。应用采用无账户的单用户模式，用 DeepSeek 将长期目标、自然语言待办或番茄计划拆成可执行任务。

## 1.1.0 重要升级说明

从旧版本首次升级时，应用会一次性且不可恢复地清空旧账号、目标、待办、画像、设置与遗留通知，然后以新的单用户 Schema 启动。重置只执行一次。详见 [1.1.0 发布说明](docs/RELEASE_NOTES_1.1.0.md)。

首次启动会显示一页精简画像引导。沟通风格、最佳工作时间和任务节奏均为可选项，也可以完全跳过并直接进入首页；之后可随时在“设置 → AI 个性化”中编辑或清空。

## 核心功能

- 目标：创建长期目标，管理分类、颜色、截止时间、进度与关联任务。
- AI 拆解：将目标或一段自然语言拆成待办，理解日期与精确时间。
- 今日待办：手动或通过 AI 新增、编辑、完成和关联目标。
- 番茄专注：从旧版恢复每日计划、计时、暂停续跑、休息、统计、历史记录与保存清单。
- 日历：日、周、月视图，支持调整任务日期并保留精确时间。
- 通知：为带精确时间的未完成待办安排本地提醒。
- 个性化：只保留沟通风格、最佳工作时间、任务节奏三项可选偏好。
- 外观：跟随系统、亮色、暗色三档主题；采用米色瓷面、金铜强调、锤子式分组组件与局部液态玻璃。

## 数据与隐私

- 应用不创建账户，也不提供云同步；目标、待办、画像与设置存储在本机 Isar 和 SharedPreferences 中。
- 主动使用 AI 目标拆解时，目标文本和已填写的三项画像偏好会发送到 DeepSeek API；主动使用番茄 AI 规划时，只发送当次输入的计划描述。
- 画像为空时不会向 Prompt 附加画像段落，也不会虚构默认偏好。
- 卸载应用或清除应用数据会使本地记录丢失。

## 技术栈

| 分类 | 技术 |
| --- | --- |
| UI | Flutter / Material 3 |
| 状态管理 | Riverpod |
| 路由 | GoRouter |
| 本地数据库 | Isar |
| 网络 | Dio / DeepSeek Chat Completions |
| 通知 | flutter_local_notifications |

主要目录：

```text
lib/
├── application/   # 目标拆解、画像、引导、主题状态
├── core/          # 启动重置、依赖注入、主题、通知
├── data/          # Isar 模型与单用户 Repository
├── presentation/  # 页面与锤子式组件
└── routes/        # 无认证路由
```

## 本地运行

1. 在 `lib/core/constants/api_constants.dart` 中配置 DeepSeek API Key。
2. 安装依赖并生成 Isar 代码：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

3. 验证并运行：

```bash
dart format --set-exit-if-changed lib test
flutter analyze --no-fatal-infos
flutter test
flutter run
```
