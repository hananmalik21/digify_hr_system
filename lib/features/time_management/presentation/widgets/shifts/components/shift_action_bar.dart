import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../gen/assets.gen.dart';

class ShiftActionBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onCreateShift;
  final VoidCallback onUpload;
  final VoidCallback onExport;

  const ShiftActionBar({
    super.key,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onCreateShift,
    required this.onUpload,
    required this.onExport,
  });

  @override
  State<ShiftActionBar> createState() => _ShiftActionBarState();
}

class _ShiftActionBarState extends State<ShiftActionBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search shifts...',
            onChanged: widget.onSearchChanged,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 144.w,
                child: DigifySelectField<PositionStatus?>(
                  label: '',
                  hint: 'All Status',
                  value: _getStatusFromString(widget.selectedStatus),
                  items: [null, ...PositionStatus.values],
                  itemLabelBuilder: (status) => status?.label ?? 'All Status',
                  onChanged: (newValue) {
                    final statusString = newValue == null ? 'All Status' : newValue.label;
                    widget.onStatusChanged(statusString);
                  },
                ),
              ),
              AppButton(
                label: 'Create Shift',
                onPressed: widget.onCreateShift,
                svgPath: Assets.icons.addDivisionIcon.path,
              ),
              AppButton(
                label: 'Upload',
                onPressed: widget.onUpload,
                svgPath: Assets.icons.bulkUploadIconFigma.path,
                backgroundColor: AppColors.shiftUploadButton,
              ),
              AppButton(
                label: 'Export',
                onPressed: widget.onExport,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }

  PositionStatus? _getStatusFromString(String statusString) {
    if (statusString == 'All Status') return null;
    if (statusString == 'Active') return PositionStatus.active;
    return PositionStatus.inactive;
  }
}
