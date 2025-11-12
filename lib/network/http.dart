import 'package:dio/dio.dart';
import 'package:instant_tale/network/api_interceptor.dart';

class Http {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.31.196:8080',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Dio get dio => _dio;

  static void init() {
    _dio.interceptors.addAll([
      // 日志拦截器
      LogInterceptor(request: true, requestBody: true, responseBody: true),
      // 防重复请求
      RepeatRequestInterceptor(),
      // token
      TokenInterceptor(),
    ]);
  }
}
