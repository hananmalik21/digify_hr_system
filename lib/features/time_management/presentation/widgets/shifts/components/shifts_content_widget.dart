import 'package:digify_hr_system/core/widgets/feedback/empty_state_widget.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid_skeleton.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_error_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/create_shift_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/shift_details_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/update_shift_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Widget for the main shifts content section
class ShiftsContentWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final ShiftState shiftsState;
  final int enterpriseId;
  final ValueChanged<ShiftOverview> onDelete;

  const ShiftsContentWidget({
    super.key,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.shiftsState,
    required this.enterpriseId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action Bar
        ShiftActionBar(
          onSearchChanged: onSearchChanged,
          selectedStatus: shiftsState.statusString,
          onStatusChanged: onStatusChanged,
          onCreateShift: () => CreateShiftDialog.show(context, enterpriseId: enterpriseId),
          onUpload: () {},
          onExport: () {},
        ),

        // Spacing
        Gap(24.h),

        // Shifts Grid
        _buildShiftsGrid(context),
      ],
    );
  }

  Widget _buildShiftsGrid(BuildContext context) {
    if (shiftsState.isLoading) {
      return const ShiftsGridSkeleton();
    }

    if (shiftsState.hasError) {
      return ShiftsErrorWidget(shiftsState: shiftsState);
    }

    if (shiftsState.items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.schedule_outlined,
        title: 'No Shifts Found',
        message: 'There are no shifts available for this enterprise. Create a new shift to get started.',
        actionLabel: 'Create Shift',
        onAction: () => CreateShiftDialog.show(context, enterpriseId: enterpriseId),
      );
    }

    return ShiftsGrid(
      shifts: shiftsState.items,
      onView: (shift) => ShiftDetailsDialog.show(context, shift),
      onEdit: (shift) => UpdateShiftDialog.show(context, shift, enterpriseId: enterpriseId),
      onCopy: (shift) {},
      onDelete: onDelete,
      deletingShiftId: shiftsState.deletingShiftId,
    );
  }
}
