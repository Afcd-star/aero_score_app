// lib/src/shared/presentation/widgets/aero/aero_badge.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Variantes semanticas de la insignia.
enum BadgeVariant {
  /// Enfasis de marca, con fondo fucsia solido y texto blanco.
  ///
  /// Su contraste con blanco es marginal para texto pequeno y queda
  /// como deuda del frente de tokens de marca.
  primary,

  /// Informacion neutra y estados por defecto, en gris suave por modo.
  secondary,

  /// Exito, activo o completado, en verde de tinte suave por modo.
  success,

  /// Informativo o proximo, en azul de tinte suave por modo.
  info,

  /// Atencion o revision requerida, en ambar de tinte suave por modo.
  warning,

  /// Error, cancelado o critico, en rojo de tinte suave por modo.
  destructive,
}

/// Tamanos predefinidos de la insignia.
enum BadgeSize {
  /// Listas densas y filtros, con texto de diez puntos.
  small,

  /// Uso general y valor por defecto, con texto de doce puntos.
  medium,

  /// Encabezados y destaque, con texto de catorce puntos.
  large,
}

/// Insignia de estado o rol, con forma, talla y tipografia del catalogo.
///
/// El color sale de la variante semantica, salvo que el consumidor pase
/// color y fondo propios, que es como se enruta la identidad de rol.
class AeroBadge extends StatelessWidget {
  /// Crea la insignia con su etiqueta obligatoria y su variante.
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

  /// Texto que se muestra dentro de la insignia.
  final String label;

  /// Variante semantica que decide el par de colores.
  final BadgeVariant variant;

  /// Talla que decide tipografia, relleno y radio.
  final BadgeSize size;

  /// Icono opcional a la izquierda del texto.
  final IconData? icon;

  /// Si es falso, oculta el icono aunque se haya pasado.
  final bool showIcon;

  /// Color de texto propio, sobrescribe el de la variante.
  final Color? customColor;

  /// Fondo propio, sobrescribe el de la variante.
  final Color? customBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores por variante, con sobrescritura propia si se proporciona.
    final colors = _getVariantColors(variant, isDark);
    final textColor = customColor ?? colors.text;
    final bgColor = customBackgroundColor ?? colors.background;

    // Dimensiones por talla.
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

  /// Dimensiones por talla predefinida.
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
