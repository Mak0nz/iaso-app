import "package:flutter/material.dart";

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white.withAlpha(200),
      indicatorColor: Colors.blue.shade400,
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade400,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.black26.withAlpha(220),
      indicatorColor: Colors.blue.shade400,
      elevation: 3,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade400,
    ),
  ); 
}