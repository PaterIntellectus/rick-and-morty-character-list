import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  final _lightTheme = ThemeData(brightness: Brightness.light);
  final _darkTheme = ThemeData(brightness: Brightness.dark);

  late var _theme = _lightTheme;

  ThemeData get theme => _theme;

  bool get isLight => theme == _lightTheme;
  bool get isDark => theme == _darkTheme;

  void toggleTheme() {
    _theme = isLight ? _darkTheme : _lightTheme;
    notifyListeners();
  }
}
