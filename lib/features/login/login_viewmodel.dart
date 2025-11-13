import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/login/login_repository.dart';

import '../../database/dto/login_data.dart';

class LoginViewModel extends StateNotifier<AsyncValue<LoginData?>> {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository) : super(AsyncValue.data(null)) {
    _init();
  }

  void _init() {}

  Future<void> login(String phone, String password) async {
    state = AsyncValue.loading();
    try {
      final loginData = await _loginRepository.login(phone, password);
      state = AsyncValue.data(loginData);
    } on RepositoryException catch (e) {
      state = AsyncValue.error(e.message, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error('未知错误', StackTrace.current);
    }
  }
}
