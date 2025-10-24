import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';

class CharacterFilter with EquatableMixin {
  const CharacterFilter({this.favoriteOnly = false});

  final bool favoriteOnly;

  List<Character> apply(List<Character> characters) => favoriteOnly
      ? characters.where((c) => c.isFavorite).toList()
      : characters;

  @override
  List<Object?> get props => [favoriteOnly];
}
