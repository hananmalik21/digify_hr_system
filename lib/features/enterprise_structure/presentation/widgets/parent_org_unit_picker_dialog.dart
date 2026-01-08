import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/date_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

/// Provider for parent org units
final parentOrgUnitsProvider = FutureProvider.autoDispose.family<List<OrgStructureLevel>, ParentOrgUnitsParams>((
  ref,
  params,
) async {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return await repository.getParentOrgUnits(params.structureId, params.levelCode);
});

class ParentOrgUnitsParams {
  final String structureId;
  final String levelCode;

  ParentOrgUnitsParams({required this.structureId, required this.levelCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentOrgUnitsParams &&
          runtimeType == other.runtimeType &&
          structureId == other.structureId &&
          levelCode == other.levelCode;

  @override
  int get hashCode => structureId.hashCode ^ levelCode.hashCode;
}

/// Dialog for selecting a parent org unit
class ParentOrgUnitPickerDialog extends ConsumerWidget {
  final String structureId;
  final String levelCode;

  const ParentOrgUnitPickerDialog({super.key, required this.structureId, required this.levelCode});

  static Future<OrgStructureLevel?> show(BuildContext context, {required String structureId, required String levelCode}) {
    return showDialog<OrgStructureLevel>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ParentOrgUnitPickerDialog(structureId: structureId, levelCode: levelCode),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final parentUnitsAsync = ref.watch(
      parentOrgUnitsProvider(ParentOrgUnitsParams(structureId: structureId, levelCode: levelCode)),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
          vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.w, maxHeight: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context, localizations, isDark, isMobile, isTablet),
              // Content
              Flexible(
                child: parentUnitsAsync.when(
                  data: (units) {
                    if (units.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.w),
                          child: Text(
                            'No parent units available',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsetsDirectional.all(16.w),
                      itemCount: units.length,
                      itemBuilder: (context, index) {
                        final unit = units[index];
                        return _buildUnitItem(context, localizations, isDark, unit, isMobile, isTablet, () {
                          Navigator.of(context).pop(unit);
                        });
                      },
                    );
                  },
                  loading: () => Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: const AppLoadingIndicator(
                        type: LoadingType.fadingCircle,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Failed to load parent units',
                            style: TextStyle(fontSize: 14.sp, color: Colors.red),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(
                                parentOrgUnitsProvider(
                                  ParentOrgUnitsParams(structureId: structureId, levelCode: levelCode),
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        end: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        top: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
        bottom: isMobile ? 16.h : (isTablet ? 20.h : 25.h),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Select Parent Org Unit',
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 15.6.sp),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: DigifyAsset(
              assetPath: Assets.icons.closeIconEdit.path,
              width: isMobile ? 20 : (isTablet ? 22 : 24),
              height: isMobile ? 20 : (isTablet ? 22 : 24),
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitItem(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    OrgStructureLevel unit,
    bool isMobile,
    bool isTablet,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: 8.h),
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFD1D5DB), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.displayName,
                    style: TextStyle(
                      fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    ),
                  ),
                  // Text(
                  //   unit.orgUnitId,
                  //   style: TextStyle(
                  //     fontSize: isMobile ? 13.sp : (isTablet ? 13.5.sp : 14.sp),
                  //     fontWeight: FontWeight.w500,
                  //     color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                  //   ),
                  // ),
                  // if (unit.orgUnitNameAr.isNotEmpty) ...[
                  //   SizedBox(height: 4.h),
                  //   Text(
                  //     unit.orgUnitNameAr,
                  //     textDirection: TextDirection.rtl,
                  //     style: TextStyle(
                  //       fontSize: isMobile
                  //           ? 12.sp
                  //           : (isTablet ? 12.5.sp : 13.sp),
                  //       fontWeight: FontWeight.w400,
                  //       color: isDark
                  //           ? AppColors.textSecondaryDark
                  //           : AppColors.textSecondary,
                  //     ),
                  //   ),
                  // ],
                  SizedBox(height: 4.h),
                  Text(
                    'Parent Type: ${unit.levelCode.toTitleCase()}',
                    style: TextStyle(
                      fontSize: isMobile ? 11.sp : (isTablet ? 11.5.sp : 12.sp),
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16.sp,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
