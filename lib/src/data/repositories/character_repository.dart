import 'package:state_management_and_api/src/core/result.dart';
import 'package:state_management_and_api/src/data/models/character_dto.dart';

abstract class CharacterRepository {
  Future<Result<Map<String, dynamic>>> fetchCharacters({int page});
  Future<Result<Map<String, dynamic>>> searchCharacters(
    String query, {
    int page,
  });
}
