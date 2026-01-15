import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';

enum LeaveRequestStep { leaveDetails, contactNotes, documentsReview }

class NewLeaveRequestState {
  final LeaveRequestStep currentStep;
  final int? selectedEmployeeId;
  final String? selectedEmployeeName;
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
  final List<String>? documentPaths;
  final bool isSubmitting;

  const NewLeaveRequestState({
    this.currentStep = LeaveRequestStep.leaveDetails,
    this.selectedEmployeeId,
    this.selectedEmployeeName,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.startTime = 'Full Day',
    this.endTime = 'Full Day',
    this.reason,
    this.delegatedToEmployeeId,
    this.delegatedToEmployeeName,
    this.addressDuringLeave,
    this.contactPhoneNumber,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.additionalNotes,
    this.documentPaths,
    this.isSubmitting = false,
  });

  NewLeaveRequestState copyWith({
    LeaveRequestStep? currentStep,
    int? selectedEmployeeId,
    String? selectedEmployeeName,
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
    List<String>? documentPaths,
    bool? isSubmitting,
    bool clearEmployee = false,
    bool clearDelegatedTo = false,
  }) {
    return NewLeaveRequestState(
      currentStep: currentStep ?? this.currentStep,
      selectedEmployeeId: clearEmployee ? null : (selectedEmployeeId ?? this.selectedEmployeeId),
      selectedEmployeeName: clearEmployee ? null : (selectedEmployeeName ?? this.selectedEmployeeName),
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
      documentPaths: documentPaths ?? this.documentPaths,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  bool canProceedToNextStep() {
    switch (currentStep) {
      case LeaveRequestStep.leaveDetails:
        return selectedEmployeeId != null &&
            leaveType != null &&
            startDate != null &&
            endDate != null;
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
  NewLeaveRequestNotifier() : super(const NewLeaveRequestState());

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

  void setEmployee(int id, String name) {
    state = state.copyWith(selectedEmployeeId: id, selectedEmployeeName: name);
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

  void setDocuments(List<String> paths) {
    state = state.copyWith(documentPaths: paths);
  }

  void reset() {
    state = const NewLeaveRequestState();
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true);
    // TODO: Implement actual submission logic
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    state = state.copyWith(isSubmitting: false);
  }
}

final newLeaveRequestProvider =
    StateNotifierProvider<NewLeaveRequestNotifier, NewLeaveRequestState>((ref) {
  return NewLeaveRequestNotifier();
});
