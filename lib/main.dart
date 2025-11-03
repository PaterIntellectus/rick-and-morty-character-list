import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/app/ui/app.dart';
import 'package:rick_and_morty_character_list/src/domain/character/data/character_database.dart';
import 'package:rick_and_morty_character_list/src/domain/character/data/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc.observer = BlocLogger();

  final dbsPath = await getDatabasesPath();
  final dbPath = '$dbsPath/rick_and_morty_characters.db';

  final database = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) => db.execute(
      'CREATE TABLE ${CharacterTable.name} ('
      ' ${CharacterTable.idCol} INTEGER PRIMARY KEY,'
      ' ${CharacterTable.nameCol} TEXT,'
      ' ${CharacterTable.genderCol} TEXT,'
      ' ${CharacterTable.statusCol} TEXT,'
      ' ${CharacterTable.speciesCol} TEXT,'
      ' ${CharacterTable.imagePathCol} TEXT,'
      ' ${CharacterTable.isFavoriteCol} BOOLEAN'
      ')',
    ),
  );

  final characterDatabaseStorage = CharacterDatabaseStorage(database);
  final rickAndMortyRestApiClient = RickAndMortyRestApiClient();

  final characterRepository = CharacterRepositoryImpl(
    restClient: rickAndMortyRestApiClient,
    databaseStorage: characterDatabaseStorage,
  );

  runApp(App(characterRepository: characterRepository));
}

class BlocLogger extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    debugPrint("Bloc: ${bloc.runtimeType} created");
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    debugPrint("Bloc: ${bloc.runtimeType}; Event: $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint(
      "Bloc: ${bloc.runtimeType}; Transition: ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}",
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint(
      "Bloc: ${bloc.runtimeType}; Error: ${error.runtimeType}('${error.toString()}')",
    );
    super.onError(bloc, error, stackTrace);
  }
}
