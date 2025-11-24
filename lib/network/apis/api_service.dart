import 'package:instant_tale/network/apis/character_api.dart';
import 'package:instant_tale/network/apis/user_api.dart';

import '../http.dart';
import 'book_api.dart';

class ApiService {

  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() {
    return _instance;
  }

  UserApi? _userApi;
  UserApi get userApi {
    _userApi ??= UserApi(Http.dio);
    return _userApi!;
  }
  CharacterApi? _characterApi;
  CharacterApi get characterApi {
    _characterApi ??= CharacterApi(Http.dio);
    return _characterApi!;
  }
  BookApi? _bookApi;
  BookApi get bookApi {
    _bookApi ??= BookApi(Http.dio);
    return _bookApi!;
  }
}
