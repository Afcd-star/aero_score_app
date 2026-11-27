// lib/src/shared/presentation/widgets/aero/aero_scroll_to_top.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_dimens.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';

/// Control de retorno al principio de una lista desplazable.
///
/// Recibe el controlador que posee el consumidor y no lo crea ni lo
/// libera, porque quien crea el desplazamiento es dueño de su ciclo de
/// vida. Aparece pasado el umbral y se oculta al volver arriba.
///
/// Se monta como hijo de una pila sobre la lista y se alinea abajo a la
/// derecha, dos píxeles por encima del relleno inferior de la tarjeta.
/// El consumidor no necesita colchón adicional en el contenido: el
/// control queda dentro de la tarjeta, y el riesgo de rozar el menú de
/// la última tarjeta al llegar al final se vigila en el pase visual.
///
/// El alto y el ancho se fuerzan desde la dimensión de control del
/// catálogo porque el modo de solo icono del botón fija su mínimo en
/// cuarenta y cuatro escrito a mano, por debajo del mínimo accesible de
/// la casa. Esa deuda del botón se registra y se resuelve en su frente.
class AeroScrollToTop extends StatefulWidget {
  /// Crea el control con el controlador del desplazamiento del consumidor.
  const AeroScrollToTop({
    required this.controller,
    super.key,
    this.threshold = 320,
    this.semanticLabel = 'Volver al principio de la lista',
    this.margin = const EdgeInsets.only(right: 10, bottom: 18),
    this.fadeDuration = const Duration(milliseconds: 200),
    this.travelDuration = const Duration(milliseconds: 320),
  });

  /// Controlador del desplazamiento, propiedad del consumidor.
  final ScrollController controller;

  /// Desplazamiento a partir del cual aparece el control.
  final double threshold;

  /// Etiqueta de accesibilidad del control.
  final String semanticLabel;

  /// Margen exterior respecto al borde de la pila.
  ///
  /// El criterio de la casa es que la tarjeta contenga el control por
  /// abajo, dentro del rango vertical que la tarjeta alcanza, y que por
  /// la derecha tenga libertad. El control facilita la navegación y no
  /// compite con el contenido de la lista, así que puede asomar fuera del
  /// borde lateral de la tarjeta sin que eso sea un defecto.
  final EdgeInsetsGeometry margin;

  /// Duración del desvanecimiento al aparecer y ocultarse.
  final Duration fadeDuration;

  /// Duración del viaje de vuelta al principio.
  final Duration travelDuration;

  @override
  State<AeroScrollToTop> createState() => _AeroScrollToTopState();
}

class _AeroScrollToTopState extends State<AeroScrollToTop> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didUpdateWidget(AeroScrollToTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
      _onScroll();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.controller.hasClients) {
      return;
    }
    final show = widget.controller.offset > widget.threshold;
    if (show != _visible) {
      setState(() => _visible = show);
    }
  }

  void _toTop() {
    if (!widget.controller.hasClients) {
      return;
    }
    unawaited(
      widget.controller.animateTo(
        0,
        duration: widget.travelDuration,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: widget.margin,
        child: IgnorePointer(
          ignoring: !_visible,
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: widget.fadeDuration,
            child: Semantics(
              label: widget.semanticLabel,
              button: true,
              child: AeroButton(
                icon: const Icon(Icons.arrow_upward),
                iconOnly: true,
                variant: AeroButtonVariant.brandSoft,
                width: AppDimens.controlHeight,
                height: AppDimens.controlHeight,
                borderRadius: AppDimens.controlHeight / 2,
                onPressed: _toTop,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
