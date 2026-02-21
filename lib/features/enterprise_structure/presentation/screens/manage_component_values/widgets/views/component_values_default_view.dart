import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_search_and_actions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_detail_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_table_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/create_component_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesDefaultView extends ConsumerWidget {
  const ComponentValuesDefaultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(componentValuesProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark =
        Theme.of(context).brightness ==
        Brightness
            .dark; // Assuming context.isDark is an extension, using Theme.of(context).brightness for a common approach.
    final orgStructuresState = ref.watch(orgStructuresDropdownProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentValuesSearchAndActions(
          isDark: isDark,
          searchHint: localizations.searchComponents,
          searchValue: state.searchQuery,
          onSearchChanged: (value) => ref.read(componentValuesProvider.notifier).searchComponents(value),
          addNewLabel: 'Add New',
          bulkUploadLabel: localizations.bulkUpload,
          exportLabel: localizations.export,
          onAddNew: () => CreateComponentDialog.show(context, defaultType: state.filterType),
          onBulkUpload: () => BulkUploadDialog.show(context),
          onExport: () {},
        ),
        Gap(24.h),
        ComponentTableView(
          isLoading: state.isLoading,
          components: state.filteredComponents,
          allComponents: state.components,
          filterType: state.filterType,
          orgStructures: orgStructuresState.structures,
          onView: (component) {
            ComponentDetailDialog.show(context, component: component, allComponents: state.components);
          },
          onEdit: (component) {
            CreateComponentDialog.show(context, initialValue: component);
          },
          onDelete: (component) {},
          onDuplicate: state.filterType == ComponentType.department ? (component) {} : null,
        ),
      ],
    );
  }
}
