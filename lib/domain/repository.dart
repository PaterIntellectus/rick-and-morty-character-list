import 'dart:async';

import 'package:rick_and_morty_character_list/domain/character.dart';

abstract interface class CharacterReader {
  FutureOr<List<Character>> list();
  FutureOr<Character> find(CharacterId id);
}

abstract interface class CharacterWriter {
  FutureOr<void> save(Character c);
}
