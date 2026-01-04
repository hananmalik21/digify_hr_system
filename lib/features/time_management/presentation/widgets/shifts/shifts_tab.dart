import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_error_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_content_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShiftsTab extends ConsumerStatefulWidget {
  const ShiftsTab({super.key});

  @override
  ConsumerState<ShiftsTab> createState() => _ShiftsTabState();
}

class _ShiftsTabState extends ConsumerState<ShiftsTab> {
  int? _selectedEnterpriseId;

  void _onSearchChanged(String searchText) {
    if (_selectedEnterpriseId == null) return;
    ref.read(shiftsNotifierProvider(_selectedEnterpriseId!).notifier).search(searchText);
  }

  void _onStatusChanged(String? status) {
    if (status == null || _selectedEnterpriseId == null) return;
    ref.read(shiftsNotifierProvider(_selectedEnterpriseId!).notifier).setStatusFilterFromString(status);
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    if (enterpriseId == null) return;

    if (enterpriseId != _selectedEnterpriseId) {
      setState(() {
        _selectedEnterpriseId = enterpriseId;
      });
      ref.read(shiftsNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    }
  }

  Future<void> _handleDelete(BuildContext context, ShiftOverview shift) async {
    if (_selectedEnterpriseId == null) return;

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
          .read(shiftsNotifierProvider(_selectedEnterpriseId!).notifier)
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
    final enterprisesState = ref.watch(enterprisesProvider);
    final shiftsState = _selectedEnterpriseId != null
        ? ref.watch(shiftsNotifierProvider(_selectedEnterpriseId!))
        : const ShiftState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enterprise Selection Section
        EnterpriseSelectorWidget(
          selectedEnterpriseId: _selectedEnterpriseId,
          onEnterpriseChanged: _onEnterpriseChanged,
        ),

        // Enterprise Error Display
        if (enterprisesState.hasError) EnterpriseErrorWidget(enterprisesState: enterprisesState),

        // Divider
        if (_selectedEnterpriseId != null && !enterprisesState.hasError)
          SizedBox(height: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),

        // Shifts Content Section
        if (_selectedEnterpriseId != null)
          ShiftsContentWidget(
            onSearchChanged: _onSearchChanged,
            onStatusChanged: _onStatusChanged,
            shiftsState: shiftsState,
            enterpriseId: _selectedEnterpriseId!,
            onDelete: (shift) => _handleDelete(context, shift),
          )
        else
          const TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view shifts'),
      ],
    );
  }
}
