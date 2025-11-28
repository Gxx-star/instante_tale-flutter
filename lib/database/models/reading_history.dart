
import 'package:isar/isar.dart';

import 'book.dart';
part 'reading_history.g.dart';
@Collection()
class ReadingHistory {
  Id id = Isar.autoIncrement;   // 主键
  late String bookId;              // 对应 Book 的 id
  DateTime? lastReadAt;         // 最后阅读时间
}
class ReadingHistoryItem{
  final Book book;
  final ReadingHistory readingHistory;
  ReadingHistoryItem(this.book, this.readingHistory);
}