import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/policy_configuration/eligibility/radio_group_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GenderReligionMaritalSubsection extends ConsumerWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;
  final bool isEditing;

  const GenderReligionMaritalSubsection({
    super.key,
    required this.eligibility,
    required this.isDark,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genderValues = ref.watch(absLookupValuesForCodeProvider(AbsLookupCode.gender));
    final religionValues = ref.watch(absLookupValuesForCodeProvider(AbsLookupCode.religionCode));
    final maritalValues = ref.watch(absLookupValuesForCodeProvider(AbsLookupCode.maritalStatus));
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    final genderOptions = ['All', ...genderValues.map((v) => v.lookupValueName)];
    final religionOptions = ['All', ...religionValues.map((v) => v.lookupValueName)];
    final maritalOptions = ['All', ...maritalValues.map((v) => v.lookupValueName)];

    final genderSelected = _selectedName(eligibility.genderCode, genderValues, true);
    final religionSelected = _selectedName(eligibility.religionCode, religionValues, true);
    final maritalSelected = _selectedName(eligibility.maritalStatusCode, maritalValues, true);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final gender = RadioGroupCard(
          title: 'Gender',
          iconPath: Assets.icons.employeesBlueIcon.path,
          options: genderOptions,
          selectedValue: genderSelected,
          isDark: isDark,
          onChanged: isEditing ? (name) => draftNotifier.updateGenderCode(_codeForName(name, genderValues)) : null,
        );
        final religion = RadioGroupCard(
          title: 'Religion',
          iconPath: Assets.icons.leaveManagement.globe.path,
          options: religionOptions,
          selectedValue: religionSelected,
          isDark: isDark,
          onChanged: isEditing ? (name) => draftNotifier.updateReligionCode(_codeForName(name, religionValues)) : null,
        );
        final marital = RadioGroupCard(
          title: 'Marital Status',
          iconPath: Assets.icons.leaveManagement.martialStatus.path,
          options: maritalOptions,
          selectedValue: maritalSelected,
          isDark: isDark,
          onChanged: isEditing
              ? (name) => draftNotifier.updateMaritalStatusCode(_codeForName(name, maritalValues))
              : null,
        );
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [gender, Gap(14.h), religion, Gap(14.h), marital],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: gender),
            Gap(14.w),
            Expanded(child: religion),
            Gap(14.w),
            Expanded(child: marital),
          ],
        );
      },
    );
  }

  String? _selectedName(String? code, List<AbsLookupValue> values, bool addAll) {
    if (code == null || code.isEmpty) return addAll ? 'All' : null;
    for (final v in values) {
      if (v.lookupValueCode == code) return v.lookupValueName;
    }
    return addAll ? 'All' : null;
  }

  static String? _codeForName(String? name, List<AbsLookupValue> values) {
    if (name == null || name.isEmpty || name == 'All') return null;
    final v = values.where((e) => e.lookupValueName == name).firstOrNull;
    return v?.lookupValueCode;
  }
}
