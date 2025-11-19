import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:instant_tale/features/login/login_repository.dart';
import 'package:instant_tale/features/user/user_repository.dart';
import 'package:instant_tale/features/user/user_state.dart';
import 'package:isar/isar.dart';

class UserViewModel extends StateNotifier<UserState> {
  final UserRepository _userRepository;
  final _isar = AppGlobals().isar;
  late final StreamSubscription _sub;
  UserViewModel(this._userRepository) : super(UserState()) {
    _init();
  }
  void updateUser(User user){
    state = state.copyWith(user: user);
  }
  void _init() {
    _sub = _isar.users.watchLazy().listen((_)async{
      state = state.copyWith(
        user: await _isar.users.where().idEqualTo(1).findFirst()
      );
    });
  }
  Future<void> updateUserAvatar(File file) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      state = state.copyWith(
        isLoading: false,
        message: '更换头像成功'
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
  Future<void> setPassword(String authCode,String newPassword) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _userRepository.setPassword(authCode, newPassword);
      state = state.copyWith(
        isLoading: false,
        message: '修改密码成功'
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
  Future<void> updateUserInfo(String newNickName) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _userRepository.updateUserInfo(newNickName);
      state = state.copyWith(
          isLoading: false,
          message: '修改信息成功'
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
  @override
  Future<void> dispose() async {
    _sub.cancel();
    super.dispose();
  }
}
