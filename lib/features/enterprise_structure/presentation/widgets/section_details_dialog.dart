import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/section.dart';
import 'package:flutter/material.dart';

class SectionDetailsDialog extends StatelessWidget {
  final SectionOverview section;

  const SectionDetailsDialog({
    super.key,
    required this.section,
  });

  static void show(BuildContext context, SectionOverview section) {
    showDialog(
      context: context,
      builder: (context) => SectionDetailsDialog(section: section),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.sectionDetails),
      content: Text('Section: ${section.name}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.close),
        ),
      ],
    );
  }
}

