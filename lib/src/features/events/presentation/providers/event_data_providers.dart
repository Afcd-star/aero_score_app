// lib/src/features/events/presentation/providers/event_data_providers.dart
// ✅ Mueve los providers aquí para evitar recreación en rebuilds
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:aero_score_app/src/features/auth/data/models/user_model.dart';
import 'package:aero_score_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:aero_score_app/src/features/teams/data/models/team_model.dart';
import 'package:aero_score_app/src/features/teams/domain/entities/team_entity.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/src/providers/future_provider.dart';

final FutureProviderFamily<List<TeamEntity>, String?> eventTeamsProvider = FutureProvider.family<List<TeamEntity>, String?>((ref, eventId) async {
  debugPrint('🔵 [TEAMS PROVIDER] Cargando equipos... eventId: $eventId');

  final pb = ref.watch(pocketBaseClientProvider);
  final filter = eventId != null ? 'event_id = "$eventId" && status = "active"' : 'status = "active"';

 debugPrint('📋 [TEAMS PROVIDER] Filtro: $filter');

  final result = await pb.collection('teams').getList(filter: filter, perPage: 100);
  return result.items.map((r) => TeamModel.fromMap(r.toJson()).toEntity()).toList();
});

final eventJudgesProvider = FutureProvider<List<UserEntity>>((ref) async {
  final pb = ref.watch(pocketBaseClientProvider);
  final result = await pb.collection('users').getList(
    filter: 'role ~ "Judge"',
    perPage: 100,
  );
  return result.items.map((r) => UserModel.fromPocketBase(r).toEntity()).toList();
});