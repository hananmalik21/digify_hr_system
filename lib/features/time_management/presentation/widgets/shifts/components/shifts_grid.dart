import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftsGrid extends StatelessWidget {
  final List<ShiftOverview> shifts;
  final Function(ShiftOverview) onView;
  final Function(ShiftOverview) onEdit;
  final Function(ShiftOverview) onCopy;
  final Function(ShiftOverview)? onDelete;
  final int? deletingShiftId;

  const ShiftsGrid({
    super.key,
    required this.shifts,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.deletingShiftId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shifts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.getGridColumns(context),
            mainAxisSpacing: 24.h,
            crossAxisSpacing: 24.w,
            mainAxisExtent: ResponsiveHelper.getShiftCardExtent(context),
          ),
          itemBuilder: (context, index) {
            final shift = shifts[index];
            return ShiftCard(
              shift: shift,
              onView: () => onView(shift),
              onEdit: () => onEdit(shift),
              onCopy: () => onCopy(shift),
              onDelete: onDelete != null ? () => onDelete!(shift) : null,
              isDeleting: deletingShiftId == shift.id,
            );
          },
        ),
        Gap(24.h),
      ],
    );
  }
}
