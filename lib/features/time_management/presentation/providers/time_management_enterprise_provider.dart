import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';

final timeManagementSelectedEnterpriseProvider = StateNotifierProvider<TimeManagementEnterpriseNotifier, int?>((ref) {
  final notifier = TimeManagementEnterpriseNotifier(ref);
  final initialActive = ref.read(activeEnterpriseIdProvider);
  if (initialActive != null) {
    notifier.setEnterpriseId(initialActive);
  }
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !notifier.hasSelection) {
      notifier.setEnterpriseId(next);
    }
  });
  return notifier;
});

class TimeManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  TimeManagementEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAllTabProviders(enterpriseId);
      });
    }
  }

  void _updateAllTabProviders(int enterpriseId) {
    ref.read(shiftsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    ref.read(workPatternsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    ref.read(workSchedulesNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
  }
}

final timeManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(timeManagementSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
