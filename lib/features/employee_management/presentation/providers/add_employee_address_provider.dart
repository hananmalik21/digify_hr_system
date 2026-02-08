import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeAddressState {
  final String? emergAddress;
  final String? emergPhone;
  final String? emergEmail;
  final String? emergRelationship;
  final String? contactName;

  const AddEmployeeAddressState({
    this.emergAddress,
    this.emergPhone,
    this.emergEmail,
    this.emergRelationship,
    this.contactName,
  });

  bool get isStepValid {
    final a = emergAddress?.trim() ?? '';
    final p = emergPhone?.trim() ?? '';
    final e = emergEmail?.trim() ?? '';
    final r = emergRelationship?.trim() ?? '';
    final c = contactName?.trim() ?? '';
    return a.isNotEmpty &&
        p.isNotEmpty &&
        e.isNotEmpty &&
        r.isNotEmpty &&
        c.isNotEmpty &&
        FormValidators.phone(emergPhone) == null;
  }

  AddEmployeeAddressState copyWith({
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
    bool clearEmergAddress = false,
    bool clearEmergPhone = false,
    bool clearEmergEmail = false,
    bool clearEmergRelationship = false,
    bool clearContactName = false,
  }) {
    return AddEmployeeAddressState(
      emergAddress: clearEmergAddress ? null : (emergAddress ?? this.emergAddress),
      emergPhone: clearEmergPhone ? null : (emergPhone ?? this.emergPhone),
      emergEmail: clearEmergEmail ? null : (emergEmail ?? this.emergEmail),
      emergRelationship: clearEmergRelationship ? null : (emergRelationship ?? this.emergRelationship),
      contactName: clearContactName ? null : (contactName ?? this.contactName),
    );
  }
}

class AddEmployeeAddressNotifier extends StateNotifier<AddEmployeeAddressState> {
  AddEmployeeAddressNotifier() : super(const AddEmployeeAddressState());

  void setEmergAddress(String? value) {
    state = state.copyWith(emergAddress: value, clearEmergAddress: value == null || value.isEmpty);
  }

  void setEmergPhone(String? value) {
    state = state.copyWith(emergPhone: value, clearEmergPhone: value == null || value.isEmpty);
  }

  void setEmergEmail(String? value) {
    state = state.copyWith(emergEmail: value, clearEmergEmail: value == null || value.isEmpty);
  }

  void setEmergRelationship(String? value) {
    state = state.copyWith(emergRelationship: value, clearEmergRelationship: value == null || value.isEmpty);
  }

  void setContactName(String? value) {
    state = state.copyWith(contactName: value, clearContactName: value == null || value.isEmpty);
  }

  void setFromFullDetails({
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
  }) {
    state = state.copyWith(
      emergAddress: emergAddress ?? state.emergAddress,
      emergPhone: emergPhone ?? state.emergPhone,
      emergEmail: emergEmail ?? state.emergEmail,
      emergRelationship: emergRelationship ?? state.emergRelationship,
      contactName: contactName ?? state.contactName,
    );
  }

  void reset() {
    state = const AddEmployeeAddressState();
  }
}

final addEmployeeAddressProvider = StateNotifierProvider<AddEmployeeAddressNotifier, AddEmployeeAddressState>((ref) {
  return AddEmployeeAddressNotifier();
});
