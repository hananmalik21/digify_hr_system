import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesPagination extends ConsumerWidget {
  const ComponentValuesPagination({
    super.key,
    required this.levelCode,
    required this.orgUnitsState,
    required this.isDark,
  });

  final String levelCode;
  final OrgUnitsState orgUnitsState;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orgUnitsProvider(levelCode).notifier);
    final currentPage = orgUnitsState.currentPage;
    final totalPages = orgUnitsState.totalPages;

    List<int> getPageNumbers() {
      if (totalPages <= 7) {
        return List.generate(totalPages, (index) => index + 1);
      }
      if (currentPage <= 3) {
        return [1, 2, 3, 4, 5];
      }
      if (currentPage >= totalPages - 2) {
        return [totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
      }
      return [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2];
    }

    final pageNumbers = getPageNumbers();
    final showFirstEllipsis = totalPages > 7 && currentPage > 4;
    final showLastEllipsis = totalPages > 7 && currentPage < totalPages - 3;

    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(
            _pageInfoText(orgUnitsState),
            style: TextStyle(fontSize: 13.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (totalPages > 7 && currentPage > 4)
                _PageButton(isDark: isDark, page: 1, currentPage: currentPage, onTap: () => notifier.goToPage(1)),
              if (totalPages > 7 && currentPage > 4) Gap(4.w),
              if (showFirstEllipsis) _Ellipsis(isDark: isDark),
              if (showFirstEllipsis) Gap(4.w),
              _PrevNextButton(
                isDark: isDark,
                isPrev: true,
                orgUnitsState: orgUnitsState,
                onTap: () => notifier.previousPage(),
              ),
              Gap(4.w),
              ...pageNumbers.map(
                (page) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: _PageButton(
                    isDark: isDark,
                    page: page,
                    currentPage: currentPage,
                    onTap: () => notifier.goToPage(page),
                  ),
                ),
              ),
              Gap(4.w),
              _PrevNextButton(
                isDark: isDark,
                isPrev: false,
                orgUnitsState: orgUnitsState,
                onTap: () => notifier.nextPage(),
              ),
              if (showLastEllipsis) Gap(4.w),
              if (showLastEllipsis) _Ellipsis(isDark: isDark),
              if (showLastEllipsis) Gap(4.w),
              if (totalPages > 7 && currentPage < totalPages - 3) Gap(4.w),
              if (totalPages > 7 && currentPage < totalPages - 3)
                _PageButton(
                  isDark: isDark,
                  page: totalPages,
                  currentPage: currentPage,
                  onTap: () => notifier.goToPage(totalPages),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _pageInfoText(OrgUnitsState s) {
    final start = ((s.currentPage - 1) * s.pageSize) + 1;
    final end = s.currentPage * s.pageSize > s.totalItems ? s.totalItems : s.currentPage * s.pageSize;
    return 'Showing $start - $end of ${s.totalItems} items';
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.isDark, required this.page, required this.currentPage, required this.onTap});

  final bool isDark;
  final int page;
  final int currentPage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = page == currentPage;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
            borderRadius: BorderRadius.circular(6.r),
            border: isActive
                ? null
                : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        '...',
        style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
      ),
    );
  }
}

class _PrevNextButton extends StatelessWidget {
  const _PrevNextButton({required this.isDark, required this.isPrev, required this.orgUnitsState, required this.onTap});

  final bool isDark;
  final bool isPrev;
  final OrgUnitsState orgUnitsState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = isPrev
        ? orgUnitsState.hasPreviousPage && !orgUnitsState.isLoading
        : orgUnitsState.hasNextPage && !orgUnitsState.isLoading;
    final isLoading = isPrev
        ? orgUnitsState.isLoading && orgUnitsState.currentPage > 1
        : orgUnitsState.isLoading && orgUnitsState.currentPage < orgUnitsState.totalPages;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: AppLoadingIndicator(
                    type: LoadingType.fadingCircle,
                    size: 16.r,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                )
              : Icon(
                  isPrev ? Icons.chevron_left : Icons.chevron_right,
                  size: 18.sp,
                  color: enabled
                      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                      : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                ),
        ),
      ),
    );
  }
}
