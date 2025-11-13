import 'package:dio/dio.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/network/api_exceptions.dart';
import 'package:instant_tale/network/api_response.dart';
import 'package:instant_tale/network/http.dart';

import '../../database/dto/login_data.dart';

class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  Future<ApiResponse<LoginData>> login(String phone, String password) async {
    try {
      Response response = await _dio.post(
        '/user/login',
        data: {'phone': phone, 'authCode': password},
      );
      return ApiResponse(
        code: response.data['code'],
        message: response.data['message'],
        data: response.data['data'] != null ? LoginData.fromJson(response.data['data']): null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
