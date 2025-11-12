import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/models/book.dart';
import 'book_repository.dart';

class BookViewModel extends StateNotifier<AsyncValue<List<Book>>> {
  final BookRepository repository;

  BookViewModel(this.repository) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    repository.watchAllBooks().listen((books) {
      state = AsyncValue.data(books);
    });
  }

  Future<void> addBook(Book book) async {
    try {
      await repository.addBook(book); // Repository 执行数据库操作
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBook(int id) async {
    try {
      await repository.deleteBook(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
