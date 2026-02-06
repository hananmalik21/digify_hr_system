import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeBankingState {
  final String? bankCode;
  final String? accountNumber;

  const AddEmployeeBankingState({this.bankCode, this.accountNumber});

  AddEmployeeBankingState copyWith({
    String? bankCode,
    String? accountNumber,
    bool clearBankCode = false,
    bool clearAccountNumber = false,
  }) {
    return AddEmployeeBankingState(
      bankCode: clearBankCode ? null : (bankCode ?? this.bankCode),
      accountNumber: clearAccountNumber ? null : (accountNumber ?? this.accountNumber),
    );
  }
}

class AddEmployeeBankingNotifier extends StateNotifier<AddEmployeeBankingState> {
  AddEmployeeBankingNotifier() : super(const AddEmployeeBankingState());

  void setBankCode(String? value) {
    state = state.copyWith(bankCode: value, clearBankCode: value == null || value.isEmpty);
  }

  void setAccountNumber(String? value) {
    state = state.copyWith(accountNumber: value, clearAccountNumber: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeBankingState();
  }
}

final addEmployeeBankingProvider = StateNotifierProvider<AddEmployeeBankingNotifier, AddEmployeeBankingState>((ref) {
  return AddEmployeeBankingNotifier();
});
