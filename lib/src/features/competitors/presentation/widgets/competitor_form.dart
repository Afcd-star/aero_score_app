// lib/src/features/competitors/presentation/widgets/competitor_form.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/utils/validators.dart';
import 'package:aero_score_app/src/features/'
    'competitors/data/di/competitors_providers.dart';
import 'package:aero_score_app/src/features/'
    'competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_form_scaffold.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_input.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_progress.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_select.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Formulario en línea para crear o editar un competidor.
///
/// Va envuelto en [AeroFormScaffold], la pieza de contenedor de sección,
/// porque una pantalla entera de formulario no es un elemento de lista.
/// La tarjeta llena el alto acotado que el panel le cede, el botón de
/// volver queda fijo arriba y el cuerpo scrollea por dentro, de modo que
/// las acciones permanecen accesibles sin desplazar la vista.
///
/// Monta su propio botón de volver como primera fila fija, fuera del
/// scroll, para que el usuario no tenga que desplazarse hasta arriba
/// para alcanzarlo. Esto es un piloto de la decisión de API del catálogo
/// sobre el botón de regresar; se generaliza al envoltorio de formulario
/// en el subfrente de esa decisión, sin tocar el catálogo aquí.
class CompetitorForm extends ConsumerStatefulWidget {
  /// Crea el formulario con las funciones de éxito y cancelación.
  const CompetitorForm({super.key, this.onSuccess, this.onCancel});

  /// Función que se invoca al completarse un guardado exitoso.
  final VoidCallback? onSuccess;

  /// Función que se invoca al cancelar sin guardar.
  final VoidCallback? onCancel;

  @override
  ConsumerState<CompetitorForm> createState() => _CompetitorFormState();
}

class _CompetitorFormState extends ConsumerState<CompetitorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _ciController;
  late final TextEditingController _solapinController;

  CompetitorSex? _sex;
  bool _sexAutoDetected = false;
  int? _academicYear;
  CompetitorCategory? _category;
  String? _teamId;

  bool get _isEditing => ref.read(competitorFormProvider).isEditing;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  void _initForm() {
    final draft = ref.read(competitorFormProvider).draft;
    final fullName = draft == null
        ? ''
        : '${draft.firstName} ${draft.lastName}'.trim();
    _fullNameController = TextEditingController(text: fullName);
    _ciController = TextEditingController(text: draft?.nationalId ?? '');
    _solapinController = TextEditingController(text: draft?.solapin ?? '');
    if (draft != null) {
      _sex = draft.sex;
      _academicYear = draft.academicYear;
      _category = draft.category;
      _teamId = draft.teamId;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _ciController.dispose();
    _solapinController.dispose();
    super.dispose();
  }

  /// Detecta el sexo a partir del carné cuando el usuario no ha tocado
  /// el selector manualmente. Se activa con once dígitos válidos y deja
  /// de actuar en cuanto el usuario elige por su cuenta.
  void _onCiChanged(String value) {
    if (value.trim().length != 11) {
      return;
    }
    final result = Validators.validateCubanId(value);
    if (result.error != null || result.detectedGender == null) {
      return;
    }
    if (_sex == null || _sexAutoDetected) {
      setState(() {
        _sex = result.detectedGender;
        _sexAutoDetected = true;
      });
    }
  }

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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_sex == null || _academicYear == null || _category == null) {
      if (mounted) {
        AeroToast.warning(
          context,
          message: 'Complete todos los campos requeridos',
        );
      }
      return;
    }
    final (firstName, lastName) = _splitFullName(_fullNameController.text);
    final nationalId = _ciController.text.trim();
    final solapin = _solapinController.text.trim();
    final notifier = ref.read(competitorFormProvider.notifier);
    final bool ok;
    if (_isEditing) {
      final existing = ref.read(competitorFormProvider).draft;
      if (existing == null) {
        return;
      }
      ok = await notifier.updateCompetitor(
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
    } else {
      ok = await notifier.createCompetitor(
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
    if (!mounted) {
      return;
    }
    if (ok) {
      AeroToast.success(
        context,
        message: _isEditing
            ? 'Competidor actualizado correctamente'
            : 'Competidor creado correctamente',
      );
      widget.onSuccess?.call();
    } else {
      final message =
          ref.read(competitorFormProvider).error ??
          'No se pudo guardar el competidor';
      AeroToast.error(context, message: message);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _ciController.clear();
    _solapinController.clear();
    setState(() {
      _sex = null;
      _sexAutoDetected = false;
      _academicYear = null;
      _category = null;
      _teamId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(competitorFormProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    return AeroFormScaffold(
      onBack: widget.onCancel,
      body: AeroForm(
        formKey: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Editar Competidor' : 'Nuevo Competidor',
              style: AppTextStyles.baseTextTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _isEditing
                  ? 'Actualice los datos del competidor'
                  : 'Complete los datos del nuevo competidor',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: 24),
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
                onChanged: _onCiChanged,
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) {
                    return 'Requerido';
                  }
                  if (v!.trim().length != 11) {
                    return 'Debe tener 11 dígitos';
                  }
                  final result = Validators.validateCubanId(v);
                  return result.error;
                },
              ),
            ),
            const SizedBox(height: 16),
            AeroFormField(
              label: 'Solapín',
              field: AeroInput(
                controller: _solapinController,
                hintText: 'Número de solapín (opcional)',
              ),
            ),
            const SizedBox(height: 16),
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
                onChanged: (v) => setState(() {
                  _sex = v;
                  _sexAutoDetected = false;
                }),
              ),
            ),
            const SizedBox(height: 16),
            AeroFormField(
              label: 'Año académico',
              required: true,
              field: AeroSelect<int>(
                value: _academicYear,
                hint: 'Seleccione el año',
                items: List.generate(
                  5,
                  (i) => AeroSelectItem(value: i + 1, label: '${i + 1}°'),
                ),
                onChanged: (v) => setState(() => _academicYear = v),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            if (state.isLoading) ...[
              const AeroProgress.linear(),
              const SizedBox(height: 12),
            ],
            AeroButton(
              label: state.isLoading
                  ? (_isEditing ? 'Guardando...' : 'Creando...')
                  : (_isEditing ? 'Guardar' : 'Crear'),
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
      ),
    );
  }
}
