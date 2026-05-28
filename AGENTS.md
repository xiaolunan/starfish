# starfish

Flutter 项目（SDK ^3.8.0），单包结构，Android + iOS。

## 已知编译阻塞

必须先修复这些问题才能正常运行：

- `lib/main.dart` 引用了未定义的 `MyApp` widget 类
- `lib/http/dio_instance.dart:2` 和 `lib/http/socket/web_socket_instance.dart:3` 导入了 `package:starfish_http/...`，但实际包名是 `starfish`
- `lib/http/interceptor/token_interceptor.dart:6` 引用了本项目中不存在的 `SpUtils` 和 `Constants`

## 架构

- `lib/main.dart` — 入口，初始化 Dio + ScreenUtil
- `lib/http/` — 网络层（Dio 单例、拦截器链、BaseModel 封装、WebSocket）
  - `dio_instance.dart` — Dio 单例封装，支持 GET/POST，可切换 baseUrl
  - `interceptor/token_interceptor.dart` — 自动注入 token 请求头（依赖缺失）
  - `interceptor/print_log_interceptor.dart` — 请求/响应/错误日志打印
  - `interceptor/rsp_interceptor.dart` — 解析 BaseModel，按 code 分发
  - `socket/web_socket_instance.dart` — WebSocket 连接管理（含心跳）
- Widget / 状态层尚未构建

## 关键依赖

`provider`（状态管理）、`dio`（HTTP）、`flutter_screenutil`（屏幕适配）、`oktoast`（Toast）、`web_socket_channel`（WebSocket）

## 资源

- `assets/json/` — 4 个 mock JSON 文件
- `assets/images/`、`assets/glb/` — 目录存在但为空

## 测试

- `test/widget_test.dart` — 旧的模板测试，引用了不存在的 `MyApp` + counter，需要重写

## 命令

```bash
flutter analyze     # 静态分析
flutter test        # 运行测试
flutter run         # 连接设备运行
flutter build apk   # 构建 Android APK
```

无 CI、无代码生成、无数据库迁移、非 monorepo。
