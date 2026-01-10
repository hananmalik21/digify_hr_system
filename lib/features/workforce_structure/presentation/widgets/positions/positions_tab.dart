import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/digify_error_state.dart';
import 'package:digify_hr_system/core/mixins/scroll_pagination_mixin.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/delete_position_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_details_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_positions_table.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_search_and_actions.dart';
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

class _PositionsTabState extends ConsumerState<PositionsTab> with ScrollPaginationMixin {
  @override
  ScrollController? get scrollController => widget.scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(positionNotifierProvider.notifier).loadFirstPage();
    });
  }

  @override
  void onLoadMore() {
    final state = ref.read(positionNotifierProvider);
    if (state.hasNextPage && !state.isLoadingMore) {
      ref.read(positionNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final positionState = ref.watch(positionNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkforceSearchAndActions(
          localizations: localizations,
          isDark: isDark,
          onAddPosition: () => _showPositionFormDialog(context, Position.empty(), false),
        ),
        Gap(24.h),
        if (positionState.hasError && positionState.items.isEmpty && !positionState.isLoading)
          DigifyErrorState(
            message: positionState.errorMessage ?? localizations.somethingWentWrong,
            retryLabel: localizations.retry,
            onRetry: () => ref.read(positionNotifierProvider.notifier).refresh(),
          )
        else
          WorkforcePositionsTable(
            localizations: localizations,
            positions: positionState.items,
            isDark: isDark,
            isLoading: positionState.isLoading,
            onView: (position) => _showPositionDetailsDialog(context, position),
            onEdit: (position) => _showPositionFormDialog(context, position, true),
            onDelete: (position) => DeletePositionDialog.show(context, position: position),
          ),

        if (positionState.isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: AppLoadingIndicator(type: LoadingType.threeBounce, size: 20)),
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
}
