// lib/src/features/teams/presentation/widgets/team_form.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/presentation/providers/coach_provider.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_selector_provider.dart';
import 'package:aero_score_app/src/features/teams/data/di/teams_providers.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/coach_selector_modal.dart';
import 'package:aero_score_app/src/features/teams/presentation/widgets/competitor_selector_modal.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_avatar.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_input.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Formulario de creación y edición de un equipo.
///
/// Construye la entidad desde los controles y delega el guardado en el
/// notificador de formulario. La validación de negocio vive en la
/// entidad de dominio, no aquí. La recogida de planilla se retiró
/// porque el esquema vivo no tiene campo que la persista, fase
/// obligatoria registrada.
class AeroTeamForm extends ConsumerStatefulWidget {
  /// Crea el formulario con el equipo opcional y las funciones de
  /// éxito y cancelación.
  const AeroTeamForm({
    super.key,
    this.initialTeam,
    this.onSuccess,
    this.onCancel,
  });
  /// Equipo en edición, nulo cuando el formulario crea uno nuevo.
  final TeamEntity? initialTeam;
  /// Función que se invoca al completarse un guardado exitoso.
  final VoidCallback? onSuccess;
  /// Función que se invoca al cancelar la edición.
  final VoidCallback? onCancel;

  @override
  ConsumerState<AeroTeamForm> createState() => _AeroTeamFormState();
}

class _AeroTeamFormState extends ConsumerState<AeroTeamForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _universityCtrl;
  late final TextEditingController _facultyCtrl;
  late final TextEditingController _emailCtrl;

  String? _selectedCoachId;
  final List<String> _selectedCompetitorIds = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromDraft());
  }

  void _initControllers() {
    final draft = ref.read(teamFormProvider).draft;
    _nameCtrl = TextEditingController(text: draft?.name ?? '');
    _universityCtrl = TextEditingController(text: draft?.university ?? '');
    _facultyCtrl = TextEditingController(text: draft?.faculty ?? '');
    _emailCtrl = TextEditingController(text: draft?.email ?? '');
    _selectedCoachId = draft?.coachId;
  }

  void _syncFromDraft() {
    final draft = ref.read(teamFormProvider).draft;
    if (draft == null) return;

    if (draft.competitorIds.isNotEmpty) {
      setState(() {
        _selectedCompetitorIds
          ..clear()
          ..addAll(draft.competitorIds);
      });
    }
    setState(() => _selectedCoachId = draft.coachId);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _universityCtrl.dispose();
    _facultyCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showCompetitorsModal() {
    ref.invalidate(competitorSelectionProvider);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CompetitorSelectorModal(
          initialSelectedIds: _selectedCompetitorIds,
          onConfirm: (selectedIds) {
            setState(() {
              _selectedCompetitorIds
                ..clear()
                ..addAll(selectedIds);
            });
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showCoachModal() {
    ref.invalidate(coachesProvider);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CoachSelectorModal(
          initialCoachId: _selectedCoachId,
          onConfirm: (coachId) {
            setState(() => _selectedCoachId = coachId);
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.destructiveLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(teamFormProvider);
    final coaches = ref.read(coachesProvider).value ?? [];
    final selectedCoach = coaches.firstWhere(
      (c) => c.id == _selectedCoachId,
      orElse: () => const CoachInfo(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        username: '',
      ),
    );

    try {
      if (state.isEditing) {
        final existing = state.draft;
        if (existing == null) {
          _showError('No hay equipo en edición');
          return;
        }
        final updatedTeam = existing.copyWith(
          name: _nameCtrl.text.trim(),
          university: _universityCtrl.text.trim(),
          faculty: _facultyCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          coachId: _selectedCoachId,
          coachName: selectedCoach.displayName,
          competitorIds: _selectedCompetitorIds,
        );
        await ref.read(teamFormProvider.notifier).updateTeam(updatedTeam);
      } else {
        await ref
            .read(teamFormProvider.notifier)
            .createTeam(
              name: _nameCtrl.text.trim(),
              university: _universityCtrl.text.trim(),
              faculty: _facultyCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              coachId: _selectedCoachId,
              coachName: selectedCoach.displayName,
              competitorIds: _selectedCompetitorIds,
            );
      }

      if (!mounted) return;
      _showSuccess(
        state.isEditing
            ? 'Equipo actualizado correctamente'
            : 'Equipo creado correctamente',
      );
      widget.onSuccess?.call();
    } on Exception catch (e) {
      if (!mounted) return;
      _showError('Error al guardar: $e');
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _universityCtrl.clear();
    _facultyCtrl.clear();
    _emailCtrl.clear();
    setState(() {
      _selectedCoachId = null;
      _selectedCompetitorIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(teamFormProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final coachesAsync = ref.watch(coachesProvider);
    final competitorsAsync = ref.watch(competitorSelectionProvider);

    ref.listen<TeamFormState>(teamFormProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) {
        if (!mounted) return;
        if (next.error != null) {
          _showError(next.error!);
        } else if (next.draft != null && next.isSuccess) {
          ref.read(teamFormProvider.notifier).clearSuccess();
          widget.onSuccess?.call();
        }
      }
    });

    return AeroForm(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.isEditing ? 'Editar Equipo' : 'Adicionar Equipo',
            style: AppTextStyles.baseTextTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.isEditing
                ? 'Actualice los datos del equipo'
                : 'Complete los datos del nuevo equipo',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.mutedForegroundDark
                  : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          AeroFormField(
            label: 'Nombre del equipo',
            required: true,
            field: AeroInput(
              controller: _nameCtrl,
              hintText: 'Ej: Estrellas Rítmicas',
              validator: (v) {
                if (v?.trim().isEmpty ?? true) return 'Campo obligatorio';
                if (v!.trim().length < 3) return 'Mínimo 3 caracteres';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          AeroFormField(
            label: 'Universidad',
            required: true,
            field: AeroInput(
              controller: _universityCtrl,
              hintText: 'Nombre de la universidad',
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Campo obligatorio' : null,
            ),
          ),
          const SizedBox(height: 16),
          AeroFormField(
            label: 'Facultad',
            required: true,
            field: AeroInput(
              controller: _facultyCtrl,
              hintText: 'Nombre de la facultad',
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Campo obligatorio' : null,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Entrenador ',
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          coachesAsync.when(
            loading: () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: AeroSkeleton(height: 20)),
            ),
            error: (err, _) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.destructiveLight),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.destructiveLight.withValues(alpha: 0.1),
              ),
              child: Text(
                'Error: $err',
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: AppColors.destructiveLight,
                ),
              ),
            ),
            data: (coaches) {
              final selectedCoach = coaches.firstWhere(
                (c) => c.id == _selectedCoachId,
                orElse: () => const CoachInfo(
                  id: '',
                  firstName: '',
                  lastName: '',
                  username: '',
                  email: '',
                ),
              );
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _showCoachModal,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedCoachId != null
                          ? AppColors.fuchsia.withValues(alpha: 0.5)
                          : (isDark
                                ? AppColors.borderDark
                                : Colors.grey.shade300),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: _selectedCoachId != null
                            ? AppColors.fuchsia
                            : AppColors.mutedForegroundDark,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedCoach.displayName.isNotEmpty
                              ? selectedCoach.displayName
                              : 'Seleccionar entrenador',
                          style: AppTextStyles.baseTextTheme.bodyLarge
                              ?.copyWith(
                                color: selectedCoach.displayName.isNotEmpty
                                    ? (isDark
                                          ? AppColors.foregroundDark
                                          : AppColors.textOnWhite)
                                    : AppColors.mutedForegroundDark,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDark
                            ? AppColors.borderDark
                            : Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          AeroFormField(
            label: 'Email de contacto',
            required: true,
            field: AeroInput(
              controller: _emailCtrl,
              hintText: 'correo@ejemplo.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v?.trim().isEmpty ?? true) return 'Campo obligatorio';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Text(
                'Competidores del equipo',
                style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.foregroundDark
                      : AppColors.textOnWhite,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: AppTextStyles.baseTextTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_selectedCompetitorIds.length} '
            'seleccionado${_selectedCompetitorIds.length == 1 ? '' : 's'}',
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.mutedForegroundDark
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AeroButton(
            label: 'Agregar Competidores',
            onPressed: _showCompetitorsModal,
            fullWidth: true,
            icon: const Icon(Icons.add),
          ),
          if (_selectedCompetitorIds.isNotEmpty) ...[
            const SizedBox(height: 16),
            competitorsAsync.when(
              loading: () => const Center(child: AeroSkeleton(height: 60)),
              error: (_, _) => const SizedBox.shrink(),
              data: (competitors) {
                return Column(
                  children: _selectedCompetitorIds.map((id) {
                    final competitor = competitors.firstWhere(
                      (c) => c.id == id,
                      orElse: () => CompetitorSelectionInfo(
                        id: id,
                        firstName: 'Competidor',
                        lastName: 'Desconocido',
                        nationalId: '',
                        university: '',
                      ),
                    );
                    return _buildCompetitorChip(competitor);
                  }).toList(),
                );
              },
            ),
          ],
          const SizedBox(height: 32),
          if (state.isLoading) ...[
            const LinearProgressIndicator(color: AppColors.fuchsia),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Procesando...',
                style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                  color: AppColors.fuchsia,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          AeroButton(
            label: state.isLoading
                ? (state.isEditing ? 'Actualizando...' : 'Creando...')
                : (state.isEditing ? 'Actualizar Equipo' : 'Registrar Equipo'),
            onPressed: state.isLoading ? null : _handleSubmit,
            isLoading: state.isLoading,
            fullWidth: true,
            gradient: AppColors.getGlowGradient(),
          ),
          const SizedBox(height: 12),
          AeroButton(
            label: 'Limpiar',
            onPressed: state.isLoading ? null : _clearForm,
            variant: AeroButtonVariant.outline,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitorChip(CompetitorSelectionInfo competitor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fuchsia.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fuchsia.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          AeroAvatar(fallbackText: competitor.initials),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  competitor.fullName,
                  style: AppTextStyles.baseTextTheme.bodyLarge,
                ),
                Text(
                  'CI: ${competitor.nationalId}',
                  style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForegroundDark,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent),
            onPressed: () =>
                setState(() => _selectedCompetitorIds.remove(competitor.id)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
