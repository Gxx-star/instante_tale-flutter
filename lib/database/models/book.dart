// book.dart

import 'package:instant_tale/database/models/page.dart';
import 'package:isar/isar.dart';

part 'book.g.dart';

@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement;
  String bookId;
  String bookName;
  String coverUrl;
  int createdAt;
  List<Page> content;

  Book({
    required this.bookId,
    required this.bookName,
    required this.coverUrl,
    required this.createdAt,
    required this.content,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'],
      bookName: json['book_name'],
      coverUrl: json['cover_url'],
      createdAt: json['created_at'],
      content: json['content'],
    );
  }
}
