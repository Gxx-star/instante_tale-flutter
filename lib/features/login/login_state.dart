// 页面状态类：驱动 UI 渲染的所有状态
import '../../network/dto/login_data.dart';

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String loginMethod;
  final String phone;
  final String password;
  final String smsCode;
  final LoginData? loginData;

  // 构造函数（推荐用 copyWith 方法，方便状态更新）
  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.loginMethod = "phone",
    this.phone = "",
    this.password = "",
    this.smsCode = "",
    this.loginData,
  });

  // 状态更新方法
  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? loginMethod,
    String? phone,
    String? password,
    String? smsCode,
    LoginData? loginData,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      loginMethod: loginMethod ?? this.loginMethod,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      smsCode: smsCode ?? this.smsCode,
      loginData: loginData ?? this.loginData,
    );
  }
}