import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid_skeleton.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/create_shift_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/shift_details_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/update_shift_dialog.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All Status';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shiftsNotifierProvider.notifier).loadFirstPage();
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final search = _searchController.text;
    ref.read(shiftsNotifierProvider.notifier).search(search);
  }

  void _onStatusChanged(String? status) {
    if (status != null) {
      setState(() => _selectedStatus = status);
      final isActive = status == 'All Status'
          ? null
          : status == 'Active'
          ? true
          : false;

      ref.read(shiftsNotifierProvider.notifier).setStatusFilter(isActive);
    }
  }

  Future<void> _handleDelete(BuildContext context, ShiftOverview shift) async {
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
      final success = await ref.read(shiftsNotifierProvider.notifier).deleteShift(shiftId: shift.id, hard: true);

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
    final shiftsState = ref.watch(shiftsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShiftActionBar(
          searchController: _searchController,
          selectedStatus: _selectedStatus,
          onStatusChanged: _onStatusChanged,
          onCreateShift: () => CreateShiftDialog.show(context),
          onUpload: () {},
          onExport: () {},
        ),
        SizedBox(height: 24.h),
        if (shiftsState.isLoading)
          const ShiftsGridSkeleton()
        else if (shiftsState.hasError)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(shiftsState.errorMessage ?? 'An error occurred', style: const TextStyle(color: Colors.red)),
            ),
          )
        else
          ShiftsGrid(
            shifts: shiftsState.items,
            onView: (shift) => ShiftDetailsDialog.show(context, shift),
            onEdit: (shift) => UpdateShiftDialog.show(context, shift),
            onCopy: (shift) {},
            onDelete: (shift) => _handleDelete(context, shift),
            deletingShiftId: shiftsState.deletingShiftId,
          ),
      ],
    );
  }
}
