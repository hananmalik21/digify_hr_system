import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_org_selection_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrganizationalStructureModule extends ConsumerStatefulWidget {
  const OrganizationalStructureModule({super.key});

  @override
  ConsumerState<OrganizationalStructureModule> createState() => _OrganizationalStructureModuleState();
}

class _OrganizationalStructureModuleState extends ConsumerState<OrganizationalStructureModule> {
  int? _ensureLoadScheduledForEnterpriseId;

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final orgState = enterpriseId != null ? ref.watch(enterpriseOrgStructureNotifierProvider(enterpriseId)) : null;

    if (enterpriseId == null) {
      _ensureLoadScheduledForEnterpriseId = null;
      return _AssignmentCard(
        isDark: theme.isDark,
        child: _MessageContent(
          message: AppLocalizations.of(theme)!.organizationalStructure,
          isDark: theme.isDark,
          textTheme: theme.textTheme,
        ),
      );
    }

    _ensureOrgStructureLoaded(enterpriseId, orgState);

    if (orgState?.isLoading ?? true) {
      return _AssignmentCard(
        isDark: theme.isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModuleHeader(theme: theme),
            Gap(18.h),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLoadingIndicator(
                      type: LoadingType.circle,
                      color: theme.isDark ? AppColors.textSecondaryDark : AppColors.primary,
                      size: 32.r,
                    ),
                    Gap(12.h),
                    Text(
                      AppLocalizations.of(theme)!.pleaseWait,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (orgState?.error != null) {
      return _AssignmentCard(
        isDark: theme.isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModuleHeader(theme: theme),
            Gap(18.h),
            Text(
              orgState!.error!,
              style: TextStyle(color: AppColors.error, fontSize: 12.sp),
            ),
          ],
        ),
      );
    }

    final activeLevels = orgState?.orgStructure?.activeLevels ?? [];
    if (activeLevels.isEmpty) {
      return _AssignmentCard(
        isDark: theme.isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModuleHeader(theme: theme),
            Gap(18.h),
            _MessageContent(
              message: 'No organizational structure available for this enterprise.',
              isDark: theme.isDark,
              textTheme: theme.textTheme,
            ),
          ],
        ),
      );
    }

    final structureId = orgState!.orgStructure!.structureId;
    final selectionProvider = addEmployeeOrgSelectionProvider((structureId: structureId, levels: activeLevels));
    final selectionState = ref.watch(selectionProvider);
    final assignmentState = ref.watch(addEmployeeAssignmentProvider);
    final workLocation = assignmentState.workLocation;
    final orderedLevelCodes = activeLevels.map((l) => l.levelCode).toList();

    return _AssignmentCard(
      isDark: theme.isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModuleHeader(theme: theme),
          Gap(18.h),
          _OrgLevelsSection(
            activeLevels: activeLevels,
            selectionProvider: selectionProvider,
            selectionState: selectionState,
            assignmentState: assignmentState,
            orderedLevelCodes: orderedLevelCodes,
            getPreselectedUnitId: assignmentState.getSelectedUnitId,
            onSelectionChanged: (levelCode, unit) {
              if (unit != null) {
                ref
                    .read(addEmployeeAssignmentProvider.notifier)
                    .setSelection(levelCode, unit.orgUnitId, unit.orgUnitNameEn, orderedLevelCodes: orderedLevelCodes);
              }
            },
          ),
          Gap(24.h),
          _WorkLocationSection(
            theme: theme,
            initialValue: workLocation ?? '',
            onChanged: (value) => ref.read(addEmployeeAssignmentProvider.notifier).setWorkLocation(value),
          ),
        ],
      ),
    );
  }

  void _ensureOrgStructureLoaded(int enterpriseId, dynamic orgState) {
    if (orgState?.error != null) _ensureLoadScheduledForEnterpriseId = null;
    final needsLoad =
        orgState?.isLoading != true &&
        ((orgState?.allStructures.isEmpty ?? true) ||
            (orgState?.orgStructure == null && (orgState?.allStructures.isNotEmpty ?? false)));
    if (!needsLoad || _ensureLoadScheduledForEnterpriseId == enterpriseId) return;
    _ensureLoadScheduledForEnterpriseId = enterpriseId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId).notifier);
      final currentState = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId));
      if (currentState.isLoading) return;
      if (currentState.allStructures.isEmpty) {
        notifier.fetchOrgStructureByEnterpriseId(enterpriseId);
      } else if (currentState.orgStructure == null && currentState.allStructures.isNotEmpty) {
        notifier.selectStructure(currentState.allStructures.first.structureId);
      }
    });
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.isDark, required this.child});

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({required this.theme});

  final BuildContext theme;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.isDark;
    final l10n = AppLocalizations.of(theme)!;
    return Row(
      children: [
        DigifyAsset(
          assetPath: Assets.icons.locationHeaderIcon.path,
          width: 14,
          height: 14,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
        ),
        Gap(7.w),
        Text(
          l10n.organizationalStructure,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      ],
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({required this.message, required this.isDark, required this.textTheme});

  final String message;
  final bool isDark;
  final TextTheme? textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: textTheme?.titleSmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle),
    );
  }
}

class _WorkLocationSection extends StatelessWidget {
  const _WorkLocationSection({required this.theme, required this.initialValue, required this.onChanged});

  final BuildContext theme;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.isDark;
    final l10n = AppLocalizations.of(theme)!;
    final locationIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.locationPinIcon.path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    return DigifyTextField(
      labelText: l10n.workLocation,
      prefixIcon: locationIcon,
      hintText: l10n.hintWorkLocation,
      initialValue: initialValue,
      onChanged: onChanged,
      isRequired: true,
    );
  }
}

class _OrgLevelsSection extends StatelessWidget {
  const _OrgLevelsSection({
    required this.activeLevels,
    required this.selectionProvider,
    required this.selectionState,
    required this.assignmentState,
    required this.orderedLevelCodes,
    required this.getPreselectedUnitId,
    required this.onSelectionChanged,
  });

  final List<OrgStructureLevel> activeLevels;
  final dynamic selectionProvider;
  final EnterpriseSelectionState selectionState;
  final AddEmployeeAssignmentState assignmentState;
  final List<String> orderedLevelCodes;
  final String? Function(String levelCode) getPreselectedUnitId;
  final void Function(String levelCode, OrgUnit? unit) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...activeLevels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          final isEnabled = index == 0 || assignmentState.getSelectedUnitId(activeLevels[index - 1].levelCode) != null;
          return Padding(
            padding: EdgeInsets.only(bottom: index < activeLevels.length - 1 ? 16.h : 0),
            child: DigifyStyleOrgLevelField(
              level: level,
              selectionProvider: selectionProvider,
              isEnabled: isEnabled,
              displayLabel: assignmentState.getDisplayName(level.levelCode),
              preselectedUnitId: getPreselectedUnitId(level.levelCode),
              onSelectionChanged: onSelectionChanged,
            ),
          );
        }),
      ],
    );
  }
}
