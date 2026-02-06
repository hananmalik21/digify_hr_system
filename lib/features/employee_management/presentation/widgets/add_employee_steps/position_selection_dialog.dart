import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionSelectionDialog extends ConsumerStatefulWidget {
  const PositionSelectionDialog({super.key});

  static Future<Position?> show(BuildContext context) async {
    return showDialog<Position>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PositionSelectionDialog(),
    );
  }

  @override
  ConsumerState<PositionSelectionDialog> createState() => _PositionSelectionDialogState();
}

class _PositionSelectionDialogState extends ConsumerState<PositionSelectionDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(positionNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(positionNotifierProvider);

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
                levelName: 'Position',
                onClose: () => context.pop(),
                onSearchChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(positionNotifierProvider.notifier).clearSearch();
                  } else {
                    ref.read(positionNotifierProvider.notifier).search(value);
                  }
                },
                initialSearchQuery: state.searchQuery ?? '',
              ),
              Flexible(child: _buildContent(context, state)),
            ],
          ),
        ),
      ),
    );
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
    final positions = state.items;
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
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: positions.length,
      separatorBuilder: (_, __) => Gap(8.h),
      itemBuilder: (context, index) {
        final position = positions[index];
        return SelectionListItem(
          title: position.titleEnglish,
          subtitle: position.code,
          isSelected: false,
          onTap: () => context.pop(position),
        );
      },
    );
  }
}
