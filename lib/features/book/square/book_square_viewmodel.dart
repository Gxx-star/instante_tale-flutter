import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/models/book.dart';
import '../../../network/dto/book_data.dart';
import '../book_repository.dart';
import 'book_square_state.dart';

class BookSquareViewModel extends StateNotifier<BookSquareState> {
  final BookRepository _bookRepository;

  BookSquareViewModel(this._bookRepository)
    : super(BookSquareState(books: [], hasMore: true)) {
    _init();
  }

  void _init() {}

  Future<void> loadBookPage(int page) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final books = await _bookRepository.loadBookPage(page);
      if (books.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          message: '没有更多数据了',
          hasMore: false,
        );
        return;
      }
      final newBooks = [...state.books, ...books];
      state = state.copyWith(books: newBooks, isLoading: false, hasMore: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<Book?> findBookById(String bookId)async{
    if (state.isLoading) return null;
    state = state.copyWith(isLoading: true);
    try {
      final book = await _bookRepository.findBookById(bookId);
      state = state.copyWith(isLoading: false);
      return book;
    } catch (e) {
      print(e);
      state = state.copyWith(isLoading: false, message: '加载绘本失败！');
      return null;
    }
  }
}
