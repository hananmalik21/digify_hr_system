import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';

class WorkScheduleUpdateState {
  final String scheduleCode;
  final String scheduleNameEn;
  final String scheduleNameAr;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final WorkPattern? selectedWorkPattern;
  final PositionStatus selectedStatus;
  final String assignmentMode;
  final Map<int, ShiftOverview?> dayShifts;
  final ShiftOverview? sameShiftForAllDays;
  final bool isUpdating;
  final String? error;

  const WorkScheduleUpdateState({
    this.scheduleCode = '',
    this.scheduleNameEn = '',
    this.scheduleNameAr = '',
    this.effectiveStartDate = '',
    this.effectiveEndDate = '',
    this.selectedWorkPattern,
    this.selectedStatus = PositionStatus.active,
    this.assignmentMode = 'PER_DAY_SHIFT',
    this.dayShifts = const {},
    this.sameShiftForAllDays,
    this.isUpdating = false,
    this.error,
  });

  WorkScheduleUpdateState copyWith({
    String? scheduleCode,
    String? scheduleNameEn,
    String? scheduleNameAr,
    String? effectiveStartDate,
    String? effectiveEndDate,
    WorkPattern? selectedWorkPattern,
    bool clearWorkPattern = false,
    PositionStatus? selectedStatus,
    String? assignmentMode,
    Map<int, ShiftOverview?>? dayShifts,
    bool clearDayShifts = false,
    ShiftOverview? sameShiftForAllDays,
    bool clearSameShift = false,
    bool? isUpdating,
    String? error,
    bool clearError = false,
  }) {
    return WorkScheduleUpdateState(
      scheduleCode: scheduleCode ?? this.scheduleCode,
      scheduleNameEn: scheduleNameEn ?? this.scheduleNameEn,
      scheduleNameAr: scheduleNameAr ?? this.scheduleNameAr,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
      selectedWorkPattern: clearWorkPattern ? null : (selectedWorkPattern ?? this.selectedWorkPattern),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      assignmentMode: assignmentMode ?? this.assignmentMode,
      dayShifts: clearDayShifts ? {} : (dayShifts ?? this.dayShifts),
      sameShiftForAllDays: clearSameShift ? null : (sameShiftForAllDays ?? this.sameShiftForAllDays),
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : (error ?? this.error),
    );
  }

  WorkScheduleUpdateState reset() {
    return const WorkScheduleUpdateState();
  }
}
