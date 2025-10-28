import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/aggregate/character_list/ui/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';

class InfiniteListSettings {
  const InfiniteListSettings({
    required this.enabled,
    this.isInitial = true,
    this.perBatch = 20,
  });

  final bool enabled;
  final bool isInitial;
  final int perBatch;
}

class CharacterGridView extends StatelessWidget {
  const CharacterGridView({
    super.key,
    required this.itemBuilder,
    this.filter,
    this.settings = const InfiniteListSettings(enabled: true),
    this.dragToRefresh = true,
    this.padding,
  });

  final Widget Function(BuildContext context, Character character) itemBuilder;
  final CharacterFilter? filter;
  final InfiniteListSettings settings;
  final bool dragToRefresh;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    Widget widget = CustomScrollView(
      slivers: [
        BlocBuilder<CharacterListBloc, CharacterListState>(
          builder: (context, state) {
            final names = state.list.map((c) => c.name).toList();
            // print('qwer:grid:chracaters: $names');
            // print('qwer:grid:total: ${state.total}');

            return SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final character = state.list.elementAtOrNull(index);
                // print('qwer:grid:character: ${character?.name}');

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
                            offset: state.list.length,
                            limit: settings.perBatch,
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

        BlocBuilder<CharacterListBloc, CharacterListState>(
          builder: (context, state) {
            if (state is CharacterListFailure) {
              return SliverFillRemaining(
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

            return SliverToBoxAdapter(child: SizedBox());
          },
        ),
      ],
    );

    if (padding != null) {
      widget = Padding(padding: padding!, child: widget);
    }

    if (dragToRefresh) {
      widget = RefreshIndicator(
        child: widget,
        onRefresh: () async => context.read<CharacterListBloc>().add(
          CharacterListSubscribed(filter: filter),
        ),
      );
    }

    return widget;
  }
}
