part of 'bloc.dart';

enum CharacterListStatus { loading, success, failure }

class CharacterListState with EquatableMixin {
  const CharacterListState({
    required this.status,
    required this.characters,
    required this.totalCharacters,
    required this.message,
  });
  static const initial = CharacterListState(
    status: CharacterListStatus.loading,
    characters: [],
    totalCharacters: 0,
    message: '',
  );

  CharacterListState copyWith({
    final CharacterListStatus? status,
    final List<Character>? characters,
    final int? totalCharacters,
    final String? message,
  }) => CharacterListState(
    status: status ?? this.status,
    characters: characters ?? this.characters,
    totalCharacters: totalCharacters ?? this.totalCharacters,
    message: message ?? this.message,
  );

  final CharacterListStatus status;
  final List<Character> characters;
  final int totalCharacters;
  final String message;

  @override
  List<Object?> get props => [status, characters, totalCharacters, message];
}
