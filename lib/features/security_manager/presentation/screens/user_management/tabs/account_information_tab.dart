import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/date_selection_field.dart';
import '../../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/user_management/user_form_provider.dart';
import '../../../widgets/user_management/user_form_section.dart';

class AccountInformationTab extends ConsumerStatefulWidget {
  const AccountInformationTab({super.key});

  @override
  ConsumerState<AccountInformationTab> createState() =>
      _AccountInformationTabState();
}

class _AccountInformationTabState extends ConsumerState<AccountInformationTab> {
  final _userIdController = TextEditingController();
  final _usernameController = TextEditingController();
  String _accountStatus = 'Active';
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _passwordExpiration;
  bool _isPasswordNeverExpires = false;
  DateTime? _accountExpiration;
  final _emailController = TextEditingController();
  final _secondaryEmailController = TextEditingController();
  final _workPhoneController = TextEditingController();
  final _mobilePhoneController = TextEditingController();
  final _extensionController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _mailingAddressController = TextEditingController();
  String? _department;
  String? _jobTitle;
  String? _reportToManager;
  String? _employeeType;
  String? _workLocation;
  DateTime? _hireDate;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    _userIdController.text = state.userId ?? "";
    _usernameController.text = state.userName ?? "";
    _accountStatus = state.accountStatus ?? "Active";
    _isPasswordNeverExpires = state.neverExpire ?? false;
    _passwordExpiration = state.passwordExpiration;
    _accountExpiration = state.accountExpiration;
    _emailController.text = state.email ?? "";
    _secondaryEmailController.text = state.secondaryEmail ?? "";
    _workPhoneController.text = state.workPhone ?? "";
    _mobilePhoneController.text = state.mobilePhone ?? "";
    _extensionController.text = state.extension ?? "";
    _officeLocationController.text = state.officeLocation ?? "";
    _mailingAddressController.text = state.mailingAddress ?? "";
    _department = state.department;
    _jobTitle = state.jobTitle;
    _reportToManager = state.reportToManager;
    _employeeType = state.employeeType;
    _workLocation = state.workLocation;
    _hireDate = state.hireDate;
    _startDate = state.startDate;
    _endDate = state.endDate;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildAccountInfoSection(context, notifier),
          Gap(24.h),
          _buildContactInfoSection(context, notifier),
          Gap(24.h),
          _buildEmploymentInfoSection(context, notifier),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection(
    BuildContext context,
    UserFormProvider notifier,
  ) {
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Account Information',
        icon: Icon(Icons.person_outline, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _userIdController,
              labelText: 'User ID',
              hintText: 'Auto-generated or manual entry',
              isRequired: true,
              onChanged: (v) => notifier.setUserId(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'username',
              isRequired: true,
              onChanged: (v) => notifier.setUserName(v),
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Account Status',
              value: _accountStatus,
              items: const ['Active', 'Inactive'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setAccountStatus(v!),
              isRequired: true,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _userIdController,
                    labelText: 'User ID',
                    hintText: 'Auto-generated or manual entry',
                    isRequired: true,
                    onChanged: (v) => notifier.setUserId(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    hintText: 'username',
                    isRequired: true,
                    onChanged: (v) => notifier.setUserName(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Account Status',
                    value: _accountStatus,
                    items: const ['Active', 'Inactive'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setAccountStatus(v!),
                    isRequired: true,
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _firstNameController,
              labelText: 'First Name',
              hintText: 'First name',
              isRequired: true,
              onChanged: (v) => notifier.setFirstName(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _lastNameController,
              labelText: 'Last Name',
              hintText: 'Last name',
              isRequired: true,
              onChanged: (v) => notifier.setLastName(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    hintText: 'First name',
                    isRequired: true,
                    onChanged: (v) => notifier.setFirstName(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    hintText: 'Last name',
                    isRequired: true,
                    onChanged: (v) => notifier.setLastName(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter password',
              isRequired: true,
              obscureText: true,
              onChanged: (v) => notifier.setPassword(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Confirm password',
              isRequired: true,
              obscureText: true,
              onChanged: (v) => notifier.setConfirmPassword(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter password',
                    isRequired: true,
                    obscureText: true,
                    onChanged: (v) => notifier.setPassword(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm password',
                    isRequired: true,
                    obscureText: true,
                    onChanged: (v) => notifier.setConfirmPassword(v),
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
                    date: _passwordExpiration,
                    onDateSelected: (v) => notifier.setPasswordExpiration(v),
                  ),
                ),
                Gap(16.w),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyCheckbox(
                        value: _isPasswordNeverExpires,
                        onChanged: (v) => notifier.setNeverExpire(v!),
                      ),
                      Gap(8.w),
                      Text(
                        'Never expires',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.isDark
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
              date: _accountExpiration,
              onDateSelected: (v) => notifier.setAccountExpiration(v),
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
                          date: _passwordExpiration,
                          onDateSelected: (v) =>
                              notifier.setPasswordExpiration(v),
                        ),
                      ),
                      Gap(16.w),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DigifyCheckbox(
                              value: _isPasswordNeverExpires,
                              onChanged: (v) => notifier.setNeverExpire(v!),
                            ),
                            Gap(8.w),
                            Text(
                              'Never expires',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: context.isDark
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
                    date: _accountExpiration,
                    onDateSelected: (v) => notifier.setAccountExpiration(v),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(
    BuildContext context,
    UserFormProvider notifier,
  ) {
    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(
        title: 'Contact Information',
        icon: Icon(Icons.email_outlined, color: AppColors.primary, size: 18.sp),
      ),
      child: Column(
        children: [
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _emailController,
              labelText: 'Email Address',
              hintText: 'user@digifyhr.com',
              isRequired: true,
              prefixIcon: Icon(Icons.email_outlined, size: 18),
              onChanged: (v) => notifier.setEmail(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _secondaryEmailController,
              labelText: 'Secondary Email',
              hintText: 'secondary@email.com',
              prefixIcon: Icon(Icons.email_outlined, size: 18),
              onChanged: (v) => notifier.setSecondaryEmail(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'user@digifyhr.com',
                    isRequired: true,
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                    onChanged: (v) => notifier.setEmail(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _secondaryEmailController,
                    labelText: 'Secondary Email',
                    hintText: 'secondary@email.com',
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                    onChanged: (v) => notifier.setSecondaryEmail(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _workPhoneController,
              labelText: 'Work Phone',
              hintText: '+965 XXXX XXXX',
              prefixIcon: Icon(Icons.phone_outlined, size: 18),
              onChanged: (v) => notifier.setWorkPhone(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _mobilePhoneController,
              labelText: 'Mobile Phone',
              hintText: '+965 XXXX XXXX',
              prefixIcon: Icon(Icons.phone_android_outlined, size: 18),
              onChanged: (v) => notifier.setMobilePhone(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _extensionController,
              labelText: 'Extension',
              hintText: 'Ext. 123',
              onChanged: (v) => notifier.setExtension(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _workPhoneController,
                    labelText: 'Work Phone',
                    hintText: '+965 XXXX XXXX',
                    prefixIcon: Icon(Icons.phone_outlined, size: 18),
                    onChanged: (v) => notifier.setWorkPhone(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _mobilePhoneController,
                    labelText: 'Mobile Phone',
                    hintText: '+965 XXXX XXXX',
                    prefixIcon: Icon(Icons.phone_android_outlined, size: 18),
                    onChanged: (v) => notifier.setMobilePhone(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _extensionController,
                    labelText: 'Extension',
                    hintText: 'Ext. 123',
                    onChanged: (v) => notifier.setExtension(v),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyTextField(
              controller: _officeLocationController,
              labelText: 'Office Location',
              hintText: 'Building, Floor, Room',
              prefixIcon: Icon(Icons.location_on_outlined, size: 18),
              onChanged: (v) => notifier.setOfficeLocation(v),
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _mailingAddressController,
              labelText: 'Mailing Address',
              hintText: 'Complete mailing address',
              onChanged: (v) => notifier.setMailingAddress(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _officeLocationController,
                    labelText: 'Office Location',
                    hintText: 'Building, Floor, Room',
                    prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                    onChanged: (v) => notifier.setOfficeLocation(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _mailingAddressController,
                    labelText: 'Mailing Address',
                    hintText: 'Complete mailing address',
                    onChanged: (v) => notifier.setMailingAddress(v),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmploymentInfoSection(
    BuildContext context,
    UserFormProvider notifier,
  ) {
    return UserFormSection(
      isDark: context.isDark,
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
              value: _department,
              items: const [],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setDepartment(v!),
              isRequired: true,
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Job Title',
              hint: 'Select Job Title',
              items: const [],
              value: _jobTitle,
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setJobTitle(v!),
              isRequired: true,
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Employee Type',
              value: _employeeType,
              items: const ['Full-Time', 'Part-Time', 'Contract'],
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setEmployeeType(v!),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Department',
                    hint: 'Select Department',
                    items: const [],
                    value: _department,
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setDepartment(v!),
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Job Title',
                    hint: 'Select Job Title',
                    items: const [],
                    value: _jobTitle,
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setJobTitle(v!),
                    isRequired: true,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Employee Type',
                    value: _employeeType,
                    items: const ['Full-Time', 'Part-Time', 'Contract'],
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setEmployeeType(v!),
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
              value: _reportToManager,
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setReportToManager(v!),
            ),
            Gap(16.h),
            DigifySelectField<String>(
              label: 'Work Location',
              hint: 'Select Location',
              items: const [],
              value: _workLocation,
              itemLabelBuilder: (item) => item,
              onChanged: (v) => notifier.setWorkLocation(v!),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Reports To (Manager)',
                    hint: 'Select Manager',
                    items: const [],
                    value: _reportToManager,
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setReportToManager(v!),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Work Location',
                    hint: 'Select Location',
                    items: const [],
                    value: _workLocation,
                    itemLabelBuilder: (item) => item,
                    onChanged: (v) => notifier.setWorkLocation(v!),
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
              date: _hireDate,
              onDateSelected: (v) => notifier.setHireDate(v),
            ),
            Gap(16.h),
            DateSelectionField(
              label: 'Start Date',
              hintText: 'dd/mm/yyyy',
              date: _startDate,
              onDateSelected: (v) => notifier.setStartDate(v),
            ),
            Gap(16.h),
            DateSelectionField(
              label: 'End Date',
              hintText: 'dd/mm/yyyy',
              date: _endDate,
              onDateSelected: (v) => notifier.setEndDate(v),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DateSelectionField(
                    label: 'Hire Date',
                    hintText: 'dd/mm/yyyy',
                    date: _hireDate,
                    onDateSelected: (v) => notifier.setHireDate(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DateSelectionField(
                    label: 'Start Date',
                    hintText: 'dd/mm/yyyy',
                    date: _startDate,
                    onDateSelected: (v) => notifier.setStartDate(v),
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DateSelectionField(
                    label: 'End Date',
                    hintText: 'dd/mm/yyyy',
                    date: _endDate,
                    onDateSelected: (v) => notifier.setEndDate(v),
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
