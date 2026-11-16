// lib/src/features/teams/data/di/teams_providers.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/teams/data/repositories/team_repository_impl.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:aero_score_app/src/features/teams/domain/repositories/team_repository.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_form_notifier.dart';
import 'package:aero_score_app/src/features/teams/presentation/providers/team_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor del repositorio de equipos.
///
/// Recibe el cliente global de PocketBase, que restaura la sesión, para
/// que todas las consultas lleven token.
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final pb = ref.watch(pocketBaseClientProvider);
  return TeamRepositoryImpl(pb);
});

/// Proveedor de la lista de equipos, con carga asíncrona y filtrado de
/// inactivos a cargo del notificador.
final teamListProvider =
    AsyncNotifierProvider<TeamListNotifier, List<TeamEntity>>(
      TeamListNotifier.new,
    );

/// Proveedor del estado del formulario de equipo.
final teamFormProvider = NotifierProvider<TeamFormNotifier, TeamFormState>(
  TeamFormNotifier.new,
);
