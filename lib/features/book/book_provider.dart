import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/reading_history.dart';
import 'package:instant_tale/features/book/book_repository.dart';

import '../../database/models/book.dart';
import 'book_state.dart';
import 'book_view_model.dart';

final bookViewModelProvider =
    StateNotifierProvider<BookViewModel, BookState>((ref) {
      final repository = ref.watch(bookRepositoryProvider);
      return BookViewModel(repository);
    });

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final isar = AppGlobals().isar;
  return BookRepository(isar);
});

final booksProvider = StreamProvider<List<Book>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchAllBooks();
});

final readingHistoryProvider = StreamProvider<List<ReadingHistoryItem>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchReadingHistory();
});