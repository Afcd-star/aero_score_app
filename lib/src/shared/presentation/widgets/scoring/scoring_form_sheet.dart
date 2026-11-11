import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScoringFormSheet extends StatefulWidget {

  const ScoringFormSheet({
    required this.competitorName, required this.teamName, required this.juryType, required this.competitorId, required this.eventId, required this.category, required this.onSubmit, super.key,
  });
  final String competitorName;
  final String teamName;
  final JuryType juryType;
  final String competitorId;
  final String eventId;
  final String category;
  final Function(ScoreEntity) onSubmit;

  @override
  State<ScoringFormSheet> createState() => _ScoringFormSheetState();
}

class _ScoringFormSheetState extends State<ScoringFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _valueCtrl = TextEditingController();
  final _deductionsCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();

  double get rawValue => double.tryParse(_valueCtrl.text) ?? 0.0;
  double get deductions => double.tryParse(_deductionsCtrl.text) ?? 0.0;
  double get finalValue => (rawValue - deductions).clamp(0.0, 10.0);

  @override
  void dispose() {
    _valueCtrl.dispose();
    _deductionsCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final score = ScoreEntity(
        id: '',
        competitorId: widget.competitorId,
        eventId: widget.eventId,
        category: widget.category,
        judgeId: '', // Se inyecta desde el provider
        juryType: widget.juryType,
        rawValue: rawValue,
        deductionsValue: deductions,
        finalValue: finalValue,
        observations: _observationsCtrl.text.isNotEmpty ? _observationsCtrl.text : null,
        status: ScoreStatus.validated,
        timestamp: DateTime.now(),
      );
      widget.onSubmit(score);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Calificación - ${widget.juryType.label}',
              style: AppTextStyles.baseTextTheme.titleLarge,
            ),
            Text(
              '${widget.competitorName} • ${widget.teamName}',
              style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            if (widget.juryType == JuryType.difficulty) ...[
              AeroInput(
                controller: _valueCtrl,
                labelText: 'Valor de Dificultad (0.00 - 10.00)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val < 0 || val > 10) return 'Valor entre 0 y 10';
                  return null;
                },
              ),
            ] else ...[
              AeroInput(
                controller: _valueCtrl,
                labelText: 'Calificación Base (0.00 - 10.00)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val < 0 || val > 10) return 'Valor entre 0 y 10';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AeroInput(
                controller: _deductionsCtrl,
                labelText: 'Deducciones (0.00 - 10.00)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (v) {
                  final val = double.tryParse(v ?? '');
                  if (val == null || val < 0 || val > 10) return 'Deducciones entre 0 y 10';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.fuchsia.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.fuchsia),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calificación Final',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      finalValue.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: AppColors.fuchsia,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            AeroInput(
              controller: _observationsCtrl,
              labelText: 'Observaciones (Opcional)',
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            AeroButton(
              label: 'Enviar Calificación',
              onPressed: _submit,
              fullWidth: true,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}