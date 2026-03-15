import 'package:digify_hr_system/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../data/models/user_management/user_role.dart';
import '../../../widgets/user_management/user_form_section.dart';
import '../../../widgets/user_management/user_form_table_header_text.dart';

class RolesAndResponsibilitiesTab extends ConsumerStatefulWidget {
  const RolesAndResponsibilitiesTab({super.key});

  @override
  ConsumerState<RolesAndResponsibilitiesTab> createState() =>
      _RolesAndResponsibilitiesTabState();
}

class _RolesAndResponsibilitiesTabState
    extends ConsumerState<RolesAndResponsibilitiesTab> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: UserFormSection(
        isDark: context.isDark,
        header: SectionHeaderCard(
          title: 'Assigned Roles',
          subtitle: 'Assign application, job, and functional roles to the user',
          icon: Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: 18.sp,
          ),
          trailing: AppButton.primary(
            label: 'Add Role',
            svgPath: Assets.icons.addNewIconFigma.path,
            onPressed: () {},
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAndFiltersRow(),
            Gap(16.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: context.isDark
                      ? AppColors.cardBorderDark
                      : AppColors.dashboardCardBorder,
                ),
              ),
              child: Column(
                children: [_buildTableHeader(), _buildEmptyTableState()],
              ),
            ),
            Gap(16.h),
            Text(
              'Available Roles (${state.availableRoles.length})',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            Gap(16.h),
            _buildAvailableRolesGrid(
              context,
              roles: state.availableRoles,
              assignedRoles: state.assignedRoles,
              notifier: notifier,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundGreyDark
            : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: DigifyCheckbox(value: false, onChanged: (v) {}),
          ),
          Gap(16.w),
          UserFormTableHeaderText(
            text: 'ROLE NAME',
            flex: 2,
            isDark: context.isDark,
          ),
          UserFormTableHeaderText(
            text: 'CATEGORY',
            flex: 1,
            isDark: context.isDark,
          ),
          UserFormTableHeaderText(
            text: 'DESCRIPTION',
            flex: 2,
            isDark: context.isDark,
          ),
          UserFormTableHeaderText(
            text: 'EFFECTIVE DATE',
            flex: 1,
            isDark: context.isDark,
          ),
          UserFormTableHeaderText(
            text: 'END DATE',
            flex: 1,
            isDark: context.isDark,
          ),
          UserFormTableHeaderText(
            text: 'ACTIONS',
            flex: 1,
            isDark: context.isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTableState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      alignment: Alignment.center,
      child: Text(
        'No roles assigned. Click "Add Role" to assign roles to this user.',
        style: TextStyle(
          fontSize: 14.sp,
          color: context.isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSearchAndFiltersRow() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: DigifyTextField(
            hintText: 'Search roles...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIconFigma.path,
                width: 18,
                height: 18,
                color: AppColors.textPlaceholder,
              ),
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          flex: 1,
          child: DigifySelectField<String>(
            hint: 'All Categories',
            items: const ['All Categories', 'Application', 'Job', 'Function'],
            itemLabelBuilder: (v) => v,
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableRolesGrid(
    BuildContext context, {
    required List<UserRole> roles,
    required List<int> assignedRoles,
    required UserFormProvider notifier,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 1 : 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        mainAxisExtent: 110.h,
      ),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return _buildRoleCard(
          title: role.title,
          description: role.description,
          type: role.type,
          userCount: role.userCount,
          isSelected: assignedRoles.contains(role.id),
          onTap: () => notifier.setRole(role.id),
        );
      },
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required String type,
    required int userCount,

    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Durations.medium4,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : context.isDark
              ? AppColors.cardBackgroundDark
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : context.isDark
                ? AppColors.cardBorderDark
                : AppColors.dashboardCardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? AppColors.cardBackgroundGreyDark
                        : AppColors.tableHeaderBackground,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "$userCount users",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: context.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              type,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
