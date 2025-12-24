import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pagination controls widget
class PaginationControlsWidget extends ConsumerWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final StructureListState state;
  final AutoDisposeStateNotifierProvider<
      StructureListNotifier,
      StructureListState> structureListProvider;

  const PaginationControlsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.state,
    required this.structureListProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagination = state.pagination;
    if (pagination == null) return const SizedBox.shrink();

    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          ElevatedButton(
            onPressed: pagination.hasPrevious && !state.isLoading
                ? () => ref.read(structureListProvider.notifier).loadPreviousPage()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.w : 24.w,
                vertical: 12.h,
              ),
            ),
            child: Text(
              'Previous',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),

          // Page info
          Text(
            'Page ${pagination.page} of ${pagination.totalPages}',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF101828),
            ),
          ),

          // Next button
          ElevatedButton(
            onPressed: pagination.hasNext && !state.isLoadingMore
                ? () => ref.read(structureListProvider.notifier).loadNextPage()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.w : 24.w,
                vertical: 12.h,
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

