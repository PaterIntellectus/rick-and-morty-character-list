import 'package:equatable/equatable.dart';

enum CharacterSortOrder { ascending, descending }

enum CharacterSortParam { name, gender }

class CharacterSorting with EquatableMixin {
  const CharacterSorting({required this.order, required this.param});

  final CharacterSortOrder order;
  final CharacterSortParam? param;

  @override
  List<Object?> get props => [order, param];
}

enum CharacterGender {
  male('Male'),
  female('Female'),
  genderless('Genderless'),
  unknown('unknown');

  const CharacterGender(this.name);

  final String name;
}

enum CharacterStatus {
  alive('Alive'),
  dead('Dead'),
  unknown('unknown');

  const CharacterStatus(this.name);

  final String name;
}

class CharacterLocation with EquatableMixin {
  const CharacterLocation({required this.name, required this.link});

  final String name;
  final Uri link;

  @override
  List<Object?> get props => [name, link];
}

typedef CharacterId = int;

class Character with EquatableMixin {
  const Character({
    required this.id,
    required this.name,
    required this.gender,
    required this.status,
    required this.species,
    required this.imagePath,
    required this.isFavorite,
  });

  final CharacterId id;
  final String name;
  final CharacterGender gender;
  final CharacterStatus status;
  final String species;
  final Uri imagePath;
  final bool isFavorite;

  Character toggleFavorite([bool? value]) => Character(
    id: id,
    name: name,
    gender: gender,
    status: status,
    species: species,
    imagePath: imagePath,
    isFavorite: value ?? !isFavorite,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    gender,
    status,
    species,
    imagePath,
    isFavorite,
  ];
}
