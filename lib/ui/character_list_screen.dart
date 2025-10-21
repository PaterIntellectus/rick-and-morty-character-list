import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/ui/character_card.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('list');

    return GridView.builder(
      padding: EdgeInsets.all(4),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final character = Character(
          id: index + 1,
          name: 'Character $index',
          status: index % 2 == 0 ? CharacterStatus.alive : CharacterStatus.dead,
          isFavorite: index % 3 == 0,
          species: 'Human',
          imagePath: Uri.parse(
            'https://rickandmortyapi.com/api/character/avatar/${index + 1}.jpeg',
          ),
        );

        return CharacterCard(
          character: character,
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Implement favorite toggle functionality
              },
              icon: character.isFavorite
                  ? Icon(Icons.star, color: Colors.amber)
                  : Icon(Icons.star_border, color: Colors.black),
            ),
          ],
        );
      },
    );
  }
}
