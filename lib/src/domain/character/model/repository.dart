import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/shared/types/pagination/pagination.dart';

abstract interface class CharacterRepository {
  FutureOr<Page<Character>> list({
    int offset,
    int limit,
    CharacterFilter? filter,
  });
  FutureOr<Character> find(CharacterId id);
  FutureOr<void> save(Character character);
  // FutureOr<void> toggleFavorite(CharacterId id, [bool? value]);
}
