import '../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../domain/repositories/attendance_summary_repository.dart';

class AttendanceSummaryRepositoryImpl implements AttendanceSummaryRepository {
  @override
  Future<List<AttendanceSummaryRecord>> getAttendanceSummaryRecords({
    required String companyId,
    String? department,
    String? date,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    return [
      AttendanceSummaryRecord(
        employeeName: 'John Doe',
        date: '2023-10-25',
        checkIn: '09:00 AM',
        checkOut: '06:00 PM',
        hours: '9h 0m',
        overtime: '1h 0m',
        status: 'Present',
      ),
      AttendanceSummaryRecord(
        employeeName: 'Jane Smith',
        date: '2023-10-25',
        checkIn: '08:45 AM',
        checkOut: '05:30 PM',
        hours: '8h 45m',
        overtime: '0h 45m',
        status: 'Present',
      ),
      AttendanceSummaryRecord(
        employeeName: 'Alice Johnson',
        date: '2023-10-25',
        checkIn: '--:--',
        checkOut: '--:--',
        hours: '0h 0m',
        overtime: '0h 0m',
        status: 'Absent',
      ),
      AttendanceSummaryRecord(
        employeeName: 'Bob Brown',
        date: '2023-10-25',
        checkIn: '09:15 AM',
        checkOut: '06:30 PM',
        hours: '9h 15m',
        overtime: '1h 15m',
        status: 'Late In',
      ),
      AttendanceSummaryRecord(
        employeeName: 'Charlie Davis',
        date: '2023-10-25',
        checkIn: '09:00 AM',
        checkOut: '04:00 PM',
        hours: '7h 0m',
        overtime: '0h 0m',
        status: 'Early Out',
      ),
    ];
  }
}
