import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_character_list/ui/character_list/screen.dart';
import 'package:rick_and_morty_character_list/ui/favorite_characters_screen.dart';
import 'package:rick_and_morty_character_list/ui/theme_controller.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  final navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      label: 'Список',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Любимые'),
  ];

  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/rick-and-morty-logo.png',
          height: 60,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            onPressed: widget.themeController.toggleTheme,
            icon: ListenableBuilder(
              listenable: widget.themeController,
              builder: (context, child) => Icon(
                widget.themeController.isLight
                    ? Icons.brightness_5_rounded
                    : Icons.brightness_2_rounded,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        dragStartBehavior: DragStartBehavior.start,
        controller: _tabController,
        children: [CharacterListScreen(), FavoriteCharactersScreen()],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _tabController,
        builder: (context, child) => BottomNavigationBar(
          currentIndex: _tabController.index,
          items: navItems,
          onTap: (value) => _tabController.animateTo(value),
        ),
      ),
    );
  }
}
