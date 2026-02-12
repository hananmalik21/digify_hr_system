import 'package:digify_hr_system/features/attendance/domain/models/attendance.dart';
import 'package:digify_hr_system/features/attendance/domain/repositories/attendance_repository.dart';

/// Mock implementation of AttendanceRepository
/// TODO: Replace with real implementation when API is ready
class AttendanceRepositoryImpl implements AttendanceRepository {
  @override
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? employeeNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data matching Figma design
    final mockAttendances = [
      Attendance(
        id: 1,
        employeeId: 1,
        employeeName: 'Ahmed Al-Mutairi',
        employeeNumber: 'EMP-001',
        departmentName: 'IT',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 8, 5),
        clockOut: DateTime(2026, 2, 2, 17, 10),
        status: AttendanceStatus.present,
        workedHours: 9.08,
        checkInLocation: AttendanceLocation(
          latitude: 29.375900,
          longitude: 47.977400,
          address: 'Kuwait City HQ - Main Entrance',
          city: 'Kuwait City',
          country: 'Kuwait',
        ),
        checkOutLocation: AttendanceLocation(
          latitude: 29.376100,
          longitude: 47.977600,
          address: 'Kuwait City HQ - Parking Exit',
          city: 'Kuwait City',
          country: 'Kuwait',
        ),
        notes: 'Regular day with 1 hour overtime',
      ),
      Attendance(
        id: 2,
        employeeId: 2,
        employeeName: 'Fatima Al-Sabah',
        employeeNumber: 'EMP-002',
        departmentName: 'HR',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 8, 30),
        clockOut: DateTime(2026, 2, 2, 16, 45),
        status: AttendanceStatus.late,
        workedHours: 8.25,
      ),
      Attendance(
        id: 3,
        employeeId: 3,
        employeeName: 'Mohammed Al-Rashid',
        employeeNumber: 'EMP-003',
        departmentName: 'Finance',
        date: DateTime(2026, 2, 2),
        clockIn: null,
        clockOut: null,
        status: AttendanceStatus.absent,
      ),
      Attendance(
        id: 4,
        employeeId: 4,
        employeeName: 'Sara Al-Kandari',
        employeeNumber: 'EMP-004',
        departmentName: 'IT',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 7, 55),
        clockOut: DateTime(2026, 2, 2, 15, 30),
        status: AttendanceStatus.early,
        workedHours: 7.58,
      ),
      Attendance(
        id: 5,
        employeeId: 5,
        employeeName: 'Ali Al-Ajmi',
        employeeNumber: 'EMP-005',
        departmentName: 'Operations',
        date: DateTime(2026, 2, 2),
        clockIn: null,
        clockOut: null,
        status: AttendanceStatus.onLeave,
      ),
      Attendance(
        id: 6,
        employeeId: 6,
        employeeName: 'Noor Al-Shammari',
        employeeNumber: 'EMP-006',
        departmentName: 'Sales',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 9, 0),
        clockOut: DateTime(2026, 2, 2, 17, 0),
        status: AttendanceStatus.officialWork,
        workedHours: 8.0,
      ),
      Attendance(
        id: 7,
        employeeId: 7,
        employeeName: 'Khaled Al-Ibrahim',
        employeeNumber: 'EMP-007',
        departmentName: 'IT',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 6, 0),
        clockOut: DateTime(2026, 2, 2, 14, 0),
        status: AttendanceStatus.businessTrip,
        workedHours: 8.0,
      ),
      Attendance(
        id: 8,
        employeeId: 8,
        employeeName: 'Yousef Al-Mutawa',
        employeeNumber: 'EMP-008',
        departmentName: 'Security',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 22, 10),
        clockOut: DateTime(2026, 2, 3, 6, 5),
        status: AttendanceStatus.present,
        workedHours: 7.92,
      ),
      Attendance(
        id: 9,
        employeeId: 9,
        employeeName: 'Layla Al-Fahad',
        employeeNumber: 'EMP-009',
        departmentName: 'Operations',
        date: DateTime(2026, 2, 2),
        clockIn: DateTime(2026, 2, 2, 22, 55),
        clockOut: DateTime(2026, 2, 3, 7, 10),
        status: AttendanceStatus.present,
        workedHours: 8.25,
      ),
    ];

    // Filter by date range (compare only date part, ignore time)
    final fromDateOnly = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final toDateOnly = DateTime(toDate.year, toDate.month, toDate.day);
    
    var filtered = mockAttendances.where((a) {
      final attendanceDateOnly = DateTime(a.date.year, a.date.month, a.date.day);
      // Check if attendance date is within the range (inclusive)
      return (attendanceDateOnly.isAtSameMomentAs(fromDateOnly) || attendanceDateOnly.isAfter(fromDateOnly)) &&
             (attendanceDateOnly.isAtSameMomentAs(toDateOnly) || attendanceDateOnly.isBefore(toDateOnly));
    }).toList();

    // Filter by employee number if provided
    if (employeeNumber != null && employeeNumber.isNotEmpty) {
      filtered = filtered
          .where((a) => a.employeeNumber.toLowerCase().contains(employeeNumber.toLowerCase()))
          .toList();
    }

    return filtered;
  }
}

