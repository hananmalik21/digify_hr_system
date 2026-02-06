import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_address_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_work_schedule_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeDialogFlow {
  AddEmployeeDialogFlow(this._ref);

  final Ref _ref;

  void clearForm() {
    _ref.read(addEmployeeStepperProvider.notifier).reset();
    _ref.read(addEmployeeBasicInfoProvider.notifier).reset();
    _ref.read(addEmployeeDemographicsProvider.notifier).reset();
    _ref.read(addEmployeeAddressProvider.notifier).reset();
    _ref.read(addEmployeeWorkScheduleProvider.notifier).reset();
    _ref.read(addEmployeeAssignmentProvider.notifier).reset();
    _ref.read(addEmployeeJobEmploymentProvider.notifier).reset();
  }

  void close(BuildContext context) {
    clearForm();
    if (context.mounted) Navigator.of(context).pop(context);
  }

  void goPrevious() {
    _ref.read(addEmployeeStepperProvider.notifier).previousStep();
  }

  void goNext(BuildContext context) {
    final stepperState = _ref.read(addEmployeeStepperProvider);
    final localizations = AppLocalizations.of(context)!;

    if (stepperState.currentStepIndex == 0) {
      final basicInfoState = _ref.read(addEmployeeBasicInfoProvider);
      final form = basicInfoState.form;

      if (!form.isEmailValid) {
        ToastService.error(context, localizations.invalidEmail);
        return;
      }

      if (!form.isPhoneValid) {
        ToastService.error(context, localizations.invalidPhone);
        return;
      }

      if (!form.isStep1Valid) {
        ToastService.warning(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    if (stepperState.currentStepIndex == 1) {
      final demographics = _ref.read(addEmployeeDemographicsProvider);
      final enterpriseId = _ref.read(manageEmployeesEnterpriseIdProvider) ?? 0;
      final typesAsync = _ref.read(emplLookupTypesProvider(enterpriseId));
      final orderedTypes = typesAsync.valueOrNull ?? [];
      final requiredTypeCodes = orderedTypes.map((t) => t.typeCode);
      if (!demographics.isStepValid(requiredTypeCodes)) {
        ToastService.warning(context, localizations.addEmployeeFillRequiredFields);
        return;
      }
    }

    _ref.read(addEmployeeStepperProvider.notifier).nextStep();
    logAddEmployeeState(_ref);
  }

  Future<void> saveAndClose(BuildContext context) async {
    final basicState = _ref.read(addEmployeeBasicInfoProvider);
    final addressState = _ref.read(addEmployeeAddressProvider);
    final workScheduleState = _ref.read(addEmployeeWorkScheduleProvider);
    final assignmentState = _ref.read(addEmployeeAssignmentProvider);
    final request = basicState.form.copyWith(
      emergAddress: _emptyToNull(addressState.emergAddress),
      emergPhone: _emptyToNull(addressState.emergPhone),
      emergEmail: _emptyToNull(addressState.emergEmail),
      emergRelationship: _emptyToNull(addressState.emergRelationship),
      contactName: _emptyToNull(addressState.contactName),
      workScheduleId: workScheduleState.workScheduleId,
      orgUnitIdHex: _emptyToNull(assignmentState.orgUnitIdHex),
    );
    final ok = await _ref.read(addEmployeeBasicInfoProvider.notifier).submitWithRequest(request);
    if (!context.mounted) return;
    if (ok) {
      ToastService.success(context, AppLocalizations.of(context)!.addEmployeeCreatedSuccess);
      close(context);
    } else {
      final error = _ref.read(addEmployeeBasicInfoProvider).submitError;
      ToastService.error(context, error ?? AppLocalizations.of(context)!.addEmployeeFillRequiredFields);
    }
  }
}

String? _emptyToNull(String? value) {
  final t = value?.trim();
  return t == null || t.isEmpty ? null : value;
}

final addEmployeeDialogFlowProvider = Provider<AddEmployeeDialogFlow>((ref) {
  return AddEmployeeDialogFlow(ref);
});

void logAddEmployeeState(dynamic ref) {
  final Ref r = ref as Ref;
  final stepper = r.read(addEmployeeStepperProvider);
  final basicInfo = r.read(addEmployeeBasicInfoProvider);
  final demographics = r.read(addEmployeeDemographicsProvider);
  final address = r.read(addEmployeeAddressProvider);
  final workSchedule = r.read(addEmployeeWorkScheduleProvider);
  final assignment = r.read(addEmployeeAssignmentProvider);
  final f = basicInfo.form;
  debugPrint('--- Add Employee State (step ${stepper.currentStepIndex + 1}) ---');
  debugPrint('Stepper: currentStepIndex=${stepper.currentStepIndex}');
  debugPrint(
    'Basic info: firstNameEn=${f.firstNameEn}, lastNameEn=${f.lastNameEn}, '
    'firstNameAr=${f.firstNameAr}, lastNameAr=${f.lastNameAr}, email=${f.email}, '
    'phoneNumber=${f.phoneNumber}, mobileNumber=${f.mobileNumber}, dateOfBirth=${f.dateOfBirth}',
  );
  debugPrint(
    'Demographics: lookupCodes=${demographics.lookupCodesByTypeCode}, '
    'civilIdNumber=${demographics.civilIdNumber}, passportNumber=${demographics.passportNumber}',
  );
  debugPrint(
    'Address: emergAddress=${address.emergAddress}, emergPhone=${address.emergPhone}, '
    'emergEmail=${address.emergEmail}, emergRelationship=${address.emergRelationship}, '
    'contactName=${address.contactName}',
  );
  debugPrint(
    'Work schedule: workScheduleId=${workSchedule.workScheduleId}, '
    'schedule=${workSchedule.selectedWorkSchedule?.scheduleNameEn}',
  );
  debugPrint('Assignment: orgUnitIdHex=${assignment.orgUnitIdHex}');
  debugPrint('---');
}
