// lib/src/features/teams/presentation/widgets/team_competitors_sheet.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_selector_provider.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hoja modal que muestra el roster de competidores de un equipo.
///
/// Lee el roster desde el proveedor de selección de competidores y
/// filtra por los identificadores del equipo recibido. Su contenido
/// visual usa widgets crudos de Material, deuda de catálogo registrada
/// para el frente de shared.
class TeamCompetitorsSheet extends ConsumerWidget {
  /// Crea la hoja para el equipo indicado.
  const TeamCompetitorsSheet({
    required this.team,
    super.key,
  });

  /// Equipo cuyo roster se muestra en la hoja.
  final TeamEntity team;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final competitorsAsync = ref.watch(competitorSelectionProvider);
    final competitorIds = team.competitorIds;

    return AeroSheet(
      title: 'Competidores del Equipo',
      subtitle: team.name,
      headerGradient: true,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      onClose: () => Navigator.pop(context),
      child: competitorsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando competidores...'),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.destructiveLight,
                ),
                const SizedBox(height: 12),
                Text(
                  'Error al cargar',
                  style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                    color: AppColors.destructiveLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: AppTextStyles.baseTextTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (allCompetitors) {
          final teamCompetitors = allCompetitors
              .where((c) => competitorIds.contains(c.id))
              .toList();

          if (teamCompetitors.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Este equipo no tiene competidores'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: teamCompetitors.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final competitor = teamCompetitors[index];
              return _buildCompetitorTile(competitor, isDark);
            },
          );
        },
      ),
    );
  }

  Widget _buildCompetitorTile(CompetitorSelectionInfo competitor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.getGlowGradient(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                competitor.initials.isNotEmpty ? competitor.initials : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competitor.fullName,
                  style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'CI: ${competitor.nationalId}',
                  style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.mutedForegroundDark
                        : AppColors.mutedForegroundLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
