import 'package:isar/isar.dart';

import '../../database/models/book.dart';

class BookRepository {
  final Isar isar;
  BookRepository(this.isar);

  Stream<List<Book>> watchAllBooks() {
    return isar.books.where().watch(fireImmediately: true);
  }

  Future<void> addBook(Book book) async {
    await isar.writeTxn(() async {
      await isar.books.put(book);
    });
  }

  Future<void> deleteBook(int bookId) async {
    await isar.writeTxn(() async {
      await isar.books.delete(bookId);
    });
  }
}
