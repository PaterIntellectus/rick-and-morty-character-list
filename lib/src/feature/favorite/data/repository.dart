import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/feature/favorite/model/repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final favoriteIds = <CharacterId>{};

  @override
  bool contains(CharacterId id) => favoriteIds.contains(id);

  @override
  void toggleItem(CharacterId id, [bool? value]) {
    if (value == true || !favoriteIds.contains(id)) {
      favoriteIds.add(id);
    } else if (value == false || favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    }
  }
}
