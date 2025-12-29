import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PositionFormActions extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isEdit;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const PositionFormActions({
    super.key,
    required this.localizations,
    required this.isEdit,
    this.isLoading = false,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton.outline(
            label: localizations.cancel,
            onPressed: isLoading ? null : onCancel,
            width: 120.w,
          ),
          SizedBox(width: 12.w),
          AppButton.primary(
            label: isEdit
                ? localizations.saveUpdates
                : localizations.saveChanges,
            icon: isLoading ? null : Icons.save,
            isLoading: isLoading,
            onPressed: isLoading ? null : onSave,
            width: 160.w,
          ),
        ],
      ),
    );
  }
}
