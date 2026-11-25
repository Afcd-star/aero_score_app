// lib/src/shared/presentation/widgets/aero/aero_sheet.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Hoja modal estandarizada con encabezado de marca.
///
/// Sustituye los encabezados duplicados de las hojas de formulario y de
/// selección. Provee título, botón de cierre y una fila opcional de
/// acciones, dejando el contenido flexible.
///
/// El fondo es blanco en claro y cardDark en oscuro. La deudas de
/// descableado de esta pieza, el blanco literal y el boton de cierre
/// crudo, se adoptan en el subfrente de descableado junto con sus
/// consumidores.
class AeroSheet extends StatelessWidget {
  /// Crea la hoja con título y contenido.
  ///
  /// [onClose] muestra el boton de cierre cuando se pasa. [actions] pinta
  /// la fila inferior cuando no esta vacia.
  const AeroSheet({
    required this.title,
    required this.child,
    super.key,
    this.onClose,
    this.actions,
  });

  /// Titulo del encabezado de la hoja.
  final String title;

  /// Contenido flexible de la hoja, normalmente un formulario.
  final Widget child;

  /// Devolucion del boton de cierre. Sin ella no se pinta el boton.
  final VoidCallback? onClose;

  /// Fila opcional de acciones al pie de la hoja.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Flexible(child: child),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(children: actions!),
          ],
        ],
      ),
    );
  }
}
