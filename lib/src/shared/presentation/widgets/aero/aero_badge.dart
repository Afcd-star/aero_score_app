// lib/src/shared/presentation/widgets/aero/aero_badge.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// ✅ Variantes semánticas para badges (consistente con sistema de diseño)
enum BadgeVariant {
  primary, // Fucsia: acciones principales, destacado
  secondary, // Gris: información neutra, estados por defecto
  success, // Verde: completado, activo, éxito
  info, // Azul: próximo, informativo, pendiente
  warning, // Amarillo: atención, revisión requerida
  destructive, // Rojo: error, cancelado, crítico
}

/// ✅ Tamaños predefinidos para consistencia visual
enum BadgeSize {
  small, // 20px height, 10px font: listas densas, filtros
  medium, // 24px height, 12px font: uso general (default)
  large, // 32px height, 14px font: headers, destaque
}

class AeroBadge extends StatelessWidget {
  const AeroBadge({
    required this.label,
    super.key,
    this.variant = BadgeVariant.secondary,
    this.size = BadgeSize.medium,
    this.icon,
    this.showIcon = true,
    this.customColor,
    this.customBackgroundColor,
  });
  final String label;
  final BadgeVariant variant;
  final BadgeSize size;
  final IconData? icon;
  final bool showIcon;
  final Color? customColor;
  final Color? customBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Colores por variante (override con custom si se proporciona)
    final colors = _getVariantColors(variant, isDark);
    final textColor = customColor ?? colors.text;
    final bgColor = customBackgroundColor ?? colors.background;

    // ✅ Dimensiones por tamaño
    final dimensions = _getSizeDimensions(size);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: dimensions.paddingVertical,
        horizontal: dimensions.paddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && icon != null) ...[
            Icon(
              icon,
              size: dimensions.iconSize,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Mapeo variante a colores, con pares de tinte suave por modo.
  ///
  /// Success, info, warning y destructive usan fondo de contenedor
  /// tenue y texto saturado en ambos modos, lo que corrige el contraste
  /// roto, la condicion de atencion invertida y el cable de ambar de
  /// Material, y de paso da a info su matiz informativo en vez del
  /// fucsia de marca que heredo. Primary conserva el solido de marca
  /// como enfasis y queda pendiente del frente de tokens de marca.
  /// Secondary conserva el neutro suave; sus grises de Material quedan
  /// como deuda de descableado.
  ({Color text, Color background, Color border}) _getVariantColors(
    BadgeVariant variant,
    bool isDark,
  ) {
    return switch (variant) {
      BadgeVariant.primary => (
        text: Colors.white,
        background: AppColors.fuchsia,
        border: AppColors.fuchsia,
      ),
      BadgeVariant.secondary => (
        text: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        background: isDark ? AppColors.cardDark : Colors.grey.shade100,
        border: isDark ? AppColors.borderDark : Colors.grey.shade300,
      ),
      BadgeVariant.success => (
        text: isDark
            ? AppColors.successOnContainerDark
            : AppColors.successOnContainerLight,
        background: isDark
            ? AppColors.successContainerDark
            : AppColors.successContainerLight,
        border: isDark
            ? AppColors.successOnContainerDark
            : AppColors.successOnContainerLight,
      ),
      BadgeVariant.info => (
        text: isDark
            ? AppColors.infoOnContainerDark
            : AppColors.infoOnContainerLight,
        background: isDark
            ? AppColors.infoContainerDark
            : AppColors.infoContainerLight,
        border: isDark
            ? AppColors.infoOnContainerDark
            : AppColors.infoOnContainerLight,
      ),
      BadgeVariant.warning => (
        text: isDark
            ? AppColors.warningOnContainerDark
            : AppColors.warningOnContainerLight,
        background: isDark
            ? AppColors.warningContainerDark
            : AppColors.warningContainerLight,
        border: isDark
            ? AppColors.warningOnContainerDark
            : AppColors.warningOnContainerLight,
      ),
      BadgeVariant.destructive => (
        text: isDark
            ? AppColors.destructiveOnContainerDark
            : AppColors.destructiveOnContainerLight,
        background: isDark
            ? AppColors.destructiveContainerDark
            : AppColors.destructiveContainerLight,
        border: isDark
            ? AppColors.destructiveOnContainerDark
            : AppColors.destructiveOnContainerLight,
      ),
    };
  }

  /// ✅ Dimensiones por tamaño predefinido
  ({
    double fontSize,
    double paddingVertical,
    double paddingHorizontal,
    double borderRadius,
    double iconSize,
  })
  _getSizeDimensions(BadgeSize size) {
    return switch (size) {
      BadgeSize.small => (
        fontSize: 10,
        paddingVertical: 4,
        paddingHorizontal: 8,
        borderRadius: 10,
        iconSize: 12,
      ),
      BadgeSize.medium => (
        fontSize: 12,
        paddingVertical: 6,
        paddingHorizontal: 12,
        borderRadius: 12,
        iconSize: 14,
      ),
      BadgeSize.large => (
        fontSize: 14,
        paddingVertical: 8,
        paddingHorizontal: 16,
        borderRadius: 16,
        iconSize: 16,
      ),
    };
  }
}
