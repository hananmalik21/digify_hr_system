import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceStatusDropdown extends ConsumerWidget {
  final bool isDark;
  final String label;

  const WorkforceStatusDropdown({
    super.key,
    required this.isDark,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = ref.watch(
      positionNotifierProvider.select((s) => s.status),
    );

    return Container(
      width: 144.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
        ),
        color: isDark ? AppColors.inputBgDark : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PositionStatus?>(
          value: currentStatus,
          hint: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          onChanged: (PositionStatus? newValue) {
            ref.read(positionNotifierProvider.notifier).setStatus(newValue);
          },
          items: [
            DropdownMenuItem<PositionStatus?>(
              value: null,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            ...PositionStatus.values.map((status) {
              return DropdownMenuItem<PositionStatus?>(
                value: status,
                child: Center(
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              );
            }),
          ],
          icon: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
          ),
          isExpanded: true,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
