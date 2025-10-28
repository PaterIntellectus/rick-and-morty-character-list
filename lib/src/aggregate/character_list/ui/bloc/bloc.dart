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
  }

  final CharacterRepository characterRepository;

  void _subscribe(
    CharacterListSubscribed event,
    Emitter<CharacterListState> emit,
  ) async {
    print('qwer:bloc:_subscribe');

    emit(
      CharacterListRefreshing(list: PaginatedList(items: const [], total: 0)),
    );

    await emit.forEach(
      characterRepository.watch(filter: event.filter),
      onData: (list) {
        print('qwer:bloc:_subscribe:list.total: ${list.total}');
        print('qwer:bloc:_subscribe:list.length: ${list.length}');

        return CharacterListSuccess(list: list);
      },
      onError: (error, stackTrace) =>
          CharacterListFailure(list: state._list, message: error.toString()),
    );

    print('qwer:bloc:_subscribe:end');
  }

  void _loadMore(
    CharacterListRequestedMore event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(CharacterListLoadingMore(list: state._list));

    try {
      await characterRepository.list(
        offset: event.offset,
        limit: event.limit,
        filter: event.filter,
      );
    } catch (error) {
      emit(CharacterListFailure(list: state._list, message: error.toString()));
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
      emit(CharacterListFailure(list: state._list, message: error.toString()));
    }
  }
}
