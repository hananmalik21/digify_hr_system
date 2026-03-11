import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/user_management_enums.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../data/models/user_management/user_managment_status.dart';

class UserManagementSearchAndFilter extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final UserManagementStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<UserManagementStatus?> onStatusFilterChanged;
  final bool isDark;

  const UserManagementSearchAndFilter({
    super.key,
    required this.searchController,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.isDark,
  });

  @override
  ConsumerState<UserManagementSearchAndFilter> createState() =>
      _UserManagementSearchAndFilterState();
}

class _UserManagementSearchAndFilterState
    extends ConsumerState<UserManagementSearchAndFilter> {
  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField.search(
                  controller: widget.searchController,
                  hintText: 'Search by name, email, or user ID...',
                  onChanged: widget.onSearchChanged,
                ),
                Gap(12.h),
                SizedBox(
                  width: double.infinity,
                  child: DigifySelectField<UserManagementStatus?>(
                    hint: 'All Status',
                    value: widget.statusFilter,
                    items: userManagementStatusFilterItems,
                    itemLabelBuilder: (item) =>
                        item == null ? 'All Status' : item.displayName,
                    onChanged: widget.onStatusFilterChanged,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: widget.searchController,
                    hintText: 'Search...',
                    onChanged: widget.onSearchChanged,
                  ),
                ),
                Gap(16.w),
                SizedBox(
                  width: 180.w,
                  child: DigifySelectField<UserManagementStatus?>(
                    hint: 'All Status',
                    value: widget.statusFilter,
                    items: userManagementStatusFilterItems,
                    itemLabelBuilder: (item) =>
                        item == null ? 'All Status' : item.displayName,
                    onChanged: widget.onStatusFilterChanged,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
