import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_top_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveDetailsEmployeeSection extends StatelessWidget {
  const LeaveDetailsEmployeeSection({super.key, required this.employeeData, required this.isDark});

  final Map<String, dynamic> employeeData;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 14.w,
      children: [
        Expanded(
          child: LeaveDetailsTopCard(label: 'Join Date', value: employeeData['joinDate'] as String, isDark: isDark),
        ),
        Expanded(
          child: LeaveDetailsTopCard(
            label: 'Years of Service',
            value: '${employeeData['yearsOfService']} years',
            isDark: isDark,
          ),
        ),
        Expanded(
          child: LeaveDetailsTopCard(label: 'Department', value: employeeData['department'] as String, isDark: isDark),
        ),
        Expanded(
          child: LeaveDetailsTopCard(label: 'Position', value: employeeData['position'] as String, isDark: isDark),
        ),
      ],
    );
  }
}
