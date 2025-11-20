import 'dart:io';

import 'package:instant_tale/database/models/character.dart';
import 'package:instant_tale/network/apis/character_api.dart';
import 'package:isar/isar.dart';
import '../../network/api_exceptions.dart';
import '../../network/apis/api_service.dart';
import '../login/login_repository.dart';

class CharacterRepository {
  final Isar _isar;
  final CharacterApi _api = ApiService().characterApi;

  CharacterRepository(this._isar);

  Stream<List<Character>> watchCharacters() {
    return _isar.characters.where().watch(fireImmediately: true);
  }

  Future<Character> addCharacter(File photo, String name, String desc) async {
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

  Future<List<Character>> findCharacterList(String keyword) async {
    try {
      final response = await _api.findCharacterList(keyword);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
      // 保存到本地
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<void> deleteCharacter(String characterId) async {
    try {
      final response = await _api.deleteCharacter(characterId);
      if (response.code != 200) {
        throw RepositoryException(response.message ?? '删除失败');
      }
      // 保存到本地
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<Character> updateCharacter(
    String characterId,
    String name,
    String desc,
  ) async {
    try {
      final response = await _api.updateCharacter(characterId, name, desc);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '修改失败');
      }
      // 保存到本地
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}
