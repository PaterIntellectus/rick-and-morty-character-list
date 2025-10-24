import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/grid_view.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/provider.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/ui/card.dart';
import 'package:rick_and_morty_character_list/src/feature/favorite/ui/button.dart';

class FavoriteCharactersScreen extends StatefulWidget {
  const FavoriteCharactersScreen({super.key});

  @override
  State<FavoriteCharactersScreen> createState() =>
      _FavoriteCharactersScreenState();
}

class _FavoriteCharactersScreenState extends State<FavoriteCharactersScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    debugPrint('FavoriteCharactersScreen');
    super.build(context);

    final filter = CharacterFilter(favoriteOnly: true);

    return CharacterListProvider(
      initialEvent: CharacterListRefreshed(filter: filter),
      builder: (context, child) => CharacterGridView(
        filter: filter,
        itemBuilder: (context, character) => CharacterCard(
          character: character,
          actions: [
            FavoriteButton(
              isFavorite: character.isFavorite,
              onPressed: () => context.read<CharacterListBloc>().add(
                CharacterListToggleCharacterFavoriteStatus(id: character.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
