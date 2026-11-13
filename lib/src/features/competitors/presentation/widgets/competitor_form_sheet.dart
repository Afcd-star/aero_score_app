// lib/src/features/competitors/presentation/widgets/competitor_form_sheet.dart
import 'dart:async';

import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/'
    'competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/'
    'competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_input.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hoja de formulario para crear o editar un competidor.
class CompetitorFormSheet extends ConsumerStatefulWidget {
  /// Crea la hoja de formulario de competidor.
  const CompetitorFormSheet({super.key});

  @override
  ConsumerState<CompetitorFormSheet> createState() {
    return _CompetitorFormSheetState();
  }
}

class _CompetitorFormSheetState extends ConsumerState<CompetitorFormSheet> {
  final _formKey = GlobalKey<FormState>();

  // ✅ UN SOLO CONTROLLER para nombre completo
  late TextEditingController _fullNameController;
  late TextEditingController _ciController;
  late TextEditingController _solapinController;

  // ✅ Enums tipados, null en modo creación para mostrar hints
  CompetitorSex? _sex;
  int? _academicYear;
  CompetitorCategory? _category;
  String? _teamId;

  // ✅ Flag para saber si estamos editando
  bool get isEditing {
    return ref.read(competitorFormProvider).draft != null;
  }

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  // ✅ Inicializar formulario
  void _initForm() {
    final state = ref.read(competitorFormProvider);
    final competitor = state.draft;

    // ✅ Combinar firstName y lastName para campo único
    final fullName = competitor == null
        ? ''
        : '${competitor.firstName} ${competitor.lastName}'.trim();

    _fullNameController = TextEditingController(text: fullName);
    _ciController = TextEditingController(
      text: competitor?.nationalId ?? '',
    );
    _solapinController = TextEditingController(
      text: competitor?.solapin ?? '',
    );

    // ✅ Asignar valores solo en edición, si no dejar null
    if (competitor != null) {
      _sex = competitor.sex;
      _academicYear = competitor.academicYear;
      _category = competitor.category;
      _teamId = competitor.teamId;
    } else {
      // ✅ Modo creación, valores null para mostrar hints
      _sex = null;
      _academicYear = null;
      _category = null;
      _teamId = null;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ciController.dispose();
    _solapinController.dispose();
    super.dispose();
  }

  // ✅ Dividir fullName en firstName y lastName
  (String, String) _splitFullName(String fullName) {
    final trimmed = fullName.trim();
    final parts = trimmed.split(' ');

    if (parts.length < 2) {
      return (parts.first, '');
    }

    final firstName = parts.first;
    final lastName = parts.skip(1).join(' ');
    return (firstName, lastName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(competitorFormProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleStyle = AppTextStyles.baseTextTheme.titleLarge;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isEditing ? 'Editar Competidor' : 'Nuevo Competidor',
                  style: titleStyle?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ✅ Formulario con AeroForm
          Expanded(
            child: AeroForm(
              formKey: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Campo único para nombre completo
                    AeroFormField(
                      label: 'Nombre y apellidos',
                      required: true,
                      field: AeroInput(
                        controller: _fullNameController,
                        hintText: 'Introduzca su nombre completo',
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) {
                            return 'Requerido';
                          }
                          if (value.split(' ').length < 2) {
                            return 'Introduzca nombre y apellido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    AeroFormField(
                      label: 'Carné de identidad',
                      required: true,
                      field: AeroInput(
                        controller: _ciController,
                        hintText: 'Número de carné',
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v?.trim().isEmpty ?? true) {
                            return 'Requerido';
                          }
                          if (v!.trim().length != 11) {
                            return 'Debe tener 11 dígitos';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    AeroFormField(
                      label: 'Solapín ',
                      field: AeroInput(
                        controller: _solapinController,
                        hintText: 'Número de solapín (opcional)',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Select con value nullable para mostrar hint
                    AeroFormField(
                      label: 'Sexo',
                      required: true,
                      field: AeroSelect<CompetitorSex>(
                        value: _sex,
                        hint: 'Seleccione el sexo',
                        items: const [
                          AeroSelectItem(
                            value: CompetitorSex.masculine,
                            label: 'Masculino',
                          ),
                          AeroSelectItem(
                            value: CompetitorSex.feminine,
                            label: 'Femenino',
                          ),
                        ],
                        onChanged: (v) => setState(() => _sex = v),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Select con value nullable para mostrar hint
                    AeroFormField(
                      label: 'Año académico',
                      required: true,
                      field: AeroSelect<int>(
                        value: _academicYear,
                        hint: 'Seleccione el año',
                        items: List.generate(
                          5,
                          (i) => AeroSelectItem(
                            value: i + 1,
                            label: '${i + 1}°',
                          ),
                        ),
                        onChanged: (v) => setState(() => _academicYear = v),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Select con value nullable para mostrar hint
                    AeroFormField(
                      label: 'Categoría a competir',
                      required: true,
                      field: AeroSelect<CompetitorCategory>(
                        value: _category,
                        hint: 'Seleccione la categoría',
                        items: const [
                          AeroSelectItem(
                            value: CompetitorCategory.soloM,
                            label: 'Solo M',
                          ),
                          AeroSelectItem(
                            value: CompetitorCategory.soloF,
                            label: 'Solo F',
                          ),
                          AeroSelectItem(
                            value: CompetitorCategory.duoMixto,
                            label: 'Dúo Mixto',
                          ),
                          AeroSelectItem(
                            value: CompetitorCategory.trio,
                            label: 'Trío',
                          ),
                          AeroSelectItem(
                            value: CompetitorCategory.quinteto,
                            label: 'Quinteto',
                          ),
                        ],
                        onChanged: (v) => setState(() => _category = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Botones de acción con texto dinámico
          Row(
            children: [
              Expanded(
                child: AeroButton(
                  // ✅ Texto dinámico según modo y estado de carga
                  label: state.isLoading
                      ? (isEditing ? 'Guardando...' : 'Creando...')
                      : (isEditing ? 'Guardar' : 'Crear'),
                  onPressed: state.isLoading
                      ? null
                      : () => unawaited(_handleSubmit()),
                  isLoading: state.isLoading,
                  gradient: AppColors.getGlowGradient(),
                ),
              ),
              const SizedBox(width: 12),
              AeroButton(
                label: 'Cancelar',
                onPressed: () => Navigator.pop(context),
                variant: AeroButtonVariant.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ✅ Validar que los selects tengan valor
    if (_sex == null || _academicYear == null || _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor complete todos los campos requeridos',
          ),
          backgroundColor: AppColors.destructiveLight,
        ),
      );
      return;
    }

    final formState = ref.read(competitorFormProvider);

    // ✅ Dividir fullName en firstName y lastName
    final (firstName, lastName) = _splitFullName(_fullNameController.text);
    final nationalId = _ciController.text.trim();
    final solapin = _solapinController.text.trim();

    if (isEditing) {
      final existing = formState.draft;
      if (existing != null) {
          await ref
            .read(competitorFormProvider.notifier)
            .updateCompetitor(
              CompetitorEntity(
                id: existing.id,
                firstName: firstName,
                lastName: lastName,
                nationalId: nationalId,
                solapin: solapin.isEmpty ? null : solapin,
                sex: _sex!,
                academicYear: _academicYear!,
                category: _category!,
                teamId: _teamId,
              ),
            );
        }
    } else {
      await ref
          .read(competitorFormProvider.notifier)
          .createCompetitor(
            firstName: firstName,
            lastName: lastName,
            nationalId: nationalId,
            solapin: solapin.isEmpty ? null : solapin,
            sex: _sex!,
            academicYear: _academicYear!,
            category: _category!,
            teamId: _teamId,
          );
    }
  }
}
