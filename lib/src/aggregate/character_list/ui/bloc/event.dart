part of 'bloc.dart';

sealed class CharacterListEvent with EquatableMixin {
  const CharacterListEvent();

  @override
  List<Object?> get props => const [];
}

final class CharacterListRefreshed extends CharacterListEvent {
  const CharacterListRefreshed({this.filter});

  final CharacterFilter? filter;

  @override
  List<Object?> get props => [...super.props, filter];
}

final class CharacterListRequestedMore extends CharacterListEvent {
  const CharacterListRequestedMore({
    required this.offset,
    required this.limit,
    this.filter,
  });

  final int offset;
  final int limit;
  final CharacterFilter? filter;

  @override
  List<Object?> get props => [...super.props, offset, limit, filter];
}

final class CharacterListToggleCharacterFavoriteStatus
    extends CharacterListEvent {
  const CharacterListToggleCharacterFavoriteStatus({
    required this.id,
    this.value,
  });

  final CharacterId id;
  final bool? value;

  @override
  List<Object?> get props => [...super.props, id, value];
}
