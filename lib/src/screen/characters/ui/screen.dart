import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/grid_view.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/provider.dart';
import 'package:rick_and_morty_character_list/src/domain/character/index.dart';
import 'package:rick_and_morty_character_list/src/feature/favorite/ui/button.dart';
import 'package:rick_and_morty_character_list/src/shared/ui/scroller_button.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CharacterListProvider(
      initialEvent: CharacterListSubscribed(),
      builder: (context, child) {
        return BlocListener<CharacterListBloc, CharacterListState>(
          listener: (context, state) {
            if (state is CharacterListFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: CharacterGridView(
                  controller: _scrollController,
                  settings: InfiniteListSettings(
                    enabled: true,
                    isInitial: false,
                  ),
                  padding: EdgeInsets.only(left: 4, right: 4),
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
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: ScrollerButton(controller: _scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
