import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustLeaveBalanceValidation {
  String? validate({
    required String annualLeaveStr,
    required String sickLeaveStr,
    required String unpaidLeaveStr,
    required String reason,
  }) {
    final annualError = _validateRequiredNumber(annualLeaveStr, 'Annual leave');
    if (annualError != null) return annualError;
    final sickError = _validateRequiredNumber(sickLeaveStr, 'Sick leave');
    if (sickError != null) return sickError;
    final unpaidError = _validateRequiredNumber(unpaidLeaveStr, 'Unpaid leave');
    if (unpaidError != null) return unpaidError;
    final trimmed = reason.trim();
    if (trimmed.isEmpty) return 'Adjustment reason is required';
    return null;
  }

  String? _validateRequiredNumber(String value, String fieldName) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '$fieldName is required';
    final parsed = double.tryParse(trimmed);
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0) return 'Must be 0 or more';
    return null;
  }
}

final adjustLeaveBalanceValidationProvider = Provider<AdjustLeaveBalanceValidation>((ref) {
  return AdjustLeaveBalanceValidation();
});
