import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
@Name('users')
class User {
  Id id = Isar.autoIncrement; // 自增
  final String userId;
  final String avatar;
  final String name;
  final bool hasPassword;
  final int createdAt;

  User({
    required this.userId,
    required this.avatar,
    required this.name,
    required this.hasPassword,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      avatar: json['avatar_url'],
      name: json['nickname'],
      hasPassword: json['has_password'],
      createdAt: (json['created_at'] as num).toInt(),
    );
  }
}
