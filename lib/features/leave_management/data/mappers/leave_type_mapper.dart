import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';

/// Maps TimeOffType enum to short display labels
class LeaveTypeMapper {
  static String getShortLabel(TimeOffType type) {
    switch (type) {
      case TimeOffType.annualLeave:
        return 'Annual';
      case TimeOffType.sickLeave:
        return 'Sick';
      case TimeOffType.personalLeave:
        return 'Emergency';
      case TimeOffType.emergencyLeave:
        return 'Emergency';
      case TimeOffType.unpaidLeave:
        return 'Unpaid';
      case TimeOffType.other:
        return 'Other';
    }
  }
}
