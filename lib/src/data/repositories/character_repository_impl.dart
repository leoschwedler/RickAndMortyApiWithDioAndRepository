import 'package:state_management_and_api/src/core/result.dart';
import 'package:state_management_and_api/src/data/datasources/remote/rick_morty_remote_data_source.dart';

import 'package:state_management_and_api/src/data/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final RickMortyRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Map<String, dynamic>>> fetchCharacters({int page = 1}) async {
    try {
      final result = await remoteDataSource.fetchCharacters(page: page);
      return Success(result);
    } catch (e) {
      return Failure('Erro ao carregar personagens: ${e.toString()}');
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> searchCharacters(
    String query, {
    int page = 1,
  }) async {
    try {
      final result = await remoteDataSource.searchCharacters(query, page: page);
      return Success(result);
    } catch (e) {
      return Failure('Erro ao buscar personagens: ${e.toString()}');
    }
  }
}
