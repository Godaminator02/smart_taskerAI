import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors - Red and White theme
  static const Color _primaryColorLight = Color(0xFFE53935); // Red
  static const Color _secondaryColorLight = Color(0xFFD32F2F); // Darker Red
  static const Color _backgroundColorLight = Colors.white; // White
  static const Color _surfaceColorLight = Colors.white; // White
  static const Color _errorColorLight = Color(0xFFFF5252); // Light Red
  static const Color _onPrimaryColorLight = Colors.white;
  static const Color _onSecondaryColorLight = Colors.white;
  static const Color _onBackgroundColorLight =
      Colors.black; // Black text on white background
  static const Color _onSurfaceColorLight =
      Colors.black; // Black text on white surface
  static const Color _onErrorColorLight = Colors.white;

  // Dark theme colors - Red and White theme
  static const Color _primaryColorDark = Color(0xFFE53935); // Red
  static const Color _secondaryColorDark = Color(0xFFD32F2F); // Darker Red
  static const Color _backgroundColorDark = Colors.white; // White
  static const Color _surfaceColorDark = Colors.white; // White
  static const Color _errorColorDark = Color(0xFFFF5252); // Light Red
  static const Color _onPrimaryColorDark = Colors.white;
  static const Color _onSecondaryColorDark = Colors.white;
  static const Color _onBackgroundColorDark =
      Colors.black; // Black text on white background
  static const Color _onSurfaceColorDark =
      Colors.black; // Black text on white surface
  static const Color _onErrorColorDark = Colors.black;

  // Task priority colors
  static const Color lowPriorityColor = Color(0xFF4CAF50); // Green
  static const Color mediumPriorityColor = Color(0xFFFFC107); // Amber
  static const Color highPriorityColor = Color(0xFFF44336); // Red

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primaryColorLight,
      secondary: _secondaryColorLight,
      background: _backgroundColorLight,
      surface: _surfaceColorLight,
      error: _errorColorLight,
      onPrimary: _onPrimaryColorLight,
      onSecondary: _onSecondaryColorLight,
      onBackground: _onBackgroundColorLight,
      onSurface: _onSurfaceColorLight,
      onError: _onErrorColorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColorLight,
      foregroundColor: _onPrimaryColorLight,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColorLight,
      foregroundColor: _onPrimaryColorLight,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _onPrimaryColorLight,
        backgroundColor: _primaryColorLight,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColorLight,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColorLight,
        side: const BorderSide(color: _primaryColorLight),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryColorLight, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _primaryColorLight.withOpacity(0.5)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColorLight, width: 2),
      ),
      filled: true,
      fillColor: _surfaceColorLight,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
    ),
    scaffoldBackgroundColor: _backgroundColorLight,
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: _primaryColorDark,
      secondary: _secondaryColorDark,
      background: _backgroundColorDark,
      surface: _surfaceColorDark,
      error: _errorColorDark,
      onPrimary: _onPrimaryColorDark,
      onSecondary: _onSecondaryColorDark,
      onBackground: _onBackgroundColorDark,
      onSurface: _onSurfaceColorDark,
      onError: _onErrorColorDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColorDark,
      foregroundColor: _onPrimaryColorDark,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColorDark,
      foregroundColor: _onPrimaryColorDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _onPrimaryColorDark,
        backgroundColor: _primaryColorDark,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColorDark,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColorDark,
        side: const BorderSide(color: _primaryColorDark),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryColorDark, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _primaryColorDark.withOpacity(0.5)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColorDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _errorColorDark, width: 2),
      ),
      filled: true,
      fillColor: _surfaceColorDark,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.5,
    ),
    scaffoldBackgroundColor: _backgroundColorDark,
  );

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return lowPriorityColor;
      case 'Medium':
        return mediumPriorityColor;
      case 'High':
        return highPriorityColor;
      default:
        return mediumPriorityColor;
    }
  }
}
