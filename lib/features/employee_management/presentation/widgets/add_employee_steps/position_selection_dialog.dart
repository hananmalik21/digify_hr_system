import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_load_more_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionSelectionDialog extends ConsumerStatefulWidget {
  const PositionSelectionDialog({super.key, required this.enterpriseId, this.selectedPosition});

  final int enterpriseId;
  final Position? selectedPosition;

  static Future<Position?> show(BuildContext context, {required int enterpriseId, Position? selectedPosition}) async {
    return showDialog<Position>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PositionSelectionDialog(enterpriseId: enterpriseId, selectedPosition: selectedPosition),
    );
  }

  @override
  ConsumerState<PositionSelectionDialog> createState() => _PositionSelectionDialogState();
}

class _PositionSelectionDialogState extends ConsumerState<PositionSelectionDialog> {
  final ScrollController _scrollController = ScrollController();
  PaginationScrollListener? _paginationListener;

  @override
  void initState() {
    super.initState();
    _paginationListener = PaginationScrollListener(
      scrollController: _scrollController,
      threshold: 500.0,
      onLoadMore: () {
        ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier).loadNextPage();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeePositionNotifierProvider(widget.enterpriseId));

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
                levelName: 'Position',
                onClose: () => context.pop<Position?>(widget.selectedPosition),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier).clearSearch();
                  } else {
                    ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier).search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              if (widget.selectedPosition != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w, top: 8.h, bottom: 4.h),
                    child: AppButton.outline(
                      label: 'Clear selection',
                      height: 32,
                      onPressed: () => context.pop<Position?>(null),
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
      return const OrgUnitSelectionSkeleton();
    }
    if (state.hasError && state.items.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load positions',
            style: TextStyle(fontSize: 14.sp, color: AppColors.error),
          ),
        ),
      );
    }
    final positions = state.items as List<Position>;
    if (positions.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            'No positions found',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      );
    }
    final isLoadingMore = state.isLoadingMore == true;
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: positions.length + (isLoadingMore ? 3 : 0),
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index >= positions.length) {
          return const OrgUnitLoadMoreSkeleton();
        }
        final position = positions[index];
        return SelectionListItem(
          title: position.titleEnglish,
          subtitle: position.code,
          isSelected: widget.selectedPosition != null && widget.selectedPosition!.id == position.id,
          onTap: () => context.pop(position),
        );
      },
    );
  }
}
