import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/overtime.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';

/// Repository interface for overtime operations
abstract class OvertimeRepository {
  /// Gets paginated list of overtime requests/records
  ///
  /// [employeeId] - Optional filter by employee ID
  /// [status] - Optional filter by status
  /// [type] - Optional filter by overtime type
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedOvertimes> getOvertimes({
    int? employeeId,
    RequestStatus? status,
    OvertimeType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets overtime record by ID
  ///
  /// Throws [AppException] if the operation fails
  Future<Overtime> getOvertimeById(int overtimeId);

  /// Creates a new overtime request
  ///
  /// Throws [AppException] if the operation fails
  Future<Overtime> createOvertime(Map<String, dynamic> overtimeData);

  /// Updates an existing overtime request
  ///
  /// Throws [AppException] if the operation fails
  Future<Overtime> updateOvertime(
    int overtimeId,
    Map<String, dynamic> overtimeData,
  );

  /// Approves an overtime request
  ///
  /// Throws [AppException] if the operation fails
  Future<Overtime> approveOvertime(int overtimeId);

  /// Rejects an overtime request
  ///
  /// Throws [AppException] if the operation fails
  Future<Overtime> rejectOvertime(int overtimeId, {required String reason});

  /// Deletes an overtime record
  ///
  /// [hard] - If true, permanently deletes. If false, soft deletes.
  /// Throws [AppException] if the operation fails
  Future<void> deleteOvertime(int overtimeId, {bool hard = true});
}

