import 'package:flutter/material.dart';

const Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

ThemeData defaultTheme = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF3f6a85),
    selectionColor: Color(0xFF3f6a85),
    selectionHandleColor: Color(0xFF3f6a85),
  ),
  brightness: Brightness.light,
  primarySwatch: const MaterialColor(0xFF3f6a85, color),
  colorScheme: _defaultColorTheme,
  textTheme: _defaultTextTheme,
);

ColorScheme _defaultColorTheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    // secondaryContainer: Colors.white,
    onPrimary: Color(0xFFfdb400),
    secondary: Color(0xFFfdb400),
    onSecondary: Color(0xFFFFFFFF), // can also be whiteish
    tertiary: Color(0xFF3f6a85),
    onTertiary: Color(0xFFfdb400),
    error: Colors.black,
    onError: Colors.red,
    background: Color(0xFFfff9fe),
    onBackground: Color(0xFFfdb400),
    surface: Color(0xFFfff9fe),
    onSurface: Color(0xFF3f6a85));

//text styling
TextTheme _defaultTextTheme = const TextTheme(
  displayLarge: TextStyle(
      fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
  displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
);
