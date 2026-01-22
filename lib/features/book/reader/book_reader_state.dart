import '../../../database/models/book.dart';

class BookReaderState {
  final bool isLoading;
  final String? message;
  final bool isControlsVisible;
  final int currentPage;
  final Book? currentBook;
  final bool isStarred;
  // 构造函数（推荐用 copyWith 方法，方便状态更新）
  BookReaderState({
    this.isLoading = false,
    this.message,
    this.isControlsVisible = true,
    this.currentPage = 0,
    this.currentBook,
    this.isStarred = false,
  });

  // 状态更新方法
  BookReaderState copyWith({
    bool? isLoading,
    String? message,
    bool? isControlsVisible,
    int? currentPage,
    Book? currentBook,
    bool? isStarred,
  }) {
    return BookReaderState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      currentPage: currentPage ?? this.currentPage,
      currentBook: currentBook ?? this.currentBook,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}