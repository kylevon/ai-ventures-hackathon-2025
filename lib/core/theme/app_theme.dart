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

  // Event Type Colors
  static const Map<int, Color> exercise = {
    100: Color(0xFFE0E0E0), // Light black/grey
    200: Color(0xFFBDBDBD),
    300: Color(0xFF9E9E9E),
    400: Color(0xFF757575),
    500: Color(0xFF212121), // Black
    600: Color(0xFF1B1B1B),
    700: Color(0xFF151515),
    800: Color(0xFF0F0F0F),
    900: Color(0xFF090909),
  };

  static const Map<int, Color> sleep = {
    100: Color(0xFFC5CAE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7986CB),
    400: Color(0xFF5C6BC0),
    500: Color(0xFF3F51B5),
    600: Color(0xFF3949AB),
    700: Color(0xFF303F9F),
    800: Color(0xFF283593),
    900: Color(0xFF1A237E),
  };

  static const Map<int, Color> food = {
    100: Color(0xFFC8E6C9), // Light green
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50), // Green
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  };

  static const Map<int, Color> liquids = {
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  };

  static const Map<int, Color> period = {
    100: Color(0xFFFCE4EC), // Light pink
    200: Color(0xFFF8BBD0),
    300: Color(0xFFF48FB1),
    400: Color(0xFFF06292),
    500: Color(0xFFEC407A), // Pink
    600: Color(0xFFE91E63),
    700: Color(0xFFD81B60),
    800: Color(0xFFC2185B),
    900: Color(0xFFAD1457),
  };

  static const Map<int, Color> bowelMovement = {
    100: Color(0xFFD7CCC8),
    200: Color(0xFFBCAAA4),
    300: Color(0xFFA1887F),
    400: Color(0xFF8D6E63),
    500: Color(0xFF795548),
    600: Color(0xFF6D4C41),
    700: Color(0xFF5D4037),
    800: Color(0xFF4E342E),
    900: Color(0xFF3E2723),
  };

  static const Map<int, Color> heartRate = {
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  };

  static const Map<int, Color> appointments = {
    100: Color(0xFFE1BEE7),
    200: Color(0xFFCE93D8),
    300: Color(0xFFBA68C8),
    400: Color(0xFFAB47BC),
    500: Color(0xFF9C27B0),
    600: Color(0xFF8E24AA),
    700: Color(0xFF7B1FA2),
    800: Color(0xFF6A1B9A),
    900: Color(0xFF4A148C),
  };

  static const Map<int, Color> mood = {
    100: Color(0xFFB2DFDB),
    200: Color(0xFF80CBC4),
    300: Color(0xFF4DB6AC),
    400: Color(0xFF26A69A),
    500: Color(0xFF009688),
    600: Color(0xFF00897B),
    700: Color(0xFF00796B),
    800: Color(0xFF00695C),
    900: Color(0xFF004D40),
  };

  static const Map<int, Color> symptoms = {
    100: Color(0xFFFFEBEE), // Lightest red
    200: Color(0xFFFFCDD2),
    300: Color(0xFFEF9A9A),
    400: Color(0xFFE57373),
    500: Color(0xFFEF5350), // Warning red
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C), // Darkest red
  };

  static const Map<int, Color> misc = {
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(0xFF9E9E9E),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
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
