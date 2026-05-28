import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

import '../base_model.dart';

/// 响应拦截器：统一处理后端返回数据，提取 content 或抛出异常
class RspInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // HTTP 状态码 200 才继续处理，否则直接拒绝
    if (response.statusCode == 200) {
      try {
        // 尝试解析后端统一响应格式 BaseModel
        var baseData = BaseModel.fromJson(response.data);

        int? code = baseData.code;
        if (code == null) {
          // code 为空，视为非法响应
          handler.reject(DioException(requestOptions: response.requestOptions));
        } else {
          if (code == 200) {
            // 业务成功，取出 content 传给下一个拦截器
            handler.next(Response(requestOptions: response.requestOptions, data: baseData.content));
          } else if (code == 210 &&
              response.requestOptions.path.contains("getAppInfo") == false &&
              response.requestOptions.path.contains("bindToken") == false &&
              response.requestOptions.path.contains("getImSign") == false) {
            // 需要登录（排除登录相关接口，避免循环跳转）
            handler.reject(DioException(requestOptions: response.requestOptions));
            showToast(baseData.message ?? "系统错误");
            // RouteUtils.pushForNamed(RouteUtils.context, RoutePath.auth);
          } else {
            // 其他业务错误
            if (response.requestOptions.path.contains("getAppInfo") == false) {
              showToast(baseData.message ?? "系统错误");
            }
            handler.reject(DioException(requestOptions: response.requestOptions));
          }
        }
      } catch (e) {
        // 解析异常，直接拒绝
        handler.reject(DioException(requestOptions: response.requestOptions));
      }
    } else {
      // 非 200 HTTP 状态码，拒绝请求
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
