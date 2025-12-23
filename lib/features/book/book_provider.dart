import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/reading_history.dart';
import 'package:instant_tale/features/book/book_repository.dart';
import 'package:instant_tale/features/user/user_provider.dart';
import 'package:instant_tale/network/api_response.dart';
import 'package:instant_tale/network/apis/api_service.dart';

import '../../database/models/book.dart';
import '../../network/api_exceptions.dart';
import '../../network/dto/book_data.dart';
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

final starBooksProvider = FutureProvider<List<BookData>>((ref) async {
  try {
    final apiService = ApiService().bookApi;
    final apiResponse = await apiService.loadStarBooks();
    if (apiResponse.code == 200) {
      final books = apiResponse.data ?? [];
      return books;
    } else {
      return [];
    }
  } on DioException catch (e) {
    throw ExceptionHandler.handle(e);
  } catch (e) {
    rethrow;
  }
});