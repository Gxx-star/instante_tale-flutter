import 'package:dio/dio.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/network/api_exceptions.dart';
import 'package:instant_tale/network/api_response.dart';
import 'package:instant_tale/network/http.dart';

import '../dto/login_data.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<ApiResponse<LoginData>> login({
    required String phone,
    required String loginMethod,
    String? password,
    String? authCode,
  }) async {
    try {
      final data = {
        'phone_number': phone,
        'login_method': loginMethod,
        if (loginMethod == 'pwd') 'password': password,
        if (loginMethod != 'pwd') 'auth_code': authCode,
      };
      final response = await _dio.post('/user/login', data: data);

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? LoginData.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
  Future<ApiResponse<void>> sendMsg({
    required String phone,
  }) async {
    try {
      final data = {
        'phone_number': phone,
      };
      final response = await _dio.post('/user/sendMsg', data: data);

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
