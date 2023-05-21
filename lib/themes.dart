import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///custom themes

//todo fix status bar color
class MyThemes {
  static ThemeData myDarkMode = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffBB86FC),
      onPrimary: Colors.white,
      secondary: Color(0xff03DAC6),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Color(0xff121212),
      onBackground: Color(0xffA4A4A4),
      surface: Color(0xff1e1e1e),
      onSurface: Color(0xffD7D7D7),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff1e1e1e),
        foregroundColor: Color(0xffD7D7D7),
        systemOverlayStyle: SystemUiOverlayStyle.dark),
  );

  static ThemeData myLightMode = ThemeData.light().copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1c1c1c),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white70,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, foregroundColor: Colors.black, systemOverlayStyle: SystemUiOverlayStyle.light),
  );
}
