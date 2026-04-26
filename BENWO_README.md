# BenWo (本我) - AI 驱动的自我探索与目标达成应用

[English](./README.md) | 中文

---

## 项目简介

**BenWo（本我）** 是一款 AI 驱动的自我探索与目标达成应用。通过 4 步引导式 Onboarding 帮助用户完成自我认知，设定大目标，并将目标智能拆解为每日 To-Do。

### 核心理念

- **探索本我**：通过结构化的引导式流程，帮助用户深度认知自己
- **目标驱动**：将宏大的目标分解为可执行的小任务
- **AI 赋能**：利用 AI 智能拆解目标、生成任务、激励用户
- **小步快跑**：每次只做一个任务，测试通过后提交，确保代码干净可合并

---

## 功能特性

### 核心功能

| 功能 | 说明 |
|-----|------|
| 邮箱登录/注册 | 简洁的邮箱+密码认证，密码 SHA256 加密 |
| 4 步 Onboarding | AI 引导式自我探索（我是谁→我的现状→我想要什么→AI 确认） |
| 用户画像 | MBTI、沟通偏好、工作时间、压力反应等多维度 |
| 大目标创建 | 用户设定目标、分类、目标时间，可选颜色标记 |
| AI 目标拆解 | AI 将大目标拆解为每日 To-Do（基于目标分类生成模板） |
| 今日 To-Do | AI 生成 + 用户自建，AI任务需确认完成（反思三问） |
| 日历视图 | 日/周/月三种视图，拖拽改日期，长按拖拽 |
| 目标完成动画 | 检测所有 To-Do 完成时自动标记目标完成 + 庆祝动画 |
| 本地推送 | flutter_local_notifications 预留，AI 智能调度提醒 |
| 设置页 | 推送开关、频率设置、用户画像查看、登出 |

### 暂不包含

- ❌ AI 对话功能（预留 MinMax API）
- ❌ 深色模式
- ❌ 云端同步
- ❌ 社区功能

---

## 技术栈

| 层级 | 技术选型 |
|-----|---------|
| 框架 | Flutter 3.x + Dart |
| 状态管理 | flutter_riverpod + riverpod_annotation |
| 路由 | go_router |
| 网络 | dio |
| 本地存储 | isar + shared_preferences |
| 依赖注入 | Riverpod Provider + InjectionContainer |
| 推送通知 | flutter_local_notifications |
| AI 服务 | MinMax API (预留，Mock 实现) |
| 国际化 | flutter_localizations + intl |
| 图标 | tabler_icons + cupertino_icons |
| 表单验证 | crypto (SHA256) |

---

## 架构设计

### Clean Architecture 分层

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

### 项目目录结构

```
hello-flutter/
├── lib/
│   ├── main.dart                     # 应用入口，Isar + Riverpod 初始化
│   ├── app.dart                      # 应用根组件，MaterialApp.router
│   │
│   ├── core/                         # 核心层
│   │   ├── constants/                # 常量定义
│   │   │   ├── app_constants.dart    # MBTI类型、挑战列表、时间框架等
│   │   │   └── api_constants.dart    # MinMax API 配置
│   │   ├── di/                       # 依赖注入
│   │   │   └── injection.dart         # InjectionContainer
│   │   ├── error/                    # 错误处理
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── theme/                    # 主题配置
│   │   │   ├── app_colors.dart       # 莫兰迪配色 (#7FA99B + #E8A87C)
│   │   │   └── app_theme.dart         # Material 3 主题
│   │   └── utils/                    # 工具类
│   │       └── auth_utils.dart        # SHA256 密码哈希
│   │
│   ├── data/                         # 数据层
│   │   ├── datasources/
│   │   │   └── local/
│   │   │       └── isar_database.dart # Isar 数据库 + 5个 Repository 实现
│   │   ├── models/                   # Isar Collections
│   │   │   ├── user_model.dart
│   │   │   ├── user_profile_model.dart
│   │   │   ├── big_goal_model.dart
│   │   │   ├── todo_item_model.dart
│   │   │   └── user_settings_model.dart
│   │   └── repositories/             # Repository 接口
│   │
│   ├── application/                  # 应用层 (Riverpod Notifiers)
│   │   ├── auth/
│   │   │   └── auth_notifier.dart    # 认证状态管理
│   │   ├── goal/
│   │   │   ├── goal_completion_notifier.dart
│   │   │   └── goal_split_notifier.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_controller.dart
│   │   └── profile/
│   │       └── profile_notifier.dart
│   │
│   ├── presentation/                # 表现层
│   │   ├── pages/
│   │   │   ├── auth/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   ├── onboarding/
│   │   │   │   └── onboarding_page.dart (4步)
│   │   │   ├── home/
│   │   │   │   └── home_page.dart
│   │   │   ├── goals/
│   │   │   │   ├── goals_list_page.dart
│   │   │   │   ├── goal_detail_page.dart
│   │   │   │   └── create_goal_page.dart
│   │   │   ├── calendar/
│   │   │   │   ├── calendar_page.dart (日/周/月三视图)
│   │   │   │   └── _completed_history_sheet.dart
│   │   │   ├── profile/
│   │   │   │   └── profile_page.dart
│   │   │   ├── settings/
│   │   │   │   └── settings_page.dart
│   │   │   ├── error_page.dart
│   │   │   └── not_found_page.dart
│   │   └── widgets/                 # 通用组件
│   │       ├── gradient_background.dart
│   │       ├── loading_indicator.dart
│   │       └── skeleton_loader.dart
│   │
│   ├── shared/                      # 共享 widgets
│   │   └── widgets/
│   │
│   ├── routes/                      # 路由配置
│   │   ├── app_router.dart          # GoRouter 配置
│   │   └── auth_guard.dart           # 路由守卫
│   │
│   └── l10n/                        # 国际化资源
│       ├── app_localizations.dart
│       ├── app_en.arb
│       └── app_zh.arb
│
├── test/                           # 测试目录
├── pubspec.yaml
├── analysis_options.yaml
└── android/                        # Android 配置
```

---

## AI 全流程开发模式分析

### Auto-Coding Agent 工作流程

本项目采用 **AI Auto-Coding Agent** 模式开发，整个开发流程高度自动化：

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI 开发循环流程                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   task.json (30个任务)                                           │
│         │                                                       │
│         ▼                                                       │
│   ┌─────────────────┐                                           │
│   │  读取任务       │ ◄─────────────────────┐                   │
│   └────────┬────────┘                      │                    │
│            │                               │                    │
│            ▼                               │                    │
│   ┌─────────────────┐     否             │                    │
│   │  环境初始化      │────进入下一步──────┘                    │
│   │  (init.sh)      │                                         │
│   └────────┬────────┘                                         │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐                                          │
│   │  编写代码       │                                          │
│   │  (AI Agent)     │                                          │
│   └────────┬────────┘                                          │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐                                          │
│   │  测试验证        │                                          │
│   │  flutter analyze │                                         │
│   │  flutter build   │                                          │
│   └────────┬────────┘                                          │
│            │                                                   │
│            ▼                                                   │
│   ┌─────────────────┐     是            ┌─────────────────┐   │
│   │  所有测试通过?   │─────── ✓ ────────→ │  更新 progress   │   │
│   └────────┬────────┘                  └────────┬────────┘   │
│            │ 否                                │              │
│            ▼                                   ▼              │
│   ┌─────────────────┐                 ┌─────────────────┐     │
│   │  修复问题        │                 │  git commit     │     │
│   └────────┬────────┘                 └────────┬────────┘     │
│            │                               │                    │
│            └───────────────────────────────┘                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### task.json 任务结构

```json
{
  "id": 1,                    // 任务ID
  "title": "项目基础配置",    // 任务标题
  "category": "infrastructure", // 类别：infrastructure/ui/business
  "description": "...",      // 任务描述
  "steps": ["步骤1", "步骤2"], // 具体实现步骤
  "passes": true              // 完成状态
}
```

### 30 个任务分类执行

| 阶段 | 任务ID | 说明 |
|------|--------|------|
| 基础设施 | 1-5 | 项目配置、路由、DI、数据模型、数据库 |
| 认证 | 6-8 | 登录、注册、状态管理 |
| Onboarding | 9-12 | 4步引导式界面 |
| 首页/To-Do | 13-15 | 今日任务、添加、编辑 |
| 大目标 | 16-19 | 创建、列表、详情、AI拆解、完成动画 |
| 日历 | 20-23 | 日/周/月视图、拖拽、历史记录 |
| 用户画像/推送 | 24-26 | 多维度画像、推送通知、设置页 |
| 收尾 | 27-30 | API预留、错误处理、Loading状态、测试 |

---

## 开发流程特点与可行性分析

### 1. AI Agent 驱动开发的优势

| 优势 | 说明 |
|------|------|
| **任务分解明确** | task.json 将大型项目分解为30个小任务，每个任务可独立完成 |
| **进度可追踪** | progress.txt 记录每个任务的完成情况，方便回顾 |
| **标准化流程** | 统一的工作流程：读任务→实现→测试→提交 |
| **降低认知负荷** | Agent 每次只需关注一个任务，不需要理解全局 |
| **自动化日志** | 每个任务完成后自动记录，便于审计和接手 |

### 2. 小步快跑策略的优势

```
一次性完成大型项目:
  ┌────────────────────────────────────────────┐
  │  一次性提交所有代码                          │
  └────────────────────────────────────────────┘
          vs
  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
  │ Task 1  │→ │ Task 2  │→ │ Task 3  │→ │ Task N  │
  │ commit  │  │ commit  │  │ commit  │  │ commit  │
  └─────────┘  └─────────┘  └─────────┘  └─────────┘

每个 commit 包含: 代码 + progress.txt + task.json 更新
```

- **代码质量高**：每个任务独立测试通过后才提交
- **回滚风险小**：问题可定位到具体任务
- **并行开发友好**：多个 Agent 可同时处理不同任务（需协调）
- **易于 Code Review**：每次 commit 改动量适中

### 3. 可行性验证

| 指标 | 结果 |
|------|------|
| 任务完成率 | 30/30 (100%) |
| 代码规范 | flutter analyze 无 error |
| 构建验证 | flutter build apk 成功 |
| 架构完整性 | Clean Architecture 4层清晰 |
| 功能完整性 | MVP 所有功能已实现 |

### 4. 潜在挑战与解决方案

| 挑战 | 解决方案 |
|------|---------|
| 多 Agent 协调 | 使用 task.json 的依赖关系，按顺序执行 |
| 上下文丢失 | progress.txt 详细记录每个任务的上下文 |
| 测试覆盖 | 每个任务必须通过 flutter analyze + build 验证 |
| 环境一致性 | init.sh 脚本确保环境标准化 |
| 代码风格一致 | architecture.md 定义了统一的设计模式 |

### 5. 适用场景

本开发模式**最适合**：
- ✅ 中小型移动应用开发（Flutter/React Native）
- ✅ 有明确任务列表的项目
- ✅ 需要快速原型验证的场景
- ✅ 独立开发者或小团队

本开发模式**不太适合**：
- ❌ 超大型项目（任务过多，协调成本高）
- ❌ 需要复杂集成测试的系统
- ❌ 高度定制化的企业级应用

---

## 快速开始

### 前提条件

- Flutter SDK 3.x
- Android SDK
- Git

### 开发流程

```bash
# 1. 进入项目目录
cd auto-coding-agent-flutter

# 2. 初始化环境（设置 Flutter SDK、Android SDK 路径）
./init.sh

# 3. 安装依赖
cd hello-flutter
flutter pub get

# 4. 运行代码生成（Isar 模型）
flutter pub run build_runner build --delete-conflicting-outputs

# 5. 运行应用
flutter run
```

### 构建 APK

```bash
# Debug 构建
flutter build apk --debug

# Release 构建
flutter build apk --release

# 输出位置: build/app/outputs/flutter-apk/
```

---

## MinMax API 配置

API 已预留，Mock 实现已就绪。真实接入步骤：

1. 获取 MinMax API Key
2. 编辑 `lib/core/constants/api_constants.dart`：
   ```dart
   const kMinimaxApiKey = 'YOUR_API_KEY_HERE';
   ```
3. 实现 `lib/data/datasources/remote/minimax_api_client.dart` 中的真实调用
4. 将 Mock 返回替换为真实 API 调用

---

## 项目结构与文件说明

| 文件/目录 | 说明 |
|-----------|------|
| `CLAUDE.md` | AI Agent 工作指令（最重要） |
| `task.json` | 30 个开发任务定义 |
| `progress.txt` | 任务进度日志 |
| `architecture.md` | 架构设计文档 |
| `init.sh` | 环境初始化脚本 |
| `run-automation.sh` | 自动化循环脚本 |
| `hello-flutter/` | Flutter 应用主目录 |

---

## 设计亮点

### 1. 莫兰迪配色系统
- 蓝绿 #7FA99B + 暖橙 #E8A87C
- 温和、友好的视觉风格
- 8 种目标颜色供用户选择

### 2. AI 生成任务确认机制
- AI 生成的任务需要用户回答反思问题
- 三个问题依次确认，强化目标意识
- 用户自建任务直接完成，无需确认

### 3. 目标完成庆祝动画
- 当所有关联 To-Do 完成时自动触发
- 缩放动画 + 绿色对勾 + 恭喜提示
- 增强用户成就感

### 4. 拖拽改日期
- 日视图：长按拖拽，底部 DropTarget
- 周视图：拖到星期 header 直接更新
- 月视图：拖到日期格子直接更新

---

## License

MIT License

---

*BenWo - 探索本我，达成目标*