import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DocumentsReviewStep extends ConsumerWidget {
  const DocumentsReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentsSection(context, localizations, isDark, state, notifier),
        Gap(24.h),
        _buildRequestSummary(context, localizations, isDark, state),
        Gap(24.h),
        _buildDeclaration(context, localizations, isDark),
      ],
    );
  }

  Widget _buildDocumentsSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.supportingDocuments,
          style: context.textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: double.infinity,
            child: DashedBorder(
              color: AppColors.borderGrey,
              strokeWidth: 2,
              dashLength: 8,
              gapLength: 4,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(26.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(color: AppColors.infoBg, shape: BoxShape.circle),
                      child: Icon(Icons.cloud_upload_outlined, size: 32.sp, color: AppColors.primary),
                    ),
                    Gap(8.h),
                    Text(
                      localizations.clickToUploadOrDragDrop,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      localizations.pdfDocDocxJpgPngUpTo10MB,
                      style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gap(8.h),
        Container(
          width: double.infinity,

          padding: EdgeInsets.all(13.w),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            border: Border.all(color: AppColors.warningBorder),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.requiredDocuments,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.warningText,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(4.h),
              Text(
                localizations.supportingDocumentsIfApplicable,
                style: context.textTheme.bodySmall?.copyWith(color: AppColors.yellowSubtitle, fontSize: 11.8.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestSummary(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.summarize, size: 20.sp, color: AppColors.textPrimary),
                  Gap(8.w),
                  Text(
                    localizations.requestSummary,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBackgroundGrey,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.employee,
                            state.selectedEmployeeName ?? localizations.notSelected,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.leaveType,
                            state.leaveType != null
                                ? LeaveTypeMapper.getShortLabel(state.leaveType!)
                                : localizations.notSelected,
                          ),
                        ),
                      ],
                    ),
                    Gap(16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.startDate,
                            state.startDate != null
                                ? DateFormat('dd/MM/yyyy').format(state.startDate!)
                                : localizations.notSelected,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.endDate,
                            state.endDate != null
                                ? DateFormat('dd/MM/yyyy').format(state.endDate!)
                                : localizations.notSelected,
                          ),
                        ),
                      ],
                    ),
                    Gap(16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.duration,
                            '${state.totalDays} ${localizations.days}',
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            context,
                            localizations.attachments,
                            localizations.filesCount(state.documentPaths?.length ?? 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontSize: 11.8.sp),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDeclaration(BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        border: Border.all(color: AppColors.infoBorder),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(Icons.info_outline, size: 20.sp, color: AppColors.infoText),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.declaration,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.infoText,
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  localizations.declarationText,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.infoTextSecondary,
                    fontSize: 11.8.sp,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
