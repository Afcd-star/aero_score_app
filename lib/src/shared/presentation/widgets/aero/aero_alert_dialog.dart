// lib/src/shared/presentation/widgets/aero/aero_alert_dialog.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Diálogo de alerta crítico para confirmaciones y errores.
/// ✅ Usa colores y estilos del sistema Aero para consistencia visual.
/// ✅ Soporta modo oscuro/claro automáticamente vía Theme.of(context).
/// ✅ Accesible: etiquetas semánticas y navegación por teclado.
///
/// ## Cuándo usarlo:
/// - Confirmar acciones destructivas (eliminar, cancelar)
/// - Mostrar errores críticos que requieren atención inmediata
/// - Alertas de seguridad o validación de negocio
///
/// ## Cuándo NO usarlo:
/// - Formularios complejos → usa [AeroDialog] o [AeroSheet]
/// - Información no crítica → usa [AeroToast] o [AeroAlertBanner]
/// - Menús de opciones → usa [AeroContextMenu]
///
/// ## Ejemplo básico:
/// ```dart
/// AeroAlertDialog(
///   title: 'Eliminar Competidor',
///   content: '¿Estás seguro? Esta acción no se puede deshacer.',
///   actions: [
///     AeroButton(label: 'Cancelar', onPressed: () => Navigator.pop(context)),
///     AeroButton(label: 'Eliminar', onPressed: _handleDelete, variant: AeroButtonVariant.destructive),
///   ],
/// )
/// ```
class AeroAlertDialog extends StatelessWidget {
  const AeroAlertDialog({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
    this.icon,
    this.iconColor,
    this.onDismissed,
    this.barrierDismissible = true,
  });

  /// Título principal del diálogo (obligatorio para claridad)
  final String title;

  /// Contenido descriptivo del mensaje
  final String content;

  /// Lista de botones de acción (mínimo 1, recomendado 2)
  final List<Widget> actions;

  /// Icono opcional a la izquierda del título para refuerzo visual
  final IconData? icon;

  /// Color del icono (por defecto: fucsia para alerts, rojo para destructivo)
  final Color? iconColor;

  /// Callback opcional cuando el diálogo se cierra sin acción
  final VoidCallback? onDismissed;

  /// Si true, el diálogo se puede cerrar tocando fuera o con retroceso.
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      semanticLabel: 'Alerta: $title',
      backgroundColor: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),

      // ✅ Contenido estructurado: icono + título + mensaje
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? AppColors.fuchsia, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),

      content: Text(
        content,
        style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.4,
        ),
      ),

      // ✅ Acciones alineadas a la derecha con espaciado consistente
      actions: actions.map((action) {
        // Si el botón ya tiene padding, no agregar extra
        if (action is Padding) return action;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: action,
        );
      }).toList(),

      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actionsAlignment: MainAxisAlignment.end,
      buttonPadding: EdgeInsets.zero,
    );
  }

  /// ✅ Helper para mostrar el diálogo con animación estándar
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onDismissed,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => AeroAlertDialog(
        title: title,
        content: content,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        onDismissed: onDismissed,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// ✅ Factory preconfigurado para alertas de confirmación destructiva
  /// ⚠️ IMPORTANTE: Este método solo crea el widget. El caller debe manejar Navigator.pop()
  AeroAlertDialog destructive({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return AeroAlertDialog(
      title: title,
      content: content,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.red,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.destructiveLight,
            foregroundColor: Colors.white,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }

  /// ✅ Factory preconfigurado para alertas de éxito/información
  /// ⚠️ IMPORTANTE: Este método solo crea el widget. El caller debe manejar Navigator.pop()
  AeroAlertDialog success({
    required String title,
    required String content,
    String? confirmLabel,
    VoidCallback? onConfirm,
  }) {
    return AeroAlertDialog(
      title: title,
      content: content,
      icon: Icons.check_circle_outline,
      iconColor: Colors.green,
      actions: [
        FilledButton(
          onPressed: onConfirm,
          child: Text(confirmLabel ?? 'Aceptar'),
        ),
      ],
    );
  }
}
