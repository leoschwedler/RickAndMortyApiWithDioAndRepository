import 'package:state_management_and_api/src/data/models/character_dto.dart';

sealed class CharacterSearchState {
  const CharacterSearchState();
}

class CharacterSearchInitial extends CharacterSearchState {
  const CharacterSearchInitial();
}

class CharacterSearchLoading extends CharacterSearchState {
  const CharacterSearchLoading();
}

class CharacterSearchSuccess extends CharacterSearchState {
  final List<CharacterDto> characters;
  final String query;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  const CharacterSearchSuccess({
    required this.characters,
    required this.query,
    required this.currentPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
  });

  CharacterSearchSuccess copyWith({
    List<CharacterDto>? characters,
    String? query,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
  }) {
    return CharacterSearchSuccess(
      characters: characters ?? this.characters,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CharacterSearchError extends CharacterSearchState {
  final String message;
  final String? query;

  const CharacterSearchError({required this.message, this.query});
}
