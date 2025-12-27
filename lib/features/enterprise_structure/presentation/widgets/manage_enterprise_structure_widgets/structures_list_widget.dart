import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/structure_card_shimmer.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/pagination_controls_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/structure_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Structures list widget
class StructuresListWidget extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final AutoDisposeStateNotifierProvider<
      StructureListNotifier,
      StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<
      SaveEnterpriseStructureNotifier,
      SaveEnterpriseStructureState> saveEnterpriseStructureProvider;

  const StructuresListWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(structureListProvider);

    if (listState.isLoading && listState.structures.isEmpty) {
      return Column(
        children: List.generate(
          3, // Show 3 shimmer cards
          (index) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: 16.h),
            child: const StructureCardShimmer(),
          ),
        ),
      );
    }

    if (listState.hasError && listState.structures.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(
              listState.errorMessage ?? 'Failed to load structures',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () =>
                  ref.read(structureListProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (listState.structures.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            'No structures found',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A5565),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...listState.structures.map((structure) {
          final activeLevels = structure.levels
              .where((l) => l.isActive)
              .toList();
          final levelNames = activeLevels.map((l) => l.levelName).toList();

          final dateFormat = DateFormat('yyyy-MM-dd');
          final createdDate = dateFormat.format(structure.createdDate);
          final modifiedDate = structure.lastUpdatedDate != null
              ? dateFormat.format(structure.lastUpdatedDate!)
              : createdDate;

          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 16.h),
            child: StructureCardWidget(
              context: context,
              localizations: localizations,
              isDark: isDark,
              title: structure.structureName,
              description: structure.description,
              isActive: structure.isActive,
              levels: levelNames,
              levelCount: activeLevels.length,
              components: 0,
              // TODO: Get from API if available
              employees: 0,
              // TODO: Get from API if available
              created: createdDate,
              modified: modifiedDate,
              showInfoMessage: structure.isActive,
              structureLevels: structure.levels,
              enterpriseId: structure.enterpriseId,
              structureId: structure.structureId,
              structureListProvider: structureListProvider,
              saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
            ),
          );
        }),

        // Pagination controls
        if (listState.pagination != null) ...[
          SizedBox(height: 24.h),
          PaginationControlsWidget(
            localizations: localizations,
            isDark: isDark,
            state: listState,
            structureListProvider: structureListProvider,
          ),
        ],

        // Loading more indicator
        if (listState.isLoadingMore)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
      ],
    );
  }
}

