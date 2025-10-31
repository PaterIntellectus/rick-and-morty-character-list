import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/data/character_database.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/src/shared/data/memory/storage.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/stream/streamer.dart';

extension _CharacterMapper on Character {
  static Character fromApiDto(CharacterDto dto) => Character(
    id: dto.id,
    name: dto.name,
    gender: CharacterGender.values.singleWhere((g) => g.name == dto.gender),
    species: dto.species,
    status: CharacterStatus.values.singleWhere((s) => s.name == dto.status),
    imagePath: Uri.parse(dto.image),
    isFavorite: false,
  );

  static Character fromDatabaseDto(CharacterDatabaseDto dto) => Character(
    id: dto.id,
    name: dto.name,
    gender: CharacterGender.values.singleWhere((g) {
      return g.name == dto.gender;
    }),
    species: dto.species,
    status: CharacterStatus.values.singleWhere((s) => s.name == dto.status),
    imagePath: Uri.parse(dto.imagePath),
    isFavorite: dto.isFavorite,
  );

  CharacterDatabaseDto toDatabaseDto() => CharacterDatabaseDto(
    id: id,
    name: name,
    gender: gender.name,
    imagePath: imagePath.toString(),
    species: species,
    isFavorite: isFavorite,
    status: status.name,
  );
}

class CharacterRepositoryImpl extends Streamer<List<Character>> implements CharacterRepository  {
   CharacterRepositoryImpl({
    required this.restClient,
    required this.databaseStorage,
    // required this.memoryStorage,
  });

  @override
  Stream<PaginatedList<Character>> watch({CharacterFilter? filter}) async* {
    await list();

    if (filter != null) {
      yield* stream.map((data) {
        final filtered = filter.apply(data);

        return PaginatedList(items: filtered, total: filtered.length);
      });
      return;
    }

    // yield* databaseStorage.stream
    //     .map((data) => PaginatedList(items: data, total: memoryStorage.total))
    //     .asBroadcastStream();
  }

  @override
  Future<PaginatedList<Character>> list({
    int page = 1,
    CharacterFilter? filter,
  }) async {
    // final cached = memoryStorage.list(
    //   offset: (page - 1) * _pageLimit,
    //   limit: _pageLimit,
    //   filter: filter?.check,
    // );
    final isFavoriesOnly = filter != null && filter.favoriteOnly;

    final cached = await databaseStorage.list(
      offset: (page - 1) * _pageLimit,
      limit: _pageLimit,
      where: isFavoriesOnly ? CharacterWhereClause(true) : null,
    );

    if (isFavoriesOnly) {
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

    final characters = response.results.map((dto) {
      final cachedCharacter = memoryStorage.find(dto.id);

      var character = _CharacterMapper.fromApiDto(dto);

      if (cachedCharacter == null) {
        return character;
      }

      return character.toggleFavorite(cachedCharacter.isFavorite);
    }).toList();

    // memoryStorage.saveMany((c) => c.id, characters);
    databaseStorage.

    return PaginatedList(items: characters, total: response.info.count);
  }

  @override
  Future<Character> find(CharacterId id) async {
    var character = await databaseStorage.find(id);

    if (character != null) {
      return character;
    }

    final response = await restClient.character(id);

    character = _CharacterMapper.fromApiDto(response);

    databaseStorage.save(character.toDatabaseDto());
    // memoryStorage.save(character.id, character);

    return character;
  }

  @override
  void save(Character character) async{
    await databaseStorage.save(character.toDatabaseDto());

    add(await databaseStorage.list());
    
    // memoryStorage.save(character.id, character);
  }

  @override
  void close() {
    restClient.close();
    databaseStorage.close();
    // memoryStorage.close();
  }

  final RickAndMortyRestApiClient restClient;
  final CharacterDatabaseStorage databaseStorage;
  // final InMemoryStorage<CharacterId, Character> memoryStorage;

  // Пагинация "Rick and Morty Api" сервиса работает ТОЛЬКО с постраничной пагинацией
  // Каждая страница имеет 20 элементов
  // Посему для простоты реализации мы имеем данный константный лимит в 20 элементов за запрос
  static const _pageLimit = 20;
}
