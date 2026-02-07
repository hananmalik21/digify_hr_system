import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeBankingState {
  final String? accountNumber;
  final String? iban;

  const AddEmployeeBankingState({this.accountNumber, this.iban});

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid => _isFilled(accountNumber) && _isFilled(iban) && FormValidators.iban(iban) == null;

  AddEmployeeBankingState copyWith({
    String? accountNumber,
    String? iban,
    bool clearAccountNumber = false,
    bool clearIban = false,
  }) {
    return AddEmployeeBankingState(
      accountNumber: clearAccountNumber ? null : (accountNumber ?? this.accountNumber),
      iban: clearIban ? null : (iban ?? this.iban),
    );
  }
}

class AddEmployeeBankingNotifier extends StateNotifier<AddEmployeeBankingState> {
  AddEmployeeBankingNotifier() : super(const AddEmployeeBankingState());

  void setAccountNumber(String? value) {
    state = state.copyWith(accountNumber: value, clearAccountNumber: value == null || value.isEmpty);
  }

  void setIban(String? value) {
    state = state.copyWith(iban: value, clearIban: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeBankingState();
  }
}

final addEmployeeBankingProvider = StateNotifierProvider<AddEmployeeBankingNotifier, AddEmployeeBankingState>((ref) {
  return AddEmployeeBankingNotifier();
});
