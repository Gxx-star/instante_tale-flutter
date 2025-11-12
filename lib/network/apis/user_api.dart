import 'package:dio/dio.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/network/api_response.dart';
import 'package:instant_tale/network/http.dart';

import '../../database/dto/login_data.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<ApiResponse<LoginData>> login(String phone, String password) async {
    Response response = await _dio.post(
      '/user/login',
      data: {'phone': phone, 'authCode': password},
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    return ApiResponse(
      code: response.data['code'],
      message: response.data['message'],
      data: response.data['data'] == null ? null : LoginData.fromJson(response.data['data']),
    );
  }
}
