# ClipNote

**本地剪贴板管理 + 极简笔记 Android 应用**

> 🔐 100% Local-first · No account · No tracking · No cloud

---

## ✨ 功能特性

### 📋 剪贴板管理
- 自动保存复制的文本（应用打开时实时监听，切回应用时自动捕获）
- 自动识别文本 / URL 类型并标记
- 自动去重（相同内容移至顶部，不重复存储）
- 支持置顶（Pin）、一键复制、删除
- 关键词搜索历史
- 导出为 JSON / TXT
- 长按或菜单操作：复制、置顶、保存为笔记、删除

### 📝 笔记
- 支持 Markdown 编辑与预览
- 自动保存（输入停止 2 秒后自动保存）
- 置顶、搜索、分享
- 导出为 JSON / Markdown / TXT
- 显示字数、最后编辑时间

### ⚙️ 设置
- **多语言**：简体中文 / 繁体中文 / English / 日本語 / 한국어，跟随系统或手动选择
- **主题**：浅色 / 深色 / 跟随系统
- 剪贴板最大历史条数（100 / 200 / 500 / 1000 / 2000）
- 自动删除旧记录（7天 / 30天 / 90天 / 从不）
- 一键导出所有数据（JSON 格式备份）
- 清空剪贴板历史 / 清空笔记

---

## 🏗️ 技术架构

```
lib/
├── core/
│   ├── database/
│   │   ├── database_service.dart     # Isar 初始化
│   │   ├── app_settings.dart         # 设置数据模型
│   │   └── settings_service.dart     # 设置持久化（JSON文件）
│   ├── services/
│   │   └── native_clipboard_service.dart  # Android MethodChannel/EventChannel
│   └── utils/
│       ├── time_formatter.dart       # 相对时间格式化（多语言）
│       └── export_service.dart       # 文件导出 & 分享
├── features/
│   ├── clipboard/
│   │   ├── models/clipboard_item.dart   # Isar model
│   │   ├── providers/clipboard_provider.dart
│   │   ├── screens/clipboard_screen.dart
│   │   └── widgets/clipboard_item_card.dart
│   ├── notes/
│   │   ├── models/note.dart             # Isar model
│   │   ├── providers/notes_provider.dart
│   │   ├── screens/
│   │   │   ├── notes_screen.dart
│   │   │   └── note_editor_screen.dart  # Markdown编辑器
│   │   └── widgets/note_card.dart
│   └── settings/
│       ├── providers/settings_provider.dart
│       └── screens/settings_screen.dart
├── l10n/
│   ├── app_localizations.dart           # 抽象基类 + 代理
│   ├── app_localizations_en.dart
│   ├── app_localizations_zh.dart        # 含繁体
│   ├── app_localizations_ja.dart
│   └── app_localizations_ko.dart
└── shared/
    ├── theme/app_theme.dart             # Material 3 主题
    └── widgets/
        ├── main_shell.dart              # 底部导航
        ├── empty_state.dart
        └── confirm_dialog.dart

android/app/src/main/kotlin/cn/inaiworld/clipnote/
├── MainActivity.kt                      # MethodChannel + EventChannel
└── ClipboardService.kt                  # 前台服务（可选后台监听）
```

**依赖**

| 用途 | 包名 |
|------|------|
| 状态管理 | flutter_riverpod |
| 数据库 | isar + isar_flutter_libs |
| 多语言 | flutter_localizations + intl |
| Markdown | flutter_markdown |
| 导出/分享 | share_plus |
| 路径 | path_provider |
| UI | Material 3（内置） |

---

## 🚀 快速开始

### 环境要求
- Flutter 3.19+ (Dart 3.0+)
- Android Studio / VS Code
- Android SDK (minSdkVersion 26 = Android 8.0+)

### 1. 克隆 / 解压项目

```bash
cd clipnote
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行（开发模式）

```bash
flutter run
```

### 4. 构建 Release APK

```bash
flutter build apk --release
# 产物: build/app/outputs/flutter-apk/app-release.apk
```

### 5. 构建 App Bundle（Google Play）

```bash
flutter build appbundle --release
# 产物: build/app/outputs/bundle/release/app-release.aab
```

---

## 📦 Google Play 上架要点

### 应用信息
- **包名**: `cn.inaiworld.clipnote`
- **minSdk**: 26（Android 8.0）
- **targetSdk**: 34

### 权限说明（Play Console 数据安全表单）
- ✅ 不收集任何用户数据
- ✅ 数据不发送至第三方
- ✅ 数据不离开设备
- `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE`：仅用于导出功能

### 剪贴板权限（重要）
Android 10+ 限制后台读取剪贴板。本应用采用两种方式：
1. **前台监听（主要）**：应用激活时通过 `EventChannel` 实时接收剪贴板变化
2. **Resume 捕获**：每次切回应用时自动读取一次剪贴板
3. **前台服务（可选）**：`ClipboardService.kt` 提供后台监听，但会显示通知栏图标

在 Play 审核时，在"数据安全"部分说明剪贴板用途为"保存用户主动复制的内容，数据不离开设备"。

---

## 🎨 界面预览（功能说明）

### 剪贴板页
- 顶部搜索栏（点击搜索图标展开）
- 记录数量 Chip
- 卡片列表：类型徽章（Text/URL）、置顶图标、相对时间、内容预览
- 右上角菜单：粘贴新内容、导出、清空

### 笔记页
- 同样支持搜索
- 卡片显示：标题/首行、内容预览、编辑时间、字数
- 点击进入 Markdown 编辑器，顶部切换"编辑/预览"模式
- 自动保存（2秒防抖）

### 设置页
- 隐私声明横幅（紫色卡片）
- 语言选择弹窗（6项：跟随系统、英文、简中、繁中、日文、韩文）
- 主题选择
- 剪贴板历史上限
- 自动删除周期
- 数据导出、清空操作

---

## 🔧 自定义

### 修改包名
替换所有 `cn.inaiworld.clipnote` 为你的包名：
- `android/app/build.gradle` → `applicationId`
- `android/app/src/main/AndroidManifest.xml` → `package`
- `android/app/src/main/kotlin/cn/inaiworld/clipnote/` → 目录名
- Kotlin 文件顶部 `package` 声明

### 添加语言
1. 在 `lib/l10n/` 创建 `app_localizations_xx.dart`，继承 `AppLocalizations`
2. 在 `app_localizations.dart` 的 `lookupAppLocalizations` 添加 case
3. 在 `supportedLocales` 列表添加 `Locale('xx')`
4. 在设置页 `_LanguageTile._languages` 添加选项

---

## 📄 License

MIT © 2026 inaiworld
