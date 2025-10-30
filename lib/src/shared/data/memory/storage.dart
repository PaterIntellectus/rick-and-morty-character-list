import 'package:rick_and_morty_character_list/src/shared/lib/collections/paginated_list.dart';
import 'package:rick_and_morty_character_list/src/shared/lib/stream/streamer.dart';

class InMemoryStorage<K, V> extends Streamer<List<V>> {
  InMemoryStorage([Map<K, V>? initial])
    : _data = initial ?? {},
      super(initial: initial?.values.toList() ?? const []);

  V? find(K key) => _data[key];

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
      return PaginatedList.empty(total: total);
    }

    if (offset > 0) {
      values = values.skip(offset);
    }

    if (limit != null && limit >= 0) {
      values = values.take(limit);
    }

    return PaginatedList(items: values.toList(), total: total);
  }

  void save(K key, V value) {
    _data[key] = value;
    add([..._data.values]);
  }

  void saveMany(K Function(V value) key, Iterable<V> values) {
    for (final value in values) {
      _data[key(value)] = value;
    }
    add([..._data.values]);
  }

  final Map<K, V> _data;

  int get total => _data.length;
}
