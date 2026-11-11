// lib/src/features/events/presentation/widgets/judge_selection_sheet.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_avatar.dart';
import 'package:flutter/material.dart';

typedef JudgeSelectionCallback = void Function(String? selectedJudgeId);

enum JudgeRoleFilter {
  principal('Juez Principal', UserRole.judgeP),
  artistry('Juez de Arte', UserRole.judgeA),
  difficulty('Juez de Dificultad', UserRole.judgeD),
  execution('Juez de Ejecución', UserRole.judgeE);

  final String label;
  final UserRole requiredRole;

  const JudgeRoleFilter(this.label, this.requiredRole);
}

class JudgeSelectionSheet extends StatefulWidget {

  const JudgeSelectionSheet({
    required this.allJudges, required this.roleFilter, required this.excludedJudgeIds, required this.onConfirm, super.key,
    this.initiallySelectedId,
  });
  final List<UserEntity> allJudges;
  final JudgeRoleFilter roleFilter;
  final String? initiallySelectedId;
  final Set<String> excludedJudgeIds;
  final JudgeSelectionCallback onConfirm;

  @override
  State<JudgeSelectionSheet> createState() => _JudgeSelectionSheetState();
}

class _JudgeSelectionSheetState extends State<JudgeSelectionSheet> {
  late String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initiallySelectedId;
  }

  @override
  Widget build(BuildContext context) {
    final availableJudges = widget.allJudges.where((judge) {
      final isCorrectRole = judge.role == widget.roleFilter.requiredRole;
      final isNotExcluded = !widget.excludedJudgeIds.contains(judge.id);
      final isNotSelf = judge.id != widget.initiallySelectedId;
      return isCorrectRole && (isNotExcluded || isNotSelf);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: availableJudges.isEmpty
                  ? _buildEmptyState(context)
                  : _buildJudgeList(context, availableJudges, scrollCtrl),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title and close button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.roleFilter.label,
                      style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${widget.allJudges.where((j) => j.role == widget.roleFilter.requiredRole).length} jueces disponibles',
                      style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurfaceVariant),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.fuchsia.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_off_outlined,
                size: 48,
                color: AppColors.fuchsia,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay jueces disponibles',
              style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Todos los jueces de este rol ya están asignados a otros puestos',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJudgeList(BuildContext context, List<UserEntity> judges, ScrollController scrollCtrl) {
    return ListView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: judges.length,
      itemBuilder: (ctx, i) {
        final judge = judges[i];
        final isSelected = judge.id == _selectedId;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.fuchsia.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? AppColors.fuchsia.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _selectedId = judge.id),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Radio button personalizado
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.fuchsia 
                              : Theme.of(context).colorScheme.outline,
                          width: 2,
                        ),
                        color: isSelected 
                            ? AppColors.fuchsia 
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    // Avatar
                    AeroAvatar(
                      fallbackText: '${judge.firstName[0]}${judge.lastName[0]}',
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    // Info del juez
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${judge.firstName} ${judge.lastName}',
                            style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected 
                                  ? AppColors.fuchsia 
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            judge.email,
                            style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Icono de check si está seleccionado
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.fuchsia,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final hasSelection = _selectedId != null;
    
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón para deseleccionar (solo si hay uno seleccionado)
          if (hasSelection && widget.initiallySelectedId != null)
            TextButton.icon(
              onPressed: () => setState(() => _selectedId = null),
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Deseleccionar juez actual'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          if (hasSelection && widget.initiallySelectedId != null)
            const SizedBox(height: 8),
          // Botón principal de confirmar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                widget.onConfirm(_selectedId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fuchsia,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                hasSelection 
                    ? 'Confirmar selección' 
                    : 'Continuar sin seleccionar',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}