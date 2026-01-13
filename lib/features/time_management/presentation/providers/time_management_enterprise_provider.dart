import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_provider.dart';

final timeManagementSelectedEnterpriseProvider = StateNotifierProvider<TimeManagementEnterpriseNotifier, int?>((ref) {
  final notifier = TimeManagementEnterpriseNotifier(ref);

  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null) {
      notifier.syncWithActiveEnterprise(next);
    }
  });

  return notifier;
});

class TimeManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  TimeManagementEnterpriseNotifier(this.ref) : super(null) {
    final activeEnterpriseId = ref.read(activeEnterpriseIdProvider);
    if (activeEnterpriseId != null) {
      state = activeEnterpriseId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAllTabProviders(activeEnterpriseId);
      });
    }
  }

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAllTabProviders(enterpriseId);
      });
    }
  }

  void syncWithActiveEnterprise(int activeEnterpriseId) {
    if (state == null) {
      state = activeEnterpriseId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateAllTabProviders(activeEnterpriseId);
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
