import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceScreenHeader extends StatelessWidget {
  final VoidCallback onMarkAttendance;

  const AttendanceScreenHeader({super.key, required this.onMarkAttendance});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: 'Daily Attendance',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'Import',
            onPressed: () {},
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: AppColors.shiftUploadButton,
          ),
          Gap(8.w),
          AppButton(
            label: 'Export',
            onPressed: () {},
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: AppColors.shiftExportButton,
          ),
          Gap(8.w),
          AppButton.primary(
            label: 'Mark Attendance',
            svgPath: Assets.icons.addDivisionIcon.path,
            onPressed: onMarkAttendance,
          ),
        ],
      ),
    );
  }
}
