import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';

class WorkforceSearchBar extends ConsumerWidget {
  final String hintText;
  final bool isDark;

  const WorkforceSearchBar({
    super.key,
    required this.hintText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(
      positionNotifierProvider.select((s) => s.searchQuery),
    );

    return SizedBox(
      width: 520.w,
      height: 40.h,
      child: TextField(
        onChanged: (value) {
          ref.read(positionNotifierProvider.notifier).search(value);
        },
        controller: TextEditingController(text: searchQuery ?? '')
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: searchQuery?.length ?? 0),
          ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isDark ? AppColors.inputBorderDark : AppColors.borderGrey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.2,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
            child: DigifyAsset(
              assetPath: Assets.icons.searchIcon.path,
              width: 20,
              height: 20,
              color: AppColors.textMuted,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: searchQuery != null && searchQuery.isNotEmpty
              ? IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.clear,
                    size: 20.sp,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {
                    ref.read(positionNotifierProvider.notifier).clearSearch();
                  },
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPlaceholder,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 12.w,
          ),
        ),
        style: TextStyle(
          fontSize: 15.3.sp,
          fontWeight: FontWeight.w400,
          color: context.themeTextPrimary,
        ),
      ),
    );
  }
}
