// lib/src/shared/presentation/widgets/aero/aero_sheet.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Hoja modal estandarizada con encabezado de marca.
///
/// Sustituye los encabezados duplicados de las hojas de formulario y de
/// selección. Provee título, subtítulo opcional, botón de cierre y una
/// fila opcional de acciones, dejando el contenido flexible.
///
/// El modo plano pinta el encabezado sobre la superficie del tema. El
/// modo con degradado, `headerGradient`, reproduce el encabezado lleno
/// de las hojas de selección de competidores y entrenador, con título y
/// cierre en blanco sobre el degradado de la casa, que es el patrón que
/// esta pieza prometía absorber y que su versión inicial no implementaba.
///
/// El contenedor raíz NO se auto rellena: cada sección, encabezado,
/// cuerpo y pie, lleva su propio relleno, que es como están escritas las
/// seis hojas vivas. El radio superior es 24, el valor de todas ellas.
/// El cuerpo va ceñido con Expanded, no suelto, porque las listas de
/// selección necesitan ocupar el espacio restante para desplazarse.
///
/// El fondo del contenedor raíz sale de `colorScheme.surface`, conforme
/// a la norma de la casa de que las superficies no se cablean con
/// ternarios de brillo. La pieza ya no arrastra esa deuda: se purgó en el
/// gesto que le dio su primer consumidor vivo, y con eso coincide con la
/// superficie de los formularios en ambos modos.
///
/// Primitivas que NO son deuda descableable y se conservan a propósito.
/// El blanco del título, el subtítulo y el cierre en modo degradado es
/// texto sobre una superficie fija de marca, no sobre el esquema
/// ambiental, así que descablearlo lo volvería ilegible sobre el
/// degradado. El botón de cierre en modo plano usa `IconButton` de
/// Material porque el catálogo no provee pieza de cierre; es primitiva
/// sin equivalente, no un color cableado.
class AeroSheet extends StatelessWidget {
  /// Crea la hoja con título y contenido.
  ///
  /// [onClose] muestra el botón de cierre cuando se pasa. [actions] pinta
  /// la fila inferior cuando no está vacía. [subtitle] pinta una línea
  /// bajo el título cuando no es nula. [headerGradient] llena el
  /// encabezado con el degradado de la casa. [maxHeight] limita el alto
  /// de la hoja cuando se pasa, que es lo que usan las hojas fijas para
  /// no crecer hasta la pantalla entera.
  const AeroSheet({
    required this.title,
    required this.child,
    super.key,
    this.onClose,
    this.actions,
    this.subtitle,
    this.headerGradient = false,
    this.maxHeight,
  });

  /// Título del encabezado de la hoja.
  final String title;

  /// Subtítulo opcional bajo el título.
  ///
  /// En modo con degradado se pinta en blanco al noventa por ciento, como
  /// las hojas de selección. En modo plano se pinta en el texto variante
  /// de la superficie del tema.
  final String? subtitle;

  /// Contenido flexible de la hoja, normalmente una lista o un formulario.
  ///
  /// El cuerpo se auto rellena, porque la pieza no añade relleno de raíz.
  final Widget child;

  /// Devolución del botón de cierre. Sin ella no se pinta el botón.
  final VoidCallback? onClose;

  /// Fila opcional de acciones al pie de la hoja.
  final List<Widget>? actions;

  /// Si es verdadero, el encabezado se llena con el degradado de la casa
  /// y título, subtítulo y cierre pasan a blanco.
  final bool headerGradient;

  /// Alto máximo de la hoja, o nulo para que crezca según el contenido.
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inset = MediaQuery.of(context).viewInsets.bottom;
    final constraints = maxHeight == null
        ? null
        : BoxConstraints(maxHeight: maxHeight!);

    final headerText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
            color: headerGradient ? Colors.white : null,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: headerGradient
                  ? Colors.white.withValues(alpha: 0.9)
                  : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );

    final closeWidget = onClose == null
        ? const SizedBox.shrink()
        : headerGradient
        ? Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose,
          );

    final headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: headerText),
        closeWidget,
      ],
    );

    final body = Expanded(child: child);

    final footer = (actions == null || actions!.isEmpty)
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + inset),
                child: Row(children: actions!),
              ),
            ],
          );

    final headerBlock = headerGradient
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.getGlowGradient(),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: headerRow,
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: headerRow,
          );

    return Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerBlock,
          if (!headerGradient) const SizedBox(height: 24),
          body,
          ?footer,
        ],
      ),
    );
  }
}
