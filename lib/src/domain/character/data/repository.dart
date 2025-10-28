import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/src/shared/data/memory/storage.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';
import 'package:rxdart/subjects.dart';

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

  final RickAndMortyRestApiClient restClient;
  final InMemoryStorage<CharacterId, Character> memoryStorage;
  late final stream = BehaviorSubject<PaginatedList<Character>>.seeded(
    memoryStorage.list(),
  );

  @override
  Stream<PaginatedList<Character>> watch({CharacterFilter? filter}) async* {
    if (!stream.hasValue || stream.value.isEmpty) {
      await list();
    }

    if (filter != null) {
      yield* stream
          .map(
            (data) => PaginatedList(
              items: filter.apply(data.items),
              total: data.total,
            ),
          )
          .asBroadcastStream();
    } else {
      yield* stream.asBroadcastStream();
    }
  }

  @override
  Future<PaginatedList<Character>> list({
    int offset = 0,
    int limit = 20,
    CharacterFilter? filter,
  }) async {
    final cached = memoryStorage.list(
      offset: offset,
      limit: limit,
      filter: filter?.check,
    );

    if (filter != null && filter.favoriteOnly) {
      return cached;
    }

    RickAndMortyRestApiPaginatedResponse<List<CharacterDto>> response;

    try {
      response = await restClient.allCharacters(page: (offset ~/ limit) + 1);
    } catch (error) {
      final cached = memoryStorage.list(
        offset: offset,
        limit: limit,
        filter: filter?.check,
      );
      // stream.add(stream.value.merge(cached));

      return cached;
    }

    final characters = response.results.map((item) {
      final cachedCharacter = memoryStorage.find(item.id);

      var character = item.toDomain();

      if (cachedCharacter == null) {
        return character;
      }

      return character.toggleFavorite(cachedCharacter.isFavorite);
    }).toList();

    // memoryStorage.saveMany((c) => c.id, characters);

    final list = PaginatedList(items: characters, total: response.info.count);

    print('qwer:stream:total: ${stream.value.total}');
    print('qwer:list:total: ${list.total}');

    stream.add(stream.value.merge(list));

    return list;
  }

  @override
  Future<Character> find(CharacterId id) async {
    var character = memoryStorage.find(id);

    if (character != null) {
      return character;
    }

    final response = await restClient.characters([id]);

    character = response.toDomain();

    memoryStorage.save(character.id, character);

    return character;
  }

  @override
  void save(Character character) {
    memoryStorage.save(character.id, character);

    final cache = memoryStorage.find(character.id);

    if (cache != null) {
      stream.add(
        PaginatedList(
          items: stream.value.items
              .map((c) => c.id == cache.id ? cache : c)
              .toList(),
          total: memoryStorage.total,
        ),
      );
    }
  }

  @override
  void close() {
    restClient.close();
  }
}
