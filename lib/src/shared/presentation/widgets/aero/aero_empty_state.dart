// lib/src/shared/presentation/widgets/aero/aero_empty_state.dart
import 'package:flutter/material.dart';

/// Estado vacio de una coleccion o de una busqueda sin resultados.
///
/// Sustituye los estados vacios improvisados de las features. Las
/// superficies y los textos salen del esquema de tema, asi que es legible
/// en claro y en oscuro. El mensaje y la accion son opcionales: una
/// busqueda sin resultados no ofrece crear, una coleccion vacia si.
class AeroEmptyState extends StatelessWidget {
  /// Crea el estado vacio con su icono y su titulo.
  const AeroEmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.message,
    this.action,
  });

  /// Icono que representa la ausencia de datos.
  final IconData icon;

  /// Titulo corto, por ejemplo no hay equipos registrados.
  final String title;

  /// Explicacion opcional de por que esta vacio o de que hacer.
  final String? message;

  /// Accion opcional, por ejemplo crear el primer registro.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: text.titleSmall?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}
