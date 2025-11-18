

import 'dart:ffi';

import '../../database/models/user.dart';

class LoginData {
  final String token;
  final int expiresIn;
  final User user;

  LoginData({required this.token, required this.expiresIn, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      user: User.fromJson(json['user_info']),
    );
  }
}
