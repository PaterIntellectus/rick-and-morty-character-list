import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';

abstract interface class FavoriteRepository {
  FutureOr<bool> contains(CharacterId id);
  FutureOr<void> toggleItem(CharacterId id, [bool? value]);
}
