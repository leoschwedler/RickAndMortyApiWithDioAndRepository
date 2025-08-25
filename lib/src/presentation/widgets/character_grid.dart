import 'package:flutter/material.dart';
import 'package:state_management_and_api/src/data/models/character_dto.dart';
import 'package:state_management_and_api/src/presentation/widgets/character_card.dart';

class CharacterGrid extends StatefulWidget {
  final List<CharacterDto> characters;
  final VoidCallback? onLoadMore;
  final bool hasMorePages;
  final bool isLoadingMore;

  const CharacterGrid({
    super.key,
    required this.characters,
    this.onLoadMore,
    this.hasMorePages = false,
    this.isLoadingMore = false,
  });

  @override
  State<CharacterGrid> createState() => _CharacterGridState();
}

class _CharacterGridState extends State<CharacterGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMorePages &&
          !widget.isLoadingMore &&
          widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  int _getCrossAxisCount(double maxWidth) {
    if (maxWidth >= 1440) return 7;
    if (maxWidth >= 1200) return 6;
    if (maxWidth >= 992) return 5;
    if (maxWidth >= 768) return 4;
    if (maxWidth >= 576) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 768 ? 24 : 16,
                  vertical: 16,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: constraints.maxWidth > 768 ? 16 : 12,
                  mainAxisSpacing: constraints.maxWidth > 768 ? 16 : 12,
                  childAspectRatio: constraints.maxWidth > 576 ? 0.72 : 0.68,
                ),
                itemCount: widget.characters.length,
                itemBuilder: (context, index) {
                  return CharacterCard(character: widget.characters[index]);
                },
              ),
            ),
            if (widget.isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
