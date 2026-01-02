import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/attendance.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/attendance_repository.dart';

/// Use case for employee check-out
class CheckOutUseCase {
  final AttendanceRepository repository;

  CheckOutUseCase({required this.repository});

  /// Executes the use case to record check-out
  ///
  /// [attendanceId] - Attendance record ID
  /// [checkOutTime] - Optional check-out time (defaults to now)
  /// [notes] - Optional notes
  ///
  /// Returns the updated [Attendance] record
  /// Throws [AppException] if the operation fails
  Future<Attendance> call({
    required int attendanceId,
    DateTime? checkOutTime,
    String? notes,
  }) async {
    try {
      return await repository.checkOut(
        attendanceId: attendanceId,
        checkOutTime: checkOutTime,
        notes: notes,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to check out: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
