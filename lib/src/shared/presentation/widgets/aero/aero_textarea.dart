// lib/src/shared/presentation/widgets/aero/aero_textarea.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ✅ Input de texto multilínea con estilos AeroScore
/// Usar dentro de AeroFormField como `field:` o standalone
class AeroTextarea extends StatelessWidget {

  const AeroTextarea({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.maxLines = 4,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.showCounter = true,
    this.counterText,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.borderColor,
    this.borderRadius,
    this.contentPadding,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.newline,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.validator,
  });
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final bool showCounter;
  final String? counterText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // ✅ Colores por defecto según tema
    final effectiveFillColor = fillColor ?? 
        (isDark ? AppColors.inputDark : AppColors.inputBackgroundLight);
    final effectiveBorderColor = borderColor ?? 
        (isDark ? AppColors.borderDark : AppColors.borderLight);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveContentPadding = contentPadding ?? 
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    // ✅ Estilo de texto por defecto
    final effectiveTextStyle = textStyle ?? 
        AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        );

    // ✅ Estilo de hint por defecto
    final effectiveHintStyle = hintStyle ?? 
        AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
          color: (isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight)
              .withValues(alpha: 0.7),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Label con indicador de requerido
        if (labelText != null) ...[
          RichText(
            text: TextSpan(
              style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(text: labelText),
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.destructiveLight),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // ✅ TextFormField con estilos Aero
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: expands ? null : maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          style: effectiveTextStyle,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          
          // ✅ Decoración personalizada
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: effectiveHintStyle,
            helperText: helperText,
            helperStyle: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
            ),
            errorText: errorText,
            errorStyle: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: AppColors.destructiveLight,
            ),
            counterText: showCounter ? counterText : '',
            counterStyle: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
            ),
            
            // ✅ Bordes y fondo
            filled: true,
            fillColor: effectiveFillColor,
            contentPadding: effectiveContentPadding,
            enabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: effectiveBorderColor.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.fuchsia,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.destructiveLight,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: const BorderSide(
                color: AppColors.destructiveLight,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: effectiveBorderRadius,
              borderSide: BorderSide(
                color: effectiveBorderColor.withValues(alpha: 0.3),
              ),
            ),
            
            // ✅ Eliminar padding por defecto del counter
            counter: showCounter && counterText == null ? null : const Offstage(),
          ),
          
          // ✅ Validación
          validator: validator,
          
          // ✅ Accesibilidad
          textAlignVertical: TextAlignVertical.top,
          textCapitalization: TextCapitalization.sentences,
        ),

        // ✅ Helper text adicional si no usa el nativo
        if (helperText != null && errorText == null) ...[
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}
