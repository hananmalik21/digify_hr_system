import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import '../../../../workforce_structure/domain/models/org_structure_level.dart';
import '../../providers/attendance_summary/attendance_summary_enterprise_selection_provider.dart';
import '../../providers/attendance_summary/attendance_summary_org_structure_provider.dart';
import '../../providers/attendance_summary/attendance_summary_provider.dart';

class ComponentAttendanceSummaryFilters extends ConsumerStatefulWidget {
  const ComponentAttendanceSummaryFilters({super.key, required this.isDark});
  final bool isDark;

  @override
  ConsumerState<ComponentAttendanceSummaryFilters> createState() =>
      _ComponentAttendanceSummaryFiltersState();
}

class _ComponentAttendanceSummaryFiltersState
    extends ConsumerState<ComponentAttendanceSummaryFilters> {
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orgState = ref.read(attendanceSummaryOrgStructureNotifierProvider);
      if (!orgState.isLoading && orgState.orgStructure == null) {
        ref
            .read(attendanceSummaryOrgStructureNotifierProvider.notifier)
            .fetchOrgStructureLevels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.employeeManagement.filterSecondary.path,
                width: 20,
                height: 20,
              ),
              Gap(12.w),
              SizedBox(
                width: 180.w,
                child: DateSelectionField(
                  date: DateTime.now(),
                  onDateSelected: (date) {},
                ),
              ),
              Gap(12.w),
              AppButton.outline(
                label: 'Filters',
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                onPressed: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          Gap(16.h),
          if (_showFilters) ...[Gap(16.h), _buildAdvancedFilters(context)],
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    final orgState = ref.watch(attendanceSummaryOrgStructureNotifierProvider);
    final org = orgState.orgStructure;
    final isDark = widget.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath:
                        Assets.icons.employeeManagement.filterSecondary.path,
                    width: 20,
                    height: 20,
                  ),
                  Gap(8.w),
                  Text(
                    'Advanced Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              if (org != null)
                GestureDetector(
                  onTap: _resetOrgFilters,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reset filters',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.brandRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(6.w),
                      DigifyAsset(
                        assetPath: Assets.icons.refreshGray.path,
                        width: 16.w,
                        height: 16.h,
                        color: AppColors.brandRed,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Gap(16.h),
          Wrap(
            spacing: 14.w,
            runSpacing: 14.h,
            children: org == null
                ? _buildOrgFiltersLoadingPlaceholders()
                : _buildOrgCascade((
                    levels: org.activeLevels,
                    structureId: org.structureId,
                  )),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrgFiltersLoadingPlaceholders() {
    return List.generate(4, (_) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: SizedBox(
          width: 180.w,
          height: 48.h,
          child: Skeletonizer(
            enabled: true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? AppColors.inputBgDark
                    : AppColors.inputBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: widget.isDark
                      ? AppColors.cardBorderDark
                      : AppColors.borderGrey,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrgCascade(
    ({List<OrgStructureLevel> levels, String structureId}) param,
  ) {
    final notifier = ref.read(attendanceSummaryProvider.notifier);
    final selectionProvider =
        attendanceSummaryEnterpriseSelectionNotifierProvider(param.structureId);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled =
          index == 0 ||
          selectionState.getSelection(levels[index - 1].levelCode) != null;

      return SizedBox(
        width: 180.w,
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            final id = unit?.orgUnitId;
            ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
            notifier.setOrgFilter(id?.toString(), levelCode);
          },
        ),
      );
    }).toList();
  }

  void _resetOrgFilters() {
    final orgState = ref.read(attendanceSummaryOrgStructureNotifierProvider);
    final org = orgState.orgStructure;
    if (org != null) {
      ref
          .read(
            attendanceSummaryEnterpriseSelectionNotifierProvider(
              org.structureId,
            ).notifier,
          )
          .reset();
    }

    final notifier = ref.read(attendanceSummaryProvider.notifier);
    notifier.setOrgFilter(null, null);
  }
}
