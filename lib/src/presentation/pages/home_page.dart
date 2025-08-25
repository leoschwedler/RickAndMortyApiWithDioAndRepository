import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:state_management_and_api/src/presentation/widgets/search_field.dart';
import 'package:state_management_and_api/src/presentation/widgets/empty_placeholder_state.dart';
import 'package:state_management_and_api/src/presentation/controllers/character_search_controller.dart';
import 'package:state_management_and_api/src/presentation/controllers/character_search_state.dart';
import 'package:state_management_and_api/src/presentation/widgets/character_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final CharacterSearchController _controller =
      GetIt.instance<CharacterSearchController>();

  @override
  void initState() {
    super.initState();
    _controller.loadInitial();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Campo de busca expandido
              Expanded(
                child: SearchField(
                  controller: _searchController,
                  hintText: 'Buscar personagens...',
                  onChanged: _controller.setQuery,
                  onSubmitted: (q) => _controller.search(q),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ValueListenableBuilder<CharacterSearchState>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          return switch (state) {
            CharacterSearchInitial() => const EmptyOrPlaceholderState(
              query: '',
            ),
            CharacterSearchLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CharacterSearchSuccess(
              :final characters,
              :final query,
              :final hasMorePages,
              :final isLoadingMore,
            ) =>
              characters.isEmpty
                  ? EmptyOrPlaceholderState(query: query)
                  : CharacterGrid(
                    characters: characters,
                    hasMorePages: hasMorePages,
                    isLoadingMore: isLoadingMore,
                    onLoadMore: _controller.loadMorePages,
                  ),
            CharacterSearchError(:final message, :final query) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {
                        if (query != null && query.isNotEmpty) {
                          _controller.search(query);
                        } else {
                          _controller.loadInitial();
                        }
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
