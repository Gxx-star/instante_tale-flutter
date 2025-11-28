import 'package:instant_tale/database/models/page.dart';
import 'package:isar/isar.dart';

import 'character.dart';

part 'book.g.dart';

@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement;
  @Index()
  String bookId;
  String bookName;
  String coverUrl;
  int createdAt;
  List<BookPage> content;
  List<CharacterEmbedded>characters;
  Book({
    required this.bookId,
    required this.bookName,
    required this.coverUrl,
    required this.createdAt,
    required this.content,
    required this.characters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<BookPage> content = (json['content'] as List)
        .map((e) => BookPage.fromJson(e))
        .toList();
    List<CharacterEmbedded> characters = (json['characters'] as List)
        .map((e) => CharacterEmbedded.fromJson(e))
        .toList();
    return Book(
      bookId: json['book_id'],
      bookName: json['book_name'],
      coverUrl: json['cover_url'],
      createdAt: (json['created_at'] as double).toInt() ,
      content: content,
      characters: characters
    );
  }
}
