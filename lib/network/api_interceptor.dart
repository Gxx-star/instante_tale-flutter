import 'package:dio/dio.dart';
import 'package:instant_tale/app_globals.dart';

/// 每次请求自动加Authorization
/// 检测401自动刷新token
/// 刷新后重新发送请求
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppGlobals().globalToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await AppGlobals().clearTokens();
      // 跳转到登录页
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: '登录已过期，请重新登录',
          type: DioExceptionType.badResponse,
          response: err.response,
        ),
      );
    }
    handler.next(err);
  }
}

/// 防重复提交
class RepeatRequestInterceptor extends Interceptor {
  final _requestSet = <String>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = '${options.method}_${options.path}_${options.data}';
    if (_requestSet.contains(key)) {
      return handler.reject(
        DioException(requestOptions: options, error: '重复请求被拦截'),
      );
    }
    _requestSet.add(key);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _requestSet.remove(
      '${response.requestOptions.method}_${response.requestOptions.path}_${response.requestOptions.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _requestSet.remove(
      '${err.requestOptions.method}_${err.requestOptions.path}_${err.requestOptions.data}',
    );
    handler.next(err);
  }
}

