import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:state_management_and_api/src/data/datasources/remote/rick_morty_remote_data_source.dart';
import 'package:state_management_and_api/src/data/datasources/remote/rick_morty_remote_data_source_impl.dart';
import 'package:state_management_and_api/src/data/repositories/character_repository.dart';
import 'package:state_management_and_api/src/data/repositories/character_repository_impl.dart';
import 'package:state_management_and_api/src/presentation/controllers/character_search_controller.dart';

final getIt = GetIt.instance;

void injector() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<RickMortyRemoteDataSource>(
    () => RickMortyRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: getIt<RickMortyRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<CharacterSearchController>(
    () => CharacterSearchController(repository: getIt<CharacterRepository>()),
  );
}
