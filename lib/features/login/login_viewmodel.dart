import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/login/login_repository.dart';
import 'package:instant_tale/features/login/login_state.dart';

import '../../network/dto/login_data.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository) : super(LoginState()) {
    _init();
  }

  void _init() {}

  void updatePhone(String value) {
    state = state.copyWith(phone: value, errorMessage: null);
  }

  void updateSmsCode(String value) {
    state = state.copyWith(smsCode: value, errorMessage: null);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, errorMessage: null);
  }

  void switchLoginMethod(String method) {
    state = state.copyWith(loginMethod: method, errorMessage: null);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      LoginData data;
      if (state.loginMethod == "sms") {
        data = await _loginRepository.loginWithSms(
          phone: state.phone,
          authCode: state.smsCode,
        );
      } else {
        data = await _loginRepository.loginWithPwd(
          phone: state.phone,
          password: state.password,
        );
      }
      state = state.copyWith(
        isLoading: false,
        loginData: data,
        errorMessage: null,
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
