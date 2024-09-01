import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black, // Text, icons, primary elements in black
    onPrimary: Colors.white, // Text on primary elements
    secondary: Colors.grey.shade100, // Background color or secondary elements
    onSecondary: Colors.black, // Text on secondary elements
    surface: Colors.white, // Background color
    onSurface: Colors.black, // Text on surface
    error: Colors.red, // Error color
    onError: Colors.white, // Text on error/ Text on background
    tertiary: Colors.grey.shade300, // Optional color for additional elements
    inversePrimary: Colors.black, // Inverse text color for dark backgrounds
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.white, // Text, icons, primary elements in white
    onPrimary: Colors.black, // Text on primary elements
    secondary: Colors.grey.shade900, // Background color or secondary elements
    onSecondary: Colors.white, // Text on secondary elements
    surface: Colors.black, // Background color
    onSurface: Colors.white, // Text on surface
    error: Colors.red, // Error color
    onError: Colors.black, // Text on error// Text on background
    tertiary: Colors.grey.shade800, // Optional color for additional elements
    inversePrimary: Colors.white, // Inverse text color for light backgrounds
  ),
);
