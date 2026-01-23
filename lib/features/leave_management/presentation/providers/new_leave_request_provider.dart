import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LeaveRequestStep { leaveDetails, contactNotes, documentsReview }

class NewLeaveRequestState {
  final LeaveRequestStep currentStep;
  final Employee? selectedEmployee;
  final TimeOffType? leaveType;
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

  const NewLeaveRequestState({
    this.currentStep = LeaveRequestStep.leaveDetails,
    this.selectedEmployee,
    this.leaveType,
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
  });

  NewLeaveRequestState copyWith({
    LeaveRequestStep? currentStep,
    Employee? selectedEmployee,
    TimeOffType? leaveType,
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
    bool clearEmployee = false,
    bool clearDelegatedTo = false,
  }) {
    return NewLeaveRequestState(
      currentStep: currentStep ?? this.currentStep,
      selectedEmployee: clearEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      leaveType: leaveType ?? this.leaveType,
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

  NewLeaveRequestNotifier({LeaveRequestsRepository? repository})
    : _repository = repository,
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

  void reset() {
    state = const NewLeaveRequestState();
  }

  Future<Map<String, dynamic>> submit() async {
    if (_repository == null) {
      throw Exception('Repository not provided');
    }

    state = state.copyWith(isSubmitting: true);
    try {
      final response = await _repository.createLeaveRequest(state, true);
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

    state = state.copyWith(isSavingDraft: true);
    try {
      final response = await _repository.createLeaveRequest(state, false);
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
  return NewLeaveRequestNotifier(repository: repository);
});
