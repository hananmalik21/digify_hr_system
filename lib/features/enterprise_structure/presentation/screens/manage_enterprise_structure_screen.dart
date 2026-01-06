import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/active_structure_card_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/header_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/stats_cards_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structures_list_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart' show Assets;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/manage_enterprise_structure_widgets/structure_configurations_header_widget.dart'
    show StructureConfigurationsHeaderWidget;

class ManageEnterpriseStructureScreen extends ConsumerStatefulWidget {
  const ManageEnterpriseStructureScreen({super.key});

  @override
  ConsumerState<ManageEnterpriseStructureScreen> createState() =>
      _ManageEnterpriseStructureScreenState();
}

class _ManageEnterpriseStructureScreenState
    extends ConsumerState<ManageEnterpriseStructureScreen> {
  /// Provider for structure list
  final structureListProvider =
      StateNotifierProvider.autoDispose<
        StructureListNotifier,
        StructureListState
      >((ref) {
        final getStructureListUseCase = ref.watch(
          getStructureListUseCaseProvider,
        );
        return StructureListNotifier(
          getStructureListUseCase: getStructureListUseCase,
        );
      });
  final saveEnterpriseStructureProvider =
      StateNotifierProvider.autoDispose<
        SaveEnterpriseStructureNotifier,
        SaveEnterpriseStructureState
      >((ref) {
        final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
        return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
      });

  @override
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final isMobile = ResponsiveHelper.isMobile(context);

    final listState = ref.watch(structureListProvider);
    final isRefreshing = listState.isLoading && listState.structures.isNotEmpty;

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: EdgeInsetsDirectional.only(
                  top: 16.h,
                  start: 16.w,
                  end: 16.w,
                  bottom: 16.h,
                ),
                tablet: EdgeInsetsDirectional.only(
                  top: 24.h,
                  start: 24.w,
                  end: 24.w,
                  bottom: 24.h,
                ),
                web: EdgeInsetsDirectional.only(
                  top: 24.h,
                  start: 24.w,
                  end: 24.w,
                  bottom: 24.h,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    title: localizations.manageEnterpriseStructure,
                    icon: Assets.icons.manageEnterpriseIcon.path,
                    localizations: localizations,
                  ),
                  // SizedBox(height: isMobile ? 16.h : 24.h),

                  // ActiveStructureCardWidget(
                  //   localizations: localizations,
                  //   isDark: isDark,
                  // ),
                  SizedBox(height: isMobile ? 16.h : 24.h),

                  StatsCardsWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                  ),
                  SizedBox(height: isMobile ? 16.h : 24.h),

                  StructureConfigurationsHeaderWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                  ),
                  SizedBox(height: isMobile ? 12.h : 16.h),

                  StructuresListWidget(
                    localizations: localizations,
                    isDark: isDark,
                    structureListProvider: structureListProvider,
                    saveEnterpriseStructureProvider:
                        saveEnterpriseStructureProvider,
                  ),
                ],
              ),
            ),

            // ✅ Loading overlay
            if (isRefreshing)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: isDark ? Colors.black : Colors.white,
                    child: Center(
                      child: const AppLoadingIndicator(
                        type: LoadingType.fadingCircle,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
