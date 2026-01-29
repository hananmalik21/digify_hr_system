import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';

final leaveManagementSelectedEnterpriseProvider = StateNotifierProvider<LeaveManagementEnterpriseNotifier, int?>((ref) {
  final notifier = LeaveManagementEnterpriseNotifier();
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

class LeaveManagementEnterpriseNotifier extends StateNotifier<int?> {
  LeaveManagementEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final leaveManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(leaveManagementSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
