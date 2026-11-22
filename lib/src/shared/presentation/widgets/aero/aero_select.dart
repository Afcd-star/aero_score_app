// lib/src/shared/presentation/widgets/aero/aero_select.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/app_dimens.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

/// Opcion de la lista del selector, con valor tipado y etiqueta visible.
class AeroSelectItem<T> {
  /// Crea la opcion con su valor y su etiqueta obligatorios.
  const AeroSelectItem({
    required this.value,
    required this.label,
    this.icon,
  });

  /// Valor que se devuelve al elegir esta opcion.
  final T value;

  /// Texto que se muestra en la lista y en el chip.
  final String label;

  /// Icono opcional a la izquierda de la etiqueta.
  final IconData? icon;
}

/// Selector de una o varias opciones, con etiqueta y error externo.
///
/// En modo simple pinta un desplegable nativo. En modo multiple pinta
/// chips y abre una hoja con casillas que se confirma con un boton, asi
/// que el efecto es diferido hasta confirmar.
///
/// Deuda registrada: el modo simple no expone validador, asi que la
/// marca de obligatorio es solo visual y el error llega de fuera.
class AeroSelect<T> extends StatefulWidget {
  /// Crea el selector simple con sus opciones y su valor actual.
  const AeroSelect({
    required this.items,
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.required = false,
    // Parámetros de múltiple (no usados en modo simple)
    this.multiple = false,
    this.values,
    this.onMultiChanged,
    this.multiValidator,
  }) : assert(
         !multiple || (onChanged == null && onMultiChanged != null),
         'En modo múltiple, use onMultiChanged en lugar de onChanged',
       );

  /// Crea el selector multiple, con valores y aviso de cambio de lista.
  const AeroSelect.multi({
    required List<AeroSelectItem<T>> items,
    required List<T>? values,
    required ValueChanged<List<T>?> onMultiChanged,
    Key? key,
    String? label,
    String? hint,
    String? errorText,
    bool required = false,
    String? Function(List<T>?)? validator,
  }) : this(
         key: key,
         items: items,
         value: null,
         onChanged: null,
         multiple: true,
         values: values,
         onMultiChanged: onMultiChanged,
         label: label,
         hint: hint,
         errorText: errorText,
         required: required,
         multiValidator: validator,
       );

  /// Opciones disponibles, en el orden en que se pintan.
  final List<AeroSelectItem<T>> items;

  /// Valor elegido en modo simple. Nulo muestra la pista.
  final T? value;

  /// Aviso al elegir en modo simple. Nulo deja el desplegable inerte.
  final ValueChanged<T?>? onChanged;

  /// Si es verdadero, usa el modo multiple de chips y hoja.
  final bool multiple;

  /// Valores elegidos en modo multiple.
  final List<T>? values;

  /// Aviso al confirmar la seleccion multiple.
  final ValueChanged<List<T>?>? onMultiChanged;

  /// Etiqueta sobre el selector.
  final String? label;

  /// Texto de pista cuando no hay seleccion.
  final String? hint;

  /// Error externo que se muestra bajo el selector.
  final String? errorText;

  /// Si es verdadero, anade la marca de obligatorio a la etiqueta.
  final bool required;

  /// Validador del modo multiple, llamado con los valores actuales.
  final String? Function(List<T>?)? multiValidator;

  @override
  State<AeroSelect<T>> createState() => _AeroSelectState<T>();
}

class _AeroSelectState<T> extends State<AeroSelect<T>> {
  // Estado local para modo múltiple (para preview antes de confirmar)
  late List<T> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List<T>.from(widget.values ?? []);
  }

  @override
  void didUpdateWidget(AeroSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincronizar estado local si cambian los valores externos
    if (widget.values != oldWidget.values) {
      _tempSelected = List<T>.from(widget.values ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.multiple) {
      return _buildMultiSelect(context);
    }
    return _buildSingleSelect(context);
  }

  // ✅ Selección simple: usa DropdownButtonFormField nativo
  Widget _buildSingleSelect(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (widget.required) ...[
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],
        DropdownButtonFormField<T>(
          initialValue:
              widget.value == null ||
                  (widget.value is String && (widget.value! as String).isEmpty)
              ? null
              : widget.value,
          hint: widget.hint != null
              ? Text(
                  widget.hint!,
                  style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                )
              : null,
          decoration: InputDecoration(
            constraints: const BoxConstraints(
              minHeight: AppDimens.controlHeight,
            ),
            filled: true,
            fillColor: isDark
                ? AppColors.inputDark
                : AppColors.inputBackgroundLight,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: _buildBorder(theme),
            enabledBorder: _buildBorder(theme),
            focusedBorder: _buildBorder(theme, focused: true),
            errorBorder: _buildBorder(theme, error: true),
            errorText: widget.errorText,
          ),
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 18,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        item.label,
                        style: AppTextStyles.baseTextTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          dropdownColor: theme.colorScheme.surface,
          style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          icon: Icon(
            Icons.expand_more,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  // ✅ Selección múltiple: chips + modal con checkboxes
  Widget _buildMultiSelect(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasError =
        widget.errorText != null ||
        (widget.multiValidator?.call(widget.values) != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (widget.required) ...[
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],

        // ✅ Contenedor principal con estilo de input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.inputDark
                : AppColors.inputBackgroundLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : (theme.colorScheme.outline.withValues(alpha: 0.5)),
              width: hasError ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => unawaited(_showMultiSelectModal(context)),
            child: Row(
              children: [
                Expanded(
                  child: _tempSelected.isEmpty
                      ? Text(
                          widget.hint ?? 'Seleccionar...',
                          style: AppTextStyles.baseTextTheme.bodyMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _tempSelected.map((selectedValue) {
                            final item = widget.items.firstWhere(
                              (i) => i.value == selectedValue,
                              orElse: () => AeroSelectItem(
                                value: selectedValue,
                                label: 'Desconocido',
                              ),
                            );
                            return _buildChip(
                              item.label,
                              () => _removeItem(selectedValue),
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  Icons.expand_more,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),

        // ✅ Mensaje de error
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText ??
                  widget.multiValidator?.call(widget.values) ??
                  '',
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ✅ Modal para selección múltiple con checkboxes
  Future<void> _showMultiSelectModal(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header del modal
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.fuchsia,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label ?? 'Seleccionar',
                    style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(ctx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Lista de checkboxes
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: widget.items.map((item) {
                  final isSelected = _tempSelected.contains(item.value);
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(item.icon, size: 18, color: AppColors.fuchsia),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          item.label,
                          style: AppTextStyles.baseTextTheme.bodyMedium,
                        ),
                      ],
                    ),
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _tempSelected.add(item.value);
                        } else {
                          _tempSelected.remove(item.value);
                        }
                      });
                    },
                    activeColor: AppColors.fuchsia,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ),

            // Botones de acción
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _tempSelected.clear());
                      },
                      child: const Text(
                        'Limpiar selección',
                        style: TextStyle(color: AppColors.destructiveLight),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onMultiChanged?.call(
                          List<T>.from(_tempSelected),
                        );
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.fuchsia,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper: chip para item seleccionado
  Widget _buildChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fuchsia.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fuchsia.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: AppColors.fuchsia,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.fuchsia),
          ),
        ],
      ),
    );
  }

  void _removeItem(T value) {
    setState(() => _tempSelected.remove(value));
    widget.onMultiChanged?.call(List<T>.from(_tempSelected));
  }

  // ✅ Helper: border reusable
  OutlineInputBorder _buildBorder(
    ThemeData theme, {
    bool focused = false,
    bool error = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: error
            ? theme.colorScheme.error
            : (focused ? AppColors.fuchsia : theme.colorScheme.outline),
        width: focused || error ? 2 : 1,
      ),
    );
  }
}
