import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/leave_details_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/contact_notes_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/documents_review_step.dart';
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
          constraints: BoxConstraints(maxWidth: 900.w, maxHeight: 800.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, offset: const Offset(0, 12)),
            ],
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 22.9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    localizations.completeAllStepsToSubmit,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: const Color(0xFFDBEAFE), fontSize: 13.6.sp),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.closeIcon.path,
                      width: 24,
                      height: 24,
                      color: Colors.white,
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
    return Row(
      children: [
        Expanded(
          child: _buildStepItem(
            icon: Icons.calendar_today,
            label: localizations.leaveDetails,
            isActive: currentStepIndex == 0,
            isCompleted: currentStepIndex > 0,
          ),
        ),
        Expanded(
          child: Container(
            height: 2.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: currentStepIndex > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
        Expanded(
          child: _buildStepItem(
            icon: Icons.contact_mail,
            label: localizations.contactNotes,
            isActive: currentStepIndex == 1,
            isCompleted: currentStepIndex > 1,
          ),
        ),
        Expanded(
          child: Container(
            height: 2.h,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: currentStepIndex > 1 ? Colors.white : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
        Expanded(
          child: _buildStepItem(
            icon: Icons.description,
            label: localizations.documentsReview,
            isActive: currentStepIndex == 2,
            isCompleted: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: isActive || isCompleted ? const Color(0xFF2563EB) : Colors.white.withValues(alpha: 0.5),
          ),
        ),
        Gap(12.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.split(' ').first,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive || isCompleted ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  fontSize: 13.9.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (label.contains(' '))
                Text(
                  label.split(' ').skip(1).join(' '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isActive || isCompleted ? Colors.white : Colors.white.withValues(alpha: 0.5),
                    fontSize: 13.9.sp,
                    fontWeight: FontWeight.w500,
                  ),
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
        color: const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.currentStep != LeaveRequestStep.leaveDetails)
            TextButton(
              onPressed: () => notifier.previousStep(),
              child: Text(
                localizations.previous,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF364153),
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
                  backgroundColor: const Color(0xFF2563EB),
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
                  backgroundColor: const Color(0xFF00A63E),
                  icon: Icons.check,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
