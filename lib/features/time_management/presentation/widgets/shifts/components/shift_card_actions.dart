import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/action_button.dart';
import 'package:digify_hr_system/core/widgets/buttons/icon_action_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftCardActions extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ShiftCardActions({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ActionButton(
            label: localizations.view,
            onTap: onView,
            iconPath: Assets.icons.viewIconBlue.path,
            backgroundColor: AppColors.infoBg,
            foregroundColor: AppColors.primary,
          ),
        ),
        Gap(8.w),
        Expanded(
          child: ActionButton(
            label: localizations.edit,
            onTap: onEdit,
            iconPath: Assets.icons.editIconGreen.path,
            backgroundColor: AppColors.greenBg,
            foregroundColor: AppColors.greenButton,
          ),
        ),
        if (onDelete != null) ...[
          Gap(8.w),
          IconActionButton(
            iconPath: Assets.icons.deleteIconRed.path,
            bgColor: AppColors.errorBg,
            iconColor: AppColors.error,
            onPressed: isDeleting ? null : onDelete,
            isLoading: isDeleting,
          ),
        ],
      ],
    );
  }
}
