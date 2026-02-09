import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_details_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_positions_table.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_search_and_actions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionsTab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;

  const PositionsTab({super.key, this.scrollController});

  @override
  ConsumerState<PositionsTab> createState() => _PositionsTabState();
}

class _PositionsTabState extends ConsumerState<PositionsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(positionNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final positionState = ref.watch(positionNotifierProvider);

    final paginationInfo = (positionState.totalPages > 0 || positionState.items.isNotEmpty)
        ? PaginationInfo(
            currentPage: positionState.currentPage,
            totalPages: positionState.totalPages,
            totalItems: positionState.totalItems,
            pageSize: positionState.pageSize,
            hasNext: positionState.hasNextPage,
            hasPrevious: positionState.hasPreviousPage,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        WorkforceSearchAndActions(localizations: localizations, isDark: isDark),
        Gap(16.h),
        if (positionState.hasError && positionState.items.isEmpty && !positionState.isLoading)
          DigifyErrorState(
            message: positionState.errorMessage ?? localizations.somethingWentWrong,
            retryLabel: localizations.retry,
            onRetry: () => ref.read(positionNotifierProvider.notifier).refresh(),
          )
        else
          Expanded(
            child: WorkforcePositionsTable(
              localizations: localizations,
              positions: positionState.items,
              isDark: isDark,
              isLoading: positionState.isLoading,
              paginationInfo: paginationInfo,
              currentPage: positionState.currentPage,
              pageSize: positionState.pageSize,
              onPrevious: paginationInfo != null && positionState.hasPreviousPage
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage - 1)
                  : null,
              onNext: paginationInfo != null && positionState.hasNextPage
                  ? () => ref.read(positionNotifierProvider.notifier).goToPage(positionState.currentPage + 1)
                  : null,
              onView: (position) => _showPositionDetailsDialog(context, position),
              onEdit: (position) => _showPositionFormDialog(context, position, true),
              onDelete: (position) => _showDeleteConfirmation(position),
              paginationIsLoading: false,
            ),
          ),
      ],
    );
  }

  void _showPositionDetailsDialog(BuildContext context, Position position) {
    showDialog(
      context: context,
      builder: (context) => PositionDetailsDialog(position: position),
    );
  }

  void _showPositionFormDialog(BuildContext context, Position position, bool isEdit) {
    PositionFormDialog.show(context, position: position, isEdit: isEdit);
  }

  Future<void> _showDeleteConfirmation(Position position) async {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context)!;
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.delete,
      message: 'Are you sure you want to delete this position? This action cannot be undone.',
      itemName: position.titleEnglish,
      confirmLabel: localizations.delete,
      cancelLabel: localizations.cancel,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(positionNotifierProvider.notifier).deletePosition(position.id);
      if (!mounted) return;
      ToastService.success(context, 'Position deleted successfully', title: 'Deleted');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to delete position: ${e.toString()}', title: 'Error');
    }
  }
}
