import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_action_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shifts_grid.dart';
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

  // Mock data to match Figma design
  final List<ShiftOverview> _mockShifts = [
    const ShiftOverview(
      id: 1,
      name: 'Day Shift',
      code: 'DAY-SHIFT',
      startTime: '08:00',
      endTime: '17:00',
      totalHours: 9.0,
      isActive: true,
      assignedEmployeesCount: 10,
    ),
    const ShiftOverview(
      id: 2,
      name: 'Night Shift',
      code: 'NIGHT-SHIFT',
      startTime: '20:00',
      endTime: '05:00',
      totalHours: 9.0,
      isActive: true,
      assignedEmployeesCount: 5,
    ),
    const ShiftOverview(
      id: 3,
      name: 'Evening Shift',
      code: 'EVENING-SHIFT',
      startTime: '14:00',
      endTime: '22:00',
      totalHours: 8.0,
      isActive: true,
      assignedEmployeesCount: 8,
    ),
    const ShiftOverview(
      id: 4,
      name: 'Morning Shift',
      code: 'MORNING-SHIFT',
      startTime: '06:00',
      endTime: '14:00',
      totalHours: 8.0,
      isActive: true,
      assignedEmployeesCount: 12,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShiftActionBar(
          searchController: _searchController,
          selectedStatus: _selectedStatus,
          onStatusChanged: (status) {
            if (status != null) {
              setState(() => _selectedStatus = status);
            }
          },
          onCreateShift: () {},
          onUpload: () {},
          onExport: () {},
        ),
        SizedBox(height: 24.h),
        ShiftsGrid(
          shifts: _mockShifts,
          onView: (shift) {},
          onEdit: (shift) {},
          onCopy: (shift) {},
        ),
      ],
    );
  }
}
