import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/network/apis/api_service.dart';
import 'package:isar/isar.dart';
import '../../network/apis/user_api.dart';

class LoginRepository {
  final Isar isar;
  final UserApi api = ApiService().userApi;

  LoginRepository(this.isar);

  Future<String?> login(String phone, String password) async {
    final response = await api.login(phone, password);
    if (response.code == 200 && response.data != null) {
      await AppGlobals().saveToken(response.data!.token);
      return response.data?.token;
    } else {
      throw Exception(response.message);
    }
  }
}
