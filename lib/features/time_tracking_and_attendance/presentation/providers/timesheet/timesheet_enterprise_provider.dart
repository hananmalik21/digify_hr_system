import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timesheetSelectedEnterpriseProvider = StateNotifierProvider<TimesheetEnterpriseNotifier, int?>((ref) {
  final notifier = TimesheetEnterpriseNotifier(ref);
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

class TimesheetEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  TimesheetEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(timesheetNotifierProvider.notifier).setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final timesheetEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(timesheetSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
