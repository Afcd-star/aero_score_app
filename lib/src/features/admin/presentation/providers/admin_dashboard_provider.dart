// lib/src/features/admin/presentation/providers/admin_dashboard_provider.dart
import 'package:aero_score_app/src/features/admin/domain/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Estado UI del dashboard admin (NO carga datos, solo gestiona navegación)
class AdminDashboardState {

  const AdminDashboardState({
    this.activeSection = AdminSection.home,
    this.isSyncing = false,
  });
  final AdminSection activeSection;
  final bool isSyncing;

  AdminDashboardState copyWith({
    AdminSection? activeSection,
    bool? isSyncing,
  }) => AdminDashboardState(
    activeSection: activeSection ?? this.activeSection,
    isSyncing: isSyncing ?? this.isSyncing,
  );
}

class AdminDashboardNotifier extends Notifier<AdminDashboardState> {
  AdminDashboardNotifier();

  @override
  AdminDashboardState build() => const AdminDashboardState();

  void setActiveSection(AdminSection section) {
    state = state.copyWith(activeSection: section);
  }

  void setSyncing(bool value) {
    state = state.copyWith(isSyncing: value);
  }

  Future<void> syncData() async {
    state = state.copyWith(isSyncing: true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(isSyncing: false);
  }

  Future<Map<String, int>> getStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return {
      'events': 15,
      'teams': 8,
      'competitors': 120,
    };
  }
}