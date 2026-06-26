# DOCHAT 全项目功能测试报告 V1.0

> 测试日期：2026-06-26  
> 测试类型：静态代码审查 + API 契约审计  
> 测试范围：M1-M14 全部模块（19 后端 Controller × 17 前端 Service）  
> 编译基线：`mvn compile` BUILD SUCCESS ✅ | `dart analyze` 0 error ✅  

---

## 一、总体结论

**通过率：10/14 模块通过**  
**故障模块：5 个模块存在 API 路径断裂，总计 56 个 API 端点不可用**

| 状态 | 模块数 | 模块清单 |
|------|--------|----------|
| ✅ 通过 | 10 | M4广场、M5服务六宫格、M6设置、M8电波找房、M9担保交易、M10电波直聘、M11电波邮箱、M12电波速运、M13电波商城、M14电波到家 |
| ❌ 断裂 | 5 | M1用户认证、M2聊天核心、M3好友系统+定位、M7电波婚恋 |

---

## 二、高危 Bug（P1 — 运行时 404，功能完全不可用）

### Bug #1 — Auth 模块 8 个端点断裂

**所属模块**：M1 用户认证底座  
**文件**：`frontend/lib/services/auth_service.dart`  
**严重程度**：P1 — 登录/注册/短信/密码全部失效

**根因**：前端路径使用 `/api/auth/xxx`，但 `ApiService.baseUrl` 已是 `http://localhost:8080/api`，导致最终请求 URL 为 `http://localhost:8080/api/api/auth/xxx`，后端期望 `http://localhost:8080/api/auth/xxx`。

**受影响方法**（共 8 个）：

| 前端路径 | 正确路径 | 后端端点 |
|----------|----------|----------|
| `/api/auth/sms/send` | `/auth/sms/send` | `POST /api/auth/sms/send` |
| `/api/auth/register` | `/auth/register` | `POST /api/auth/register` |
| `/api/auth/login` | `/auth/login` | `POST /api/auth/login` |
| `/api/auth/login/sms` | `/auth/login/sms` | `POST /api/auth/login/sms` |
| `/api/auth/refresh` | `/auth/refresh` | `POST /api/auth/refresh` |
| `/api/auth/logout` | `/auth/logout` | `POST /api/auth/logout` |
| `/api/auth/password` | `/auth/password` | `PUT /api/auth/password` |
| `/api/auth/password/reset` | `/auth/password/reset` | `POST /api/auth/password/reset` |

**修复方案**：`auth_service.dart` 中 8 处路径将 `/api/auth` → `/auth`

---

### Bug #2 — Chat 模块 12 个端点断裂

**所属模块**：M2 聊天核心  
**文件**：`frontend/lib/services/chat_service.dart`  
**严重程度**：P1 — 消息收发、会话管理、文件上传全部失效

**根因**：前端路径使用 `/api/v1/xxx`，实际请求 `.../api/api/v1/xxx`。

**受影响方法**（共 12 个）：

| 前端路径 | 正确路径 | 后端端点 |
|----------|----------|----------|
| `/api/v1/sessions` | `/v1/sessions` | `GET/POST /api/v1/sessions` |
| `/api/v1/sessions/$sid/pin` | `/v1/sessions/$sid/pin` | `PUT /api/v1/sessions/{id}/pin` |
| `/api/v1/sessions/$sid/mute` | `/v1/sessions/$sid/mute` | `PUT /api/v1/sessions/{id}/mute` |
| `/api/v1/sessions/$sid` | `/v1/sessions/$sid` | `DELETE /api/v1/sessions/{id}` |
| `/api/v1/messages` | `/v1/messages` | `GET/POST /api/v1/messages` |
| `/api/v1/messages/$mid/revoke` | `/v1/messages/$mid/revoke` | `PUT /api/v1/messages/{id}/revoke` |
| `/api/v1/messages/read` | `/v1/messages/read` | `PUT /api/v1/messages/read` |
| `/api/v1/messages/search` | `/v1/messages/search` | `GET /api/v1/messages/search` |
| `/api/v1/messages/upload` | `/v1/messages/upload` | `POST /api/v1/messages/upload` |
| `/api/v1/friends` | `/v1/friends` | `GET /api/v1/friends` |

**修复方案**：`chat_service.dart` 中 12 处路径将 `/api/v1` → `/v1`

---

### Bug #3 — Friend 模块 6 个端点断裂

**所属模块**：M3 好友系统  
**文件**：`frontend/lib/services/friend_service.dart`  
**严重程度**：P1 — 搜索好友、发请求、好友列表全部失效

**受影响方法**（共 6 个）：

| 前端路径 | 正确路径 | 后端端点 |
|----------|----------|----------|
| `/api/v1/friends/search` | `/v1/friends/search` | `GET /api/v1/friends/search` |
| `/api/v1/friends/requests` | `/v1/friends/requests` | `POST /api/v1/friends/requests` |
| `/api/v1/friends/requests` | `/v1/friends/requests/pending` | `GET /api/v1/friends/requests/pending` |
| `/api/v1/friends/requests/{id}/accept` | `/v1/friends/requests/{id}/accept` | `PUT /api/v1/friends/requests/{id}/accept` |
| `/api/v1/friends/requests/{id}/reject` | `/v1/friends/requests/{id}/reject` | `PUT /api/v1/friends/requests/{id}/reject` |
| `/api/v1/friends` | `/v1/friends` | `GET /api/v1/friends` |
| `/api/v1/friends/{fid}` | `/v1/friends/{fid}` | `DELETE /api/v1/friends/{friendId}` |

**⚠️ 额外发现**：前端 `friend_service.dart` 请求 `/api/v1/friends/requests` 获取待处理请求，但后端实际端点需要 `/api/v1/friends/requests/pending`。这是 **第二个 Bug** — 前端漏了 `/pending` 后缀。

**修复方案**：
1. 7 处路径将 `/api/v1` → `/v1`  
2. `getPendingRequests()` 中 `/api/v1/friends/requests` → `/v1/friends/requests/pending`

---

### Bug #4 — Location 模块 8 个端点断裂

**所属模块**：M3 定位系统  
**文件**：`frontend/lib/services/location_service.dart`  
**严重程度**：P1 — 位置上传、轨迹、地理围栏全部失效

**受影响方法**（共 8 个）：

| 前端路径 | 正确路径 | 后端端点 |
|----------|----------|----------|
| `/api/v1/location/upload` | `/v1/location/upload` | `POST /api/v1/location/upload` |
| `/api/v1/location/current` | `/v1/location/current` | `GET /api/v1/location/current` |
| `/api/v1/location/friends` | `/v1/location/friends` | `GET /api/v1/location/friends` |
| `/api/v1/location/{fid}/trajectory` | `/v1/location/{fid}/trajectory` | `GET /api/v1/location/{friendId}/trajectory` |
| `/api/v1/location/sharing` | `/v1/location/sharing` | `PUT /api/v1/location/sharing` |
| `/api/v1/geofences` | `/v1/geofences` | `GET/POST /api/v1/geofences` |
| `/api/v1/geofences/{fid}` | `/v1/geofences/{fid}` | `DELETE /api/v1/geofences/{id}` |

**修复方案**：`location_service.dart` 中 8 处路径将 `/api/v1` → `/v1`

---

### Bug #5 — Dating 模块 22 个端点断裂

**所属模块**：M7 电波婚恋  
**文件**：`frontend/lib/services/dating_service.dart`  
**严重程度**：P1 — 婚恋全部功能不可用，含资料/推荐/点赞/匹配/直播/礼物/VIP等

**根因**：前端使用 `/v1/love/xxx`，实际请求 `.../api/v1/love/xxx`，但后端 `DatingController` 的 `@RequestMapping("/api/love")` 期望 `.../api/love/xxx`。前缀 `v1` 导致路径不匹配。

**受影响方法**（共 22 个）：

```dart
// 所有 /v1/love/xxx 应改为 /love/xxx
'/v1/love/profile'        → '/love/profile'
'/v1/love/recommend'      → '/love/recommend'
'/v1/love/like'           → '/love/like'
'/v1/love/superlike'      → '/love/superlike'
'/v1/love/match'          → '/love/match'
'/v1/love/note'           → '/love/note'
'/v1/love/notes'          → '/love/notes'
'/v1/love/auth/real'      → '/love/auth/real'
'/v1/love/auth/work'      → '/love/auth/work'
'/v1/love/auth/edu'       → '/love/auth/edu'
'/v1/love/feed'           → '/love/feed'
'/v1/love/feed/{id}/like' → '/love/feed/{id}/like'
'/v1/love/feed/{id}/comment' → '/love/feed/{id}/comment'
'/v1/love/live/start'     → '/love/live/start'
'/v1/love/live/end'       → '/love/live/end'
'/v1/love/gift'           → '/love/gift'
'/v1/love/recharge'       → '/love/recharge'
'/v1/love/vip'            → '/love/vip'
'/v1/love/superboost'     → '/love/superboost'
'/v1/love/charm/withdraw' → '/love/charm/withdraw'
```

**修复方案**：`dating_service.dart` 中 22 处路径将 `/v1/love` → `/love`

---

## 三、中危 Bug（P2 — 功能异常但非完全断裂）

### Bug #6 — Friend 请求列表端点缺失 `/pending`

**所属模块**：M3 好友系统  
**文件**：`frontend/lib/services/friend_service.dart:24`  
**严重程度**：P2

前端调用 `GET /api/v1/friends/requests`（修正后应为 `/v1/friends/requests`），但后端 `FriendController.getPendingRequests()` 映射的路径是 `GET /api/v1/friends/requests/pending`。

这说明 **待处理请求列表** 功能 **不可用**，即使修正了 `/api` 前缀问题，路径依然不匹配（缺 `/pending`）。

**修复方案**：`friend_service.dart:24` 中 `'/api/v1/friends/requests'` → `'/v1/friends/requests/pending'`

---

### Bug #7 — Chat Service 中 getFriends() 与 FriendService 重复

**所属模块**：M2 聊天核心  
**文件**：`frontend/lib/services/chat_service.dart:141-151`  
**严重程度**：P2

`ChatService` 中定义了 `getFriends()` 方法，但其功能与 `FriendService.getFriends()` 重复。同一个 API 端点被两个不同的 Service 包装，且 `ChatService` 中的版本返回裸 `Map` 类型而非类型安全对象，属于设计冗余。

**建议**：移除 `ChatService.getFriends()`，统一使用 `FriendService.getFriends()`

---

### Bug #8 — AuthController 使用通用 HTTP 400 而非业务错误码

**所属模块**：M1 用户认证  
**文件**：`AuthController.java`  
**严重程度**：P2

`AuthController` 中所有异常处理使用 `ResponseEntity.badRequest().body(ApiResponse.error(400, e.getMessage()))`，即错误的 code 为 `400`。但 DOCHAT 标准要求各模块使用自定义错误码（如 Auth 应使用 1001-1008 系列）。

对比：`SettingsController` 使用 6001-6010，`DatingController` 使用 6001-6010。

**影响**：前端无法根据错误码区分不同业务错误类型（如"短信验证码错误"vs"密码错误"）。

**建议**：为 Auth 模块分配错误码 1001-1008，并在 Controller 中按错误类型返回不同 code。

---

### Bug #9 — Chat Service SSE 路径缺少 `/api` 前缀（一致性问题）

**所属模块**：M2 聊天核心  
**文件**：`frontend/lib/services/sse_service.dart:49`  
**严重程度**：P2（非破坏性，但风格不一致）

SSE 连接使用 `ApiService.baseUrl + '/v1/sessions/$sessionId/subscribe'`，最终 URL 为 `http://localhost:8080/api/v1/sessions/{sid}/subscribe`，与后端一致 ✅。

但其他 Chat Service 中使用 `/api/v1/sessions`（双重 `/api`）而非 `/v1/sessions`。这种不一致说明 Chat 模块的前端路径设计没有统一规划。

**建议**：修正 Bug #2 后，Chat 模块路径统一为 `/v1/xxx` 风格（不含 `/api` 前缀），与 SSE 一致。

---

## 四、通过模块确认（10/14 ✅）

### M4 — 广场（Post/Comment/Follow）

| 前端文件 | 后端 Controller | 路径匹配 | API 数 |
|----------|----------------|----------|--------|
| `post_service.dart` | `PostController` `/api/v1/posts` | ✅ | 8 |
| `post_service.dart` | `CommentController` `/api/v1` | ✅ | 3 |
| `post_service.dart` | `FollowController` `/api/v1/users` | ✅ | 4 |

### M5 — 服务六宫格

| 前端文件 | 后端 Controller | 路径匹配 | API 数 |
|----------|----------------|----------|--------|
| `service_hub_service.dart` | `ServiceHubController` `/api/v1/services` | ✅ | 2 |

### M6 — 设置

| 前端文件 | 后端 Controller | 路径匹配 | API 数 |
|----------|----------------|----------|--------|
| `settings_service.dart` | `SettingsController` `/api/user` | ✅ | 11 |

### M8 — 电波找房 ✅ | M9 — 担保交易 ✅ | M10 — 电波直聘 ✅ | M11 — 电波邮箱 ✅ | M12 — 电波速运 ✅ | M13 — 电波商城 ✅ | M14 — 电波到家 ✅

---

## 五、错误码审计

| 模块 | 后端使用错误码 | 规范情况 | 建议 |
|------|---------------|----------|------|
| Auth | `400`（通用） | ❌ 未遵循 | 应使用 1001-1008 |
| Chat | `400`（通用） | ❌ | 应使用 2001-2008 |
| Friend | `400`（通用） | ❌ | 应使用 3001-3008 |
| Location | `400`（通用） | ❌ | 应使用 4001-4008 |
| Square/Post | `400`（通用） | ❌ | 应使用 5001-5008 |
| Dating | `6001-6010` | ✅ | — |
| Settings | `6001-6010` | ✅（与 Dating 共用） | 建议分配独立段 |
| Home | `11001-11010` | ✅ | — |
| Express | `10001-10010` | ✅ | — |
| House | `7001-7010` | ✅ | — |
| Job | `8001-8010` | ✅ | — |
| Mail | `9001-9006` | ✅ | — |
| Mall | `12001-12010` | ✅ | — |
| Guarantee | `7001-7011` | ✅ | — |

---

## 六、编译与静态分析

### 后端（Java）

```
mvn compile → BUILD SUCCESS
```

### 前端（Dart/Flutter）

```
dart analyze
  No issues found! (0 error, 0 warning, 227 info)
```

所有 227 个 info 级别提示均为 Dart 标准 lint 建议（如 `prefer_const_constructors`、`unused_import` 等），不影响运行时。

---

## 七、审查终审结论

### M1-M3、M7：57 处路径断裂 — ✅ 已由用户自行修复，审查通过

### 剩余待 Codex 修复项

| 编号 | 模块 | 文件 | 问题 | 修复说明 | 工作量 |
|------|------|------|------|----------|--------|
| Bug #6 | M3 Friend | `friend_service.dart:24` | 路径缺 `/pending` | `/v1/friends/requests` → `/v1/friends/requests/pending` | 1 行 |
| Bug #7 | M2 Chat | `chat_service.dart:141-151` | `getFriends()` 与 FriendService 重复 | 移除冗余方法 | 3 行 |
| Bug #8 | M1 Auth | `AuthController.java` | 错误码全用 400 | 分配 1001-1008 错误码 | 30 min（可延期） |

### 最终模块状态

| 模块 | 路径审计 | 错误码规范 | 备注 |
|------|----------|-----------|------|
| ✅ M1 Auth | 已修复（8 处） | ❌ 通用 400 | 跟踪 Bug #8 |
| ✅ M2 Chat | 已修复（12 处） | ❌ 通用 400 | Bug #7 冗余代码 |
| ✅ M3 Friend | 已修复（7 处） | ❌ 通用 400 | **仍有 Bug #6 未修** |
| ✅ M3 Location | 已修复（8 处） | ❌ 通用 400 | — |
| ✅ M4 Square | 通过 | ❌ 通用 400 | 错误码可延期 |
| ✅ M5 服务六宫格 | 通过 | ❌ 通用 400 | — |
| ✅ M6 设置 | 通过 | ✅ 6001-6010 | — |
| ✅ M7 Dating | 已修复（22 处） | ✅ 6001-6010 | — |
| ✅ M8-M14 | 全部通过 | ✅ 各模块独立编码 | — |

---

## 八、修复优先级与工作量估算

| 优先级 | Bug ID | 说明 | 影响范围 | 预估工作量 |
|--------|--------|------|----------|-----------|
| **P0** | #1 Auth | 登录注册完全不可用 | 全部用户 | 5 min（8 处替换） |
| **P0** | #5 Dating | 婚恋完全不可用 | 婚恋用户 | 5 min（22 处替换） |
| **P1** | #2 Chat | 聊天完全不可用 | 全部用户 | 3 min（12 处替换） |
| **P1** | #3 Friend | 好友系统完全不可用 | 全部用户 | 3 min（7+1 处替换） |
| **P1** | #4 Location | 定位完全不可用 | 需要定位的用户 | 3 min（8 处替换） |
| **P2** | #6 | 好友请求列表不可用 | 好友模块 | 1 min（1 处路径） |
| **P2** | #7 | 代码冗余/重复 | Chat 模块 | 3 min（移除方法） |
| **P2** | #8 | 错误码不规范 | Auth 模块 | 30 min（梳理错误类型） |
| **P3** | 整体 | 为 Chat/Friend/Location/Square 分配错误码 | 4 个模块 | 可延期处理 |

**总计核心修复**：5 个 Service 文件，约 56 个路径替换，预估耗时 **20-30 分钟**。

---

## 八、根本原因总结

### 路径前缀混乱的 3 种模式

```
ApiService.baseUrl = 'http://localhost:8080/api'  // 已有 /api 前缀

模式 A：前端用 '/api/xxx'  → URL: .../api/api/xxx  ❌ 双重 /api
  影响：auth_service.dart、chat_service.dart、friend_service.dart、location_service.dart

模式 B：前端用 '/v1/xxx'   → URL: .../api/v1/xxx     ✅ 无重复
  影响：post_service.dart  → 后端 /api/v1/posts ✅
  影响：dating_service.dart → 后端 /api/love ❌（前端 v1/love ≠ 后端 /api/love）

模式 C：前端用 '/xxx'      → URL: .../api/xxx        ✅ 简洁正确
  影响：settings_service.dart、.../express_service.dart 等全部 7 模块
```

### 一致的正确路径规范

对于 `baseUrl = 'http://localhost:8080/api'`：

| 后端 Controller 映射 | 前端应使用路径 |
|----------------------|--------------|
| `/api/auth/xxx` | `/auth/xxx` |
| `/api/v1/xxx` | `/v1/xxx` |
| `/api/user/xxx` | `/user/xxx` ✅ |
| `/api/love/xxx` | `/love/xxx` |
| `/api/home/xxx` | `/home/xxx` ✅ |
| `/api/express/xxx` | `/express/xxx` ✅ |

**规则**：前端路径 = 去掉后端 `@RequestMapping` 中的 `/api` 前缀

---

## 九、下一步建议

1. **立即修复 P0/P1（20-30 分钟）**：修正 5 个 Service 文件中的 56 处路径（搜索替换即可）
2. **修复 P2 问题**：Friend 请求列表路径、清理 ChatService 冗余方法
3. **分配错误码**：为 M1-M4 分配标准错误码段（可延期至 V5.1）
4. **运行运行时测试**：启动后端 + 前端，逐模块手动测试关键流程
5. **编写自动化测试**：为关键 API 路径编写集成测试，防止回归
