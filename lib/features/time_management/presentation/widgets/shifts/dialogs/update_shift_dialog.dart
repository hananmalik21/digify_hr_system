import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart' show AppButton, AppButtonType;
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/update_shift_form_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/dialogs/widgets/update_shift_form_content.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateShiftDialog extends ConsumerStatefulWidget {
  final ShiftOverview shift;

  const UpdateShiftDialog({super.key, required this.shift});

  static Future<void> show(BuildContext context, ShiftOverview shift) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateShiftDialog(shift: shift),
    );
  }

  @override
  ConsumerState<UpdateShiftDialog> createState() => _UpdateShiftDialogState();
}

class _UpdateShiftDialogState extends ConsumerState<UpdateShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _durationController;
  late final TextEditingController _breakDurationController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.shift.code);
    _nameEnController = TextEditingController(text: widget.shift.name);
    _nameArController = TextEditingController(text: widget.shift.nameAr);
    _durationController = TextEditingController(text: widget.shift.totalHours.toStringAsFixed(1));
    _breakDurationController = TextEditingController(text: widget.shift.breakHours.toString());
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _durationController.dispose();
    _breakDurationController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final formNotifier = ref.read(updateShiftFormProvider(widget.shift).notifier);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!formNotifier.validate()) {
      ToastService.error(context, 'Please fill in all required fields');
      return;
    }

    // Update shift
    final updatedShift = await formNotifier.updateShift();

    if (!mounted) return;

    if (updatedShift != null) {
      ToastService.success(context, 'Shift updated successfully', title: 'Success');
      Navigator.of(context).pop();
    } else {
      final errorMessage = ref.read(updateShiftFormProvider(widget.shift)).errorMessage;
      if (errorMessage != null) {
        ToastService.error(context, errorMessage, title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(updateShiftFormProvider(widget.shift));

    return AppDialog(
      title: 'Update Shift',
      width: 800.w,
      content: UpdateShiftFormContent(
        formKey: _formKey,
        shift: widget.shift,
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
          width: null,
          onPressed: formState.isLoading ? null : () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 12.w),
        AppButton(
          label: 'Update Shift',
          svgPath: Assets.icons.saveIcon.path,
          width: null,
          onPressed: formState.isLoading ? null : _handleUpdate,
          isLoading: formState.isLoading,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
