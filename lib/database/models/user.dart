import 'package:isar/isar.dart';
part 'user.g.dart';
@collection
@Name('users')
class User{
  Id id = Isar.autoIncrement; // 自增

  final String avatar;
  final String name;

  User({
    required this.id,
    required this.avatar,
    required this.name,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
    );
  }
}