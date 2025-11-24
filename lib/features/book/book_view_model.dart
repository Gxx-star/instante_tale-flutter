import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/models/book.dart';
import '../login/login_repository.dart';
import 'book_repository.dart';
import 'book_state.dart';

class BookViewModel extends StateNotifier<BookState> {
  final BookRepository _bookRepository;

  BookViewModel(this._bookRepository) : super(BookState()) {
    _init();
  }

  void _init() {}

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }

  // 点击屏幕中央时切换沉浸模式/控制模式
  void toggleControls() {
    state = state.copyWith(isControlsVisible: !state.isControlsVisible);
  }

  Future<void> createBook(
    List<String> storyTypes,
    List<String> storyQualities,
  ) async {
    state = state.copyWith(isLoading: true, message: "绘本正在生成中...完成后会通知~");
    try {
      // await _bookRepository.createBook(storyTypes, storyQualities);
      await Future.delayed(Duration(seconds: 10));
      state = state.copyWith(
        isLoading: false,
        message: "绘本生成成功啦！可以在\"我的绘本\"中查看",
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  // 查询绘本列表
  Future<void> findBookList(String keyword) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _bookRepository.findBookList(keyword);
      state = state.copyWith(isLoading: false, message: null);
      // 查询成功之后的操作
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> fetchBookList() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _bookRepository.fetchBookList();
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  // 打开绘本
  Future<void> loadBook(Book book) async {
    state = state.copyWith(isLoading: false, message: null, currentBook: book);
  }
}
