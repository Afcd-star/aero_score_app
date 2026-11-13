// lib/src/core/theme/text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Definicion centralizada de la tipografia de AeroScore.
///
/// Sora para titulos y Manrope para cuerpo. Se declaran los quince
/// roles de TextTheme: un rol ausente hace que cualquier
/// `baseTextTheme.rol?.copyWith(...)` devuelva null y el texto pierda
/// en silencio tamano, peso y color, heredando el estilo del Material.
class AppTextStyles {
  const AppTextStyles._();

  /// Precarga las familias para evitar parpadeo en el primer frame.
  static void preload() {
    GoogleFonts.sora();
    GoogleFonts.manrope();
  }

  /// Tema tipografico base, aplicado segun el brillo en AppTheme.
  static TextTheme get baseTextTheme {
    return TextTheme(
      displayLarge: GoogleFonts.sora(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.sora(
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.sora(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
