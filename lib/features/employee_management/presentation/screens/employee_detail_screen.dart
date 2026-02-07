import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/employee_full_details_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_header.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_tab_bar.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/compensation_benefits_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/documents_banking_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/employment_details_tab_content.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/tabs/personal_info_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailScreen extends ConsumerStatefulWidget {
  const EmployeeDetailScreen({super.key, required this.employee});

  final EmployeeListItem employee;

  static const int _tabCount = 4;

  @override
  ConsumerState<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends ConsumerState<EmployeeDetailScreen> with SingleTickerProviderStateMixin {
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
    final fullDetailsAsync = ref.watch(employeeFullDetailsProvider(widget.employee.id));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: fullDetailsAsync.when(
        data: (EmployeeFullDetails? fullDetails) {
          final displayData = EmployeeDetailDisplayData(employee: widget.employee, fullDetails: fullDetails);
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: EmployeeDetailHeader(displayData: displayData, isDark: isDark),
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
                        child: _buildTabContent(_tabController.index, isDark, fullDetails),
                      ),
                    ],
                  ),
                ),
                Gap(24.h),
              ],
            ),
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLoadingIndicator(
                type: LoadingType.fadingCircle,
                color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                size: 48.r,
              ),
              Gap(16.h),
              Text(
                AppLocalizations.of(context)!.pleaseWait,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        error: (Object err, StackTrace _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(err.toString(), style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error)),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index, bool isDark, EmployeeFullDetails? fullDetails) {
    final child = switch (index) {
      0 => PersonalInfoTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      1 => EmploymentDetailsTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      2 => CompensationBenefitsTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      3 => DocumentsBankingTabContent(isDark: isDark, fullDetails: fullDetails, wrapInScrollView: false),
      _ => const SizedBox.shrink(),
    };
    return KeyedSubtree(key: ValueKey<int>(index), child: child);
  }
}
