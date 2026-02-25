import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../../core/theme/app_shadows.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../enterprise_structure/domain/models/structure_list_item.dart';
import '../../../../domain/models/overtime/overtime_record.dart';
import 'overtime_table_header.dart';
import 'overtime_table_row.dart';
import 'overtime_table_skeleton.dart';

class OvertimeTable extends StatelessWidget {
  final AppLocalizations localizations;
  final List<OvertimeRecord> records;
  final bool isDark;
  final bool isLoading;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(OvertimeRecord) onView;
  final Function(OvertimeRecord) onEdit;
  final Function(OvertimeRecord) onDelete;
  final bool? paginationIsLoading;

  const OvertimeTable({
    super.key,
    required this.localizations,
    required this.records,
    required this.isDark,
    this.isLoading = false,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.paginationIsLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Skeletonizer(
                enabled: isLoading,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OvertimeTableHeader(
                      isDark: isDark,
                      localizations: localizations,
                    ),

                    if (isLoading && records.isEmpty)
                      OvertimeTableSkeleton(localizations: localizations)
                    else if (records.isEmpty && !isLoading)
                      SizedBox(
                        width: context.screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.h),
                          child: Center(
                            child: Text(
                              localizations.noResultsFound,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ...records.map(
                        (record) => OvertimeTableRow(
                          record: record,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                          onDelete: onDelete,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // if (paginationInfo != null) ...[
          //   PaginationControls.fromPaginationInfo(
          //     paginationInfo: paginationInfo!,
          //     currentPage: currentPage,
          //     pageSize: pageSize,
          //     onPrevious: onPrevious,
          //     onNext: onNext,
          //     isLoading: paginationIsLoading ?? isLoading,
          //     style: PaginationStyle.simple,
          //   ),
          // ],
        ],
      ),
    );
  }
}
