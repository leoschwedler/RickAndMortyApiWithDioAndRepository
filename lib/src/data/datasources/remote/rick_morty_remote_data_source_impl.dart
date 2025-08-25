import 'package:dio/dio.dart';
import 'package:state_management_and_api/src/data/datasources/remote/rick_morty_remote_data_source.dart';
import 'package:state_management_and_api/src/data/models/character_dto.dart';

class RickMortyRemoteDataSourceImpl implements RickMortyRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://rickandmortyapi.com/api/character/';

  RickMortyRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> fetchCharacters({int page = 1}) async {
    final Response response = await dio.get(
      baseUrl,
      queryParameters: {'page': page},
    );
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final List results = data['results'] as List? ?? [];
    final String? next = data['info']?['next'] as String?;

    return {
      'characters': results.map((json) => CharacterDto.fromJson(json)).toList(),
      'hasMorePages': next != null,
      'currentPage': page,
    };
  }

  @override
  Future<Map<String, dynamic>> searchCharacters(
    String query, {
    int page = 1,
  }) async {
    final Response response = await dio.get(
      baseUrl,
      queryParameters: {'name': query, 'page': page},
    );
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    final List results = data['results'] as List? ?? [];
    final String? next = data['info']?['next'] as String?;

    return {
      'characters': results.map((json) => CharacterDto.fromJson(json)).toList(),
      'hasMorePages': next != null,
      'currentPage': page,
    };
  }
}
