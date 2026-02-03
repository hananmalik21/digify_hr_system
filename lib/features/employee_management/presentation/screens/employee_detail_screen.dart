import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_header.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_tab_bar.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/compensation_benefits_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/documents_banking_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/employment_details_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/personal_info_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({super.key, required this.employee});

  final EmployeeListItem employee;

  static const int _tabCount = 4;

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: EmployeeDetailScreen._tabCount, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: EmployeeDetailHeader(employee: widget.employee, isDark: isDark),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: AppShadows.primaryShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmployeeDetailTabBar(controller: _tabController, isDark: isDark),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: _buildTabContent(_tabController.index, isDark),
                  ),
                ],
              ),
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int index, bool isDark) {
    final child = switch (index) {
      0 => PersonalInfoTabContent(isDark: isDark, wrapInScrollView: false),
      1 => EmploymentDetailsTabContent(isDark: isDark, wrapInScrollView: false),
      2 => CompensationBenefitsTabContent(isDark: isDark, wrapInScrollView: false),
      3 => DocumentsBankingTabContent(isDark: isDark, wrapInScrollView: false),
      _ => const SizedBox.shrink(),
    };
    return KeyedSubtree(key: ValueKey<int>(index), child: child);
  }
}
