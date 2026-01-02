enum TimeManagementTab {
  shifts,
  workPatterns,
  workSchedules,
  scheduleAssignments,
  viewCalendar,
  publicHolidays,
}

enum ShiftType {
  day,
  morning,
  evening,
  night;

  static ShiftType fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'DAY':
        return ShiftType.day;
      case 'MORNING':
        return ShiftType.morning;
      case 'EVENING':
        return ShiftType.evening;
      case 'NIGHT':
        return ShiftType.night;
      default:
        return ShiftType.day;
    }
  }

  String get displayName {
    switch (this) {
      case ShiftType.day:
        return 'Day';
      case ShiftType.morning:
        return 'Morning';
      case ShiftType.evening:
        return 'Evening';
      case ShiftType.night:
        return 'Night';
    }
  }
}

enum ShiftStatus {
  active,
  inactive;

  static ShiftStatus fromString(String value) {
    final normalized = value.toUpperCase().trim();
    switch (normalized) {
      case 'ACTIVE':
        return ShiftStatus.active;
      case 'INACTIVE':
        return ShiftStatus.inactive;
      default:
        return ShiftStatus.inactive;
    }
  }

  String get displayName {
    switch (this) {
      case ShiftStatus.active:
        return 'ACTIVE';
      case ShiftStatus.inactive:
        return 'INACTIVE';
    }
  }

  bool get isActive => this == ShiftStatus.active;
}
