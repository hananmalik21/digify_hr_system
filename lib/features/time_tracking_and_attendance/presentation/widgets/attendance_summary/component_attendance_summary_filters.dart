import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/timesheet/timesheet_status.dart';

class ComponentAttendanceSummaryFilters extends ConsumerWidget {
  const ComponentAttendanceSummaryFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.employeeManagement.filterSecondary.path,
            width: 20,
            height: 20,
          ),
          Gap(12.w),
          SizedBox(
            width: 180.w,
            child: DigifySelectField<TimesheetStatus?>(
              hint: 'All Departments',
              items: [],
              itemLabelBuilder: (item) =>
                  item == null ? 'All Departments' : item.displayName,
              onChanged: (value) {},
            ),
          ),
          Gap(12.w),
          SizedBox(
            width: 180.w,
            child: DateSelectionField(
              date: DateTime.now(),
              onDateSelected: (date) {},
            ),
          ),
        ],
      ),
    );
  }
}
