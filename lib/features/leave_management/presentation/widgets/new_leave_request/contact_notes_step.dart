import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContactNotesStep extends ConsumerStatefulWidget {
  const ContactNotesStep({super.key});

  @override
  ConsumerState<ContactNotesStep> createState() => _ContactNotesStepState();
}

class _ContactNotesStepState extends ConsumerState<ContactNotesStep> {
  final _reasonController = TextEditingController();
  final _delegatedToController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _delegatedToController.dispose();
    _addressController.dispose();
    _contactPhoneController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReasonField(localizations, isDark, state, notifier),
        Gap(24.h),
        _buildDelegatedToField(localizations, isDark, state, notifier),
        Gap(24.h),
        _buildContactInformationSection(localizations, isDark, state, notifier),
        Gap(24.h),
        _buildAdditionalNotesField(localizations, isDark, state, notifier),
      ],
    );
  }

  Widget _buildReasonField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.reasonForLeave,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.6.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextArea(
          controller: _reasonController,
          hintText: localizations.pleaseProvideDetailedReason,
          maxLines: 6,
          minLines: 6,
          onChanged: (value) => notifier.setReason(value),
        ),
        Gap(2.h),
        Text(
          localizations.charactersCount(_reasonController.text.length),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6A7282), fontSize: 11.8.sp),
        ),
      ],
    );
  }

  Widget _buildDelegatedToField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    if (state.delegatedToEmployeeName != null) {
      _delegatedToController.text = state.delegatedToEmployeeName!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.workDelegatedTo,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _delegatedToController,
          hintText: localizations.selectColleagueToHandleWork,
          filled: true,
          fillColor: Colors.white,
          borderColor: const Color(0xFFD1D5DC),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 17.w, end: 8.w),
            child: DigifyAsset(
              assetPath: Assets.icons.searchIcon.path,
              width: 18,
              height: 18,
              color: AppColors.textMuted,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsetsDirectional.only(end: 17.w),
            child: DigifyAsset(
              assetPath: Assets.icons.dropdownArrowIcon.path,
              width: 18,
              height: 18,
              color: AppColors.textMuted,
            ),
          ),
          readOnly: true,
          onTap: () {
            // TODO: Open employee selection dialog
            notifier.setDelegatedTo(2, 'Jane Smith');
            _delegatedToController.text = 'Jane Smith';
          },
        ),
        Gap(2.h),
        Text(
          localizations.selectColleagueWhoWillHandle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF6A7282), fontSize: 11.8.sp),
        ),
      ],
    );
  }

  Widget _buildContactInformationSection(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone, size: 20.sp, color: const Color(0xFF101828)),
                  Gap(8.w),
                  Text(
                    localizations.contactInformationDuringLeave,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF101828),
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              _buildAddressField(localizations, isDark, state, notifier),
              Gap(16.h),
              Row(
                children: [
                  Expanded(child: _buildContactPhoneField(localizations, isDark, state, notifier)),
                  Gap(16.w),
                  Expanded(child: _buildEmergencyContactNameField(localizations, isDark, state, notifier)),
                ],
              ),
              Gap(16.h),
              _buildEmergencyContactPhoneField(localizations, isDark, state, notifier),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.addressDuringLeave,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextArea(
          controller: _addressController,
          hintText: localizations.enterAddressOrLocation,
          maxLines: 6,
          minLines: 6,
          onChanged: (value) => notifier.setAddressDuringLeave(value),
        ),
      ],
    );
  }

  Widget _buildContactPhoneField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.contactPhoneNumber,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _contactPhoneController,
          hintText: '+965 XXXX XXXX',
          keyboardType: TextInputType.phone,
          borderColor: const Color(0xFFD1D5DC),
          onChanged: (value) => notifier.setContactPhoneNumber(value),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactNameField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.emergencyContactName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _emergencyContactNameController,
          hintText: localizations.enterEmergencyContactName,
          borderColor: const Color(0xFFD1D5DC),
          onChanged: (value) => notifier.setEmergencyContactName(value),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactPhoneField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.emergencyContactPhone,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _emergencyContactPhoneController,
          hintText: '+965 XXXX XXXX',
          keyboardType: TextInputType.phone,
          borderColor: const Color(0xFFD1D5DC),
          onChanged: (value) => notifier.setEmergencyContactPhone(value),
        ),
      ],
    );
  }

  Widget _buildAdditionalNotesField(
    AppLocalizations localizations,
    bool isDark,
    NewLeaveRequestState state,
    NewLeaveRequestNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.additionalNotes,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF364153),
            fontSize: 13.7.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        DigifyTextArea(
          controller: _additionalNotesController,
          hintText: localizations.anyAdditionalInformation,
          maxLines: 6,
          minLines: 6,
          onChanged: (value) => notifier.setAdditionalNotes(value),
        ),
      ],
    );
  }
}
