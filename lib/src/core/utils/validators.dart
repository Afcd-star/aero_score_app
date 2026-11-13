// lib/src/core/utils/validators.dart
import 'package:aero_score_app/src/features/competitors/domain/entities/competitor_entity.dart';

/// Validadores de dominio reutilizables y testeables.
/// ✅ Puros: no dependen de Flutter ni de contexto.
class Validators {
  /// Valida carné de identidad cubano (11 dígitos) y extrae género.
  /// Retorna (error: null, detectedGender: 'masculino'/'femenino') si es válido.
  static ({String? error, CompetitorSex? detectedGender}) validateCubanId(String? value) {
    if (value == null || value.isEmpty) return (error: null, detectedGender: null);
    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return (error: 'Debe tener 11 dígitos numéricos', detectedGender: null);
    }
    final genderDigit = int.tryParse(value.substring(9, 10));
    if (genderDigit == null) return (error: 'Formato inválido', detectedGender: null);
    
    final detectedGender = (genderDigit % 2 == 0) ? CompetitorSex.masculine : CompetitorSex.feminine;
    return (error: null, detectedGender: detectedGender);
  }
}
