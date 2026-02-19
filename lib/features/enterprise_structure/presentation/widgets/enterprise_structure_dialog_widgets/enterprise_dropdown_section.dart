import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnterpriseDropdownSection extends ConsumerWidget {
  final EditDialogParams params;
  final int? initialEnterpriseId;
  final AutoDisposeStateNotifierProviderFamily<
    EditEnterpriseStructureNotifier,
    EditEnterpriseStructureState,
    EditDialogParams
  >
  editDialogProvider;

  const EnterpriseDropdownSection({
    super.key,
    required this.params,
    required this.editDialogProvider,
    this.initialEnterpriseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesState = ref.watch(enterprisesProvider);
    final editState = ref.watch(editDialogProvider(params));
    final preferredId = editState.selectedEnterpriseId ?? initialEnterpriseId;
    final selectedId = preferredId != null && enterprisesState.enterprises.any((e) => e.id == preferredId)
        ? preferredId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        EnterpriseDropdown(
          label: 'Enterprise',
          isRequired: true,
          selectedEnterpriseId: selectedId,
          enterprises: enterprisesState.enterprises,
          isLoading: enterprisesState.isLoading,
          readOnly: false,
          onChanged: (enterpriseId) {
            ref.read(editDialogProvider(params).notifier).updateSelectedEnterprise(enterpriseId);
          },
          errorText: enterprisesState.hasError ? enterprisesState.errorMessage : null,
        ),
        Gap(16.h),
      ],
    );
  }
}
