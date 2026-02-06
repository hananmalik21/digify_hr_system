import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeDemographicsState {
  final String? genderCode;
  final String? nationality;
  final String? maritalStatusCode;
  final String? religionCode;
  final String? civilIdNumber;
  final String? passportNumber;

  const AddEmployeeDemographicsState({
    this.genderCode,
    this.nationality,
    this.maritalStatusCode,
    this.religionCode,
    this.civilIdNumber,
    this.passportNumber,
  });

  AddEmployeeDemographicsState copyWith({
    String? genderCode,
    String? nationality,
    String? maritalStatusCode,
    String? religionCode,
    String? civilIdNumber,
    String? passportNumber,
    bool clearGenderCode = false,
    bool clearNationality = false,
    bool clearMaritalStatusCode = false,
    bool clearReligionCode = false,
    bool clearCivilIdNumber = false,
    bool clearPassportNumber = false,
  }) {
    return AddEmployeeDemographicsState(
      genderCode: clearGenderCode ? null : (genderCode ?? this.genderCode),
      nationality: clearNationality ? null : (nationality ?? this.nationality),
      maritalStatusCode: clearMaritalStatusCode ? null : (maritalStatusCode ?? this.maritalStatusCode),
      religionCode: clearReligionCode ? null : (religionCode ?? this.religionCode),
      civilIdNumber: clearCivilIdNumber ? null : (civilIdNumber ?? this.civilIdNumber),
      passportNumber: clearPassportNumber ? null : (passportNumber ?? this.passportNumber),
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

  void setCivilIdNumber(String? value) {
    state = state.copyWith(civilIdNumber: value, clearCivilIdNumber: value == null || value.isEmpty);
  }

  void setPassportNumber(String? value) {
    state = state.copyWith(passportNumber: value, clearPassportNumber: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeDemographicsState();
  }
}

final addEmployeeDemographicsProvider =
    StateNotifierProvider<AddEmployeeDemographicsNotifier, AddEmployeeDemographicsState>((ref) {
      return AddEmployeeDemographicsNotifier();
    });
