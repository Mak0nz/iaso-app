import "package:flutter/material.dart";

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.lightBlue.shade50.withAlpha(200),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.lightBlue.shade50.withAlpha(200),
        indicatorColor: Colors.blue.shade400,
        elevation: 3,
        height: 50,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5))),
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade400,
      surface: Colors.lightBlue.shade50,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey.shade900.withAlpha(220),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.blueGrey.shade900.withAlpha(220),
        indicatorColor: Colors.blue.shade400,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
                color: Colors.blueGrey.shade900.withAlpha(220));
          }
          return const IconThemeData(
              color: Colors.white); // Default color for unselected icons
        }),
        elevation: 3,
        height: 50,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5))),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade400,
      surfaceContainer: Colors.blueGrey.shade900,
      surfaceContainerLowest: Colors.blueGrey.shade900,
      surfaceContainerLow: Colors.blueGrey.shade900,
      surfaceContainerHigh: Colors.blueGrey.shade900,
      surfaceContainerHighest: Colors.blueGrey.shade900,
      surface: const Color(0xFF1D2326),
    ),
  );
}
