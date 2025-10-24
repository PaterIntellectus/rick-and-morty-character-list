import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/src/shared/data/memory/storage.dart';
import 'package:rick_and_morty_character_list/src/shared/types/pagination/pagination.dart';

extension on CharacterDto {
  Character toDomain() => Character(
    id: id,
    name: name,
    gender: CharacterGender.values.singleWhere((g) => g.name == gender),
    species: species,
    status: CharacterStatus.values.singleWhere((s) => s.name == status),
    imagePath: Uri.parse(image),
    isFavorite: false,
  );
}

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this.restClient, this.memoryStorage);

  final favoriteIds = <CharacterId>{};

  final RickAndMortyRestApiClient restClient;
  final InMemoryStorage<CharacterId, Character> memoryStorage;

  @override
  Future<Page<Character>> list({
    int offset = 0,
    int limit = 20,
    CharacterFilter? filter,
  }) async {
    var characters = memoryStorage.list(offset, limit);

    if (characters.isNotEmpty) {
      return Page(items: filter?.apply(characters) ?? characters);
    }

    final response = await restClient.allCharacters(
      page: (offset ~/ limit) + 1,
    );

    characters = response.results.map((e) => e.toDomain()).toList();

    cacheMany(characters);

    return Page(
      items: filter?.apply(characters) ?? characters,
      totalItemsCount: response.info.count,
      next: response.info.next,
      prev: response.info.prev,
    );
  }

  @override
  Future<Character> find(CharacterId id) async {
    var character = memoryStorage.find(id);

    if (character != null) {
      return character;
    }

    final response = await restClient.characters([id]);

    character = response.toDomain();

    cacheSingle(character);

    return character;
  }

  @override
  void save(Character character) => memoryStorage.save(character.id, character);

  // @override
  // void toggleFavorite(CharacterId id, [bool? value]) {
  //   if (value == true || !favoriteIds.contains(id)) {
  //     favoriteIds.add(id);
  //   } else if (value == false || favoriteIds.contains(id)) {
  //     favoriteIds.remove(id);
  //   }
  // }

  void cacheMany(List<Character> characters) =>
      memoryStorage.saveMany((c) => c.id, characters);

  void cacheSingle(Character character) =>
      memoryStorage.save(character.id, character);
}
