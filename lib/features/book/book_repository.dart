import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/database/models/reading_history.dart';
import 'package:isar/isar.dart';

import '../../database/models/book.dart';
import '../../network/api_exceptions.dart';
import '../../network/apis/api_service.dart';
import '../../network/apis/book_api.dart';
import '../../network/dto/book_data.dart';
import '../login/login_repository.dart';

class BookRepository {
  final Isar isar;

  BookRepository(this.isar);

  final BookApi _api = ApiService().bookApi;

  Stream<List<Book>> watchAllBooks() {
    return isar.books.where().sortByCreatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  Stream<List<ReadingHistory>> watchReadingHistory(String userId) {
    return isar.readingHistorys
        .where()
        .userIdEqualTo(userId)
        .sortByLastReadAtDesc()
        .watch(fireImmediately: true);
  }

  Future<void> saveReadingHistory(Book book, String userId) async {
    await isar.writeTxn(() async {
      final lastHistory = await isar.readingHistorys
          .filter()
          .bookIdEqualTo(book.bookId)
          .userIdEqualTo(userId)
          .findFirst();
      if (lastHistory != null) {
        lastHistory.lastReadAt = DateTime.now();
        await isar.readingHistorys.put(lastHistory);
      } else {
        final history = ReadingHistory()
          ..bookId = book.bookId
          ..bookName = book.bookName
          ..bookCover = book.coverUrl
          ..userId = userId
          ..lastReadAt = DateTime.now();
        await isar.readingHistorys.put(history);
      }
    });
  }

  Future<void> clearReadingHistoryByBookId(String bookId) async {
    await isar.writeTxn(() async {
      await isar.readingHistorys.where().bookIdEqualTo(bookId).deleteAll();
    });
  }

  Future<void> clearReadingHistory() async {
    await isar.writeTxn(() async {
      await isar.readingHistorys.where().deleteAll();
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

  Future<void> generateBook(
    List<String> storyTypes,
    List<String> storyQualities,
    String model,
  ) async {
    try {
      final response = await _api.generateBook(
        storyTypes,
        storyQualities,
        model,
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

  Future<void> deleteBook(String bookId) async {
    try {
      final response = await _api.deleteBook(bookId);
      if (response.code != 200) {
        throw RepositoryException(response.message ?? '删除失败');
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

  Future<void> generateExclusiveBook(
    List<String> storyTypes,
    List<String> storyQualities,
    List<String> charactersId,
    String model,
  ) async {
    try {
      final response = await _api.generateExclusiveBook(
        storyTypes,
        storyQualities,
        charactersId,
        model,
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

  Future<void> createFastBook(List<String> charactersId) async {
    try {
      final response = await _api.createFastBook(charactersId);
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
        throw RepositoryException(response.message ?? '查询失败');
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
        throw RepositoryException(response.message ?? '同步失败');
      }
      await isar.writeTxn(() async {
        await isar.books.clear();
        await isar.books.putAll(response.data!);
      });
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<List<BookData>> loadBookPage(int page) async {
    try {
      final response = await _api.loadBookPage(page);
      if (response.code != 200) {
        throw RepositoryException(response.message ?? '加载失败');
      }
      return response.data == null ? [] : response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<Book> findBookById(String bookId) async {
    try {
      final response = await _api.findBookById(bookId);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<bool> starBook(String bookId) async {
    try {
      final response = await _api.starBook(bookId);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '收藏失败');
      }
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }

  Future<bool> queryStarStatus(String bookId) async {
    try {
      final response = await _api.queryStarStatus(bookId);
      if (response.code != 200 || response.data == null) {
        throw RepositoryException(response.message ?? '查询失败');
      }
      return response.data!;
    } on ApiException catch (e) {
      throw RepositoryException(e.message);
    }
  }
}
