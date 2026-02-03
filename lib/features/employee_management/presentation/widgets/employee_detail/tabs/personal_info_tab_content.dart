import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonalInfoTabContent extends StatelessWidget {
  const PersonalInfoTabContent({super.key, required this.isDark, this.wrapInScrollView = true});

  final bool isDark;
  final bool wrapInScrollView;

  static const List<EmployeeDetailBorderedField> _personalInfoLeft = [
    EmployeeDetailBorderedField(label: 'First Name (English)', value: 'KHURAM'),
    EmployeeDetailBorderedField(label: 'Middle Name (English)', value: 'K P'),
    EmployeeDetailBorderedField(label: 'Last Name (English)', value: 'SHAHZAD'),
    EmployeeDetailBorderedField(label: 'Full Name (English)', value: 'KHURAM K P SHAHZAD'),
    EmployeeDetailBorderedField(label: 'First Name (Arabic)', value: 'khuram', isValueRtl: true),
    EmployeeDetailBorderedField(label: 'Middle Name (Arabic)', value: 'shahzad', isValueRtl: true),
    EmployeeDetailBorderedField(label: 'Last Name (Arabic)', value: 'saddf', isValueRtl: true),
    EmployeeDetailBorderedField(label: 'Full Name (Arabic)', value: 'khuram shahzad saddf', isValueRtl: true),
  ];

  static const List<EmployeeDetailBorderedField> _personalInfoRight = [
    EmployeeDetailBorderedField(label: 'Email Address', value: 'kh@gmail.com'),
    EmployeeDetailBorderedField(label: 'Phone Number', value: '888888'),
    EmployeeDetailBorderedField(label: 'Mobile Number', value: '8888'),
    EmployeeDetailBorderedField(label: 'Date of Birth', value: '02/09/1987'),
    EmployeeDetailBorderedField(label: 'Gender', value: 'Male'),
    EmployeeDetailBorderedField(label: 'Marital Status', value: 'Married'),
    EmployeeDetailBorderedField(label: 'Nationality', value: 'Pakistani'),
    EmployeeDetailBorderedField(label: 'Religion', value: 'Islam'),
  ];

  static const List<EmployeeDetailBorderedField> _identificationLeft = [
    EmployeeDetailBorderedField(label: 'Civil ID Number', value: '989987878'),
    EmployeeDetailBorderedField(label: 'Address in Kuwait', value: '—'),
  ];

  static const List<EmployeeDetailBorderedField> _identificationRight = [
    EmployeeDetailBorderedField(label: 'Passport Number', value: '8777898978'),
  ];

  static const List<EmployeeDetailBorderedField> _emergencyContactLeft = [
    EmployeeDetailBorderedField(label: 'Contact Name', value: 'cs'),
    EmployeeDetailBorderedField(label: 'Relationship', value: 'Other'),
  ];

  static const List<EmployeeDetailBorderedField> _emergencyContactRight = [
    EmployeeDetailBorderedField(label: 'Emergency Phone', value: '234234'),
    EmployeeDetailBorderedField(label: 'Emergency Email', value: 'kh@gmail.com'),
  ];

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmployeeDetailBorderedSectionCard(
            title: 'Personal Information',
            leftColumnFields: _personalInfoLeft,
            rightColumnFields: _personalInfoRight,
            isDark: isDark,
          ),
          Gap(24.h),
          EmployeeDetailBorderedSectionCard(
            title: 'Identification & Address',
            leftColumnFields: _identificationLeft,
            rightColumnFields: _identificationRight,
            isDark: isDark,
          ),
          Gap(24.h),
          EmployeeDetailBorderedSectionCard(
            title: 'Emergency Contact',
            titleIconAssetPath: Assets.icons.warningIcon.path,
            leftColumnFields: _emergencyContactLeft,
            rightColumnFields: _emergencyContactRight,
            isDark: isDark,
          ),
        ],
      ),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
