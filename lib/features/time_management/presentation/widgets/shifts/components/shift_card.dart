import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_actions.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_card_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCard extends StatelessWidget {
  final ShiftOverview shift;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ShiftCard({
    super.key,
    required this.shift,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShiftCardContent(shift: shift, isDark: isDark),
          const Spacer(),
          DigifyDivider(
            height: 1,
            color: Color(0xFFE5E7EB),
            margin: EdgeInsets.symmetric(horizontal: 24.w),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: ShiftCardActions(
              onView: onView,
              onEdit: onEdit,
              onCopy: onCopy,
              onDelete: onDelete,
              isDeleting: isDeleting,
            ),
          ),
        ],
      ),
    );
  }
}
