import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/date_selection_field.dart';
import 'package:digify_hr_system/core/widgets/common/digify_checkbox.dart';
import 'package:digify_hr_system/features/security_manager/presentation/widgets/user_management/user_form_section.dart';

class AccountInformationTab extends StatelessWidget {
  final bool isDark;

  const AccountInformationTab({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildAccountInfoSection(context),
          Gap(24.h),
          _buildContactInfoSection(context),
          Gap(24.h),
          _buildEmploymentInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Account Information',
        icon: Icon(Icons.person_outline, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'User ID',
              hintText: 'Auto-generated or manual entry',
              isRequired: true,
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Username',
              hintText: 'username',
              isRequired: true,
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Account Status',
              value: 'Active',
              items: const ['Active', 'Inactive'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
              isRequired: true,
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'User ID',
                    hintText: 'Auto-generated or manual entry',
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Username',
                    hintText: 'username',
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Account Status',
                    value: 'Active',
                    items: const ['Active', 'Inactive'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                    isRequired: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'First Name',
              hintText: 'First name',
              isRequired: true,
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Last Name',
              hintText: 'Last name',
              isRequired: true,
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'First Name',
                    hintText: 'First name',
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Last Name',
                    hintText: 'Last name',
                    isRequired: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'Password',
              hintText: 'Enter password',
              isRequired: true,
              obscureText: true,
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Confirm Password',
              hintText: 'Confirm password',
              isRequired: true,
              obscureText: true,
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    isRequired: true,
                    obscureText: true,
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm password',
                    isRequired: true,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            Row(
              children: [
                Expanded(
                  child: DateSelectionField(
                    label: 'Password Expiration',
                    hintText: 'dd/mm/yyyy',
                    date: null,
                    onDateSelected: (v) {},
                  ),
                ),
                Gap(16.w),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyCheckbox(value: false, onChanged: (v) {}),
                      Gap(8.w),
                      Text(
                        'Never expires',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(16.h),
            DateSelectionField(
              label: 'Account Expiration',
              hintText: 'dd/mm/yyyy',
              date: null,
              onDateSelected: (v) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DateSelectionField(
                          label: 'Password Expiration',
                          hintText: 'dd/mm/yyyy',
                          date: null,
                          onDateSelected: (v) {},
                        ),
                      ),
                      Gap(16.w),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DigifyCheckbox(value: false, onChanged: (v) {}),
                            Gap(8.w),
                            Text(
                              'Never expires',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DateSelectionField(
                    label: 'Account Expiration',
                    hintText: 'dd/mm/yyyy',
                    date: null,
                    onDateSelected: (v) {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Contact Information',
        icon: Icon(Icons.email_outlined, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'Email Address',
              hintText: 'user@digifyhr.com',
              isRequired: true,
              prefixIcon: Icon(Icons.email_outlined, size: 18),
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Secondary Email',
              hintText: 'secondary@email.com',
              prefixIcon: Icon(Icons.email_outlined, size: 18),
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Email Address',
                    hintText: 'user@digifyhr.com',
                    isRequired: true,
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Secondary Email',
                    hintText: 'secondary@email.com',
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'Work Phone',
              hintText: '+965 XXXX XXXX',
              prefixIcon: Icon(Icons.phone_outlined, size: 18),
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Mobile Phone',
              hintText: '+965 XXXX XXXX',
              prefixIcon: Icon(Icons.phone_android_outlined, size: 18),
            ),
            Gap(16.h),
            const DigifyTextField(labelText: 'Extension', hintText: 'Ext. 123'),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Work Phone',
                    hintText: '+965 XXXX XXXX',
                    prefixIcon: Icon(Icons.phone_outlined, size: 18),
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Mobile Phone',
                    hintText: '+965 XXXX XXXX',
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      size: 18,
                    ),
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Extension',
                    hintText: 'Ext. 123',
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            const DigifyTextField(
              labelText: 'Office Location',
              hintText: 'Building, Floor, Room',
              prefixIcon: Icon(Icons.location_on_outlined, size: 18),
            ),
            Gap(16.h),
            const DigifyTextField(
              labelText: 'Mailing Address',
              hintText: 'Complete mailing address',
            ),
          ] else ...[
            Row(
              children: [
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Office Location',
                    hintText: 'Building, Floor, Room',
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 18,
                    ),
                  ),
                ),
                Gap(24.w),
                const Expanded(
                  child: DigifyTextField(
                    labelText: 'Mailing Address',
                    hintText: 'Complete mailing address',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmploymentInfoSection(BuildContext context) {
    return UserFormSection(
      isDark: isDark,
      header: SectionHeaderCard(
        title: 'Employment Information',
        icon: Icon(
          Icons.business_center_outlined,
          color: AppColors.primary,
          size: 18.sp,
        ),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifySelectField<String>(
              label: 'Department',
              hint: 'Select Department',
              items: const [],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
              isRequired: true,
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Job Title',
              hint: 'Select Job Title',
              items: const [],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
              isRequired: true,
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Employee Type',
              value: 'Full-Time',
              items: const ['Full-Time', 'Part-Time', 'Contract'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Department',
                    hint: 'Select Department',
                    items: const [],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Job Title',
                    hint: 'Select Job Title',
                    items: const [],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Employee Type',
                    value: 'Full-Time',
                    items: const ['Full-Time', 'Part-Time', 'Contract'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifySelectField<String>(
              label: 'Reports To (Manager)',
              hint: 'Select Manager',
              items: const [],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Work Location',
              hint: 'Select Location',
              items: const [],
              itemLabelBuilder: (item) => item,
              onChanged: (v) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Reports To (Manager)',
                    hint: 'Select Manager',
                    items: const [],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Work Location',
                    hint: 'Select Location',
                    items: const [],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) {},
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DateSelectionField(
              label: 'Hire Date',
              hintText: 'dd/mm/yyyy',
              date: null,
              onDateSelected: (v) {},
            ),
            Gap(16.h),
            DateSelectionField(
              label: 'Start Date',
              hintText: 'dd/mm/yyyy',
              date: null,
              onDateSelected: (v) {},
            ),
            Gap(16.h),
            DateSelectionField(
              label: 'End Date',
              hintText: 'dd/mm/yyyy',
              date: null,
              onDateSelected: (v) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DateSelectionField(
                    label: 'Hire Date',
                    hintText: 'dd/mm/yyyy',
                    date: null,
                    onDateSelected: (v) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DateSelectionField(
                    label: 'Start Date',
                    hintText: 'dd/mm/yyyy',
                    date: null,
                    onDateSelected: (v) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DateSelectionField(
                    label: 'End Date',
                    hintText: 'dd/mm/yyyy',
                    date: null,
                    onDateSelected: (v) {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
