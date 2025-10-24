import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/grid_view.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/provider.dart';
import 'package:rick_and_morty_character_list/src/domain/character/index.dart';
import 'package:rick_and_morty_character_list/src/feature/favorite/ui/button.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CharacterListProvider(
      initialEvent: CharacterListRefreshed(),
      builder: (context, child) {
        return BlocListener<CharacterListBloc, CharacterListState>(
          listener: (context, state) {
            if (state is CharacterListFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: CharacterGridView(
            onRefresh: () async =>
                context.read<CharacterListBloc>().add(CharacterListRefreshed()),
            itemBuilder: (context, character) => CharacterCard(
              character: character,
              actions: [
                FavoriteButton(
                  isFavorite: character.isFavorite,
                  onPressed: () => context.read<CharacterListBloc>().add(
                    CharacterListToggleCharacterFavoriteStatus(
                      id: character.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
