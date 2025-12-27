import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/custom_text_field.dart';
import 'package:digify_hr_system/core/widgets/forms/filter_pill_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Search and filter bar for component values
class ComponentSearchBar extends ConsumerStatefulWidget {
  const ComponentSearchBar({super.key});

  @override
  ConsumerState<ComponentSearchBar> createState() => _ComponentSearchBarState();
}

class _ComponentSearchBarState extends ConsumerState<ComponentSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(componentValuesProvider);

    // Component type filter options
    final typeOptions = [
      localizations.allTypes,
      localizations.company,
      localizations.division,
      localizations.businessUnit,
      localizations.department,
      localizations.section,
    ];

    String getCurrentTypeFilter() {
      if (state.filterType == null) return localizations.allTypes;
      switch (state.filterType!) {
        case ComponentType.company:
          return localizations.company;
        case ComponentType.division:
          return localizations.division;
        case ComponentType.businessUnit:
          return localizations.businessUnit;
        case ComponentType.department:
          return localizations.department;
        case ComponentType.section:
          return localizations.section;
      }
    }

    ComponentType? getTypeFromString(String value) {
      if (value == localizations.allTypes) return null;
      if (value == localizations.company) return ComponentType.company;
      if (value == localizations.division) return ComponentType.division;
      if (value == localizations.businessUnit)
        return ComponentType.businessUnit;
      if (value == localizations.department) return ComponentType.department;
      if (value == localizations.section) return ComponentType.section;
      return null;
    }

    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search input
          Expanded(
            child: CustomTextField(
              controller: _searchController,
              hintText: localizations.searchComponents,
              height: 39.h,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              prefixIcon: const Icon(Icons.search, size: 16),
              onChanged: (value) {
                ref
                    .read(componentValuesProvider.notifier)
                    .searchComponents(value);
              },
            ),
          ),
          SizedBox(width: 12.w),
          // Type filter
          FilterPillDropdown(
            value: getCurrentTypeFilter(),
            items: typeOptions,
            isDark: isDark,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(componentValuesProvider.notifier)
                    .filterByType(getTypeFromString(value));
              }
            },
          ),
          SizedBox(width: 12.w),
          // Tree view toggle
          GestureDetector(
            onTap: () {
              ref.read(componentValuesProvider.notifier).toggleTreeView();
            },
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 9.h,
              ),
              decoration: BoxDecoration(
                color: state.isTreeView
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.cardBackgroundGreyDark
                          : AppColors.grayBg),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: state.isTreeView
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.inputBorderDark
                            : AppColors.inputBorder),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.isTreeView ? Icons.view_list : Icons.account_tree,
                    size: 18.sp,
                    color: state.isTreeView
                        ? Colors.white
                        : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    state.isTreeView
                        ? localizations.listView
                        : localizations.treeView,
                    style: TextStyle(
                      fontSize: 13.7.sp,
                      fontWeight: FontWeight.w400,
                      color: state.isTreeView
                          ? Colors.white
                          : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary),
                      height: 20 / 13.7,
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
}
