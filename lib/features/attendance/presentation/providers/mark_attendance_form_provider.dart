import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';

class MarkAttendanceFormState {
  final int? employeeId;
  final String? employeeName;
  final String? employeeNumber;
  final DateTime? date;
  final TimeOfDay? scheduleStartTime;
  final int? scheduleDuration;
  final AttendanceStatus? status;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;
  final int? overtimeHours;
  final String? location;
  final String? notes;
  final bool isLoading;

  const MarkAttendanceFormState({
    this.employeeId,
    this.employeeName,
    this.employeeNumber,
    this.date,
    this.scheduleStartTime,
    this.scheduleDuration,
    this.status,
    this.checkInTime,
    this.checkOutTime,
    this.overtimeHours,
    this.location,
    this.notes,
    this.isLoading = false,
  });

  MarkAttendanceFormState copyWith({
    int? employeeId,
    String? employeeName,
    String? employeeNumber,
    DateTime? date,
    TimeOfDay? scheduleStartTime,
    int? scheduleDuration,
    AttendanceStatus? status,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    int? overtimeHours,
    String? location,
    String? notes,
    bool? isLoading,
  }) {
    return MarkAttendanceFormState(
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      date: date ?? this.date,
      scheduleStartTime: scheduleStartTime ?? this.scheduleStartTime,
      scheduleDuration: scheduleDuration ?? this.scheduleDuration,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MarkAttendanceFormNotifier extends StateNotifier<MarkAttendanceFormState> {
  MarkAttendanceFormNotifier() : super(const MarkAttendanceFormState());

  void initializeFromAttendance(Attendance attendance) {
    state = MarkAttendanceFormState(
      employeeId: attendance.employeeId,
      employeeName: attendance.employeeName,
      employeeNumber: attendance.employeeNumber,
      date: attendance.date,
      scheduleStartTime: attendance.clockIn != null
          ? TimeOfDay.fromDateTime(attendance.clockIn!)
          : const TimeOfDay(hour: 8, minute: 0),
      scheduleDuration: attendance.workedHours?.toInt() ?? 8,
      status: attendance.status,
      checkInTime: attendance.clockIn != null
          ? TimeOfDay.fromDateTime(attendance.clockIn!)
          : null,
      checkOutTime: attendance.clockOut != null
          ? TimeOfDay.fromDateTime(attendance.clockOut!)
          : null,
      overtimeHours: attendance.workedHours != null && attendance.workedHours! > 8
          ? (attendance.workedHours! - 8).toInt()
          : 0,
      location: attendance.checkInLocation?.city ?? attendance.checkInLocation?.address ?? 'Kuwait City HQ',
      notes: attendance.notes,
    );
  }

  void setEmployee(int? id, String? name, String? number) {
    state = state.copyWith(employeeId: id, employeeName: name, employeeNumber: number);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date);
  }

  void setScheduleStartTime(TimeOfDay? time) {
    state = state.copyWith(scheduleStartTime: time);
  }

  void setScheduleDuration(int? duration) {
    state = state.copyWith(scheduleDuration: duration);
  }

  void setStatus(AttendanceStatus? status) {
    state = state.copyWith(status: status);
  }

  void setCheckInTime(TimeOfDay? time) {
    state = state.copyWith(checkInTime: time);
  }

  void setCheckOutTime(TimeOfDay? time) {
    state = state.copyWith(checkOutTime: time);
  }

  void setOvertimeHours(int? hours) {
    state = state.copyWith(overtimeHours: hours);
  }

  void setLocation(String? location) {
    state = state.copyWith(location: location);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = const MarkAttendanceFormState();
  }
}

final markAttendanceFormProvider = StateNotifierProvider<MarkAttendanceFormNotifier, MarkAttendanceFormState>((ref) {
  return MarkAttendanceFormNotifier();
});

