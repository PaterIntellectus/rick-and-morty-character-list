import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/ui/character_image.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    this.actions = const [],
  });

  final Character character;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CharacterImage(
                imagePath: character.imagePath,
                characterStatus: character.status,
              ),

              Positioned(bottom: 0, right: 0, child: Column(children: actions)),
            ],
          ),
        ),

        Text(character.name, style: theme.textTheme.titleLarge),

        Text(character.species, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
