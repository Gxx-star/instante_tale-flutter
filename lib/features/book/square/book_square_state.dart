import '../../../database/models/book.dart';
import '../../../network/dto/book_data.dart';
import '../reader/book_reader_state.dart';

class BookSquareState {
  final bool isLoading;
  final String? message;
  final List<BookData> books;
  final bool hasMore;
  // 构造函数（推荐用 copyWith 方法，方便状态更新）
  BookSquareState({
    this.isLoading = false,
    this.message,
    required this.books,
    required this.hasMore
  });

  // 状态更新方法
  BookSquareState copyWith({
    bool? isLoading,
    String? message,
    List<BookData>? books,
    bool? hasMore
  }) {
    return BookSquareState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      books: books ?? this.books,
      hasMore: hasMore ?? this.hasMore
    );
  }
}