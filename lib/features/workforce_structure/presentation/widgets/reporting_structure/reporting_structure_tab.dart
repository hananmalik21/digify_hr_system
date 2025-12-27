import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportingStructureTab extends ConsumerWidget {
  const ReportingStructureTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final positions = ref.watch(reportingPositionListProvider);
    final stats = ref.watch(reportingStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, localizations, isDark),
        SizedBox(height: 24.h),
        _buildStatsCards(context, localizations, stats, isDark),
        SizedBox(height: 24.h),
        _buildTable(context, localizations, positions, isDark),
        SizedBox(height: 24.h),
        _buildPositionTypesLegend(context, localizations, isDark),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.reportingStructure,
                style: TextStyle(
                  fontSize: 15.8.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  height: 24 / 15.8,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.reportingStructureDescription,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 20 / 13.7,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.reportingStructureDescriptionAr,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 20 / 13.7,
                ),
              ),
            ],
          ),
        ),
        _buildExportButton(localizations),
      ],
    );
  }

  Widget _buildExportButton(AppLocalizations localizations) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {

        },
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIconWidget(
                assetPath: 'assets/icons/download_icon.svg',
                size: 20.sp,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.exportTable,
                style: TextStyle(
                  fontSize: 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 24 / 15.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations localizations,
    ReportingStats stats,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 48.w) / 4;
        final minCardWidth = 160.0;
        final useWrap = cardWidth < minCardWidth;

        final cards = [
          _buildStatCard(
            label: localizations.totalPositions,
            value: '${stats.totalPositions}',
            iconPath: 'assets/icons/business_unit_icon.svg',
            backgroundColor: const Color(0xFFEFF6FF),
            valueColor: AppColors.primary,
            isDark: isDark,
          ),
          _buildStatCard(
            label: localizations.topLevel,
            value: '${stats.topLevelCount}',
            iconPath: 'assets/icons/hierarchy_icon_department.svg',
            backgroundColor: const Color(0xFFFFF7ED),
            valueColor: const Color(0xFFF97316),
            isDark: isDark,
          ),
          _buildStatCard(
            label: localizations.withReports,
            value: '${stats.withReportsCount}',
            iconPath: 'assets/icons/users_icon.svg',
            backgroundColor: const Color(0xFFECFDF5),
            valueColor: const Color(0xFF10B981),
            isDark: isDark,
          ),
          _buildStatCard(
            label: localizations.departments,
            value: '${stats.departmentsCount}',
            iconPath: 'assets/icons/departments_icon.svg',
            backgroundColor: const Color(0xFFF3E8FF),
            valueColor: const Color(0xFF9333EA),
            isDark: isDark,
          ),
        ];

        if (useWrap) {
          return Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: cards
                .map(
                  (card) => SizedBox(
                    width: (constraints.maxWidth - 16.w) / 2,
                    child: card,
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: cards.map((card) => Expanded(child: card)).toList()
            ..asMap().forEach((index, widget) {
              if (index < cards.length - 1) {}
            }),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String iconPath,
    required Color backgroundColor,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsetsDirectional.only(end: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B7FFF), // Light blue
            Color(0xFF1447E6), // Deep blue
          ],
        ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85), // better contrast
                  height: 20 / 13.6,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 36 / 28,
                ),
              ),
            ],
          ),
          SvgIconWidget(
            assetPath: iconPath,
            size: 32.sp,
            color: Colors.white, // optional but recommended
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    AppLocalizations localizations,
    List<ReportingPosition> positions,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
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
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 1400.w),
          child: Column(
            children: [
              _buildTableHeader(localizations, isDark),
              ...positions.map(
                (position) => _buildTableRow(position, localizations, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B7FFF), Color(0xFF1447E6)],
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell(localizations.positionCode, 180.w, isGradient: true),
          _buildHeaderCell(
            localizations.positionTitle,
            200.w,
            isGradient: true,
          ),
          _buildHeaderCell(localizations.department, 200.w, isGradient: true),
          _buildHeaderCell(localizations.jobLevel, 150.w, isGradient: true),
          _buildHeaderCell(localizations.gradeStep, 150.w, isGradient: true),
          _buildHeaderCell(localizations.reportsTo, 175.w, isGradient: true),
          _buildHeaderCell(
            localizations.directReports,
            160.w,
            isGradient: true,
          ),
          _buildHeaderCell(localizations.status, 100.w, isGradient: true),
          _buildHeaderCell(localizations.actions, 105.w, isGradient: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text,
    double width, {
    bool isGradient = false,
  }) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w600,
            color: isGradient ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(
    ReportingPosition position,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          // Position Code
          _buildPositionCodeCell(position.positionCode, 180.w),
          // Position Title
          _buildPositionTitleCell(
            position.titleEnglish,
            position.titleArabic,
            200.w,
          ),
          // Department
          _buildTagCell(
            position.department,
            const Color(0xFFEFF6FF),
            const Color(0xFF2563EB),
            200.w,
          ),
          // Level
          _buildTagCell(
            position.level,
            const Color(0xFFF3E8FF),
            const Color(0xFF9333EA),
            150.w,
          ),
          // Grade/Step
          _buildGradeStepCell(position.gradeStep, 150.w),
          // Reports To
          _buildReportsToCell(position, 175.w),
          // Direct Reports
          _buildDirectReportsCell(
            position.directReportsCount,
            localizations,
            160.w,
          ),
          // Status
          _buildStatusCell(position.status, 100.w),
          // Actions
          _buildActionsCell(105.w),
        ],
      ),
    );
  }

  Widget _buildPositionCodeCell(String code, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: SvgIconWidget(
                  assetPath: 'assets/icons/financial_icon.svg',
                  size: 16.sp,
                  color: Color(0xff9810FA),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 24 / 13.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionTitleCell(String titleEn, String titleAr, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleEn,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 24 / 13.7,
              ),
            ),
            Text(
              titleAr,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 16 / 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagCell(
    String text,
    Color bgColor,
    Color textColor,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: width - 32.w, // 👈 important for wrapping
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xffF3E8FF),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgIconWidget(
                    size: 12,
                    assetPath: "assets/icons/departments_icon.svg",
                    color: const Color(0xff6E11B0),
                  ),
                  SizedBox(width: 6.w),

                  /// ✅ This is the key
                  Flexible(
                    child: Text(
                      text,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff6E11B0),
                        height: 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildGradeStepCell(String gradeStep, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width - 32.w, // 👈 critical
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgIconWidget(
                assetPath: 'assets/icons/levels_icon.svg',
                size: 12.sp,
                color: const Color(0xFFD97706),
              ),
              SizedBox(width: 6.w),

              /// ✅ allows wrapping
              Flexible(
                child: Text(
                  gradeStep,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFD97706),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildReportsToCell(ReportingPosition position, double width) {
    if (position.isTopLevel) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
         SvgIconWidget(assetPath: "assets/icons/hierarchy_icon_department.svg",
           size:12,color: const Color(0xFF6E11B0),
         ),
                SizedBox(width: 6.w),
                Text(
                  'Top Level',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6E11B0),
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Icon(Icons.arrow_forward,size: 14,color: Color(0xff99A1AF),),
            // SvgIconWidget(
            //   assetPath: 'assets/icons/reports_to_arrow.svg',
            //   size: 14.sp,
            //   color: AppColors.textSecondary,
            // ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    position.reportsToTitle ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 20 / 13,
                    ),
                  ),
                  Text(
                    position.reportsToCode ?? '',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 16 / 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectReportsCell(
    int count,
    AppLocalizations localizations,
    double width,
  ) {
    if (count == 0) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.noReports,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  height: 16 / 12,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              localizations.viewReports,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status, double width) {
    final isActive = status.toLowerCase() == 'active';
    return SizedBox(
      // width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 12.sp,
                color: isActive
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
              ),
              SizedBox(width: 4.w),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFEF4444),
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsCell(double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionIcon('assets/icons/blue_eye_icon.svg'),
            SizedBox(width: 8.w),
            _buildActionIcon('assets/icons/edit_icon.svg'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(String assetPath) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgIconWidget(assetPath: assetPath, size: 16.sp),
        ),
      ),
    );
  }

  Widget _buildPositionTypesLegend(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.positionTypes,
            style: TextStyle(
              fontSize: 15.6.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              height: 24 / 15.6,
            ),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 32.w) / 3;
              final minCardWidth = 200.0;
              final useWrap = cardWidth < minCardWidth;

              final cards = [
                _buildPositionTypeCard(
                  icon: 'assets/icons/total_units_icon.svg',
                  title: localizations.topLevelPositions,
                  subtitle: localizations.noReportingManager,
                  bgColor: const Color(0xFFFAF5FF),
                  iconBgColor: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9810FA),
                ),
                _buildPositionTypeCard(
                  icon: 'assets/icons/total_units_icon.svg',
                  title: localizations.managementPositions,
                  subtitle: localizations.hasDirectReports,
                  bgColor: const Color(0xFFEFF6FF),
                  iconBgColor: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF155DFC),

                ),
                _buildPositionTypeCard(
                  icon: 'assets/icons/total_units_icon.svg',
                  title: localizations.individualContributors,
                  subtitle: localizations.noDirectReports,
                  bgColor: const Color(0xFFF9FAFB),
                  iconBgColor: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF4A5565),

                ),
              ];

              if (useWrap) {
                return Wrap(spacing: 16.w, runSpacing: 16.h, children: cards);
              }

              return Row(
                children: [
                  Expanded(child: cards[0]),
                  SizedBox(width: 16.w),
                  Expanded(child: cards[1]),
                  SizedBox(width: 16.w),
                  Expanded(child: cards[2]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPositionTypeCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgIconWidget(assetPath: icon, size: 20.sp,color: iconColor,),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 24 / 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
