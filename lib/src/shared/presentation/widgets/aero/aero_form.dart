// lib/src/shared/presentation/widgets/aero/aero_form.dart
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════
// AERO FORM - Wrapper que envuelve Form con autovalidación
// ═════════════════════════════════════════════════════════════

class AeroForm extends StatelessWidget {

  const AeroForm({
    required this.child, super.key,
    this.formKey,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onSubmit,
  });
  final Widget child;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode autovalidateMode;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // ✅ Si hay onSubmit, no permitir pop automático
      canPop: onSubmit == null,

      // ✅ NUEVO: Usar onPopInvokedWithResult en lugar de onPopInvoked
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // Si ya se permitió el pop, no hacer nada

        if (onSubmit != null) {
          // Si hay onSubmit, validar y ejecutar
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

// ═════════════════════════════════════════════════════════════
// AERO FORM FIELD - Wrapper inteligente para label + field + error
// ═════════════════════════════════════════════════════════════

class AeroFormField extends StatefulWidget {
  

  const AeroFormField({
    required this.label, required this.field, super.key,
    this.errorText,
    this.required = false,
    this.onFocusChange,
  });
  final String label;
  final Widget? field;
  final String? errorText;
  final bool required;
  final ValueChanged<bool>? onFocusChange;

  @override
  State<AeroFormField> createState() => _AeroFormFieldState();
}

class _AeroFormFieldState extends State<AeroFormField> {
  final _fieldKey = GlobalKey<FormFieldState>();
  String? _currentError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateError();
    });
  }

  void _updateError() {
    if (_fieldKey.currentState != null) {
      final newError = _fieldKey.currentState!.errorText;
      if (newError != _currentError) {
        setState(() {
          _currentError = newError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorText = widget.errorText ?? _currentError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con asterisco rojo
        Row(
          children: [
            Text(
              widget.label,
              style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.required) ...[
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
        // Field envuelto para detectar errores
        NotificationListener<FormFieldNotification>(
          onNotification: (notification) {
            _updateError();
            widget.onFocusChange?.call(notification.hasFocus);
            return true;
          },
          child: KeyedSubtree(key: _fieldKey, child: widget.field!),
        ),
        // Mensaje de error
        if (errorText != null && errorText.isNotEmpty) ...[
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
                  errorText,
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

// ═════════════════════════════════════════════════════════════
// NOTIFICACIÓN PARA CAMBIOS EN FORM FIELD
// ═════════════════════════════════════════════════════════════

class FormFieldNotification extends Notification {

  FormFieldNotification({this.errorText, this.hasFocus = false});
  final String? errorText;
  final bool hasFocus;
}
