import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart' show AppButton, AppButtonType;
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/dialogs/steps/leave_details_step.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/dialogs/steps/contact_notes_step.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/leave_management/dialogs/steps/documents_review_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewLeaveRequestDialog extends StatefulWidget {
  const NewLeaveRequestDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const NewLeaveRequestDialog(),
    );
  }

  @override
  State<NewLeaveRequestDialog> createState() => _NewLeaveRequestDialogState();
}

class _NewLeaveRequestDialogState extends State<NewLeaveRequestDialog> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _goToStep(_currentStep + 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleSubmit() {
    // Close dialog after submission
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: 900.w, maxHeight: 800.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              _buildHeader(context, localizations, isDark),
              // Content area
              Flexible(
                child: Container(
                  padding: EdgeInsetsDirectional.only(top: 32.h),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LeaveDetailsStep(
                        onStepComplete: _nextStep,
                      ),
                      ContactNotesStep(
                        onStepComplete: _nextStep,
                      ),
                      DocumentsReviewStep(
                        onSubmit: _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
              // Footer
              _buildFooter(context, localizations, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      padding: EdgeInsetsDirectional.all(24.w),
      child: Column(
        children: [
          // Title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.newLeaveRequest,
                      style: TextStyle(
                        fontSize: 22.9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 32 / 22.9,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      localizations.completeAllStepsToSubmit,
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFDBEAFE),
                        height: 20 / 13.6,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleCancel,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.closeIcon.path,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Step indicator
          _buildStepIndicator(context, localizations),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, AppLocalizations localizations) {
    return Row(
      children: [
        // Step 1: Leave Details
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: DigifyAsset(
                        assetPath: Assets.icons.infoIconGreen.path,
                        width: 20,
                        height: 20,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Leave',
                          style: TextStyle(
                            fontSize: 13.9.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 20 / 13.9,
                          ),
                        ),
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 13.9.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 20 / 13.9,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 2.h,
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Step 2: Contact & Notes
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: _currentStep >= 1 ? Colors.white : Colors.transparent,
                        border: Border.all(
                          color: _currentStep >= 1 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(2.w),
                      child: DigifyAsset(
                        assetPath: Assets.icons.infoIconGreen.path,
                        width: 20,
                        height: 20,
                        color: _currentStep >= 1 ? const Color(0xFF2563EB) : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Contact &',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: _currentStep >= 1 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                            height: 20 / 14,
                          ),
                        ),
                        Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: _currentStep >= 1 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 2.h,
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: _currentStep >= 2 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Step 3: Documents & Review
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: _currentStep >= 2 ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: _currentStep >= 2 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(2.w),
                child: DigifyAsset(
                  assetPath: Assets.icons.infoIconGreen.path,
                  width: 20,
                  height: 20,
                  color: _currentStep >= 2 ? const Color(0xFF2563EB) : Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Gap(12.w),
              Text(
                localizations.documentsAndReview,
                style: TextStyle(
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w500,
                  color: _currentStep >= 2 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  height: 20 / 13.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 32.w, end: 32.w, top: 25.h, bottom: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button (disabled on first step)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _currentStep > 0 ? _previousStep : null,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Text(
                  localizations.previous,
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w500,
                    color: _currentStep > 0
                        ? const Color(0xFF364153)
                        : const Color(0xFF99A1AF),
                    height: 24 / 15.5,
                  ),
                ),
              ),
            ),
          ),
          // Cancel and Next/Submit buttons
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleCancel,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 25.w, vertical: 13.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DC), width: 1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      localizations.cancel,
                      style: TextStyle(
                        fontSize: 15.4.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0A0A0A),
                        height: 24 / 15.4,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.w),
              if (_currentStep < 2)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _nextStep,
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        localizations.next,
                        style: TextStyle(
                          fontSize: 15.4.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 24 / 15.4,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleSubmit,
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A63E),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.checkIconGreen.path,
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                          Gap(8.w),
                          Text(
                            localizations.submitRequest,
                            style: TextStyle(
                              fontSize: 15.5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 24 / 15.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
