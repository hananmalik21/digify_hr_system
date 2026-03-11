import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelSelectionDialog extends ConsumerStatefulWidget {
  const JobLevelSelectionDialog({super.key, this.selectedJobLevel});

  final JobLevel? selectedJobLevel;

  static Future<JobLevel?> show(BuildContext context, {JobLevel? selectedJobLevel}) async {
    return showDialog<JobLevel>(
      context: context,
      barrierDismissible: false,
      builder: (context) => JobLevelSelectionDialog(selectedJobLevel: selectedJobLevel),
    );
  }

  @override
  ConsumerState<JobLevelSelectionDialog> createState() => _JobLevelSelectionDialogState();
}

class _JobLevelSelectionDialogState extends ConsumerState<JobLevelSelectionDialog>
    with ScrollPaginationMixin<JobLevelSelectionDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  ScrollController get scrollController => _scrollController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobLevelNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobLevelNotifierProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 550.w,
          constraints: BoxConstraints(maxHeight: 650.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrgUnitSelectionHeader(
                levelName: 'Job Level',
                onClose: () => context.pop<JobLevel?>(widget.selectedJobLevel),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(jobLevelNotifierProvider.notifier).clearSearch();
                  } else {
                    ref.read(jobLevelNotifierProvider.notifier).search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedJobLevel != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<JobLevel?>(null),
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onLoadMore() {
    ref.read(jobLevelNotifierProvider.notifier).loadNextPage();
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    if (state.isLoading && state.items.isEmpty) {
      return const OrgUnitSelectionSkeleton();
    }
    if (state.hasError && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load job levels',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final items = state.items as List<JobLevel>;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No job levels found',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final isLoadingMore = state.isLoadingMore == true;
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const OrgUnitSelectionSkeleton();
        }
        final jobLevel = items[index];
        return SelectionListItem(
          title: jobLevel.nameEn,
          subtitle: jobLevel.code,
          isSelected: widget.selectedJobLevel != null && widget.selectedJobLevel!.id == jobLevel.id,
          onTap: () => context.pop(jobLevel),
        );
      },
    );
  }
}
