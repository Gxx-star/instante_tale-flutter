import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/network/api_exceptions.dart';
import 'package:instant_tale/network/apis/api_service.dart';
import 'package:isar/isar.dart';
import '../../database/dto/login_data.dart';
import '../../network/apis/user_api.dart';

class LoginRepository {
  final Isar _isar;
  final UserApi _api = ApiService().userApi;

  LoginRepository(this._isar);

  Future<LoginData> login(String phone, String password) async {
    try {
      final response = await _api.login(phone, password);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(
          response.message.isEmpty ? '登录失败' : response.message,
        );
      }
      await AppGlobals().saveToken(response.data!.token);
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException('网络错误：${e.message}');
    }
  }
}

class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);
}
