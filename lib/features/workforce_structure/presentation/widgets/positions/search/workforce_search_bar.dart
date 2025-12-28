import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_provider.dart';

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
    return SizedBox(
      width: 520.w,
      child: TextField(
        onChanged: (value) {
          ref.read(positionSearchQueryProvider.notifier).state = value;
        },
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
            child: SvgIconWidget(
              assetPath: 'assets/icons/search_icon.svg',
              size: 20.sp,
              color: AppColors.textMuted,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.3.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textPlaceholder,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
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
