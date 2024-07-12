import "package:flutter/material.dart";

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.lightBlue.shade50.withAlpha(200),
      indicatorColor: Colors.blue.shade400,
      elevation: 3,
      height: 50,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5))
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade400,
      surface: Colors.lightBlue.shade50,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.blueGrey.shade900.withAlpha(220),
      indicatorColor: Colors.blue.shade400,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(color: Colors.blueGrey.shade900.withAlpha(220));
        }
        return const IconThemeData(color: Colors.white); // Default color for unselected icons
      }),
      elevation: 3,
      height: 50,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5))
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade400,
      surface: Colors.blueGrey.shade900,
      background: const Color(0xFF1D2326),
    ),
  ); 
}