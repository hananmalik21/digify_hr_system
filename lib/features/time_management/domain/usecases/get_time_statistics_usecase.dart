import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_statistics.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/time_statistics_repository.dart';

/// Use case for getting time statistics
class GetTimeStatisticsUseCase {
  final TimeStatisticsRepository repository;

  GetTimeStatisticsUseCase({required this.repository});

  /// Executes the use case to get time statistics
  ///
  /// [startDate] - Optional start date for statistics
  /// [endDate] - Optional end date for statistics
  ///
  /// Returns [TimeStatistics] with dashboard statistics
  /// Throws [AppException] if the operation fails
  Future<TimeStatistics> call({DateTime? startDate, DateTime? endDate}) async {
    try {
      return await repository.getTimeStatistics(
        startDate: startDate,
        endDate: endDate,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get time statistics: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
