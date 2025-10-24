part of 'bloc.dart';

enum CharacterListStatus { loading, success, failure }

sealed class CharacterListState with EquatableMixin {
  const CharacterListState({
    required this.totalCharacters,
    required List<Character> characters,
  }) : _characters = characters;

  final List<Character> _characters;
  final int totalCharacters;

  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_characters);

  bool get isFull => characters.length == totalCharacters;
  bool get isNotFull => !isFull;

  @override
  List<Object?> get props => [characters, totalCharacters];
}

final class CharacterListInitial extends CharacterListState {
  const CharacterListInitial()
    : super(totalCharacters: 0, characters: const []);
}

final class CharacterListRefreshing extends CharacterListState {
  const CharacterListRefreshing({
    super.totalCharacters = 0,
    super.characters = const [],
  });
}

final class CharacterListLoadingMore extends CharacterListState {
  const CharacterListLoadingMore({
    super.totalCharacters = 0,
    super.characters = const [],
  });
}

final class CharacterListSuccess extends CharacterListState {
  const CharacterListSuccess({
    required super.totalCharacters,
    required super.characters,
  });
}

final class CharacterListFailure extends CharacterListState {
  const CharacterListFailure({
    super.totalCharacters = 0,
    super.characters = const [],
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

// class CharacterListStateOld with EquatableMixin {
//   const CharacterListStateOld({
//     required this.status,
//     required List<Character> characters,
//     required this.totalCharacters,
//     required this.message,
//   }) : _characters = characters;

//   static const initial = CharacterListStateOld(
//     status: CharacterListStatus.loading,
//     characters: [],
//     totalCharacters: null,
//     message: '',
//   );

//   CharacterListStateOld copyWith({
//     final CharacterListStatus? status,
//     final List<Character>? characters,
//     final int? totalCharacters,
//     final String? message,
//   }) => CharacterListStateOld(
//     status: status ?? this.status,
//     characters: characters ?? this.characters,
//     totalCharacters: totalCharacters ?? this.totalCharacters,
//     message: message ?? this.message,
//   );

//   final CharacterListStatus status;
//   final List<Character> _characters;
//   final int? totalCharacters;
//   final String message;

//   UnmodifiableListView<Character> get characters =>
//       UnmodifiableListView(_characters);

//   @override
//   List<Object?> get props => [status, _characters, totalCharacters, message];
// }
