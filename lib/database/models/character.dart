import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';

part 'character.g.dart';
mixin CharacterFields {
  String characterId = '';
  String characterName = '';
  String desc = '';
  String avatarUrl = '';
  String threeViewUrl = '';
  String authorId = '';
  int createdAt = 0;
}
@embedded
class CharacterEmbedded with CharacterFields {
  CharacterEmbedded({
    String characterId = '',
    String characterName = '',
    String desc = '',
    String avatarUrl = '',
    String threeViewUrl = '',
    String authorId = '',
    int createdAt = 0,
  }) {
    this.characterId = characterId;
    this.characterName = characterName;
    this.desc = desc;
    this.avatarUrl = avatarUrl;
    this.threeViewUrl = threeViewUrl;
    this.authorId = authorId;
    this.createdAt = createdAt;
  }

  // 这里的 fromJson 返回的是嵌入版实例
  factory CharacterEmbedded.fromJson(Map<String, dynamic> json) {
    return CharacterEmbedded(
      characterId: json['character_id'] ?? '',
      characterName: json['character_name'] ?? '',
      desc: json['desc'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      threeViewUrl: json['three_view_url'] ?? '',
      authorId: json['author_id'] ?? '',
      createdAt: (json['created_at'] as num?)?.toInt() ?? 0,
    );
  }

  // CopyWith 返回嵌入版实例
  CharacterEmbedded copyWith({
    String? characterId,
    String? characterName,
    String? desc,
    String? avatarUrl,
    String? threeViewUrl,
    String? authorId,
    int? createdAt,
  }) {
    return CharacterEmbedded(
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
@collection
@Name('characterCollections')
class CharacterCollection with CharacterFields {
  // 必须：Isar 集合必须有一个整型 Id
  // 你的 characterId 是 String，所以这里需要一个额外的内部 ID
  Id id = Isar.autoIncrement;

  // 构造函数
  CharacterCollection({
    String characterId = '',
    String characterName = '',
    String desc = '',
    String avatarUrl = '',
    String threeViewUrl = '',
    String authorId = '',
    int createdAt = 0,
  }) {
    this.characterId = characterId;
    this.characterName = characterName;
    this.desc = desc;
    this.avatarUrl = avatarUrl;
    this.threeViewUrl = threeViewUrl;
    this.authorId = authorId;
    this.createdAt = createdAt;
  }

  // 集合版的 fromJson
  factory CharacterCollection.fromJson(Map<String, dynamic> json) {
    return CharacterCollection(
      characterId: json['character_id'] ?? '',
      characterName: json['character_name'] ?? '',
      desc: json['desc'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      threeViewUrl: json['three_view_url'] ?? '',
      authorId: json['author_id'] ?? '',
      createdAt: (json['created_at'] as num?)?.toInt() ?? 0,
    );
  }
  String get pinyinInitial {
    if (characterName.isEmpty) return '#';
    final pinyin = PinyinHelper.getPinyin(characterName, separator: '');
    return pinyin.isNotEmpty ? pinyin[0].toUpperCase() : '#';
  }
}
