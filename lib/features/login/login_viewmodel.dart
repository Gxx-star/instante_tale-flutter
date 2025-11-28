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
  void logout(){
    state = state.copyWith(loginData: null,message: null);
  }
  void clearMessage() {
    state = state.copyWith(message: null);
  }
  void updatePhone(String value) {
    state = state.copyWith(phone: value, message: null);
  }

  void updateSmsCode(String value) {
    state = state.copyWith(smsCode: value, message: null);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, message: null);
  }

  void switchLoginMethod(String method) {
    state = state.copyWith(loginMethod: method, message: null);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, message: null);
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
        message: '欢迎回来',
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> sendMsg() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _loginRepository.sendMsg(phone: state.phone);
      state = state.copyWith(isLoading: false, message: '发送成功');
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }
}
