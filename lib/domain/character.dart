import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [id];
}
