import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:flutter/material.dart';

class AddSectionDialog extends StatelessWidget {
  final bool isEditMode;
  final Map<String, dynamic>? initialData;

  const AddSectionDialog({
    super.key,
    this.isEditMode = false,
    this.initialData,
  });

  static void show(BuildContext context, {bool isEditMode = false, Map<String, dynamic>? initialData}) {
    showDialog(
      context: context,
      builder: (context) => AddSectionDialog(
        isEditMode: isEditMode,
        initialData: initialData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // TODO: Implement AddSectionDialog UI
    return AlertDialog(
      title: Text(isEditMode ? localizations.editSection : localizations.addSection),
      content: const Text('Section dialog UI coming soon'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancel),
        ),
      ],
    );
  }
}

