// lib/src/shared/presentation/widgets/aero/aero_card.dart
import 'package:flutter/material.dart';

/// Tarjeta contenedora, con superficie del esquema, borde y sombra.
///
/// Solo envuelve un hijo. Si se pasa una accion, la superficie responde
/// al toque con onda.
class AeroCard extends StatelessWidget {
  /// Crea la tarjeta con su hijo y su geometria opcionales.
  const AeroCard({
    required this.child,
    super.key,
    this.padding,
    this.bordered = true,
    this.onTap,
    this.margin,
  });

  /// Contenido de la tarjeta.
  final Widget child;

  /// Relleno interior. Por defecto veinte en todos los lados.
  final EdgeInsetsGeometry? padding;

  /// Si es verdadero, dibuja el borde del esquema.
  final bool bordered;

  /// Accion al tocar la tarjeta. Nulo deja la superficie inerte.
  final VoidCallback? onTap;

  /// Margen exterior de la tarjeta.
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
            border: bordered
                ? Border.all(color: theme.colorScheme.outline)
                : null,
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
