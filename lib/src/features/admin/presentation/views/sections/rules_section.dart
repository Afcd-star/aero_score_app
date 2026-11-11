// lib/src/features/admin/presentation/views/sections/rules_section.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:aero_score_app/src/core/theme/text_styles.dart';
import 'package:aero_score_app/src/shared/presentation/widgets/admin/section_card.dart';
import 'package:flutter/material.dart';

/// Datos estáticos del reglamento (mover a archivo de configuración si crece)
class _RulesData {
  static const List<Map<String, dynamic>> sections = [
    {
      'title': 'Normas Generales',
      'gradient': [AppColors.fuchsia, Color(0xFF8B00FF)],
      'items': [
        'Los competidores deben presentarse 30 minutos antes del evento',
        'El vestuario debe cumplir con las normas de la federación',
        'Cada presentación tiene un tiempo máximo de 2 minutos',
        'No se permite el uso de elementos no autorizados',
      ],
    },
    {
      'title': 'Sistema de Puntuación',
      'gradient': [Colors.blue, Colors.blueAccent],
      'items': [
        'Ejecución técnica: 40%',
        'Expresión artística: 30%',
        'Dificultad: 30%',
      ],
    },
    {
      'title': 'Categorías',
      'gradient': [Colors.green, Colors.greenAccent],
      'items': [
        'Juvenil: 12-15 años',
        'Senior: 16-18 años',
        'Elite: 19+ años',
      ],
    },
    {
      'title': 'Penalizaciones',
      'gradient': [Colors.red, Colors.deepOrange],
      'items': [
        'Salida fuera del tapiz: -0.3 puntos',
        'Caída del aparato: -0.5 puntos',
        'Vestuario incorrecto: -0.3 puntos',
        'Exceso de tiempo: -0.3 puntos por cada 5 segundos',
      ],
    },
  ];
}

class RulesSection extends StatelessWidget {
  const RulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ CARD BLANCA ENVOLVENTE (consistente con otras secciones)
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header de la sección
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Icon(Icons.description, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reglamento',
                            style: AppTextStyles.baseTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Normas y regulaciones de la competición',
                            style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                              color: AppColors.textOnWhite.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Cards de reglamento
                ..._RulesData.sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index < _RulesData.sections.length - 1 ? 16 : 0),
                    child: _buildSectionCard(
                      context,
                      title: section['title'] as String,
                      gradientColors: section['gradient'] as List<Color>,
                      items: section['items'] as List<String>,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Color> gradientColors,
    required List<String> items,
  }) {
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ Aplicar opacidad alpha 0.7 al gradiente para fondo sutil
        gradient: LinearGradient(
          colors: gradientColors.map((color) => color.withValues(alpha: 0.65)).toList(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gradientColors.first.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.baseTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•',
                      style: TextStyle(
                        color: gradientColors.first,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.baseTextTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}