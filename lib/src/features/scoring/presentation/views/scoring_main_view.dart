// lib/src/features/scoring/presentation/views/scoring_main_view.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/scoring/data/di/scoring_providers.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/result_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/entities/score_entity.dart';
import 'package:aero_score_app/src/features/scoring/domain/types.dart';
import 'package:aero_score_app/src/features/scoring/presentation/providers/scoring_notifier.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScoringMainView extends ConsumerStatefulWidget {

  const ScoringMainView({super.key, this.juryType});
  final JuryType? juryType;
  
  @override
  ConsumerState<ScoringMainView> createState() => _ScoringMainViewState();
}

class _ScoringMainViewState extends ConsumerState<ScoringMainView> {
  @override
  void initState() {
    super.initState();
    // ✅ Inicializar tipo de jurado desde el parámetro de ruta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.juryType != null) {
        ref.read(selectedJuryTypeProvider.notifier).selectJuryType(widget.juryType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scoringProvider);
    final selectedJuryType = ref.watch(selectedJuryTypeProvider);
    final selectedCompetitorId = ref.watch(selectedCompetitorIdProvider);
    // ✅ CORREGIDO: Usar provider público del notifier
    final notifier = ref.read(scoringProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundBase,
      appBar: AppBar(
        backgroundColor: AppColors.fuchsia,
        title: const Text('Calificaciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              if (selectedCompetitorId != null) {
                notifier.loadScores(competitorId: selectedCompetitorId, juryType: selectedJuryType);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildJurySelector(selectedJuryType, notifier),
          const SizedBox(height: 16),
          
          Expanded(
            child: state.scores.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.fuchsia)),
              error: (err, _) => _buildErrorState(err.toString()),
              data: (scores) => scores.isEmpty
                  ? _buildEmptyState()
                  : _buildScoresList(scores, state.result.value),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.fuchsia,
        onPressed: () => _showScoreSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJurySelector(JuryType? selectedJuryType, ScoringNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tipo de Jurado', style: AppTextStyles.baseTextTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: JuryType.values.map((type) {
              final isSelected = selectedJuryType == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AeroButton(
                    label: type.label,
                    onPressed: () {
                      // ✅ CORREGIDO: Usar método correcto del notifier
                      notifier.setCurrentJuryType(type);
                      ref.read(selectedJuryTypeProvider.notifier).selectJuryType(type);
                      
                      // Recargar scores con el nuevo filtro
                      final competitorId = ref.read(selectedCompetitorIdProvider);
                      if (competitorId != null) {
                        notifier.loadScores(competitorId: competitorId, juryType: type);
                      }
                    },
                    variant: isSelected 
                        ? AeroButtonVariant.primary 
                        : AeroButtonVariant.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text('Error: $error', style: AppTextStyles.baseTextTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.score, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('No hay calificaciones', style: AppTextStyles.baseTextTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildScoresList(List<ScoreEntity> scores, ResultEntity? result) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...scores.map(_buildScoreCard),
        const SizedBox(height: 24),
        if (result != null) _buildResultCard(result),
      ],
    );
  }

  Widget _buildScoreCard(ScoreEntity score) {
    return AeroCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.fuchsia, AppColors.coral]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                score.juryType == JuryType.difficulty ? Icons.star : 
                score.juryType == JuryType.execution ? Icons.check_circle : Icons.palette,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(score.juryType.label, style: AppTextStyles.baseTextTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('Valor: ${score.finalValue.toStringAsFixed(2)}', 
                    style: AppTextStyles.baseTextTheme.bodySmall),
                ],
              ),
            ),
            Text(
              score.finalValue.toStringAsFixed(2),
              style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                color: AppColors.fuchsia,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ResultEntity result) {
    return AeroCard(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resultado Final', style: AppTextStyles.baseTextTheme.titleMedium),
            const SizedBox(height: 16),
            _buildResultRow('Dificultad', result.difficultyTotal),
            _buildResultRow('Ejecución', result.executionTotal),
            _buildResultRow('Arte', result.artistryTotal),
            _buildResultRow('Deducciones', -result.deductionsTotal, isNegative: true),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL', style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  result.finalScore.toStringAsFixed(2),
                  style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                    color: AppColors.fuchsia,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.baseTextTheme.bodyMedium),
          Text(
            isNegative ? '-${value.abs().toStringAsFixed(2)}' : value.toStringAsFixed(2),
            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
              color: isNegative ? Colors.redAccent : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showScoreSheet(BuildContext context) {
    final selectedJuryType = ref.read(selectedJuryTypeProvider);
    final selectedCompetitorId = ref.read(selectedCompetitorIdProvider);
    
    if (selectedCompetitorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar un competidor primero'),
          backgroundColor: AppColors.destructiveLight,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderScope(
        child: _ScoreFormSheet(
          juryType: selectedJuryType ?? JuryType.difficulty,
          competitorId: selectedCompetitorId,
        ),
      ),
    );
  }
}

class _ScoreFormSheet extends ConsumerStatefulWidget {

  const _ScoreFormSheet({
    required this.juryType,
    required this.competitorId,
  });
  final JuryType juryType;
  final String competitorId;

  @override
  ConsumerState<_ScoreFormSheet> createState() => _ScoreFormSheetState();
}

class _ScoreFormSheetState extends ConsumerState<_ScoreFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _valueCtrl = TextEditingController();
  final _deductionsCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _valueCtrl.dispose();
    _deductionsCtrl.dispose();
    _observationsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            Text('Calificación - ${widget.juryType.label}', 
              style: AppTextStyles.baseTextTheme.titleLarge),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _valueCtrl,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Requerido';
                final val = double.tryParse(v);
                if (val == null || val < 0 || val > 10) return 'Valor entre 0 y 10';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            if (widget.juryType != JuryType.difficulty) ...[
              TextFormField(
                controller: _deductionsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deducciones',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
            ],
            
            TextFormField(
              controller: _observationsCtrl,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: AeroButton(
                label: _isSubmitting ? 'Guardando...' : 'Guardar Calificación',
                onPressed: _isSubmitting ? null : _submit,
                isLoading: _isSubmitting,
                gradient: AppColors.getGlowGradient(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    final value = double.tryParse(_valueCtrl.text) ?? 0;
    final deductions = double.tryParse(_deductionsCtrl.text);
    final observations = _observationsCtrl.text.trim().isEmpty ? null : _observationsCtrl.text.trim();
    
    final notifier = ref.read(scoringProvider.notifier);
    final success = await notifier.saveScore(
      competitorId: widget.competitorId,
      juryType: widget.juryType,
      value: value,
      deductions: deductions,
      observations: observations,
    );
    
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calificación guardada correctamente'),
          backgroundColor: AppColors.successLight,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la calificación'),
          backgroundColor: AppColors.destructiveLight,
        ),
      );
    }
  }
}