# DOCHAT 上架前修复指令 — Codex 派发用

> 基于上架前合规审查报告（docs/test/DOCHAT-上架前合规审查报告.md）
> 编译基线：`mvn compile` ✅ | `dart analyze` 0 error ✅

---

## 第一轮：🔴 必须修复（3 项，Worker: Dalton）

### S1：设置页深色模式开关修复或隐藏

**文件**：`frontend/lib/pages/settings/settings_page.dart:468`

**问题**：`CupertinoSwitch` 的 `onChanged: null`，点击无效，上架审核时会发现死开关。

**修改**（二选一）：
- **选项 A（推荐）**：实现真实深色模式切换，在 `SettingsProvider` 中加 `_isDarkMode` 字段 + `toggleDarkMode()` 方法，`onChanged` 回调调用 `provider.toggleDarkMode()` 并保存到 `SharedPreferences`。
- **选项 B（最快）**：删除第 460-472 行的 `_buildThemeRow()` 整个方法及其调用位置，隐藏该设置项。

### S2：设置页语言切换修复或隐藏

**文件**：`frontend/lib/pages/settings/settings_page.dart` 中 `_showLanguageSheet` 方法

**问题**：弹出 BottomSheet 显示中/英文两个选项，但 `Navigator.pop()` 后不做任何事，选择不生效。

**修改**（二选一）：
- **选项 A（推荐）**：实现真实语言切换——弹出选项时，将所选语言保存到 `SharedPreferences`，然后通过 `E10n.of(context).locale` 或类似机制刷新多语言。
- **选项 B（最快）**：删除 `_showLanguageSheet` 方法及调用入口，隐藏语言设置行。

### S3：设置页支付设置修复或隐藏

**文件**：`frontend/lib/pages/settings/settings_page.dart` 中 `_showPaymentDialog` 方法

**问题**：点击"支付设置"只弹出对话框显示"未绑定"占位文本，无实际功能。

**修改**（二选一）：
- **选项 A（推荐）**：实现支付绑定引导页，提示"功能开发中，敬请期待"，跳转到支付配置页面（可后续对接微信/支付宝 SDK）。
- **选项 B（最快）**：移除支付设置入口行，或改为显示已绑定的 Mock 状态，避免上架审核发现空功能。

---

## 第二轮：🟡 建议修复（3 项，Worker: Dalton）

### S4：广场移除 Material 的 SliverPersistentHeader

**文件**：`frontend/lib/pages/square/square_page.dart:67-70`

**问题**：T26 要求移除 Material 的 `SliverPersistentHeader`，代码中该段仍然存在。虽然 segment 内容是 Cupertino 组件，但 wrapper 是 Material 的 `SliverPersistentHeader`。

**修改**：将 `SliverPersistentHeader` 替换为纯 Cupertino 方案：
- 方案 1：使用 `CustomScrollView` + 定位 segment 到 navigation bar 下方
- 方案 2：使用 `CupertinoSliverNavigationBar` 的 `trailing` 或 `largeTitle` 区域放置 segment

### S5：设置页 coming soon 占位项隐藏

**文件**：`frontend/lib/pages/settings/settings_page.dart` 中 `_showComingSoonDialog` 方法

**问题**：意见反馈、用户协议、隐私政策 3 个入口都指向同一个 `_showComingSoonDialog()` 显示"coming soon"，上架审核会认为功能不完整。

**修改**（二选一）：
- **选项 A**：从设置页中移除这三行（或注释掉）。
- **选项 B**：替换为真实页面——意见反馈跳转 Email/FEEDBACK 页面，用户协议/隐私政策显示本地 HTML 内容。

### S6：HomePage default 分支改为 assert

**文件**：`frontend/lib/pages/auth/main_shell_page.dart:142-143`

**问题**：`_buildPage()` 的 default 分支返回 `HomePage` 作为兜底页。正常使用时此分支不可达，但 App Store 审核可能注意到"登录成功"页面出现在不合逻辑的上下文。

**修改**：
```dart
default:
  assert(false, 'Invalid tab index: $index');
  return const SizedBox.shrink(); // 或 throw StateError
```

---

## 执行顺序

```
第一轮：S1~S3（🔴 必须修复，共约 25 min）
第二轮：S4~S6（🟡 建议修复，共约 16 min）
每轮完成后 → WorkBuddy 复查
```

