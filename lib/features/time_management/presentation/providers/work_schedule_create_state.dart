import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';

class WorkScheduleCreateState {
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
  final bool isCreating;
  final String? error;

  const WorkScheduleCreateState({
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
    this.isCreating = false,
    this.error,
  });

  WorkScheduleCreateState copyWith({
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
    ShiftOverview? sameShiftForAllDays,
    bool clearSameShift = false,
    bool? isCreating,
    String? error,
    bool clearError = false,
  }) {
    return WorkScheduleCreateState(
      scheduleCode: scheduleCode ?? this.scheduleCode,
      scheduleNameEn: scheduleNameEn ?? this.scheduleNameEn,
      scheduleNameAr: scheduleNameAr ?? this.scheduleNameAr,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
      selectedWorkPattern: clearWorkPattern ? null : (selectedWorkPattern ?? this.selectedWorkPattern),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      assignmentMode: assignmentMode ?? this.assignmentMode,
      dayShifts: dayShifts ?? this.dayShifts,
      sameShiftForAllDays: clearSameShift ? null : (sameShiftForAllDays ?? this.sameShiftForAllDays),
      isCreating: isCreating ?? this.isCreating,
      error: clearError ? null : (error ?? this.error),
    );
  }

  WorkScheduleCreateState reset() {
    return const WorkScheduleCreateState();
  }
}
