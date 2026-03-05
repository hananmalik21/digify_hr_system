import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_stats_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/dialogs/enterprise_structure_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/stats_cards_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/structures_list_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ManageEnterpriseStructureScreen extends ConsumerWidget {
  const ManageEnterpriseStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 47.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: localizations.manageEnterpriseStructure,
              description: localizations.manageDifferentConfigurations,
              trailing: AppButton.primary(
                label: localizations.createNewStructure,
                svgPath: Assets.icons.createNewStructureIcon.path,
                onPressed: () async {
                  final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);
                  if (enterpriseId == null) {
                    ToastService.warning(context, localizations.selectEnterpriseFirst);
                    return;
                  }
                  final result = await EnterpriseStructureDialog.showCreate(
                    context,
                    provider: manageEnterpriseStructureStructureListProvider,
                  );
                  if (result == true) {
                    ref.read(manageEnterpriseStructureStructureListProvider.notifier).refresh();
                    ref.read(enterpriseStatsNotifierProvider.notifier).refresh();
                  }
                },
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: ref.watch(manageEnterpriseStructureEnterpriseIdProvider),
              onEnterpriseChanged: (id) =>
                  ref.read(manageEnterpriseStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
              subtitle: ref.watch(manageEnterpriseStructureEnterpriseIdProvider) != null
                  ? 'Viewing data for selected enterprise'
                  : 'Select an enterprise to view data',
            ),
            Gap(24.h),
            StatsCardsWidget(localizations: localizations, isDark: isDark),
            Gap(16.h),
            StructuresListWidget(
              localizations: localizations,
              isDark: isDark,
              structureListProvider: manageEnterpriseStructureStructureListProvider,
              saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
            ),
          ],
        ),
      ),
    );
  }
}
