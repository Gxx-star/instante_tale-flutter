import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:instant_tale/database/models/book.dart';
import 'package:instant_tale/database/models/user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// 全局单例，用于保存全局状态和工具实例
class AppGlobals {
  AppGlobals._internal();

  static final AppGlobals _instance = AppGlobals._internal();

  factory AppGlobals() => _instance;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? globalToken;
  Isar? _isar;

  bool get isLoggedIn => globalToken != null && globalToken!.isNotEmpty;
  //bool  get isLoggedIn => true;
  Isar get isar {
    if (_isar == null) {
      throw Exception("Isar尚未初始化，请先调用init()");
    }
    return _isar!;
  }

  Future<void> init() async {  // 初始化全局状态
    _secureStorage.delete(key: 'token');
    // 从本地安全存储中恢复 token
    globalToken = await _secureStorage.read(key: 'token');
    final dir = await getApplicationCacheDirectory();
    _isar = await Isar.open([BookSchema, UserSchema], directory: dir.path);
  }

  Future<void> saveToken(String token) async {
    globalToken = token;
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<void> clearTokens() async {
    globalToken = null;
    await _secureStorage.deleteAll();
  }
}
