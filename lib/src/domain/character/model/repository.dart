import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';

abstract interface class CharacterRepository {
  // Stream<Page<Character>> watch({CharacterFilter? filter});
  Stream<PaginatedList<Character>> watch({CharacterFilter? filter});
  FutureOr<PaginatedList<Character>> list({int page, CharacterFilter? filter});
  FutureOr<Character> find(CharacterId id);
  FutureOr<void> save(Character character);
  FutureOr<void> close();
  // FutureOr<void> toggleFavorite(CharacterId id, [bool? value]);
}
