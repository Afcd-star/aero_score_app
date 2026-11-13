// lib/src/features/competitors/data/di/competitor_filter_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado del filtro de equipo seleccionado para la lista de
/// competidores.
///
/// Vive en competidores porque su consumidor es el provider de lista
/// de esta feature. Antes residia en administracion, lo que obligaba
/// a competidores a importar el modulo del panel.
class SelectedTeamIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  /// Selecciona el equipo activo del filtro.
  void selectTeam(String? teamId) {
    state = teamId;
  }

  /// Limpia la seleccion de equipo.
  void clearSelection() {
    state = null;
  }
}

/// Proveedor del filtro de equipo seleccionado.
final NotifierProvider<SelectedTeamIdNotifier, String?>
    selectedTeamIdProvider =
    NotifierProvider<SelectedTeamIdNotifier, String?>(
  SelectedTeamIdNotifier.new,
);
