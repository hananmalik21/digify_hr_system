import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceSelectedEnterpriseProvider =
    StateNotifierProvider<AttendanceEnterpriseNotifier, int?>((ref) {
      final notifier = AttendanceEnterpriseNotifier(ref);
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

class AttendanceEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  AttendanceEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(attendanceNotifierProvider.notifier)
            .setCompanyId(enterpriseId.toString());
        ref
            .read(attendanceSummaryProvider.notifier)
            .setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final attendanceEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(attendanceSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
