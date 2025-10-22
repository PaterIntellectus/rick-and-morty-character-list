class Page<T> {
  const Page({required this.items, this.totalItemsCount, this.next, this.prev});

  final List<T> items;
  final int? totalItemsCount;
  final Uri? next;
  final Uri? prev;
}
