import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController() : _theme = _lightTheme;

  static final _lightTheme = ThemeData(brightness: Brightness.light);
  static final _darkTheme = ThemeData(brightness: Brightness.dark);

  ThemeData _theme;
  ThemeData get theme => _theme;

  bool get isLight => theme == _lightTheme;
  bool get isDark => theme == _darkTheme;

  void toggleTheme() {
    _theme = isLight ? _darkTheme : _lightTheme;
    notifyListeners();
  }
}
