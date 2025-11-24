import 'dart:io';

import 'package:dio/dio.dart';

import '../../database/models/book.dart';
import '../api_exceptions.dart';
import '../api_response.dart';
import '../dto/login_data.dart';
class BookApi {
  final Dio _dio;

  BookApi(this._dio);

  Future<ApiResponse<Book>> createBook(
      List<String> storyTypes,
      List<String> storyQualities
      ) async {
    try {
      final data = {
        'story_type': storyTypes,
        'story_quality': storyQualities
      };
      final response = await _dio.post('/book/generate', data: data,options: Options(
          receiveTimeout: Duration(minutes: 7)
      ));

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
  Future<ApiResponse<List<Book>>> findBookList(
      String keyword,
      ) async {
    try {
      final data = {
        'keyword': keyword
      };
      final response = await _dio.get('/book/query', data: data);
      final listJson = response.data['data'] as List<dynamic>;
      final books = listJson.map((e) => Book.fromJson(e)).toList();
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? books
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
