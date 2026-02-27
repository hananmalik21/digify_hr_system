import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../providers/overtime_configuration/overtime_configuration_provider.dart';

class ComponentLaborLawLimit extends ConsumerStatefulWidget {
  const ComponentLaborLawLimit({super.key});

  @override
  ConsumerState<ComponentLaborLawLimit> createState() =>
      _ComponentLaborLawLimitState();
}

class _ComponentLaborLawLimitState
    extends ConsumerState<ComponentLaborLawLimit> {
  final _maxDailyOvertimeController = TextEditingController();
  final _maxAnnualOvertimeController = TextEditingController();
  final _minRestPeriodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _maxDailyOvertimeController.text = '2';
    _maxAnnualOvertimeController.text = '40';
    _minRestPeriodController.text = '11';
  }

  @override
  void dispose() {
    _maxDailyOvertimeController.dispose();
    _maxAnnualOvertimeController.dispose();
    _minRestPeriodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final laborLawLimits = ref.watch(
      overtimeConfigurationProvider.select((state) => state.laborLawLimits),
    );

    _maxDailyOvertimeController.text = laborLawLimits?.maxDailyOvertime ?? "";
    _maxAnnualOvertimeController.text = laborLawLimits?.maxAnnualOvertime ?? "";
    _minRestPeriodController.text = laborLawLimits?.minRestPeriod ?? "";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.attendanceMainIcon.path,
                color: AppColors.primary,
                height: 28.h,
                width: 28.w,
              ),
              Gap(8.w),
              Text(
                'Labor Law Limits',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(24.h),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Max Daily Overtime (Hours)',
                    controller: _maxDailyOvertimeController,
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Law recommendation: 2 hours per day',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Max Annual Overtime (Hours)',
                    controller: _maxAnnualOvertimeController,
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Statutory limit: 180 hours per year',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyTextField(
                    labelText: 'Min Rest Period (Hours)',
                    controller: _minRestPeriodController,
                    keyboardType: TextInputType.number,
                  ),
                  Gap(4.h),
                  Text(
                    'Standard: 11 hours between shifts',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          DigifyDivider(height: 48.h),
        ],
      ),
    );
  }
}
