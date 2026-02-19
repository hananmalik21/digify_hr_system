import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSwitchSection extends ConsumerWidget {
  final EditDialogParams params;
  final AutoDisposeStateNotifierProviderFamily<
    EditEnterpriseStructureNotifier,
    EditEnterpriseStructureState,
    EditDialogParams
  >
  editDialogProvider;

  const ActiveSwitchSection({super.key, required this.params, required this.editDialogProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(editDialogProvider(params));
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                ),
              ),
              Switch(
                value: editState.isActive,
                onChanged: (value) {
                  ref.read(editDialogProvider(params).notifier).updateIsActive(value);
                },
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ),
        Gap(24.h),
      ],
    );
  }
}
