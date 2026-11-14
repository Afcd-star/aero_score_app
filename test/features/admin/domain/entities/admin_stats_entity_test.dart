// test/features/admin/domain/entities/admin_stats_entity_test.dart
import 'package:aero_score_app/src/features/admin/domain/entities/'
    'admin_stats_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Punto de entrada de la suite de metricas.
void main() {
  const base = AdminStats(
    activeUsers: 11,
    totalCompetitors: 10,
    totalTeams: 2,
    upcomingEvents: 1,
  );

  group('AdminStats', () {
    test('dos instancias con los mismos valores son iguales', () {
      const copia = AdminStats(
        activeUsers: 11,
        totalCompetitors: 10,
        totalTeams: 2,
        upcomingEvents: 1,
      );
      expect(copia, base);
      expect(copia.hashCode, base.hashCode);
    });

    test('copyWith cambia solo el campo indicado', () {
      final cambiada = base.copyWith(totalTeams: 5);
      expect(cambiada.totalTeams, 5);
      expect(cambiada.activeUsers, base.activeUsers);
      expect(cambiada, isNot(base));
    });
  });
}
