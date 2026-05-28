import 'package:dio/dio.dart';
import 'http_method.dart';
import 'interceptor/print_log_interceptor.dart';
import 'interceptor/rsp_interceptor.dart';
import 'interceptor/token_interceptor.dart';

/// Dio 网络请求单例封装
///
/// 提供 GET/POST 请求、拦截器链注册、BaseOptions 构建及 baseUrl 切换能力。
/// 使用前必须调用 [initDio] 完成初始化。
class DioInstance {
  static DioInstance? _instance;

  /// 私有构造，禁止外部直接实例化
  DioInstance._internal();

  /// 获取单例实例（懒加载）
  static DioInstance instance() {
    return _instance ??= DioInstance._internal();
  }

  /// Dio 核心实例
  Dio _dio = Dio();

  /// 默认超时时间 30 秒
  final _defaultTimeout = const Duration(seconds: 30);

  /// 是否已调用 [initDio]
  var _inited = false;

  /// 初始化 Dio 配置及拦截器链
  ///
  /// [baseUrl] 接口基地址
  /// [method] 默认请求方法，默认 GET
  /// [connectTimeout] 连接超时，默认 30s
  /// [receiveTimeout] 接收超时，默认 30s
  /// [sendTimeout] 发送超时，默认 30s
  /// [responseType] 响应数据类型，默认 JSON
  /// [contentType] 请求 Content-Type
  ///
  /// 拦截器注册顺序：TokenInterceptor → PrintLogInterceptor → RspInterceptor
  void initDio({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async {
    _dio.options = buildBaseOptions(
        method: method,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTimeout,
        receiveTimeout: receiveTimeout ?? _defaultTimeout,
        sendTimeout: sendTimeout ?? _defaultTimeout,
        responseType: responseType,
        contentType: contentType);
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(PrintLogInterceptor());
    _dio.interceptors.add(RspInterceptor());

    _inited = true;
  }

  /// GET 请求
  ///
  /// [path] 请求路径（相对 baseUrl）
  /// [param] 查询参数
  /// [options] 额外请求配置
  /// [cancelToken] 取消令牌
  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_inited) {
      throw Exception("you should call initDio() first!");
    }
    return await _dio.get(path,
        queryParameters: param,
        options: options ??
            Options(
              method: HttpMethod.GET,
              receiveTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
            ),
        cancelToken: cancelToken);
  }

  /// POST 请求
  ///
  /// [path] 请求路径（相对 baseUrl）
  /// [data] 请求体数据
  /// [queryParameters] URL 查询参数
  /// [options] 额外请求配置
  /// [cancelToken] 取消令牌
  Future<Response> post(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    if (!_inited) {
      throw Exception("you should call initDio() first!");
    }
    return await _dio.post(path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options ??
            Options(
              method: HttpMethod.POST,
              receiveTimeout: _defaultTimeout,
              sendTimeout: _defaultTimeout,
            ));
  }

  /// 构建 [BaseOptions] 配置对象
  ///
  /// 参数默认值与 [initDio] 一致
  BaseOptions buildBaseOptions({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    return BaseOptions(
        method: method,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? _defaultTimeout,
        receiveTimeout: receiveTimeout ?? _defaultTimeout,
        sendTimeout: sendTimeout ?? _defaultTimeout,
        responseType: responseType,
        contentType: contentType);
  }

  /// 动态切换 baseUrl
  ///
  /// 适用于多环境部署场景
  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
