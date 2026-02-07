import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeDocumentsState {
  final DateTime? civilIdExpiry;
  final DateTime? passportExpiry;
  final String? visaNumber;
  final DateTime? visaExpiry;
  final String? workPermitNumber;
  final DateTime? workPermitExpiry;
  final Document? document;

  const AddEmployeeDocumentsState({
    this.civilIdExpiry,
    this.passportExpiry,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
    this.document,
  });

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid =>
      civilIdExpiry != null &&
      passportExpiry != null &&
      _isFilled(visaNumber) &&
      visaExpiry != null &&
      _isFilled(workPermitNumber) &&
      workPermitExpiry != null;

  AddEmployeeDocumentsState copyWith({
    DateTime? civilIdExpiry,
    DateTime? passportExpiry,
    String? visaNumber,
    DateTime? visaExpiry,
    String? workPermitNumber,
    DateTime? workPermitExpiry,
    Document? document,
    bool clearCivilIdExpiry = false,
    bool clearPassportExpiry = false,
    bool clearVisaNumber = false,
    bool clearVisaExpiry = false,
    bool clearWorkPermitNumber = false,
    bool clearWorkPermitExpiry = false,
    bool clearDocument = false,
  }) {
    return AddEmployeeDocumentsState(
      civilIdExpiry: clearCivilIdExpiry ? null : (civilIdExpiry ?? this.civilIdExpiry),
      passportExpiry: clearPassportExpiry ? null : (passportExpiry ?? this.passportExpiry),
      visaNumber: clearVisaNumber ? null : (visaNumber ?? this.visaNumber),
      visaExpiry: clearVisaExpiry ? null : (visaExpiry ?? this.visaExpiry),
      workPermitNumber: clearWorkPermitNumber ? null : (workPermitNumber ?? this.workPermitNumber),
      workPermitExpiry: clearWorkPermitExpiry ? null : (workPermitExpiry ?? this.workPermitExpiry),
      document: clearDocument ? null : (document ?? this.document),
    );
  }
}

class AddEmployeeDocumentsNotifier extends StateNotifier<AddEmployeeDocumentsState> {
  AddEmployeeDocumentsNotifier() : super(const AddEmployeeDocumentsState());

  void setCivilIdExpiry(DateTime? value) {
    state = state.copyWith(civilIdExpiry: value, clearCivilIdExpiry: value == null);
  }

  void setPassportExpiry(DateTime? value) {
    state = state.copyWith(passportExpiry: value, clearPassportExpiry: value == null);
  }

  void setVisaNumber(String? value) {
    state = state.copyWith(visaNumber: value, clearVisaNumber: value == null || value.isEmpty);
  }

  void setVisaExpiry(DateTime? value) {
    state = state.copyWith(visaExpiry: value, clearVisaExpiry: value == null);
  }

  void setWorkPermitNumber(String? value) {
    state = state.copyWith(workPermitNumber: value, clearWorkPermitNumber: value == null || value.isEmpty);
  }

  void setWorkPermitExpiry(DateTime? value) {
    state = state.copyWith(workPermitExpiry: value, clearWorkPermitExpiry: value == null);
  }

  void setDocument(Document? value) {
    state = state.copyWith(document: value, clearDocument: value == null);
  }

  void reset() {
    state = const AddEmployeeDocumentsState();
  }
}

final addEmployeeDocumentsProvider = StateNotifierProvider<AddEmployeeDocumentsNotifier, AddEmployeeDocumentsState>((
  ref,
) {
  return AddEmployeeDocumentsNotifier();
});
