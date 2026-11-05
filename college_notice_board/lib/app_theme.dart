import 'package:flutter/material.dart';

/// The single place where a colour is chosen. Every screen reads its colours
/// from Theme.of(context).colorScheme, which is generated from this seed.
class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF1B5E9E);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    );
  }
}
