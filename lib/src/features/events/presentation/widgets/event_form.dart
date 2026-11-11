// lib/src/features/events/presentation/widgets/event_form.dart
// ✅ EventForm completo: sincronización Riverpod + tipo-seguridad + UX nativa
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_role.dart';
import 'package:aero_score_app/src/features/events/data/di/event_providers.dart';
import 'package:aero_score_app/src/features/events/domain/entities/event_entity.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_data_providers.dart';
import 'package:aero_score_app/src/features/events/presentation/providers/event_form_state.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/judge_selection_sheet.dart';
import 'package:aero_score_app/src/features/events/presentation/widgets/team_selection_sheet.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_avatar.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_input.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_select.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_textarea.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AeroEventForm extends ConsumerStatefulWidget {

  const AeroEventForm({
    super.key,
    this.initialEvent,
    this.onSuccess,
    this.onCancel,
  });
  final EventEntity? initialEvent;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  @override
  ConsumerState<AeroEventForm> createState() => _AeroEventFormState();
}

class _AeroEventFormState extends ConsumerState<AeroEventForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final FocusNode _nombreFocus;

  late final TextEditingController _ubicacionCtrl;
  late final FocusNode _ubicacionFocus;

  late final TextEditingController _descripcionCtrl;
  late final FocusNode _descripcionFocus;

  DateTime? _date;
  String? _time;
  EventCategory? _category;
  final List<TeamEntity> _selectedTeams = [];
  String? _principalJudgeId;
  String? _artistryJudgeId;
  String? _difficultyJudgeId;
  String? _executionJudgeId;
  final List<String> _additionalJudgeIds = [];

  @override
  void initState() {
    super.initState();

    _initControllersAndFocus();
    _setupFocusListeners();

    // ✅ Sincronización completa desde el draft
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncFromDraft();
    });
  }

  void _initControllersAndFocus() {
    final initialDraft = ref.read(eventFormProvider).draft;

    _nombreCtrl = TextEditingController(text: initialDraft?.name ?? '');
    _nombreFocus = FocusNode();

    _ubicacionCtrl = TextEditingController(text: initialDraft?.location ?? '');
    _ubicacionFocus = FocusNode();

    _descripcionCtrl = TextEditingController(text: initialDraft?.description ?? '');
    _descripcionFocus = FocusNode();

    _time = initialDraft?.time;
  }

  // ✅ NUEVO: Sincronización completa desde el draft
  void _syncFromDraft() {
    final draft = ref.read(eventFormProvider).draft;
    if (draft == null) return;

    // Sincronizar campos de texto
    _updateControllersFromDraft(draft);

    // ✅ Sincronizar equipos
    final teamsAsync = ref.read(eventTeamsProvider(null));
    teamsAsync.whenData((allTeams) {
      final selectedTeams = allTeams
          .where((team) => draft.teamIds.contains(team.id))
          .toList();
      setState(() {
        _selectedTeams.clear();
        _selectedTeams.addAll(selectedTeams);
      });
    });

    // ✅ Sincronizar jueces
    setState(() {
      _principalJudgeId = draft.principalJudgeId;
      _artistryJudgeId = draft.artistryJudgeId;
      _difficultyJudgeId = draft.difficultyJudgeId;
      _executionJudgeId = draft.executionJudgeId;
      _additionalJudgeIds.clear();
      _additionalJudgeIds.addAll(draft.additionalJudgeIds);
    });
  }

  void _updateControllersFromDraft(EventEntity? draft) {
    // Actualizar controllers solo si no tienen foco (evitar perder texto mientras el usuario escribe)
    if (!_nombreFocus.hasFocus) {
      _nombreCtrl.text = draft?.name ?? '';
    }
    if (!_ubicacionFocus.hasFocus) {
      _ubicacionCtrl.text = draft?.location ?? '';
    }
    if (!_descripcionFocus.hasFocus) {
      _descripcionCtrl.text = draft?.description ?? '';
    }

    // Actualizar campos no controlados por TextEditingController
    setState(() {
      _date = draft?.date;
      _category = draft?.category;
      _time = draft?.time;
      // ✅ ELIMINADO: TODO - ahora se sincroniza en _syncFromDraft()
    });
  }

  void _setupFocusListeners() {
    void onFocusChange() => setState(() {});

    _nombreFocus.addListener(onFocusChange);
    _ubicacionFocus.addListener(onFocusChange);
    _descripcionFocus.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _ubicacionCtrl.dispose();
    _descripcionCtrl.dispose();
    _nombreFocus.dispose();
    _ubicacionFocus.dispose();
    _descripcionFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.fuchsia),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final currentTime = _time != null 
        ? TimeOfDay(
            hour: int.parse(_time!.split(':')[0]),
            minute: int.parse(_time!.split(':')[1]),
          )
        : TimeOfDay.now();
    
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.fuchsia,
          ),
        ),
        child: child!,
      ),
    );
    
    if (picked != null) {
      setState(() {
        _time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
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

  void _submit() {
    // ✅ Validaciones UI-only para feedback inmediato
    if (_formKey.currentState?.validate() != true) return;
    if (_date == null || _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fecha y categoría son obligatorias'),
          backgroundColor: AppColors.destructiveDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // ✅ CORREGIDO: Usar eventFormProvider.notifier en lugar de eventFormProvider.notifier
    ref
        .read(eventFormProvider.notifier)
        .submit(
          name: _nombreCtrl.text.trim(),
          location: _ubicacionCtrl.text.trim(),
          date: _date!,
          time: _time,
          category: _category!,
          description: _descripcionCtrl.text.trim(),
          teamIds: _selectedTeams.map((t) => t.id).toList(),
          principalJudgeId: _principalJudgeId!,
          artistryJudgeId: _artistryJudgeId!,
          difficultyJudgeId: _difficultyJudgeId!,
          executionJudgeId: _executionJudgeId!,
          additionalJudgeIds: _additionalJudgeIds,
        );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nombreCtrl.clear();
    _ubicacionCtrl.clear();
    _descripcionCtrl.clear();
    setState(() {
      _date = null;
      _time = null;
      _category = null;
      _selectedTeams.clear();
      _principalJudgeId = null;
      _artistryJudgeId = null;
      _difficultyJudgeId = null;
      _executionJudgeId = null;
      _additionalJudgeIds.clear();
    });
  }

  void _showJudgeSelector(
    JudgeRoleFilter roleFilter,
    String? currentId,
    ValueChanged<String?> onSelected,
  ) {
    final judgesAsync = ref.watch(eventJudgesProvider);

    judgesAsync.when(
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cargando jueces...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      error: (err, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar jueces: $err'),
            backgroundColor: AppColors.destructiveLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      data: (allJudges) {
        // ✅ Calcular IDs excluidos: todos los jueces seleccionados EXCEPTO el actual de este rol
        final excludedIds = {
          if (_principalJudgeId != null && roleFilter != JudgeRoleFilter.principal)
            _principalJudgeId!,
          if (_artistryJudgeId != null && roleFilter != JudgeRoleFilter.artistry)
            _artistryJudgeId!,
          if (_difficultyJudgeId != null && roleFilter != JudgeRoleFilter.difficulty)
            _difficultyJudgeId!,
          if (_executionJudgeId != null && roleFilter != JudgeRoleFilter.execution)
            _executionJudgeId!,
          ..._additionalJudgeIds,
        };

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (ctx) => JudgeSelectionSheet(
            allJudges: allJudges,
            roleFilter: roleFilter,
            initiallySelectedId: currentId,
            excludedJudgeIds: excludedIds,
            onConfirm: onSelected,
          ),
        );
      },
    );
  }

  Widget _buildJudgeSelector(
    String label,
    JudgeRoleFilter roleFilter,
    String? selectedId,
    //bool isRequired,
    ValueChanged<String?> onChanged,
  ) {
    final judgesAsync = ref.watch(eventJudgesProvider);

    return judgesAsync.when(
      loading: () => const SizedBox(
        height: 48,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.fuchsia),
        ),
      ),
      error: (_, _) => const Text(
        'Error al cargar',
        style: TextStyle(color: AppColors.destructiveLight),
      ),
      data: (judges) {
        final selectedJudge = selectedId != null
            ? judges.firstWhereOrNull((j) => j.id == selectedId)
            : null;

        return AeroButton(
          label: selectedJudge != null
              ? '${selectedJudge.firstName} ${selectedJudge.lastName}'
              : label,
          onPressed: () => _showJudgeSelector(roleFilter, selectedId, onChanged),
          variant: selectedId != null
              ? AeroButtonVariant.primary
              : AeroButtonVariant.outline,
          fullWidth: true,
          trailingIcon: selectedId != null ? Icons.edit : Icons.arrow_forward_ios,
        );
      },
    );
  }

  Widget _buildJudgeChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.fuchsia, AppColors.coral],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.baseTextTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showTeamSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Consumer(
        builder: (context, ref, child) {
          final teamsAsync = ref.watch(eventTeamsProvider(null));

          return TeamSelectionSheet(
            teamsAsync: teamsAsync,
            initiallySelectedIds: _selectedTeams.map((t) => t.id).toList(),
            onConfirm: (selectedIds) {
              setState(() {
                _selectedTeams.clear();
                if (teamsAsync is AsyncData) {
                  _selectedTeams.addAll(
                    teamsAsync.value!.where(
                      (team) => selectedIds.contains(team.id),
                    ),
                  );
                }
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(eventFormProvider);
    final judgesAsync = ref.watch(eventJudgesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Efecto secundario: feedback post-submit sin rebuilds
    ref.listen<EventFormState>(eventFormProvider, (
      previous,
      next,
    ) {
      if (next.errorMessage != null && previous?.errorMessage == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: isDark
                  ? AppColors.destructiveDark
                  : AppColors.destructiveLight,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Reintentar',
                textColor: Colors.white,
                onPressed: _submit,
              ),
            ),
          );
        });
      }
    });

    return AeroForm(
      formKey: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formState.mode == FormMode.edit ? 'Editar Evento' : 'Nuevo Evento',
            style: AppTextStyles.baseTextTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete los datos del evento',
            style: AppTextStyles.baseTextTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          AeroFormField(
            label: 'Nombre del evento',
            required: true,
            field: AeroInput(
              controller: _nombreCtrl,
              hintText: 'Ej: Campeonato Regional',
              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(height: 16),

          AeroFormField(
            label: 'Fecha',
            required: true,
            field: InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.fuchsia),
                    const SizedBox(width: 8),
                    Text(
                      _date != null
                          ? DateFormat('dd/MM/yyyy').format(_date!)
                          : 'Seleccione fecha',
                      style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                        color: _date != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          AeroFormField(
            label: 'Hora',
            field: InkWell(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppColors.fuchsia),
                    const SizedBox(width: 8),
                    Text(
                      _time != null
                          ? _formatTime(_time!)
                          : 'Seleccione hora (opcional)',
                      style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                        color: _time != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          AeroFormField(
            label: 'Ubicación',
            required: true,
            field: AeroInput(
              controller: _ubicacionCtrl,
              hintText: 'Ej: Polideportivo Central',
              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(height: 16),

          AeroFormField(
            label: 'Categoría',
            required: true,
            field: AeroSelect<EventCategory>(
              value: _category,
              hint: 'Seleccione la categoría del evento',
              items: const [
                AeroSelectItem(value: EventCategory.universitario, label: 'Universitario'),
                AeroSelectItem(value: EventCategory.regional, label: 'Regional'),
                AeroSelectItem(value: EventCategory.nacional, label: 'Nacional'),
                AeroSelectItem(value: EventCategory.torneo, label: 'Torneo'),
              ],
              onChanged: (v) => setState(() => _category = v),
            ),
          ),
          const SizedBox(height: 16),

          AeroFormField(
            label: 'Descripción',
            field: AeroTextarea(
              controller: _descripcionCtrl,
              hintText: 'Descripción del evento (opcional)',
              maxLength: 500,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Text(
                'Jueces obligatorios',
                style: AppTextStyles.baseTextTheme.titleSmall?.copyWith(
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

          const SizedBox(height: 12),

          _buildJudgeSelector(
            'Juez Principal',
            JudgeRoleFilter.principal,
            _principalJudgeId,
            //isRequired: true,
            (id) => setState(() => _principalJudgeId = id),
          ),
          const SizedBox(height: 12),
          _buildJudgeSelector(
            'Juez de Arte',
            JudgeRoleFilter.artistry,
            _artistryJudgeId,
            (id) => setState(() => _artistryJudgeId = id),
          ),
          const SizedBox(height: 12),
          _buildJudgeSelector(
            'Juez de Dificultad',
            JudgeRoleFilter.difficulty,
            _difficultyJudgeId,
            (id) => setState(() => _difficultyJudgeId = id),
          ),
          const SizedBox(height: 12),
          _buildJudgeSelector(
            'Juez de Ejecución',
            JudgeRoleFilter.execution,
            _executionJudgeId,
            (id) => setState(() => _executionJudgeId = id),
          ),
          const SizedBox(height: 24),

          Text(
            'Jueces adicionales',
            style: AppTextStyles.baseTextTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          judgesAsync.when(
            loading: () => const SizedBox(
              height: 40,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.fuchsia),
              ),
            ),
            error: (_, _) => const Text(
              'Error al cargar jueces',
              style: TextStyle(color: AppColors.destructiveLight),
            ),
            data: (judges) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AeroSelect<String>(
                  value: null,
                  hint: 'Agregar juez adicional (opcional)',
                  items: judges
                      .where(
                        (j) =>
                            j.id != _principalJudgeId &&
                            j.id != _artistryJudgeId &&
                            j.id != _difficultyJudgeId &&
                            j.id != _executionJudgeId &&
                            !_additionalJudgeIds.contains(j.id),
                      )
                      .map(
                        (j) => AeroSelectItem(
                          value: j.id,
                          label: '${j.firstName} ${j.lastName}',
                        ),
                      )
                      .toList(),
                  onChanged: (id) {
                    if (id != null && !_additionalJudgeIds.contains(id)) {
                      setState(() => _additionalJudgeIds.add(id));
                    }
                  },
                ),
                if (_additionalJudgeIds.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _additionalJudgeIds.map((id) {
                      final judge = judges.firstWhere(
                        (j) => j.id == id,
                        orElse: () => UserEntity(
                          id: id,
                          username: '',
                          email: '',
                          firstName: 'Desconocido',
                          lastName: '',
                          role: UserRole.viewer,
                          status: 'active',
                        ),
                      );
                      return _buildJudgeChip(
                        '${judge.firstName} ${judge.lastName}',
                        () => setState(() => _additionalJudgeIds.remove(id)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          AeroFormField(
            label: 'Equipos participantes',
            required: true,
            field: AeroButton(
              label: 'Agregar Equipos (${_selectedTeams.length})',
              onPressed: _showTeamSelector,
              variant: AeroButtonVariant.outline,
              fullWidth: true,
            ),
          ),
          if (_selectedTeams.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._selectedTeams.map(
              (team) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fuchsia.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.fuchsia.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    AeroAvatar(fallbackText: team.name, radius: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team.name,
                            style: AppTextStyles.baseTextTheme.bodyLarge,
                          ),
                          Text(
                            team.university,
                            style: AppTextStyles.baseTextTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(
                        () => _selectedTeams.removeWhere((t) => t.id == team.id),
                      ),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          if (formState.isLoading) ...[
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
            label: formState.isEditing ? 'Actualizar Evento' : 'Crear Evento',
            onPressed: formState.isLoading ? null : _submit,
            fullWidth: true,
            isLoading: formState.isLoading,
          ),
          const SizedBox(height: 12),
          AeroButton(
            label: 'Limpiar',
            onPressed: formState.isLoading ? null : _clearForm,
            variant: AeroButtonVariant.outline,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}