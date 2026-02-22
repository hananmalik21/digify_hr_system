import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesSearchAndActions extends ConsumerStatefulWidget {
  const ComponentValuesSearchAndActions({
    super.key,
    required this.isDark,
    required this.searchHint,
    required this.searchValue,
    required this.onSearchChanged,
    required this.addNewLabel,
    required this.bulkUploadLabel,
    required this.exportLabel,
    required this.onAddNew,
    required this.onBulkUpload,
    required this.onExport,
  });

  final bool isDark;
  final String searchHint;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final String addNewLabel;
  final String bulkUploadLabel;
  final String exportLabel;
  final VoidCallback onAddNew;
  final VoidCallback onBulkUpload;
  final VoidCallback onExport;

  @override
  ConsumerState<ComponentValuesSearchAndActions> createState() => _ComponentValuesSearchAndActionsState();
}

class _ComponentValuesSearchAndActionsState extends ConsumerState<ComponentValuesSearchAndActions> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(ComponentValuesSearchAndActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchValue != widget.searchValue && _controller.text != widget.searchValue) {
      _controller.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _controller,
            hintText: widget.searchHint,
            onChanged: widget.onSearchChanged,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                label: widget.addNewLabel,
                onPressed: widget.onAddNew,
                svgPath: Assets.icons.addNewIconFigma.path,
                backgroundColor: AppColors.primary,
              ),
              AppButton(
                label: widget.bulkUploadLabel,
                onPressed: widget.onBulkUpload,
                svgPath: Assets.icons.bulkUploadIconFigma.path,
                backgroundColor: const Color(0xFF00A63E),
              ),
              AppButton(
                label: widget.exportLabel,
                onPressed: widget.onExport,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: widget.isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFF4A5565),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
