import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/src/domain/character/data/character_repository.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/memory/storage.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppStarting()) {
    on<AppStarted>(_startApp, transformer: droppable());
  }

  void _startApp(AppStarted event, Emitter<AppState> emit) async {
    emit(AppStarting());

    try {
      final rickAndMortyRestApiClient = RickAndMortyRestApiClient();
      final rickAndMortyCharacterInMemoryStorage =
          InMemoryStorage<CharacterId, Character>();

      final characterRepository = CharacterRepositoryImpl(
        rickAndMortyRestApiClient,
        rickAndMortyCharacterInMemoryStorage,
      );

      emit(AppSucess(characterRepository: characterRepository));
    } catch (error) {
      emit(
        AppFailure(
          message:
              'Failed to open an application:\n'
              '${error.toString()}',
        ),
      );
    }
  }
}
