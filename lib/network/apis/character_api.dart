import 'dart:io';

import 'package:dio/dio.dart';
import 'package:instant_tale/database/models/character.dart';

import '../api_exceptions.dart';
import '../api_response.dart';

class CharacterApi {
  final Dio _dio;

  CharacterApi(this._dio);

  Future<ApiResponse<CharacterCollection>> addCharacter(
    File characterPhoto,
    String characterName,
    String desc,
  ) async {
    try {
      final data = {
        'character_photo': await MultipartFile.fromFile(
          characterPhoto.path,
          filename: characterPhoto.path.split('/').last,
        ),
        'character_name': characterName,
        'desc': desc,
      };
      final fromData = FormData.fromMap(data);
      final response = await _dio.post(
        '/character/add',
        data: fromData,
        options: Options(receiveTimeout: Duration(minutes: 7)),
      );
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? CharacterCollection.fromJson(
                response.data['data']['character_info'],
              )
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<void>> deleteCharacter(String characterId) async {
    try {
      final data = {'character_id': characterId};
      final response = await _dio.delete('/character/delete', data: data);
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<List<CharacterCollection>>> findCharacterList(
    String keyword,
  ) async {
    try {
      final data = {'keyword': keyword};
      final response = await _dio.get('/character/query', data: data);
      final listJson = response.data['data']['list'] as List<dynamic>;
      final characters = listJson
          .map((e) => CharacterCollection.fromJson(e))
          .toList();
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: characters,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
  Future<ApiResponse<List<CharacterCollection>>> findCharacterListById(
      String characterId,
      ) async {
    try {
      final data = {'character_id': characterId};
      final response = await _dio.get('/character/query', data: data);
      final listJson = response.data['data']['list'] as List<dynamic>;
      final characters = listJson
          .map((e) => CharacterCollection.fromJson(e))
          .toList();
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: characters,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }

  Future<ApiResponse<CharacterCollection>> updateCharacter(
    String characterId,
    String characterName,
    String desc,
  ) async {
    try {
      final data = {
        'character_id': characterId,
        'character_name': characterName,
        'desc': desc,
      };
      final response = await _dio.post('/character/update', data: data);
      return ApiResponse(
        code: response.data['code'],
        message: response.data['msg'],
        data: response.data['data'] != null
            ? CharacterCollection.fromJson(
                response.data['data']['character_info'],
              )
            : null,
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handle(e);
    }
  }
}
