abstract class RickMortyRemoteDataSource {
  Future<Map<String, dynamic>> fetchCharacters({int page});
  Future<Map<String, dynamic>> searchCharacters(String query, {int page});
}
