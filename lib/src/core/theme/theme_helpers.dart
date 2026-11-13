// lib/src/core/theme/theme_helpers.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:flutter/material.dart';

/// Helpers que consumen AppColors pero requieren contexto de UI.
class ThemeHelper {
  const ThemeHelper._();

  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight;

  static Color getForeground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.foregroundDark
          : AppColors.foregroundLight;

  static Color getCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardDark
          : AppColors.cardLight;

  static Color getBorder(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  static Color getInputBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.inputDark
          : AppColors.inputBackgroundLight;

  static Color getSuccess(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.successDark
          : AppColors.successLight;

  static Color getRoleColor(UserRole role, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (role) {
      UserRole.admin =>
          isDark
              ? AppColors.roleAdminDark
              : AppColors.roleAdminLight,
      UserRole.judgeP =>
          isDark
              ? AppColors.roleJudgePrincipalDark
              : AppColors.roleJudgePrincipalLight,
      UserRole.judgeA =>
          isDark
              ? AppColors.roleJudgeADark
              : AppColors.roleJudgeALight,
      UserRole.judgeD =>
          isDark
              ? AppColors.roleJudgeDDark
              : AppColors.roleJudgeDLight,
      UserRole.judgeE =>
          isDark
              ? AppColors.roleJudgeEDark
              : AppColors.roleJudgeELight,
      UserRole.organizer =>
          isDark
              ? AppColors.roleOrganizerDark
              : AppColors.roleOrganizerLight,
      UserRole.coach =>
          isDark
              ? AppColors.roleCoachDark
              : AppColors.roleCoachLight,
      UserRole.viewer =>
          isDark
              ? AppColors.roleViewerDark
              : AppColors.roleViewerLight,
      UserRole.unknown =>
          isDark
              ? AppColors.roleUnknownDark
              : AppColors.roleUnknownLight,
    };
  }

  static Color getFacultyColor(String faculty) {
    return switch (faculty.toUpperCase().trim()) {
      'FIO' => AppColors.facultyFIO,
      'FTL' => AppColors.facultyFTL,
      'FTI' => AppColors.facultyFTI,
      'FTE' => AppColors.facultyFTE,
      _ => Colors.grey.shade400,
    };
  }
}
