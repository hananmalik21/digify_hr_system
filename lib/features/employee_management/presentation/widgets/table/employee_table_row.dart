import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/features/employee_management/data/config/manage_employees_table_config.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeTableRow extends StatelessWidget {
  final EmployeeListItem employee;
  final int index;
  final AppLocalizations localizations;
  final Function(EmployeeListItem) onView;
  final Function(EmployeeListItem) onEdit;
  final VoidCallback? onMore;

  const EmployeeTableRow({
    super.key,
    required this.employee,
    required this.index,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (ManageEmployeesTableConfig.showIndex)
            _buildDataCell(Text('$index', style: textStyle), ManageEmployeesTableConfig.indexWidth.w),
          if (ManageEmployeesTableConfig.showEmployee)
            _buildDataCell(
              Row(
                children: [
                  AppAvatar(image: null, fallbackInitial: employee.fullName, size: 40.w),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          employee.fullName.toUpperCase(),
                          style: textStyle?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Gap(2.h),
                        Text(employee.employeeId, style: secondaryStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              ManageEmployeesTableConfig.employeeWidth.w,
            ),
          if (ManageEmployeesTableConfig.showPosition)
            _buildDataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.positionsIcon.path,
                    width: 16,
                    height: 16,
                    color: AppColors.statIconBlue,
                  ),
                  Gap(6.w),
                  Flexible(
                    child: Text(employee.position, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              ManageEmployeesTableConfig.positionWidth.w,
            ),
          if (ManageEmployeesTableConfig.showDepartment)
            _buildDataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.departmentsIcon.path,
                    width: 16,
                    height: 16,
                    color: AppColors.statIconBlue,
                  ),
                  Gap(6.w),
                  Flexible(
                    child: Text(
                      employee.department.toUpperCase(),
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              ManageEmployeesTableConfig.departmentWidth.w,
            ),
          if (ManageEmployeesTableConfig.showStatus)
            _buildDataCell(_buildStatusCapsule(), ManageEmployeesTableConfig.statusWidth.w),
          if (ManageEmployeesTableConfig.showActions)
            _buildDataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  DigifyAssetButton(assetPath: Assets.icons.blueEyeIcon.path, onTap: () => onView(employee)),
                  DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: () => onEdit(employee)),
                  DigifyAssetButton(assetPath: Assets.icons.moreIcon.path, onTap: onMore ?? () {}),
                ],
              ),
              ManageEmployeesTableConfig.actionsWidth.w,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCapsule() {
    final isProbation = employee.status.toLowerCase().contains('probation');
    final label = (employee.status.isEmpty ? localizations.onProbation : employee.status).toUpperCase();
    return DigifyCapsule(
      label: label,
      backgroundColor: isProbation ? AppColors.warningBg : AppColors.activeStatusBg,
      textColor: isProbation ? AppColors.warningText : AppColors.successText,
      borderColor: isProbation ? AppColors.warningBorder : AppColors.activeStatusBorder,
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
    );
  }
}
