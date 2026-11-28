// lib/src/shared/presentation/widgets/aero/aero_button.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/app_dimens.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Variantes visuales del boton.
enum AeroButtonVariant {
  /// Accion principal. Toma el degradado de marca por defecto.
  primary,

  /// Accion de contorno, fondo transparente y borde del esquema.
  outline,

  /// Accion destructiva, tinte rojo suave con texto rojo.
  destructive,

  /// Accion discreta, sin fondo ni borde.
  ghost,

  /// Accion de apoyo sobre superficie secundaria.
  secondary,

  /// Acción de marca con fondo tenue y borde suave, leídos de tokens.
  ///
  /// Replica el patrón del botón de volver, fondo de marca al diez por
  /// ciento y borde al treinta por ciento, pero expresado como tokens
  /// opacos medidos en vez de alfas cableadas en la vista. El texto y el
  /// icono salen en el acento de marca. Contraste verificado por prueba
  /// numérica: cinco coma cero cinco en claro y cinco coma cero dos en
  /// oscuro, ambos por encima del umbral de texto. El borde es decorativo
  /// en los dos modos y no cumple el umbral de componente.
  brandSoft,
}

/// Tallas del boton, que deciden relleno vertical y tamano de texto.
enum AeroButtonSize {
  /// Compacta, para filas densas y dialogos.
  sm,

  /// Media, valor por defecto.
  md,

  /// Grande, para acciones destacadas.
  lg,
}

/// Boton del catalogo, con variantes, tallas, carga y modo solo icono.
class AeroButton extends StatelessWidget {
  /// Crea el boton. Exige etiqueta, modo solo icono o un icono.
  const AeroButton({
    super.key,
    this.label, // ✅ Sin required
    this.onPressed,
    this.variant = AeroButtonVariant.primary,
    this.size = AeroButtonSize.md,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.gradient,
    this.height,
    this.width,
    this.padding,
    this.trailingIcon,
    this.iconOnly = false,
    this.borderRadius = 10,
  }) : assert(
         label != null || iconOnly || icon != null,
         'Debe proporcionar label, iconOnly=true, o un icon',
       );

  /// Texto del boton. Opcional si hay icono o modo solo icono.
  final String? label;

  /// Accion al pulsar. Nulo deja el boton deshabilitado.
  final VoidCallback? onPressed;

  /// Variante visual que decide fondo, texto y borde.
  final AeroButtonVariant variant;

  /// Talla que decide relleno vertical y tamano de texto.
  final AeroButtonSize size;

  /// Si es verdadero, muestra progreso y bloquea la pulsacion.
  final bool isLoading;

  /// Icono a la izquierda del texto, o unico en modo solo icono.
  final Widget? icon;

  /// Si es verdadero, ocupa todo el ancho disponible.
  final bool fullWidth;

  /// Degradado explicito. Sobrescribe el de la variante primaria.
  final LinearGradient? gradient;

  /// Alto fijo opcional.
  final double? height;

  /// Ancho fijo opcional.
  final double? width;

  /// Relleno explicito. Sobrescribe el de la talla.
  final EdgeInsetsGeometry? padding;

  /// Icono a la derecha del texto.
  final IconData? trailingIcon;

  /// Si es verdadero, muestra solo el icono centrado.
  final bool iconOnly;

  /// Radio de las esquinas del botón.
  ///
  /// Por defecto diez, el valor histórico de la casa. Pasar la mitad del
  /// alto produce un círculo, que es lo que usa el control de retorno al
  /// principio de las listas.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (bgColor, fgColor, border) = _getColors(theme, isDark);
    final (verticalPadding, fontSize) = _getDimensions();

    final effectiveGradient =
        gradient ??
        (variant == AeroButtonVariant.primary
            ? AppColors.getGlowGradient()
            : null);
    final hasGradient = effectiveGradient != null;
    final buttonBackgroundColor = hasGradient ? Colors.transparent : bgColor;
    final textColor = hasGradient ? Colors.white : fgColor;

    // ✅ Determinar padding: personalizado, icon-only, o default
    final effectivePadding =
        padding ??
        (iconOnly
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding));

    final buttonChild = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonBackgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        padding: effectivePadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: hasGradient ? BorderSide.none : border,
        ),
        textStyle: AppTextStyles.baseTextTheme.labelLarge!.copyWith(
          fontSize: fontSize,
        ),
        shadowColor: hasGradient ? Colors.transparent : Colors.black26,
        // ✅ Fixed size si se especifica width/height
        minimumSize: Size(
          width ?? (iconOnly ? 44 : 0),
          height ?? (iconOnly ? 44 : AppDimens.controlHeight),
        ),
      ),
      child: _buildChild(isLoading, textColor),
    );

    // ✅ Si hay gradiente, envolver en Container
    if (hasGradient) {
      return SizedBox(
        width: fullWidth ? double.infinity : width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: effectiveGradient.colors.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: buttonChild,
          ),
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: buttonChild,
    );
  }

  Widget _buildChild(bool isLoading, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    // ✅ Modo icon-only: solo muestra el ícono centrado
    if (iconOnly && icon != null) {
      return IconTheme(
        data: IconThemeData(color: textColor, size: 20),
        child: icon!,
      );
    }

    // ✅ Modo normal: ícono + label + trailing icon
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: iconOnly
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: textColor, size: 18),
            child: icon!,
          ),
          if (!iconOnly) const SizedBox(width: 8),
        ],
        if (!iconOnly && label != null)
          Flexible(
            child: Text(
              label!,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
          ),
        if (!iconOnly && trailingIcon != null) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: IconThemeData(color: textColor, size: 18),
            child: Icon(trailingIcon),
          ),
        ],
      ],
    );
  }

  (Color, Color, BorderSide) _getColors(ThemeData theme, bool isDark) {
    switch (variant) {
      case AeroButtonVariant.primary:
        // El borde de esta variante nunca se pinta: la primaria siempre
        // lleva degradado, propio o recibido, y el render fija el lado en
        // ninguno cuando hay degradado. Se devuelve ninguno para que el
        // código no mienta sobre lo que dibuja.
        //
        // Hallazgo registrado para el frente de descableado de tema: el
        // fondo y el texto de esta variante también se descartan, porque
        // con degradado el fondo se fuerza a transparente y el texto a
        // blanco. Retirarlos dejaría huérfanos a los tokens de texto sobre
        // primario, y eso es realineación de paleta, no pieza muerta.
        return (
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? AppColors.primaryForegroundDark
              : AppColors.primaryForegroundLight,
          BorderSide.none,
        );
      case AeroButtonVariant.destructive:
        return (
          // ✅ Para destructive: fondo claro con alpha
          AppColors.destructiveLight.withValues(alpha: 0.1),
          AppColors.destructiveLight,
          BorderSide(
            color: AppColors.destructiveLight.withValues(alpha: 0.3),
          ),
        );
      case AeroButtonVariant.outline:
        return (
          Colors.transparent,
          theme.colorScheme.onSurface,
          BorderSide(color: theme.colorScheme.outline),
        );
      case AeroButtonVariant.secondary:
        return (
          isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
          isDark
              ? AppColors.secondaryForegroundDark
              : AppColors.secondaryForegroundLight,
          BorderSide.none,
        );
      case AeroButtonVariant.ghost:
        return (
          Colors.transparent,
          theme.colorScheme.onSurface.withValues(alpha: 0.7),
          BorderSide.none,
        );
      case AeroButtonVariant.brandSoft:
        return (
          isDark
              ? AppColors.brandSoftBackgroundDark
              : AppColors.brandSoftBackgroundLight,
          isDark
              ? AppColors.brandSoftForegroundDark
              : AppColors.brandSoftForegroundLight,
          BorderSide(
            color: isDark
                ? AppColors.brandSoftBorderDark
                : AppColors.brandSoftBorderLight,
          ),
        );
    }
  }

  (double, double) _getDimensions() {
    switch (size) {
      case AeroButtonSize.sm:
        return (8, 13);
      case AeroButtonSize.md:
        return (12, 14);
      case AeroButtonSize.lg:
        return (14, 15);
    }
  }
}
