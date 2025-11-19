import 'package:instant_tale/database/models/character.dart';
import 'package:instant_tale/network/apis/character_api.dart';
import 'package:isar/isar.dart';

import '../../network/api_exceptions.dart';
import '../../network/apis/api_service.dart';
import '../login/login_repository.dart';

class LoginRepository {
  final Isar _isar;
  final CharacterApi _api = ApiService().characterApi;

  LoginRepository(this._isar);

  Future<Character> addCharacter(String photo,String name,String desc) async {
    try {
      final response = await _api.addCharacter(photo, name, desc);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '登录失败');
      }
      // 保存到本地
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}