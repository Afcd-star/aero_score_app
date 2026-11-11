// lib/src/features/competitors/presentation/widgets/aero_competitor_form.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/core/theme/theme_helpers.dart';
import 'package:aero_score_app/src/core/utils/validators.dart';
import 'package:aero_score_app/src/features/'
    'competitors/domain/entities/competitor_entity.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_card.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_form.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_input.dart';
import 'package:aero_score_app/src/shared/'
    'presentation/widgets/aero/aero_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formulario visual para registrar un competidor.
class AeroCompetitorForm extends StatefulWidget {
  /// Crea el formulario con callback opcional de éxito.
  const AeroCompetitorForm({super.key, this.onSuccess});

  /// Callback ejecutado cuando el registro simulado termina bien.
  final VoidCallback? onSuccess;

  @override
  State<AeroCompetitorForm> createState() => _AeroCompetitorFormState();
}

class _AeroCompetitorFormState extends State<AeroCompetitorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _carneCtrl = TextEditingController();
  final TextEditingController _solapinCtrl = TextEditingController();

  CompetitorSex? _sex;
  String _academicYear = '';
  CompetitorCategory? _category;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _carneCtrl.dispose();
    _solapinCtrl.dispose();
    super.dispose();
  }

  // Detección automática de género al escribir carné.
  void _onCarneChanged(String value) {
    final result = Validators.validateCubanId(value);

    if (result.error == null &&
        result.detectedGender != null &&
        _sex != null) {
      setState(() => _sex = result.detectedGender);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Pendiente: conectar con CreateCompetitorUseCase o repositorio.
      await Future<void>.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '✅ Competidor registrado exitosamente',
            ),
            backgroundColor: ThemeHelper.getSuccess(context),
          ),
        );
        _clearForm();
        widget.onSuccess?.call();
      }
    } on Exception catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nombreCtrl.clear();
    _carneCtrl.clear();
    _solapinCtrl.clear();

    setState(() {
      _sex = null;
      _academicYear = '';
      _category = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AeroCard(
      padding: const EdgeInsets.all(20),
      child: AeroForm(
        formKey: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildFullNameField(),
            const SizedBox(height: 16),
            _buildCarneField(),
            const SizedBox(height: 16),
            _buildSolapinField(),
            const SizedBox(height: 16),
            _buildSexDropdown(),
            const SizedBox(height: 16),
            _buildAnioDropdown(),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 24),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.fuchsia, Color(0xFF8B00FF)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adicionar Competidor',
                style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Complete los datos del nuevo competidor',
                style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return AeroFormField(
      label: 'Nombre y apellidos',
      required: true,
      field: AeroInput(
        controller: _nombreCtrl,
        hintText: 'Nombre completo del competidor',
        validator: (v) {
          if (v?.trim().isEmpty == true) {
            return 'Requerido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCarneField() {
    return AeroFormField(
      label: 'Carné de identidad',
      required: true,
      field: AeroInput(
        controller: _carneCtrl,
        hintText: 'Número de carné (11 dígitos)',
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        onChanged: _onCarneChanged,
        validator: (v) {
          final result = Validators.validateCubanId(v);

          if (result.error != null) {
            return result.error;
          }

          if (v?.isEmpty == true) {
            return 'Requerido';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildSolapinField() {
    return AeroFormField(
      label: 'Solapín',
      field: AeroInput(
        controller: _solapinCtrl,
        hintText: 'Número de solapín (opcional)',
      ),
    );
  }

  Widget _buildSexDropdown() {
    return AeroFormField(
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
    );
  }

  Widget _buildAnioDropdown() {
    return AeroFormField(
      label: 'Año académico',
      required: true,
      field: DropdownButtonFormField<String>(
        initialValue:
            _academicYear.isEmpty ? null : _academicYear,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: List.generate(
          5,
          (i) => DropdownMenuItem<String>(
            value: '${i + 1}',
            child: Text('${i + 1}er año'),
          ),
        ),
        onChanged: (val) {
          setState(() => _academicYear = val ?? '');
        },
        validator: (v) {
          if (v == null) {
            return 'Seleccione el año';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return AeroFormField(
      label: 'Categoría',
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
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        AeroButton(
          label: 'Registrar Competidor',
          onPressed: _isLoading ? null : _submit,
          isLoading: _isLoading,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        AeroButton(
          label: 'Limpiar',
          variant: AeroButtonVariant.outline,
          onPressed: _isLoading ? null : _clearForm,
          fullWidth: true,
        ),
      ],
    );
  }
}
