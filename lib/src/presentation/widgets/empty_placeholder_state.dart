import 'package:flutter/material.dart';

class EmptyOrPlaceholderState extends StatelessWidget {
  final String query;

  const EmptyOrPlaceholderState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasQuery = query.isNotEmpty;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 420;
        return Center(
          child: Padding(
            padding: EdgeInsets.all(compact ? 16.0 : 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasQuery
                      ? Icons.person_search_outlined
                      : Icons.travel_explore_outlined,
                  size: compact ? 48 : 64,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: compact ? 8 : 12),
                Text(
                  hasQuery
                      ? 'Pronto para buscar "$query"'
                      : 'Busque personagens de Rick and Morty',
                  textAlign: TextAlign.center,
                  style:
                      compact
                          ? theme.textTheme.titleSmall
                          : theme.textTheme.titleMedium,
                ),
                SizedBox(height: compact ? 6 : 8),
                Text(
                  hasQuery
                      ? 'Toque em Buscar ou pressione Enter para iniciar.'
                      : 'Use o campo acima para pesquisar por nome (ex: Rick, Morty).',
                  textAlign: TextAlign.center,
                  style: (compact
                          ? theme.textTheme.bodySmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
