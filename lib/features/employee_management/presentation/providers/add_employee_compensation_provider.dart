import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeCompensationState {
  final String? basicSalaryKwd;
  final String? housingKwd;
  final String? transportKwd;
  final String? foodKwd;
  final String? mobileKwd;
  final String? otherKwd;

  const AddEmployeeCompensationState({
    this.basicSalaryKwd,
    this.housingKwd,
    this.transportKwd,
    this.foodKwd,
    this.mobileKwd,
    this.otherKwd,
  });

  static double _parse(String? value) {
    if (value == null || value.trim().isEmpty) return 0;
    final cleaned = value.trim().replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  double get totalMonthly =>
      _parse(basicSalaryKwd) +
      _parse(housingKwd) +
      _parse(transportKwd) +
      _parse(foodKwd) +
      _parse(mobileKwd) +
      _parse(otherKwd);

  double get totalAnnual => totalMonthly * 12;

  String get monthlyTotalFormatted => totalMonthly.toStringAsFixed(3);
  String get annualTotalFormatted => totalAnnual.toStringAsFixed(3);

  static bool _isFilled(String? value) {
    final t = value?.trim();
    return t != null && t.isNotEmpty;
  }

  bool get isStepValid =>
      _isFilled(basicSalaryKwd) &&
      _isFilled(housingKwd) &&
      _isFilled(transportKwd) &&
      _isFilled(foodKwd) &&
      _isFilled(mobileKwd) &&
      _isFilled(otherKwd);

  AddEmployeeCompensationState copyWith({
    String? basicSalaryKwd,
    String? housingKwd,
    String? transportKwd,
    String? foodKwd,
    String? mobileKwd,
    String? otherKwd,
    bool clearBasicSalaryKwd = false,
    bool clearHousingKwd = false,
    bool clearTransportKwd = false,
    bool clearFoodKwd = false,
    bool clearMobileKwd = false,
    bool clearOtherKwd = false,
  }) {
    return AddEmployeeCompensationState(
      basicSalaryKwd: clearBasicSalaryKwd ? null : (basicSalaryKwd ?? this.basicSalaryKwd),
      housingKwd: clearHousingKwd ? null : (housingKwd ?? this.housingKwd),
      transportKwd: clearTransportKwd ? null : (transportKwd ?? this.transportKwd),
      foodKwd: clearFoodKwd ? null : (foodKwd ?? this.foodKwd),
      mobileKwd: clearMobileKwd ? null : (mobileKwd ?? this.mobileKwd),
      otherKwd: clearOtherKwd ? null : (otherKwd ?? this.otherKwd),
    );
  }
}

class AddEmployeeCompensationNotifier extends StateNotifier<AddEmployeeCompensationState> {
  AddEmployeeCompensationNotifier() : super(const AddEmployeeCompensationState());

  void setBasicSalaryKwd(String? value) {
    state = state.copyWith(basicSalaryKwd: value, clearBasicSalaryKwd: value == null || value.isEmpty);
  }

  void setHousingKwd(String? value) {
    state = state.copyWith(housingKwd: value, clearHousingKwd: value == null || value.isEmpty);
  }

  void setTransportKwd(String? value) {
    state = state.copyWith(transportKwd: value, clearTransportKwd: value == null || value.isEmpty);
  }

  void setFoodKwd(String? value) {
    state = state.copyWith(foodKwd: value, clearFoodKwd: value == null || value.isEmpty);
  }

  void setMobileKwd(String? value) {
    state = state.copyWith(mobileKwd: value, clearMobileKwd: value == null || value.isEmpty);
  }

  void setOtherKwd(String? value) {
    state = state.copyWith(otherKwd: value, clearOtherKwd: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeCompensationState();
  }
}

final addEmployeeCompensationProvider =
    StateNotifierProvider<AddEmployeeCompensationNotifier, AddEmployeeCompensationState>((ref) {
      return AddEmployeeCompensationNotifier();
    });
