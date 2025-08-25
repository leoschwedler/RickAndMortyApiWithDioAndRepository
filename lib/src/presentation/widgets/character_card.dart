import 'package:flutter/material.dart';
import 'package:state_management_and_api/src/data/models/character_dto.dart';

class CharacterCard extends StatelessWidget {
  final CharacterDto character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 180;
        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(character.image, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? 8 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          compact
                              ? theme.textTheme.titleSmall
                              : theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: compact ? 2 : 4),
                    Text(
                      '${character.species} • ${character.status}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (compact
                              ? theme.textTheme.bodySmall
                              : theme.textTheme.bodySmall)
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
