// lib/src/features/events/presentation/widgets/event_date_picker.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ✅ Función helper para mostrar DatePicker con tema AeroScore
/// Retorna DateTime? (null si el usuario cancela)
Future<DateTime?> showAeroDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2020),
    lastDate: lastDate ?? DateTime(2030),
    locale: const Locale('es', 'ES'), // ✅ Español según Idioma de la App.md
    helpText: helpText ?? 'Seleccionar fecha',
    
    // ✅ Tema personalizado con colores AeroScore
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primary: AppColors.fuchsia,
            onPrimary: Colors.white,
            secondary: AppColors.coral,
            onSecondary: Colors.white,
            surface: isDark ? AppColors.cardDark : Colors.white,
            onSurface: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
            error: AppColors.destructiveLight,
            onError: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.fuchsia,
            ),
          ), dialogTheme: DialogThemeData(backgroundColor: isDark ? AppColors.cardDark : Colors.white),
        ),
        child: child!,
      );
    },
  );
}

/// ✅ Widget de input de fecha con estilo AeroScore
/// Usar dentro de AeroFormField como `field:`
class AeroEventDatePicker extends StatelessWidget {

  const AeroEventDatePicker({
    super.key,
    this.value,
    this.hintText,
    this.labelText,
    this.required = false,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  });
  final DateTime? value;
  final String? hintText;
  final String? labelText;
  final bool required;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = value != null
        ? (isDark ? AppColors.foregroundDark : AppColors.foregroundLight)
        : AppColors.mutedForegroundDark;

    return InkWell(
      onTap: () async {
        final selected = await showAeroDatePicker(
          context: context,
          initialDate: value,
          firstDate: firstDate,
          lastDate: lastDate,
          helpText: labelText ?? 'Fecha del evento',
        );
        if (selected != null) {
          onChanged?.call(selected);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
          color: isDark ? AppColors.inputDark : AppColors.inputBackgroundLight,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.fuchsia,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labelText != null) ...[
                    Text(
                      labelText!,
                      style: AppTextStyles.baseTextTheme.labelSmall?.copyWith(
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    value != null
                        ? DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(value!)
                        : (hintText ?? 'Seleccionar fecha'),
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: borderColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Widget para rango de fechas (inicio y fin)
class AeroEventDateRangePicker extends StatelessWidget {

  const AeroEventDateRangePicker({
    super.key,
    this.value,
    this.startLabel,
    this.endLabel,
    this.onChanged,
  });
  final DateTimeRange? value;
  final String? startLabel;
  final String? endLabel;
  final ValueChanged<DateTimeRange?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AeroEventDatePicker(
            value: value?.start,
            labelText: startLabel ?? 'Desde',
            hintText: 'Fecha inicio',
            onChanged: (start) {
              if (start != null) {
                final end = value?.end ?? start.add(const Duration(days: 7));
                onChanged?.call(DateTimeRange(start: start, end: end));
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AeroEventDatePicker(
            value: value?.end,
            labelText: endLabel ?? 'Hasta',
            hintText: 'Fecha fin',
            firstDate: value?.start,
            onChanged: (end) {
              if (end != null) {
                final start = value?.start ?? end.subtract(const Duration(days: 7));
                onChanged?.call(DateTimeRange(start: start, end: end));
              }
            },
          ),
        ),
      ],
    );
  }
}