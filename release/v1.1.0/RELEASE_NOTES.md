# BenWo 1.1.0 更新说明

## 重点更新
- 全局界面升级为浅米色毛玻璃风格，设置页、首页、目标、专注、日历等页面统一浅底深字，提升可读性。
- 新增专注页番茄计划能力：今日番茄任务支持拖动排序、保存计划、历史记录和右上角已保存番茄列表。
- 新增命名保存番茄列表：可保存当前番茄任务快照，后续可重命名、删除、追加到今天或替换今天未开始的任务。
- 新增全屏“番茄中”模式：开始番茄后进入大屏倒计时，支持暂停、继续、完成、退出全屏和放弃本轮。
- 全屏完成后新增两个选择：返回专注，或直接开始下一个番茄。
- AI 番茄计划改为流式预览体验：AI 返回结构化内容后，页面只展示转换后的计划，不显示原始 JSON。

## 修复
- 修复创建大目标时选择“自定义”分类并确认后出现 Flutter 红屏断言的问题。
- 修复专注页操作说明占用任务区域的问题，说明已移动到底部小字展示。
- 修复此前全局路由包装导致的 `_dependents.isEmpty` 断言风险。
- 避免 Android 覆盖安装时因 build number 降级失败。

## 本地与离线能力
- 今日 Todo 导入、日期判断、排除已完成 Todo、重复导入检测、番茄拆分、休息插入、倒计时、暂停/继续/跳过/完成、重启恢复、排序、冲突检测、统计和通知调度均保持本地运行。
- AI 仅用于自然语言排程、任务拆解、时间估算、动态调整和复盘总结等不确定性能力。

## 构建产物
- Android APK: `benwo-1.1.0-android-release.apk`
- Android App Bundle: `benwo-1.1.0-android-release.aab`
- Windows x64: `benwo-1.1.0-windows-x64.zip`

## 已知限制
- Web release 当前未发布：Isar 生成代码在 dart2js 编译时触发 JavaScript 大整数精度错误，同时 Wasm dry run 报告 `dart:ffi` 不兼容。
- iOS/macOS release 需要在 macOS/Xcode 环境中构建。
- Linux release 需要在 Linux 桌面构建环境中构建。

## 验证
- `dart run build_runner build --delete-conflicting-outputs`
- `flutter analyze`
- `flutter test`
- `flutter build apk --release --build-name=1.1.0 --build-number=2022`
- `flutter build appbundle --release --build-name=1.1.0 --build-number=2022`
- `flutter build windows --release --build-name=1.1.0 --build-number=2022`
