import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_load_more_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobFamilySelectionDialog extends ConsumerStatefulWidget {
  const JobFamilySelectionDialog({super.key, this.selectedJobFamily});

  final JobFamily? selectedJobFamily;

  static Future<JobFamily?> show(BuildContext context, {JobFamily? selectedJobFamily}) async {
    return showDialog<JobFamily>(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobFamilySelectionDialog(selectedJobFamily: selectedJobFamily),
    );
  }

  @override
  ConsumerState<JobFamilySelectionDialog> createState() => _JobFamilySelectionDialogState();
}

class _JobFamilySelectionDialogState extends ConsumerState<JobFamilySelectionDialog> {
  final ScrollController _scrollController = ScrollController();
  PaginationScrollListener? _paginationListener;

  @override
  void initState() {
    super.initState();
    _paginationListener = PaginationScrollListener(
      scrollController: _scrollController,
      threshold: 500.0,
      onLoadMore: () {
        ref.read(jobFamilyNotifierProvider.notifier).loadNextPage();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobFamilyNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobFamilyNotifierProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 550.w,
          height: 650.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrgUnitSelectionHeader(
                levelName: 'Job Family',
                onClose: () => context.pop<JobFamily?>(widget.selectedJobFamily),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(jobFamilyNotifierProvider.notifier).clearSearch();
                  } else {
                    ref.read(jobFamilyNotifierProvider.notifier).search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedJobFamily != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<JobFamily?>(null),
                    ),
                  ),
                ),
              Flexible(child: _buildContent(context, state)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _paginationListener?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    if (state.isLoading && state.items.isEmpty) {
      return Padding(padding: EdgeInsets.all(16.w), child: const OrgUnitSelectionSkeleton());
    }
    if (state.hasError && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load job families',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final items = state.items as List<JobFamily>;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No job families found',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final isLoadingMore = state.isLoadingMore == true;
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: items.length + (isLoadingMore ? 3 : 0),
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const OrgUnitLoadMoreSkeleton();
        }
        final jobFamily = items[index];
        return SelectionListItem(
          title: jobFamily.nameEnglish,
          subtitle: jobFamily.code,
          isSelected: widget.selectedJobFamily != null && widget.selectedJobFamily!.id == jobFamily.id,
          onTap: () => context.pop(jobFamily),
        );
      },
    );
  }
}
