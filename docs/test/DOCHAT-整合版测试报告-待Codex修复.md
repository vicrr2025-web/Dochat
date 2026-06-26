# DOCHAT 修复任务清单 — Codex 派发用

> API 路径 57 处 ✅ 已由用户修复，WorkBuddy 审查通过，以下不再涉及。  
> 编译基线：`mvn compile` ✅ | `dart analyze` 0 error ✅

---

## 第一轮：P0 崩溃修复（7 项，Worker: Dalton）

### T1：AuthService 全部 POST 方法加业务状态码检查

**文件**：`frontend/lib/services/auth_service.dart`

**修改**：`register()`、`login()`、`loginBySms()`、`refreshToken()`、`resetPassword()` 五个方法，在 `AuthResponse.fromJson(response.data['data'])` 之前加：

```dart
if (response.data['code'] != 0) {
  throw Exception(response.data['message'] ?? '业务错误');
}
```

`resetPassword()` 同时改为返回 `Future<Map<String, dynamic>>` 而非 `Future<void>`。

### T2：SmsButton 检查发送结果再启动倒计时

**文件**：`frontend/lib/pages/auth/widgets/sms_button.dart`

**修改**：`sendSms()` 调用后检查 `response.data['code'] == 0` 才启动 60 秒倒计时，失败时保持按钮可点击。

### T3：密码修改字段名 currentPassword → oldPassword

**文件**：`frontend/lib/services/settings_service.dart:20`

**修改**：请求体中 `'currentPassword': currentPassword` → `'oldPassword': currentPassword`。

### T4：隐私设置值统一为 'everyone'

**文件**：`frontend/lib/pages/settings/privacy_settings_page.dart:53`

**修改**：`'all'` → `'everyone'`。

### T5：PostInfo.createdAt 空安全

**文件**：`frontend/lib/models/post_models.dart:54`

**修改**：`json['createdAt'] as String` → `(json['createdAt'] as String?) ?? ''`。

### T6：Chat 分页字段统一

**文件**：
1. `backend/.../dto/PageResponse.java` — 字段 `page` → 加 `@JsonProperty("currentPage")` 或改为 `currentPage`。`size` 字段缺失需补上。
2. `frontend/lib/models/chat_models.dart` — 检查 `SessionInfo` / `MessageInfo` 中 `fromJson` 的分页解析字段名与后端对齐。

### T7：resetPassword 返回类型改为带状态码

同 T1 一并处理，确保 `resetPassword()` 返回 `response.data['code']` 给调用方判断。

---

## 第二轮：P1 功能修复（10 项，Worker: Dalton）

### T8：登录/注册成功跳转 MainShellPage

**文件**：
- `frontend/lib/pages/auth/login_page.dart:74-76`
- `frontend/lib/pages/auth/register_page.dart:61-64`

**修改**：`Navigator.pushReplacement` 的目标从 `HomePage` 改为 `MainShellPage`。

### T9：MainShellPage Tab 0 / Tab 1 分配正确页面

**文件**：`frontend/lib/pages/auth/main_shell_page.dart:130-133`

**修改**：
- `case 0:` → 聊天列表页面组件
- `case 1:` → 好友列表页面组件

### T10：VideoBrowsePage 点赞调 API

**文件**：`frontend/lib/pages/square/video_browse_page.dart:37-40`

**修改**：双击点赞回调中调用 `provider.toggleLike(postId)`，根据返回结果更新 `_isLiked`。

### T11：关注状态持久化（后端+前端）

**文件**：
1. `backend/.../dto/PostResponse.java` — 新增字段 `isFollowing: boolean`
2. `frontend/lib/models/post_models.dart` — `PostInfo` 加 `isFollowing` 字段
3. `frontend/lib/pages/square/square_page.dart:225` — `_isFollowed = false` 改为从 `post.isFollowing` 初始化

### T12：评论回复传 parentId

**文件**：`frontend/lib/pages/square/comment_list_page.dart:57-61`

**修改**：回复时除了传 `replyToUserId`，再加传 `parentId`（被回复评论的 `commentId`）。

### T13：评论列表实现分页加载

**文件**：
- `frontend/lib/services/post_service.dart:42-52` — 修改 `getComments` 返回分页元数据（currentPage, totalPages）
- `frontend/lib/pages/square/comment_list_page.dart` — 加滚动监听，触底调 `getComments(page+1)`

### T14：Chat `_hasMore` 动态计算

**文件**：`frontend/lib/providers/chat_provider.dart`

**修改**：加载会话/消息列表后，根据后端返回的 `totalPages` 或 `hasNext` 字段设置 `_hasMore`，替代固定 true。

### T15：Chat 媒体消息上传真实文件

**文件**：`frontend/lib/providers/chat_provider.dart`

**修改**：图片/语音/文件消息先调 `uploadFile(file)` 获取真实 URL，用真实 URL 调 `sendMessage`，去掉硬编码 mock URL。

### T16：loadMore 失败后页码回滚

**文件**：`frontend/lib/providers/post_provider.dart:81-85`

**修改**：`_currentPage++` 移到 `loadFeed` API 成功返回之后，或 catch 块中执行 `_currentPage--`。

### T17：catch 块补 notifyListeners

**文件**：`auth_provider.dart`、`settings_provider.dart`、`post_provider.dart`

**修改**：所有设置了 `_errorMessage` 的 catch 块末尾加一行 `notifyListeners()`。

---

## 第三轮：P2 缺陷修复（19 项，Worker: Dalton）

### T18：_extractError 加类型检查

**文件**：`frontend/lib/pages/auth/login_page.dart`

**修改**：`as Map` → 加 `is Map` 判断，非 Map 时返回默认错误文本。

### T19：_isLoggedIn 只应在业务成功后设置

**文件**：`frontend/lib/providers/auth_provider.dart:65`

**修改**：`_isLoggedIn = true` 放在确认 `response.data['code'] == 0` 之后。

### T20：expiresIn 类型安全

**文件**：`frontend/lib/models/auth_models.dart:22`

**修改**：`json['expiresIn'] as int` → `(json['expiresIn'] as num?)?.toInt() ?? 0`。

### T21：Token 刷新后保存 userId

**文件**：`frontend/lib/services/api_service.dart:54-58`

**修改**：刷新成功后补 `_storage.write('userId', data['userId'])`。

### T22：SSE 未读计数区分当前会话

**文件**：`frontend/lib/providers/chat_provider.dart`

**修改**：SSE 回调中判断 `sessionId != _currentSessionId` 时才累加未读计数。

### T23：markAsRead 防空参数

**文件**：`frontend/lib/providers/chat_provider.dart`（或 `chat_page.dart`）

**修改**：调 `markAsRead` 前检查 `sessionId` 不为空字符串。

### T24：Chat 消息乐观更新

**文件**：`frontend/lib/providers/chat_provider.dart`

**修改**：`sendMessage` 发送前先创建临时 `MessageInfo` 插入消息列表，发送失败时回滚。

### T25：关注按钮 UI 反馈

**文件**：`frontend/lib/pages/square/square_page.dart`

**修改**：关注/取消关注时切换按钮文字和颜色。

### T26：Square 页面移除 Material 组件

**文件**：`frontend/lib/pages/square/square_page.dart:161-212`

**修改**：`SliverPersistentHeader`（Material）改为 Cupertino 方案（如 `SliverAppBar` 配合 Cupertino 风格）。

### T27：发帖时上传媒体文件

**文件**：`frontend/lib/pages/square/create_post_page.dart`

**修改**：提交前先调 `uploadFile` 获取真实 URL，URL 跟随帖子内容一起提交。

### T28：成功操作清理错误状态

**文件**：`frontend/lib/providers/settings_provider.dart`

**修改**：各 load 方法成功路径加 `_errorMessage = null`。

### T29：写操作补充 loading 状态

**文件**：`frontend/lib/providers/settings_provider.dart`

**修改**：`updateProfile()` 等写操作前后设置 `_isLoading = true / false`。

### T30：device_manage_page i18n key 修正

**文件**：`frontend/lib/pages/settings/device_manage_page.dart:82`

**修改**：`removeFriendConfirm` → 正确的 i18n key（如 `removeDeviceConfirm`，按实际 l10n 定义）。

### T31：TextEditingController 移到 initState

**文件**：`frontend/lib/pages/settings/profile_edit_page.dart:92`

**修改**：在 build 中初始化的 controller 移到 `initState` 或 `_` 前缀字段声明处初始化。

### T32：异步操作加 await

**文件**：`frontend/lib/pages/settings/device_manage_page.dart:93,131`

**修改**：两个异步调用前加 `await`。

### T33：删除 ChatService 冗余 getFriends

**文件**：`frontend/lib/services/chat_service.dart:141-151`

**修改**：删除整个 `getFriends()` 方法（与 `FriendService` 重复）。

### T34：FriendService 好友请求路径补 /pending

**文件**：`frontend/lib/services/friend_service.dart:24`

**修改**：`/v1/friends/requests` → `/v1/friends/requests/pending`。

### T35：JWT 黑名单 Redis Key 统一

**文件**：
1. `backend/.../security/JwtAuthenticationFilter.java:41`
2. `backend/.../service/AuthService.java:33`

**修改**：两者使用相同的 key 前缀。推荐方案——`JwtAuthenticationFilter.java` 中硬编码的 `"token:blacklist:"` 改为引用 `AuthService.TOKEN_BLACKLIST_PREFIX`（即 `"token_blacklist:"`）。

---

## 执行顺序

```
第一轮：T1~T7（P0，39 min）
第二轮：T8~T17（P1，85 min）
第三轮：T18~T35（P2，90 min）
每轮完成后 → WorkBuddy 复查
```
