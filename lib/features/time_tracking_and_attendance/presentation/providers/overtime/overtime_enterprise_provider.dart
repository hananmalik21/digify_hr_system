import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'overtime_provider.dart';

final overtimeSelectedEnterpriseProvider = StateNotifierProvider<OvertimeEnterpriseNotifier, int?>((ref) {
  final notifier = OvertimeEnterpriseNotifier(ref);
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

class OvertimeEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  OvertimeEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(overtimeManagementProvider.notifier).setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final overtimeEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(overtimeSelectedEnterpriseProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
