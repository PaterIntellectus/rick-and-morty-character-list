import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/src/shared/data/memory/storage.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';

extension CharacterMapper on CharacterDto {
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

  @override
  Stream<PaginatedList<Character>> watch({CharacterFilter? filter}) async* {
    await list();

    if (filter != null) {
      yield* memoryStorage.stream.map((data) {
        final filtered = filter.apply(data);

        return PaginatedList(items: filtered, total: filtered.length);
      });
      return;
    }

    yield* memoryStorage.stream
        .map((data) => PaginatedList(items: data, total: memoryStorage.total))
        .asBroadcastStream();
  }

  @override
  Future<PaginatedList<Character>> list({
    int page = 1,
    CharacterFilter? filter,
  }) async {
    final cached = memoryStorage.list(
      offset: (page - 1) * _pageLimit,
      limit: _pageLimit,
      filter: filter?.check,
    );

    if (filter != null && filter.favoriteOnly) {
      return PaginatedList(items: cached.items, total: cached.total);
    }

    if (cached.isNotEmpty && cached.total != null && cached.total! > 0) {
      return PaginatedList(items: cached.items, total: cached.total);
    }

    RickAndMortyRestApiPaginatedResponse<List<CharacterDto>> response;

    try {
      response = await restClient.allCharacters(page: page);
    } catch (error) {
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

    memoryStorage.saveMany((c) => c.id, characters);

    return PaginatedList(items: characters, total: response.info.count);
  }

  @override
  Future<Character> find(CharacterId id) async {
    var character = memoryStorage.find(id);

    if (character != null) {
      return character;
    }

    final response = await restClient.character(id);

    character = response.toDomain();

    memoryStorage.save(character.id, character);

    return character;
  }

  @override
  void save(Character character) {
    memoryStorage.save(character.id, character);
  }

  @override
  void close() {
    restClient.close();
    memoryStorage.close();
  }

  final RickAndMortyRestApiClient restClient;
  final InMemoryStorage<CharacterId, Character> memoryStorage;

  // Пагинация "Rick and Morty Api" сервиса работает ТОЛЬКО с постраничной пагинацией
  // Каждая страница имеет 20 элементов
  // Посему для простоты реализации мы имеем данный константный лимит в 20 элементов за запрос
  static const _pageLimit = 20;
}
