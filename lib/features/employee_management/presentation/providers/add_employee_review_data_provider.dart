import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_address_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_banking_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_compensation_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_documents_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_job_employment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_work_schedule_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

String _formatDate(DateTime? d) {
  if (d == null) return '—';
  return DateFormat('dd/MM/yyyy').format(d);
}

String _str(String? v) => (v?.trim().isNotEmpty ?? false) ? v!.trim() : '—';

String _contractLabel(String? code) {
  if (code == null || code.isEmpty) return '—';
  switch (code.toUpperCase()) {
    case 'PERMANENT':
      return 'Permanent';
    case 'TEMPORARY':
      return 'Temporary';
    default:
      return code;
  }
}

String _statusLabel(String? code) {
  if (code == null || code.isEmpty) return '—';
  switch (code.toUpperCase()) {
    case 'ACTIVE':
      return 'Active';
    case 'INACTIVE':
      return 'Inactive';
    default:
      return code;
  }
}

double _parseKwd(String? value) {
  if (value == null || value.trim().isEmpty) return 0;
  final cleaned = value.trim().replaceAll(',', '');
  return double.tryParse(cleaned) ?? 0;
}

class AddEmployeeReviewData {
  final String name;
  final String phone;
  final String nationality;
  final String email;
  final String dobFormatted;
  final String gender;
  final String emergAddress;
  final String emergPhone;
  final String emergEmail;
  final String relationship;
  final String contactName;
  final String companyDisplay;
  final String workLocation;
  final String position;
  final String contractTypeLabel;
  final String enterpriseHireDateFormatted;
  final String statusLabel;
  final String workScheduleName;
  final String basicSalaryDisplay;
  final String allowancesDisplay;
  final String totalDisplay;
  final String accountNumber;
  final String iban;
  final String civilIdExpiryFormatted;
  final String passportExpiryFormatted;
  final String visaNumber;
  final String visaExpiryFormatted;
  final String workPermitNumber;
  final String workPermitExpiryFormatted;
  final String supportingDocumentName;

  const AddEmployeeReviewData({
    required this.name,
    required this.phone,
    required this.nationality,
    required this.email,
    required this.dobFormatted,
    required this.gender,
    required this.emergAddress,
    required this.emergPhone,
    required this.emergEmail,
    required this.relationship,
    required this.contactName,
    required this.companyDisplay,
    required this.workLocation,
    required this.position,
    required this.contractTypeLabel,
    required this.enterpriseHireDateFormatted,
    required this.statusLabel,
    required this.workScheduleName,
    required this.basicSalaryDisplay,
    required this.allowancesDisplay,
    required this.totalDisplay,
    required this.accountNumber,
    required this.iban,
    required this.civilIdExpiryFormatted,
    required this.passportExpiryFormatted,
    required this.visaNumber,
    required this.visaExpiryFormatted,
    required this.workPermitNumber,
    required this.workPermitExpiryFormatted,
    required this.supportingDocumentName,
  });
}

final addEmployeeReviewDataProvider = Provider<AddEmployeeReviewData>((ref) {
  final basicForm = ref.watch(addEmployeeBasicInfoProvider).form;
  final demographics = ref.watch(addEmployeeDemographicsProvider);
  final address = ref.watch(addEmployeeAddressProvider);
  final assignment = ref.watch(addEmployeeAssignmentProvider);
  final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
  final workSchedule = ref.watch(addEmployeeWorkScheduleProvider);
  final job = ref.watch(addEmployeeJobEmploymentProvider);
  final compensation = ref.watch(addEmployeeCompensationProvider);
  final banking = ref.watch(addEmployeeBankingProvider);
  final documents = ref.watch(addEmployeeDocumentsProvider);

  final name = [
    basicForm.firstNameEn,
    basicForm.lastNameEn,
  ].where((s) => (s?.trim().isNotEmpty ?? false)).join(' ').trim();
  final basicKwd = _parseKwd(compensation.basicSalaryKwd);
  final allowancesKwd = compensation.totalMonthly - basicKwd;

  return AddEmployeeReviewData(
    name: name.isEmpty ? '—' : name,
    phone: _str(basicForm.phoneNumber),
    nationality: _str(demographics.getLookupCodeByTypeCode('NATIONALITY')),
    email: _str(basicForm.email),
    dobFormatted: basicForm.dateOfBirth != null ? _formatDate(basicForm.dateOfBirth) : '—',
    gender: _str(demographics.getLookupCodeByTypeCode('GENDER')),
    emergAddress: _str(address.emergAddress),
    emergPhone: _str(address.emergPhone),
    emergEmail: _str(address.emergEmail),
    relationship: _str(address.emergRelationship),
    contactName: _str(address.contactName),
    companyDisplay: enterpriseId != null ? 'ID: $enterpriseId' : '—',
    workLocation: _str(assignment.workLocation),
    position: _str(job.selectedPosition?.titleEnglish),
    contractTypeLabel: _contractLabel(job.contractTypeCode),
    enterpriseHireDateFormatted: job.enterpriseHireDate != null ? _formatDate(job.enterpriseHireDate) : '—',
    statusLabel: _statusLabel(job.employmentStatusCode),
    workScheduleName: _str(workSchedule.selectedWorkSchedule?.scheduleNameEn),
    basicSalaryDisplay: '${basicKwd.toStringAsFixed(3)} KWD',
    allowancesDisplay: '${allowancesKwd.toStringAsFixed(3)} KWD',
    totalDisplay: '${compensation.monthlyTotalFormatted} KWD',
    accountNumber: _str(banking.accountNumber),
    iban: _str(banking.iban),
    civilIdExpiryFormatted: _formatDate(documents.civilIdExpiry),
    passportExpiryFormatted: _formatDate(documents.passportExpiry),
    visaNumber: _str(documents.visaNumber),
    visaExpiryFormatted: _formatDate(documents.visaExpiry),
    workPermitNumber: _str(documents.workPermitNumber),
    workPermitExpiryFormatted: _formatDate(documents.workPermitExpiry),
    supportingDocumentName: documents.document != null ? documents.document!.name : '—',
  );
});
