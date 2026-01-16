import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/contact_notes_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/documents_review_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/leave_details_step.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:ui';

class NewLeaveRequestDialog extends ConsumerStatefulWidget {
  const NewLeaveRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const NewLeaveRequestDialog());
  }

  @override
  ConsumerState<NewLeaveRequestDialog> createState() => _NewLeaveRequestDialogState();
}

class _NewLeaveRequestDialogState extends ConsumerState<NewLeaveRequestDialog> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 900.w, maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(localizations, isDark, notifier),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                  child: _buildStepContent(state.currentStep, localizations, isDark),
                ),
              ),
              _buildFooter(localizations, isDark, state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, bool isDark, NewLeaveRequestNotifier notifier) {
    final state = ref.watch(newLeaveRequestProvider);
    final currentStepIndex = state.currentStep.index;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.newLeaveRequest,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.buttonTextLight,
                      fontSize: 22.9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    localizations.completeAllStepsToSubmit,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.buttonTextLight.withValues(alpha: 0.8),
                      fontSize: 13.6.sp,
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    notifier.reset();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.closeIcon.path,
                      width: 24,
                      height: 24,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(24.h),
          _buildStepper(localizations, currentStepIndex),
        ],
      ),
    );
  }

  Widget _buildStepper(AppLocalizations localizations, int currentStepIndex) {
    final steps = [
      _StepConfig(icon: Icons.calendar_today, label: localizations.leaveDetails),
      _StepConfig(icon: Icons.contact_mail, label: localizations.contactNotes),
      _StepConfig(icon: Icons.description, label: localizations.documentsReview),
    ];

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _buildStepItem(
              icon: steps[i].icon,
              label: steps[i].label,
              stepNumber: i + 1,
              isActive: currentStepIndex == i,
              isCompleted: currentStepIndex > i,
            ),
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: currentStepIndex > i
                      ? AppColors.buttonTextLight
                      : AppColors.buttonTextLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required int stepNumber,
    required bool isActive,
    required bool isCompleted,
  }) {
    final textColor = isActive || isCompleted
        ? AppColors.buttonTextLight
        : AppColors.buttonTextLight.withValues(alpha: 0.5);
    final iconColor = isActive || isCompleted ? AppColors.primary : AppColors.buttonTextLight.withValues(alpha: 0.5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? AppColors.buttonTextLight : Colors.transparent,
            border: Border.all(color: AppColors.buttonTextLight, width: 2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.sp, color: iconColor),
        ),
        Gap(12.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Step $stepNumber',
                style: context.textTheme.bodySmall?.copyWith(color: textColor.withValues(alpha: 0.8), fontSize: 11.sp),
              ),
              Gap(2.h),
              Text(
                label,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontSize: 13.9.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(LeaveRequestStep step, AppLocalizations localizations, bool isDark) {
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        return const LeaveDetailsStep();
      case LeaveRequestStep.contactNotes:
        return const ContactNotesStep();
      case LeaveRequestStep.documentsReview:
        return const DocumentsReviewStep();
    }
  }

  Widget _buildFooter(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentStep != LeaveRequestStep.leaveDetails)
            TextButton(
              onPressed: () => notifier.previousStep(),
              child: Text(
                localizations.previous,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          Row(
            children: [
              AppButton.outline(
                label: localizations.cancel,
                onPressed: () {
                  notifier.reset();
                  Navigator.of(context).pop();
                },
              ),
              Gap(8.w),
              if (state.currentStep != LeaveRequestStep.documentsReview)
                AppButton(
                  label: localizations.next,
                  onPressed: state.canProceedToNextStep() ? () => notifier.nextStep() : null,
                  type: AppButtonType.primary,
                )
              else
                AppButton(
                  label: localizations.submitRequest,
                  onPressed: state.isSubmitting
                      ? null
                      : () async {
                          await notifier.submit();
                          if (mounted && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  type: AppButtonType.primary,
                  backgroundColor: AppColors.greenButton,
                  icon: Icons.check,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepConfig {
  final IconData icon;
  final String label;

  const _StepConfig({required this.icon, required this.label});
}
