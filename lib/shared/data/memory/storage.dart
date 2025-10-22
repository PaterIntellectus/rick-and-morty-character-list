import 'dart:math';

class InMemoryStorage<K, V> {
  InMemoryStorage([Map<K, V>? initial]) : _data = initial ?? {};

  final Map<K, V> _data;

  List<V> list([int offset = 0, int? limit]) => _data.values.toList().sublist(
    offset,
    limit == null
        ? _data.values.length
        : min(offset + limit, _data.values.length),
  );
  V? find(K key) => _data[key];

  void save(K key, V value) => _data[key] = value;
  void saveMany(K Function(V value) key, List<V> values) {
    for (final value in values) {
      _data[key(value)] = value;
    }
  }

  int get itemCount => _data.length;
}
