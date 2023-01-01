// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class Palette {
  /// Includes [Color] that are the primary and secondary
  /// tones of the design system.
  static const Color RED = Color.fromARGB(255, 243, 83, 59);
  static const Color ORANGE = Color.fromARGB(255, 250, 159, 66);
  static const Color BLUE = Color.fromARGB(255, 91, 206, 201);
  static const Color GREEN = Color.fromARGB(255, 140, 215, 122);
  static const Color AMBER = Color.fromARGB(255, 255, 251, 235);
  static const Color BLACK = Color.fromARGB(255, 24, 24, 27);
  static const Color WHITE = Color.fromARGB(255, 254, 254, 254);
  static const Color GREY = Color.fromARGB(255, 163, 163, 163);
  static const Color DARK_GREY = Color.fromARGB(255, 64, 64, 64);

  /// Includes a color swatch of the primary tone.
  static const MaterialColor ORANGE_SWATCH =
      MaterialColor(0xfffa9f42, <int, Color>{
    50: Color.fromRGBO(250, 159, 66, 0.1),
    100: Color.fromRGBO(250, 159, 66, 0.2),
    200: Color.fromRGBO(250, 159, 66, 0.3),
    300: Color.fromRGBO(250, 159, 66, 0.4),
    400: Color.fromRGBO(250, 159, 66, 0.5),
    500: Color.fromRGBO(250, 159, 66, 0.6),
    600: Color.fromRGBO(250, 159, 66, 0.7),
    700: Color.fromRGBO(250, 159, 66, 0.8),
    800: Color.fromRGBO(250, 159, 66, 0.9),
    900: Color.fromRGBO(250, 159, 66, 1)
  });
}
