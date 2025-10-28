import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';

class InMemoryStorage<K, V> {
  InMemoryStorage([Map<K, V>? initial]) : _data = initial ?? {};

  final Map<K, V> _data;

  PaginatedList<V> list({
    int offset = 0,
    int? limit,
    bool Function(V value)? filter,
  }) {
    var values = _data.values;

    if (filter != null) {
      values = values.where(filter);
    }

    final total = values.length;

    if (total < offset) {
      return PaginatedList(items: const [], total: total);
    }

    values = values.skip(offset);
    if (limit != null) {
      values = values.take(limit);
    }

    return PaginatedList(items: values.toList(), total: total);
  }

  V? find(K key) => _data[key];

  void save(K key, V value) {
    _data[key] = value;
  }

  void saveMany(K Function(V value) key, Iterable<V> values) {
    print('qwer:cache:saveMany:values: ${values.length}');
    for (final value in values) {
      final k = key(value);
      print('qwer:cache: $k : $value');

      save(k, value);
    }
  }

  int get total => _data.length;
}
