import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/app/ui/scaffold.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/ui/theme/cubit/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key, required this.characterRepository});

  final CharacterRepository characterRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: state,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: RepositoryProvider(
              create: (context) => characterRepository,
              dispose: (value) => value.close(),
              child: AppScaffold(),
            ),
          );
        },
      ),
    );
  }
}
