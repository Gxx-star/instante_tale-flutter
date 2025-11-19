import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
@Name('users')
class User {
  Id id = 1;
  String userId;
  String avatar;
  String name;
  bool hasPassword;
  int createdAt;
  String phone;
  User({
    required this.userId,
    required this.avatar,
    required this.name,
    required this.hasPassword,
    required this.createdAt,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      avatar: json['avatar_url'],
      name: json['nickname'],
      phone: json['phone_number'],
      hasPassword: json['has_password'],
      createdAt: (json['created_at'] as num).toInt(),
    );
  }
  User copyWith({
    String? userId,
    String? avatar,
    String? name,
    bool? hasPassword,
    int? createdAt,
    String? phone,
  }){
    return User(
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      hasPassword: hasPassword ?? this.hasPassword,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}