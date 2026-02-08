import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/presentation/models/employee_detail_document_display.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/employee_detail/employee_detail_document_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentsBankingTabContent extends StatelessWidget {
  const DocumentsBankingTabContent({super.key, required this.isDark, this.fullDetails, this.wrapInScrollView = true});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final items = EmployeeDetailDocumentDisplay.fromFullDetails(fullDetails);
    final documentIconPath = Assets.icons.employeeManagement.document.path;

    if (items.isEmpty) {
      final content = Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.noDocumentsAvailable,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
      if (wrapInScrollView) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: content,
        );
      }
      return content;
    }

    final List<Widget> cardRows = [];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      cardRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EmployeeDetailDocumentCard(
                title: left.title,
                iconPath: documentIconPath,
                statusLabel: left.status,
                number: left.fileName,
                expiryDate: left.expiryDate,
                isDark: isDark,
                firstFieldLabel: left.firstFieldLabel,
                accessUrl: left.accessUrl,
              ),
            ),
            if (right != null) ...[
              Gap(12.w),
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: right.title,
                  iconPath: documentIconPath,
                  statusLabel: right.status,
                  number: right.fileName,
                  expiryDate: right.expiryDate,
                  isDark: isDark,
                  firstFieldLabel: right.firstFieldLabel,
                  accessUrl: right.accessUrl,
                ),
              ),
            ],
          ],
        ),
      );
      if (i + 2 < items.length) cardRows.add(Gap(12.h));
    }

    final content = Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: cardRows),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
