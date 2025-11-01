part of 'bloc.dart';

enum CharacterListStatus { loading, success, failure }

sealed class CharacterListState with EquatableMixin {
  const CharacterListState({
    required PaginatedList<Character> list,
    required this.sorting,
  }) : _list = list;

  final PaginatedList<Character> _list;
  final CharacterSorting sorting;

  final int pageSizeLimit = 20;

  bool get isFull => _list.isFull;
  bool get hasMore => !_list.isFull;

  UnmodifiableListView<Character> get characters {
    var items = _list.items.toList();

    if (sorting.order == CharacterSortOrder.descending) {
      items = items.reversed.toList();
    }

    if (sorting.param == CharacterSortParam.name) {
      items.sort((a, b) => a.name.compareTo(b.name));
    } else if (sorting.param == CharacterSortParam.gender) {
      items.sort((a, b) => a.gender.index.compareTo(b.gender.index));
    }

    return UnmodifiableListView(items);
  }

  int? get total => _list.total;

  @override
  List<Object?> get props => [_list, sorting];
}

final class CharacterListInitial extends CharacterListState {
  const CharacterListInitial()
    : super(
        list: const PaginatedList(items: [], total: 0),
        sorting: const CharacterSorting(
          order: CharacterSortOrder.ascending,
          param: null,
        ),
      );
}

sealed class CharacterListLoading extends CharacterListState {
  const CharacterListLoading({
    super.list = const PaginatedList(items: [], total: 0),
    required super.sorting,
  });
}

final class CharacterListRefreshing extends CharacterListLoading {
  const CharacterListRefreshing({
    super.list = const PaginatedList(items: [], total: 0),
    required super.sorting,
  });
}

final class CharacterListLoadingMore extends CharacterListLoading {
  const CharacterListLoadingMore({
    super.list = const PaginatedList(items: [], total: 0),
    required super.sorting,
  });
}

final class CharacterListSuccess extends CharacterListState {
  const CharacterListSuccess({required super.list, required super.sorting});
}

final class CharacterListFailure extends CharacterListState {
  const CharacterListFailure({
    super.list = const PaginatedList(items: [], total: 0),
    required super.sorting,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
