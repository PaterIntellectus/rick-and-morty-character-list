import 'dart:async';

import 'package:rick_and_morty_character_list/src/domain/character/data/character_database.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/character.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/filter.dart';
import 'package:rick_and_morty_character_list/src/domain/character/model/repository.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/client.dart';
import 'package:rick_and_morty_character_list/src/shared/data/api/dto.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';

extension _CharacterMapper on Character {
  static Character fromApiDto(CharacterApiDto dto) => Character(
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

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({
    required this.restClient,
    required this.databaseStorage,
    // required this.memoryStorage,
  });

  @override
  Stream<List<Character>> watch({CharacterFilter? filter}) async* {
    await list();

    yield* databaseStorage
        .watch(
          where: filter == null
              ? null
              : CharacterWhereClause(isFavorite: filter.isFavorite),
        )
        .map((data) {
          return data.map(_CharacterMapper.fromDatabaseDto).toList();
        });
  }

  @override
  Future<PaginatedList<Character>> list({
    int page = 1,
    CharacterFilter? filter,
  }) async {
    final isFavoriteFilter = filter != null && filter.isFavorite != null;
    final where = filter != null && filter.isFavorite != null
        ? CharacterWhereClause(isFavorite: isFavoriteFilter)
        : null;

    final cached = (await databaseStorage.list(
      offset: (page - 1) * _pageLimit,
      limit: _pageLimit,
      where: where,
    )).map(_CharacterMapper.fromDatabaseDto).toList();

    final cachedTotal = await databaseStorage.count(where: where);

    if (isFavoriteFilter ||
        (cached.isNotEmpty && cachedTotal != null && cachedTotal > 0)) {
      return PaginatedList(items: cached, total: cachedTotal);
    }

    RickAndMortyRestApiPaginatedResponse<List<CharacterApiDto>> response;

    try {
      response = await restClient.allCharacters(page: page);
    } catch (error) {
      if (cached.isEmpty) {
        throw 'Internet connection hasn\'t been found\n'
            'Try connecting to the internet and try again';
      }

      return PaginatedList(items: cached, total: cachedTotal);
    }

    List<Character> characters = [];
    for (final dto in response.results) {
      final cachedCharacter = await databaseStorage.find(
        dto.id,
        isFavorite: filter?.isFavorite,
      );

      var character = _CharacterMapper.fromApiDto(dto);

      if (cachedCharacter == null) {
        characters.add(character);
      } else {
        characters.add(character.toggleFavorite(cachedCharacter.isFavorite));
      }
    }

    await databaseStorage.saveMany(
      characters.map((character) => character.toDatabaseDto()).toList(),
    );

    return PaginatedList(items: characters, total: response.info.count);
  }

  @override
  Future<Character> find(CharacterId id) async {
    var dbDto = await databaseStorage.find(id);

    if (dbDto != null) {
      return _CharacterMapper.fromDatabaseDto(dbDto);
    }

    final apiDto = await restClient.character(id);

    final character = _CharacterMapper.fromApiDto(apiDto);

    databaseStorage.save(character.toDatabaseDto());

    return character;
  }

  @override
  void save(Character character) async {
    await databaseStorage.save(character.toDatabaseDto());
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

  // Пагинация 'Rick and Morty Api' сервиса работает ТОЛЬКО с постраничной пагинацией
  // Каждая страница имеет 20 элементов
  // Посему для простоты реализации мы имеем данный константный лимит в 20 элементов за запрос
  static const _pageLimit = 20;
}
