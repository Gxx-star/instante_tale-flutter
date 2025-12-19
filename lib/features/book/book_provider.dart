import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/reading_history.dart';
import 'package:instant_tale/features/book/book_repository.dart';
import 'package:instant_tale/features/user/user_provider.dart';

import '../../database/models/book.dart';
import 'square/book_square_state.dart';
import 'square/book_square_viewmodel.dart';
import 'reader/book_reader_state.dart';
import 'reader/book_reader_viewmodel.dart';

final bookReaderViewModelProvider =
    StateNotifierProvider<BookReaderViewModel, BookReaderState>((ref) {
      final repository = ref.watch(bookRepositoryProvider);
      return BookReaderViewModel(repository);
    });

final bookSquareViewModelProvider =
    StateNotifierProvider<BookSquareViewModel, BookSquareState>((ref) {
      final repository = ref.watch(bookRepositoryProvider);
      return BookSquareViewModel(repository);
    });

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final isar = AppGlobals().isar;
  return BookRepository(isar);
});

final booksProvider = StreamProvider<List<Book>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchAllBooks();
});

final readingHistoryProvider = StreamProvider<List<ReadingHistory>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  final userId = ref.watch(userViewModelProvider).user?.userId;
  if (userId == null) {
    return Stream.value([]);
  }
  return repository.watchReadingHistory(userId);
});
