import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

/// Domain model for Shift
class Shift {
  final int id;
  final String name;
  final String code;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Duration breakDuration;
  final double totalHours;
  final bool isActive;
  final String? description;
  final List<ShiftDay> workingDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Shift({
    required this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.breakDuration,
    required this.totalHours,
    required this.isActive,
    this.description,
    required this.workingDays,
    this.createdAt,
    this.updatedAt,
  });
}

/// Domain model for Shift overview (list item)
class ShiftOverview {
  final int id;
  final String name;
  final String code;
  final String startTime;
  final String endTime;
  final double totalHours;
  final bool isActive;
  final int assignedEmployeesCount;

  const ShiftOverview({
    required this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.totalHours,
    required this.isActive,
    required this.assignedEmployeesCount,
  });
}

/// Shift working days
enum ShiftDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

/// Time of day model
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  String get formatted {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}

/// Paginated shift response
class PaginatedShifts {
  final List<ShiftOverview> shifts;
  final PaginationInfo pagination;

  const PaginatedShifts({required this.shifts, required this.pagination});
}
