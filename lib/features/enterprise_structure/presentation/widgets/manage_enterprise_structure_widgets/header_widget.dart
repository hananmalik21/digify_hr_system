import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header widget for manage enterprise structure screen
class HeaderWidget extends StatelessWidget {
  final AppLocalizations localizations;

  const HeaderWidget({
    super.key,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(16.w),
        tablet: EdgeInsetsDirectional.all(20.w),
        web: EdgeInsetsDirectional.all(24.w),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9810FA), Color(0xFF155DFC)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.manageEnterpriseStructure,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 32 / 22.7,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            localizations.configureManageHierarchy,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFF3E8FF),
                              height: 24 / 15.3,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgIconWidget(
                      assetPath: 'assets/icons/manage_enterprise_icon.svg',
                      size: 24.sp,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  localizations.configureManageHierarchyAr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFF3E8FF),
                    height: 20 / 14,
                    letterSpacing: 0,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.manageEnterpriseStructure,
                        style: TextStyle(
                          fontSize: isTablet ? 20.sp : 22.7.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 32 / 22.7,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        localizations.configureManageHierarchy,
                        style: TextStyle(
                          fontSize: isTablet ? 14.sp : 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF3E8FF),
                          height: 24 / 15.3,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        localizations.configureManageHierarchyAr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFF3E8FF),
                          height: 20 / 14,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 12.w : 16.w),
                SvgIconWidget(
                  assetPath: 'assets/icons/manage_enterprise_icon.svg',
                  size: isTablet ? 28.sp : 32.sp,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }
}

