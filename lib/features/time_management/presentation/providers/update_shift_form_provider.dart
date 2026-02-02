import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/utils/duration_formatter.dart';
import 'package:digify_hr_system/features/time_management/data/config/shift_form_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for update shift form
class UpdateShiftFormState {
  final int shiftId;
  final String code;
  final String nameEn;
  final String nameAr;
  final String? shiftType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String duration;
  final String breakDuration;
  final Color selectedColor;
  final String status;
  final Map<String, String> errors;
  final bool isLoading;
  final ShiftOverview? updatedShift;
  final String? errorMessage;

  UpdateShiftFormState({
    required this.shiftId,
    this.code = '',
    this.nameEn = '',
    this.nameAr = '',
    this.shiftType,
    this.startTime,
    this.endTime,
    this.duration = '',
    this.breakDuration = '',
    Color? selectedColor,
    String? status,
    this.errors = const {},
    this.isLoading = false,
    this.updatedShift,
    this.errorMessage,
  }) : selectedColor = selectedColor ?? ShiftFormConfig.defaultColor,
       status = status ?? ShiftFormConfig.statusOptions.first;

  UpdateShiftFormState copyWith({
    int? shiftId,
    String? code,
    String? nameEn,
    String? nameAr,
    String? shiftType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? duration,
    String? breakDuration,
    Color? selectedColor,
    String? status,
    Map<String, String>? errors,
    bool? isLoading,
    bool clearErrors = false,
    ShiftOverview? updatedShift,
    String? errorMessage,
    bool clearUpdatedShift = false,
    bool clearErrorMessage = false,
  }) {
    return UpdateShiftFormState(
      shiftId: shiftId ?? this.shiftId,
      code: code ?? this.code,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      shiftType: shiftType ?? this.shiftType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      breakDuration: breakDuration ?? this.breakDuration,
      selectedColor: selectedColor ?? this.selectedColor,
      status: status ?? this.status,
      errors: clearErrors ? {} : (errors ?? this.errors),
      isLoading: isLoading ?? this.isLoading,
      updatedShift: clearUpdatedShift ? null : (updatedShift ?? this.updatedShift),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid {
    return nameEn.isNotEmpty &&
        nameAr.isNotEmpty &&
        shiftType != null &&
        startTime != null &&
        endTime != null &&
        duration.isNotEmpty &&
        errors.isEmpty;
  }
}

/// StateNotifier for managing update shift form
class UpdateShiftFormNotifier extends StateNotifier<UpdateShiftFormState> {
  final int _enterpriseId;
  final ShiftsNotifier? _shiftsNotifier;

  UpdateShiftFormNotifier({
    required int enterpriseId,
    ShiftsNotifier? shiftsNotifier,
    required ShiftOverview initialShift,
  }) : _enterpriseId = enterpriseId,
       _shiftsNotifier = shiftsNotifier,
       super(_initializeFromShift(initialShift));

  static UpdateShiftFormState _initializeFromShift(ShiftOverview shift) {
    TimeOfDay? parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);
          if (hour != null && minute != null) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
      } catch (_) {
        // Ignore parsing errors and return null
      }
      return null;
    }

    Color parseColor(String hexColor) {
      try {
        final hex = hexColor.replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        }
      } catch (_) {
        // Ignore parsing errors and return default color
      }
      return ShiftFormConfig.defaultColor;
    }

    String getStatusDisplayName(ShiftStatus status) {
      return status.displayName;
    }

    String getShiftTypeDisplayName(ShiftType type) {
      return type.displayName;
    }

    return UpdateShiftFormState(
      shiftId: shift.id,
      code: shift.code,
      nameEn: shift.name,
      nameAr: shift.nameAr,
      shiftType: getShiftTypeDisplayName(shift.shiftType),
      startTime: parseTime(shift.startTime),
      endTime: parseTime(shift.endTime),
      duration: DurationFormatter.formatHours(shift.totalHours),
      breakDuration: DurationFormatter.formatHours(shift.breakHours.toDouble()),
      selectedColor: parseColor(shift.colorHex),
      status: getStatusDisplayName(shift.status),
    );
  }

  /// Update name (English) field
  void updateNameEn(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('nameEn');
    state = state.copyWith(nameEn: value, errors: errors);
  }

  /// Update name (Arabic) field
  void updateNameAr(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('nameAr');
    state = state.copyWith(nameAr: value, errors: errors);
  }

  /// Update shift type
  void updateShiftType(String? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('shiftType');
    state = state.copyWith(shiftType: value, errors: errors);
  }

  /// Update start time
  void updateStartTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('startTime');
    state = state.copyWith(startTime: value, errors: errors);
  }

  /// Update end time
  void updateEndTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('endTime');
    state = state.copyWith(endTime: value, errors: errors);
  }

  /// Update duration
  void updateDuration(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('duration');
    state = state.copyWith(duration: value, errors: errors);
  }

  /// Update break duration
  void updateBreakDuration(String value) {
    state = state.copyWith(breakDuration: value);
  }

  /// Update selected color
  void updateColor(Color value) {
    state = state.copyWith(selectedColor: value);
  }

  /// Update status
  void updateStatus(String value) {
    state = state.copyWith(status: value);
  }

  /// Validate form
  bool validate() {
    final errors = <String, String>{};

    if (state.nameEn.isEmpty) {
      errors['nameEn'] = 'Required';
    }

    if (state.nameAr.isEmpty) {
      errors['nameAr'] = 'Required';
    }

    if (state.shiftType == null) {
      errors['shiftType'] = 'Please select a shift type';
    }

    if (state.startTime == null) {
      errors['startTime'] = 'Please select start time';
    }

    if (state.endTime == null) {
      errors['endTime'] = 'Please select end time';
    }

    if (state.duration.isEmpty) {
      errors['duration'] = 'Required';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  /// Reset form
  void reset() {
    state = UpdateShiftFormState(shiftId: state.shiftId, code: state.code);
  }

  /// Convert Flutter TimeOfDay to minutes since midnight
  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  /// Convert Color to hex string
  String _colorToHex(Color color) {
    final r = ((color.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((color.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((color.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  /// Update shift
  Future<ShiftOverview?> updateShift() async {
    if (_shiftsNotifier == null) {
      state = state.copyWith(errorMessage: 'Shifts notifier not available', isLoading: false);
      return null;
    }

    if (!validate()) {
      state = state.copyWith(isLoading: false);
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, clearErrorMessage: true, clearUpdatedShift: true);

    try {
      final durationValue = double.tryParse(state.duration) ?? 0.0;
      final breakDurationValue = state.breakDuration.isEmpty ? 0.0 : (double.tryParse(state.breakDuration) ?? 0.0);

      final shiftData = <String, dynamic>{
        'tenant_id': _enterpriseId,
        'shift_name_en': state.nameEn.trim(),
        'shift_name_ar': state.nameAr.trim(),
        'shift_type': state.shiftType ?? 'REGULAR',
        'start_minutes': _timeOfDayToMinutes(state.startTime!),
        'end_minutes': _timeOfDayToMinutes(state.endTime!),
        'duration_hours': durationValue,
        'break_hours': breakDurationValue.round(),
        'color_hex': _colorToHex(state.selectedColor),
        'status': state.status.toUpperCase(),
      };

      final updatedShift = await _shiftsNotifier.updateShift(shiftId: state.shiftId, shiftData: shiftData);

      state = state.copyWith(isLoading: false, updatedShift: updatedShift, errorMessage: null, clearErrorMessage: true);

      return updatedShift;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), clearUpdatedShift: true);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update shift: ${e.toString()}',
        clearUpdatedShift: true,
      );
      return null;
    }
  }
}

/// Family provider for update shift form that accepts shift and enterprise ID
final updateShiftFormProvider = StateNotifierProvider.autoDispose
    .family<UpdateShiftFormNotifier, UpdateShiftFormState, ({ShiftOverview shift, int enterpriseId})>((ref, params) {
      return UpdateShiftFormNotifier(
        enterpriseId: params.enterpriseId,
        shiftsNotifier: ref.read(shiftsNotifierProvider(params.enterpriseId).notifier),
        initialShift: params.shift,
      );
    });
