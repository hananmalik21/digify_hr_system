import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComponentDetailDialog extends StatelessWidget {
  final ComponentValue component;
  final List<ComponentValue> allComponents;

  const ComponentDetailDialog({
    super.key,
    required this.component,
    required this.allComponents,
  });

  static Future<void> show(
    BuildContext context, {
    required ComponentValue component,
    required List<ComponentValue> allComponents,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ComponentDetailDialog(
        component: component,
        allComponents: allComponents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    // Get parent component
    final parentComponent = component.parentId != null
        ? allComponents.firstWhere(
            (c) => c.id == component.parentId,
            orElse: () => component,
          )
        : null;

    // Get child components count
    final childComponents = allComponents
        .where((c) => c.parentId == component.id)
        .toList();

    // Build hierarchy path
    final hierarchyPath = _buildHierarchyPath(component, allComponents);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : (isTablet ? 700.w : 900.w),
          maxHeight: MediaQuery.of(context).size.height * (isMobile ? 0.95 : 0.9),
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - pixel perfect: pt-[24px] pb-[25px] px-[24px]
            _buildHeader(context, localizations, isDark, isMobile, isTablet),
            // Content - pixel perfect: left-[24px] right-[24px] top-[96.95px] gap-[24px]
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                  start: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
                  end: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
                  top: isMobile ? 16.h : 0.h, // Content starts immediately after header
                  bottom: isMobile ? 16.h : 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information - gap-[24px] between sections
                    _buildBasicInformationSection(
                        context, localizations, isDark, isMobile, isTablet),
                    SizedBox(height: 24.h),
                    // Hierarchy & Relationships
                    _buildHierarchySection(context, localizations, isDark,
                        isMobile, isTablet, parentComponent, childComponents, hierarchyPath),
                    SizedBox(height: 24.h),
                    // Management Information
                    _buildManagementSection(
                        context, localizations, isDark, isMobile, isTablet),
                    SizedBox(height: 24.h),
                    // Audit Trail
                    _buildAuditTrailSection(
                        context, localizations, isDark, isMobile, isTablet),
                    SizedBox(height: 24.h),
                    // Description
                    _buildDescriptionSection(
                        context, localizations, isDark, isMobile, isTablet),
                    SizedBox(height: 24.h),
                    // Additional Fields - Only show for Company
                    if (component.type == ComponentType.company)
                      _buildAdditionalFieldsSection(
                          context, localizations, isDark, isMobile, isTablet),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations,
      bool isDark, bool isMobile, bool isTablet) {
    // Pixel perfect: pt-[24px] pb-[25px] px-[24px]
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        end: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        top: isMobile ? 16.h : 24.h,
        bottom: isMobile ? 16.h : 25.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${localizations.componentDetails} - ${component.name}',
              // Pixel perfect: text-[15.6px] font-semibold leading-[24px]
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 15.6.sp),
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgIconWidget(
              assetPath: 'assets/icons/close_icon.svg',
              // Pixel perfect: size-[24px]
              size: isMobile ? 20.sp : (isTablet ? 22.sp : 24.sp),
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationSection(BuildContext context,
      AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header - gap-[8px] between icon and text
        Row(
          children: [
            SvgIconWidget(
              assetPath: component.type == ComponentType.department
                  ? 'assets/icons/basic_info_icon_department.svg'
                  : 'assets/icons/basic_info_icon.svg',
              // Pixel perfect: size-[20px]
              size: isMobile ? 18.sp : (isTablet ? 19.sp : 20.sp),
              // Pixel perfect: Blue color #155DFC from Figma
              color: const Color(0xFF155DFC),
            ),
            SizedBox(width: isMobile ? 6.w : 8.w),
            Text(
              localizations.basicInformation,
              // Pixel perfect: text-[15.5px] font-medium leading-[24px]
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.5,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        // Pixel perfect: gap-[16px] after header
        SizedBox(height: isMobile ? 12.h : 16.h),
        // Fields - pixel perfect: h-[272px] with absolute positioning
        // Each field: 432px wide (half of 864px - 16px gap)
        isMobile
            ? Column(
                children: [
                  _buildInfoField(
                      context,
                      localizations.componentType,
                      component.type.displayName.toLowerCase(),
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: 15.5.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.componentCode, component.code,
                      isDark, isMobile, isTablet,
                      valueFontSize: component.type == ComponentType.company ? 15.6.sp : 15.5.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.nameEnglish,
                      component.name, isDark, isMobile, isTablet,
                      valueFontSize: 15.4.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.nameArabic,
                      component.arabicName, isDark, isMobile, isTablet,
                      isArabic: true,
                      valueFontSize: 16.sp),
                  SizedBox(height: 12.h),
                  _buildStatusField(
                      context, localizations.status, component.status, isDark, isMobile, isTablet),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.costCenter, 'CC-0000',
                      isDark, isMobile, isTablet,
                      valueFontSize: 15.5.sp),
                ],
              )
            : SizedBox(
                height: 272.h,
                child: Stack(
                  children: [
                    // Row 1: Component Type (left) and Code (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 0,
                      child: _buildInfoField(
                          context,
                          localizations.componentType,
                          component.type.displayName.toLowerCase(),
                          isDark,
                          isMobile,
                          isTablet,
                          valueFontSize: 15.5.sp),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 0,
                      child: _buildInfoField(context, localizations.componentCode,
                          component.code, isDark, isMobile, isTablet,
                          valueFontSize: component.type == ComponentType.company ? 15.6.sp : 15.5.sp),
                    ),
                    // Row 2: Name English (left) and Name Arabic (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 96.h,
                      child: _buildInfoField(context, localizations.nameEnglish,
                          component.name, isDark, isMobile, isTablet,
                          valueFontSize: 15.4.sp),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 96.h,
                      child: _buildInfoField(context, localizations.nameArabic,
                          component.arabicName, isDark, isMobile, isTablet,
                          isArabic: true,
                          valueFontSize: 16.sp),
                    ),
                    // Row 3: Status (left) and Cost Center (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 192.h,
                      child: _buildStatusField(
                          context, localizations.status, component.status, isDark, isMobile, isTablet),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 192.h,
                      child: _buildInfoField(context, localizations.costCenter,
                          'CC-0000', isDark, isMobile, isTablet,
                          valueFontSize: 15.5.sp),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildHierarchySection(
      BuildContext context,
      AppLocalizations localizations,
      bool isDark,
      bool isMobile,
      bool isTablet,
      ComponentValue? parentComponent,
      List<ComponentValue> childComponents,
      String hierarchyPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            SvgIconWidget(
              assetPath: component.type == ComponentType.department
                  ? 'assets/icons/hierarchy_icon_department.svg'
                  : 'assets/icons/hierarchy_icon.svg',
              size: isMobile ? 18.sp : (isTablet ? 19.sp : 20.sp),
              // Pixel perfect: Purple color #9810FA from Figma
              color: const Color(0xFF9810FA),
            ),
            SizedBox(width: isMobile ? 6.w : 8.w),
            Text(
              localizations.hierarchyRelationships,
              // Pixel perfect: text-[15.6px]
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.6.sp),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.6,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        // Fields - pixel perfect: h-[176px]
        isMobile
            ? Column(
                children: [
                  _buildInfoField(
                      context,
                      localizations.parentComponent,
                      parentComponent != null
                          ? '${parentComponent.name} (${parentComponent.code})'
                          : localizations.rootLevelNoParent,
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: 15.5.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(
                      context,
                      localizations.childComponents,
                      '${childComponents.length} ${localizations.components}',
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: 15.5.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.hierarchyPath,
                      hierarchyPath, isDark, isMobile, isTablet,
                      valueFontSize: component.type == ComponentType.company
                          ? 13.9.sp
                          : (component.type == ComponentType.businessUnit ? 13.7.sp : 13.8.sp),
                      customPadding: EdgeInsetsDirectional.only(
                        start: 16.w,
                        end: 16.w,
                        top: 16.h,
                        bottom: 20.h,
                      )),
                  SizedBox(height: 12.h),
                  _buildInfoField(
                      context,
                      localizations.hierarchyLevel,
                      '${localizations.level} ${_getHierarchyLevel(component, allComponents)}',
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: component.type == ComponentType.company
                          ? 15.3.sp
                          : (component.type == ComponentType.businessUnit
                              ? 15.3.sp
                              : (component.type == ComponentType.department ? 15.4.sp : 15.4.sp))),
                ],
              )
            : SizedBox(
                height: 176.h,
                child: Stack(
                  children: [
                    // Row 1: Parent Component (left) and Child Components (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 0,
                      child: _buildInfoField(
                          context,
                          localizations.parentComponent,
                          parentComponent != null
                              ? '${parentComponent.name} (${parentComponent.code})'
                              : localizations.rootLevelNoParent,
                          isDark,
                          isMobile,
                          isTablet,
                          valueFontSize: 15.5.sp),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 0,
                      child: _buildInfoField(
                          context,
                          localizations.childComponents,
                          '${childComponents.length} ${localizations.components}',
                          isDark,
                          isMobile,
                          isTablet,
                          valueFontSize: 15.5.sp),
                    ),
                    // Row 2: Hierarchy Path (left) and Hierarchy Level (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 96.h,
                      child: _buildInfoField(context, localizations.hierarchyPath,
                          hierarchyPath, isDark, isMobile, isTablet,
                          valueFontSize: component.type == ComponentType.company
                          ? 13.9.sp
                          : (component.type == ComponentType.businessUnit || component.type == ComponentType.department
                              ? 13.7.sp
                              : 13.8.sp),
                          customPadding: EdgeInsetsDirectional.only(
                            start: 16.w,
                            end: 16.w,
                            top: 16.h,
                            bottom: 20.h,
                          )),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 96.h,
                      child: _buildInfoField(
                          context,
                          localizations.hierarchyLevel,
                          '${localizations.level} ${_getHierarchyLevel(component, allComponents)}',
                          isDark,
                          isMobile,
                          isTablet,
                          valueFontSize: component.type == ComponentType.company
                          ? 15.3.sp
                          : (component.type == ComponentType.businessUnit
                              ? 15.3.sp
                              : (component.type == ComponentType.department ? 15.4.sp : 15.4.sp))),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildManagementSection(BuildContext context,
      AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            SvgIconWidget(
              assetPath: component.type == ComponentType.department
                  ? 'assets/icons/management_icon_department.svg'
                  : 'assets/icons/management_icon.svg',
              size: isMobile ? 18.sp : (isTablet ? 19.sp : 20.sp),
              // Pixel perfect: Green color #00A63E from Figma
              color: const Color(0xFF00A63E),
            ),
            SizedBox(width: isMobile ? 6.w : 8.w),
            Text(
              localizations.managementInformation,
              // Pixel perfect: text-[15.5px]
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.5,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        // Fields - pixel perfect: gap-[16px], each w-[416px]
        isMobile
            ? Column(
                children: [
                  _buildManagerField(context, localizations, isDark, isMobile, isTablet),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.location,
                      component.location ?? localizations.notSpecified, isDark, isMobile, isTablet,
                      valueFontSize: 15.4.sp),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 416.w,
                    child: _buildManagerField(context, localizations, isDark, isMobile, isTablet),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 416.w,
                    child: _buildInfoField(context, localizations.location,
                        component.location ?? localizations.notSpecified, isDark, isMobile, isTablet,
                        valueFontSize: 15.4.sp),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildAuditTrailSection(BuildContext context,
      AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            SvgIconWidget(
              assetPath: component.type == ComponentType.department
                  ? 'assets/icons/audit_trail_icon_department.svg'
                  : 'assets/icons/audit_trail_icon.svg',
              size: isMobile ? 18.sp : (isTablet ? 19.sp : 20.sp),
              // Pixel perfect: Orange color #F54900 from Figma
              color: const Color(0xFFF54900),
            ),
            SizedBox(width: isMobile ? 6.w : 8.w),
            Text(
              localizations.auditTrail,
              // Pixel perfect: text-[15.3px]
              style: TextStyle(
                fontSize: isMobile ? 14.sp : (isTablet ? 14.3.sp : 15.3.sp),
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.3,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        // Fields - pixel perfect: gap-[16px], each w-[416px]
        isMobile
            ? Column(
                children: [
                  _buildInfoField(
                      context,
                      localizations.lastUpdatedDate,
                      _formatDate(component.updatedAt),
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: 15.6.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(
                      context,
                      localizations.lastUpdatedBy,
                      'HR Admin', // TODO: Get from component
                      isDark,
                      isMobile,
                      isTablet,
                      valueFontSize: component.type == ComponentType.businessUnit ? 15.4.sp : 15.6.sp),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 416.w,
                    child: _buildInfoField(
                        context,
                        localizations.lastUpdatedDate,
                        _formatDate(component.updatedAt),
                        isDark,
                        isMobile,
                        isTablet,
                        valueFontSize: 15.6.sp),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 416.w,
                    child: _buildInfoField(
                        context,
                        localizations.lastUpdatedBy,
                        'HR Admin', // TODO: Get from component
                        isDark,
                        isMobile,
                        isTablet,
                        valueFontSize: component.type == ComponentType.businessUnit
                            ? 15.4.sp
                            : (component.type == ComponentType.department ? 15.5.sp : 15.6.sp)),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context,
      AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pixel perfect: text-[15.5px] font-medium
        Text(
          localizations.description,
          style: TextStyle(
            fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp),
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textPrimaryDark
                : const Color(0xFF101828),
            height: 24 / 15.5,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        Container(
          width: double.infinity,
          // Pixel perfect: p-[16px]
          padding: EdgeInsetsDirectional.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            component.description ?? localizations.noDescription,
            // Pixel perfect: text-[15.3px] font-normal color #364153
            style: TextStyle(
              fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.3.sp),
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF364153),
              height: 24 / 15.3,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFieldsSection(BuildContext context,
      AppLocalizations localizations, bool isDark, bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pixel perfect: text-[15.4px] font-medium
        Text(
          localizations.additionalFields,
          style: TextStyle(
            fontSize: isMobile ? 14.sp : (isTablet ? 14.4.sp : 15.4.sp),
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textPrimaryDark
                : const Color(0xFF101828),
            height: 24 / 15.4,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        // Fields - pixel perfect: h-[176px]
        isMobile
            ? Column(
                children: [
                  _buildInfoField(context, localizations.establishedDate,
                      '1990-01-01', isDark, isMobile, isTablet,
                      valueFontSize: 15.6.sp,
                      labelFontSize: 13.6.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.registrationNumber,
                      'CR-123456', isDark, isMobile, isTablet,
                      valueFontSize: 15.6.sp,
                      labelFontSize: 13.7.sp),
                  SizedBox(height: 12.h),
                  _buildInfoField(context, localizations.taxId, 'TAX-KW-001',
                      isDark, isMobile, isTablet,
                      valueFontSize: 15.6.sp,
                      labelFontSize: 13.3.sp),
                ],
              )
            : SizedBox(
                height: 176.h,
                child: Stack(
                  children: [
                    // Row 1: Established Date (left) and Registration Number (right)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 0,
                      child: _buildInfoField(context, localizations.establishedDate,
                          '1990-01-01', isDark, isMobile, isTablet,
                          valueFontSize: 15.6.sp,
                          labelFontSize: 13.6.sp),
                    ),
                    Positioned(
                      left: 432.w + 16.w,
                      right: 0,
                      top: 0,
                      child: _buildInfoField(context, localizations.registrationNumber,
                          'CR-123456', isDark, isMobile, isTablet,
                          valueFontSize: 15.6.sp,
                          labelFontSize: 13.7.sp),
                    ),
                    // Row 2: Tax ID (left only)
                    Positioned(
                      left: 0,
                      right: 432.w + 16.w,
                      top: 96.h,
                      child: _buildInfoField(context, localizations.taxId, 'TAX-KW-001',
                          isDark, isMobile, isTablet,
                          valueFontSize: 15.6.sp,
                          labelFontSize: 13.3.sp),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildInfoField(BuildContext context, String label, String value,
      bool isDark, bool isMobile, bool isTablet,
      {bool isArabic = false,
      double? valueFontSize,
      double? labelFontSize,
      EdgeInsetsDirectional? customPadding}) {
    // Pixel perfect: p-[16px], gap-[4px]
    return Container(
      width: double.infinity,
      padding: customPadding ?? EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            // Pixel perfect: text-[13.6px] or [13.7px] font-normal leading-[20px] color #4a5565
            style: TextStyle(
              fontSize: labelFontSize ?? (isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.6.sp)),
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A5565),
              height: 20 / (labelFontSize ?? 13.6),
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            // Pixel perfect: text-[15.5px] or [15.6px] font-medium leading-[24px] color #101828
            // Special case: Hierarchy Path uses leading-[20px] for 13.8px font
            style: TextStyle(
              fontSize: valueFontSize ?? (isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp)),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF101828),
              height: (valueFontSize != null && (valueFontSize == 13.7.sp || valueFontSize == 13.8.sp || valueFontSize == 13.9.sp))
                  ? 20 / valueFontSize  // Special case for Hierarchy Path (leading-[20px])
                  : 24 / (valueFontSize ?? 15.5),
              letterSpacing: 0,
            ),
            textDirection: isArabic ? TextDirection.rtl : null,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusField(BuildContext context, String label, bool isActive,
      bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      // Pixel perfect: p-[16px]
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pixel perfect: text-[13.7px]
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.7.sp),
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A5565),
              height: 20 / 13.7,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          // Pixel perfect: pt-[2.5px] px-[8px] py-[3px]
          Padding(
            padding: EdgeInsetsDirectional.only(
              top: 2.5.h,
            ),
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                // Pixel perfect: bg-[#dcfce7] for active
                color: isActive
                    ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
                    : (isDark
                        ? AppColors.errorBgDark
                        : const Color(0xFFFFE2E2)),
                // Pixel perfect: rounded-[16777200px] (fully rounded)
                borderRadius: BorderRadius.circular(9999.r),
              ),
              child: Text(
                isActive ? 'ACTIVE' : 'INACTIVE',
                // Pixel perfect: text-[11.8px] font-medium leading-[16px] color #016630
                style: TextStyle(
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? (isDark
                          ? AppColors.successTextDark
                          : const Color(0xFF016630))
                      : (isDark
                          ? AppColors.errorTextDark
                          : const Color(0xFFC10007)),
                  height: 16 / 11.8,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerField(BuildContext context, AppLocalizations localizations,
      bool isDark, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      // Pixel perfect: p-[16px]
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pixel perfect: text-[13.6px]
          Text(
            localizations.manager,
            style: TextStyle(
              fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.6.sp),
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A5565),
              height: 20 / 13.6,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 4.h),
          // Pixel perfect: text-[15.5px] for most, text-[15.6px] for business unit
          Text(
            component.managerId ?? localizations.notSpecified, // TODO: Get manager name
            style: TextStyle(
              fontSize: isMobile
                  ? 14.sp
                  : (isTablet
                      ? 14.5.sp
                      : (component.type == ComponentType.businessUnit
                          ? 15.6.sp
                          : (component.type == ComponentType.department ? 15.4.sp : 15.5.sp))),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF101828),
              height: component.type == ComponentType.businessUnit
                  ? 24 / 15.6
                  : (component.type == ComponentType.department ? 24 / 15.4 : 24 / 15.5),
              letterSpacing: 0,
            ),
          ),
          if (component.managerId != null) ...[
            SizedBox(height: 4.h),
            // Pixel perfect: text-[12px] color #6a7282
            Text(
              'ID: ${component.managerId}',
              style: TextStyle(
                fontSize: isMobile ? 11.sp : (isTablet ? 11.5.sp : 12.sp),
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : const Color(0xFF6A7282),
                height: 16 / 12,
                letterSpacing: 0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildHierarchyPath(
      ComponentValue component, List<ComponentValue> allComponents) {
    final path = <String>[];
    ComponentValue? current = component;

    while (current != null) {
      path.insert(0, current.code);
      if (current.parentId != null) {
        current = allComponents.firstWhere(
          (c) => c.id == current!.parentId,
          orElse: () => current!,
        );
        if (current.parentId == null) break;
      } else {
        break;
      }
    }

    // Use arrow (→) instead of " > " to match Figma design
    return path.join(' → ');
  }

  int _getHierarchyLevel(
      ComponentValue component, List<ComponentValue> allComponents) {
    int level = 1;
    ComponentValue? current = component;

    while (current?.parentId != null) {
      level++;
      current = allComponents.firstWhere(
        (c) => c.id == current!.parentId,
        orElse: () => current!,
      );
      if (current.parentId == null) break;
    }

    return level;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
