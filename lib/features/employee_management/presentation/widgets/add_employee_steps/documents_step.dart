import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/add_employee_document_upload_section.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/document_expiry_dates_module.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeDocumentsStep extends ConsumerWidget {
  const AddEmployeeDocumentsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.document.path,
          title: localizations.documentsAndCompliance,
          subtitle: localizations.documentsAndComplianceSubtitle,
        ),
        const DocumentExpiryDatesModule(),
        const AddEmployeeDocumentUploadSection(),
      ],
    );
  }
}
