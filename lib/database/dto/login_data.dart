

class LoginData {
  final bool is_first;
  final String token;

  LoginData({required this.is_first, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    // 拆分 User 和 token
    final userJson = Map<String, dynamic>.from(json)..remove('token');
    return LoginData(
      is_first: json['is-first'],
      token: json['token'] as String,
    );
  }
}
