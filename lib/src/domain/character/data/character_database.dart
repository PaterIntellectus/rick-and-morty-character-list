import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/stream/streamer.dart';
import 'package:sqflite/sqflite.dart';

abstract class CharacterTable {
  static const name = 'character';

  static const idCol = 'id';
  static const nameCol = 'name';
  static const genderCol = 'gender';
  static const statusCol = 'status';
  static const speciesCol = 'species';
  static const imagePathCol = 'image_path';
  static const isFavoriteCol = 'is_favorite';
}

class CharacterWhereClause {
  const CharacterWhereClause(this.isFavorite);

  final bool isFavorite;

  @override
  String toString() =>
      'WHERE ${CharacterTable.isFavoriteCol} = ${isFavorite ? 1 : 0}';
}

class CharacterDatabaseDto {
  const CharacterDatabaseDto({
    required this.id,
    required this.name,
    required this.gender,
    required this.status,
    required this.species,
    required this.imagePath,
    required this.isFavorite,
  });

  factory CharacterDatabaseDto.fromDatabase(Map<String, Object?> row) =>
      CharacterDatabaseDto(
        id: (row[CharacterTable.idCol] as num).toInt(),
        name: row[CharacterTable.nameCol] as String,
        gender: row[CharacterTable.genderCol] as String,
        status: row[CharacterTable.statusCol] as String,
        species: row[CharacterTable.speciesCol] as String,
        imagePath: row[CharacterTable.imagePathCol] as String,
        isFavorite: (row[CharacterTable.isFavoriteCol] as num).toInt() == 1
            ? true
            : false,
      );

  final int id;
  final String name;
  final String gender;
  final String status;
  final String species;
  final String imagePath;
  final bool isFavorite;

  Map<String, Object?> toDatabaseRow() => {
    CharacterTable.idCol: id,
    CharacterTable.nameCol: name,
    CharacterTable.genderCol: gender,
    CharacterTable.statusCol: status,
    CharacterTable.speciesCol: species,
    CharacterTable.imagePathCol: imagePath,
    CharacterTable.isFavoriteCol: isFavorite ? 1 : 0,
  };
}

class CharacterDatabaseStorage extends Streamer<List<CharacterDatabaseDto>> {
  CharacterDatabaseStorage(this.database);

  @override
  Stream<List<CharacterDatabaseDto>> watch({
    CharacterWhereClause? where,
  }) async* {
    await list();

    if (where != null) {
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

  Future<int?> count({CharacterWhereClause? where}) async {
    return Sqflite.firstIntValue(
      await database.rawQuery(
        [
          'SELECT COUNT(*) FROM ${CharacterTable.name}',
          if (where != null)
            'WHERE ${CharacterTable.isFavoriteCol} = ${where.isFavorite}',
        ].join(' '),
      ),
    );
  }

  Future<void> save(CharacterDatabaseDto dto, {Database? db}) async {
    await database.insert(
      CharacterTable.name,
      dto.toDatabaseRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    add(await list());
  }

  Future<void> saveMany(List<CharacterDatabaseDto> dtos) async {
    final batch = database.batch();

    for (final dto in dtos) {
      batch.insert(
        CharacterTable.name,
        dto.toDatabaseRow(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);

    add(await list());
  }

  Future<CharacterDatabaseDto?> find(int id) async {
    final data = await database.query(
      CharacterTable.name,
      where: '${CharacterTable.idCol} = $id',
    );

    return CharacterDatabaseDto.fromDatabase(data.single);
  }

  Future<List<CharacterDatabaseDto>> list({
    int offset = 0,
    int? limit,
    CharacterWhereClause? where,
  }) async {
    final data = await database.query(
      CharacterTable.name,
      offset: offset,
      limit: limit,
      where: where.toString(),
    );

    return data.map((row) {
      return CharacterDatabaseDto.fromDatabase(row);
    }).toList();
  }

  final Database database;
}
