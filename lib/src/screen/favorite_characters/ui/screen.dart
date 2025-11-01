import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/grid_view.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/provider.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/refresh_indicator.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/sorter.dart';
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
  final filter = CharacterFilter(isFavorite: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return CharacterListProvider(
      initialEvent: CharacterListSubscribed(filter: filter),
      builder: (context, child) {
        return BlocBuilder<CharacterListBloc, CharacterListState>(
          builder: (context, state) {
            if (state is! CharacterListLoading && state.characters.isEmpty) {
              return CharacterRefreshIndicator(
                filter: filter,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, size: 100),

                          Text(
                            "Your favorites are empty\n"
                            "Try tapping some Stars ;)",
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CharacterSorter(),
                ),

                Expanded(
                  child: CharacterGridView(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    filter: filter,
                    itemBuilder: (context, character) => CharacterCard(
                      character: character,
                      actions: [
                        FavoriteButton(
                          isFavorite: character.isFavorite,
                          onPressed: () =>
                              context.read<CharacterListBloc>().add(
                                CharacterListToggleCharacterFavoriteStatus(
                                  id: character.id,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
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
