// lib/src/shared/presentation/widgets/aero/aero_filter_bar.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Barra de filtros de seleccion unica con desplazamiento horizontal.
///
/// Es controlada: el indice activo lo decide el consumidor, no el propio
/// widget. Asi el filtro vive en el notificador y no se desincroniza
/// cuando el estado cambia desde fuera, que era el defecto del grupo de
/// toggles heredado de la estructura anterior.
class AeroFilterBar extends StatelessWidget {
  /// Crea la barra con sus opciones y el indice activo.
  const AeroFilterBar({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
    this.label,
  });

  /// Etiquetas de las opciones, en su orden de aparicion.
  final List<String> options;

  /// Indice de la opcion activa.
  final int selectedIndex;

  /// Aviso al consumidor cuando se elige otra opcion.
  final ValueChanged<int> onChanged;

  /// Titulo opcional sobre la barra, por ejemplo Estado.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: text.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.generate(options.length, (i) {
              final active = i == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(options[i]),
                  selected: active,
                  onSelected: (_) => onChanged(i),
                  showCheckmark: false,
                  backgroundColor: scheme.surfaceContainerHighest,
                  selectedColor: AppColors.fuchsia.withValues(alpha: 0.15),
                  side: BorderSide(
                    color: active ? AppColors.fuchsia : scheme.outlineVariant,
                  ),
                  labelStyle: text.labelMedium?.copyWith(
                    color: active ? AppColors.fuchsia : scheme.onSurfaceVariant,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
