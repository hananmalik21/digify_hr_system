import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/add_position_button.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_level_detail_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_level_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelsTab extends ConsumerWidget {
  const JobLevelsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final jobLevels = ref.watch(jobLevelListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.jobLevels,
              style: TextStyle(
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 24 / 15.5,
              ),
            ),
            AddButton(
              customLabel: localizations.addJobLevel,
              onTap: () {
                JobLevelFormDialog.show(
                  context,
                  onSave: (level) {

                  },
                );
              },
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: -1,
              ),
            ],
          ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1459),
            child: Column(
              children: [
                _buildTableHeader(),
                ...jobLevels.map((level) {
                  return _buildTableRow(context, level);
                }),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFF9FAFB),
      child: Row(
        children: [
          _buildHeaderCell('Level Name', 244.57.w),
          _buildHeaderCell('Code', 133.38.w),
          _buildHeaderCell('Description', 446.61.w),
          _buildHeaderCell('Grade Range', 248.44.w),
          _buildHeaderCell('Total Positions', 216.64.w),
          _buildHeaderCell(
            'Actions',
            170.w,
            alignment: Alignment.center,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text,
    double width, {
    Alignment alignment = Alignment.centerLeft,
    TextAlign textAlign = TextAlign.start,
  }) {
      return Container(
        width: width,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 24.w,
          vertical: 12.h,
        ),
        alignment: alignment,
        child: Text(
          text.toUpperCase(),
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6A7282),
            height: 16 / 12,
          ),
        ),
      );
  }

  Widget _buildTableRow(BuildContext context, JobLevel level) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBorder,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Text(
              level.nameEnglish,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.7,
              ),
            ),
            244.57.w,
          ),
          _buildDataCell(
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                level.code,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6E11B0),
                  height: 16 / 12,
                ),
              ),
            ),
            133.38.w,
          ),
          _buildDataCell(
            Text(
              level.description,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            446.61.w,
            maxLines: 2,
          ),
          _buildDataCell(
            Text(
              level.gradeRange,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            248.44.w,
          ),
          _buildDataCell(
            Text(
              '${level.totalPositions}',
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            160.w,
          ),
          _buildDataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionIcon(
                      'assets/icons/blue_eye_icon.svg',
                      onTap: () => JobLevelDetailDialog.show(context, level),
                    ),
                    SizedBox(width: 8.w),
                  _buildActionIcon(
                    'assets/icons/edit_icon.svg',
                    onTap: () {
                      JobLevelFormDialog.show(
                        context,
                        jobLevel: level,
                        isEdit: true,
                        onSave: (updated) {

                        },
                      );
                    },
                  ),
                    SizedBox(width: 8.w),
                    _buildActionIcon('assets/icons/red_delete_icon.svg'),
                  ],
                ),
            170.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width, {int? maxLines}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildActionIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgIconWidget(
        assetPath: assetPath,
        size: 16.sp,
      ),
    );
  }
}

