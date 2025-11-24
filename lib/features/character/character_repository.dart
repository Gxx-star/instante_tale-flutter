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

  Stream<List<CharacterCollection>> watchCharacters() {
    return _isar.characterCollections.where().watch(fireImmediately: true);
  }

  Future<CharacterCollection> addCharacter(File photo, String name, String desc) async {
    try {
      final response = await _api.addCharacter(photo, name, desc);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '登录失败');
      }
      await _isar.writeTxn(() async {
        await _isar.characterCollections.put(response.data!);
      });
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
  // 同步角色列表
  Future<List<CharacterCollection>> fetchCharacterList() async {
    try {
      final response = await _api.findCharacterList("");
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
      await _isar.writeTxn(() async {
        await _isar.characterCollections.clear();
        await _isar.characterCollections.putAll(response.data!);
      });
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
  Future<List<CharacterCollection>> findCharacterList(String keyword) async {
    try {
      final response = await _api.findCharacterList(keyword);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
  Future<List<CharacterCollection>> findCharacterListById(String characterId) async {
    try {
      final response = await _api.findCharacterListById(characterId);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
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
      await _isar.writeTxn(() async {
        await _isar.characterCollections.filter().characterIdEqualTo(characterId).deleteAll();
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<CharacterCollection> updateCharacter(
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
      await _isar.writeTxn(() async {
        await _isar.characterCollections.put(response.data!);
      });
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}
