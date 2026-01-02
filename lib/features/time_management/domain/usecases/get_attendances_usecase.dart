import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/attendance.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/attendance_repository.dart';

/// Use case for getting attendance records
class GetAttendancesUseCase {
  final AttendanceRepository repository;

  GetAttendancesUseCase({required this.repository});

  /// Executes the use case to get attendance records
  ///
  /// [employeeId] - Optional filter by employee ID
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [status] - Optional filter by attendance status
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Returns a [PaginatedAttendances] with the list of attendances and pagination info
  /// Throws [AppException] if the operation fails
  Future<PaginatedAttendances> call({
    int? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getAttendances(
        employeeId: employeeId,
        startDate: startDate,
        endDate: endDate,
        status: status,
        search: search,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get attendances: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
