import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'http/dio_instance.dart';

Future<void> main() async {
  DioInstance.instance().initDio(baseUrl: "http://192.168.2.45:9900/");
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}
