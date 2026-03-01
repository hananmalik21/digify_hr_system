import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset_button.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/common/scrollable_wrapper.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../providers/attendance_summary/attendance_summary_provider.dart';

class ComponentAttendanceSummaryTable extends ConsumerStatefulWidget {
  const ComponentAttendanceSummaryTable({super.key});

  @override
  ConsumerState<ComponentAttendanceSummaryTable> createState() => _ComponentAttendanceSummaryTableState();
}

class _ComponentAttendanceSummaryTableState extends ConsumerState<ComponentAttendanceSummaryTable> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceSummaryProvider);
    // final notifier = ref.read(attendanceSummaryProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Attendance Records',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  AppButton.primary(label: 'Add Record', svgPath: Assets.icons.addNewIconFigma.path, onPressed: () {}),
                ],
              ),
            ),
            ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableHeaderRow(context),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 200.h, maxHeight: 400.h),
                    child: Column(
                      children: [
                        if (state.isLoading)
                          Skeletonizer(
                            enabled: true,
                            child: Column(children: List.generate(3, (index) => _buildTableDataRow(context))),
                          )
                        else if (state.records.isEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            height: 250.h,
                            width: constraints.maxWidth,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'No record found',
                                  style: context.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                                ),
                                Gap(8.h),
                                Text(
                                  'Click "Add Record" to create one.',
                                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.textTertiary),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: state.records
                                .map((record) => _buildTableDataRow(context, record: record, onEdit: () {}))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeaderRow(BuildContext context) {
    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          _buildCell(
            context,
            Text(
              'EMPLOYEE',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            300.w,
          ),
          _buildCell(
            context,
            Text(
              'DATE',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'CHECK IN',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'CHECK OUT',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'HOURS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'OVERTIME',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,
            Text(
              'STATUS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),

          _buildCell(
            context,
            Text(
              'ACTIONS',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark ? AppColors.textMutedDark : AppColors.textTertiary,
              ),
            ),
            150.w,
          ),
        ],
      ),
    );
  }

  Widget _buildTableDataRow(BuildContext context, {AttendanceSummaryRecord? record, VoidCallback? onEdit}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            context,
            Text(record?.employeeName ?? '----------------', style: context.textTheme.titleMedium),
            300.w,
          ),
          _buildCell(context, Text(record?.date ?? '--/--/--', style: context.textTheme.bodyMedium), 150.w),
          _buildCell(context, Text(record?.checkIn ?? '--:--', style: context.textTheme.bodyMedium), 150.w),
          _buildCell(context, Text(record?.checkOut ?? '--:--', style: context.textTheme.bodyMedium), 150.w),
          _buildCell(context, Text(record?.hours ?? '--', style: context.textTheme.bodyMedium), 150.w),
          _buildCell(context, Text(record?.overtime ?? '--', style: context.textTheme.bodyMedium), 150.w),
          _buildCell(
            context,
            Align(
              alignment: Alignment.centerLeft,
              child: DigifyCapsule(
                label: record?.status ?? '-------',
                backgroundColor: _getStatusColor(record?.status ?? '').withValues(alpha: .2),
                textColor: _getStatusColor(record?.status ?? ''),
              ),
            ),
            150.w,
          ),
          _buildCell(
            context,

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.w,
              children: [
                DigifyAssetButton(assetPath: Assets.icons.editIcon.path, onTap: onEdit),
                // DigifyAssetButton(
                //   assetPath: Assets.icons.redDeleteIcon.path,
                //   onTap: () {},
                // ),
              ],
            ),
            150.w,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late in':
        return Colors.orange;
      case 'early out':
        return Colors.amber;
      default:
        return AppColors.textTertiary;
    }
  }

  Widget _buildCell(BuildContext context, Widget child, double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      width: width,
      child: child,
    );
  }
}
