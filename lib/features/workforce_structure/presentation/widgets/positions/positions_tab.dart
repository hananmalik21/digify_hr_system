import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_details_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/position_form_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_positions_table.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/workforce_search_and_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionsTab extends ConsumerWidget {
  const PositionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final filteredPositions = ref.watch(filteredPositionsProvider);

    return Column(
      children: [
        WorkforceSearchAndActions(
          localizations: localizations,
          isDark: isDark,
          onAddPosition: () =>
              _showPositionFormDialog(context, Position.empty(), false),
        ),
        SizedBox(height: 24.h),
        WorkforcePositionsTable(
          localizations: localizations,
          positions: filteredPositions,
          isDark: isDark,
          onView: (position) => _showPositionDetailsDialog(context, position),
          onEdit: (position) =>
              _showPositionFormDialog(context, position, true),
          onDelete: (position) {},
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

  void _showPositionFormDialog(
    BuildContext context,
    Position position,
    bool isEdit,
  ) {
    PositionFormDialog.show(context, position: position, isEdit: isEdit);
  }
}
