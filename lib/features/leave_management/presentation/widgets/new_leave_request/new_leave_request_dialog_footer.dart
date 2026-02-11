import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

List<Widget> buildNewLeaveRequestFooterLeftActions(
  BuildContext context,
  NewLeaveRequestState state,
  NewLeaveRequestNotifier notifier,
) {
  final localizations = AppLocalizations.of(context)!;
  return [
    AppButton.outline(
      label: localizations.cancel,
      onPressed: () {
        notifier.reset();
        context.pop();
      },
    ),
    if (state.currentStep != LeaveRequestStep.leaveDetails) ...[
      Gap(8.w),
      AppButton.outline(label: localizations.previous, onPressed: () => notifier.previousStep()),
    ],
  ];
}

List<Widget> buildNewLeaveRequestFooterRightActions(
  BuildContext context,
  NewLeaveRequestState state,
  NewLeaveRequestNotifier notifier,
) {
  final localizations = AppLocalizations.of(context)!;

  Future<void> onSaveAsDraft() async {
    final result = await notifier.saveAsDraft();
    if (!context.mounted) return;
    if (result.isSuccess) {
      ToastService.success(context, localizations.draftSaved);
      notifier.reset();
      context.pop();
    } else {
      ToastService.error(context, result.errorMessage ?? '');
    }
  }

  Future<void> onSubmit() async {
    final result = await notifier.submit();
    if (!context.mounted) return;
    if (result.isSuccess) {
      ToastService.success(context, localizations.submitRequest);
      notifier.reset();
      context.pop();
    } else {
      ToastService.error(context, result.errorMessage ?? '');
    }
  }

  return [
    AppButton.outline(
      label: localizations.saveAsDraft,
      isLoading: state.isSavingDraft,
      onPressed: state.isSavingDraft || state.isSubmitting ? null : onSaveAsDraft,
    ),
    Gap(8.w),
    if (state.currentStep != LeaveRequestStep.documentsReview)
      AppButton(
        label: localizations.next,
        onPressed: state.isSavingDraft
            ? null
            : () {
                if (state.currentStep == LeaveRequestStep.contactNotes && !state.canProceedToNextStep()) {
                  ToastService.error(context, localizations.addEmployeeFillRequiredFields);
                  return;
                }
                notifier.nextStep();
              },
        type: AppButtonType.primary,
      )
    else
      AppButton(
        label: localizations.submitRequest,
        isLoading: state.isSubmitting,
        onPressed: (state.isSubmitting || state.isSavingDraft) ? null : onSubmit,
        type: AppButtonType.primary,
        backgroundColor: AppColors.greenButton,
        svgPath: Assets.icons.checkIconGreen.path,
      ),
  ];
}
