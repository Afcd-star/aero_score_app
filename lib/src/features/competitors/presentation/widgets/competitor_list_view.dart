// lib/src/features/competitors/presentation/widgets/competitor_list_view.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vista de lista de competidores.
class CompetitorListView extends ConsumerWidget {
  /// Crea la vista con acciones de edición y eliminación.
  const CompetitorListView({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// Acción solicitada al editar un competidor.
  final void Function(CompetitorEntity) onEdit;

  /// Acción solicitada al eliminar un competidor por identificador.
  final void Function(String) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(competitorListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return state.when(
      loading: _buildSkeleton,
      error: (error, _) => _buildError(error.toString(), isDark),
      data: (competitors) {
        if (competitors.isEmpty) {
          return _buildEmptyState(isDark);
        }
        return _buildList(competitors, context);
      },
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AeroSkeleton(height: 100),
        ),
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    final errorColor = isDark
        ? AppColors.destructiveDark
        : AppColors.destructiveLight;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: errorColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: errorColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: $error',
              style: AppTextStyles.baseTextTheme.bodyMedium
                  ?.copyWith(color: errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: isDark
                ? Colors.grey.shade500
                : Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay competidores registrados',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.foregroundDark
                  : AppColors.foregroundLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    List<CompetitorEntity> competitors,
    BuildContext context,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: competitors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildCompetitorCard(
          competitors[index],
          context,
        );
      },
    );
  }

  // ✅ Tarjeta con colores del Sistema de Diseño
  Widget _buildCompetitorCard(
    CompetitorEntity competitor,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary =
        isDark ? AppColors.foregroundDark : AppColors.foregroundLight;
    final textSecondary = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Encabezado: Avatar e información
          Row(
            children: [
              // ✅ Avatar con gradiente de marca
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.getGlowGradient(),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // ✅ Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      competitor.fullName,
                      style: AppTextStyles.baseTextTheme.titleMedium
                          ?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'CI: ${competitor.nationalId}',
                      style: AppTextStyles.baseTextTheme.bodySmall
                          ?.copyWith(color: textSecondary),
                    ),
                    Text(
                      competitor.categoryLabel,
                      style: AppTextStyles.baseTextTheme.bodySmall
                          ?.copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),

          // ✅ Pie: estado, etiqueta y acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Izquierda: estado con etiqueta
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Estado:',
                    style: AppTextStyles.baseTextTheme.labelSmall
                        ?.copyWith(color: textSecondary),
                  ),
                  const SizedBox(width: 8),
                  // ✅ Etiqueta con color semántico
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBadgeColor(
                        competitor.status,
                        isDark,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(competitor.status),
                      style: AppTextStyles.baseTextTheme.labelSmall
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              // ✅ Derecha: menú con tres puntos
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: textSecondary,
                  size: 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardBg,
                elevation: 8,
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit(competitor);
                    case 'delete':
                      onDelete(competitor.id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: AppColors.fuchsia,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Editar',
                            style: AppTextStyles.baseTextTheme.bodyMedium
                                ?.copyWith(color: textPrimary),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: isDark
                                ? AppColors.destructiveDark
                                : AppColors.destructiveLight,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Eliminar',
                            style: AppTextStyles.baseTextTheme.bodyMedium
                                ?.copyWith(
                              color: isDark
                                  ? AppColors.destructiveDark
                                  : AppColors.destructiveLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Ayudante: color de etiqueta según estado
  Color _getStatusBadgeColor(
    CompetitorStatus status,
    bool isDark,
  ) {
    return switch (status) {
      CompetitorStatus.active =>
        isDark ? AppColors.successDark : AppColors.successLight,
      CompetitorStatus.inactive =>
        isDark ? AppColors.mutedDark : AppColors.mutedLight,
      CompetitorStatus.suspended =>
        isDark ? AppColors.destructiveDark : AppColors.destructiveLight,
    };
  }

  // ✅ Ayudante: texto en español según estado
  String _getStatusLabel(CompetitorStatus status) {
    return switch (status) {
      CompetitorStatus.active => 'Activo',
      CompetitorStatus.inactive => 'Inactivo',
      CompetitorStatus.suspended => 'Suspendido',
    };
  }
}
