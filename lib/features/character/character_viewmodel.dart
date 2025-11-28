import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/character/character_repository.dart';
import 'package:instant_tale/features/character/character_state.dart';
import '../login/login_repository.dart';

class CharacterViewModel extends StateNotifier<CharacterState> {
  final CharacterRepository _characterRepository;

  CharacterViewModel(this._characterRepository) : super(CharacterState()) {
    _init();
  }

  void _init() {}

  void updateSearchKeyword(String s) {
    state = state.copyWith(searchKeyword: s);
    findCharacter();
  }

  Future<void> addCharacter(
    File characterPhoto,
    String characterName,
    String desc,
  ) async {
    state = state.copyWith(isLoading: true, message: '角色正在创建中，完成后会通知~');
    try {
      await _characterRepository.addCharacter(
        characterPhoto,
        characterName,
        desc,
      );
      state = state.copyWith(isLoading: false, message: '角色创建成功！');
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> deleteCharacter(String characterId) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.deleteCharacter(characterId);
      state = state.copyWith(isLoading: false, message: '删除成功');
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> updateCharacter(
    String characterId,
    String characterName,
    String desc,
  ) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.updateCharacter(
        characterId,
        characterName,
        desc,
      );
      state = state.copyWith(isLoading: false, message: '更新成功');
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> fetchCharacter() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.fetchCharacterList();
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> findCharacter() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final characterQueryData = await _characterRepository.findCharacterList(
        state.searchKeyword,
      );
      final list = characterQueryData.characters;
      if (characterQueryData.keyword == state.searchKeyword) {
        state = state.copyWith(
          isLoading: false,
          message: null,
          filteredList: list,
        );
      }
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> findCharacterById(String characterId) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.findCharacterListById(characterId);
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
}
