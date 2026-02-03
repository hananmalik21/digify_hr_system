import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Demographics form state for Add Employee flow (Gender, Nationality, Marital Status, Religion).
class AddEmployeeDemographicsState {
  final String? genderCode;
  final String? nationality;
  final String? maritalStatusCode;
  final String? religionCode;

  const AddEmployeeDemographicsState({this.genderCode, this.nationality, this.maritalStatusCode, this.religionCode});

  AddEmployeeDemographicsState copyWith({
    String? genderCode,
    String? nationality,
    String? maritalStatusCode,
    String? religionCode,
    bool clearGenderCode = false,
    bool clearNationality = false,
    bool clearMaritalStatusCode = false,
    bool clearReligionCode = false,
  }) {
    return AddEmployeeDemographicsState(
      genderCode: clearGenderCode ? null : (genderCode ?? this.genderCode),
      nationality: clearNationality ? null : (nationality ?? this.nationality),
      maritalStatusCode: clearMaritalStatusCode ? null : (maritalStatusCode ?? this.maritalStatusCode),
      religionCode: clearReligionCode ? null : (religionCode ?? this.religionCode),
    );
  }
}

class AddEmployeeDemographicsNotifier extends StateNotifier<AddEmployeeDemographicsState> {
  AddEmployeeDemographicsNotifier() : super(const AddEmployeeDemographicsState());

  void setGenderCode(String? value) {
    state = state.copyWith(genderCode: value, clearGenderCode: value == null);
  }

  void setNationality(String? value) {
    state = state.copyWith(nationality: value, clearNationality: value == null);
  }

  void setMaritalStatusCode(String? value) {
    state = state.copyWith(maritalStatusCode: value, clearMaritalStatusCode: value == null);
  }

  void setReligionCode(String? value) {
    state = state.copyWith(religionCode: value, clearReligionCode: value == null);
  }

  void reset() {
    state = const AddEmployeeDemographicsState();
  }
}

final addEmployeeDemographicsProvider =
    StateNotifierProvider<AddEmployeeDemographicsNotifier, AddEmployeeDemographicsState>((ref) {
      return AddEmployeeDemographicsNotifier();
    });
