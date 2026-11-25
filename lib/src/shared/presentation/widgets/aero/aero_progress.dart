// lib/src/shared/presentation/widgets/aero/aero_progress.dart
import 'package:aero_score_app/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Indicador de progreso de marca, circular o lineal.
///
/// Sustituye los indicadores crudos de Material. Usa el color fucsia de
/// la casa por defecto, y el lineal pinta su pista sobre el fondo
/// secundario fijo, sin rama por brillo.
class AeroProgress extends StatelessWidget {
  /// Indicador circular de marca.
  const AeroProgress.circular({super.key, this.size = 24.0})
    : _isLinear = false,
      value = null;

  /// Indicador lineal de marca.
  const AeroProgress.linear({super.key, this.value})
    : _isLinear = true,
      size = null;

  final bool _isLinear;

  /// Tamano del indicador circular en pixeles.
  final double? size;

  /// Proporcion del indicador lineal entre cero y uno. Nulo significa
  /// indeterminado.
  final double? value;

  @override
  Widget build(BuildContext context) {
    if (_isLinear) {
      return LinearProgressIndicator(
        value: value,
        backgroundColor: AppColors.backgroundSecondary,
        color: AppColors.fuchsia,
        minHeight: 4,
        borderRadius: BorderRadius.circular(2),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        color: AppColors.fuchsia,
        strokeWidth: 3,
      ),
    );
  }
}
