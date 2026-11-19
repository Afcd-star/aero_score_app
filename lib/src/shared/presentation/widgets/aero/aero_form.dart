// lib/src/shared/presentation/widgets/aero/aero_form.dart
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════
// AERO FORM - Wrapper que envuelve Form con autovalidación
// ═════════════════════════════════════════════════════════════

class AeroForm extends StatelessWidget {
  const AeroForm({
    required this.child,
    super.key,
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

// ═════════════════════════════════════════════════════════════
// AERO FORM FIELD - Etiqueta más campo, con error externo opcional
// ═════════════════════════════════════════════════════════════

class AeroFormField extends StatelessWidget {
  const AeroFormField({
    required this.label,
    required this.field,
    super.key,
    this.errorText,
    this.required = false,
  });
  final String label;
  final Widget? field;
  final String? errorText;
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
        if (field != null) field!,
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
