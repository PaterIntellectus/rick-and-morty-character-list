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
    super.build(context);

    final filter = CharacterFilter(favoriteOnly: true);
    final padding = EdgeInsets.symmetric(horizontal: 4);

    return CharacterListProvider(
      initialEvent: CharacterListSubscribed(filter: filter),
      builder: (context, child) {
        return CharacterGridView(
          padding: padding,
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
        );

        // return BlocBuilder<CharacterListBloc, CharacterListState>(
        //   builder: (context, state) {
        //     if (state is! CharacterListLoading && state.characters.isEmpty) {
        //       return RefreshIndicator(
        //         // onRefresh: () async {},
        //         onRefresh: () async => context.read<CharacterListBloc>().add(
        //           CharacterListSubscribed(filter: filter),
        //         ),
        //         child: CustomScrollView(
        //           slivers: [
        //             SliverPadding(
        //               padding: padding,
        //               sliver: SliverFillRemaining(
        //                 child: Center(
        //                   child: Text(
        //                     'Your Favorites is empty\n'
        //                     'Try tapping some stars ;)',
        //                     textAlign: TextAlign.center,
        //                     style: theme.textTheme.bodyLarge,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     }

        //     return CharacterGridView(
        //       padding: padding,
        //       filter: filter,
        //       itemBuilder: (context, character) => CharacterCard(
        //         character: character,
        //         actions: [
        //           FavoriteButton(
        //             isFavorite: character.isFavorite,
        //             onPressed: () => context.read<CharacterListBloc>().add(
        //               CharacterListToggleCharacterFavoriteStatus(
        //                 id: character.id,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
