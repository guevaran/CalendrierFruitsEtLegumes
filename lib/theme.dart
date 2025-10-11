import 'package:flutter/material.dart';

ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xff9DD2A8),

  // brightness: Brightness.light,
  // primary: Color(0xff89b276),
  // onPrimary: Color(0xfff6f9f4),
  // secondary: Color(0xff6d9c57),
  // onSecondary: Color(0xfff6f9f4),
  // error: Color(0xffa85e6d),
  // onError: Color(0xffeedce2),
  // background: Color(0xffe1d5c7), 
  // onBackground: Color(0xff33281c),
  // surface: Color(0xffd6c4b3),
  // surfaceTint: Color.fromARGB(151, 137, 106, 76),
  // onSurface: Color(0xff33281c),
  // onSurfaceVariant: Color(0xff375329)
);

ThemeData lightTheme() {
  final theme = ThemeData.light();

  return theme.copyWith(
    colorScheme: lightColorScheme,
    //appBarTheme: theme.appBarTheme.copyWith(backgroundColor: lightColorScheme.primary),
    scaffoldBackgroundColor: lightColorScheme.surface,
    bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(backgroundColor: lightColorScheme.surface),
    textTheme: theme.textTheme.apply(fontFamily: 'Handlee'), // bundled Handlee font
  );
}
