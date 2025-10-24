import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/ui/image.dart';

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

    final paddingValue = 8.0;
    final borderRadiusValue = 16.0;

    return Container(
      padding: EdgeInsets.all(paddingValue),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadiusValue),
        color: theme.colorScheme.secondaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    borderRadiusValue - paddingValue,
                  ),
                  child: CharacterImage(
                    imagePath: character.imagePath,
                    characterStatus: character.status,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Column(children: actions),
                ),
              ],
            ),
          ),

          Text(character.name, style: theme.textTheme.titleLarge),

          Row(
            children: [
              Text(character.species, style: theme.textTheme.labelMedium),

              if (character.gender != CharacterGender.unknown)
                Text(
                  ' - ${character.gender.name}',
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
