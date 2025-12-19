import 'dart:io';

import 'package:dio/dio.dart';
import 'package:instant_tale/database/models/character.dart';

import '../../database/models/book.dart';
import '../api_exceptions.dart';
import '../api_response.dart';
import '../dto/book_data.dart';
import '../dto/login_data.dart';

class BookApi {
  final Dio _dio;

  BookApi(this._dio);

  Future<ApiResponse<Book>> createBook(
    List<String> storyTypes,
    List<String> storyQualities,
  ) async {
    try {
      final data = {'story_type': storyTypes, 'story_quality': storyQualities};
      final response = await _dio.post(
        '/book/generate_creativity',
        data: data,
        options: Options(receiveTimeout: Duration(minutes: 7)),
      );

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? Book.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<Book>> generateBook(
    List<String> storyTypes,
    List<String> storyQualities,
    String model,
  ) async {
    try {
      final data = {
        'story_type': storyTypes,
        'story_quality': storyQualities,
        'model': model,
      };
      final response = await _dio.post(
        '/book/gen_creativity_book',
        data: data,
        options: Options(receiveTimeout: Duration(minutes: 7)),
      );

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? Book.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<Book>> createExclusiveBook(
    List<String> storyTypes,
    List<String> storyQualities,
    List<String> charactersId,
  ) async {
    try {
      final data = {
        'story_type': storyTypes,
        'story_quality': storyQualities,
        'characters_id': charactersId,
      };
      final response = await _dio.post(
        '/book/generate_exclusive',
        data: data,
        options: Options(receiveTimeout: Duration(minutes: 7)),
      );

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? Book.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  // 可选模型的生成专属绘本
  Future<ApiResponse<Book>> generateExclusiveBook(
    List<String> storyTypes,
    List<String> storyQualities,
    List<String> charactersId,
    String model,
  ) async {
    try {
      final data = {
        'story_type': storyTypes,
        'story_quality': storyQualities,
        'characters_id': charactersId,
        'model': model,
      };
      final response = await _dio.post(
        '/book/gen_exclusive_book',
        data: data,
        options: Options(receiveTimeout: Duration(minutes: 7)),
      );

      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? Book.fromJson(response.data['data'])
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<void>> deleteBook(String bookId) async {
    try {
      final data = {'book_id': bookId};
      final response = await _dio.delete('/book/delete', data: data);
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<List<Book>>> findBookList(String keyword) async {
    try {
      final data = {'keyword': keyword};
      final response = await _dio.get('/book/query', queryParameters: data);
      final listJson = response.data['data'] as List<dynamic>;
      final books = listJson.map((e) => Book.fromJson(e)).toList();
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null ? books : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<List<BookData>>> loadBookPage(int page) async {
    try {
      final data = {'page': page};
      final response = await _dio.get(
        '/book/get_book_square',
        queryParameters: data,
      );
      final listJson = response.data['data']['books_info'] as List<dynamic>;
      final books = listJson.map((e) => BookData.fromJson(e)).toList();
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null ? books : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<Book>> findBookById(String bookId) async {
    try {
      final data = {'book_id': bookId};
      final response = await _dio.get(
        '/book/query_by_id',
        queryParameters: data,
      );
      final book = Book.fromJson(response.data['data']);
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null ? book : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
