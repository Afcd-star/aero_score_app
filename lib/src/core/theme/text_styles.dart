// lib/src/core/theme/text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Definición centralizada de tipografía.
/// ✅ Sora (Títulos) + Manrope (Cuerpo)
/// ✅ Precarga recomendada en main.dart para evitar parpadeo.
class AppTextStyles {
  const AppTextStyles._();

  static void preload() {
    GoogleFonts.sora();
    GoogleFonts.manrope();
  }

  // ✅ Tema Base (se aplicará dinámicamente según el brillo en AppTheme)
  static TextTheme get baseTextTheme {
    return TextTheme(
      // SORA - Headings
      displayLarge: GoogleFonts.sora(
        fontSize: 36,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      
      // MANROPE - Body
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
    );
  }
}