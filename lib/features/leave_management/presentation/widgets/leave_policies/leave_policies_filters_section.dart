import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeavePoliciesFiltersSection extends StatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const LeavePoliciesFiltersSection({super.key, required this.localizations, required this.isDark});

  @override
  State<LeavePoliciesFiltersSection> createState() => _LeavePoliciesFiltersSectionState();
}

class _LeavePoliciesFiltersSectionState extends State<LeavePoliciesFiltersSection> {
  late TextEditingController _searchController;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaveTypes = [
      widget.localizations.annualLeave,
      widget.localizations.sickLeave,
      widget.localizations.maternityLeave,
      widget.localizations.hajjLeave,
      widget.localizations.compassionateLeave,
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: DigifyTextField.search(
              controller: _searchController,
              hintText: 'Search policies...',
              onChanged: (value) {
                // Handle search
              },
            ),
          ),
          Gap(12.w),
          SizedBox(
            width: 144.w,
            child: DigifySelectField<String?>(
              label: '',
              hint: 'All Types',
              value: _selectedType,
              items: [null, ...leaveTypes],
              itemLabelBuilder: (type) => type ?? 'All Types',
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
