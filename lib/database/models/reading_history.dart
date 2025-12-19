import 'package:isar/isar.dart';

import 'book.dart';

part 'reading_history.g.dart';

@Collection()
class ReadingHistory {
  Id id = Isar.autoIncrement; // 主键
  @Index()
  late String userId; // 用户 id
  @Index()
  late String bookId; // 对应 Book 的 id
  late String bookName;
  late String bookCover;
  DateTime? lastReadAt; // 最后阅读时间
}
