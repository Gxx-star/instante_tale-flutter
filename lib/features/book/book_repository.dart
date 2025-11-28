import 'package:instant_tale/database/models/reading_history.dart';
import 'package:isar/isar.dart';

import '../../database/models/book.dart';
import '../../network/api_exceptions.dart';
import '../../network/apis/api_service.dart';
import '../../network/apis/book_api.dart';
import '../login/login_repository.dart';

class BookRepository {
  final Isar isar;

  BookRepository(this.isar);

  final BookApi _api = ApiService().bookApi;

  Stream<List<Book>> watchAllBooks() {
    return isar.books.where().watch(fireImmediately: true);
  }

  Stream<List<ReadingHistoryItem>> watchReadingHistory() {
    final historyStream = isar.readingHistorys.where().sortByLastReadAtDesc().watch(fireImmediately: true);
    return historyStream.asyncMap((_) async {
      final histories = await isar.readingHistorys.where().sortByLastReadAtDesc().findAll();
      List<ReadingHistoryItem>items = [];
      for(var h in histories){
        final book = await isar.books.where().bookIdEqualTo(h.bookId).findFirst();
        if(book!=null){
          items.add(ReadingHistoryItem(book, h));
        }
      }
        return items;
    });
  }

  Future<void> saveReadingHistory(String bookId) async {
    await isar.writeTxn(() async {
      final lastHistory = await isar.readingHistorys
          .filter()
          .bookIdEqualTo(bookId)
          .findFirst();
      if (lastHistory != null) {
        lastHistory.lastReadAt = DateTime.now();
        await isar.readingHistorys.put(lastHistory);
      } else {
        final history = ReadingHistory()
          ..bookId = bookId
          ..lastReadAt = DateTime.now();
        await isar.readingHistorys.put(history);
      }
    });
  }

  Future<void> createBook(
    List<String> storyTypes,
    List<String> storyQualities,
  ) async {
    try {
      final response = await _api.createBook(storyTypes, storyQualities);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '创建失败');
      }
      await isar.writeTxn(() async {
        await isar.books.put(response.data!);
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
  Future<void> deleteBook(
      String bookId
      ) async {
    try {
      final response = await _api.deleteBook(bookId);
      if (response.code != 200) {
        throw RepositoryException(response.message ?? '创建失败');
      }
      await isar.writeTxn(() async {
        await isar.books.where().bookIdEqualTo(bookId).deleteAll();
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<void> createExclusiveBook(
    List<String> storyTypes,
    List<String> storyQualities,
    List<String> charactersId,
  ) async {
    try {
      final response = await _api.createExclusiveBook(
        storyTypes,
        storyQualities,
        charactersId,
      );
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '创建失败');
      }
      await isar.writeTxn(() async {
        await isar.books.put(response.data!);
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<List<Book>> findBookList(String keyword) async {
    try {
      final response = await _api.findBookList(keyword);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '创建失败');
      }
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<void> fetchBookList() async {
    try {
      final response = await _api.findBookList('');
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '创建失败');
      }
      await isar.writeTxn(() async {
        await isar.books.clear();
        await isar.books.putAll(response.data!);
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}
