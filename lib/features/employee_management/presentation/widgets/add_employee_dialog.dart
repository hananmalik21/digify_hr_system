import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_stepper_dialog_label_below.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/basic_info_step.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeDialog extends ConsumerWidget {
  const AddEmployeeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddEmployeeDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(addEmployeeStepperProvider);
    final notifier = ref.read(addEmployeeStepperProvider.notifier);

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

    final subtitle = localizations.addEmployeeStepSubtitle(state.currentStepIndex + 1);

    return AppStepperDialogLabelBelow(
      title: localizations.addNewEmployee,
      subtitle: subtitle,
      content: _buildStepContent(state.currentStepIndex),
      stepperSteps: stepperSteps,
      contentPadding: EdgeInsets.all(20.w),
      currentStepIndex: state.currentStepIndex,
      maxWidth: 1200.w,
      onClose: () {
        notifier.reset();
        context.pop();
      },
      footerLeftActions: state.canGoPrevious
          ? [AppButton.outline(label: localizations.previous, onPressed: () => notifier.previousStep())]
          : null,
      footerActions: [
        if (state.isLastStep)
          AppButton.primary(
            label: localizations.saveChanges,
            onPressed: () {
              notifier.reset();
              context.pop();
            },
          )
        else
          AppButton.primary(label: localizations.next, onPressed: () => notifier.nextStep()),
      ],
    );
  }

  Widget _buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return const AddEmployeeBasicInfoStep();
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        return const _PlaceholderStepContent();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _PlaceholderStepContent extends StatelessWidget {
  const _PlaceholderStepContent();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Text(localizations.addEmployeeStepContentPlaceholder, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
