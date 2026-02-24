import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/overtime/overtime_provider.dart';

class ComponentOvertimeFilterBar extends ConsumerWidget {
  const ComponentOvertimeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overtimeManagementProvider);
    final notifier = ref.read(overtimeManagementProvider.notifier);
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(vertical: 8.w, horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.usersIcon.path,
            width: 16,
            height: 16,
          ),
          Gap(16.w),
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = state.categories![index];
                  return ChoiceChip(
                    label: Text(category.name),
                    selected: state.selectedCategory == category,
                    selectedColor: context.colorScheme.primary,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: state.selectedCategory == category
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: context.isDark
                        ? AppColors.backgroundDark
                        : AppColors.grayBg,
                    side: BorderSide.none,
                    onSelected: (value) => notifier.selectCategory(category),
                  );
                },
                separatorBuilder: (context, index) => Gap(8.w),
                itemCount: state.categories?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
