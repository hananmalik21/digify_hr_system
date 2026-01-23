import 'package:digify_hr_system/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LeaveRequestStep { leaveDetails, contactNotes, documentsReview }

class NewLeaveRequestState {
  final LeaveRequestStep currentStep;
  final Employee? selectedEmployee;
  final TimeOffType? leaveType;
  final int? leaveTypeId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime; // "Full Day" or specific time
  final String? endTime; // "Full Day" or specific time
  final String? reason;
  final int? delegatedToEmployeeId;
  final String? delegatedToEmployeeName;
  final String? addressDuringLeave;
  final String? contactPhoneNumber;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? additionalNotes;
  final List<Document> documents;
  final bool isSubmitting;
  final bool isSavingDraft;
  final bool isLoadingDraft;
  final String? editingRequestGuid;

  const NewLeaveRequestState({
    this.currentStep = LeaveRequestStep.leaveDetails,
    this.selectedEmployee,
    this.leaveType,
    this.leaveTypeId,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.reason,
    this.delegatedToEmployeeId,
    this.delegatedToEmployeeName,
    this.addressDuringLeave,
    this.contactPhoneNumber,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.additionalNotes,
    this.documents = const [],
    this.isSubmitting = false,
    this.isSavingDraft = false,
    this.isLoadingDraft = false,
    this.editingRequestGuid,
  });

  NewLeaveRequestState copyWith({
    LeaveRequestStep? currentStep,
    Employee? selectedEmployee,
    TimeOffType? leaveType,
    int? leaveTypeId,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? reason,
    int? delegatedToEmployeeId,
    String? delegatedToEmployeeName,
    String? addressDuringLeave,
    String? contactPhoneNumber,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? additionalNotes,
    List<Document>? documents,
    bool? isSubmitting,
    bool? isSavingDraft,
    bool? isLoadingDraft,
    String? editingRequestGuid,
    bool clearEmployee = false,
    bool clearDelegatedTo = false,
  }) {
    return NewLeaveRequestState(
      currentStep: currentStep ?? this.currentStep,
      selectedEmployee: clearEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      leaveType: leaveType ?? this.leaveType,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      reason: reason ?? this.reason,
      delegatedToEmployeeId: clearDelegatedTo ? null : (delegatedToEmployeeId ?? this.delegatedToEmployeeId),
      delegatedToEmployeeName: clearDelegatedTo ? null : (delegatedToEmployeeName ?? this.delegatedToEmployeeName),
      addressDuringLeave: addressDuringLeave ?? this.addressDuringLeave,
      contactPhoneNumber: contactPhoneNumber ?? this.contactPhoneNumber,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      documents: documents ?? this.documents,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isLoadingDraft: isLoadingDraft ?? this.isLoadingDraft,
      editingRequestGuid: editingRequestGuid ?? this.editingRequestGuid,
    );
  }

  bool canProceedToNextStep() {
    switch (currentStep) {
      case LeaveRequestStep.leaveDetails:
        return selectedEmployee != null && leaveType != null && startDate != null && endDate != null;
      case LeaveRequestStep.contactNotes:
        return reason != null && reason!.isNotEmpty;
      case LeaveRequestStep.documentsReview:
        return true; // Documents are optional
    }
  }

  int get totalDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }
}

class NewLeaveRequestNotifier extends StateNotifier<NewLeaveRequestState> {
  final LeaveRequestsRepository? _repository;
  final Ref? _ref;

  NewLeaveRequestNotifier({LeaveRequestsRepository? repository, Ref? ref})
    : _repository = repository,
      _ref = ref,
      super(const NewLeaveRequestState());

  void setStep(LeaveRequestStep step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (!state.canProceedToNextStep()) return;

    final steps = LeaveRequestStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex < steps.length - 1) {
      state = state.copyWith(currentStep: steps[currentIndex + 1]);
    }
  }

  void previousStep() {
    final steps = LeaveRequestStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex > 0) {
      state = state.copyWith(currentStep: steps[currentIndex - 1]);
    }
  }

  void updateEmployee(Employee employee) {
    state = state.copyWith(selectedEmployee: employee);
  }

  void setLeaveType(TimeOffType type) {
    state = state.copyWith(leaveType: type);
  }

  void setLeaveTypeFromApi(int leaveTypeId, String leaveCode) {
    final timeOffType = LeaveTypeMapper.getLeaveTypeFromCode(leaveCode);
    state = state.copyWith(leaveType: timeOffType, leaveTypeId: leaveTypeId);
  }

  void setStartDate(DateTime date) {
    state = state.copyWith(startDate: date);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setStartTime(String time) {
    state = state.copyWith(startTime: time);
  }

  void setEndTime(String time) {
    state = state.copyWith(endTime: time);
  }

  void setReason(String? reason) {
    state = state.copyWith(reason: reason);
  }

  void setDelegatedTo(int id, String name) {
    state = state.copyWith(delegatedToEmployeeId: id, delegatedToEmployeeName: name);
  }

  void setAddressDuringLeave(String? address) {
    state = state.copyWith(addressDuringLeave: address);
  }

  void setContactPhoneNumber(String? phone) {
    state = state.copyWith(contactPhoneNumber: phone);
  }

  void setEmergencyContactName(String? name) {
    state = state.copyWith(emergencyContactName: name);
  }

  void setEmergencyContactPhone(String? phone) {
    state = state.copyWith(emergencyContactPhone: phone);
  }

  void setAdditionalNotes(String? notes) {
    state = state.copyWith(additionalNotes: notes);
  }

  void addDocument(Document document) {
    final updatedDocuments = [...state.documents, document];
    state = state.copyWith(documents: updatedDocuments);
  }

  void addDocuments(List<Document> documents) {
    final updatedDocuments = [...state.documents, ...documents];
    state = state.copyWith(documents: updatedDocuments);
  }

  void removeDocument(String documentId) {
    final updatedDocuments = state.documents.where((doc) => doc.id != documentId).toList();
    state = state.copyWith(documents: updatedDocuments);
  }

  void clearDocuments() {
    state = state.copyWith(documents: []);
  }

  void setLoadingDraft(bool isLoading) {
    state = state.copyWith(isLoadingDraft: isLoading);
  }

  void reset() {
    state = const NewLeaveRequestState();
  }

  Future<void> loadDraftData(Map<String, dynamic> responseData) async {
    final data = responseData['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception('Invalid response data');
    }

    final item = data[0] as Map<String, dynamic>;
    final leaveDetails = item['leave_details'] as Map<String, dynamic>?;
    final leaveContactInfo = item['leave_contact_info'] as Map<String, dynamic>?;
    final leaveDocumentInfo = item['leave_document_info'] as Map<String, dynamic>?;

    if (leaveDetails == null) {
      throw Exception('Leave details not found');
    }

    final employeeInfo = leaveDetails['employee_info'] as Map<String, dynamic>?;
    final leaveTypeInfo = leaveDetails['leave_type_info'] as Map<String, dynamic>?;

    if (employeeInfo == null) {
      throw Exception('Employee info not found');
    }

    final employee = Employee(
      id: (employeeInfo['employee_id'] as num?)?.toInt() ?? 0,
      guid: employeeInfo['employee_guid'] as String? ?? '',
      enterpriseId: (leaveDetails['tenant_id'] as num?)?.toInt() ?? 0,
      firstName: employeeInfo['first_name'] as String? ?? '',
      lastName: employeeInfo['last_name'] as String? ?? '',
      email: employeeInfo['email'] as String? ?? '',
      status: '',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final leaveCode = leaveTypeInfo?['leave_code'] as String?;
    final leaveType = LeaveTypeMapper.getLeaveTypeFromCode(leaveCode);

    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    String mapPortionToTime(String? portion) {
      if (portion == null) return 'Full Time';
      switch (portion.toUpperCase()) {
        case 'FULL_DAY':
          return 'Full Time';
        case 'HALF_AM':
        case 'HALF_PM':
          return 'Half Time';
        default:
          return 'Full Time';
      }
    }

    state = state.copyWith(
      editingRequestGuid: leaveDetails['leave_request_guid'] as String?,
      selectedEmployee: employee,
      leaveType: leaveType,
      leaveTypeId: (leaveDetails['leave_type_id'] as num?)?.toInt(),
      startDate: parseDateTime(leaveDetails['start_date']),
      endDate: parseDateTime(leaveDetails['end_date']),
      startTime: mapPortionToTime(leaveDetails['start_portion'] as String?),
      endTime: mapPortionToTime(leaveDetails['end_portion'] as String?),
      reason: leaveContactInfo?['reason_for_leave'] as String?,
      delegatedToEmployeeId: (leaveContactInfo?['delegated_employee_id'] as num?)?.toInt(),
      addressDuringLeave: leaveContactInfo?['address_during_leave'] as String?,
      contactPhoneNumber: leaveContactInfo?['contact_phone'] as String?,
      emergencyContactName: leaveContactInfo?['emergency_contact_name'] as String?,
      emergencyContactPhone: leaveContactInfo?['emergency_contact_phone'] as String?,
      additionalNotes: leaveContactInfo?['additional_notes'] as String?,
      documents: leaveDocumentInfo != null
          ? [
              Document(
                id: leaveDocumentInfo['document_guid'] as String? ?? '',
                name: leaveDocumentInfo['file_name'] as String? ?? '',
                path: '',
                size: 0,
                uploadedAt: parseDateTime(leaveDocumentInfo['creation_date']),
              ),
            ]
          : [],
    );
  }

  Future<Map<String, dynamic>> submit() async {
    if (_repository == null) {
      throw Exception('Repository not provided');
    }

    final tenantId = _ref?.read(leaveManagementSelectedEnterpriseProvider);

    state = state.copyWith(isSubmitting: true);
    try {
      final response = state.editingRequestGuid != null
          ? await _repository.updateLeaveRequest(state.editingRequestGuid!, state, true, tenantId: tenantId)
          : await _repository.createLeaveRequest(state, true, tenantId: tenantId);
      state = state.copyWith(isSubmitting: false);
      return response;
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> saveAsDraft() async {
    if (_repository == null) {
      throw Exception('Repository not provided');
    }

    final tenantId = _ref?.read(leaveManagementSelectedEnterpriseProvider);

    state = state.copyWith(isSavingDraft: true);
    try {
      final response = state.editingRequestGuid != null
          ? await _repository.updateLeaveRequest(state.editingRequestGuid!, state, false, tenantId: tenantId)
          : await _repository.createLeaveRequest(state, false, tenantId: tenantId);
      state = state.copyWith(isSavingDraft: false);
      return response;
    } catch (e) {
      state = state.copyWith(isSavingDraft: false);
      rethrow;
    }
  }
}

final newLeaveRequestProvider = StateNotifierProvider<NewLeaveRequestNotifier, NewLeaveRequestState>((ref) {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  return NewLeaveRequestNotifier(repository: repository, ref: ref);
});
