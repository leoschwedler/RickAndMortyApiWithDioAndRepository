import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:state_management_and_api/src/data/models/character_dto.dart';
import 'package:state_management_and_api/src/data/repositories/character_repository.dart';
import 'package:state_management_and_api/src/presentation/controllers/character_search_state.dart';

class CharacterSearchController {
  final CharacterRepository repository;

  final ValueNotifier<CharacterSearchState> state =
      ValueNotifier<CharacterSearchState>(const CharacterSearchInitial());

  Timer? _debounce;

  CharacterSearchController({required this.repository});

  Future<void> loadInitial() async {
    state.value = const CharacterSearchLoading();

    final result = await repository.fetchCharacters(page: 1);
    result.fold(
      (data) =>
          state.value = CharacterSearchSuccess(
            characters: (data['characters'] as List).cast<CharacterDto>(),
            query: '',
            currentPage: data['currentPage'] as int,
            hasMorePages: data['hasMorePages'] as bool,
          ),
      (error) => state.value = CharacterSearchError(message: error),
    );
  }

  Future<void> loadMorePages() async {
    final currentState = state.value;
    if (currentState is! CharacterSearchSuccess ||
        currentState.isLoadingMore ||
        !currentState.hasMorePages) {
      return;
    }

    // Atualiza estado para mostrar loading
    state.value = currentState.copyWith(isLoadingMore: true);

    final nextPage = currentState.currentPage + 1;

    // Busca mais páginas baseado no tipo de busca atual
    if (currentState.query.isNotEmpty) {
      // Busca por nome com paginação
      final result = await repository.searchCharacters(
        currentState.query,
        page: nextPage,
      );

      result.fold((data) {
        final newCharacters = (data['characters'] as List).cast<CharacterDto>();
        final allCharacters = [...currentState.characters, ...newCharacters];

        state.value = currentState.copyWith(
          characters: allCharacters,
          currentPage: nextPage,
          hasMorePages: data['hasMorePages'] as bool,
          isLoadingMore: false,
        );
      }, (error) => state.value = currentState.copyWith(isLoadingMore: false));
    } else {
      // Lista inicial com paginação
      final result = await repository.fetchCharacters(page: nextPage);

      result.fold((data) {
        final newCharacters = (data['characters'] as List).cast<CharacterDto>();
        final allCharacters = [...currentState.characters, ...newCharacters];

        state.value = currentState.copyWith(
          characters: allCharacters,
          currentPage: nextPage,
          hasMorePages: data['hasMorePages'] as bool,
          isLoadingMore: false,
        );
      }, (error) => state.value = currentState.copyWith(isLoadingMore: false));
    }
  }

  void setQuery(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      unawaited(loadInitial());
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      search(query);
    });
  }

  Future<void> search(String value) async {
    state.value = const CharacterSearchLoading();

    final result = await repository.searchCharacters(value, page: 1);
    result.fold(
      (data) =>
          state.value = CharacterSearchSuccess(
            characters: (data['characters'] as List).cast<CharacterDto>(),
            query: value,
            currentPage: data['currentPage'] as int,
            hasMorePages: data['hasMorePages'] as bool,
          ),
      (error) =>
          state.value = CharacterSearchError(message: error, query: value),
    );
  }

  void dispose() {
    _debounce?.cancel();
    state.dispose();
  }
}
