import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/app/bloc/bloc.dart';
import 'package:rick_and_morty_character_list/ui/character_repository_provider.dart';
import 'package:rick_and_morty_character_list/ui/scaffold.dart';
import 'package:rick_and_morty_character_list/ui/theme_controller.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  final _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, child) => MaterialApp(
        theme: _themeController.theme,
        home: BlocProvider(
          create: (context) => AppBloc()..add(AppStarted()),
          child: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              return switch (state) {
                AppStarting() => Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                AppFailure() => Scaffold(
                  body: Center(child: Text(state.message.toString())),
                ),
                AppSucess(characterRepository: final cr) =>
                  CharacterRepositoryProvider(
                    repository: cr,
                    child: MainScaffold(themeController: _themeController),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}
