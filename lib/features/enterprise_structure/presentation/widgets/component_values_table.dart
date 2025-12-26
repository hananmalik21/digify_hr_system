import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/action_button_group.dart';
import 'package:digify_hr_system/core/widgets/component_type_badge.dart';
import 'package:digify_hr_system/core/widgets/custom_status_cell.dart';
import 'package:digify_hr_system/core/widgets/custom_table.dart';
import 'package:digify_hr_system/core/widgets/empty_state_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Wrapper around CustomTable with component-specific columns and row rendering
class ComponentValuesTable extends ConsumerWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ComponentValuesTable({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  ComponentType _getComponentType(ComponentType type) {
    switch (type) {
      case ComponentType.company:
        return ComponentType.company;
      case ComponentType.division:
        return ComponentType.division;
      case ComponentType.businessUnit:
        return ComponentType.businessUnit;
      case ComponentType.department:
        return ComponentType.department;
      case ComponentType.section:
        return ComponentType.section;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(componentValuesProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final columns = [
      TableColumn(
        key: 'code',
        label: localizations.componentCode,
        sortable: true,
        width: 120.w,
      ),
      TableColumn(
        key: 'name',
        label: localizations.componentName,
        sortable: true,
        width: 180.w,
      ),
      TableColumn(
        key: 'arabicName',
        label: localizations.arabicName,
        width: 180.w,
      ),
      TableColumn(
        key: 'type',
        label: localizations.componentType,
        width: 150.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          return ComponentTypeBadge(
            type: _getComponentType(component.type),
          );
        },
      ),
      TableColumn(
        key: 'parent',
        label: localizations.parentComponent,
        width: 150.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          if (component.parentId == null) {
            return Text(
              '-',
              style: TextStyle(
                fontSize: 13.7.sp,
                color: isDark
                    ? AppColors.textPlaceholderDark
                    : AppColors.textPlaceholder,
              ),
            );
          }

          return Text(
            component.parentId ?? '-',
            style: TextStyle(
              fontSize: 13.7.sp,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          );
        },
      ),
      TableColumn(
        key: 'manager',
        label: localizations.manager,
        width: 150.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          if (component.managerId == null) {
            return Text(
              '-',
              style: TextStyle(
                fontSize: 13.7.sp,
                color: isDark
                    ? AppColors.textPlaceholderDark
                    : AppColors.textPlaceholder,
              ),
            );
          }

          return Text(
            component.managerId ?? '-',
            style: TextStyle(
              fontSize: 13.7.sp,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          );
        },
      ),
      TableColumn(
        key: 'location',
        label: localizations.location,
        width: 150.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          return Text(
            component.location ?? '-',
            style: TextStyle(
              fontSize: 13.7.sp,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          );
        },
      ),
      TableColumn(
        key: 'status',
        label: localizations.status,
        width: 100.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          return CustomStatusCell(
            isActive: component.status,
            activeLabel: localizations.active,
            inactiveLabel: localizations.inactive,
          );
        },
      ),
      TableColumn(
        key: 'lastUpdated',
        label: localizations.lastUpdated,
        width: 150.w,
        cellBuilder: (value, rowData) {
          final component = rowData['component'] as ComponentValue;
          final formatter = DateFormat('MMM dd, yyyy');
          return Text(
            formatter.format(component.updatedAt),
            style: TextStyle(
              fontSize: 13.7.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          );
        },
      ),
      TableColumn(
        key: 'actions',
        label: localizations.actions,
        width: 120.w,
        cellBuilder: (value, rowData) {
          return ActionButtonGroup(
            onView: onView != null
                ? () {

                    onView!();
                  }
                : null,
            onEdit: onEdit != null
                ? () {

                    onEdit!();
                  }
                : null,
            onDelete: onDelete != null
                ? () {

                    onDelete!();
                  }
                : null,
          );
        },
      ),
    ];

    final tableData = state.filteredComponents.map((component) {
      return {
        'code': component.code,
        'name': component.name,
        'arabicName': component.arabicName,
        'type': component.type,
        'parent': component.parentId,
        'manager': component.managerId,
        'location': component.location,
        'status': component.status,
        'lastUpdated': component.updatedAt,
        'actions': '',
        'component': component,
      };
    }).toList();

    return CustomTable(
      columns: columns,
      data: tableData,
      sortColumn: state.sortColumn,
      sortAscending: state.sortAscending,
      onSort: (column) {
        ref.read(componentValuesProvider.notifier).sortByColumn(column);
      },
      isLoading: state.isLoading,
      emptyStateWidget: EmptyStateWidget(
        icon: Icons.business_outlined,
        title: localizations.noComponentsFound,
        message: localizations.tryAdjustingSearchCriteria,
        actionLabel: localizations.addNewComponent,
        onAction: () {

        },
      ),
    );
  }
}

