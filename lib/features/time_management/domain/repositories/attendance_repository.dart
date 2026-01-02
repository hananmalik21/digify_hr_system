import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/attendance.dart';

/// Repository interface for attendance operations
abstract class AttendanceRepository {
  /// Gets paginated list of attendance records
  ///
  /// [employeeId] - Optional filter by employee ID
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [status] - Optional filter by attendance status
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedAttendances> getAttendances({
    int? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets attendance record by ID
  ///
  /// Throws [AppException] if the operation fails
  Future<Attendance> getAttendanceById(int attendanceId);

  /// Records check-in for an employee
  ///
  /// Throws [AppException] if the operation fails
  Future<Attendance> checkIn({
    required int employeeId,
    DateTime? checkInTime,
    String? notes,
  });

  /// Records check-out for an employee
  ///
  /// Throws [AppException] if the operation fails
  Future<Attendance> checkOut({
    required int attendanceId,
    DateTime? checkOutTime,
    String? notes,
  });

  /// Creates or updates attendance record manually (admin)
  ///
  /// Throws [AppException] if the operation fails
  Future<Attendance> createOrUpdateAttendance(
    Map<String, dynamic> attendanceData,
  );

  /// Deletes an attendance record
  ///
  /// [hard] - If true, permanently deletes. If false, soft deletes.
  /// Throws [AppException] if the operation fails
  Future<void> deleteAttendance(int attendanceId, {bool hard = true});

  /// Gets today's attendance for an employee
  ///
  /// Throws [AppException] if the operation fails
  Future<Attendance?> getTodayAttendance(int employeeId);
}
