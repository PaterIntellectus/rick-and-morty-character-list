import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/ui/sliver_grid.dart';

class InfiniteListSettings {
  const InfiniteListSettings({required this.enabled, this.perBatch = 20});

  final bool enabled;
  final int perBatch;
}

class CharacterGridView extends StatelessWidget {
  const CharacterGridView({
    super.key,
    required this.itemBuilder,
    this.filter,
    this.settings = const InfiniteListSettings(enabled: true),
    this.onRefresh,
  });

  final Widget Function(BuildContext context, Character character) itemBuilder;
  final CharacterFilter? filter;
  final InfiniteListSettings settings;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterListBloc, CharacterListState>(
      builder: (context, state) {
        debugPrint('CharacterGridView:BlocBuilder: $state');

        final footer = state is CharacterListLoadingMore
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    padding: EdgeInsets.only(bottom: 12),
                  ),
                ),
              )
            : state is CharacterListFailure
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),

                      FilledButton(
                        onPressed: () => context.read<CharacterListBloc>()
                          ..add(
                            CharacterListRequestedMore(
                              offset: state.characters.length,
                              limit: 20,
                              filter: filter,
                            ),
                          ),
                        child: Text("Try again"),
                      ),
                    ],
                  ),
                ),
              )
            : null;

        final scrollView = CustomScrollView(
          slivers: [
            CharacterSliverGrid(
              totalCharacterCount: state.totalCharacters,
              itemBuilder: (context, index) {
                final character = state.characters.elementAtOrNull(index);

                if (character == null) {
                  if (state is! CharacterListFailure &&
                      state.isNotFull &&
                      settings.enabled) {
                    context.read<CharacterListBloc>().add(
                      CharacterListRequestedMore(
                        offset: state.characters.length,
                        limit: 20,
                        filter: filter,
                      ),
                    );
                  }
                  return null;
                }

                return itemBuilder(context, character);
              },
            ),

            ?footer,
          ],
        );

        if (onRefresh != null) {
          return RefreshIndicator(
            child: scrollView,
            onRefresh: () async =>
                context.read<CharacterListBloc>().add(CharacterListRefreshed()),
          );
        }

        return scrollView;
      },
    );
  }
}
