import 'dart:async';

import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/shared/lib/pagination/pagination.dart';

// abstract interface class CharacterReadableSource {
//   FutureOr<List<Character>> list();
//   FutureOr<Character> find(CharacterId id);
// }

// abstract interface class CharacterWritableSource {
//   FutureOr<void> save(Character c);
// }

abstract interface class CharacterRepository {
  FutureOr<Page<Character>> list({int offset, int limit});
  FutureOr<void> save(Character c);
}
