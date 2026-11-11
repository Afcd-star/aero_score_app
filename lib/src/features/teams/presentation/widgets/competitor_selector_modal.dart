// lib/src/features/teams/presentation/widgets/competitor_selector_modal.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/competitors/presentation/providers/competitor_selector_provider.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal independiente para selección de competidores.
/// Maneja su propio estado de selección temporal y emite el resultado final.
class CompetitorSelectorModal extends ConsumerStatefulWidget {

  const CompetitorSelectorModal({
    required this.initialSelectedIds, required this.onConfirm, super.key,
  });
  final List<String> initialSelectedIds;
  final Function(List<String>) onConfirm;

  @override
  ConsumerState<CompetitorSelectorModal> createState() => _CompetitorSelectorModalState();
}

class _CompetitorSelectorModalState extends ConsumerState<CompetitorSelectorModal> {
  late List<String> _tempSelectedIds;

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = List.from(widget.initialSelectedIds);
  }

  void _toggleCompetitor(String id) {
    setState(() {
      if (_tempSelectedIds.contains(id)) {
        _tempSelectedIds.remove(id);
      } else {
        _tempSelectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final competitorsAsync = ref.watch(competitorSelectionProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ HEADER CON GRADIENTE AEROSCORE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.getGlowGradient(),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Seleccionar Competidores',
                    style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2, // ✅ PERMITIR: 2 líneas
                    overflow: TextOverflow.visible, // ✅ MOSTRAR: completo
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),

          // ✅ BODY - Fondo normal para contraste de contenido
          Expanded(
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
                      const Icon(Icons.error_outline, size: 48, color: AppColors.destructiveLight),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar',
                        style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
                          color: AppColors.destructiveLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        err.toString(),
                        style: AppTextStyles.baseTextTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      AeroButton(
                        label: 'Reintentar',
                        onPressed: () => ref.invalidate(competitorSelectionProvider),
                        variant: AeroButtonVariant.outline,
                      ),
                    ],
                  ),
                ),
              ),
              data: (competitors) {
                if (competitors.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No hay competidores disponibles'),
                        SizedBox(height: 8),
                        Text('Crea un competidor primero', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: competitors.length,
                  itemBuilder: (context, index) {
                    final comp = competitors[index];
                    final isSelected = _tempSelectedIds.contains(comp.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isDark ? AppColors.cardDark : Colors.grey.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.fuchsia,
                          child: Text(
                            comp.initials.isNotEmpty ? comp.initials : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          comp.fullName,
                          style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text('nationalId: ${comp.nationalId}', style: AppTextStyles.baseTextTheme.bodySmall),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.fuchsia)
                            : null,
                        onTap: () => _toggleCompetitor(comp.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ✅ FOOTER - Fondo normal con borde superior sutil
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_tempSelectedIds.length} seleccionado(s)',
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: AeroButton(
                    label: 'Confirmar',
                    onPressed: _tempSelectedIds.isEmpty ? null : () => widget.onConfirm(_tempSelectedIds),
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