import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';

part 'event.dart';
part 'state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  CharacterListBloc(this.characterRepository) : super(CharacterListInitial()) {
    on<CharacterListSubscribed>(_subscribe, transformer: restartable());
    on<CharacterListRequestedMore>(_loadMore, transformer: droppable());
    on<CharacterListToggleCharacterFavoriteStatus>(
      _toggleCharacterFavoriteStatus,
      transformer: droppable(),
    );
    on<CharacterListSorted>(_sort, transformer: restartable());
  }

  void _subscribe(
    CharacterListSubscribed event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(CharacterListRefreshing(list: state._list, sorting: state.sorting));

    await emit.forEach(
      characterRepository.watch(filter: event.filter),
      onData: (list) {
        final total = list.isEmpty
            ? state._list.items.length
            : list.length < state.pageSizeLimit
            ? list.length
            : null;

        return CharacterListSuccess(
          list: PaginatedList(items: list, total: total),
          sorting: state.sorting,
        );
      },
      onError: (error, stackTrace) => CharacterListFailure(
        list: state._list,
        message: error.toString(),
        sorting: state.sorting,
      ),
    );
  }

  void _loadMore(
    CharacterListRequestedMore event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(CharacterListLoadingMore(list: state._list, sorting: state.sorting));

    try {
      final list = await characterRepository.list(
        page: event.page,
        filter: event.filter,
      );

      emit(
        CharacterListSuccess(
          list: PaginatedList(
            items: state._list.items,
            total: list.isEmpty ? state._list.items.length : list.total,
          ),
          sorting: state.sorting,
        ),
      );
    } catch (error) {
      emit(
        CharacterListFailure(
          list: state._list,
          message: error.toString(),
          sorting: state.sorting,
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
    } catch (error) {
      emit(
        CharacterListFailure(
          list: state._list,
          message: error.toString(),
          sorting: state.sorting,
        ),
      );
    }
  }

  void _sort(CharacterListSorted event, Emitter<CharacterListState> emit) {
    emit(
      CharacterListSuccess(
        list: PaginatedList(items: state._list.items, total: state.total),
        sorting: event.sorting,
      ),
    );
  }

  final CharacterRepository characterRepository;
}
