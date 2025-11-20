import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/character/character_repository.dart';
import 'package:instant_tale/features/character/character_state.dart';

import '../../database/models/character.dart';
import '../login/login_repository.dart';

class CharacterViewModel extends StateNotifier<CharacterState> {
  final CharacterRepository _characterRepository;

  CharacterViewModel(this._characterRepository) : super(CharacterState()) {
    _init();
  }

  void _init() {}

  Future<void> addCharacter(
    File characterPhoto,
    String characterName,
    String desc,
  ) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.addCharacter(
        characterPhoto,
        characterName,
        desc,
      );
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
  Future<void> deleteCharacter(
      String characterId
      ) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.deleteCharacter(
        characterId,
      );
      state = state.copyWith(isLoading: false, message: null);
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
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
  Future<void> fetchCharacter() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _characterRepository.findCharacterList('');
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
}
