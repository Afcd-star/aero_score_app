// lib/src/shared/presentation/widgets/aero/aero_button.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

enum AeroButtonVariant { primary, outline, destructive, ghost, secondary }

enum AeroButtonSize { sm, md, lg }

class AeroButton extends StatelessWidget {

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
    this.isRequired = false,
    this.iconOnly = false, // ✅ Default false
  }) : assert(
         label != null || iconOnly || icon != null,
         'Debe proporcionar label, iconOnly=true, o un icon',
       );
  final String? label; // ✅ CAMBIO: Hacer label opcional
  final VoidCallback? onPressed;
  final AeroButtonVariant variant;
  final AeroButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;
  final LinearGradient? gradient;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final IconData? trailingIcon;
  final bool iconOnly; // ✅ NUEVO: Para botones solo-ícono
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final (bgColor, fgColor, border) = _getColors(theme, isDark);
    final (verticalPadding, fontSize) = _getDimensions();

    final hasGradient = gradient != null;
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
          borderRadius: BorderRadius.circular(10),
          side: hasGradient ? BorderSide.none : border,
        ),
        textStyle: AppTextStyles.baseTextTheme.labelLarge!.copyWith(
          fontSize: fontSize,
        ),
        shadowColor: hasGradient ? Colors.transparent : Colors.black26,
        // ✅ Fixed size si se especifica width/height
        minimumSize: Size(
          width ?? (iconOnly ? 44 : 0),
          height ?? (iconOnly ? 44 : 0),
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
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradient!.colors.first.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
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
          Text(label!, style: TextStyle(color: textColor)),
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
        return (
          isDark ? AppColors.primaryDark : AppColors.primaryLight,
          isDark
              ? AppColors.primaryForegroundDark
              : AppColors.primaryForegroundLight,
          const BorderSide(color: AppColors.fuchsia, width: 2),
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
