import 'dart:io';

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

  Future<ApiResponse<void>> sendMsg({required String phone}) async {
    try {
      final data = {'phone_number': phone};
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

  Future<ApiResponse<String?>> updateAvatar({required File file}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await _dio.post('/user/uploadAvatar', data: formData);
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'],
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<void>> setPassword(
    String authCode,
    String newPassword,
  ) async {
    try {
      final data = {'auth_code': authCode, 'new_password': newPassword};
      final response = await _dio.post('/user/setPassword', data: data);

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
  Future<ApiResponse<User>> updateUserInfo(
      User user
      ) async {
    try {
      final data = {
        'nickname': user.name,
        'address': user.location,
        'introduction': user.personalProfile
      };
      final response = await _dio.post('/user/update', data: data);

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: User.fromJson(response.data['data']),
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
