import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/add_position_button.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_family_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_family_detail_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_level_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamiliesTab extends ConsumerWidget {
  const JobFamiliesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final jobFamilies = ref.watch(jobFamilyListProvider);
    final jobLevels = ref.watch(jobLevelListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.jobFamilies,
              style: TextStyle(
                fontSize: 15.6.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 24 / 15.6,
              ),
            ),
            AddButton(
              onTap: () {
                JobFamilyFormDialog.show(context);
              },
              customLabel: localizations.addJobFamily,
            )
          ],
        ),
        SizedBox(height: 24.h),
        // SizedBox(
        //   height: 650.h,
        //   child: GridView.builder(
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       crossAxisSpacing: 16.w,
        //       mainAxisSpacing: 16.h,
        //       childAspectRatio: 490 / 320,
        //     ),
        //     itemCount: jobFamilies.length,
        //     itemBuilder: (context, index) {
        //       return _buildJobFamilyCard(
        //         context,
        //         localizations,
        //         jobFamilies[index],
        //         isDark,
        //       );
        //     },
        //   ),
        // ),
        LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;

            final spacing = 16.w;
            final runSpacing = 20.h;

            // ✅ fixed target width like CSS
            final targetCardWidth = 466.0;

            // ✅ decide columns but keep max 3
            final columns = maxW < 600 ? 1 : maxW < 900 ? 2 : 3;

            // ✅ computed width, but clamp to 466 for web look
            final computed = (maxW - (spacing * (columns - 1))) / columns;
            final cardWidth = computed > targetCardWidth ? targetCardWidth : computed;

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: jobFamilies.asMap().entries.map((entry) {
                final index = entry.key;
                final jobFamily = entry.value;
                final jobLevel = jobLevels[index % jobLevels.length];

                return SizedBox(
                  width: cardWidth,
                  child: _buildJobFamilyCard(
                    context,
                    localizations,
                    jobFamily,
                    jobLevel,
                    jobLevels,
                    isDark,
                  ),
                );
              }).toList(),
            );
          },
        )


      ],
    );
  }

  Widget _buildJobFamilyCard(
    BuildContext context,
    AppLocalizations localizations,
    JobFamily jobFamily,
    JobLevel jobLevel,
    List<JobLevel> jobLevels,
    bool isDark,
  ) {
    final gap = 16.h;

    final cardContent = Container(
      padding: EdgeInsets.all(24.w), // padding: 24px
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // align-items:flex-start
        children: [
          // 1) Header block
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobFamily.nameEnglish,
                      style: TextStyle(
                        fontSize: 15.6.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 24 / 15.6,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      jobFamily.nameArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 20 / 14,
                      ),
                    ),
                    SizedBox(height: 8.h), // slightly more breathing before chip
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        jobFamily.code,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF193CB8),
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SvgIconWidget(
                assetPath: 'assets/icons/business_unit_details_icon.svg',
                color: const Color(0xFF2B7FFF),
                size: 24.sp,
              ),
            ],
          ),

          SizedBox(height: gap), // ✅ GAP 16

          // 2) Description block
          Text(
            jobFamily.description,
            style: TextStyle(
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 20 / 13.6,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: gap), // ✅ GAP 16

          // 3) Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                label: localizations.totalPositions,
                value: '${jobFamily.totalPositions}',
                fontSize: 14.sp,
              ),
              _buildStatItem(
                label: localizations.filled,
                value: '${jobFamily.filledPositions}',
                valueColor: const Color(0xFF00A63E),
                fontSize: 14.sp,
              ),
              _buildStatItem(
                label: localizations.fillRate,
                value: '${jobFamily.fillRate.toStringAsFixed(0)}%',
                valueColor: AppColors.primary,
                fontSize: 14.sp,
              ),
            ],
          ),

          SizedBox(height: gap), // ✅ GAP 16

          // 4) Divider
          Divider(
            color: AppColors.cardBorder,
            thickness: 1.w,
            height: 1, // ✅ prevent extra vertical padding from Divider itself
          ),

          SizedBox(height: gap), // ✅ GAP 16

          // 5) Buttons row
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => JobFamilyDetailDialog.show(
                      context,
                      jobFamily: jobFamily,
                      jobLevels: jobLevels,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIconWidget(
                            assetPath: 'assets/icons/view_icon_blue.svg',
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.view,
                            style: TextStyle(
                              fontSize: 15.1.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                              height: 24 / 15.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                  onTap: () {
                    JobFamilyFormDialog.show(
                      context,
                      jobFamily: jobFamily,
                      isEdit: true,
                      onSave: (updated) {
                        // TODO: wire to provider/persistence
                      },
                    );
                  },
                    borderRadius: BorderRadius.circular(4.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgIconWidget(
                            assetPath: 'assets/icons/edit_icon_green.svg',
                            size: 16.sp,
                            color: AppColors.greenButton,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.edit,
                            style: TextStyle(
                              fontSize: 15.4.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greenButton,
                              height: 24 / 15.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: cardContent,
    );
  }


  Widget _buildStatItem({
    required String label,
    required String value,
    Color? valueColor,
    required double fontSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 20 / 13.6,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
            height: 20 / fontSize,
          ),
        ),
      ],
    );
  }
}

