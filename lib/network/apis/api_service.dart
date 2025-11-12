import 'package:instant_tale/network/apis/user_api.dart';

import '../http.dart';

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
}
