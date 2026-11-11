// lib/src/features/admin/presentation/widgets/event_list_view.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_filter_provider.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/event_status_badge.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_badge.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final isDateFilterExpandedProvider = Provider<bool>((ref) {
  return ref.watch(_isDateFilterExpandedStateProvider);
});

final _isDateFilterExpandedStateProvider = NotifierProvider<DateFilterNotifier, bool>(() {
  return DateFilterNotifier();
});

class DateFilterNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggleExpanded() {
    state = !state;
  }

  void expand() {
    state = true;
  }
}

class EventListView extends ConsumerWidget {

  const EventListView({
    required this.onAddEvent, super.key,
    this.onEdit,
    this.onDelete,
  });
  final VoidCallback onAddEvent;
  final Function(EventEntity)? onEdit;
  final Function(String)? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Header
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.fuchsia, AppColors.coral],
                ),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: const Icon(Icons.event, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eventos',
                    style: AppTextStyles.baseTextTheme.titleLarge,
                  ),
                  filteredAsync.when(
                    data: (list) => Text(
                      'Gestión y seguimiento de eventos (${list.length} registrado${list.length == 1 ? '' : 's'})',
                      style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        _buildStatusFilterBar(ref, context),
        const SizedBox(height: 6),

        _buildDateFilterBar(ref, context),
        const SizedBox(height: 2),

        // ✅ Botón Crear
        AeroButton(
          label: 'Crear Nuevo Evento',
          onPressed: () {
            debugPrint(' [UI] Botón "Crear Nuevo Evento" presionado');
            onAddEvent();
          },
          icon: const Icon(Icons.add, size: 20),
          gradient: AppColors.getGlowGradient(),
          fullWidth: true,
        ),
        const SizedBox(height: 24),

        // ✅ Lista
        filteredAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.fuchsia),
          ),
          error: (error, stack) => _buildErrorState(context, error.toString()),
          data: (events) => events.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _buildEventCard(
                    context,
                    events[index],
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatusFilterBar(WidgetRef ref, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filter = ref.watch(eventFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Estado', style: AppTextStyles.baseTextTheme.labelMedium),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(ref, 'Todos', 'all', isDark, filter.status),
              const SizedBox(width: 8),
              _buildFilterChip(
                ref,
                'Próximos',
                'Planificado',
                isDark,
                filter.status,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                ref,
                'En curso',
                'En curso',
                isDark,
                filter.status,
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                ref,
                'Finalizados',
                'Finalizado',
                isDark,
                filter.status,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    WidgetRef ref,
    String label,
    String value,
    bool isDark,
    String currentStatus,
  ) {
    final isActive = currentStatus == value;

    return GestureDetector(
      onTap: () => ref.read(eventFilterProvider.notifier).updateStatus(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.fuchsia, Color(0xFF8B00FF)],
                )
              : null,
          color: isActive
              ? null
              : (isDark ? AppColors.cardDark : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                ),
        ),
        child: Text(
          label,
          style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
            fontSize: 13,
            color: isActive
                ? Colors.white
                : (isDark ? AppColors.foregroundDark : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilterBar(WidgetRef ref, BuildContext context) {
    final isExpanded = ref.watch(isDateFilterExpandedProvider);
    final filter = ref.watch(eventFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fecha', style: AppTextStyles.baseTextTheme.labelMedium),
            Row(
              children: [
                if (filter.dateRange != null)
                  TextButton.icon(
                    onPressed: () => ref
                        .read(eventFilterProvider.notifier)
                        .clearDateFilter(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.destructiveLight,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                                IconButton(
                  onPressed: () =>
                      ref.read(
                        _isDateFilterExpandedStateProvider.notifier
                        ).toggleExpanded(),
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: AppColors.fuchsia,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        if (isExpanded) ...[
          const SizedBox(height: 8),
          // Chips rápidos
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateChip(
                  ref,
                  'Hoy',
                  _getTodayRange(),
                  filter.dateRange,
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildDateChip(
                  ref,
                  'Esta semana',
                  _getWeekRange(),
                  filter.dateRange,
                  isDark,
                ),
                const SizedBox(width: 8),
                _buildDateChip(
                  ref,
                  'Este mes',
                  _getMonthRange(),
                  filter.dateRange,
                  isDark,
                ),
                const SizedBox(width: 8),
                // Botón para rango personalizado
                GestureDetector(
                  onTap: () => _showCustomDateRangePicker(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.fuchsia.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.fuchsia,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Personalizado',
                          style: AppTextStyles.baseTextTheme.labelLarge
                              ?.copyWith(
                                fontSize: 12,
                                color: AppColors.fuchsia,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Mostrar rango seleccionado si existe
          if (filter.dateRange != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.fuchsia.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.date_range, size: 14, 
                    color: AppColors.fuchsia
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(filter.dateRange!.start)} - ${_formatDate(filter.dateRange!.end)}',
                    style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                      color: AppColors.fuchsia,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildDateChip(
    WidgetRef ref,
    String label,
    DateTimeRange range,
    DateTimeRange? selectedRange,
    bool isDark,
  ) {
    final isSelected =
        selectedRange != null &&
        selectedRange.start == range.start &&
        selectedRange.end == range.end;

    return GestureDetector(
      onTap: () =>
          ref.read(eventFilterProvider.notifier).updateDateRange(range),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.fuchsia, AppColors.coral],
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.cardDark : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                ),
        ),
        child: Text(
          label,
          style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
            fontSize: 12,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.foregroundDark : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  Future<void> _showCustomDateRangePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final filter = ref.read(eventFilterProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: filter.dateRange,
      locale: const Locale('es', 'ES'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.fuchsia,
            onPrimary: Colors.white,
            surface: Theme.of(ctx).colorScheme.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ref.read(eventFilterProvider.notifier).updateDateRange(picked);
      // Expandir automáticamente si se selecciona rango personalizado
      ref.read(_isDateFilterExpandedStateProvider.notifier).expand();
    }
  }

  // Helpers para rangos predefinidos
  DateTimeRange _getTodayRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange _getWeekRange() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(start.year, start.month, start.day);
    final weekEnd = weekStart
        .add(const Duration(days: 7))
        .subtract(const Duration(seconds: 1));
    return DateTimeRange(start: weekStart, end: weekEnd);
  }

  DateTimeRange _getMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return DateTimeRange(start: start, end: end);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM', 'es_ES').format(date);
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardDark
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_outlined,
            size: 64,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay eventos en esta categoría',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.foregroundDark : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer evento para comenzar',
            style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.mutedForegroundDark
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.destructiveLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.destructiveLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.destructiveLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error al cargar eventos: $error',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: AppColors.destructiveLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    EventEntity event, {
    Function(EventEntity)? onEdit,
    Function(String)? onDelete,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardDark
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.borderDark
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header: Badges de estado + categoría
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        EventStatusBadge(
                          status: event.status, // ✅ Enum directo
                          size: BadgeSize.small,
                        ),
                        const SizedBox(width: 8),
                        AeroBadge(
                          label: event
                              .category
                              .value, // ✅ EventCategory.value → String
                          customBackgroundColor: AppColors.fuchsia.withValues(
                            alpha: 0.2,
                          ),
                          customColor: AppColors.fuchsia,
                          size: BadgeSize.small,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.name,
                      style: AppTextStyles.baseTextTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ Detalles con iconos
          _buildDetailRow(
            context,
            Icons.calendar_today,
            _formatDateFull(event.date),
          ),
          
          if (event.time != null && event.time!.isNotEmpty)
            _buildDetailRow(
              context,
              Icons.access_time,
              _formatTime(event.time!),
            ), // "09:00 AM"

          _buildDetailRow(
            context, 
            Icons.category, 
            event.category.value,
          ),
          
          if (event.location.isNotEmpty)
            _buildDetailRow(
              context, 
              Icons.location_on, 
              event.location
            ),

          if (event.teamIds.isNotEmpty)
            
            _buildDetailRow(
              context,
              Icons.people,
              '${event.teamIds.length} equipos participante${event.teamIds.length == 1 ? '' : 's'}',
            ), 

          //TODO: REVISAR ESTO
          //if (event.teamIds.isNotEmpty) {
          //  debugPrint('Equipos ${event.teamIds.length}');
          //},
          
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // ✅ Acciones
          Row(
            children: [
              // Botón Editar - Gradiente fucsia con label
              Expanded(
                child: AeroButton(
                  label: 'Editar',
                  onPressed: onEdit != null ? () => onEdit(event) : null,
                  icon: const Icon(Icons.edit, size: 18),
                  gradient: AppColors.getGlowGradient(),
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              // Botón Eliminar - Solo ícono, variante destructive
              AeroButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                iconOnly: true, // ✅ Nuevo parámetro
                variant: AeroButtonVariant.destructive,
                width: 44,
                height: 44,
                onPressed: onDelete != null ? () => onDelete(event.id!) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.fuchsia),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.foregroundDark.withValues(alpha: 0.8)
                    : AppColors.foregroundLight.withValues(alpha: 0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateFull(DateTime date) {
    return DateFormat("EEEE, d 'de' MMMM 'de' yyyy", 'es_ES').format(date);
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (_) {
      return time;
    }
  }
}
