import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/grid/employee_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeesGridView extends StatelessWidget {
  final List<EmployeeListItem> employees;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isLoading;
  final Function(EmployeeListItem) onView;
  final VoidCallback? onMore;

  const EmployeesGridView({
    super.key,
    required this.employees,
    required this.localizations,
    required this.isDark,
    this.isLoading = false,
    required this.onView,
    this.onMore,
  });

  static double get _minCardWidth => 280;

  static int _crossAxisCount(double width) {
    final count = (width / _minCardWidth).floor();
    return count.clamp(1, 4);
  }

  static const double _cardHeight = 386;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCount(constraints.maxWidth);
        final cellWidth = (constraints.maxWidth - (crossAxisCount - 1) * 16.w) / crossAxisCount;
        final childAspectRatio = cellWidth / _cardHeight.h;

        if (isLoading && employees.isEmpty) {
          return _buildSkeletonGrid(context, crossAxisCount, childAspectRatio);
        }
        if (employees.isEmpty) {
          return _buildEmptyState(context);
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return EmployeeGridCard(
              employee: employees[index],
              localizations: localizations,
              isDark: isDark,
              onView: () => onView(employees[index]),
              onMore: onMore,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48.h),
      alignment: Alignment.center,
      child: Text(
        localizations.noResultsFound,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF717182),
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid(BuildContext context, int crossAxisCount, double childAspectRatio) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Gap(8.h),
                        Container(
                          height: 12.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
