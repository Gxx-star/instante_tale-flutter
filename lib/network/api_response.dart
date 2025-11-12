  import 'package:dio/src/dio_exception.dart';
import 'package:instant_tale/database/dto/login_data.dart';

class ApiResponse<T> {
    final int code;
    final String message;
    final T? data;

    ApiResponse({required this.code, required this.message, this.data});

    factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) convert) {
      return ApiResponse(
        code: json['code'],
        message: json['msg'],
        data: json['data'] == null ? null : convert(json['data']),
      );
    }

    factory ApiResponse.fromDioError(DioException error) {
      return ApiResponse(
        code: error.response?.statusCode ?? 0,
        message: error.message ?? '',
        data: null,
      );
    }
  }
