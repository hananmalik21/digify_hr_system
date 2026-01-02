import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftsGrid extends StatelessWidget {
  final List<ShiftOverview> shifts;
  final Function(ShiftOverview) onView;
  final Function(ShiftOverview) onEdit;
  final Function(ShiftOverview) onCopy;

  const ShiftsGrid({
    super.key,
    required this.shifts,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getResponsiveColumns(
      context,
      mobile: 1,
      tablet: 2,
      web: 3,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shifts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 24.h,
        crossAxisSpacing: 24.w,
        mainAxisExtent: 320.h, // Adjusted to fit card content
      ),
      itemBuilder: (context, index) {
        final shift = shifts[index];
        return ShiftCard(
          shift: shift,
          onView: () => onView(shift),
          onEdit: () => onEdit(shift),
          onCopy: () => onCopy(shift),
        );
      },
    );
  }
}
