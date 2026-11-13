// lib/src/features/competitors/presentation/providers/competitor_selector_provider.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompetitorSelectionInfo { // ✅ AGREGADO: Para saber si ya tiene equipo

  const CompetitorSelectionInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.university,
    this.teamId,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String nationalId;
  final String university;
  final String? teamId;

  String get fullName => '$firstName $lastName'.trim();
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
}

// ✅ CORREGIDO: Agregar parámetro currentTeamId para filtrar correctamente
final FutureProvider<List<CompetitorSelectionInfo>> competitorSelectionProvider = 
    FutureProvider.autoDispose<List<CompetitorSelectionInfo>>((ref) async {
  final pb = ref.watch(pocketBaseClientProvider);
  final result = await pb.collection('competitors').getList(
    page: 1,
    perPage: 200,
    filter: 'status = "active"',
    sort: 'firstName',
    expand: 'teamId', // ✅ Para obtener info del equipo si existe
  );

  return result.items.map((record) => CompetitorSelectionInfo(
    id: record.id,
    firstName: record.getStringValue('firstName'),
    lastName: record.getStringValue('lastName'),
    nationalId: record.getStringValue('nationalId'),
    university: record.getStringValue('university'),
    teamId: record.getStringValue('teamId').isEmpty 
        ? null 
        : record.getStringValue('teamId'), // ✅ Guardar teamId
  )).toList();
});

// ✅ NUEVO: Provider que filtra competidores disponibles
final FutureProvider<List<CompetitorSelectionInfo>> availableCompetitorsProvider = FutureProvider.autoDispose<List<CompetitorSelectionInfo>>((ref) async {
  final allCompetitors = await ref.watch(competitorSelectionProvider.future);
  final currentTeamId = ref.watch(currentEditingTeamIdProvider);
  
  // Filtrar: solo competidores sin equipo O que ya están en este equipo
  return allCompetitors.where((c) {
    if (c.teamId == null) return true; // ✅ Sin equipo - disponible
    if (currentTeamId != null && c.teamId == currentTeamId) return true; // ✅ Ya está en este equipo
    return false; // ❌ Ya está en otro equipo - no disponible
  }).toList();
});

// ✅ NUEVO: Provider para trackear el equipo que se está editando
final currentEditingTeamIdProvider = Provider<String?>((ref) => null);
