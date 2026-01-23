import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/contact_notes_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/documents_review/documents_review_step.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/new_leave_request/leave_details_step.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewLeaveRequestDialog extends ConsumerWidget {
  const NewLeaveRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const NewLeaveRequestDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    final stepperSteps = [
      StepperStepConfig(assetPath: Assets.icons.leaveManagement.emptyLeave.path, label: localizations.leaveDetails),
      StepperStepConfig(assetPath: Assets.icons.leaveManagement.forfeitReports.path, label: localizations.contactNotes),
      StepperStepConfig(assetPath: Assets.icons.leaveManagement.attachment.path, label: localizations.documentsReview),
    ];

    return AppStepperDialog(
      title: localizations.newLeaveRequest,
      subtitle: localizations.completeAllStepsToSubmit,
      content: _buildStepContent(state.currentStep),
      stepperSteps: stepperSteps,
      currentStepIndex: state.currentStep.index,
      onClose: () {
        notifier.reset();
        Navigator.of(context).pop();
      },
      footerLeftActions: state.currentStep != LeaveRequestStep.leaveDetails
          ? [AppButton.outline(label: localizations.previous, onPressed: () => notifier.previousStep())]
          : null,
      footerActions: [
        AppButton.outline(
          label: localizations.cancel,
          onPressed: () {
            notifier.reset();
            Navigator.of(context).pop();
          },
        ),
        Gap(8.w),
        AppButton.outline(
          label: localizations.saveAsDraft,
          isLoading: state.isSavingDraft,
          onPressed: state.isSavingDraft || state.isSubmitting
              ? null
              : () async {
                  try {
                    await notifier.saveAsDraft();
                    if (context.mounted) {
                      ToastService.success(context, localizations.draftSaved);
                      notifier.reset();
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      final errorMessage = e.toString().replaceFirst('Exception: ', '');
                      ToastService.error(context, errorMessage);
                    }
                  }
                },
        ),
        Gap(8.w),
        if (state.currentStep != LeaveRequestStep.documentsReview)
          AppButton(
            label: localizations.next,
            onPressed: (state.isSavingDraft || !state.canProceedToNextStep()) ? null : () => notifier.nextStep(),
            type: AppButtonType.primary,
          )
        else
          AppButton(
            label: localizations.submitRequest,
            isLoading: state.isSubmitting,
            onPressed: (state.isSubmitting || state.isSavingDraft)
                ? null
                : () async {
                    try {
                      final response = await notifier.submit();
                      if (context.mounted) {
                        final leaveRequestsNotifier = ref.read(leaveRequestsNotifierProvider.notifier);
                        final employeeName = state.selectedEmployee?.fullName ?? '';
                        final leaveType = state.leaveType!;
                        leaveRequestsNotifier.addLeaveRequestOptimistically(response, employeeName, leaveType);
                        ToastService.success(context, localizations.submitRequest);
                        notifier.reset();
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        final errorMessage = e.toString().replaceFirst('Exception: ', '');
                        ToastService.error(context, errorMessage);
                      }
                    }
                  },
            type: AppButtonType.primary,
            backgroundColor: AppColors.greenButton,
            icon: Icons.check,
          ),
      ],
    );
  }

  Widget _buildStepContent(LeaveRequestStep step) {
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        return const LeaveDetailsStep();
      case LeaveRequestStep.contactNotes:
        return const ContactNotesStep();
      case LeaveRequestStep.documentsReview:
        return const DocumentsReviewStep();
    }
  }
}
