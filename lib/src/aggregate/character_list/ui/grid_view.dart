import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/refresh_indicator.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';

class InfiniteListSettings {
  const InfiniteListSettings({required this.enabled, this.isInitial = true});

  final bool enabled;
  final bool isInitial;
}

class CharacterGridView extends StatelessWidget {
  const CharacterGridView({
    super.key,
    this.controller,
    required this.itemBuilder,
    this.filter,
    this.settings = const InfiniteListSettings(enabled: true),
    this.dragToRefresh = true,
    this.padding = EdgeInsets.zero,
  });

  final ScrollController? controller;
  final Widget Function(BuildContext context, Character character) itemBuilder;
  final CharacterFilter? filter;
  final InfiniteListSettings settings;
  final bool dragToRefresh;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Widget widget = CustomScrollView(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: BlocBuilder<CharacterListBloc, CharacterListState>(
            builder: (context, state) {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final character = state.characters.elementAtOrNull(index);

                  if (character == null) {
                    switch (state) {
                      case CharacterListInitial():
                        if (settings.isInitial) continue success;
                        break;
                      success:
                      case CharacterListSuccess():
                        if (state.hasMore && settings.enabled) {
                          context.read<CharacterListBloc>().add(
                            CharacterListRequestedMore(
                              page:
                                  state.characters.length ~/
                                      state.pageSizeLimit +
                                  1,
                              filter: filter,
                            ),
                          );
                        }
                      default:
                        break;
                    }
                    return null;
                  }

                  return itemBuilder(context, character);
                }, childCount: state.total),
              );
            },
          ),
        ),

        BlocBuilder<CharacterListBloc, CharacterListState>(
          builder: (context, state) {
            if (state is CharacterListFailure) {
              return SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),

                      FilledButton(
                        onPressed: () =>
                            context.read<CharacterListBloc>()
                              ..add(CharacterListSubscribed(filter: filter)),
                        child: Text("Try again"),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CharacterListLoading) {
              return SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      padding: EdgeInsets.only(bottom: 12),
                    ),
                  ),
                ),
              );
            }

            if (state.characters.isEmpty) {
              return SliverFillRemaining(
                fillOverscroll: true,
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'For some reason the list is empty try to realod the page',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SliverToBoxAdapter(child: SizedBox());
          },
        ),
      ],
    );

    if (dragToRefresh) {
      widget = CharacterRefreshIndicator(filter: filter, child: widget);
    }

    return widget;
  }
}
