import 'package:flutter/material.dart';
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
  void dispose() {
    _themeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, child) =>
          MaterialApp(theme: _themeController.theme, home: child),
      child: MainScaffold(themeController: _themeController),
    );
  }
}
