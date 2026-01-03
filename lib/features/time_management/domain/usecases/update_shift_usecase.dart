import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/shift_repository.dart';

class UpdateShiftUseCase {
  final ShiftRepository repository;

  UpdateShiftUseCase({required this.repository});

  Future<ShiftOverview> call({required int shiftId, required Map<String, dynamic> shiftData}) async {
    try {
      return await repository.updateShift(shiftId: shiftId, shiftData: shiftData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update shift: ${e.toString()}', originalError: e);
    }
  }
}
