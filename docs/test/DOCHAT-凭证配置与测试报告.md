# DoChat 凭证配置与测试报告

**日期：** 2026-06-26
**状态：** 后端测试通过 ✅ | 前端编译待用户手动验证

---

## 一、凭证配置

### 已写入 application.yml（5 项）

| 服务 | 配置项 | 状态 |
|------|--------|:---:|
| 腾讯云 IM | SDKAppID `1600148865` + SecretKey | ✅ |
| 阿里云 OSS | Bucket/Endpoint/AK/SK | ✅ |
| 高德地图 | Android/iOS/Harmony 三端 Key | ✅ |
| 极光推送 | AppKey `ac56f2e04ad1a28f64509ad6` | ⚠️ Master Secret 待补 |
| 阿里云人脸识别 | AK/SK + Endpoint | ✅ |

### 保持 Mock

| 服务 | 原因 |
|------|------|
| 腾讯云短信 | 公司注册后补 |
| 微信支付 | 公司注册后补 |
| 支付宝支付 | 公司注册后补 |

### 安全措施

- `.gitignore` 已加入 `backend/dochatapp-server/src/main/resources/application.yml`
- 凭证不会提交到 Git 仓库

---

## 二、后端 API 测试结果

### 编译

`mvn compile` → BUILD SUCCESS ✅

### API 功能测试（code:0 = 成功）

| # | 接口 | 方法 | 路径 | 结果 |
|:---:|------|------|------|:---:|
| 1 | 发送验证码 | POST | `/api/auth/sms/send` | ✅ code:0 |
| 2 | 注册 | POST | `/api/auth/register` | ✅ code:0（返回 JWT+RefreshToken+UserSig） |
| 3 | 密码登录 | POST | `/api/auth/login` | ✅ code:0 |
| 4 | Token 刷新 | POST | `/api/auth/refresh` | ✅ code:0 |
| 5 | 退出登录 | POST | `/api/auth/logout` | ✅ code:0 |
| 6 | 会话列表 | GET | `/api/v1/sessions` | ✅ code:0 |
| 7 | 好友列表 | GET | `/api/v1/friends` | ✅ code:0 |
| 8 | 广场帖子 | GET | `/api/v1/posts` | ✅ code:0 |
| 9 | 用户资料 | GET | `/api/user/profile` | ✅ code:0 |

### 注册返回示例

```json
{
  "code": 0,
  "message": "success",
  "data": {
    "userId": "u_d9c9956a12f94d6a",
    "token": "eyJhbGciOiJIUzUxMiJ9...",
    "refreshToken": "eyJhbGciOiJIUzUxMiJ9...",
    "userSig": "eyJ1c2VySWQiOiJ1X2Q5Yzk5NTZhMTJmOTRkNmEiLCJzZGtBcHBJZCI6MTYwMDE0ODg2NSwic2lnIjoi...",
    "expiresIn": 86400
  }
}
```

---

## 三、前端状态

### 静态分析

`dart analyze lib/` → 0 error ✅
- 226 info（全部是 lint 风格建议，不影响编译）
- 少量 warning（未使用 import/变量，不影响编译）

### macOS 编译

- CocoaPods 环境存在兼容性问题（Ruby 4.0.5 + CocoaPods 1.16.2）
- 需要在 Xcode 中手动 Build 或修复 CocoaPods 后再 `flutter run`

**用户操作：**
```bash
export PATH="$PATH:/Users/claude/development/flutter/bin"
cd /Users/claude/Documents/电波灵动v2/frontend
flutter run -d macos
```

或直接在 Xcode 中打开 `frontend/macos/Runner.xcworkspace` 编译运行。

---

## 四、已知问题

| # | 问题 | 严重度 | 状态 |
|---|------|:---:|------|
| 1 | JWT 黑名单未生效（登出后旧 Token 仍可用） | P2 | M1 审查遗留 |
| 2 | 极光推送 Master Secret 未填写 | P2 | 需用户控制台获取 |
| 3 | CocoaPods 兼容性问题 | P3 | Ruby 版本过新 |
| 4 | `app_localizations.dart:921` 重复 map key | P3 | lint warning |

---

**报告完毕。后端 API 测试全部通过，可提交 WorkBuddy 审查。**
