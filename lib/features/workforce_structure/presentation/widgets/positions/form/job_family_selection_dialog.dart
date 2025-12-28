import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/job_family_list_item.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilySelectionDialog extends ConsumerStatefulWidget {
  final JobFamily? selectedJobFamily;

  const JobFamilySelectionDialog({super.key, this.selectedJobFamily});

  static Future<JobFamily?> show({
    required BuildContext context,
    JobFamily? selectedJobFamily,
  }) async {
    return await showDialog<JobFamily>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          JobFamilySelectionDialog(selectedJobFamily: selectedJobFamily),
    );
  }

  @override
  ConsumerState<JobFamilySelectionDialog> createState() =>
      _JobFamilySelectionDialogState();
}

class _JobFamilySelectionDialogState
    extends ConsumerState<JobFamilySelectionDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(jobFamilyNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobFamiliesState = ref.watch(jobFamilyNotifierProvider);
    final items = jobFamiliesState.items;
    final isLoading = jobFamiliesState.isLoading;
    final errorMessage = jobFamiliesState.errorMessage;
    final isLoadingMore = jobFamiliesState.isLoadingMore;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 8,
      child: Container(
        width: 550.w,
        constraints: BoxConstraints(maxHeight: 650.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: _buildContent(
                context,
                items,
                isLoading,
                errorMessage,
                isLoadingMore,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.work_rounded,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Job Family',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Choose a job family from the list',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, size: 24.sp),
            padding: EdgeInsets.all(8.w),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<JobFamily> items,
    bool isLoading,
    String? error,
    bool isLoadingMore,
  ) {
    if (isLoading && items.isEmpty) {
      return const OrgUnitSelectionSkeleton();
    }

    if (error != null && items.isEmpty) {
      return OrgUnitSelectionErrorState(
        error: error,
        onRetry: () => ref.read(jobFamilyNotifierProvider.notifier).refresh(),
      );
    }

    if (items.isEmpty) {
      return const OrgUnitSelectionEmptyState(message: 'No Job Families found');
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }

        final jobFamily = items[index];
        final isSelected = widget.selectedJobFamily?.id == jobFamily.id;

        return JobFamilyListItem(
          jobFamily: jobFamily,
          isSelected: isSelected,
          onTap: () => Navigator.of(context).pop(jobFamily),
        );
      },
    );
  }
}
