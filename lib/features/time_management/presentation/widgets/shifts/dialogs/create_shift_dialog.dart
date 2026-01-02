import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart' show AppButton, AppButtonType;
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shift_form_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_form_content.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateShiftDialog extends ConsumerStatefulWidget {
  const CreateShiftDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, barrierDismissible: false, builder: (context) => const CreateShiftDialog());
  }

  @override
  ConsumerState<CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends ConsumerState<CreateShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameArController = TextEditingController();
  final _durationController = TextEditingController();
  final _breakDurationController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _durationController.dispose();
    _breakDurationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final formNotifier = ref.read(shiftFormProvider.notifier);
    final shiftsNotifier = ref.read(shiftsNotifierProvider.notifier);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formNotifier.validate()) {
      ToastService.error(context, 'Please fill in all required fields');
      return;
    }

    // Create shift
    final createdShift = await formNotifier.createShift();

    if (!mounted) return;

    if (createdShift != null) {
      // Optimistically add to list
      shiftsNotifier.addShiftOptimistically(createdShift);

      // Show success message
      ToastService.success(context, 'Shift created successfully', title: 'Success');

      // Close dialog
      Navigator.of(context).pop();
    } else {
      // Error is already handled in the provider
      final errorMessage = ref.read(shiftFormProvider).errorMessage;
      if (errorMessage != null) {
        ToastService.error(context, errorMessage, title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(shiftFormProvider);

    return AppDialog(
      title: 'Create New Shift',
      width: 800.w,
      content: ShiftFormContent(
        formKey: _formKey,
        codeController: _codeController,
        nameEnController: _nameEnController,
        nameArController: _nameArController,
        durationController: _durationController,
        breakDurationController: _breakDurationController,
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          type: AppButtonType.outline,
          onPressed: formState.isLoading
              ? null
              : () {
                  ref.read(shiftFormProvider.notifier).reset();
                  Navigator.of(context).pop();
                },
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Create Shift',
          svgPath: Assets.icons.saveIcon.path,
          onPressed: formState.isLoading ? null : _handleCreate,
          isLoading: formState.isLoading,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
