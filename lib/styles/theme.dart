import 'package:flutter/material.dart';

const Color _grisFondo     = Color(0xFF212121); // fondo general (gris oscuro)
const Color _grisTarjeta   = Color(0xFF464646); // tarjetas (gris menos oscuro)
const Color _naranja       = Color(0xFFFFA726); // naranja para marca/modelo
const Color _textoClaro    = Color(0xFFE0E0E0); // texto claro
const Color _textoSecundario = Color(0xFFBDBDBD); // texto menos destacado

final ColorScheme appColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _grisTarjeta,
  onPrimary: _textoClaro,
  secondary: _naranja,
  onSecondary: Colors.black,
  background: _grisFondo,
  onBackground: _textoClaro,
  surface: _grisTarjeta,
  onSurface: _textoClaro,
  error: Colors.red,
  onError: Colors.white,
  primaryContainer: _grisTarjeta,
  secondaryContainer: _naranja,
);

// Theme global:
final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: appColorScheme,
  scaffoldBackgroundColor: appColorScheme.background,

  appBarTheme: AppBarTheme(
    backgroundColor: appColorScheme.primary,
    elevation: 2,
    iconTheme: IconThemeData(color: appColorScheme.onPrimary),
    titleTextStyle: TextStyle(
      color: appColorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: _textoClaro,
      fontSize: 14,
    ),
    titleMedium: TextStyle(
      color: _textoSecundario,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: _naranja, // Marca y modelo
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: _textoClaro,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: appColorScheme.secondary,
      foregroundColor: appColorScheme.onSecondary,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: appColorScheme.secondary,
      textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _grisTarjeta,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: _textoSecundario),
  ),

  cardTheme: CardThemeData(
    color: _grisTarjeta,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
);
