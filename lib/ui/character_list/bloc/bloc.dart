import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/domain/repository.dart';

part 'event.dart';
part 'state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  CharacterListBloc(this.characterRepository)
    : super(CharacterListState.initial) {
    on<CharacterListRefreshed>(_refreshList, transformer: restartable());
    on<CharacterListRequestedMore>(_requestMoreItems, transformer: droppable());
  }

  final CharacterRepository characterRepository;

  void _refreshList(
    CharacterListRefreshed event,
    Emitter<CharacterListState> emit,
  ) async {
    emit(
      state.copyWith(status: CharacterListStatus.loading, characters: const []),
    );

    try {
      final charactersPage = await characterRepository.list();

      emit(
        state.copyWith(
          status: CharacterListStatus.success,
          characters: charactersPage.items,
          totalCharacters: charactersPage.totalItemsCount,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CharacterListStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }

  void _requestMoreItems(
    CharacterListRequestedMore event,
    Emitter<CharacterListState> emit,
  ) async {
    if (state.totalCharacters == state.characters.length) {
      return;
    }

    emit(state.copyWith(status: CharacterListStatus.loading));

    try {
      final charactersPage = await characterRepository.list(
        offset: event.offset,
        limit: event.limit,
      );

      final characters = [...state.characters, ...charactersPage.items];

      emit(
        state.copyWith(
          status: CharacterListStatus.success,
          characters: characters,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CharacterListStatus.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
