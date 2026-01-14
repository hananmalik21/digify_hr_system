import 'dart:io';
import 'dart:math' as math;
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:file_picker/file_picker.dart';

class DocumentsReviewStep extends StatefulWidget {
  final VoidCallback onSubmit;

  const DocumentsReviewStep({
    super.key,
    required this.onSubmit,
  });

  @override
  State<DocumentsReviewStep> createState() => _DocumentsReviewStepState();
}

class _DocumentsReviewStepState extends State<DocumentsReviewStep> {
  List<File> _selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles = result.files
            .where((file) => file.path != null && file.path!.isNotEmpty)
            .map((file) => File(file.path!))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(top: 32.h, start: 0, end: 0, bottom: 0),
      child: SizedBox(
        width: 832.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Supporting Documents
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.supportingDocuments,
                style: TextStyle(
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.8,
                ),
              ),
              Gap(8.h),
              GestureDetector(
                onTap: _pickFiles,
                child: _DashedBorder(
                  color: const Color(0xFFD1D5DC),
                  strokeWidth: 2,
                  dashLength: 5,
                  gapLength: 3,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.all(26.w),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: DigifyAsset(
                            assetPath: Assets.icons.uploadDropIcon.path,
                            width: 32,
                            height: 32,
                            color: AppColors.primary,
                          ),
                        ),
                        Gap(8.h),
                        Text(
                          localizations.clickToUploadOrDragDrop,
                          style: TextStyle(
                            fontSize: 13.8.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                            height: 20 / 13.8,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          localizations.pdfDocDocxJpgPngUpTo10MB,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6A7282),
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(12.h),
              Container(
                padding: EdgeInsets.all(13.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFCE8),
                  border: Border.all(color: const Color(0xFFFFF085), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.requiredDocuments,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF894B00),
                        height: 16 / 12,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      '• ${localizations.supportingDocumentsIfApplicable}',
                      style: TextStyle(
                        fontSize: 11.8.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFA65F00),
                        height: 16 / 11.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(24.h),
          // Request Summary
          Container(
            padding: EdgeInsetsDirectional.only(top: 25.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.infoIconGreen.path,
                      width: 20,
                      height: 20,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                    ),
                    Gap(8.w),
                    Text(
                      localizations.requestSummary,
                      style: TextStyle(
                        fontSize: 15.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                        height: 24 / 15.5,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  height: 152.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Stack(
                    children: [
                      // Row 1 - Employee and Leave Type
                      Positioned(
                        left: 0,
                        right: 408.w,
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.employee,
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 11.8,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              localizations.notSelected,
                              style: TextStyle(
                                fontSize: 15.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 408.w,
                        right: 0,
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.leaveType,
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 11.8,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              'annual',
                              style: TextStyle(
                                fontSize: 15.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row 2 - Start Date and End Date
                      Positioned(
                        left: 0,
                        right: 408.w,
                        top: 56.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.startDate,
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 11.8,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              '21/02/2025',
                              style: TextStyle(
                                fontSize: 15.1.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 408.w,
                        right: 0,
                        top: 56.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.endDate,
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 11.8,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              '22/02/2025',
                              style: TextStyle(
                                fontSize: 15.1.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row 3 - Duration and Attachments
                      Positioned(
                        left: 0,
                        right: 408.w,
                        top: 112.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.duration,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 12,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              '2 Days',
                              style: TextStyle(
                                fontSize: 15.4.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 408.w,
                        right: 0,
                        top: 112.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.attachments,
                              style: TextStyle(
                                fontSize: 11.8.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                                height: 16 / 11.8,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              '${_selectedFiles.length} ${_selectedFiles.length == 1 ? 'file' : 'files'}',
                              style: TextStyle(
                                fontSize: 15.6.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                height: 24 / 15.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
          // Declaration
          Container(
            padding: EdgeInsets.all(17.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBEDBFF), width: 1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 2.h),
                  child: DigifyAsset(
                    assetPath: Assets.icons.infoIconGreen.path,
                    width: 20,
                    height: 20,
                    color: const Color(0xFF193CB8),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.declaration,
                        style: TextStyle(
                          fontSize: 13.8.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF193CB8),
                          height: 20 / 13.8,
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        localizations.declarationText,
                        style: TextStyle(
                          fontSize: 11.8.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1447E6),
                          height: 16 / 11.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _DashedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  const _DashedBorder({
    required this.child,
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(borderRadius: borderRadius, child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final BorderRadius borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = math.min(metric.length, distance + dashLength);
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.gapLength != gapLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
