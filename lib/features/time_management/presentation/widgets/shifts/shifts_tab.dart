import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/core/widgets/feedback/empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_content_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftsTab extends ConsumerStatefulWidget {
  const ShiftsTab({super.key});

  @override
  ConsumerState<ShiftsTab> createState() => _ShiftsTabState();
}

class _ShiftsTabState extends ConsumerState<ShiftsTab> {
  void _onSearchChanged(String searchText) {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;
    ref.read(shiftsNotifierProvider(enterpriseId).notifier).search(searchText);
  }

  void _onStatusChanged(String? status) {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (status == null || enterpriseId == null) return;
    ref.read(shiftsNotifierProvider(enterpriseId).notifier).setStatusFilterFromString(status);
  }

  Future<void> _handleDelete(BuildContext context, ShiftOverview shift) async {
    final enterpriseId = ref.read(timeManagementSelectedEnterpriseProvider);
    if (enterpriseId == null) return;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Shift',
      message: 'Are you sure you want to delete this shift? This action cannot be undone.',
      itemName: shift.name,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;

    try {
      final success = await ref
          .read(shiftsNotifierProvider(enterpriseId).notifier)
          .deleteShift(shiftId: shift.id, hard: true);

      if (success && context.mounted) {
        ToastService.success(context, 'Shift deleted successfully', title: 'Success');
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message, title: 'Error');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete shift: ${e.toString()}', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(timeManagementSelectedEnterpriseProvider);
    final shiftsState = selectedEnterpriseId != null
        ? ref.watch(shiftsNotifierProvider(selectedEnterpriseId))
        : const ShiftState();

    if (selectedEnterpriseId == null) {
      return Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: EmptyStateWidget(
          icon: Icons.business_outlined,
          title: 'Select an Enterprise',
          message: 'Please select an enterprise from above to view and manage shifts',
        ),
      );
    }

    return ShiftsContentWidget(
      onSearchChanged: _onSearchChanged,
      onStatusChanged: _onStatusChanged,
      shiftsState: shiftsState,
      enterpriseId: selectedEnterpriseId,
      onDelete: (shift) => _handleDelete(context, shift),
    );
  }
}
