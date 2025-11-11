// book.dart

import 'package:isar/isar.dart';

part 'book.g.dart';

// 自定义对象：绘本
@collection
@Name('books')
class Book {
  Id id = Isar.autoIncrement; // 自增
  @Index()
  final String title; // 绘本标题
  final String type; // 类型：创意绘本/专属绘本

  Book({
    required this.id,
    required this.title,
    required this.type,
  });
}
