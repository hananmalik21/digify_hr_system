import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardActionButton extends StatelessWidget {
  final String label;
  final bool showLabel;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ShiftCardActionButton({
    super.key,
    required this.label,
    this.showLabel = true,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: textColor),
            if (showLabel) ...[
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
