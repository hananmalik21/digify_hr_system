import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeBankingState {
  final String? bankName;
  final String? accountNumber;
  final String? iban;

  const AddEmployeeBankingState({this.bankName, this.accountNumber, this.iban});

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid =>
      _isFilled(bankName) && _isFilled(accountNumber) && _isFilled(iban) && FormValidators.iban(iban) == null;

  AddEmployeeBankingState copyWith({
    String? bankName,
    String? accountNumber,
    String? iban,
    bool clearBankName = false,
    bool clearAccountNumber = false,
    bool clearIban = false,
  }) {
    return AddEmployeeBankingState(
      bankName: clearBankName ? null : (bankName ?? this.bankName),
      accountNumber: clearAccountNumber ? null : (accountNumber ?? this.accountNumber),
      iban: clearIban ? null : (iban ?? this.iban),
    );
  }
}

class AddEmployeeBankingNotifier extends StateNotifier<AddEmployeeBankingState> {
  AddEmployeeBankingNotifier() : super(const AddEmployeeBankingState());

  void setBankName(String? value) {
    state = state.copyWith(bankName: value, clearBankName: value == null || value.isEmpty);
  }

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
