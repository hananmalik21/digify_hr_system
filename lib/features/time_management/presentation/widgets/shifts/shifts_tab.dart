import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid_skeleton.dart';
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
      ref.read(shiftsNotifierProvider.notifier).loadShifts();
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
    final isActive = _selectedStatus == 'All Status'
        ? null
        : _selectedStatus == 'Active'
        ? true
        : false;

    ref
        .read(shiftsNotifierProvider.notifier)
        .loadShifts(search: search.isEmpty ? null : search, isActive: isActive);
  }

  void _onStatusChanged(String? status) {
    if (status != null) {
      setState(() => _selectedStatus = status);
      final search = _searchController.text;
      final isActive = status == 'All Status'
          ? null
          : status == 'Active'
          ? true
          : false;

      ref
          .read(shiftsNotifierProvider.notifier)
          .loadShifts(
            search: search.isEmpty ? null : search,
            isActive: isActive,
          );
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
          onCreateShift: () {},
          onUpload: () {},
          onExport: () {},
        ),
        SizedBox(height: 24.h),
        if (shiftsState.isLoading)
          const ShiftsGridSkeleton()
        else if (shiftsState.error != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                shiftsState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        else
          ShiftsGrid(
            shifts: shiftsState.shifts,
            onView: (shift) {},
            onEdit: (shift) {},
            onCopy: (shift) {},
          ),
      ],
    );
  }
}
