// lib/src/shared/presentation/widgets/aero/aero_form_scaffold.dart
import 'package:aero_score_app/src/core/theme/app_dimens.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';

/// Andamiaje de formulario de pantalla completa.
///
/// Fija el retorno arriba y deja el cuerpo crecer y desplazarse por
/// dentro, de modo que quien llega al final del formulario nunca pierde
/// la salida. La superficie y la sombra salen del tema, no de constantes
/// cableadas, conforme a la regla de la casa de que lo nuevo no arrastra
/// deudas viejas.
///
/// El viewport va recortado con radio solo en las esquinas superiores.
/// Sin ese recorte, el cuerpo se desplaza por debajo del encabezado
/// anclado y rellena los triángulos transparentes del radio, que es lo
/// que hacía perder el redondeo al scrollear. El radio inferior vive en
/// el cuerpo y queda fuera de pantalla hasta llegar al final, que es lo
/// que da la sensación de que el formulario continúa más abajo.
class AeroFormScaffold extends StatelessWidget {
  /// Crea el andamiaje con su cuerpo y su devolución de retorno.
  const AeroFormScaffold({
    required this.body,
    super.key,
    this.onBack,
    this.backLabel = 'Volver a la lista',
    this.headerPadding = const EdgeInsets.fromLTRB(24, 16, 24, 8),
    this.contentPadding = const EdgeInsets.fromLTRB(24, 0, 24, 16),
    this.cornerRadius = 16,
    this.bottomGap = 16,
  });

  /// Contenido del formulario, que crece y se desplaza.
  final Widget body;

  /// Devolución del retorno. Nula deja el encabezado sin botón.
  final VoidCallback? onBack;

  /// Etiqueta del botón de retorno.
  final String backLabel;

  /// Relleno del encabezado fijado.
  final EdgeInsetsGeometry headerPadding;

  /// Relleno del cuerpo desplazable.
  final EdgeInsetsGeometry contentPadding;

  /// Radio de las esquinas exteriores de la superficie.
  final double cornerRadius;

  /// Hueco de fondo tras el cuerpo, visible solo al llegar al final.
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final esquinasSuperiores = BorderRadius.vertical(
      top: Radius.circular(cornerRadius),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: esquinasSuperiores,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: esquinasSuperiores,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _BackHeaderDelegate(
                surface: scheme.surface,
                extent: AppDimens.controlHeight + headerPadding.vertical,
                padding: headerPadding,
                label: backLabel,
                onBack: onBack,
              ),
            ),
            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(cornerRadius),
                  ),
                ),
                child: Padding(padding: contentPadding, child: body),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: bottomGap),
            ),
          ],
        ),
      ),
    );
  }
}

/// Delegado del encabezado fijado que lleva el retorno.
class _BackHeaderDelegate extends SliverPersistentHeaderDelegate {
  _BackHeaderDelegate({
    required this.surface,
    required this.extent,
    required this.padding,
    required this.label,
    required this.onBack,
  });

  final Color surface;
  final double extent;
  final EdgeInsetsGeometry padding;
  final String label;
  final VoidCallback? onBack;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: surface,
      child: Padding(
        padding: padding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: onBack == null
              ? const SizedBox.shrink()
              : AeroButton(
                  label: label,
                  onPressed: onBack,
                  variant: AeroButtonVariant.brandSoft,
                  size: AeroButtonSize.sm,
                  icon: const Icon(Icons.arrow_back),
                ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_BackHeaderDelegate oldDelegate) {
    return surface != oldDelegate.surface ||
        extent != oldDelegate.extent ||
        padding != oldDelegate.padding ||
        label != oldDelegate.label ||
        onBack != oldDelegate.onBack;
  }
}
