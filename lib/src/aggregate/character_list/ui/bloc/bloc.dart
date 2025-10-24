import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';

part 'event.dart';
part 'state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  CharacterListBloc(this.characterRepository) : super(CharacterListInitial()) {
    on<CharacterListRefreshed>(_refreshList, transformer: restartable());
    on<CharacterListRequestedMore>(_requestMoreItems, transformer: droppable());
    on<CharacterListToggleCharacterFavoriteStatus>(
      _toggleCharacterFavoriteStatus,
      transformer: droppable(),
    );
  }

  final CharacterRepository characterRepository;

  void _refreshList(
    CharacterListRefreshed event,
    Emitter<CharacterListState> emit,
  ) async {
    print('_refreshList');
    emit(CharacterListRefreshing());

    try {
      final charactersPage = await characterRepository.list(
        filter: event.filter,
      );

      emit(
        CharacterListSuccess(
          totalCharacters:
              charactersPage.totalItemsCount ?? charactersPage.items.length,
          characters: charactersPage.items,
        ),
      );
    } catch (error) {
      emit(CharacterListFailure(message: error.toString()));
    }
  }

  void _requestMoreItems(
    CharacterListRequestedMore event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(
      CharacterListLoadingMore(
        characters: state.characters,
        totalCharacters: state.totalCharacters,
      ),
    );

    await Future.delayed(Duration(seconds: 1));

    try {
      final charactersPage = await characterRepository.list(
        offset: event.offset,
        limit: event.limit,
        filter: event.filter,
      );

      final characters = [...state.characters, ...charactersPage.items];

      emit(
        CharacterListSuccess(
          totalCharacters: state.totalCharacters,
          characters: characters,
        ),
      );
    } catch (error) {
      emit(
        CharacterListFailure(
          message: error.toString(),
          characters: state.characters,
        ),
      );
    }
  }

  void _toggleCharacterFavoriteStatus(
    CharacterListToggleCharacterFavoriteStatus event,
    Emitter<CharacterListState> emit,
  ) async {
    try {
      var character = await characterRepository.find(event.id);

      character = character.toggleFavorite(event.value);

      await characterRepository.save(character);

      emit(
        CharacterListSuccess(
          totalCharacters: state.totalCharacters,
          characters: state.characters
              .map((c) => c.id == event.id ? character : c)
              .toList(),
        ),
      );
    } catch (error) {
      emit(CharacterListFailure(message: error.toString()));
    }
  }
}
