import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardIconButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const ShiftCardIconButton({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading || onPressed == null ? null : onPressed,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.r)),
        child: isLoading
            ? SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(iconColor)),
              )
            : Icon(icon, size: 16.sp, color: iconColor),
      ),
    );
  }
}
