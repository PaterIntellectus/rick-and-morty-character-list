import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/ui/character_card.dart';
import 'package:rick_and_morty_character_list/ui/character_list/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/ui/character_repository_provider.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = CharacterRepositoryProvider.of(context);

    return BlocProvider(
      create: (context) =>
          CharacterListBloc(repository)..add(CharacterListRefreshed()),
      child: BlocBuilder<CharacterListBloc, CharacterListState>(
        builder: (context, state) {
          final grid = RefreshIndicator(
            onRefresh: () async =>
                context.read<CharacterListBloc>()
                  ..add(CharacterListRefreshed()),
            child: GridView.builder(
              padding: EdgeInsets.all(4),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: state.totalCharacters,
              itemBuilder: (context, index) {
                final character = state.characters.elementAtOrNull(index);

                if (character == null) {
                  context.read<CharacterListBloc>().add(
                    CharacterListRequestedMore(
                      offset: state.characters.length,
                      limit: 20,
                    ),
                  );
                  return null;
                }

                return CharacterCard(
                  character: character,
                  actions: [
                    IconButton(
                      color: Colors.amber,
                      onPressed: () {
                        // TODO: Implement favorite toggle functionality
                      },
                      icon: character.isFavorite
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                    ),
                  ],
                );
              },
            ),
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              if (state.characters.isNotEmpty) Expanded(child: grid),

              if (state.status == CharacterListStatus.loading)
                Center(
                  child: CircularProgressIndicator(
                    padding: EdgeInsets.only(bottom: 12),
                  ),
                ),

              if (state.status == CharacterListStatus.failure)
                Center(
                  child: Text('Ошибка во время загрузки:\n ${state.message}'),
                ),
            ],
          );
        },
      ),
    );
  }
}
