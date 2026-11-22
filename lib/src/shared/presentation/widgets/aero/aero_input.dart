// lib/src/shared/presentation/widgets/aero/aero_input.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entrada de texto de una linea, con validacion nativa del formulario.
///
/// La tipografia sale del catalogo tipografico de la casa, no de fuentes
/// llamadas directamente.
class AeroInput extends StatefulWidget {
  /// Crea la entrada con su controlador y su decoracion opcionales.
  const AeroInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.inputFormatters,
    this.textCapitalization,
  });

  /// Controlador del texto editado.
  final TextEditingController? controller;

  /// Texto de pista cuando el campo esta vacio.
  final String? hintText;

  /// Etiqueta flotante del campo.
  final String? labelText;

  /// Si es verdadero, oculta el texto, para contrasenas.
  final bool obscureText;

  /// Widget al final del campo, tipico para mostrar u ocultar.
  final Widget? suffixIcon;

  /// Widget al inicio del campo.
  final Widget? prefixIcon;

  /// Tipo de teclado que pide el campo.
  final TextInputType? keyboardType;

  /// Validador nativo del formulario que lo envuelve.
  final String? Function(String?)? validator;

  /// Si es falso, el campo queda deshabilitado.
  final bool enabled;

  /// Numero maximo de lineas visibles.
  final int? maxLines;

  /// Tope de caracteres admitidos.
  final int? maxLength;

  /// Aviso en cada cambio de texto.
  final ValueChanged<String>? onChanged;

  /// Formateadores de entrada aplicados al texto.
  final List<TextInputFormatter>? inputFormatters;

  /// Politica de mayusculas del teclado.
  final TextCapitalization? textCapitalization;

  @override
  State<AeroInput> createState() => _AeroInputState();
}

class _AeroInputState extends State<AeroInput> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      style: AppTextStyles.baseTextTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.inputDark
            : AppColors.inputBackgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.fuchsia, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
