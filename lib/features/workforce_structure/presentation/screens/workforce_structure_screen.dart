import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/add_position_button.dart';
import 'package:digify_hr_system/core/widgets/export_button.dart';
import 'package:digify_hr_system/core/widgets/import_button.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels_tab.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/position_details_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/position_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/reporting_structure_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkforceStructureScreen extends ConsumerStatefulWidget {
  final String? initialTab;
  const WorkforceStructureScreen({super.key, this.initialTab});

  @override
  ConsumerState<WorkforceStructureScreen> createState() =>
      _WorkforceStructureScreenState();
}

class _WorkforceStructureScreenState
    extends ConsumerState<WorkforceStructureScreen> {
  String? selectedTab;

  @override
  void initState() {
    super.initState();
    // Initialize selectedTab in didChangeDependencies or build since we need localizations
  }

  @override
  void didUpdateWidget(WorkforceStructureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab &&
        widget.initialTab != null) {
      _updateSelectedTab();
    }
  }

  void _updateSelectedTab() {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      switch (widget.initialTab) {
        case 'positions':
          selectedTab = localizations.positions;
          break;
        case 'jobFamilies':
          selectedTab = localizations.jobFamilies;
          break;
        case 'jobLevels':
          selectedTab = localizations.jobLevels;
          break;
        case 'gradeStructure':
          selectedTab = localizations.gradeStructure;
          break;
        case 'reportingStructure':
          selectedTab = localizations.reportingStructure;
          break;
        case 'positionTree':
          selectedTab = localizations.positionTree;
          break;
        default:
          selectedTab = localizations.positions;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Initialize selectedTab if it's null
    if (selectedTab == null) {
      if (widget.initialTab != null) {
        switch (widget.initialTab) {
          case 'positions':
            selectedTab = localizations.positions;
            break;
          case 'jobFamilies':
            selectedTab = localizations.jobFamilies;
            break;
          case 'jobLevels':
            selectedTab = localizations.jobLevels;
            break;
          case 'gradeStructure':
            selectedTab = localizations.gradeStructure;
            break;
          case 'reportingStructure':
            selectedTab = localizations.reportingStructure;
            break;
          case 'positionTree':
            selectedTab = localizations.positionTree;
            break;
          default:
            selectedTab = localizations.positions;
        }
      } else {
        selectedTab = localizations.positions;
      }
    }

    final isDark = context.isDark;
    final stats = ref.watch(workforceStatsProvider);
    final filteredPositions = ref.watch(filteredPositionsProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
            top: 88.h,
            start: 32.w,
            end: 32.w,
            bottom: 24.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, localizations, isDark),
              SizedBox(height: 24.h),
              _buildStatsCards(context, localizations, stats, isDark),
              SizedBox(height: 24.h),
              _buildTabBar(context, localizations, isDark),
              SizedBox(height: 24.h),
              if (selectedTab == localizations.positions) ...[
                _buildSearchAndActions(context, localizations, isDark, ref),
                SizedBox(height: 24.h),
                _buildPositionsTable(localizations, filteredPositions, isDark),
              ] else if (selectedTab == localizations.jobFamilies) ...[
                const JobFamiliesTab(),
              ] else if (selectedTab == localizations.jobLevels) ...[
                const JobLevelsTab(),
              ] else if (selectedTab == localizations.gradeStructure) ...[
                const GradeStructureTab(),
              ] else if (selectedTab == localizations.reportingStructure) ...[
                const ReportingStructureTab(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF155DFC), Color(0xFF9810FA)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.all(24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.workforceStructure,
                  style: TextStyle(
                    fontSize: 22.7.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 32 / 22.7,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.managePositionsJobFamilies,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFDBEAFE),
                    height: 24 / 15.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  localizations.managePositionsJobFamiliesAr,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFDBEAFE),
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SvgIconWidget(
            assetPath: 'assets/icons/workforce_structure_icon.svg',
            size: 32.sp,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations localizations,
    WorkforceStats stats,
    bool isDark,
  ) {
    final statsCards = <_StatCardData>[
      _StatCardData(
        label: localizations.totalPositions,
        value: '${stats.totalPositions}',
        iconPath: 'assets/icons/business_unit_icon.svg',
        valueColor: const Color(0xFF101828),
      ),
      _StatCardData(
        label: localizations.filledPositions,
        value: '${stats.filledPositions}',
        iconPath: 'assets/icons/filled_position_icon.svg',
        valueColor: const Color(0xFF00A63E),
      ),
      _StatCardData(
        label: localizations.vacantPositions,
        value: '${stats.vacantPositions}',
        iconPath: 'assets/icons/warning_Icon.svg',
        valueColor: const Color(0xFFF54900),
      ),
      _StatCardData(
        label: localizations.fillRate,
        value: '${stats.fillRate.toStringAsFixed(1)}%',
        iconPath: 'assets/icons/price_up_item.svg',
        valueColor: const Color(0xFF155DFC),
      ),
    ];

    return Wrap(
      runSpacing: 16.h,
      children: statsCards.map((card) {
        return Padding(
          padding: EdgeInsetsDirectional.only(end: 16.w),
          child: SizedBox(
            width: 349.5.w,
            child: _buildStatCard(
              context,
              label: card.label,
              value: card.value,
              iconPath: card.iconPath,
              valueColor: card.valueColor,
              isDark: isDark,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String iconPath,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
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
                    fontSize: 23.4.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                    height: 32 / 23.4,
                  ),
                ),
              ],
            ),
          ),
          SvgIconWidget(assetPath: iconPath, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final tabs = [
      {
        'label': localizations.positions,
        'icon': 'assets/icons/business_unit_card_icon.svg',
      },
      {
        'label': localizations.jobFamilies,
        'icon': 'assets/icons/hierarchy_icon_department.svg',
      },
      {
        'label': localizations.jobLevels,
        'icon': 'assets/icons/levels_icon.svg',
      },
      {
        'label': localizations.gradeStructure,
        'icon': 'assets/icons/grade_icon.svg',
      },
      {
        'label': localizations.reportingStructure,
        'icon': 'assets/icons/company_filter_icon.svg',
      },
      {
        'label': localizations.positionTree,
        'icon': 'assets/icons/hierarchy_icon_department.svg',
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      width: double.infinity,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isSelected = selectedTab == tab['label'];
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedTab = tab['label']!;
                    });
                  },
                  borderRadius: BorderRadius.circular(6.r),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 18.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIconWidget(
                          assetPath: tab['icon']!,
                          size: 16.sp,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          tab['label']!,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            height: 24 / 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchAndActions(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    WidgetRef ref,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
      child: Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Search Field
          SizedBox(
            width: 520.w,
            child: TextField(
              onChanged: (value) {
                ref.read(positionSearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                isDense: true,

                /// 🎨 BACKGROUND COLOR
                filled: true,
                fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,

                /// 🔲 BORDER (ALL STATES)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.inputBorderDark
                        : AppColors.borderGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.inputBorderDark
                        : AppColors.borderGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.2,
                  ),
                ),

                /// 🔍 PREFIX ICON INSIDE FIELD
                prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                  child: SvgIconWidget(
                    assetPath: 'assets/icons/search_icon.svg',
                    size: 20.sp,
                    color: AppColors.textMuted,
                  ),
                ),

                /// 🚫 Remove default 48px padding
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),

                hintText: localizations.searchPositionsPlaceholder,
                hintStyle: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPlaceholder,
                ),

                /// 📐 INTERNAL SPACING
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 12.w,
                ),
              ),
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: context.themeTextPrimary,
              ),
            ),
          ),

          // Department Filter
          _buildOptionChip(
            width: 200.w,
            label: localizations.allDepartments,
            isDark: isDark,
          ),

          // Status Filter
          _buildOptionChip(
            width: 150.w,
            label: localizations.allStatus,
            isDark: isDark,
          ),

          AddButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            onTap: () {
              _showPositionFormDialog(context, Position.empty(), false);
            },
          ),
          ImportButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            backgroundColor: AppColors.greenButton,
            textColor: Colors.white,
            onTap: () {},
          ),
          ExportButton(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
            backgroundColor: const Color(0xFF4A5565),
            textColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChip({
    required String label,
    required bool isDark,
    double? width,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
        ),
        color: isDark ? AppColors.inputBgDark : Colors.white,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            height: 19 / 15.3,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionsTable(
    AppLocalizations localizations,
    List<Position> positions,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(context, localizations, isDark),
            ...positions.map((position) {
              return _buildTableRow(localizations, position);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final headerColor = isDark
        ? AppColors.cardBackgroundDark
        : const Color(0xFFF9FAFB);
    return Container(
      color: headerColor,
      child: Row(
        children: [
          _buildHeaderCell(localizations.positionCode, 117.53.w),
          _buildHeaderCell(localizations.title, 162.79.w),
          _buildHeaderCell(localizations.department, 151.96.w),
          _buildHeaderCell(localizations.jobFamily, 146.86.w),
          _buildHeaderCell(localizations.jobLevel, 141.12.w),
          _buildHeaderCell(localizations.gradeStep, 133.29.w),
          _buildHeaderCell(localizations.step, 100.w),
          _buildHeaderCell(localizations.reportsTo, 140.07.w),
          _buildHeaderCell(localizations.headcount, 125.12.w),
          _buildHeaderCell(localizations.vacancy, 108.22.w),
          _buildHeaderCell(localizations.status, 107.02.w),
          _buildHeaderCell(localizations.actions, 112.03.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 12.h,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6A7282),
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildTableRow(AppLocalizations localizations, Position position) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Text(
              position.code,
              style: TextStyle(
                fontSize: 13.9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.9,
              ),
            ),
            117.53.w,
          ),
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.titleEnglish,
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 20 / 13.7,
                  ),
                ),
                Text(
                  position.titleArabic,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
            162.79.w,
          ),
          _buildDataCell(
            Text(
              position.department,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            151.96.w,
          ),
          _buildDataCell(
            Text(
              position.jobFamily,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            146.86.w,
          ),
          _buildDataCell(
            Text(
              position.level,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            141.12.w,
          ),
          _buildDataCell(
            Text(
              position.grade,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.5,
              ),
            ),
            133.29.w,
          ),
          _buildDataCell(
            Text(
              position.step,
              style: TextStyle(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.5,
              ),
            ),
            100.w,
          ),
          _buildDataCell(
            Text(
              position.reportsTo ?? '-',
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            140.07.w,
          ),
          _buildDataCell(
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${position.filled}',
                    style: TextStyle(
                      fontSize: 13.3.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 20 / 13.3,
                    ),
                  ),
                  TextSpan(
                    text: '/${position.headcount}',
                    style: TextStyle(
                      fontSize: 13.3.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 20 / 13.3,
                    ),
                  ),
                ],
              ),
            ),
            125.12.w,
          ),
          _buildDataCell(_buildVacancyBadge(position, localizations), 108.22.w),
          _buildDataCell(
            _buildStatusBadge(localizations.active.toUpperCase()),
            107.02.w,
          ),
          _buildDataCell(
            Row(
              children: [
                _buildActionIcon(
                  'assets/icons/blue_eye_icon.svg',
                  () => _showPositionDetailsDialog(context, position),
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  'assets/icons/edit_icon.svg',
                  () => _showPositionFormDialog(context, position, true),
                ),
                SizedBox(width: 8.w),
                _buildActionIcon('assets/icons/red_delete_icon.svg', () {}),
              ],
            ),
            112.03.w,
          ),
        ],
      ),
    );
  }

  Widget _buildVacancyBadge(Position position, AppLocalizations localizations) {
    if (position.vacant > 0) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.orangeBg,
          borderRadius: BorderRadius.circular(9999.r),
        ),
        child: Column(
          children: [
            Text(
              '${position.vacant}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.orangeText,
                height: 16 / 12,
              ),
            ),
            Text(
              localizations.vacant,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.orangeText,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Text(
        localizations.filled,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.successText,
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.8.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.successText,
          height: 16 / 11.8,
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildActionIcon(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgIconWidget(assetPath: assetPath, size: 16.sp),
    );
  }

  void _showPositionDetailsDialog(BuildContext context, Position position) {
    ref.read(selectedPositionProvider.notifier).state = position;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PositionDetailsDialog(position: position),
    ).then((_) {
      ref.read(selectedPositionProvider.notifier).state = null;
    });
  }

  void _showPositionFormDialog(
    BuildContext context,
    Position position,
    bool isEdit,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) =>
          PositionFormDialog(initialPosition: position, isEdit: isEdit),
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String iconPath;
  final Color valueColor;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.valueColor,
  });
}
