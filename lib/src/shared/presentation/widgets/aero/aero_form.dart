// lib/src/shared/presentation/widgets/aero/aero_form.dart
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Envoltorio de formulario con autovalidacion y envio por gesto de salida.
///
/// Si se pasa un aviso de envio, el gesto de retroceso no cierra la
/// pantalla: valida el formulario y, solo si pasa, dispara el envio.
class AeroForm extends StatelessWidget {
  /// Crea el envoltorio con su hijo y su clave de formulario opcionales.
  const AeroForm({
    required this.child,
    super.key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onSubmit,
  });

  /// Contenido del formulario, normalmente una columna de campos.
  final Widget child;

  /// Clave del formulario, necesaria para validar desde fuera.
  final GlobalKey<FormState>? formKey;

  /// Politica de autovalidacion. Por defecto tras la primera interaccion.
  final AutovalidateMode autovalidateMode;

  /// Envio al intentar salir con el formulario valido.
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: onSubmit == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (onSubmit != null) {
          final formState = formKey?.currentState;
          if (formState != null && formState.validate()) {
            onSubmit!();
          }
        }
      },
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: child,
      ),
    );
  }
}

/// Par de etiqueta y campo, con marca de obligatorio y error externo.
///
/// El error interno del campo lo muestra el propio campo. Este par solo
/// muestra el error que el consumidor le pase desde fuera.
class AeroFormField extends StatelessWidget {
  /// Crea el par con su etiqueta y su campo obligatorios.
  const AeroFormField({
    required this.label,
    required this.field,
    super.key,
    this.errorText,
    this.required = false,
  });

  /// Texto de la etiqueta sobre el campo.
  final String label;

  /// Campo que se envuelve. Si es nulo, no se pinta nada bajo la etiqueta.
  final Widget? field;

  /// Error externo que se muestra bajo el campo.
  final String? errorText;

  /// Si es verdadero, anade la marca de obligatorio a la etiqueta.
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        ?field,
        if (errorText != null && errorText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 14,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorText!,
                  style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
