import 'package:flutter/material.dart';

class AuthTheme {
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: gray[300]!,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: gray[300]!,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: primary[500]!,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
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
} 