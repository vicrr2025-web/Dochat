# DOCHAT 深度代码审查报告 V2.0

> 审查日期：2026-06-26  
> 审查方式：Subagent 逐模块静态代码审查（Provider → Service → Model → DTO 数据流）  
> 审查模块：Auth / Chat / Square(Post/Comment/Follow) / Settings  
> 编译基线：`mvn compile` ✅ | `dart analyze` 226 info, 0 error ✅

---

## 一、整体结论

API 路径 57 处修复已通过审查，但深入数据流审查发现 **大量运行时隐患**，按严重度分级如下：

| 严重度 | 数量 | 说明 |
|--------|------|------|
| P0 崩溃级 | 7 | 运行时必崩或核心功能完全不可用 |
| P1 高 | 10 | 功能缺失或数据不同步 |
| P2 中 | 15 | 功能缺陷或 UX 问题 |
| P3 低 | 10 | 可改进/代码味道 |

---

## 二、P0 — 运行时崩溃（7 项）

### P0-1：AuthService 未检查业务状态码 → 登录注册必崩

**文件**：`frontend/lib/services/auth_service.dart:26-61`  
**场景**：密码错误 / 手机号未注册 / 账号锁定等业务错误时，后端返回 HTTP 200 + `{"code": 1, "message": "...", "data": null}`。前端直接解析 `response.data['data']` 为 `AuthResponse.fromJson(null)` → 崩溃。  
**修复**：所有 parse 前检查 `response.data['code'] == 0`，非零则抛异常。

### P0-2：SmsButton 发送失败仍启动 60 秒倒计时

**文件**：`frontend/lib/pages/auth/widgets/sms_button.dart:39`  
**问题**：`sendSms()` 的 `ApiResponse` 返回值被丢弃，失败时用户仍看到倒计时 60 秒，无法重试。  
**修复**：检查返回值，成功才启动倒计时。

### P0-3：重置密码成功/失败无法区分

**文件**：`frontend/lib/services/auth_service.dart:77-83`  
**问题**：`resetPassword()` 不检查 `code`、不返回 `ApiResponse`，业务错误时不抛异常 → 用户收到"密码重置成功"误导。  
**修复**：同 P0-1，检查业务状态码。

### P0-4：Chat 模块 PageResponse 字段不匹配

**文件**：`frontend/lib/models/chat_models.dart` vs `后端 PageResponse.java`  
**问题**：前端 `SessionInfo` 和 `MessageInfo` 的分页解析用 `currentPage`，后端 `PageResponse.java` 的字段是 `page`（而非 `currentPage`），且后端 `page` 从 0 开始计数，但前端按 1 计数。另外后端 `PageResponse` 缺少 `size` 字段但前端 `pageResponse` 尝试读取。  
**修复**：统一字段名和计数基准。

### P0-5：Settings 密码修改字段名不匹配

**文件**：`frontend/lib/services/settings_service.dart:20` vs `后端 PasswordChangeRequest.java:8`  
**问题**：前端发 `'currentPassword'`，后端期望 `'oldPassword'` → Jackson 反序列化后 `oldPassword` 为 null → 触发 `@NotBlank` 校验失败 → 改密码功能完全不可用。  
**修复**：前端 `'currentPassword'` → `'oldPassword'`。

### P0-6：Settings 隐私设置值 'all' vs 'everyone' 不一致

**文件**：`frontend/lib/models/settings_models.dart:128` vs `frontend/lib/pages/settings/privacy_settings_page.dart:53`  
**问题**：模型默认值用 `'everyone'`，页面 ActionSheet 发 `'all'` → 初始选中标记丢失 + 后端数据不一致。  
**修复**：统一为 `'everyone'`。

### P0-7：PostInfo.createdAt 可为 null → 列表页可能崩

**文件**：`frontend/lib/models/post_models.dart:54`  
**问题**：`json['createdAt'] as String` 但后端允许返回 null，列表页渲染遇到 null 即崩溃。  
**修复**：`(json['createdAt'] as String?) ?? ''`

---

## 三、P1 — 核心功能不可用/数据不同步（10 项）

### P1-1：登录后导航到 HomePage 占位页面

**文件**：`frontend/lib/pages/auth/login_page.dart:74-76`、`register_page.dart:61-64`  
**问题**：登录/注册成功后跳转 `HomePage`（仅有"登录成功"文字的占位页），而非 `MainShellPage`（真实 Tab 界面）。  
**修复**：跳转改为 `MainShellPage`。

### P1-2：MainShellPage Tab 0 和 Tab 1 都显示 HomePage

**文件**：`frontend/lib/pages/auth/main_shell_page.dart:130-133`  
**问题**：
```dart
case 0: return const HomePage();  // 应为聊天列表
case 1: return const HomePage();  // 应为好友列表
```
**修复**：Tab 0 → ChatListPage，Tab 1 → FriendListPage（或其他正确页面组件）。

### P1-3：VideoBrowsePage 点赞不与 Provider 同步

**文件**：`frontend/lib/pages/square/video_browse_page.dart:37-40`  
**问题**：双击点赞仅更新本地 `_isLiked`，**完全不调** `PostProvider.toggleLike()`，返回列表页后状态重置。  
**修复**：调用 `provider.toggleLike(postId)` 并处理结果。

### P1-4：关注状态不持久化

**文件**：`frontend/lib/pages/square/square_page.dart:225`  
**问题**：`bool _isFollowed = false` 始终初始化为 false，Widget 重建即重置。API 调用失败 UI 仍切换。后端 `PostResponse` 缺少 `isFollowing` 字段。  
**修复**：后端 PostResponse 加 `isFollowing: boolean`，前端据此初始化。

### P1-5：评论回复 parentId 丢失

**文件**：`frontend/lib/pages/square/comment_list_page.dart:57-61`  
**问题**：回复评论时只传 `replyToUserId` 不传 `parentId`，评论树层级关系丢失。  
**修复**：存储被回复评论的 `commentId` 作为 `parentId` 一并发送。

### P1-6：评论列表无分页加载

**文件**：`frontend/lib/services/post_service.dart:42-52`  
**问题**：`getComments` 忽略 `totalPages` 等分页元数据，ListView 不检测滚动加载更多。  
**修复**：返回分页元数据并在 UI 实现滚动加载。

### P1-7：Chat `_hasMore` 固定为 true → 无限请求

**文件**：`frontend/lib/providers/chat_provider.dart`  
**问题**：未根据 `PageResponse` 的分页数据动态计算 `_hasMore`。  
**修复**：从后端 `totalPages` 或 `hasNext` 判断。

### P1-8：Chat 媒体消息使用伪造 URL

**文件**：`frontend/lib/providers/chat_provider.dart`  
**问题**：图片/语音/文件消息使用硬编码 mock URL，`sendMessage` 未调 `uploadFile`。  
**修复**：先调 `uploadFile` 获取真实 URL，再发消息。

### P1-9：loadMore 失败后页码不回滚

**文件**：`frontend/lib/providers/post_provider.dart:81-85`  
**问题**：`_currentPage++` 在 `loadFeed` 之前执行，失败后不回滚，导致页码空洞。  
**修复**：`_currentPage++` 移到成功路径，或 catch 中 `_currentPage--`。

### P1-10：多处 catch 块未调 notifyListeners

**文件**：auth_provider、settings_provider、post_provider 等多处  
**问题**：catch 设置了 `_errorMessage` 但未调 `notifyListeners()`，UI 无法获悉错误状态变更。  
**修复**：所有 catch 块末尾加 `notifyListeners()`。

---

## 四、P2 — 功能性缺陷（15 项摘要）

| # | 模块 | 位置 | 问题 | 修复 |
|---|------|------|------|------|
| 1 | Auth | `login_page.dart` | `_extractError` 强制转型 `as Map` 风险 | 加类型检查 |
| 2 | Auth | `auth_provider.dart:65` | 业务错误时 `_isLoggedIn` 可能误设为 true | 只在确认 code==0 后设 true |
| 3 | Auth | `auth_models.dart:22` | `expiresIn` 类型 Long vs int | 用 `(num?)?.toInt() ?? 0` |
| 4 | Auth | `api_service.dart:54-58` | Token 刷新后未保存 userId | 保存 userId |
| 5 | Chat | chat_provider | SSE 未读计数不区分当前会话 | 判断 `sessionId != _currentSessionId` |
| 6 | Chat | `chat_page.dart` | `markAsRead` 传空字符串 | 检查 sessionId 非空 |
| 7 | Chat | chat_provider | 无乐观更新 | 先创建临时 MessageInfo |
| 8 | Square | `square_page.dart` | 关注按钮 UI 无变化 | 切换按钮文字/颜色 |
| 9 | Square | `square_page.dart` | 使用 Material `SliverPersistentHeader` | 改为 Cupertino 方案 |
| 10 | Square | `create_post_page.dart` | 媒体选择后未上传 | 调 uploadFile 获取 URL |
| 11 | Settings | settings_provider | 成功操作不清理错误状态 | `_errorMessage = null` |
| 12 | Settings | settings_provider | 写操作不设 `isLoading` | 补充 loading 状态 |
| 13 | Settings | `device_manage_page.dart:82` | i18n 键误用 `removeFriendConfirm` | 换为正确 key |
| 14 | Settings | `profile_edit_page.dart:92` | Controller 在 build 中初始化 | 移到 initState |
| 15 | Settings | `device_manage_page.dart:93,131` | 异步操作未 await | 加 await |

---

## 五、修复排期建议

### 第一轮（P0 — 崩溃修复）

| 顺序 | 任务 | Worker | 涉及文件 | 预估 |
|------|------|--------|---------|------|
| 1 | AuthService 全部 POST 返回前检查 `response.data['code']` | Dalton | `auth_service.dart` | 15 min |
| 2 | SmsButton 检查返回值 | Dalton | `sms_button.dart` | 5 min |
| 3 | 密码修改字段名 `currentPassword` → `oldPassword` | Dalton | `settings_service.dart` | 1 min |
| 4 | 隐私值统一 `'all'` → `'everyone'` | Dalton | `settings_models.dart`, `privacy_settings_page.dart` | 2 min |
| 5 | PostInfo.createdAt 空安全 | Dalton | `post_models.dart` | 1 min |
| 6 | Chat PageResponse 字段统一 | Dalton | `chat_models.dart`, 后端 `PageResponse.java` | 10 min |
| 7 | resetPassword 检查业务状态码 | Dalton | `auth_service.dart` | 5 min |

### 第二轮（P1 — 功能修复）

| 顺序 | 任务 | Worker | 涉及文件 | 预估 |
|------|------|--------|---------|------|
| 1 | 登录导航改 `MainShellPage` | Dalton | `login_page.dart`, `register_page.dart` | 5 min |
| 2 | MainShellTab 分配正确页面 | Dalton | `main_shell_page.dart` | 5 min |
| 3 | VideoBrowsePage 点赞调用 API | Dalton | `video_browse_page.dart` | 10 min |
| 4 | PostResponse 加 `isFollowing` | Dalton | `PostResponse.java`, `post_models.dart` | 15 min |
| 5 | 评论 parentId 传递 | Dalton | `comment_list_page.dart` | 5 min |
| 6 | 评论分页加载 | Dalton | `post_service.dart`, `comment_list_page.dart` | 15 min |
| 7 | Chat `_hasMore` 动态计算 | Dalton | `chat_provider.dart` | 5 min |
| 8 | Chat 媒体上传真实 URL | Dalton | `chat_provider.dart` | 10 min |
| 9 | loadMore 页码回滚 | Dalton | `post_provider.dart` | 5 min |
| 10 | catch 块补 notifyListeners | Dalton | 各 provider | 10 min |

### 第三轮（P2 — 优化，可延期 V5.1）

17 项 P2 问题，按模块分批修复。

---

## 六、已完成路径修复确认（无需再动）

| 文件 | 修复内容 | 状态 |
|------|---------|------|
| `auth_service.dart` | 8 处 `/api/auth/` → `/auth/` | ✅ |
| `chat_service.dart` | 12 处 `/api/v1/` → `/v1/` | ✅ |
| `friend_service.dart` | 7 处 `/api/v1/friends` → `/v1/friends` | ✅ |
| `location_service.dart` | 8 处 `/api/v1/` → `/v1/` | ✅ |
| `dating_service.dart` | 22 处 `/v1/love/` → `/love/` | ✅ |

**待修复项**：
- `friend_service.dart:24` → 缺 `/pending`（P2 任务 1）
- `chat_service.dart:141-151` → 冗余 `getFriends()`（P2 任务 2）
