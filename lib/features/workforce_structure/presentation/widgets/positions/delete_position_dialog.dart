import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletePositionDialog extends ConsumerStatefulWidget {
  final Position position;

  const DeletePositionDialog({super.key, required this.position});

  static Future<void> show(BuildContext context, {required Position position}) {
    return showDialog(
      context: context,
      builder: (_) => DeletePositionDialog(position: position),
    );
  }

  @override
  ConsumerState<DeletePositionDialog> createState() => _DeletePositionDialogState();
}

class _DeletePositionDialogState extends ConsumerState<DeletePositionDialog> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);

    try {
      await ref.read(positionNotifierProvider.notifier).deletePosition(widget.position.id);

      if (mounted) {
        Navigator.of(context).pop();
        ToastService.success(context, 'Position deleted successfully', title: 'Deleted');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        Navigator.of(context).pop();
        ToastService.error(context, 'Failed to delete position: ${e.toString()}', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppConfirmationDialog.delete(
      title: localizations?.delete ?? 'Delete Position',
      message: 'Are you sure you want to delete this position? This action cannot be undone.',
      itemName: widget.position.titleEnglish,
      confirmLabel: localizations?.delete ?? 'Delete',
      cancelLabel: localizations?.cancel ?? 'Cancel',
      isLoading: _isDeleting,
      onConfirm: _handleDelete,
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}
