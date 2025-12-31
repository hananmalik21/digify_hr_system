import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/time_off_repository.dart';

/// Use case for creating a time-off request
class CreateTimeOffRequestUseCase {
  final TimeOffRepository repository;

  CreateTimeOffRequestUseCase({required this.repository});

  /// Executes the use case to create a time-off request
  ///
  /// [requestData] - Map containing request data
  ///
  /// Returns the created [TimeOffRequest]
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> call(Map<String, dynamic> requestData) async {
    try {
      // Validate required fields
      if (requestData['employee_id'] == null) {
        throw ValidationException('Employee ID is required');
      }
      if (requestData['type'] == null) {
        throw ValidationException('Time-off type is required');
      }
      if (requestData['start_date'] == null) {
        throw ValidationException('Start date is required');
      }
      if (requestData['end_date'] == null) {
        throw ValidationException('End date is required');
      }

      return await repository.createTimeOffRequest(requestData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create time-off request: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
