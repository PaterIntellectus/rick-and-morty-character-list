part of 'bloc.dart';

enum CharacterListStatus { loading, success, failure }

sealed class CharacterListState with EquatableMixin {
  const CharacterListState({required PaginatedList<Character> list})
    : _list = list;

  final PaginatedList<Character> _list;

  final int pageSizeLimit = 20;

  bool get isFull => _list.isFull;
  bool get hasMore => !_list.isFull;

  UnmodifiableListView<Character> get characters =>
      UnmodifiableListView(_list.items);
  int? get total => _list.total;

  @override
  List<Object?> get props => [characters];
}

final class CharacterListInitial extends CharacterListState {
  const CharacterListInitial()
    : super(list: const PaginatedList(items: [], total: 0));
}

sealed class CharacterListLoading extends CharacterListState {
  const CharacterListLoading({
    super.list = const PaginatedList(items: [], total: 0),
  });
}

final class CharacterListRefreshing extends CharacterListLoading {
  const CharacterListRefreshing({
    super.list = const PaginatedList(items: [], total: 0),
  });
}

final class CharacterListLoadingMore extends CharacterListLoading {
  const CharacterListLoadingMore({
    super.list = const PaginatedList(items: [], total: 0),
  });
}

final class CharacterListSuccess extends CharacterListState {
  const CharacterListSuccess({required super.list});
}

final class CharacterListFailure extends CharacterListState {
  const CharacterListFailure({
    super.list = const PaginatedList(items: [], total: 0),
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
