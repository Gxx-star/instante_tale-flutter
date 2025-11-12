import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/login/login_repository.dart';

class LoginViewModel extends StateNotifier<String> {
  final LoginRepository _loginRepository;

  LoginViewModel(this._loginRepository) : super("") {
    _init();
  }

  void _init() {}

  Future<bool> login(String phoneNumber, String password) async {
    try {
      String? token = await _loginRepository.login(phoneNumber, password);
      return token != null;
    } catch (e, st) {
      state = "error";
      return false;
    }
  }
}
