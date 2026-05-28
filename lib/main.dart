import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'http/dio_instance.dart';

/// 应用入口函数
///
/// 初始化网络请求实例、屏幕适配，然后启动应用。
Future<void> main() async {
  // 初始化 Dio（网络请求库）单例，设置接口基础地址
  DioInstance.instance().initDio(baseUrl: "http://192.168.2.45:9900/");
  // 确保 ScreenUtil 在运行前完成屏幕尺寸初始化（适配不同分辨率）
  await ScreenUtil.ensureScreenSize();
  // 启动 Flutter 应用，根组件为 MyApp
  runApp(const MyApp());
}
