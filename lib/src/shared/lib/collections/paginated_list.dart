import 'dart:collection';

class PaginatedList<T> {
  const PaginatedList({required List<T> items, required this.total})
    : _items = items;

  final List<T> _items;
  final int total;

  UnmodifiableListView<T> get items => UnmodifiableListView<T>(_items);
  int get length => items.length;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isFull => items.length == total;

  PaginatedList<T> merge(PaginatedList<T> other) =>
      PaginatedList<T>(items: [...items, ...other.items], total: other.total);
}
