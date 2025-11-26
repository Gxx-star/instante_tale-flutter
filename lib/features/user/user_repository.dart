import 'dart:io';

import 'package:instant_tale/features/login/login_repository.dart';
import 'package:instant_tale/network/api_exceptions.dart';
import 'package:instant_tale/network/apis/api_service.dart';
import 'package:isar/isar.dart';

import '../../database/models/user.dart';
import '../../network/apis/user_api.dart';

class UserRepository{
  final Isar _isar;
  final UserApi _userApi = ApiService().userApi;
  UserRepository(this._isar);
  Future<void> updateAvatar(File file) async{
    try{
      final response = await _userApi.updateAvatar(file: file);
      if(response.code!= 200 || response.data==null){
        throw RepositoryException(response.message ?? '上传失败');
      }
      await _isar.writeTxn(() async{
        final user = await _isar.users.get(1);
        user?.avatar = response.data!;
        await _isar.users.put(user!);
      });
    }on ApiException catch (e){
      throw RepositoryException(e.message);
    }
  }
  Future<void> setPassword(String authCode,String newPassword) async{
    try{
      final response = await _userApi.setPassword(authCode, newPassword);
      if(response.code!= 200){
        throw RepositoryException(response.message ?? '修改失败');
      }
    }on ApiException catch (e){
      throw RepositoryException(e.message);
    }
  }
  Future<void> updateUserInfo(User user) async{
    try{
      final response = await _userApi.updateUserInfo(user);
      if(response.code!= 200 || response.data == null){
        throw RepositoryException(response.message ?? '修改失败');
      }
      // 更新数据库
      await _isar.writeTxn(() async{
        await _isar.users.put(response.data!);
      });
    }on ApiException catch (e){
      throw RepositoryException(e.message);
    }
  }
}