import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';

class PositionDialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const PositionDialogHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size(32.w, 32.h)),
            icon: Icon(
              Icons.close,
              size: 20.sp,
              color: AppColors.textSecondary,
            ),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class PositionDialogSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PositionDialogSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(spacing: 16.w, runSpacing: 16.h, children: children),
      ],
    );
  }
}

class PositionFormRow extends StatelessWidget {
  final List<Widget> children;

  const PositionFormRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final isLast = entry.key == children.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 16.w),
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

class PositionLabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const PositionLabeledField({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        child,
      ],
    );
  }
}
