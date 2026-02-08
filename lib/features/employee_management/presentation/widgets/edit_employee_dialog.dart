import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_stepper_dialog_label_below.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_dialog_flow_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_editing_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/address_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/assignment_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/basic_info_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/banking_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/compensation_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/demographics_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/documents_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/review_step.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/work_schedule_step.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEmployeeDialog extends ConsumerWidget {
  const EditEmployeeDialog({super.key});

  static Future<void> show(BuildContext context, String employeeGuid) {
    final container = ProviderScope.containerOf(context);
    container.read(addEmployeeDialogFlowProvider).clearForm();
    container.read(addEmployeeEditingEmployeeIdProvider.notifier).state = employeeGuid;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EditEmployeeDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final preloadAsync = ref.watch(addEmployeeEditPreloadProvider);
    final stepperState = ref.watch(addEmployeeStepperProvider);
    final basicInfoState = ref.watch(addEmployeeBasicInfoProvider);
    final flow = ref.watch(addEmployeeDialogFlowProvider);
    final isPreloadLoading = preloadAsync.isLoading;
    final preloadError = preloadAsync.hasError ? preloadAsync.error : null;

    final em = Assets.icons.employeeManagement;
    final stepperSteps = [
      StepperStepConfig(assetPath: em.basicInfo.path, label: localizations.addEmployeeStepBasicInfo),
      StepperStepConfig(assetPath: em.demographics.path, label: localizations.addEmployeeStepDemographics),
      StepperStepConfig(assetPath: Assets.icons.homeIcon.path, label: localizations.addEmployeeStepAddress),
      StepperStepConfig(assetPath: em.assignment.path, label: localizations.addEmployeeStepAssignmentInfo),
      StepperStepConfig(
        assetPath: Assets.icons.timeManagementMainIcon.path,
        label: localizations.addEmployeeStepWorkSchedule,
      ),
      StepperStepConfig(assetPath: em.compensation.path, label: localizations.addEmployeeStepCompensation),
      StepperStepConfig(assetPath: em.banking.path, label: localizations.addEmployeeStepBanking),
      StepperStepConfig(assetPath: em.document.path, label: localizations.addEmployeeStepDocuments),
      StepperStepConfig(assetPath: Assets.icons.checkIconGreen.path, label: localizations.addEmployeeStepReview),
    ];

    Widget content = AppStepperDialogLabelBelow(
      title: localizations.editEmployee,
      subtitle: localizations.addEmployeeStepSubtitle(stepperState.currentStepIndex + 1),
      content: _buildStepContent(stepperState.currentStepIndex),
      stepperSteps: stepperSteps,
      contentPadding: EdgeInsets.all(20.w),
      currentStepIndex: stepperState.currentStepIndex,
      maxWidth: 1200.w,
      isLoading: isPreloadLoading,
      onClose: () => flow.close(context),
      footerLeftActions: stepperState.canGoPrevious
          ? [AppButton.outline(label: localizations.previous, onPressed: flow.goPrevious)]
          : null,
      footerActions: stepperState.isLastStep
          ? [
              AppButton.primary(
                label: localizations.saveChanges,
                isLoading: basicInfoState.isSubmitting,
                onPressed: () => flow.saveAndClose(context),
              ),
            ]
          : [AppButton.primary(label: localizations.next, onPressed: () => flow.goNext(context))],
    );

    if (preloadError != null) {
      content = Stack(
        children: [
          content,
          Positioned.fill(
            child: Container(
              color: Colors.black26,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Text(
                    preloadError.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }

  static Widget _buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return const AddEmployeeBasicInfoStep();
      case 1:
        return const AddEmployeeDemographicsStep();
      case 2:
        return const AddEmployeeAddressStep();
      case 3:
        return const AddEmployeeAssignmentStep();
      case 4:
        return const AddEmployeeWorkScheduleStep();
      case 5:
        return const AddEmployeeCompensationStep();
      case 6:
        return const AddEmployeeBankingStep();
      case 7:
        return const AddEmployeeDocumentsStep();
      case 8:
        return const AddEmployeeReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }
}
