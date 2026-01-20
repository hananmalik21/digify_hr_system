import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyTabHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;

  const DigifyTabHeader({super.key, required this.title, this.description, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.displaySmall),
              if (description != null) ...[
                Gap(3.h),
                Text(description!, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[Gap(11.w), trailing!],
      ],
    );
  }
}
