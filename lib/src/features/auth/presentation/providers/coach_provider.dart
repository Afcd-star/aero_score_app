// lib/src/features/auth/presentation/providers/coach_provider.dart
import 'package:aero_score_app/src/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo simple para coach
// lib/src/features/auth/presentation/providers/coach_provider.dart

class CoachInfo {   // ✅ Email opcional (privado)

  const CoachInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.email,
  });
  final String id;
  final String firstName;
  final String lastName;
  final String username; // ✅ Username en lugar de email
  final String? email;
  
  String get displayName {
    final fullName = '$firstName $lastName'.trim();
    return fullName.isNotEmpty ? fullName : username;
  }
  
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }
}

final coachesProvider = FutureProvider<List<CoachInfo>>((ref) async {
  debugPrint('🔍 [CoachProvider] ========== INICIANDO CARGA ==========');

  final pb = ref.watch(pocketBaseClientProvider);
  debugPrint('🔗 [CoachProvider] PocketBase URL: ${pb.baseURL}');

  try {
    debugPrint('📡 [CoachProvider] Filtrando: role = "Coach" && status = "Active"');
    
    final result = await pb.collection('users').getList(
      filter: 'role = "Coach" && status = "Active"',
      sort: 'firstName',
      perPage: 100,
    );
    
    debugPrint('✅ [CoachProvider] Total encontrados: ${result.items.length}');
    
    final coaches = <CoachInfo>[];

    for (final record in result.items) {
      final coach = CoachInfo(
        id: record.id,
        firstName: record.getStringValue('firstName'),
        lastName: record.getStringValue('lastName'),
        username: record.getStringValue('username'), // ✅ Siempre visible
        email: record.getStringValue('email'),        // ✅ Puede estar vacío/oculto
      );
      
      coaches.add(coach);
      debugPrint('   ➕ Coach: ${coach.displayName} (@${coach.username})');
    }

    debugPrint('✅ [CoachProvider] Total procesados: ${coaches.length}');
    return coaches;
    
  } catch (e, stack) {
    debugPrint('❌ [CoachProvider] Error: $e');
    debugPrint('📋 Stack: $stack');
    rethrow;
  }
});
