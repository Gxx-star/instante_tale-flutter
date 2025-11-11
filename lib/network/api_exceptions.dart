import 'package:dio/dio.dart';

/// 统一异常类
class ApiException implements Exception {
  final int? code;        // 业务错误码（后端返回的）
  final String message;   // 错误提示信息
  final DioException? origin; // 原始 Dio 异常（可选）

  ApiException(this.code, this.message, {this.origin});

  @override
  String toString() => 'ApiException(code: $code, message: $message)';
}

/// 异常转换工具：把 DioException -> ApiException
class ExceptionHandler {
  static ApiException handle(dynamic error) {
    if (error is ApiException) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException(-1, "连接超时", origin: error);
        case DioExceptionType.sendTimeout:
          return ApiException(-1, "请求超时", origin: error);
        case DioExceptionType.receiveTimeout:
          return ApiException(-1, "响应超时", origin: error);
        case DioExceptionType.badResponse:
        // 处理服务端响应错误
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return ApiException(401, "登录失效，请重新登录", origin: error);
          } else if (statusCode == 403) {
            return ApiException(403, "没有权限访问", origin: error);
          } else if (statusCode == 404) {
            return ApiException(404, "请求地址不存在", origin: error);
          } else {
            final msg = error.response?.data?['msg'] ?? '服务器错误';
            final code = error.response?.data?['code'] ?? statusCode;
            return ApiException(code, msg.toString(), origin: error);
          }
        case DioExceptionType.cancel:
          return ApiException(-1, "请求已取消", origin: error);
        default:
          return ApiException(-1, "网络错误，请检查您的网络连接", origin: error);
      }
    } else {
      return ApiException(-1, error.toString());
    }
  }
}
