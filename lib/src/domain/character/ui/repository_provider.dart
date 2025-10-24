import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';

class CharacterRepositoryProvider extends InheritedWidget {
  const CharacterRepositoryProvider({
    super.key,
    required super.child,
    required this.repository,
  });

  final CharacterRepository repository;

  static CharacterRepository? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CharacterRepositoryProvider>()
      ?.repository;

  static CharacterRepository of(BuildContext context) {
    final repository = maybeOf(context);
    assert(repository != null, 'CharacterRepository не найден');
    return repository!;
  }

  @override
  bool updateShouldNotify(CharacterRepositoryProvider oldWidget) =>
      repository != oldWidget.repository;
}
