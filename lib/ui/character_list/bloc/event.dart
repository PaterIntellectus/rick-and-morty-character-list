part of 'bloc.dart';

sealed class CharacterListEvent with EquatableMixin {
  const CharacterListEvent();

  @override
  List<Object?> get props => const [];
}

final class CharacterListRefreshed extends CharacterListEvent {
  const CharacterListRefreshed();
}

final class CharacterListRequestedMore extends CharacterListEvent {
  const CharacterListRequestedMore({required this.offset, required this.limit});

  final int offset;
  final int limit;

  @override
  List<Object?> get props => [offset, limit];
}
