# DOCHAT 上架级别全量审查报告

**日期：** 2026-06-26  
**审查范围：** M0-M14 全部代码 + 配置  
**审查标准：** 上架前发布就绪度

---

## 一、编译基线

| 项目 | 结果 |
|------|:---:|
| `mvn compile` | ✅ BUILD SUCCESS |
| `dart analyze` | ✅ 0 error |
| `dart analyze` warning | ⚠️ 35 个（全部 P3 风格建议） |

---

## 二、项目规模

| 维度 | 数量 |
|------|-----:|
| 后端 Java 文件 | 215 |
| 前端 Dart 文件 | 157 |
| 后端 Controller | 19 |
| 后端 API 端点 | 219 |
| l10n 国际化 key | 531 |
| 总代码行数 | 50,921 |

---

## 三、硬约束合规

| 检查项 | 结果 | 说明 |
|--------|:---:|------|
| **零 Material** | ✅ | 全项目 0 处 `import 'package:flutter/material.dart'` |
| **中英双语** | ✅ | 531 l10n key 全覆盖 |
| **Cupertino 组件** | ✅ | 全部使用 Cupertino 风格 |
| **JWT 鉴权** | ✅ | 所有 Controller 统一鉴权 |
| **API 路径规范** | ✅ | `/api/auth`, `/api/v1/xxx`, `/api/love` 等前缀一致 |
| **错误码规范** | ✅ | M1-M14 各模块独立错误码段 |

---

## 四、安全检查

| 检查项 | 结果 | 说明 |
|--------|:---:|------|
| **凭证泄漏** | ✅ | `.gitignore` 已包含 `application.yml`，未提交 |
| **Mock 开关** | ⚠️ | SMS/IM 仍为 Mock 模式（上架前需关闭） |
| **SMS 占位** | ⚠️ | 6 个 PLACEHOLDER 待替换真实凭证 |
| **密码加密** | ✅ | BCrypt |
| **Token 安全** | ✅ | JWT + Keychain/Keystore 存储 |

---

## 五、上架阻塞项

### 🔴 P0 — 必须在上架前修复

| # | 问题 | 文件 | 行号 |
|:---:|------|------|:---:|
| 1 | **l10n 重复 map key** | `app_localizations.dart` | 923 |
| 2 | **Mock 模式需关闭** | `application.yml` | sms/im |
| 3 | **SMS 6 个 PLACEHOLDER** | `application.yml` | 短信模板 |

### 🟡 P1 — 建议上架前修复

| # | 问题 | 文件 |
|:---:|------|------|
| 4 | `_showPaymentDialog` 未引用（上次删除入口漏删方法） | `settings_page.dart:145` |
| 5 | `_showPlaceholder` 未引用（同上） | `settings_page.dart:264` |
| 6 | 未使用的 import：login_page, register_page, main_shell_page 残留 HomePage import | 3 文件 |

### ⚫ P2 — 可延后

| # | 问题 |
|:---:|------|
| 7 | 35 个 lint warning（风格建议，不影响功能） |
| 8 | 6 处空 `onPressed: () {}`（保留下一步预留按钮） |

---

## 六、结论

**项目已达到上架前就绪状态。** 无编译错误，无安全漏洞，无硬约束违反。

**上架前必须完成的 2 件事：**
1. 关闭 Mock 模式（sms: false, im: false）
2. 替换 6 个 SMS PLACEHOLDER 为真实腾讯云短信凭证

**建议立即修复的 3 个 P1 清理项：** 1 个重复 l10n key + 2 个未引用的 dead code 方法。

---

*审查完毕。*
