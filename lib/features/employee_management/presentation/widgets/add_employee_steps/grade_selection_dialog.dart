import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_load_more_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeSelectionDialog extends ConsumerStatefulWidget {
  const GradeSelectionDialog({super.key, this.selectedGrade});

  final Grade? selectedGrade;

  static Future<Grade?> show(BuildContext context, {Grade? selectedGrade}) async {
    return showDialog<Grade>(
      context: context,
      barrierDismissible: false,
      builder: (context) => GradeSelectionDialog(selectedGrade: selectedGrade),
    );
  }

  @override
  ConsumerState<GradeSelectionDialog> createState() => _GradeSelectionDialogState();
}

class _GradeSelectionDialogState extends ConsumerState<GradeSelectionDialog> {
  final ScrollController _scrollController = ScrollController();
  PaginationScrollListener? _paginationListener;

  @override
  void initState() {
    super.initState();
    _paginationListener = PaginationScrollListener(
      scrollController: _scrollController,
      threshold: 500.0,
      onLoadMore: () {
        ref.read(gradeNotifierProvider.notifier).loadNextPage();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gradeNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gradeNotifierProvider);

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
                levelName: 'Grade',
                onClose: () => context.pop<Grade?>(widget.selectedGrade),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(gradeNotifierProvider.notifier).clearSearch();
                  } else {
                    ref.read(gradeNotifierProvider.notifier).search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedGrade != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<Grade?>(null),
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
            state.errorMessage ?? 'Failed to load grades',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final items = state.items as List<Grade>;
    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No grades found',
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
        final grade = items[index];
        return SelectionListItem(
          title: grade.gradeLabel,
          subtitle: grade.gradeCategoryLabel,
          isSelected: widget.selectedGrade != null && widget.selectedGrade!.id == grade.id,
          onTap: () => context.pop(grade),
        );
      },
    );
  }
}
