
import 'package:flutter/material.dart';

const Color color1 = Color(0xfff8f8f8);
const Color color2 = Color(0xff5068a9);
const Color color3 = Color(0xff86a6df);
const Color color4 = Color(0xff324e7b);
themeData() {
  return ThemeData(
    fontFamily: "nemo2",
    scaffoldBackgroundColor: color1,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      backgroundColor: color2,
      iconTheme: IconThemeData(
        color: color1,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: color4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: color1,
      selectedItemColor: color4,
      unselectedItemColor: color3,
    ),
  );
}
