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
  const CharacterWhereClause({this.isFavorite});

  final bool? isFavorite;

  bool apply(CharacterDatabaseDto dto) =>
      isFavorite != null && dto.isFavorite == isFavorite;

  @override
  String toString() => 'WHERE ${CharacterTable.isFavoriteCol} = ?';

  List<dynamic> get args => [if (isFavorite != null) '${isFavorite! ? 1 : 0}'];
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
  CharacterDatabaseStorage(this.database) : super(initial: const []) {
    list().then((value) => add(value));
  }

  Stream<List<CharacterDatabaseDto>> watch({
    CharacterWhereClause? where,
  }) async* {
    if (where != null) {
      yield* stream
          .map((data) => data.where(where.apply).toList())
          .asBroadcastStream();
      return;
    }

    yield* stream.asBroadcastStream();
  }

  Future<int?> count({CharacterWhereClause? where}) async {
    return Sqflite.firstIntValue(
      await database.query(
        CharacterTable.name,
        columns: ['COUNT(*)'],
        where: where != null ? '${CharacterTable.isFavoriteCol} = ?' : null,
        whereArgs: where != null ? [where.isFavorite] : const [],
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

  Future<CharacterDatabaseDto?> find(int id, {bool? isFavorite}) async {
    final data = await database.query(
      CharacterTable.name,
      where: [
        '${CharacterTable.idCol} = ?',
        if (isFavorite != null) '${CharacterTable.isFavoriteCol} = ?',
      ].join(' '),
      whereArgs: [id, ?isFavorite],
    );

    if (data.isEmpty) {
      return null;
    }

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
      where: where?.toString(),
      whereArgs: where?.args,
    );

    return data.map((row) {
      return CharacterDatabaseDto.fromDatabase(row);
    }).toList();
  }

  final Database database;
}
