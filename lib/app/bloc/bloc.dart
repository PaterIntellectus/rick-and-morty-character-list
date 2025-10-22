import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/data/character_repository.dart';
import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/domain/repository.dart';
import 'package:rick_and_morty_character_list/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/shared/data/memory/storage.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppStarting()) {
    on(_startApp);
  }

  void _startApp(AppStarted event, Emitter<AppState> emit) async {
    emit(AppStarting());

    try {
      final rickAndMortyRestApiClient = RickAndMortyRestApiClient();
      final rickAndMortyCharacterInMemoryStorage =
          InMemoryStorage<CharacterId, Character>();

      CharacterRepository characterRepository = CharacterRepositoryImpl(
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
