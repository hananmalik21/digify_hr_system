import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForfeitReportsTab extends StatelessWidget {
  const ForfeitReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Center(
        child: Text(
          'Forfeit Reports',
          style: TextStyle(fontSize: 18.sp, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
      ),
    );
  }
}
