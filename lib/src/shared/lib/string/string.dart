extension StringExtensino on String {
  String capitalise() =>
      isEmpty ? '' : replaceRange(0, 1, this[0].toUpperCase());
}
