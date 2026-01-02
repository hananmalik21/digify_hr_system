import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_detail_row.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardContent extends StatelessWidget {
  final ShiftOverview shift;
  final bool isDark;

  const ShiftCardContent({
    super.key,
    required this.shift,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShiftCardHeader(shift: shift, isDark: isDark),
          SizedBox(height: 16.h),
          ShiftCardDetailRow(
            label: 'Time',
            value: '${shift.startTime} - ${shift.endTime}',
          ),
          ShiftCardDetailRow(
            label: 'Duration',
            value: '${shift.totalHours} hours',
          ),
          ShiftCardDetailRow(
            label: 'Break',
            value:
                '${shift.breakHours} ${shift.breakHours == 1 ? 'hour' : 'hours'}',
          ),
          ShiftCardDetailRow(label: 'Type', value: shift.shiftTypeRaw),
        ],
      ),
    );
  }
}
