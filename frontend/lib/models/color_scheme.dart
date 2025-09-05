import 'package:flutter/material.dart';

// Default ColorSchemej
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(25, 5, 99, 125),
);

// Blueish ColorScheme
var blueishColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF2962FF), // Indigo Blue
);

var blueishDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF82B1FF), // Light Indigo
);

// Greenish ColorScheme
var greenishColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF00C853), // Emerald Green
);

var greenishDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF69F0AE), // Mint Green
);

