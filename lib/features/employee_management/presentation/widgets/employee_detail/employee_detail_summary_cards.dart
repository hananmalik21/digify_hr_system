import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Row of summary cards (Service Period, Grade Level, Total Salary, Nationality).
class EmployeeDetailSummaryCards extends StatelessWidget {
  const EmployeeDetailSummaryCards({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const servicePeriod = '15y 11m';
    const gradeLevel = 'Grade';
    const totalSalary = '3094 KWD';
    const nationality = 'Pakistani';

    return Row(
      children: [
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Service Period', value: servicePeriod, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Grade Level', value: gradeLevel, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Total Salary', value: totalSalary, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Nationality', value: nationality, isDark: isDark),
        ),
      ],
    );
  }
}
