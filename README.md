# Dochat（电波灵动）

> 极简联络，一诺可守

超级社交协作平台 = 即时通讯底座 + 七大生态

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | Flutter 3.x (Dart) + Swift/Kotlin（原生桥接） |
| 后端 | Spring Boot 3.x (Java 17) |
| 数据库 | PostgreSQL 16 |
| 缓存 | Redis 7.x |
| 即时通讯 | 腾讯 IM SDK (SDKAppID: 1600148063) |
| 地图 | 高德地图 SDK |
| 支付 | 支付宝/微信支付（预留） |

## 目录结构

```
Dochat/
├── legacy/          # 旧代码归档（只读参考）
├── backend/         # Spring Boot 后端
├── frontend/        # Flutter 前端
├── docs/            # 项目文档
└── scripts/         # 自动化脚本
```

## 开发环境

- Mac Studio (M1 Max, 32GB, 512GB)
- 双屏：34寸主屏 + 24寸副屏

## 设计风格

- iOS 原生风格（Cupertino 组件库）
- 对标微信、Telegram、iOS 系统 App
- 主色：#007AFF（品牌蓝）

## 进度

🚧 开发中
