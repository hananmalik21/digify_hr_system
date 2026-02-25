import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/digify_square_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/widgets/assets/digify_asset_button.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../domain/domain/models/overtime/overtime_record.dart';

class OvertimeTableRow extends ConsumerWidget {
  final OvertimeRecord record;
  final AppLocalizations localizations;
  final Function(OvertimeRecord) onView;
  final Function(OvertimeRecord) onEdit;
  final Function(OvertimeRecord) onDelete;

  const OvertimeTableRow({
    super.key,
    required this.record,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("--/--/--"), Text("Requested: --/--/--")],
            ),
          ),
          _buildDataCell(
            DigifySquareCapsule(
              label: "Weekday",
              textColor: AppColors.statIconBlue,
              backgroundColor: AppColors.statIconBlue.withValues(alpha: 0.1),
            ),
          ),
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("--/--/--"), Text("Requested: --/--/--")],
            ),
          ),
          _buildDataCell(Text("1.25x")),
          _buildDataCell(Text("KWD 112.50")),
          _buildDataCell(
            DigifyCapsule(
              label: "Approved",
              textColor: AppColors.statIconGreen,
              backgroundColor: AppColors.statIconGreen.withValues(alpha: 0.1),
            ),
          ),
          _buildDataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.w,
              children: [
                DigifyAssetButton(
                  assetPath: Assets.icons.blueEyeIcon.path,
                  onTap: () => onView(record),
                ),
                DigifyAssetButton(
                  assetPath: Assets.icons.editIcon.path,
                  onTap: () => onEdit(record),
                ),
                DigifyAssetButton(
                  assetPath: Assets.icons.redDeleteIcon.path,
                  onTap: () => onDelete(record),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        child: child,
      ),
    );
  }
}
