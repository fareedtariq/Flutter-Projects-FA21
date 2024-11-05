import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  // Track whether dark mode is enabled
  bool _isDarkMode = false;
  // User-selected font size and font family
  double _fontSize = 16.0;
  String _fontFamily = 'Roboto';
  // User-selected notification sound
  String _notificationSound = 'default';

  // Getters
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get notificationSound => _notificationSound;

  // Themes
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.lightBlueAccent,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
      bodyText2: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
    accentColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
      bodyText2: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
    ),
  );

  // Methods to toggle theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Method to update font size
  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  // Method to update font family
  void setFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  // Method to update notification sound
  void setNotificationSound(String sound) {
    _notificationSound = sound;
    notifyListeners();
  }

  // Method to retrieve the current theme based on mode
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Factory or Singleton pattern to manage a single instance of ThemeManager
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal();
}
