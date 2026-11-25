// lib/src/shared/presentation/widgets/aero/aero_module_placeholder.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_background.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/'
    'aero_button.dart';
import 'package:flutter/material.dart';

/// Pantalla de marcador para un módulo aún no construido.
///
/// Sustituye los destinos crudos del enrutador y las vistas temporales de
/// los roles cuya funcionalidad todavía no existe. Es pantalla completa
/// porque todos sus consumidores reales lo son.
///
/// No conoce la autenticación: la acción se recibe por parámetro, así que
/// el catálogo no importa funcionalidades. El casco es oscuro fijo por
/// marca, de modo que los textos usan claro fijo y no color de tema,
/// conforme a la regla de acoplamiento.
class AeroModulePlaceholder extends StatelessWidget {
  /// Crea el marcador con su título, su descripción y su acción opcional.
  ///
  /// La etiqueta y la devolución de la acción deben venir juntas: una
  /// acción sin devolución pintaría un botón que no hace nada.
  const AeroModulePlaceholder({
    required this.title,
    required this.description,
    super.key,
    this.icon = Icons.construction_rounded,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'La etiqueta y la devolucion de la accion van juntas',
       );

  /// Título del módulo, tomado del catálogo de identidad cuando aplica.
  final String title;

  /// Explicación honesta de lo que el módulo todavía no permite hacer.
  final String description;

  /// Icono que representa al módulo.
  final IconData icon;

  /// Etiqueta de la acción opcional, por ejemplo cerrar sesión.
  final String? actionLabel;

  /// Icono de la acción opcional, decidido por quien consume la pieza.
  final IconData? actionIcon;

  /// Devolución de la acción opcional.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      body: AeroBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 64, color: AppColors.fuchsia),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 24),
                    AeroButton(
                      label: actionLabel,
                      onPressed: onAction,
                      icon: actionIcon == null
                          ? null
                          : Icon(actionIcon, size: 18),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
