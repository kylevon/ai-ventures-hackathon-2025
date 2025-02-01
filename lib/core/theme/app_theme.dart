import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Map<int, Color> primary = {
    100: Color(0xFFE8EFEF),
    200: Color(0xFFD1DFDF),
    300: Color(0xFFA3BFBF),
    400: Color(0xFF75A0A0),
    500: Color(0xFF497d7b),
    600: Color(0xFF3B6463),
    700: Color(0xFF2D4B4A),
    800: Color(0xFF1F3232),
    900: Color(0xFF111919),
  };

  // Gray Colors
  static const Map<int, Color> gray = {
    100: Color(0xFFf8fafa),
    200: Color(0xFFeef1f1),
    300: Color(0xFFe4e8e8),
    400: Color(0xFFcbd2d2),
    500: Color(0xFFa3adad),
    600: Color(0xFF7a8686),
    700: Color(0xFF5c6666),
    800: Color(0xFF3d4444),
    900: Color(0xFF1f2222),
  };

  // Orbit Colors with opacity
  static const List<Color> orbitColors = [
    Color(0x66808080), // Medium grey
    Color(0x59A9A9A9), // Dark grey
    Color(0x4DC0C0C0), // Silver
    Color(0x40D3D3D3), // Light grey
    Color(0x33DCDCDC), // Gainsboro
    Color(0x26F5F5F5), // White smoke
    Color(0x1AFAFAFF), // Snow
    Color(0x0DFFFFFF), // White
  ];

  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w200,
    color: Color(0xFF497d7b), // primary[500]
    letterSpacing: 0.5,
  );

  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: gray[100],
      border: _buildInputBorder(gray[300]!, 1),
      enabledBorder: _buildInputBorder(gray[300]!, 1),
      focusedBorder: _buildInputBorder(primary[500]!, 2),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  static OutlineInputBorder _buildInputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary[500],
    minimumSize: const Size(120, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 2,
  );

  static TextStyle buttonTextStyle = TextStyle(
    color: gray[100],
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle registerButtonTextStyle = TextStyle(
    color: primary[500],
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  // Theme Configuration Methods
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      elevatedButtonTheme: _lightElevatedButtonTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      elevatedButtonTheme: _darkElevatedButtonTheme,
    );
  }

  static ColorScheme get _lightColorScheme {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primary[500]!,
      onPrimary: Colors.white,
      secondary: primary[300]!,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: gray[100]!,
      onBackground: gray[900]!,
      surface: Colors.white,
      onSurface: gray[900]!,
    );
  }

  static ColorScheme get _darkColorScheme {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: primary[400]!,
      onPrimary: Colors.white,
      secondary: primary[300]!,
      onSecondary: Colors.white,
      error: Colors.red[300]!,
      onError: Colors.white,
      background: gray[900]!,
      onBackground: gray[100]!,
      surface: gray[800]!,
      onSurface: gray[100]!,
    );
  }

  static AppBarTheme get _lightAppBarTheme {
    return AppBarTheme(
      backgroundColor: primary[500],
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  static AppBarTheme get _darkAppBarTheme {
    return AppBarTheme(
      backgroundColor: primary[700],
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  static InputDecorationTheme get _lightInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: gray[100],
      border: _buildInputBorder(gray[300]!, 1),
      enabledBorder: _buildInputBorder(gray[300]!, 1),
      focusedBorder: _buildInputBorder(primary[500]!, 2),
    );
  }

  static InputDecorationTheme get _darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: gray[800],
      border: _buildInputBorder(gray[600]!, 1),
      enabledBorder: _buildInputBorder(gray[600]!, 1),
      focusedBorder: _buildInputBorder(primary[400]!, 2),
    );
  }

  static ElevatedButtonThemeData get _lightElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: primaryButtonStyle,
    );
  }

  static ElevatedButtonThemeData get _darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary[400],
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }
}
