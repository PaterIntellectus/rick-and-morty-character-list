import 'package:equatable/equatable.dart';

enum CharacterGender { male, female, genderless, unknown }

enum CharacterStatus { alive, dead, unknown }

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
    required this.status,
    required this.isFavorite,
    required this.species,
    // required this.type,
    // required this.gender,
    //   required this.origin,
    //   required this.location,
    required this.imagePath,
    //   required this.episode,
    //   required this.url,
    // required this.createdt,
  });

  final CharacterId id;
  final String name;
  final CharacterStatus status;
  final bool isFavorite;
  final String species;
  // final String type;
  // final CharacterGender gender;
  // final CharacterLocation origin;
  // final CharacterLocation location;
  final Uri imagePath;
  // final Uri episode;
  // final Uri url;
  // final DateTime createdt;

  @override
  List<Object?> get props => throw UnimplementedError();
}
