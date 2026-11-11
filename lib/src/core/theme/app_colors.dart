// lib/src/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Catálogo puro de colores de AeroScore.
/// ✅ NO contiene lógica, NO recibe BuildContext.
class AppColors {
  const AppColors._();

  // ═════════════════════════════════════════════════════════════
  // COLORES DE MARCA (Invariantes)
  // ═════════════════════════════════════════════════════════════
  static const Color fuchsia = Color(0xFFFF00FF);
  static const Color coral = Color(0xFFFF006A);
  static const Color mint = Color(0xFF86FBD1);
  static const Color midnight = Color(0xFF0B0D17);
  static const Color backgroundBase = Color(0xFF0A0515);
  static const Color backgroundSecondary = Color(0xFF0B0D17);

  // Glow/Decoración
  static const Color glowFuchsia = Color(0xFFFF00FF);
  static const Color glowViolet = Color(0xFF8B00FF);
  static const Color glowPink = Color(0xFFFF006A);

  // ═════════════════════════════════════════════════════════════
  // COLORES DE TEXTO
  // ═════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color.fromARGB(255, 52, 52, 54);
  static const Color textOnWhite = Color(0xFF252525);

  // ═════════════════════════════════════════════════════════════
  // LIGHT MODE
  // ═════════════════════════════════════════════════════════════
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF252525);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardForegroundLight = Color(0xFF252525);
  static const Color primaryLight = Color(0xFF030213);
  static const Color primaryForegroundLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFFF1F2F6);
  static const Color secondaryForegroundLight = Color(0xFF030213);
  static const Color mutedLight = Color(0xFFECECF0);
  static const Color mutedForegroundLight = Color(0xFF717182);
  static const Color accentLight = Color(0xFFE9EBEF);
  static const Color accentForegroundLight = Color(0xFF030213);
  static const Color destructiveLight = Color(0xFFD4183D);
  static const Color destructiveForegroundLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0x1A000000);
  static const Color inputBackgroundLight = Color(0xFFF3F3F5);
  static const Color ringLight = Color(0xFFB5B5B5);
  static const Color successLight = Color(0xFF22C55E);

  // ═════════════════════════════════════════════════════════════
  // DARK MODE
  // ═════════════════════════════════════════════════════════════
  static const Color backgroundDark = Color(0xFF252525);
  static const Color foregroundDark = Color(0xFFFAFAFA);
  static const Color cardDark = Color(0xFF252525);
  static const Color cardForegroundDark = Color(0xFFFAFAFA);
  static const Color primaryDark = Color(0xFFFAFAFA);
  static const Color primaryForegroundDark = Color(0xFF343434);
  static const Color secondaryDark = Color(0xFF454545);
  static const Color secondaryForegroundDark = Color(0xFFFAFAFA);
  static const Color mutedDark = Color(0xFF454545);
  static const Color mutedForegroundDark = Color(0xFFB5B5B5);
  static const Color accentDark = Color(0xFF454545);
  static const Color accentForegroundDark = Color(0xFFFAFAFA);
  static const Color destructiveDark = Color(0xFF8B2340);
  static const Color destructiveForegroundDark = Color(0xFFA85665);
  static const Color borderDark = Color(0xFF454545);
  static const Color inputDark = Color(0xFF454545);
  static const Color ringDark = Color(0xFF707070);
  static const Color successDark = Color(0xFF16A34A);

  // ═════════════════════════════════════════════════════════════
  // SURFACES & BORDERS
  // ═════════════════════════════════════════════════════════════
  static const surfaceBase = Color.fromARGB(255, 240, 240, 248);
  static const surfaceElevated = Color.fromARGB(255, 220, 220, 243);
  static const borderSubtle = Color(0xFF454545);

  // ═════════════════════════════════════════════════════════════
  // ROLES (9 tipos)
  // ═════════════════════════════════════════════════════════════
  static const Color roleAdminLight = Color(0xFFEF4444);
  static const Color roleJudgePrincipalLight = Color(0xFFF59E0B);
  static const Color roleJudgeALight = Color(0xFF3B82F6);
  static const Color roleJudgeDLight = Color(0xFFA855F7);
  static const Color roleJudgeELight = Color(0xFF6366F1);
  static const Color roleCoachLight = Color(0xFF14B8A6);
  static const Color roleOrganizerLight = Color(0xFF22C55E);
  static const Color roleViewerLight = Color(0xFF6B7280);
  // Rol desconocido o no catalogado. Escala slate para separarlo
  // del gris de espectador y señalar anomalía de datos.
  static const Color roleUnknownLight = Color(0xFF94A3B8);
  static const Color roleAdminDark = Color(0xFFDC2626);
  static const Color roleJudgePrincipalDark = Color(0xFFD97706);
  static const Color roleJudgeADark = Color(0xFF2563EB);
  static const Color roleJudgeDDark = Color(0xFF9333EA);
  static const Color roleJudgeEDark = Color(0xFF4F46E5);
  static const Color roleCoachDark = Color(0xFF0D9488);
  static const Color roleOrganizerDark = Color(0xFF16A34A);
  static const Color roleViewerDark = Color(0xFF4B5563);
  // Rol desconocido o no catalogado en modo oscuro.
  static const Color roleUnknownDark = Color(0xFF64748B);

  // ═════════════════════════════════════════════════════════════
  // FACULTADES (UCI)
  // ═════════════════════════════════════════════════════════════
  static const Color facultyFIO = Color(0xFF3B82F6);
  static const Color facultyFTL = Color(0xFF22C55E);
  static const Color facultyFTI = Color(0xFFA855F7);
  static const Color facultyFTE = Color(0xFFEAB308);

  // ═════════════════════════════════════════════════════════════
  // GRADIENTES
  // ═════════════════════════════════════════════════════════════
  static LinearGradient getGlowGradient({bool diagonal = true}) {
    return LinearGradient(
      begin: diagonal ? Alignment.topLeft : Alignment.center,
      end: diagonal ? Alignment.bottomRight : Alignment.center,
      colors: const [glowFuchsia, glowViolet],
    );
  }
}