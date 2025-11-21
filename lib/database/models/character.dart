import 'package:isar/isar.dart';

part 'character.g.dart';

@collection
@Name('characters')
class Character {
  Id id = Isar.autoIncrement;
  String characterId;
  String characterName;
  String desc;
  String avatarUrl;
  String threeViewUrl;
  String authorId;
  int createdAt;
  Character({
    required this.characterId,
    required this.characterName,
    required this.desc,
    required this.avatarUrl,
    required this.threeViewUrl,
    required this.authorId,
    required this.createdAt,
  });
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      characterId: json['character_id'],
      characterName: json['character_name'],
      desc: json['desc'],
      avatarUrl: json['avatar_url'],
      threeViewUrl: json['three_view_url'],
      authorId: json['author_id'],
      createdAt: (json['created_at'] as num).toInt(),
    );
  }
  Character copyWith({
    String? characterId,
    String? characterName,
    String? desc,
    String? avatarUrl,
    String? threeViewUrl,
    String? authorId,
    int? createdAt,
  }){
    return Character(
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      desc: desc ?? this.desc,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      threeViewUrl: threeViewUrl ?? this.threeViewUrl,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}