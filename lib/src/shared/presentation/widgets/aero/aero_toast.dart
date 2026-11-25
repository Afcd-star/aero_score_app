// lib/src/shared/presentation/widgets/aero/aero_toast.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Aviso temporal con superficie inversa y acento de variante.
///
/// La superficie es neutra inversa (oscuro en claro, claro en oscuro) para
/// garantizar contraste del texto en ambos modos. La semántica la carga el
/// acento: icono de Material más barra lateral de cuatro píxeles con el
/// color del contenedor semántico correspondiente.
///
/// Limpia avisos previos antes de mostrar el nuevo, y lleva margen
/// inferior para separarse de la barra de navegación.
class AeroToast {
  const AeroToast._();

  /// Muestra un aviso de éxito con acento verde.
  static void success(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      accent: AppColors.successContainerLight,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra un aviso de error con acento rojo.
  static void error(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      accent: AppColors.destructiveContainerLight,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra un aviso de atención con acento ámbar.
  static void warning(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      accent: AppColors.warningContainerLight,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Muestra un aviso informativo con acento azul.
  static void info(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      accent: AppColors.infoContainerLight,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color accent,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    assert(
      (actionLabel == null) == (onAction == null),
      'La etiqueta y la devolución de la acción van juntas',
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final background = isDark
        ? AppColors.foregroundDark
        : AppColors.foregroundLight;
    final foreground = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: accent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: foreground),
                ),
              ),
            ],
          ),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          duration: const Duration(seconds: 3),
          action: actionLabel != null && onAction != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: accent,
                  onPressed: onAction,
                )
              : null,
        ),
      );
  }
}
