part of 'bloc.dart';

sealed class CharacterListEvent with EquatableMixin {
  const CharacterListEvent();

  @override
  List<Object?> get props => const [];
}

final class CharacterListSubscribed extends CharacterListEvent {
  const CharacterListSubscribed({this.filter});

  final CharacterFilter? filter;

  @override
  List<Object?> get props => [...super.props, filter];
}

final class CharacterListRefreshed extends CharacterListEvent {
  const CharacterListRefreshed({this.filter});

  final CharacterFilter? filter;

  @override
  List<Object?> get props => [...super.props, filter];
}

final class CharacterListRequestedMore extends CharacterListEvent {
  const CharacterListRequestedMore({required this.page, this.filter});

  final int page;
  final CharacterFilter? filter;

  @override
  List<Object?> get props => [...super.props, page, filter];
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
