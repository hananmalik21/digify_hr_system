import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftsGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ShiftsGridSkeleton({super.key, this.itemCount = 6});

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
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 24.h,
        crossAxisSpacing: 24.w,
        mainAxisExtent: 320.h,
      ),
      itemBuilder: (context, index) {
        return const ShiftCardSkeleton();
      },
    );
  }
}
