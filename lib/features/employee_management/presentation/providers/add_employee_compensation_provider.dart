import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeCompensationState {
  final String? basicSalaryKwd;
  final String? housingKwd;
  final String? transportKwd;
  final String? foodKwd;
  final String? mobileKwd;
  final String? otherKwd;
  final DateTime? compStart;
  final DateTime? compEnd;

  const AddEmployeeCompensationState({
    this.basicSalaryKwd,
    this.housingKwd,
    this.transportKwd,
    this.foodKwd,
    this.mobileKwd,
    this.otherKwd,
    this.compStart,
    this.compEnd,
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
      _isFilled(otherKwd) &&
      compStart != null &&
      compEnd != null &&
      !compEnd!.isBefore(compStart!);

  AddEmployeeCompensationState copyWith({
    String? basicSalaryKwd,
    String? housingKwd,
    String? transportKwd,
    String? foodKwd,
    String? mobileKwd,
    String? otherKwd,
    DateTime? compStart,
    DateTime? compEnd,
    bool clearBasicSalaryKwd = false,
    bool clearHousingKwd = false,
    bool clearTransportKwd = false,
    bool clearFoodKwd = false,
    bool clearMobileKwd = false,
    bool clearOtherKwd = false,
    bool clearCompStart = false,
    bool clearCompEnd = false,
  }) {
    return AddEmployeeCompensationState(
      basicSalaryKwd: clearBasicSalaryKwd ? null : (basicSalaryKwd ?? this.basicSalaryKwd),
      housingKwd: clearHousingKwd ? null : (housingKwd ?? this.housingKwd),
      transportKwd: clearTransportKwd ? null : (transportKwd ?? this.transportKwd),
      foodKwd: clearFoodKwd ? null : (foodKwd ?? this.foodKwd),
      mobileKwd: clearMobileKwd ? null : (mobileKwd ?? this.mobileKwd),
      otherKwd: clearOtherKwd ? null : (otherKwd ?? this.otherKwd),
      compStart: clearCompStart ? null : (compStart ?? this.compStart),
      compEnd: clearCompEnd ? null : (compEnd ?? this.compEnd),
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

  void setCompStart(DateTime? value) {
    state = state.copyWith(compStart: value, clearCompStart: value == null);
  }

  void setCompEnd(DateTime? value) {
    state = state.copyWith(compEnd: value, clearCompEnd: value == null);
  }

  void reset() {
    state = const AddEmployeeCompensationState();
  }
}

final addEmployeeCompensationProvider =
    StateNotifierProvider<AddEmployeeCompensationNotifier, AddEmployeeCompensationState>((ref) {
      return AddEmployeeCompensationNotifier();
    });
