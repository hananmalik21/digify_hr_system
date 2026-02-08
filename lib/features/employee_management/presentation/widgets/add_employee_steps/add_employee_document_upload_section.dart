import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_documents_provider.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/document_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeDocumentUploadSection extends ConsumerStatefulWidget {
  const AddEmployeeDocumentUploadSection({super.key});

  @override
  ConsumerState<AddEmployeeDocumentUploadSection> createState() => _AddEmployeeDocumentUploadSectionState();
}

class _AddEmployeeDocumentUploadSectionState extends ConsumerState<AddEmployeeDocumentUploadSection> {
  Future<void> _pickFile() async {
    final documentRepository = ref.read(documentRepositoryProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    try {
      final doc = await documentRepository.pickFile();
      if (!mounted) return;
      if (doc != null) {
        notifier.setDocument(doc);
        ToastService.success(context, 'Document added');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeDocumentsProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.supportingDocuments,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(8.h),
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(14.r),
          child: SizedBox(
            width: double.infinity,
            child: DashedBorder(
              color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
              strokeWidth: 2,
              dashLength: 4,
              gapLength: 4,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: BoxDecoration(color: AppColors.infoBg, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: DigifyAsset(
                        assetPath: Assets.icons.bulkUploadIconFigma.path,
                        color: AppColors.primary,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      localizations.clickToUploadOrDragDrop,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      localizations.pdfDocDocxJpgPngUpTo10MB,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (state.document != null) ...[
          Gap(16.h),
          _DocumentTypeDropdown(
            value: state.documentTypeCode ?? 'PASSPORT',
            onChanged: (v) => notifier.setDocumentTypeCode(v),
            isDark: isDark,
          ),
          Gap(12.h),
          _UploadedDocumentItem(document: state.document!, onRemove: () => notifier.setDocument(null)),
        ],
      ],
    );
  }
}

class _DocumentTypeDropdown extends StatelessWidget {
  const _DocumentTypeDropdown({required this.value, required this.onChanged, required this.isDark});

  final String value;
  final ValueChanged<String?> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: documentTypeCodeOptions.contains(value) ? value : documentTypeCodeOptions.first,
      decoration: InputDecoration(
        labelText: 'Document type',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      dropdownColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      items: documentTypeCodeOptions.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

class _UploadedDocumentItem extends StatelessWidget {
  const _UploadedDocumentItem({required this.document, required this.onRemove});

  final Document document;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  document.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.h),
                Text(
                  document.formattedSize,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(8.r)),
              child: Icon(Icons.close, size: 18.sp, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
