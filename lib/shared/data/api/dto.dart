class CharacterDto {
  const CharacterDto({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) => CharacterDto(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as String,
    species: json['species'] as String,
    type: json['type'] as String,
    gender: json['gender'] as String,
    origin: Map<String, String>.from(json['origin'] as Map),
    location: Map<String, String>.from(json['location'] as Map),
    image: json['image'] as String,
    episode: List<String>.from(json['episode'] as List),
    url: json['url'] as String,
    created: json['created'] as String,
  );

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final Map<String, String> origin;
  final Map<String, String> location;
  final String image;
  final List<String> episode;
  final String url;
  final String created;
}
