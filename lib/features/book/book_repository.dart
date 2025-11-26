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
  Future<List<Book>> findBookList(
      String keyword
      ) async {
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
  Future<void> fetchBookList(
      ) async {
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
