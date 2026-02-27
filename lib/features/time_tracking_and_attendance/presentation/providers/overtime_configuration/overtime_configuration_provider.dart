import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/overtime_configuration/labor_law_limits.dart';
import '../../../domain/models/overtime_configuration/rate_multiplier.dart';

class OvertimeConfiguration {
  final bool isLoading;
  final bool isError;
  final GlobalKey<FormState>? formKey;
  final List<RateMultiplier> rateMultipliers;
  final LaborLawLimit? laborLawLimits;
  final bool isManagerApprovalRequired;
  final bool isHRValidationRequired;
  final String errorMessage;

  OvertimeConfiguration({
    this.isLoading = false,
    this.isError = false,
    this.formKey,
    this.errorMessage = '',
    this.rateMultipliers = const [],
    this.laborLawLimits,
    this.isManagerApprovalRequired = false,
    this.isHRValidationRequired = false,
  });

  OvertimeConfiguration copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<RateMultiplier>? rateMultipliers,
    LaborLawLimit? laborLawLimits,
    bool? isManagerApprovalRequired,
    bool? isHRValidationRequired,
  }) {
    return OvertimeConfiguration(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      rateMultipliers: rateMultipliers ?? this.rateMultipliers,
      laborLawLimits: laborLawLimits ?? this.laborLawLimits,
      isManagerApprovalRequired:
          isManagerApprovalRequired ?? this.isManagerApprovalRequired,
      isHRValidationRequired:
          isHRValidationRequired ?? this.isHRValidationRequired,
    );
  }
}

final overtimeConfigurationProvider =
    StateNotifierProvider<OvertimeConfigurationNotifier, OvertimeConfiguration>(
      (ref) {
        return OvertimeConfigurationNotifier(ref);
      },
    );

class OvertimeConfigurationNotifier
    extends StateNotifier<OvertimeConfiguration> {
  OvertimeConfigurationNotifier(Ref ref) : super(OvertimeConfiguration()) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = state.copyWith(
      isLoading: false,
      isError: false,
      errorMessage: '',
      laborLawLimits: LaborLawLimit(),
    );
  }

  void addRateMultiplier(RateMultiplier rateMultiplier) {
    state = state.copyWith(
      rateMultipliers: [...state.rateMultipliers, rateMultiplier],
    );
  }

  void toggleManagerApprovalRequired(bool value) {
    state = state.copyWith(isManagerApprovalRequired: value);
  }

  void toggleHRValidationRequired(bool value) {
    state = state.copyWith(isHRValidationRequired: value);
  }
}
