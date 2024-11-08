import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  // Private fields to track theme settings
  bool _isDarkMode = false;
  double _fontSize = 16.0;
  String _fontFamily = 'Roboto';
  String _notificationSound = 'default';

  // Singleton instance
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() => _instance;

  ThemeManager._internal();

  // Getters for theme settings
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  String get notificationSound => _notificationSound;

  // Dynamic themes based on the selected mode and user settings
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.lightBlueAccent,
    scaffoldBackgroundColor: Colors.white,
    textTheme: _buildTextTheme(),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey,
    accentColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    textTheme: _buildTextTheme(),
  );

  // Helper method to build TextTheme based on current font size and family
  TextTheme _buildTextTheme() {
    return TextTheme(
      bodyText1: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
      bodyText2: TextStyle(fontSize: _fontSize, fontFamily: _fontFamily),
    );
  }

  // Retrieve the current theme based on dark mode status
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Method to toggle dark and light themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Method to update the font size
  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  // Method to update the font family
  void setFontFamily(String font) {
    _fontFamily = font;
    notifyListeners();
  }

  // Method to update the notification sound
  void setNotificationSound(String sound) {
    _notificationSound = sound;
    notifyListeners();
  }
}
