import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContactNotesStep extends StatefulWidget {
  final VoidCallback onStepComplete;

  const ContactNotesStep({
    super.key,
    required this.onStepComplete,
  });

  @override
  State<ContactNotesStep> createState() => _ContactNotesStepState();
}

class _ContactNotesStepState extends State<ContactNotesStep> {
  final _reasonController = TextEditingController();
  final _workDelegatedController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _workDelegatedController.dispose();
    _addressController.dispose();
    _contactPhoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
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
          // Reason for Leave
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: localizations.reasonForLeave,
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                      ),
                    ),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
              Gap(8.h),
              Container(
                padding: EdgeInsetsDirectional.only(start: 17.w, end: 17.w, top: 13.h, bottom: 85.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D5DC),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: TextField(
                  controller: _reasonController,
                  maxLines: null,
                  maxLength: 500,
                  style: TextStyle(
                    fontSize: 15.1.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    height: 24 / 15.1,
                  ),
                  decoration: InputDecoration(
                    hintText: localizations.pleaseProvideDetailedReason,
                    hintStyle: TextStyle(
                      fontSize: 15.1.sp,
                      color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              Gap(2.h),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 2.h),
                child: Text(
                  '${_reasonController.text.length}/500 characters',
                  style: TextStyle(
                    fontSize: 11.8.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6A7282),
                    height: 16 / 11.8,
                  ),
                ),
              ),
            ],
          ),
          Gap(24.h),
          // Work Delegated To
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.workDelegatedTo,
                style: TextStyle(
                  fontSize: 13.7.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                  height: 20 / 13.7,
                ),
              ),
              Gap(8.h),
              Container(
                padding: EdgeInsetsDirectional.only(start: 17.w, end: 17.w, top: 9.h, bottom: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD1D5DC), width: 1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.searchIcon.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                    ),
                    Gap(8.w),
                    Expanded(
                      child: TextField(
                        controller: _workDelegatedController,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: localizations.selectColleagueToHandleWork,
                          hintStyle: TextStyle(
                            fontSize: 15.3.sp,
                            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsetsDirectional.only(top: 2.5.h, bottom: 2.5.h),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    DigifyAsset(
                      assetPath: Assets.icons.workforce.chevronDown.path,
                      width: 18,
                      height: 18,
                      color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            localizations.selectColleagueWhoWillHandle,
            style: TextStyle(
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6A7282),
              height: 16 / 11.8,
            ),
          ),
          Gap(24.h),
          // Contact Information Section
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
                      localizations.contactInformationDuringLeave,
                      style: TextStyle(
                        fontSize: 15.4.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                        height: 24 / 15.4,
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                // Address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.addressDuringLeave,
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                        height: 20 / 13.7,
                      ),
                    ),
                    Gap(8.h),
                    Container(
                      padding: EdgeInsetsDirectional.only(start: 17.w, end: 17.w, top: 13.h, bottom: 37.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD1D5DC),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: TextField(
                        controller: _addressController,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          height: 24 / 15.3,
                        ),
                        decoration: InputDecoration(
                          hintText: localizations.enterAddressOrLocation,
                          hintStyle: TextStyle(
                            fontSize: 15.3.sp,
                            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                // Phone and Emergency Name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: localizations.contactPhoneNumber,
                              style: TextStyle(
                                fontSize: 13.8.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                              ),
                            ),
                          ),
                          Gap(8.h),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 15.5.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: TextField(
                              controller: _contactPhoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: '+965 XXXX XXXX',
                                hintStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: localizations.emergencyContactName,
                              style: TextStyle(
                                fontSize: 13.8.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                              ),
                            ),
                          ),
                          Gap(8.h),
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 15.5.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: TextField(
                              controller: _emergencyNameController,
                              style: TextStyle(
                                fontSize: 15.3.sp,
                                fontWeight: FontWeight.w400,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: localizations.enterEmergencyContactName,
                                hintStyle: TextStyle(
                                  fontSize: 15.3.sp,
                                  color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(16.h),
                // Emergency Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.emergencyContactPhone,
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                        height: 20 / 13.7,
                      ),
                    ),
                    Gap(8.h),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 17.w, vertical: 15.5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD1D5DC),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: TextField(
                        controller: _emergencyPhoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: '+965 XXXX XXXX',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(24.h),
          // Additional Notes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 6.h),
                child: Text(
                  localizations.additionalNotes,
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF364153),
                    height: 20 / 13.7,
                  ),
                ),
              ),
              Gap(8.h),
              Container(
                padding: EdgeInsetsDirectional.only(start: 17.w, end: 17.w, top: 13.h, bottom: 61.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD1D5DC),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: TextField(
                  controller: _additionalNotesController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 15.3.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    height: 24 / 15.3,
                  ),
                  decoration: InputDecoration(
                    hintText: localizations.anyAdditionalInformation,
                    hintStyle: TextStyle(
                      fontSize: 15.3.sp,
                      color: const Color(0xFF0A0A0A).withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
