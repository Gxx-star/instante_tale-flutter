// 页面状态类：驱动 UI 渲染的所有状态
import '../../network/dto/login_data.dart';

class LoginState {
  final bool isLoading;
  final String? message;
  final String loginMethod;
  final String phone;
  final String password;
  final String smsCode;
  final LoginData? loginData;
  LoginState({
    this.isLoading = false,
    this.message,
    this.loginMethod = "pwd",
    this.phone = "15633008625",
    this.password = "123456789",
    this.smsCode = "",
    this.loginData,
  });

  LoginState copyWith({
    bool? isLoading,
    String? message,
    String? loginMethod,
    String? phone,
    String? password,
    String? smsCode,
    LoginData? loginData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      loginMethod: loginMethod ?? this.loginMethod,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      smsCode: smsCode ?? this.smsCode,
      loginData: loginData ?? this.loginData,
    );
  }
}