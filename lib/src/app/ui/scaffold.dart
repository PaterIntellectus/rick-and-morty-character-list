import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_character_list/src/screen/characters/ui/screen.dart';
import 'package:rick_and_morty_character_list/src/screen/favorite_characters/ui/screen.dart';
import 'package:rick_and_morty_character_list/src/shared/ui/theme/cubit/theme_cubit.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with TickerProviderStateMixin {
  final navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      label: 'Characters',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
  ];

  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            onPressed: context.read<ThemeCubit>().toggle,
            icon: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) => Icon(
                theme.brightness == Brightness.dark
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
        children: [CharactersScreen(), FavoriteCharactersScreen()],
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
