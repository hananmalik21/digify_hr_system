import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_list_item.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_empty_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_error_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_header.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_skeleton.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/org_unit_load_more_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

class OrgUnitSelectionDialog extends ConsumerStatefulWidget {
  final OrgStructureLevel level;
  final dynamic selectionProvider;
  final String? preselectedUnitId;
  final void Function(OrgUnit unit)? onUnitSelected;

  const OrgUnitSelectionDialog({
    super.key,
    required this.level,
    required this.selectionProvider,
    this.preselectedUnitId,
    this.onUnitSelected,
  });

  static Future<bool> show({
    required BuildContext context,
    required OrgStructureLevel level,
    required dynamic selectionProvider,
    String? preselectedUnitId,
    void Function(OrgUnit unit)? onUnitSelected,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrgUnitSelectionDialog(
        level: level,
        selectionProvider: selectionProvider,
        preselectedUnitId: preselectedUnitId,
        onUnitSelected: onUnitSelected,
      ),
    );
    return result ?? false;
  }

  @override
  ConsumerState<OrgUnitSelectionDialog> createState() => _OrgUnitSelectionDialogState();
}

class _OrgUnitSelectionDialogState extends ConsumerState<OrgUnitSelectionDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _didApplyPreselection = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    final initialState = ref.read(widget.selectionProvider);
    final hasOptions = initialState.getOptions(widget.level.levelCode).isNotEmpty;
    final isLoading = initialState.isLoading(widget.level.levelCode);
    if (!hasOptions && !isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(widget.selectionProvider.notifier).loadOptionsForLevel(widget.level.levelCode);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(widget.selectionProvider.notifier).loadMoreOptionsForLevel(widget.level.levelCode);
    }
  }

  void _applyPreselectionIfNeeded(WidgetRef ref, List<OrgUnit> options) {
    final pid = widget.preselectedUnitId;
    if (pid == null || pid.isEmpty || _didApplyPreselection || options.isEmpty) return;
    OrgUnit? unit;
    for (final u in options) {
      if (u.orgUnitId == pid) {
        unit = u;
        break;
      }
    }
    if (unit == null) return;
    _didApplyPreselection = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(widget.selectionProvider.notifier).selectUnit(widget.level.levelCode, unit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(widget.selectionProvider);
    final options = selectionState.getOptions(widget.level.levelCode);
    final isLoading = selectionState.isLoading(widget.level.levelCode);
    final isFetchingMore = selectionState.isFetchingMore(widget.level.levelCode);
    final error = selectionState.getError(widget.level.levelCode);

    if (!isLoading && options.isNotEmpty) {
      _applyPreselectionIfNeeded(ref, options);
    }

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
                levelName: widget.level.levelName,
                onClose: () => context.pop(false),
                onSearchChanged: (value) {
                  ref.read(widget.selectionProvider.notifier).setSearchQuery(widget.level.levelCode, value);
                },
                initialSearchQuery: selectionState.getSearchQuery(widget.level.levelCode),
              ),
              Flexible(child: _buildContent(context, ref, options, isLoading, isFetchingMore, error)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<OrgUnit> options,
    bool isLoading,
    bool isFetchingMore,
    String? error,
  ) {
    if (isLoading) {
      return const OrgUnitSelectionSkeleton();
    }

    if (error != null) {
      return OrgUnitSelectionErrorState(
        error: error,
        onRetry: () {
          ref.read(widget.selectionProvider.notifier).loadOptionsForLevel(widget.level.levelCode);
        },
      );
    }

    if (options.isEmpty) {
      return const OrgUnitSelectionEmptyState(message: 'No options available');
    }

    return _buildOptionsList(context, ref, options, isFetchingMore);
  }

  Widget _buildOptionsList(BuildContext context, WidgetRef ref, List<OrgUnit> options, bool isFetchingMore) {
    final selectionState = ref.watch(widget.selectionProvider);
    final selectedUnit = selectionState.getSelection(widget.level.levelCode);

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: options.length + (isFetchingMore ? 3 : 0),
      separatorBuilder: (context, index) => Gap(8.h),
      itemBuilder: (context, index) {
        if (index >= options.length) {
          return const OrgUnitLoadMoreSkeleton();
        }
        final unit = options[index];
        final isSelected = selectedUnit?.orgUnitId == unit.orgUnitId;

        return OrgUnitListItem(
          unit: unit,
          isSelected: isSelected,
          onTap: () {
            ref.read(widget.selectionProvider.notifier).selectUnit(widget.level.levelCode, unit);
            widget.onUnitSelected?.call(unit);
            context.pop(true);
          },
        );
      },
    );
  }
}
