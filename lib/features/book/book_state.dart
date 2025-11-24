import '../../database/models/book.dart';

class BookState {
  final bool isLoading;
  final String? message;
  final bool isControlsVisible;
  final int currentPage;
  final Book? currentBook;
  // 构造函数（推荐用 copyWith 方法，方便状态更新）
  BookState({
    this.isLoading = false,
    this.message,
    this.isControlsVisible = true,
    this.currentPage = 0,
    this.currentBook,
  });

  // 状态更新方法
  BookState copyWith({
    bool? isLoading,
    String? message,
    bool? isControlsVisible,
    int? currentPage,
    Book? currentBook,
  }) {
    return BookState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      currentPage: currentPage ?? this.currentPage,
      currentBook: currentBook ?? this.currentBook,
    );
  }
}