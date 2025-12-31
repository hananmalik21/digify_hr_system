import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/attendance.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/attendance_repository.dart';

/// Use case for employee check-in
class CheckInUseCase {
  final AttendanceRepository repository;

  CheckInUseCase({required this.repository});

  /// Executes the use case to record check-in
  ///
  /// [employeeId] - Employee ID
  /// [checkInTime] - Optional check-in time (defaults to now)
  /// [notes] - Optional notes
  ///
  /// Returns the created [Attendance] record
  /// Throws [AppException] if the operation fails
  Future<Attendance> call({
    required int employeeId,
    DateTime? checkInTime,
    String? notes,
  }) async {
    try {
      return await repository.checkIn(
        employeeId: employeeId,
        checkInTime: checkInTime,
        notes: notes,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to check in: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
