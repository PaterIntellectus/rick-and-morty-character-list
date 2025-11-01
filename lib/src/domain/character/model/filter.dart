import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';

class CharacterFilter with EquatableMixin {
  const CharacterFilter({this.isFavorite = false});

  final bool? isFavorite;

  List<Character> apply(List<Character> characters) {
    return isFavorite != null
        ? characters.where((c) => c.isFavorite == isFavorite).toList()
        : characters;
  }

  bool check(Character character) =>
      isFavorite != null ? character.isFavorite == isFavorite : true;

  @override
  List<Object?> get props => [isFavorite];
}
