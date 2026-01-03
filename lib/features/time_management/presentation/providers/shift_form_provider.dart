import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/utils/duration_formatter.dart';
import 'package:digify_hr_system/features/time_management/data/config/shift_form_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart' hide TimeOfDay;
import 'package:digify_hr_system/features/time_management/domain/usecases/create_shift_usecase.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for shift form
class ShiftFormState {
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
  final ShiftOverview? createdShift;
  final String? errorMessage;

  ShiftFormState({
    this.code = '',
    this.nameEn = '',
    this.nameAr = '',
    this.shiftType,
    this.startTime,
    this.endTime,
    this.duration = '',
    this.breakDuration = '1',
    Color? selectedColor,
    String? status,
    this.errors = const {},
    this.isLoading = false,
    this.createdShift,
    this.errorMessage,
  }) : selectedColor = selectedColor ?? ShiftFormConfig.defaultColor,
       status = status ?? ShiftFormConfig.statusOptions.first;

  ShiftFormState copyWith({
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
    ShiftOverview? createdShift,
    String? errorMessage,
    bool clearCreatedShift = false,
    bool clearErrorMessage = false,
  }) {
    return ShiftFormState(
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
      createdShift: clearCreatedShift ? null : (createdShift ?? this.createdShift),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isValid {
    return code.isNotEmpty &&
        nameEn.isNotEmpty &&
        nameAr.isNotEmpty &&
        shiftType != null &&
        startTime != null &&
        endTime != null &&
        duration.isNotEmpty &&
        errors.isEmpty;
  }
}

/// StateNotifier for managing shift form
class ShiftFormNotifier extends StateNotifier<ShiftFormState> {
  final CreateShiftUseCase? _createShiftUseCase;

  ShiftFormNotifier({CreateShiftUseCase? createShiftUseCase})
    : _createShiftUseCase = createShiftUseCase,
      super(ShiftFormState());

  /// Update code field
  void updateCode(String value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('code');
    state = state.copyWith(code: value, errors: errors);
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

  /// Calculate duration in hours from start and end time
  String _calculateDuration(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) return '';

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    int diffMinutes;
    if (endMinutes >= startMinutes) {
      diffMinutes = endMinutes - startMinutes;
    } else {
      diffMinutes = (24 * 60 - startMinutes) + endMinutes;
    }

    final totalHours = diffMinutes / 60.0;
    return DurationFormatter.formatHours(totalHours);
  }

  /// Update start time
  void updateStartTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('startTime');
    errors.remove('duration');

    final newDuration = _calculateDuration(value, state.endTime);
    state = state.copyWith(startTime: value, duration: newDuration, errors: errors);
  }

  /// Update end time
  void updateEndTime(TimeOfDay? value) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('endTime');
    errors.remove('duration');

    final newDuration = _calculateDuration(state.startTime, value);
    state = state.copyWith(endTime: value, duration: newDuration, errors: errors);
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

    if (state.code.isEmpty) {
      errors['code'] = 'Required';
    }

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

    if (state.breakDuration.isEmpty) {
      errors['breakDuration'] = 'Required';
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  /// Reset form
  void reset() {
    state = ShiftFormState(breakDuration: '1');
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

  /// Create shift
  Future<ShiftOverview?> createShift() async {
    final useCase = _createShiftUseCase;
    if (useCase == null) {
      state = state.copyWith(errorMessage: 'Create shift use case not available', isLoading: false);
      return null;
    }

    // Validate form first
    if (!validate()) {
      state = state.copyWith(isLoading: false);
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, clearErrorMessage: true, clearCreatedShift: true);

    try {
      final shiftData = <String, dynamic>{
        'tenant_id': 1001,
        'shift_code': state.code.trim(),
        'shift_name_en': state.nameEn.trim(),
        'shift_name_ar': state.nameAr.trim(),
        'shift_type': state.shiftType ?? 'REGULAR',
        'start_minutes': _timeOfDayToMinutes(state.startTime!),
        'end_minutes': _timeOfDayToMinutes(state.endTime!),
        'duration_hours': double.tryParse(state.duration) ?? 0.0,
        'break_hours': double.tryParse(state.breakDuration.isEmpty ? '0' : state.breakDuration) ?? 0.0,
        'color_hex': _colorToHex(state.selectedColor),
        'status': state.status.toUpperCase(),
      };

      final createdShift = await useCase.call(shiftData: shiftData);

      state = state.copyWith(isLoading: false, createdShift: createdShift, errorMessage: null, clearErrorMessage: true);

      return createdShift;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString(), clearCreatedShift: true);
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create shift: ${e.toString()}',
        clearCreatedShift: true,
      );
      return null;
    }
  }
}

/// Family provider for create shift use case that accepts enterprise ID
final createShiftUseCaseProvider = Provider.family<CreateShiftUseCase, int>((ref, enterpriseId) {
  return CreateShiftUseCase(repository: ref.read(shiftRepositoryProvider(enterpriseId)));
});

/// Family provider for shift form that accepts enterprise ID
final shiftFormProvider = StateNotifierProvider.autoDispose.family<ShiftFormNotifier, ShiftFormState, int>(
  (ref, enterpriseId) => ShiftFormNotifier(createShiftUseCase: ref.read(createShiftUseCaseProvider(enterpriseId))),
);
