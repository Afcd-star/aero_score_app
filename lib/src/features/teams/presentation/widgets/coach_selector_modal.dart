// lib/src/features/admin/presentation/widgets/coach_selector_modal.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/features/admin/presentation/providers/coach_provider.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/aero/aero_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modal independiente para selección de entrenador.
/// Maneja su propio estado y emite el ID del coach seleccionado.
class CoachSelectorModal extends ConsumerStatefulWidget {

  const CoachSelectorModal({
    required this.initialCoachId, required this.onConfirm, super.key,
  });
  final String? initialCoachId;
  final Function(String?) onConfirm;

  @override
  ConsumerState<CoachSelectorModal> createState() => _CoachSelectorModalState();
}

class _CoachSelectorModalState extends ConsumerState<CoachSelectorModal> {
  String? _selectedCoachId;

  @override
  void initState() {
    super.initState();
    debugPrint('🎬 [CoachModal] initState - ID inicial: ${widget.initialCoachId}');
    _selectedCoachId = widget.initialCoachId;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 [CoachModal] Build llamado');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coachesAsync = ref.watch(coachesProvider);

    debugPrint('📊 [CoachModal] Estado async: $coachesAsync');

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
                    'Seleccionar Entrenador',
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

          // ✅ BODY - Fondo normal para contraste
          Expanded(
            child: coachesAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando entrenadores...'),
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
                        onPressed: () => ref.invalidate(coachesProvider),
                        variant: AeroButtonVariant.outline,
                      ),
                    ],
                  ),
                ),
              ),
              data: (coaches) {
                if (coaches.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No hay entrenadores disponibles'),
                        SizedBox(height: 8),
                        Text('Registra un entrenador primero', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    final isSelected = _selectedCoachId == coach.id;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isDark ? AppColors.cardDark : Colors.grey.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.fuchsia,
                          child: Text(
                            coach.initials.isNotEmpty ? coach.initials : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          coach.displayName,
                          style: AppTextStyles.baseTextTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          coach.username.isNotEmpty ? '@${coach.username}' : 'Sin username', 
                          style: AppTextStyles.baseTextTheme.bodySmall),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.fuchsia)
                            : null,
                        onTap: () => setState(() => _selectedCoachId = coach.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ✅ FOOTER - Fondo normal con borde superior
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
                    _selectedCoachId != null ? 'Entrenador seleccionado' : 'Sin seleccionar',
                    style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: AeroButton(
                    label: 'Confirmar',
                    onPressed: () => widget.onConfirm(_selectedCoachId),
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