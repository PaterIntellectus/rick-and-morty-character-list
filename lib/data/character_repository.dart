import 'dart:async';

import 'package:rick_and_morty_character_list/domain/character.dart';
import 'package:rick_and_morty_character_list/domain/repository.dart';
import 'package:rick_and_morty_character_list/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/shared/data/memory/storage.dart';
import 'package:rick_and_morty_character_list/shared/lib/pagination/pagination.dart';

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
  const CharacterRepositoryImpl(this.restClient, this.memoryStorage);

  final RickAndMortyRestApiClient restClient;
  final InMemoryStorage<CharacterId, Character> memoryStorage;

  @override
  FutureOr<Page<Character>> list({int offset = 0, int limit = 20}) async {
    final memoized = memoryStorage.list(offset, limit);

    if (memoized.isNotEmpty) {
      return Page(items: memoized);
    }

    final response = await restClient.allCharacters(
      page: (offset ~/ limit) + 1,
    );

    final characters = response.results.map((e) => e.toDomain()).toList();

    cache(characters);

    return Page(
      items: characters,
      totalItemsCount: response.info.count,
      next: response.info.next,
      prev: response.info.prev,
    );
  }

  @override
  FutureOr<void> save(Character character) {
    memoryStorage.save(character.id, character);
  }

  void cache(List<Character> characters) =>
      memoryStorage.saveMany((c) => c.id, characters);
}
