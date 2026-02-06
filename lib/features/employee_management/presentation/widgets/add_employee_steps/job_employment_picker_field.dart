import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobEmploymentPickerField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final String hint;
  final VoidCallback onTap;

  const JobEmploymentPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.onTap,
    this.isRequired = false,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: value != null ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DigifyAsset(
                assetPath: Assets.icons.workforce.chevronRight.path,
                color: AppColors.textSecondary,
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
