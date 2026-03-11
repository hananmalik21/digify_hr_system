import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/security_manager/domain/models/system_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'user_management_table_header.dart';
import 'user_management_table_row.dart';

class UserManagementTable extends StatelessWidget {
  final List<SystemUser> users;
  final bool isDark;
  final bool isLoading;

  const UserManagementTable({
    super.key,
    required this.users,
    required this.isDark,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 400.h),
        child: ScrollableSingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserManagementTableHeader(isDark: isDark),
              if (isLoading && users.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (users.isEmpty)
                SizedBox(
                  width: 1200.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48.h),
                    child: Center(
                      child: Text(
                        localizations.noResultsFound,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                )
              else
                ...users.map(
                  (user) => UserManagementTableRow(
                    user: user,
                    isDark: isDark,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
