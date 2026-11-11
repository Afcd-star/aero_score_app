// lib/src/shared/presentation/widgets/aero/aero_card.dart
import 'package:flutter/material.dart';

/// Card contenedor con sombra y bordes redondeados.
/// ✅ Simplificado: sin lógica compleja, solo contenedor visual.
class AeroCard extends StatelessWidget {

  const AeroCard({
    required this.child, super.key,
    this.padding,
    this.bordered = true,
    this.onTap, 
    this.margin,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool bordered;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: margin,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: bordered ? Border.all(color: theme.colorScheme.outline) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}