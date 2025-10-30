import 'dart:collection';

import 'package:equatable/equatable.dart';

class PaginatedList<T> with EquatableMixin {
  const PaginatedList({required List<T> items, required this.total})
    : _items = items;

  factory PaginatedList.empty({int total = 0}) =>
      PaginatedList(items: const [], total: total);

  PaginatedList<T> merge(PaginatedList<T> other) =>
      PaginatedList<T>(items: [...items, ...other.items], total: other.total);

  final List<T> _items;
  final int? total;

  UnmodifiableListView<T> get items => UnmodifiableListView<T>(_items);
  int get length => items.length;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get isFull => items.length == total;

  @override
  List<Object?> get props => [items, total];
}
