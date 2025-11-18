import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/network/api_exceptions.dart';
import 'package:instant_tale/network/api_response.dart';
import 'package:instant_tale/network/apis/api_service.dart';
import 'package:isar/isar.dart';
import '../../network/dto/login_data.dart';
import '../../network/apis/user_api.dart';

class LoginRepository {
  final Isar _isar;
  final UserApi _api = ApiService().userApi;

  LoginRepository(this._isar);

  Future<LoginData> loginWithPwd({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _api.login(
        phone: phone,
        loginMethod: 'pwd',
        password: password,
      );
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '登录失败');
      }
      await AppGlobals().saveToken(response.data!.token);
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<LoginData> loginWithSms({
    required String phone,
    required String authCode,
  }) async {
    try {
      final response = await _api.login(
        phone: phone,
        loginMethod: 'sms',
        authCode: authCode,
      );
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '登录失败');
      }
      await AppGlobals().saveToken(response.data!.token);
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
  Future<void> sendMsg({
    required String phone,
  }) async {
    try {
      final response = await _api.sendMsg(
        phone: phone
      );
      if (response.code != 200) {
        throw RepositoryException(response.message ?? '登录失败');
      }
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}

class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);
}
