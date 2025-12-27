import 'dart:ui' as ui;

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/buttons/gradient_icon_button.dart';
import 'package:digify_hr_system/core/widgets/data/stats_card.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/department.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/department_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_department_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/department_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepartmentManagementScreen extends ConsumerWidget {
  const DepartmentManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final listState = ref.watch(departmentListNotifierProvider);
    final departments = listState.departments;
    final isRefreshing = listState.isLoading && departments.isNotEmpty;
    final isDark = context.isDark;

    // Calculate stats from current list
    final totalEmployees = departments.fold<int>(
      0,
      (prev, department) => prev + department.employees,
    );
    final activeDepartments =
        departments.where((department) => department.isActive).length;
    final totalBudget = departments.fold<double>(
      0,
      (prev, department) {
        final sanitized =
            department.budget.replaceAll('M', '').replaceAll(' KWD', '').replaceAll(',', '').replaceAll(' ', '');
        final parsed = double.tryParse(sanitized);
        return prev + (parsed ?? 0);
      },
    );

    final stats = [
      StatsCardData(
        label: localizations.totalDepartments,
        value: '${departments.length}',
        iconPath: 'assets/icons/total_departments_icon.svg',
        iconColor: const Color(0xFF00BBA7),
        iconBackground: const Color(0xFFCFFBF1),
      ),
      StatsCardData(
        label: localizations.activeDepartments,
        value: '$activeDepartments',
        iconPath: 'assets/icons/active_departments_icon.svg',
        iconColor: const Color(0xFF22C55E),
        iconBackground: const Color(0xFFDCFCE7),
      ),
      StatsCardData(
        label: localizations.totalEmployeesDept,
        value: '$totalEmployees',
        iconPath: 'assets/icons/total_employees_dept_icon.svg',
        iconColor: const Color(0xFF06B6D4),
        iconBackground: const Color(0xFFCEFAFE),
      ),
      StatsCardData(
        label: localizations.totalBudgetDept,
        value: '${totalBudget.toStringAsFixed(1)}M KWD',
        iconPath: 'assets/icons/total_budget_dept_icon.svg',
        iconColor: const Color(0xFF10B981),
        iconBackground: const Color(0xFFD0FAE5),
      ),
    ];

    return Container(
      color: context.themeBackground,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => ref.read(departmentListNotifierProvider.notifier).refresh(),
              child: Opacity(
                opacity: isRefreshing ? 0.5 : 1.0,
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.getResponsivePadding(
                    context,
                    mobile: EdgeInsetsDirectional.only(
                      top: 16.h,
                      start: 16.w,
                      end: 16.w,
                      bottom: 24.h,
                    ),
                    tablet: EdgeInsetsDirectional.only(
                      top: 24.h,
                      start: 24.w,
                      end: 24.w,
                      bottom: 24.h,
                    ),
                    web: EdgeInsetsDirectional.only(
                      top: 24.h,
                      start: 24.w,
                      end: 24.w,
                      bottom: 24.h,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildStatsSection(context, stats),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildSearchBar(context, ref, localizations),
                      SizedBox(height: ResponsiveHelper.isMobile(context) ? 16.h : 24.h),
                      _buildDepartmentList(
                        context,
                        ref,
                        listState,
                        departments,
                        localizations,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isRefreshing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(height: 16.h),
                          Text(
                            localizations.pleaseWait,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: context.themeTextSecondary,
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: const Color(0xFF00BBA7),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: SvgIconWidget(
              assetPath: 'assets/icons/department_management_header.svg',
              size: 24.sp,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.departmentManagement,
                style: TextStyle(
                  fontSize: isMobile ? 20.sp : 22.1.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleLarge?.color ??
                      context.themeTextPrimary,
                  height: 36 / 22.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.manageDepartmentsSubtitle,
                style: TextStyle(
                  fontSize: 15.1.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextSecondary,
                  height: 24 / 15.1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        GradientIconButton(
          label: localizations.addDepartment,
          iconPath: 'assets/icons/add_department_icon.svg',
          backgroundColor: const Color(0xFF009689),
          onTap: () => AddDepartmentDialog.show(context),
        ),
      ],
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    List<StatsCardData> stats,
  ) {
    final gap = 16.w;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(
          context,
          mobile: 1,
          tablet: 2,
          web: 4,
        );
        final totalSpacing = gap * (columns - 1);
        final width = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - totalSpacing) / columns
            : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 12.h,
          children: stats.map((stat) {
            return SizedBox(
              width: columns == 1 ? double.infinity : width,
              child: StatsCard(data: stat),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.inputBorderDark : const Color(0xFFE5E7EB),
        ),
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
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: TextField(
                onChanged: (value) {
                  ref.read(departmentSearchQueryProvider.notifier).state = value;
                  // Debounce API search - only search if user stops typing for 500ms
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (ref.read(departmentSearchQueryProvider) == value) {
                      ref.read(departmentListNotifierProvider.notifier).search(value);
                    }
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
                  border: InputBorder.none,
                  hintText: localizations.searchDepartmentsPlaceholder,
                  hintStyle: TextStyle(
                    color: const Color(0xFF364153).withValues(alpha: 0.5),
                    fontSize: 15.3.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/search_department_icon.svg',
                      size: 20.sp,
                      color: context.themeTextSecondary,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 0,
                    minWidth: 0,
                  ),
                ),
                style: TextStyle(
                  color: context.themeTextPrimary,
                  fontSize: 15.3.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                SvgIconWidget(
                  assetPath: 'assets/icons/business_unit_filter_icon.svg',
                  size: 20.sp,
                  color: context.themeTextSecondary,
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD1D5DC)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    localizations.allBusinessUnits,
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : const Color(0xFF0A0A0A),
                      height: 19 / 15.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentList(
    BuildContext context,
    WidgetRef ref,
    DepartmentListState listState,
    List<DepartmentOverview> departments,
    AppLocalizations localizations, {
    required bool isDark,
  }) {
    if (listState.isLoading && departments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (listState.hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                listState.errorMessage ?? 'An error occurred',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref.read(departmentListNotifierProvider.notifier).refresh(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (departments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 14.sp, color: context.themeTextSecondary),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ResponsiveHelper.getResponsiveColumns(
          context,
          mobile: 1,
          tablet: 2,
          web: 2,
        );
        const gap = 24.0;
        final totalSpacing = gap * (columns - 1);
        final cardWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - totalSpacing) / columns
            : double.infinity;

        return Wrap(
          spacing: gap,
          runSpacing: 24.h,
          children: departments.map((department) {
            return SizedBox(
              width: columns == 1 ? double.infinity : cardWidth,
              child: _DepartmentCard(
                department: department,
                localizations: localizations,
                isDark: isDark,
                onDelete: (dept) => _handleDelete(context, ref, dept, localizations),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    DepartmentOverview department,
    AppLocalizations localizations,
  ) async {
    bool isLoading = false;

    await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return _DeleteConfirmationDialogWithLoader(
            title: localizations.delete,
            message: 'Are you sure you want to delete this department? This action cannot be undone.',
            itemName: department.name,
            isLoading: isLoading,
            onConfirm: () async {
              setState(() {
                isLoading = true;
              });

              try {
                final deleteUseCase = ref.read(deleteDepartmentUseCaseProvider);
                await deleteUseCase(int.parse(department.id), hard: true);

                if (context.mounted) {
                  Navigator.of(context).pop(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Department deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  ref.read(departmentListNotifierProvider.notifier).refresh();
                }
              } on AppException catch (e) {
                setState(() {
                  isLoading = false;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete department: ${e.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                setState(() {
                  isLoading = false;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete department: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            onCancel: () {
              if (!isLoading) {
                Navigator.of(context).pop(false);
              }
            },
          );
        },
      ),
    );
  }
}

class _DeleteConfirmationDialogWithLoader extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const _DeleteConfirmationDialogWithLoader({
    required this.title,
    required this.message,
    this.itemName,
    required this.isLoading,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsetsDirectional.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error.withValues(alpha: 0.1),
                    AppColors.error.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/delete_icon_red.svg',
                      size: 24.sp,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        height: 28 / 20,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (!isLoading)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(false);
                        onCancel?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: SvgIconWidget(
                          assetPath: 'assets/icons/close_dialog_icon.svg',
                          size: 20.sp,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsetsDirectional.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                      height: 24 / 15.3,
                      letterSpacing: 0,
                    ),
                  ),
                  if (itemName != null) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackgroundGreyDark
                            : AppColors.grayBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : AppColors.cardBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              itemName!,
                              style: TextStyle(
                                fontSize: 15.3.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                                height: 24 / 15.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsetsDirectional.only(
                start: 24.w,
                end: 24.w,
                top: 20.h,
                bottom: 24.h,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop(false);
                            onCancel?.call();
                          },
                    style: TextButton.styleFrom(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : const Color(0xFFD1D5DC),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      localizations?.cancel ?? 'Cancel',
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF364153),
                        height: 24 / 15.3,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: isLoading ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.error.withValues(alpha: 0.6),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgIconWidget(
                                assetPath: 'assets/icons/delete_icon_red.svg',
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                localizations?.delete ?? 'Delete',
                                style: TextStyle(
                                  fontSize: 15.3.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 24 / 15.3,
                                ),
                              ),
                            ],
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
}

class _DepartmentCard extends StatelessWidget {
  final DepartmentOverview department;
  final AppLocalizations localizations;
  final bool isDark;
  final void Function(DepartmentOverview) onDelete;

  const _DepartmentCard({
    required this.department,
    required this.localizations,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DepartmentDetailsDialog.show(context, department),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: context.themeCardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: context.themeCardBorder),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCFFBF1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: SvgIconWidget(
                                assetPath: 'assets/icons/department_card_icon.svg',
                                size: 20.sp,
                                color: const Color(0xFF00BBA7),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  department.name,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: context.themeTextPrimary,
                                    height: 27 / 17,
                                  ),
                                ),
                                Text(
                                  department.nameArabic,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: context.themeTextSecondary,
                                    height: 24 / 16,
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _Badge(
                            label: department.code,
                            backgroundColor: const Color(0xFFF3F4F6),
                            textColor: const Color(0xFF364153),
                          ),
                          SizedBox(width: 8.w),
                          _Badge(
                            label: department.isActive
                                ? localizations.active
                                : localizations.inactive,
                            backgroundColor: isDark
                                ? AppColors.successBgDark
                                : const Color(0xFFDCFCE7),
                            textColor: isDark
                                ? AppColors.successTextDark
                                : const Color(0xFF016630),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _detailRow(
                        'assets/icons/division_small_icon_2.svg',
                        department.divisionName,
                      ),
                      SizedBox(height: 4.h),
                      _detailRow(
                        'assets/icons/business_unit_small_icon.svg',
                        department.businessUnitName,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _ActionIcon(
                      assetPath: 'assets/icons/edit_icon_green.svg',
                      onTap: () {
                        AddDepartmentDialog.show(
                          context,
                          isEditMode: true,
                          department: department,
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    _ActionIcon(
                      assetPath: 'assets/icons/delete_icon_red.svg',
                      onTap: () => onDelete(department),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  SvgIconWidget(
                    assetPath: 'assets/icons/head_icon.svg',
                    size: 16.sp,
                    color: context.themeTextSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${localizations.head}: ${department.headName}',
                    style: TextStyle(
                      fontSize: 13.9.sp,
                      fontWeight: FontWeight.w500,
                      color: context.themeTextSecondary,
                      height: 20 / 13.9,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _iconStat(
                    'assets/icons/email_icon.svg',
                    department.headEmail ?? localizations.notSpecified,
                    context,
                  ),
                ),
                Expanded(
                  child: _iconStat(
                    'assets/icons/phone_icon.svg',
                    department.headPhone ?? localizations.notSpecified,
                    context,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: [
                _iconStat(
                  'assets/icons/department_metric_icon.svg',
                  '${department.employees} ${localizations.emp}',
                  context,
                ),
                _iconStat(
                  'assets/icons/department_metric2_icon.svg',
                  '${department.sections} ${localizations.depts}',
                  context,
                ),
                _iconStat(
                  'assets/icons/department_metric3_icon.svg',
                  department.budget,
                  context,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SvgIconWidget(
                  assetPath: 'assets/icons/department_card_icon.svg',
                  size: 16.sp,
                  color: context.themeTextSecondary,
                ),
                SizedBox(width: 8.w),
                Text(
                  department.focusArea,
                  style: TextStyle(
                    fontSize: 13.6.sp,
                    fontWeight: FontWeight.w400,
                    color: context.themeTextSecondary,
                    height: 20 / 13.6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String iconPath, String text) {
    return Row(
      children: [
        SvgIconWidget(
          assetPath: iconPath,
          size: 12.sp,
          color: const Color(0xFF6A7282),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.6.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6A7282),
              height: 20 / 13.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconStat(String iconPath, String value, BuildContext context) {
    return SizedBox(
      width: 140.w,
      child: Row(
        children: [
          SvgIconWidget(
            assetPath: iconPath,
            size: 16.sp,
            color: const Color(0xFF6A7282),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6A7282),
                height: 20 / 13.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 20 / 13.5,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: context.themeCardBackground,
        ),
        child: Center(
          child: SvgIconWidget(
            assetPath: assetPath,
            size: 16.sp,
            color: context.themeTextSecondary,
          ),
        ),
      ),
    );
  }
}
