import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_statistics.dart';

/// Repository interface for time statistics operations
abstract class TimeStatisticsRepository {
  /// Gets time statistics for dashboard
  ///
  /// [startDate] - Optional start date for statistics
  /// [endDate] - Optional end date for statistics
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeStatistics> getTimeStatistics({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Gets attendance statistics for a date range
  ///
  /// Throws [AppException] if the operation fails
  Future<List<DailyAttendanceStats>> getDailyAttendanceStats({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Gets department time statistics
  ///
  /// Throws [AppException] if the operation fails
  Future<List<DepartmentTimeStats>> getDepartmentTimeStats({DateTime? date});
}
