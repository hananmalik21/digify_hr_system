import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';

final leaveManagementSelectedEnterpriseProvider = StateNotifierProvider<LeaveManagementEnterpriseNotifier, int?>((ref) {
  final notifier = LeaveManagementEnterpriseNotifier(ref);

  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null) {
      notifier.syncWithActiveEnterprise(next);
    }
  });

  return notifier;
});

class LeaveManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  LeaveManagementEnterpriseNotifier(this.ref) : super(null) {
    final activeEnterpriseId = ref.read(activeEnterpriseIdProvider);
    if (activeEnterpriseId != null) {
      state = activeEnterpriseId;
    }
  }

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }

  void syncWithActiveEnterprise(int activeEnterpriseId) {
    if (state == null) {
      state = activeEnterpriseId;
    }
  }
}
